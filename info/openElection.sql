-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 22, 2019 at 06:58 AM
-- Server version: 10.3.18-MariaDB-1
-- PHP Version: 7.3.9-1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `openPoll`
--

-- --------------------------------------------------------
DROP TABLE IF EXISTS `logPoll`;
DROP TABLE IF EXISTS `logChanges`;
DROP TABLE IF EXISTS `joinRuleAdmin`;
DROP TABLE IF EXISTS `joinEmailVoter`;
DROP TABLE IF EXISTS `joinPollAdmin`;
DROP TABLE IF EXISTS `joinPollCohortFilter`;
DROP TABLE IF EXISTS `resultsCache`;
DROP TABLE IF EXISTS `ballotBox`;
DROP TABLE IF EXISTS `candidate`;
DROP TABLE IF EXISTS `party`;
DROP TABLE IF EXISTS `electorate`;
DROP TABLE IF EXISTS `email`;
DROP TABLE IF EXISTS `poll`;
DROP TABLE IF EXISTS `rules`;
DROP TABLE IF EXISTS `countMethod`;
DROP TABLE IF EXISTS `cohortFilter`;
DROP TABLE IF EXISTS `admin`;
DROP TABLE IF EXISTS `cohortSources`;
-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `adminID` smallint(5) UNSIGNED NOT NULL,
  `adminUserID` varchar(128) NOT NULL,
  `adminCohortSourceID` smallint(5) UNSIGNED NOT NULL,
  `adminLevel` enum('basic','official','poll','rule','super','root') NOT NULL DEFAULT 'basic',
  `adminCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `adminCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `adminUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `adminUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ballotBox`
--

CREATE TABLE `ballotBox` (
  `ballotPollID` int(10) UNSIGNED NOT NULL,
  `ballotID` char(40) NOT NULL,
  `ballotPaper` text NOT NULL,
  `ballotChecksum` char(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `candidate`
--

CREATE TABLE `candidate` (
  `candidateID` smallint(5) UNSIGNED NOT NULL,
  `candidatePollID` int(10) UNSIGNED NOT NULL,
  `candidateVoterID` int(10) UNSIGNED NOT NULL,
  `candidateCampaignURL` text NOT NULL,
  `candidateStatement` text NOT NULL,
  `candidatePhotoURL` text NOT NULL,
  `candidateEndorsedByPartyID` smallint(5) UNSIGNED NOT NULL,
  `candidateEndorsementStatus` enum('rejected','none','requested','varified') NOT NULL DEFAULT 'none',
  `candidateCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `candidateUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `candidateUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cohortFilter`
--

CREATE TABLE `cohortFilter` (
  `cohortFilterID` smallint(5) UNSIGNED NOT NULL,
  `cohortFilterName` varchar(128) NOT NULL,
  `cohortFilterEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `cohortFilterSourceID` smallint(5) UNSIGNED NOT NULL,
  `cohortFilterPerameters` text NOT NULL,
  `cohortFIlterCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `cohortFilterCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `cohortFilterUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `cohortFilterUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `cohortDescription` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cohortSources`
--

CREATE TABLE `cohortSources` (
  `cohortSourceID` smallint(5) UNSIGNED NOT NULL,
  `cohortSourceName` varchar(64) NOT NULL,
  `cohortSourceDescription` varchar(255) NOT NULL,
  `cohortSourceEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `cohortSourceAvailableParams` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `countMethod`
--

