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
DROP TABLE IF EXISTS `enumAdminLevel`;
DROP TABLE IF EXISTS `enumCandidateStatus`;
DROP TABLE IF EXISTS `enumChangeAction`;
DROP TABLE IF EXISTS `enumEmailType`;
DROP TABLE IF EXISTS `enumEndorsementStatus`;
DROP TABLE IF EXISTS `enumLogType`;
DROP TABLE IF EXISTS `enumLogTypeSub`;
DROP TABLE IF EXISTS `enumPollStatus`;
DROP TABLE IF EXISTS `enumVoterStatus`;
-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `adminID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `adminUserID` varchar(128) NOT NULL,
  `adminCohortSourceID` smallint(5) UNSIGNED NOT NULL,
  `adminLevelID` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `adminCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `adminCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `adminUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `adminUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`adminID`),
  UNIQUE `U_adminUserID` (`adminUserID`,`adminCohortSourceID`) USING BTREE,
  KEY `I_adminLevel` (`adminLevelID`),
  KEY `I_adminCreatedByAdminID` (`adminCreatedByAdminID`),
  KEY `I_adminUpdatedByAdminID` (`adminUpdatedByAdminID`),
  KEY `I_adminCohortSourceID` (`adminCohortSourceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ballotBox`
--

CREATE TABLE `ballotBox` (
  `ballotPollID` int(10) UNSIGNED NOT NULL,
  `ballotID` char(40) NOT NULL,
  `ballotPaper` text NOT NULL,
  `ballotChecksum` char(40) NOT NULL,
  UNIQUE `U_ballotID` (`ballotID`),
  KEY `I_ballotPollID` (`ballotPollID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `candidate`
--

