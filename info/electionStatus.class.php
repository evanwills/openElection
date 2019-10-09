<?php

/**
 * This file defines the Election Status enum/normalised table
 *
 * PHP Version 7.2
 *
 * @category   Election
 * @package    OpenElection
 * @subpackage ElectionStatus
 * @author     Evan Wills <evan.i.wills@gmail.com>
 * @license    GPL2 https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
 * @link       https://github.com/evanwills/openElection
 */

declare(strict_types=1);

/**
 * This file defines the interface for admin UI for OpenElection
 *
 * @category   Election
 * @package    OpenElection
 * @subpackage ElectionStatus
 * @author     Evan Wills <evan.i.wills@gmail.com>
 * @license    GPL2 https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
 * @link       https://github.com/evanwills/openelection
 *
 * @Entity
 * @Table(name="election")
 */
class ElectionStatus
{
    /**
     * Unique identifier of Election
     *
     * @Id
     * @Column(type="smallint", unique=true)
     * @GeneratedValue
     *
     * @var integer
     */
    protected $id;

    /**
     * Name of election status
     * * _pending_
     * * _nominating_
     * * _campaigning_
     * * _voting_
     * * _counting_
     * * _results_
     * * _archived_
     *
     * @Column(type="string", length=16, unique=true)
     *
     * @var string
     */
    protected $name;
}
