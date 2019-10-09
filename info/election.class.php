<?php

/**
 * This file defines the interface for admin UI for OpenElection
 *
 * PHP Version 7.2
 *
 * @category   Election
 * @package    OpenElection
 * @subpackage SimpleElectionObj
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
 *
 * @Entity
 * @Table(name="election")
 */
class Election
{
    /**
     * Unique identifier of Election
     *
     * @var integer
     *
     * @Id
     * @Column(type="integer", unique=true)
     * @GeneratedValue
     */
    protected $id;

    /**
     * Name of Election
     *
     * @var string
     *
     * @Column(type="string", length=255)
     */
    protected $name;

    /**
     * HTML Description of Election
     *
     * @var string
     *
     * @Column(type="text")
     */
    protected $description;

    /**
     * The current status of the election
     * * _pending_
     * * _nominating_
     * * _campaigning_
     * * _voting_
     * * _counting_
     * * _results_
     * * _archived_
     *
     * @var ElectionStatus
     *
     * @ManyToOne(targetEntity="ElectionStatus")
     * @JoinColumn(name="status",referencedColumnName="id")
     */
    protected $status;

    /**
     * The rules applied to the election
     *
     * @var ElectionRules
     *
     * @ManyToOne(targetEntity="ElectionRules")
     * @JoinColumn(name="rules",referencedColumnName="id")
     */
    protected $rules;

    /**
     * The Date when voting starts
     *
     * __NOTE:__All other dates for this election are set relative
     * to this date and set by the election's rules
     *
     * @var ElectionRules
     *
     * @Column(type="datetime")
     */
    protected $votingStartDate;

    /**
     * The person who is legally responsible for the election
     *
     * @ManyToOne(targetEntity="ElectionOfficial")
     * @JoinColumn(name="returningOfficer",referencedColumnName="id")
     *
     * @var ElectionOfficial
     */
    protected $returningOfficer;

    /**
     * The person to talk to if you have an issue with the election
     *
     * @ManyToOne(targetEntity="ElectionOfficial")
     * @JoinColumn(name="contactOfficer",referencedColumnName="id")
     *
     * @var ElectionOfficial
     */
    protected $contactOfficer = null;

    /**
     * Whether the election is a Referendum
     * i.e. the options being selected/ranked are concept based, not
     * choices between people
     *
     * @column(type="boolean")
     *
     * @var boolean
     */
    protected $isReferendum = false;

    /**
     * Whether the election was created
     *
     * @column(type="datetime")
     *
     * @var integer
     */
    protected $created;

    /**
     * Whether the election was last updated
     *
     * @column(type="datetime")
     *
     * @var integer
     */
    protected $updated;

    /**
     * Whether the election was created
     *
     * @ManyToOne(targetEntity="Admin")
     * @JoinColumn(name="createdBy",referencedColumnName="id")
     *
     * @var inteAdminger
     */
    protected $createdBy;

    /**
     * Whether the election was last updated
     *
     * @ManyToOne(targetEntity="Admin")
     * @JoinColumn(name="updatedby",referencedColumnName="id")
     *
     * @var Admin
     */
    protected $updatedBy;


    // ==========================================

    /**
     * Get the Unique ID for this Election
     *
     * @return integer
     */
    public function getID() : int
    {
        return 0;
    }

    /**
     * Get the name of the eleciton
     *
     * @return string
     */
    public function getName() : string
    {
        return '';
    }

    /**
     * Get the HTML description of the election/referendum
     *
     * @return string
     */
    public function getDescription() : string
    {
        return '';
    }

    /**
     * Get the current status of the Election
     * * _pending_
     * * _nominating_
     * * _campaigning_
     * * _voting_
     * * _counting_
     * * _results_
     * * _archived_
     *
     * @return string
     */
    public function getStatus() : string
    {
        return '';
    }

    /**
     * Undocumented function
     *
     * @return integer
     */
    public function getStatusID() : int
    {
        return 0;
    }
    public function getRules() : ElectionRule;
    public function getRulePart(string $part) : mixed;
    public function getDate(string $eventName) : int;
    public function getAllDates(string $filter) : array;
    public function getIsReferendum() : bool;
    public function getIsClosedComplete() : bool;
    public function getIsNominating() : bool;
    public function getIsCampaigning() : bool;
    public function getIsVoting() : bool;
    public function getIsCounted() : bool;
    public function getReturningOfficer() : ElectionOfficial;
    public function getContact() : ElectionOfficial;

    public function getChoices() : array
    {
        return array();
    }
    public function getChoiceCount() : array
    {
        return 0;
    }
    public function getVoterCount() : array
    {
        return 0;
    }
    public function getVoters(int $page = 1, int $count = 50) : array
    {
        return array();
    }
    public function getAdmins() : array
    {
        return array();
    }
}