CREATE TABLE `candidate` (
  `candidateID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `candidatePollID` int(10) UNSIGNED NOT NULL,
  `candidateVoterID` int(10) UNSIGNED NOT NULL,
  `candidateCampaignURL` text NOT NULL,
  `candidateStatement` text NOT NULL,
  `candidatePhotoURL` text NOT NULL,
  `candidateEndorsedByPartyID` smallint(5) UNSIGNED NOT NULL,
  `candidateEndorsementStatusID` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `candidateCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `candidateUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `candidateUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`candidateID`),
  UNIQUE `candidateID` (`candidateID`,`candidatePollID`),
  KEY `I_candidatevoterPollID` (`candidatePollID`),
  KEY `I_candidateVoterID` (`candidateVoterID`),
  KEY `I_candidateEndorsedByPartyID` (`candidateEndorsedByPartyID`),
  KEY `I_candidateEndorsementStatus` (`candidateEndorsementStatusID`),
  KEY `I_candidateUpdatedByAdminID` (`candidateUpdatedByAdminID`),
  KEY `I_pollParty` (`candidatePollID`,`candidateEndorsedByPartyID`,`candidateEndorsementStatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cohortFilter`
--

CREATE TABLE `cohortFilter` (
  `cohortFilterID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cohortFilterName` varchar(128) NOT NULL,
  `cohortFilterEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `cohortFilterSourceID` smallint(5) UNSIGNED NOT NULL,
  `cohortFilterPerameters` text NOT NULL,
  `cohortFIlterCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `cohortFilterCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `cohortFilterUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `cohortFilterUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `cohortDescription` text NOT NULL,
  PRIMARY KEY (`cohortFilterID`),
  UNIQUE `U_cohortFilterName` (`cohortFilterName`),
  KEY `I_cohortFilterEnabled` (`cohortFilterEnabled`),
  KEY `I_cohortFilterSourceID` (`cohortFilterSourceID`),
  KEY `I_cohortFilterCreatedByAdminID` (`cohortFilterCreatedByAdminID`),
  KEY `I_cohortFilterUpdatedByAdminID` (`cohortFilterUpdatedByAdminID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cohortSources`
--

CREATE TABLE `cohortSources` (
  `cohortSourceID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cohortSourceName` varchar(64) NOT NULL,
  `cohortSourceDescription` varchar(255) NOT NULL,
  `cohortSourceEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `cohortSourceAvailableParams` text NOT NULL,
  PRIMARY KEY (`cohortSourceID`),
  UNIQUE `U_cohortName` (`cohortSourceName`),
  KEY `I_cohortEnabled` (`cohortSourceEnabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `countMethod`
--

CREATE TABLE `countMethod` (
  `countMethodID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `countMethodName` varchar(64) NOT NULL,
  `countMethodDescription` text NOT NULL,
  `countMethodInfoURL` text NOT NULL,
  `countMethodOptionsDefaults` text NOT NULL,
  `countMethodEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `countMethodCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `countMethodCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `countMethodUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `countMethodUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`countMethodID`),
  UNIQUE `U_countMethodName` (`countMethodName`),
  KEY `I_countMethodCreatedByAdminID` (`countMethodCreatedByAdminID`),
  KEY `I_countMethodUpdatedByAdminID` (`countMethodUpdatedByAdminID`),
  KEY `I_countMethodEnabled` (`countMethodEnabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `enumAdminLevel`

CREATE TABLE `enumAdminLevel` (
  `enumAdminLevelID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumAdminLevelName` varchar(8) NOT NULL,
  PRIMARY KEY (`enumAdminLevelID`),
  UNIQUE `U_enumAdminLevelName` (`enumAdminLevelName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `enumCandidateStatus`

CREATE TABLE `enumCandidateStatus` (
  `enumCandidateStatusID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumCandidateStatusName` varchar(12) NOT NULL,
  PRIMARY KEY (`enumCandidateStatusID`),
  UNIQUE `U_enumCandidateStatusName` (`enumCandidateStatusName`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `enumChangeAction`

CREATE TABLE `enumChangeAction` (
  `enumChangeActionID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumChangeActionName` varchar(8) NOT NULL,
  PRIMARY KEY (`enumChangeActionID`),
  UNIQUE `U_enumChangeActionName` (`enumChangeActionName`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `enumEmailType

CREATE TABLE `enumEmailType` (
  `enumEmailTypeID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumEmailTypeName` varchar(20) NOT NULL,
  PRIMARY KEY (`enumEmailTypeID`),
  UNIQUE `U_enumEmailTypeName` (`enumEmailTypeName`)
 ) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `enumAdminLevel`

CREATE TABLE `enumEndorsementStatus` (
  `enumEndorsementStatusID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumEndorsementStatusName` varchar(10) NOT NULL,
  PRIMARY KEY (`enumEndorsementStatusID`),
  UNIQUE `U_enumEndorsementStatusName` (`enumEndorsementStatusName`)
 ) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `enumLogType`

CREATE TABLE `enumLogType` (
  `enumLogTypeID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumLogTypeName` varchar(10) NOT NULL,
  PRIMARY KEY (`enumLogTypeID`),
  UNIQUE `U_enumLogTypeName` (`enumLogTypeName`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `enumLogTypeSub`

CREATE TABLE `enumLogTypeSub` (
  `enumLogTypeSubID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumLogTypeSubName` varchar(16) NOT NULL,
  PRIMARY KEY (`enumLogTypeSubID`),
  UNIQUE `U_enumLogTypeSubName` (`enumLogTypeSubName`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `enumPollStatus`

CREATE TABLE `enumPollStatus` (
  `enumPollStatusID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumPollStatusName` varchar(12) NOT NULL,
  PRIMARY KEY (`enumPollStatusID`),
  UNIQUE `U_enumPollStatusName` (`enumPollStatusName`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `enumPollStatus`

CREATE TABLE `enumVoterStatus` (
  `enumVoterStatusID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `enumVoterStatusName` varchar(12) NOT NULL,
  PRIMARY KEY (`enumVoterStatusID`),
  UNIQUE `U_enumVoterStatusName` (`enumVoterStatusName`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;
-- enum('forbidden','allowed','voted')

-- --------------------------------------------------------

--
-- Table structure for table `electorate`
--

CREATE TABLE `electorate` (
  `voterID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `voterPollID` int(10) UNSIGNED NOT NULL,
  `voterUserID` varchar(128) NOT NULL,
  `voterCohortSourceID` smallint(5) UNSIGNED NOT NULL,
  `voterFullName` varchar(128) NOT NULL,
  `voterEmail` varchar(255) NOT NULL,
  `voterStatus` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `voterCandidateStatusID` smallint(5) UNSIGNED NOT NULL DEFAULT 2,
  `voterBallotPaperCheckSum` char(40) NOT NULL,
  `voterCreated` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`voterID`),
  UNIQUE `U_voterIsUnique` (`voterPollID`,`voterUserID`,`voterCohortSourceID`),
  UNIQUE `U_voterCandiateStatus` (`voterPollID`,`voterUserID`,`voterCohortSourceID`,`voterCandidateStatusID`),
  KEY `I_voterPollID` (`voterPollID`),
  KEY `I_voterUserID` (`voterUserID`),
  KEY `I_voterCohortSourceID` (`voterCohortSourceID`),
  KEY `I_voterVoted` (`voterStatus`),
  KEY `I_voterCandidateStatus` (`voterCandidateStatusID`),
  KEY `I_voterHasVotedInPoll` (`voterPollID`,`voterUserID`,`voterCohortSourceID`,`voterStatus`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `email`
--

CREATE TABLE `email` (
  `emailID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `emailPollID` int(10) UNSIGNED NOT NULL,
  `emailTypeID` smallint(5) UNSIGNED NOT NULL,
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
  `emailUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`emailID`),
  UNIQUE `U_pollTypeFrom` (`emailPollID`,`emailTypeID`,`emailFromReturningOfficer`),
  KEY `I_emailPollID` (`emailPollID`),
  KEY `I_emailType` (`emailTypeID`),
  KEY `I_emailFromReturningOfficer` (`emailFromReturningOfficer`),
  KEY `I_emailSendCount` (`emailSendCount`),
  KEY `I_emailReplyTo` (`emailReplyTo`),
  KEY `I_emailIsTemplate` (`emailIsTemplate`),
  KEY `I_emailCreatedByAdminID` (`emailCreatedByAdminID`),
  KEY `I_emailUpdatedByAdminID` (`emailUpdatedByAdminID`)
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
  `joinPollAdminUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`joinPollAdminPollID`),
  UNIQUE `U_joinPollAdminPollAdmin` (`joinPollAdminPollID`,`joinPollAdminAdminID`),
  KEY `I_joinPollAdminAdminID` (`joinPollAdminAdminID`),
  KEY `I_joinPollAdminEnabled` (`joinPollAdminEnabled`),
  KEY `I_joinPollAdminCreatedByAdminID` (`joinPollAdminCreatedByAdminID`),
  KEY `I_joinPollAdminUpdatedByAdminID` (`joinPollAdminUpdatedByAdminID`),
  KEY `I_joinPollAdminPollID` (`joinPollAdminPollID`)
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
  `joinPollCohortFilterUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  UNIQUE `U_joinPollCohortFilter` (`joinPollCohortFilterPollID`,`joinPollCohortFilterCohortFilterID`) USING BTREE,
  KEY `I_joinPollCohortFilterPollID` (`joinPollCohortFilterPollID`),
  KEY `I_joinPollCohortFilterCohortFilterID` (`joinPollCohortFilterCohortFilterID`),
  KEY `I_joinPollCohortFilterCreatedByAdminID` (`joinPollCohortFilterCreatedByAdminID`),
  KEY `I_joinPollCohortFilterUpdatedByAdminID` (`joinPollCohortFilterUpdatedByAdminID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `joinEmailVoter`
--

CREATE TABLE `joinEmailVoter` (
  `joinEmailVoterVoterID` int(10) UNSIGNED NOT NULL,
  `joinEmailVoterEmailID` int(10) UNSIGNED NOT NULL,
  `joinEmailVoterSendTime` timestamp NOT NULL DEFAULT current_timestamp(),
  UNIQUE `U_joinEmailVoter` (`joinEmailVoterVoterID`,`joinEmailVoterEmailID`) USING BTREE,
  KEY `I_joinEmailVoterEmailID` (`joinEmailVoterEmailID`),
  KEY `I_joinEmailVoterVoterID` (`joinEmailVoterVoterID`)
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
  `joinRuleAdminUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  UNIQUE `U_joinRuleAdminRule` (`joinRuleAdminRuleID`,`joinRuleAdminAdminID`) USING BTREE,
  KEY `I_joinRuleAdminRuleID` (`joinRuleAdminRuleID`),
  KEY `I_joinRuleAdminAdminID` (`joinRuleAdminAdminID`),
  KEY `I_joinRuleAdminEnabled` (`joinRuleAdminEnabled`),
  KEY `I_joinRuleAdminCreatedByAdminID` (`joinRuleAdminCreatedByAdminID`),
  KEY `I_joinRuleAdminUpdatedByAdminID` (`joinRuleAdminUpdatedByAdminID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logChanges`
--

CREATE TABLE `logChanges` (
  `changeID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `changeTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changeByAdminID` smallint(5) UNSIGNED NOT NULL,
  `changeActionID` smallint(5) UNSIGNED NOT NULL,
  `changeUpdatedTable` varchar(32) NOT NULL,
  `changeDiff` text NOT NULL,
  PRIMARY KEY (`changeID`),
  KEY `I_changeByAdminID` (`changeByAdminID`),
  KEY `I_changeAction` (`changeActionID`),
  KEY `I_changeUpdatedTable` (`changeUpdatedTable`),
  KEY `I_changeByAction` (`changeByAdminID`,`changeActionID`),
  KEY `changeByUpdatedTable` (`changeByAdminID`,`changeUpdatedTable`),
  KEY `I_changeByActionUpdated` (`changeByAdminID`,`changeActionID`,`changeUpdatedTable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logPoll`
--

CREATE TABLE `logPoll` (
  `logID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `logTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `logPollID` int(10) UNSIGNED NOT NULL,
  `logTypeID` smallint(5) UNSIGNED NOT NULL,
  `logTypeSubID` smallint(5) UNSIGNED NOT NULL,
  `logCode` smallint(5) UNSIGNED NOT NULL,
  `logMessage` varchar(255) NOT NULL,
  PRIMARY KEY (`logID`),
  KEY `I_logPollID` (`logPollID`),
  KEY `I_logType` (`logTypeID`),
  KEY `I_logTypeSub` (`logTypeSubID`),
  KEY `I_typeSubtype` (`logTypeID`,`logTypeSubID`) USING BTREE,
  KEY `I_pollType` (`logPollID`,`logTypeID`),
  KEY `I_pollSubType` (`logPollID`,`logTypeSubID`),
  KEY `I_pollTypeSubtype` (`logPollID`,`logTypeID`,`logTypeSubID`),
  KEY `I_logCode` (`logCode`),
  KEY `I_logPollSubTypeCode` (`logPollID`,`logTypeSubID`,`logCode`),
  KEY `I_logPollCode` (`logPollID`,`logCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `party`
--

CREATE TABLE `party` (
  `partyID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `partyName` varchar(32) NOT NULL,
  `partyURL` text NOT NULL,
  PRIMARY KEY (`partyID`),
  UNIQUE `U_partyName` (`partyName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
--
-- Table structure for table `poll`
--

CREATE TABLE `poll` (
  `pollID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pollName` varchar(128) NOT NULL COMMENT 'Title of the poll',
  `pollYear` smallint(5) UNSIGNED NOT NULL COMMENT 'parent path in URL',
  `pollURL` varchar(32) NOT NULL COMMENT 'URL path for accessing the poll',
  `pollDescription` text NOT NULL,
  `pollStatusID` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
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
  `pollCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `pollUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `pollUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`pollID`),
  UNIQUE `U_pollURL` (`pollYear`,`pollURL`) USING BTREE,
  UNIQUE `U_pollName` (`pollName`,`pollYear`) USING BTREE,
  KEY `I_pollCohortFilterID` (`pollCohortFilterID`),
  KEY `I_pollRuleID` (`pollRuleID`),
  KEY `I_pollReturningOfficerID` (`pollReturningOfficerID`),
  KEY `I_pollContactOfficerID` (`pollContactOfficerID`),
  KEY `I_pollIsPublic` (`pollIsPublic`),
  KEY `I_pollIsReferendum` (`pollIsReferendum`),
  KEY `I_pollCreatedByID` (`pollCreatedByAdminID`),
  KEY `I_pollUpdatedByID` (`pollUpdatedByAdminID`),
  KEY `I_pollStatus` (`pollStatusID`),
  KEY `I_pollYear` (`pollYear`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `results`
--

CREATE TABLE `resultsCache` (
  `resultID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `resultsPollID` int(10) UNSIGNED NOT NULL,
  `resultsTotalVoters` int(10) UNSIGNED NOT NULL,
  `resultsTotalVotesCast` int(10) UNSIGNED NOT NULL,
  `resultsCounted` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resultsSuperseedsResultID` int(10) UNSIGNED NOT NULL,
  `resultsWinners` text NOT NULL,
  `resultsDetails` text NOT NULL,
  PRIMARY KEY (`resultID`),
  KEY `I_resultsPollID` (`resultsPollID`),
  KEY `I_resultsTotalVoters` (`resultsTotalVoters`),
  KEY `I_resultsTotalVotesCast` (`resultsTotalVotesCast`),
  KEY `I_resultsSuperseedsResultID` (`resultsSuperseedsResultID`),
  KEY `I_resultsSuperseeded` (`resultID`,`resultsSuperseedsResultID`),
  KEY `I_resultsTotalVotersAndVotes` (`resultsTotalVoters`,`resultsTotalVotesCast`) USING BTREE,
  KEY `I_resultsSuperseededByPoll` (`resultsPollID`,`resultsSuperseedsResultID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `rules`
--

CREATE TABLE `rules` (
  `ruleID` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
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
  `ruleUpdateByAdminID` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`ruleID`),
  UNIQUE `U_ruleName` (`ruleName`),
  KEY `I_ruleCountMethodID` (`ruleCountMethodID`),
  KEY `I_ruleEnabled` (`ruleEnabled`),
  KEY `I_ruleBallotVerificationAllowed` (`ruleNominatorCount`),
  KEY `I_ruleCreatedByAdminID` (`ruleCreatedByAdminID`),
  KEY `I_ruleUpdateByAdminID` (`ruleUpdateByAdminID`),
  KEY `I_ruleUpdateElectorateBeforeOpening` (`ruleUpdateElectorateBeforeOpening`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`adminCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `admin_ibfk_2` FOREIGN KEY (`adminUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `admin_ibfk_3` FOREIGN KEY (`adminCohortSourceID`) REFERENCES `cohortSources` (`cohortSourceID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `admin_ibfk_4` FOREIGN KEY (`adminLevelID`) REFERENCES `enumAdminLevel` (`enumAdminLevelID`) ON UPDATE CASCADE;

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
  ADD CONSTRAINT `candidate_ibfk_4` FOREIGN KEY (`candidateEndorsedByPartyID`) REFERENCES `party` (`partyID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `candidate_ibfk_5` FOREIGN KEY (`candidateEndorsementStatusID`) REFERENCES `enumEndorsementStatus` (`enumEndorsementStatusID`) ON UPDATE CASCADE;

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
-- Constraints for table `electorate`
--
ALTER TABLE `electorate`
  ADD CONSTRAINT `electorate_ibfk_1` FOREIGN KEY (`voterCohortSourceID`) REFERENCES `cohortFilter` (`cohortFilterID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `electorate_ibfk_2` FOREIGN KEY (`voterPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `electorate_ibfk_3` FOREIGN KEY (`voterCandidateStatusID`) REFERENCES `enumCandidateStatus` (`enumCandidateStatusID`) ON UPDATE CASCADE;

--
-- Constraints for table `email`
--
ALTER TABLE `email`
  ADD CONSTRAINT `email_ibfk_1` FOREIGN KEY (`emailPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `email_ibfk_2` FOREIGN KEY (`emailUpdatedByAdminID`) REFERENCES `enumEmailType` (`enumEmailTypeID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `email_ibfk_3` FOREIGN KEY (`emailCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `email_ibfk_4` FOREIGN KEY (`emailUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

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
  ADD CONSTRAINT `logChanges_ibfk_1` FOREIGN KEY (`changeActionID`) REFERENCES `enumChangeAction` (`enumChangeActionID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `logChanges_ibfk_2` FOREIGN KEY (`changeByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `logPoll`
--
ALTER TABLE `logPoll`
  ADD CONSTRAINT `logPoll_ibfk_1` FOREIGN KEY (`logTypeID`) REFERENCES `enumLogType` (`enumLogTypeID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `logPoll_ibfk_2` FOREIGN KEY (`logTypeSubID`) REFERENCES `enumLogTypeSub` (`enumLogTypeSubID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `logPoll_ibfk_3` FOREIGN KEY (`logPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE;

--
-- Constraints for table `poll`
--
ALTER TABLE `poll`
  ADD CONSTRAINT `poll_ibfk_1` FOREIGN KEY (`pollStatusID`) REFERENCES `enumPollStatus` (`enumPollStatusID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `poll_ibfk_2` FOREIGN KEY (`pollRuleID`) REFERENCES `rules` (`ruleID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `poll_ibfk_3` FOREIGN KEY (`pollCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `poll_ibfk_4` FOREIGN KEY (`pollUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `results`
--
ALTER TABLE `resultsCache`
  ADD CONSTRAINT `resultsCache_ibfk_1` FOREIGN KEY (`resultsPollID`) REFERENCES `poll` (`pollID`) ON UPDATE CASCADE;

--
-- Constraints for table `rules`
--
ALTER TABLE `rules`
  ADD CONSTRAINT `rules_ibfk_2` FOREIGN KEY (`ruleCountMethodID`) REFERENCES `countMethod` (`countMethodID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `rules_ibfk_3` FOREIGN KEY (`ruleCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `rules_ibfk_4` FOREIGN KEY (`ruleUpdateByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

-- --------------------------------------------------------


INSERT INTO `enumAdminLevel` (`enumAdminLevelID`, `enumAdminLevelName`) VALUES
(1, 'basic'),
(2, 'official'),
(3, 'poll'),
(6, 'root'),
(4, 'rule'),
(5, 'super');

-- --------------------------------------------------------

INSERT INTO `enumCandidateStatus` (`enumCandidateStatusID`, `enumCandidateStatusName`) VALUES
(0, 'disqualified'),
(1, 'cannot stand'),
(2, 'eligible'),
(3, 'is standing'),
(4, 'elected');

-- --------------------------------------------------------

INSERT INTO `enumChangeAction` (`enumChangeActionID`, `enumChangeActionName`) VALUES
(1, 'insert'),
(2, 'update'),
(3, 'delete');

-- --------------------------------------------------------

INSERT INTO `enumEmailType` (`enumEmailTypeID`, `enumEmailTypeName`) VALUES
(1, 'call for nominations'),
(2, 'nominations open'),
(3, 'nominations remider'),
(4, 'nominations closed'),
(5, 'voting open'),
(6, 'voting reminder'),
(7, 'voting closed'),
(8, 'results');

-- --------------------------------------------------------

INSERT INTO `enumEndorsementStatus` (`enumEndorsementStatusID`, `enumEndorsementStatusName`) VALUES
(0, 'rejected'),
(1, 'none'),
(2, 'requested'),
(3, 'varified');

-- --------------------------------------------------------

INSERT INTO `enumPollStatus` (`enumPollStatusID`, `enumPollStatusName`) VALUES
(1, 'pending'),
(2, 'accepting nominations'),
(3, 'campaigning'),
(4, 'voting'),
(5, 'counting'),
(6, 'results'),
(7, 'archived');

-- --------------------------------------------------------

INSERT INTO `enumLogType` (`enumLogTypeID`, `enumLogTypeName`) VALUES
(1, 'message'),
(2, 'notice'),
(3, 'warning'),
(4, 'error');

-- --------------------------------------------------------

INSERT INTO `enumLogTypeSub` (`enumLogTypeSubID`, `enumLogTypeSubName`) VALUES
(1, 'import'),
(2, 'email'),
(3, 'authentication'),
(4, 'nomination'),
(5, 'vote'),
(6, 'validation'),
(7, 'count');

-- --------------------------------------------------------

INSERT INTO `enumVoterStatus` (`enumVoterStatusID`, `enumVoterStatusName`) VALUES
(0, 'forbidden'),
(1, 'allowed'),
(2, 'voted');

-- --------------------------------------------------------

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