CREATE TABLE `countMethod` (
  `countMethodID` smallint(5) UNSIGNED NOT NULL,
  `countMethodName` varchar(64) NOT NULL,
  `countMethodDescription` text NOT NULL,
  `countMethodInfoURL` text NOT NULL,
  `countMethodOptionsDefaults` text NOT NULL,
  `countMethodEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `countMethodCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `countMethodCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `countMethodUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `countMethodUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `poll`
--

CREATE TABLE `poll` (
  `pollID` int(10) UNSIGNED NOT NULL,
  `pollName` varchar(128) NOT NULL COMMENT 'Title of the poll',
  `pollYear` smallint(5) UNSIGNED NOT NULL COMMENT 'parent path in URL',
  `pollURL` varchar(32) NOT NULL COMMENT 'URL path for accessing the poll',
  `pollDescription` text NOT NULL,
  `pollStatus` enum('pending','accepting nominations','campaigning','voting','counting','results','archived') NOT NULL,
  `pollCohortFilterID` smallint(5) UNSIGNED NOT NULL,
  `pollRuleID` smallint(5) UNSIGNED NOT NULL,
  `pollDateVotingStart` datetime NOT NULL,
  `pollDateVotingClose` datetime DEFAULT NULL,
  `pollDateArchive` datetime DEFAULT NULL,
  `pollDateNominationsOpen` datetime DEFAULT NULL,
  `pollDateNominationsClose` datetime DEFAULT NULL,
  `pollReturningOfficerID` int(10) UNSIGNED NOT NULL,
  `pollContactOfficerID` int(10) UNSIGNED NOT NULL,
  `pollIsPublic` tinyint(1) NOT NULL DEFAULT 1,
  `pollIsReferendum` tinyint(1) NOT NULL DEFAULT 0,
  `pollCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `pollCreatedBy` smallint(5) UNSIGNED NOT NULL,
  `pollUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `pollUpdatedByID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `electorate`
--

CREATE TABLE `electorate` (
  `voterID` int(10) UNSIGNED NOT NULL,
  `voterPollID` int(10) UNSIGNED NOT NULL,
  `voterUserID` varchar(128) NOT NULL,
  `voterCohortSourceID` smallint(5) UNSIGNED NOT NULL,
  `voterFullName` varchar(128) NOT NULL,
  `voterEmail` varchar(255) NOT NULL,
  `voterStatus` enum('forbidden','allowed','voted') NOT NULL DEFAULT 'allowed',
  `voterCandidateStatus` enum('disqualified','cannot stand','eligible','is standing','elected') NOT NULL,
  `voterBallotPaperCheckSum` char(40) NOT NULL,
  `voterCreated` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `email`
--

CREATE TABLE `email` (
  `emailID` int(10) UNSIGNED NOT NULL,
  `emailPollID` int(10) UNSIGNED NOT NULL,
  `emailType` enum('call for nominations','nominations open','nominations remider','nominations closed','voting open','voting reminder','voting closed','results') NOT NULL,
  `emailIsTemplate` tinyint(1) NOT NULL DEFAULT 0,
  `emailSubject` varchar(255) NOT NULL,
  `emailFromReturningOfficer` tinyint(1) NOT NULL DEFAULT 1,
  `emailReplyTo` varchar(255) DEFAULT NULL,
  `emailBody` text NOT NULL,
  `emailStartSend` datetime NOT NULL DEFAULT current_timestamp(),
  `emailSendEnd` datetime DEFAULT NULL,
  `emailSendCount` int(10) UNSIGNED NOT NULL,
  `emailCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `emailCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `emailUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `emailUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `joinPollAdmin`
--

CREATE TABLE `joinPollAdmin` (
  `joinPollAdminPollID` int(10) UNSIGNED NOT NULL,
  `joinPollAdminAdminID` smallint(5) UNSIGNED NOT NULL,
  `joinPollAdminEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `joinPollAdminCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `joinPollAdminCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `joinPollAdminUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `joinPollAdminUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `joinPollCohortFilter`
--

CREATE TABLE `joinPollCohortFilter` (
  `joinPollCohortFilterPollID` int(10) UNSIGNED NOT NULL,
  `joinPollCohortFilterCohortFilterID` smallint(5) UNSIGNED NOT NULL,
  `joinPollCohortFilterCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `joinPollCohortFilterCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `joinPollCohortFilterUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `joinPollCohortFilterUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `joinEmailVoter`
--

CREATE TABLE `joinEmailVoter` (
  `joinEmailVoterVoterID` int(10) UNSIGNED NOT NULL,
  `joinEmailVoterEmailID` int(10) UNSIGNED NOT NULL,
  `joinEmailVoterSendTime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `joinRuleAdmin`
--

CREATE TABLE `joinRuleAdmin` (
  `joinRuleAdminRuleID` smallint(5) UNSIGNED NOT NULL,
  `joinRuleAdminAdminID` smallint(5) UNSIGNED NOT NULL,
  `joinRuleAdminEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `joinRuleAdminCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `joinRuleAdminCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `joinRuleAdminUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `joinRuleAdminUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logChanges`
--

CREATE TABLE `logChanges` (
  `changeTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changeByAdminID` smallint(5) UNSIGNED NOT NULL,
  `changeAction` enum('insert','update','delete') NOT NULL,
  `changeUpdatedTable` varchar(32) NOT NULL,
  `changeDiff` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logPoll`
--

CREATE TABLE `logPoll` (
  `logID` int(10) UNSIGNED NOT NULL,
  `logTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `logPollID` int(10) UNSIGNED NOT NULL,
  `logType` enum('message','notice','warning','error') NOT NULL,
  `logTypeSub` enum('import','email','authentication','nomination','vote','validation','count') NOT NULL,
  `logCode` smallint(5) UNSIGNED NOT NULL,
  `logMessage` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `party`
--

CREATE TABLE `party` (
  `partyID` smallint(5) UNSIGNED NOT NULL,
  `partyName` varchar(32) NOT NULL,
  `partyURL` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `results`
--

CREATE TABLE `results` (
  `resultID` int(10) UNSIGNED NOT NULL,
  `resultsPollID` int(10) UNSIGNED NOT NULL,
  `resultsTotalVoters` int(10) UNSIGNED NOT NULL,
  `resultsTotalVotesCast` int(10) UNSIGNED NOT NULL,
  `resultsCounted` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resultsSuperseedsResultID` int(10) UNSIGNED NOT NULL,
  `resultsWinners` text NOT NULL,
  `resultsDetails` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `rules`
--

CREATE TABLE `rules` (
  `ruleID` smallint(5) UNSIGNED NOT NULL,
  `ruleName` varchar(128) NOT NULL,
  `ruleDescription` text NOT NULL,
  `ruleCountMethodID` smallint(5) UNSIGNED NOT NULL,
  `ruleCountMethodOptions` text NOT NULL,
  `ruleEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `rulePeriodNomination` smallint(5) UNSIGNED NOT NULL DEFAULT 7,
  `rulePeriodCampaign` smallint(5) UNSIGNED NOT NULL DEFAULT 14,
  `rulePeriodVoting` smallint(5) UNSIGNED NOT NULL DEFAULT 14,
  `rulePeriodResults` smallint(5) UNSIGNED NOT NULL DEFAULT 28,
  `ruleWinnerCount` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `ruleNominatorCount` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `ruleBallotVerificationAllowed` tinyint(1) NOT NULL DEFAULT 0,
  `ruleUpdateElectorateBeforeOpening` tinyint(1) NOT NULL DEFAULT 0,
  `ruleCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `ruleCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `ruleUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `ruleUpdateByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`adminID`),
  ADD UNIQUE KEY `U_adminUserID` (`adminUserID`,`adminCohortSourceID`) USING BTREE,
  ADD KEY `I_adminLevel` (`adminLevel`),
  ADD KEY `I_adminCreatedByAdminID` (`adminCreatedByAdminID`),
  ADD KEY `I_adminUpdatedByAdminID` (`adminUpdatedByAdminID`),
  ADD KEY `I_adminCohortSourceID` (`adminCohortSourceID`);

--
-- Indexes for table `ballotBox`
--
ALTER TABLE `ballotBox`
  ADD UNIQUE KEY `U_ballotID` (`ballotID`),
  ADD KEY `I_ballotPollID` (`ballotPollID`);

--
-- Indexes for table `candidate`
--
ALTER TABLE `candidate`
  ADD PRIMARY KEY (`candidateID`),
  ADD UNIQUE KEY `candidateID` (`candidateID`,`candidatePollID`),
  ADD KEY `I_candidatevoterPollID` (`candidatePollID`),
  ADD KEY `I_candidateVoterID` (`candidateVoterID`),
  ADD KEY `I_candidateEndorsedByPartyID` (`candidateEndorsedByPartyID`),
  ADD KEY `I_candidateEndorsementStatus` (`candidateEndorsementStatus`),
  ADD KEY `I_candidateUpdatedByAdminID` (`candidateUpdatedByAdminID`),
  ADD KEY `I_pollParty` (`candidatePollID`,`candidateEndorsedByPartyID`,`candidateEndorsementStatus`);

--
-- Indexes for table `cohortFilter`
--
ALTER TABLE `cohortFilter`
  ADD PRIMARY KEY (`cohortFilterID`),
  ADD UNIQUE KEY `U_cohortFilterName` (`cohortFilterName`),
  ADD KEY `I_cohortFilterEnabled` (`cohortFilterEnabled`),
  ADD KEY `I_cohortFilterSourceID` (`cohortFilterSourceID`),
  ADD KEY `I_cohortFilterCreatedByAdminID` (`cohortFilterCreatedByAdminID`),
  ADD KEY `I_cohortFilterUpdatedByAdminID` (`cohortFilterUpdatedByAdminID`);

--
-- Indexes for table `cohortSources`
--
ALTER TABLE `cohortSources`
  ADD PRIMARY KEY (`cohortSourceID`),
  ADD UNIQUE KEY `U_cohortName` (`cohortSourceName`),
  ADD KEY `I_cohortEnabled` (`cohortSourceEnabled`);

--
-- Indexes for table `countMethod`
--
ALTER TABLE `countMethod`
  ADD PRIMARY KEY (`countMethodID`),
  ADD UNIQUE KEY `U_countMethodName` (`countMethodName`),
  ADD KEY `I_countMethodCreatedByAdminID` (`countMethodCreatedByAdminID`),
  ADD KEY `I_countMethodUpdatedByAdminID` (`countMethodUpdatedByAdminID`),
  ADD KEY `I_countMethodEnabled` (`countMethodEnabled`);

--
-- Indexes for table `poll`
--
ALTER TABLE `poll`
  ADD PRIMARY KEY (`pollID`),
  ADD UNIQUE KEY `U_pollURL` (`pollYear`,`pollURL`) USING BTREE,
  ADD UNIQUE KEY `U_pollName` (`pollName`,`pollYear`) USING BTREE,
  ADD KEY `I_pollCohortFilterID` (`pollCohortFilterID`),
  ADD KEY `I_pollRuleID` (`pollRuleID`),
  ADD KEY `I_pollReturningOfficerID` (`pollReturningOfficerID`),
  ADD KEY `I_pollContactOfficerID` (`pollContactOfficerID`),
  ADD KEY `I_pollIsPublic` (`pollIsPublic`),
  ADD KEY `I_pollIsReferendum` (`pollIsReferendum`),
  ADD KEY `I_pollCreatedByID` (`pollCreatedBy`),
  ADD KEY `I_pollUpdatedByID` (`pollUpdatedByID`),
  ADD KEY `I_pollStatus` (`pollStatus`) USING BTREE,
  ADD KEY `I_pollYear` (`pollYear`);

--
-- Indexes for table `electorate`
--
ALTER TABLE `electorate`
  ADD PRIMARY KEY (`voterID`),
  ADD UNIQUE KEY `U_voterIsUnique` (`voterPollID`,`voterUserID`,`voterCohortSourceID`),
  ADD UNIQUE KEY `U_voterCandiateStatus` (`voterPollID`,`voterUserID`,`voterCohortSourceID`,`voterCandidateStatus`),
  ADD KEY `I_voterPollID` (`voterPollID`),
  ADD KEY `I_voterUserID` (`voterUserID`),
  ADD KEY `I_voterCohortSourceID` (`voterCohortSourceID`),
  ADD KEY `I_voterVoted` (`voterStatus`),
  ADD KEY `I_voterCandidateStatus` (`voterCandidateStatus`),
  ADD KEY `I_voterHasVotedInPoll` (`voterPollID`,`voterUserID`,`voterCohortSourceID`,`voterStatus`);

--
-- Indexes for table `email`
--
ALTER TABLE `email`
  ADD PRIMARY KEY (`emailID`),
  ADD UNIQUE KEY `U_pollTypeFrom` (`emailPollID`,`emailType`,`emailFromReturningOfficer`),
  ADD KEY `I_emailPollID` (`emailPollID`),
  ADD KEY `I_emailType` (`emailType`),
  ADD KEY `I_emailFromReturningOfficer` (`emailFromReturningOfficer`),
  ADD KEY `I_emailSendCount` (`emailSendCount`),
  ADD KEY `I_emailCreatedByAdminID` (`emailCreatedByAdminID`),
  ADD KEY `I_emailUpdatedByAdminID` (`emailUpdatedByAdminID`),
  ADD KEY `I_emailReplyTo` (`emailReplyTo`),
  ADD KEY `I_emailIsTemplate` (`emailIsTemplate`);

--
-- Indexes for table `joinPollAdmin`
--
ALTER TABLE `joinPollAdmin`
  ADD PRIMARY KEY (`joinPollAdminPollID`),
  ADD UNIQUE KEY `U_joinPollAdminPollAdmin` (`joinPollAdminPollID`,`joinPollAdminAdminID`),
  ADD KEY `I_joinPollAdminAdminID` (`joinPollAdminAdminID`),
  ADD KEY `I_joinPollAdminEnabled` (`joinPollAdminEnabled`),
  ADD KEY `I_joinPollAdminCreatedByAdminID` (`joinPollAdminCreatedByAdminID`),
  ADD KEY `I_joinPollAdminUpdatedByAdminID` (`joinPollAdminUpdatedByAdminID`),
  ADD KEY `I_joinPollAdminPollID` (`joinPollAdminPollID`);

--
-- Indexes for table `joinEmailVoter`
--
ALTER TABLE `joinEmailVoter`
  ADD KEY `I_joinEmailVoterEmailID` (`joinEmailVoterEmailID`),
  ADD KEY `I_joinEmailVoterVoterID` (`joinEmailVoterVoterID`);

--
-- Indexes for table `joinRuleAdmin`
--
ALTER TABLE `joinPollCohortFilter`
  ADD UNIQUE KEY `U_joinPollCohortFilter` (`joinPollCohortFilterPollID`,`joinPollCohortFilterCohortFilterID`) USING BTREE,
  ADD KEY `I_joinPollCohortFilterPollID` (`joinPollCohortFilterPollID`),
  ADD KEY `I_joinPollCohortFilterCohortFilterID` (`joinPollCohortFilterCohortFilterID`),
  ADD KEY `I_joinPollCohortFilterCreatedByAdminID` (`joinPollCohortFilterCreatedByAdminID`),
  ADD KEY `I_joinPollCohortFilterUpdatedByAdminID` (`joinPollCohortFilterUpdatedByAdminID`);

--
-- Indexes for table `joinRuleAdmin`
--
ALTER TABLE `joinRuleAdmin`
  ADD UNIQUE KEY `U_joinRuleAdminRule` (`joinRuleAdminRuleID`,`joinRuleAdminAdminID`) USING BTREE,
  ADD KEY `I_joinRuleAdminRuleID` (`joinRuleAdminRuleID`),
  ADD KEY `I_joinRuleAdminAdminID` (`joinRuleAdminAdminID`),
  ADD KEY `I_joinRuleAdminEnabled` (`joinRuleAdminEnabled`),
  ADD KEY `I_joinRuleAdminCreatedByAdminID` (`joinRuleAdminCreatedByAdminID`),
  ADD KEY `I_joinRuleAdminUpdatedByAdminID` (`joinRuleAdminUpdatedByAdminID`);

--
-- Indexes for table `logChanges`
--
ALTER TABLE `logChanges`
  ADD KEY `I_changeByAdminID` (`changeByAdminID`),
  ADD KEY `I_changeAction` (`changeAction`),
  ADD KEY `I_changeUpdatedTable` (`changeUpdatedTable`),
  ADD KEY `I_changeByAction` (`changeByAdminID`,`changeAction`),
  ADD KEY `changeByUpdatedTable` (`changeByAdminID`,`changeUpdatedTable`),
  ADD KEY `I_changeByActionUpdated` (`changeByAdminID`,`changeAction`,`changeUpdatedTable`);

--
-- Indexes for table `logPoll`
--
ALTER TABLE `logPoll`
  ADD PRIMARY KEY (`logID`),
  ADD KEY `I_logPollID` (`logPollID`),
  ADD KEY `I_logType` (`logType`),
  ADD KEY `I_logTypeSub` (`logTypeSub`),
  ADD KEY `I_typeSubtype` (`logType`,`logTypeSub`) USING BTREE,
  ADD KEY `I_pollType` (`logPollID`,`logType`),
  ADD KEY `I_pollSubType` (`logPollID`,`logTypeSub`),
  ADD KEY `I_pollTypeSubtype` (`logPollID`,`logType`,`logTypeSub`),
  ADD KEY `I_logCode` (`logCode`),
  ADD KEY `I_logPollSubTypeCode` (`logPollID`,`logTypeSub`,`logCode`),
  ADD KEY `I_logPollCode` (`logPollID`,`logCode`) USING BTREE;

--
-- Indexes for table `party`
--
ALTER TABLE `party`
  ADD PRIMARY KEY (`partyID`),
  ADD UNIQUE KEY `U_partyName` (`partyName`);

--
-- Indexes for table `results`
--
ALTER TABLE `results`
  ADD PRIMARY KEY (`resultID`),
  ADD KEY `I_resultsPollID` (`resultsPollID`),
  ADD KEY `I_resultsTotalVoters` (`resultsTotalVoters`),
  ADD KEY `I_resultsTotalVotesCast` (`resultsTotalVotesCast`),
  ADD KEY `I_resultsSuperseedsResultID` (`resultsSuperseedsResultID`),
  ADD KEY `I_resultsSuperseeded` (`resultID`,`resultsSuperseedsResultID`),
  ADD KEY `I_resultsTotalVotersAndVotes` (`resultsTotalVoters`,`resultsTotalVotesCast`) USING BTREE,
  ADD KEY `I_resultsSuperseededByPoll` (`resultsPollID`,`resultsSuperseedsResultID`);


--
-- Indexes for table `rules`
--
ALTER TABLE `rules`
  ADD PRIMARY KEY (`ruleID`),
  ADD UNIQUE KEY `U_ruleName` (`ruleName`),
  ADD KEY `I_ruleCountMethodID` (`ruleCountMethodID`),
  ADD KEY `I_ruleEnabled` (`ruleEnabled`),
  ADD KEY `I_ruleBallotVerificationAllowed` (`ruleNominatorCount`),
  ADD KEY `I_ruleCreatedByAdminID` (`ruleCreatedByAdminID`),
  ADD KEY `I_ruleUpdateByAdminID` (`ruleUpdateByAdminID`),
  ADD KEY `I_ruleUpdateElectorateBeforeOpening` (`ruleUpdateElectorateBeforeOpening`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `adminID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `candidate`
--
ALTER TABLE `candidate`
  MODIFY `candidateID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `cohortFilter`
--
ALTER TABLE `cohortFilter`
  MODIFY `cohortFilterID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `cohortSources`
--
ALTER TABLE `cohortSources`
  MODIFY `cohortSourceID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `countMethod`
--
ALTER TABLE `countMethod`
  MODIFY `countMethodID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `poll`
--
ALTER TABLE `poll`
  MODIFY `pollID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `electorate`
--
ALTER TABLE `electorate`
  MODIFY `voterID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `email`
--
ALTER TABLE `email`
  MODIFY `emailID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `joinPollAdmin`
--
ALTER TABLE `joinPollAdmin`
  MODIFY `joinPollAdminPollID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `logPoll`
--
ALTER TABLE `logPoll`
  MODIFY `logID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `party`
--
ALTER TABLE `party`
  MODIFY `partyID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `results`
--
ALTER TABLE `results`
  MODIFY `resultID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `rules`
--
ALTER TABLE `rules`
  MODIFY `ruleID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`adminCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `admin_ibfk_2` FOREIGN KEY (`adminUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `admin_ibfk_3` FOREIGN KEY (`adminCohortSourceID`) REFERENCES `cohortSources` (`cohortSourceID`) ON UPDATE CASCADE;

--
-- Constraints for table `ballotBox`
--
ALTER TABLE `ballotBox`
  ADD CONSTRAINT `ballotBox_ibfk_1` FOREIGN KEY (`ballotPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE;

--
-- Constraints for table `candidate`
--
ALTER TABLE `candidate`
  ADD CONSTRAINT `candidate_ibfk_1` FOREIGN KEY (`candidatePollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `candidate_ibfk_2` FOREIGN KEY (`candidateVoterID`) REFERENCES `electorate` (`voterID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `candidate_ibfk_3` FOREIGN KEY (`candidateUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `candidate_ibfk_4` FOREIGN KEY (`candidateEndorsedByPartyID`) REFERENCES `party` (`partyID`) ON UPDATE CASCADE;

--
-- Constraints for table `cohortFilter`
--
ALTER TABLE `cohortFilter`
  ADD CONSTRAINT `cohortFilter_ibfk_1` FOREIGN KEY (`cohortFilterSourceID`) REFERENCES `cohortSources` (`cohortSourceID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cohortFilter_ibfk_2` FOREIGN KEY (`cohortFilterCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cohortFilter_ibfk_3` FOREIGN KEY (`cohortFilterUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `countMethod`
--
ALTER TABLE `countMethod`
  ADD CONSTRAINT `countMethod_ibfk_1` FOREIGN KEY (`countMethodCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `countMethod_ibfk_2` FOREIGN KEY (`countMethodUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `poll`
--
ALTER TABLE `poll`
  ADD CONSTRAINT `poll_ibfk_1` FOREIGN KEY (`pollRuleID`) REFERENCES `rules` (`ruleID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `poll_ibfk_3` FOREIGN KEY (`pollUpdatedByID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `electorate`
--
ALTER TABLE `electorate`
  ADD CONSTRAINT `electorate_ibfk_1` FOREIGN KEY (`voterCohortSourceID`) REFERENCES `cohortFilter` (`cohortFilterID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `electorate_ibfk_2` FOREIGN KEY (`voterPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE;

--
-- Constraints for table `email`
--
ALTER TABLE `email`
  ADD CONSTRAINT `email_ibfk_1` FOREIGN KEY (`emailPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `email_ibfk_2` FOREIGN KEY (`emailCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `email_ibfk_3` FOREIGN KEY (`emailUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `joinPollAdmin`
--
ALTER TABLE `joinPollAdmin`
  ADD CONSTRAINT `joinPollAdmin_ibfk_1` FOREIGN KEY (`joinPollAdminUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinPollAdmin_ibfk_2` FOREIGN KEY (`joinPollAdminCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinPollAdmin_ibfk_3` FOREIGN KEY (`joinPollAdminAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinPollAdmin_ibfk_4` FOREIGN KEY (`joinPollAdminPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE;

--
-- Constraints for table `joinPollAdmin`
--
ALTER TABLE `joinPollCohortFilter`
  ADD CONSTRAINT `joinPollCohortFilter_ibfk_1` FOREIGN KEY (`joinPollCohortFilterUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinPollCohortFilter_ibfk_2` FOREIGN KEY (`joinPollCohortFilterCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinPollCohortFilter_ibfk_3` FOREIGN KEY (`joinPollCohortFilterPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinPollCohortFilter_ibfk_4` FOREIGN KEY (`joinPollCohortFilterCohortFilterID`) REFERENCES `cohortFilter` (`cohortFilterID`) ON UPDATE CASCADE;

--
-- Constraints for table `joinEmailVoter`
--
ALTER TABLE `joinEmailVoter`
  ADD CONSTRAINT `joinEmailVoter_ibfk_1` FOREIGN KEY (`joinEmailVoterEmailID`) REFERENCES `email` (`emailID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinEmailVoter_ibfk_2` FOREIGN KEY (`joinEmailVoterVoterID`) REFERENCES `electorate` (`voterID`) ON UPDATE CASCADE;

--
-- Constraints for table `joinRuleAdmin`
--
ALTER TABLE `joinRuleAdmin`
  ADD CONSTRAINT `joinRuleAdmin_ibfk_1` FOREIGN KEY (`joinRuleAdminAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinRuleAdmin_ibfk_2` FOREIGN KEY (`joinRuleAdminCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinRuleAdmin_ibfk_3` FOREIGN KEY (`joinRuleAdminUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinRuleAdmin_ibfk_4` FOREIGN KEY (`joinRuleAdminRuleID`) REFERENCES `rules` (`ruleID`) ON UPDATE CASCADE;

--
-- Constraints for table `logChanges`
--
ALTER TABLE `logChanges`
  ADD CONSTRAINT `logChanges_ibfk_1` FOREIGN KEY (`changeByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `logPoll`
--
ALTER TABLE `logPoll`
  ADD CONSTRAINT `logPoll_ibfk_1` FOREIGN KEY (`logPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE;

--
-- Constraints for table `results`
--
ALTER TABLE `results`
  ADD CONSTRAINT `results_ibfk_1` FOREIGN KEY (`resultsPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE;

--
-- Constraints for table `rules`
--
ALTER TABLE `rules`
  ADD CONSTRAINT `rules_ibfk_2` FOREIGN KEY (`ruleCountMethodID`) REFERENCES `countMethod` (`countMethodID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `rules_ibfk_3` FOREIGN KEY (`ruleCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `rules_ibfk_4` FOREIGN KEY (`ruleUpdateByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
