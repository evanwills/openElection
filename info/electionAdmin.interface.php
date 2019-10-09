<?php

/**
 * This file defines the interface for admin UI for OpenElection
 *
 * PHP Version 7.2
 *
 * @category   Election
 * @package    OpenElection
 * @subpackage Administration
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
 * @subpackage Administration
 * @author     Evan Wills <evan.i.wills@gmail.com>
 * @license    GPL2 https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
 * @link       https://github.com/evanwills/openelection
 */
interface IOpenElectionAdmin
{
    /**
     * List elections to be displayed to user.
     *
     * @param integer $status Status of elections to be listed
     *                        * 0 = all
     *                        * 1 = pending (no cohort set)
     *                        * 2 = nominating
     *                        (accepting candidate nominations)
     *                        * 3 = campaigning
     *                        (candidates fixed, not yet voting)
     *                        * 4 = voting
     *                        * 5 = results (count complete)
     *                        * 6 = archived
     * @param integer $start  Where to start the pagination list
     * @param integer $count  How many elections to list on each page
     *
     * @return array where the key is the election ID (int) & value
     *               is the election name (stirng)
     */
    public function listElections(
        int $status = 0,
        int $start = 0,
        int $count = 30
    ) : array;

    /**
     * List elections to be displayed to user.
     *
     * @param string  $namePart part of the name of an election
     * @param integer $status   Status of elections to be listed
     * @param integer $count    How many matched elections return
     *
     * @return array where the key is the election ID (int) & value
     *               is the election name (stirng)
     */
    public function quickElectionSearch(
        string $namePart,
        int $status = 0,
        int $count = 30
    ) : array;

    /**
     * Get all the info about a chosen election
     *
     * @param integer $electionID the ID of the election
     *
     * @return array An associative array with the following keys:
     *               * __id:__   [int] Election ID (as supplied in call)
     *               * __name:__ [str] Full name of the election
     *               * __description:__ [str] HTML description/info about
     *               Election
     *               * __rule:__ [array] ruleID => int, ruleName => string
     *               * __votingStartDate:__ [str] date-time for when
     *               voting starts
     *               * __emails:__ [array]
     *               emailID => int, type => int, subject => string
     *               * __returningOfficer:__ [array]
     *               staffID => string, fullName => string,
     *               title => string, email => string
     *               * __closedComplete:__ [bool] Is the election closed
     *               and complete (i.e. can/should it be archived)
     *               * __isReferendum:__ [bool] is this a "Referendum"
     *               (i.e. no candidates)
     *               * __created:__ [str] date/time when the election
     *               was created
     *               * __updated:__ [str] date/time when the election
     *               was last updated
     *               * __createdBy:__ [int] adminID who created the
     *               election
     *               * __updatedBy:__ [int] adminID who last updated
     *               the election
     */
    public function getElection(int $electionID) : array;

    /**
     * Create a new election
     *
     * @param string  $name             Name of the new election
     * @param string  $description      HTML description of election
     * @param integer $ruleID           ID of the election ruleset to
     *                                  be used
     * @param string  $votingStartDate  Date/time voting is to begin
     * @param string  $returningOfficer Identifier for person named
     *                                  as returning officer
     * @param boolean $isReferendum     Whether or not this election
     *                                  is a referendum
     *
     * @return integer Election ID for newly created Election
     *                 (0 if election creation failed)
     */
    public function createElection(
        string $name,
        string $description,
        int $ruleID,
        string $votingStartDate,
        string $returningOfficer,
        bool $isReferendum = false
    ) : int;
}
