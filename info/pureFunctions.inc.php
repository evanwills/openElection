<?php

/**
 * This file contains a collection of "Pure" functions for doing various generic
 * Things related to Elections
 *
 * PHP Version 7.2
 *
 * @category   Election
 * @package    OpenElection
 * @subpackage OpenElectionPureFunctions
 * @author     Evan Wills <evan.i.wills@gmail.com>
 * @license    GPL2 https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
 * @link       https://github.com/evanwills/openElection
 */

declare(strict_types=1);

/**
 * Strips unwanted elements, converts depricated elements and removes
 * all attributes from HTML element tags.
 *
 * @param array $matches array of strings matched by the regex:
 *                       `(</?)([^\s>]+)(\s+[^>]+?)?(?:\s*(/?>)`is
 *
 * @return string
 */
function sanitiseHTMLattributes(array $matches) : string {
    $allowed = array(
        'p', 'br', 'hr',
        'ul', 'ol', 'li', 'dl', 'dd',
        'strong', 'em', 'sup', 'sub', 'q'
    );
    $depricatedFind = array('i', 'b', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6');
    $depricatedReplace = array('em', 'strong', 'p', 'p', 'p', 'p', 'p', 'p');

    $element = strtolower($matches[2]);

    $replaceable = array_search($element, $depricatedFind);
    $output = '';
    if ($element === 'abbr') {
        $attr = preg_replace('`^.*?\s(title="[^"]+")?.*$', '\1', $matches[3]);
        if ($attr !== '') {
            $output = $element.' '.$attr;
        }
    } elseif ($replaceable > -1) {
        $output = $depricatedReplace($replaceable);
    } elseif (in_array($element, $allowed)) {
        $output = $element;
    }

    return ($output !== '') ? $matches[1].$element.$matches[4].$matches[5] : '';
}

/**
 * Make user supplied HTML safe for us in public web pages.
 *
 * @param string $HTML Content to be sanitised
 *
 * @return string Sanitised HTML content
 */
function sanitiseHTML(string $HTML) : string
{
    $regex = '`'.
             '<!--.*?-->|'.
             '<input[^>]+?/?>|'.
             '<(button|label|textarea|select|script|style).*?</\1[^>]*>|'.
             ''.
             '`is';

    $output = preg_replace($regex, '', $HTML);

    $output = preg_replace_callback(
        '`(</?)([^\s>]+)(\s+[^>]+?)?(?:\s*(/?))(>)`is',
        'sanitiseHTMLattributes',
        $output
    );

    $tmp = '';
    while ($tmp !== $output) {
        $tmp = $output;
        // recursively strip empty tags.
        $output = preg_replace(
            '`<([^\s>]+)[^>]*>\s*</\1>`is',
            '',
            $output
        );
    }
    return trim($output);
}
