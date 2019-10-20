-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 21, 2019 at 10:40 AM
-- Server version: 10.3.18-MariaDB-1
-- PHP Version: 7.3.9-1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `openElection`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `adminID` smallint(5) UNSIGNED NOT NULL,
  `adminUserID` varchar(128) NOT NULL,
  `adminCohortSourceID` smallint(5) UNSIGNED NOT NULL,
  `adminLevel` enum('basic','official','election','rule','super','root') NOT NULL DEFAULT 'basic',
  `adminCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `adminCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `adminUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `adminUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ballotBox`
--

DROP TABLE IF EXISTS `ballotBox`;
CREATE TABLE `ballotBox` (
  `ballotElectionID` int(10) UNSIGNED NOT NULL,
  `ballotID` char(40) NOT NULL,
  `ballotPaper` text NOT NULL,
  `ballotChecksum` char(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `candidate`
--

DROP TABLE IF EXISTS `candidate`;
CREATE TABLE `candidate` (
  `candidateID` smallint(5) UNSIGNED NOT NULL,
  `candidateElectionID` int(10) UNSIGNED NOT NULL,
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

DROP TABLE IF EXISTS `cohortFilter`;
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

DROP TABLE IF EXISTS `cohortSources`;
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

DROP TABLE IF EXISTS `countMethod`;
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
-- Table structure for table `election`
--

DROP TABLE IF EXISTS `election`;
CREATE TABLE `election` (
  `electionID` int(10) UNSIGNED NOT NULL,
  `electionName` varchar(128) NOT NULL COMMENT 'Title of the election',
  `electionYear` smallint(5) UNSIGNED NOT NULL COMMENT 'parent path in URL',
  `electionURL` varchar(32) NOT NULL COMMENT 'URL path for accessing the election',
  `electionDescription` text NOT NULL,
  `electionStatus` enum('pending','accepting nominations','campaigning','voting','counting','results','archived') NOT NULL,
  `electionCohortFilterID` smallint(5) UNSIGNED NOT NULL,
  `electionRuleID` smallint(5) UNSIGNED NOT NULL,
  `electionDateVotingStart` datetime NOT NULL,
  `electionDateVotingClose` datetime DEFAULT NULL,
  `electionDateArchive` datetime DEFAULT NULL,
  `electionDateNominationsOpen` datetime DEFAULT NULL,
  `electionDateNominationsClose` datetime DEFAULT NULL,
  `electionReturningOfficerID` int(10) UNSIGNED NOT NULL,
  `electionContactOfficerID` int(10) UNSIGNED NOT NULL,
  `electionIsPublic` tinyint(1) NOT NULL DEFAULT 1,
  `electionIsReferendum` tinyint(1) NOT NULL DEFAULT 0,
  `electionCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `electionCreatedBy` smallint(5) UNSIGNED NOT NULL,
  `electionUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `electionUpdatedByID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `electorate`
--

DROP TABLE IF EXISTS `electorate`;
CREATE TABLE `electorate` (
  `voterID` int(10) UNSIGNED NOT NULL,
  `voterElectionID` int(10) UNSIGNED NOT NULL,
  `voterUserID` varchar(128) NOT NULL,
  `voterCohortSourceID` smallint(5) UNSIGNED NOT NULL,
  `voterFullName` varchar(128) NOT NULL,
  `voterEmail` varchar(255) NOT NULL,
  `voterStatus` enum('forbidden','allowed','voted') NOT NULL DEFAULT 'allowed',
  `voterCandidateStatus` enum('Disqualified','Cannot stand','Eligible','Is standing','Elected') NOT NULL,
  `voterBallotPaperCheckSum` char(40) NOT NULL,
  `voterCreated` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
CREATE TABLE `email` (
  `emailID` int(10) UNSIGNED NOT NULL,
  `emailElectionID` int(10) UNSIGNED NOT NULL,
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
-- Table structure for table `joinElectionAdmin`
--

DROP TABLE IF EXISTS `joinElectionAdmin`;
CREATE TABLE `joinElectionAdmin` (
  `joinElectionAdminElectionID` int(10) UNSIGNED NOT NULL,
  `joinElectionAdminAdminID` smallint(5) UNSIGNED NOT NULL,
  `joinElectionAdminEnabled` tinyint(1) NOT NULL DEFAULT 1,
  `joinElectionAdminCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `joinElectionAdminCreatedByAdminID` smallint(5) UNSIGNED NOT NULL,
  `joinElectionAdminUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `joinElectionAdminUpdatedByAdminID` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `joinEmailVoter`
--

DROP TABLE IF EXISTS `joinEmailVoter`;
CREATE TABLE `joinEmailVoter` (
  `joinEmailVoterEmailID` int(10) UNSIGNED NOT NULL,
  `joinEmailVoterVoterID` int(10) UNSIGNED NOT NULL,
  `joinEmailVoterSendTime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `joinRuleAdmin`
--

DROP TABLE IF EXISTS `joinRuleAdmin`;
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

DROP TABLE IF EXISTS `logChanges`;
CREATE TABLE `logChanges` (
  `changeTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `changeByAdminID` smallint(5) UNSIGNED NOT NULL,
  `changeAction` enum('insert','update','delete') NOT NULL,
  `changeUpdatedTable` varchar(32) NOT NULL,
  `changeDiff` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logElection`
--

DROP TABLE IF EXISTS `logElection`;
CREATE TABLE `logElection` (
  `logID` int(10) UNSIGNED NOT NULL,
  `logTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `logElectionID` int(10) UNSIGNED NOT NULL,
  `logType` enum('message','notice','warning','error') NOT NULL,
  `logTypeSub` enum('import','email','authentication','nomination','vote','validation','count') NOT NULL,
  `logCode` smallint(5) UNSIGNED NOT NULL,
  `logMessage` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `party`
--

DROP TABLE IF EXISTS `party`;
CREATE TABLE `party` (
  `partyID` smallint(5) UNSIGNED NOT NULL,
  `partyName` varchar(32) NOT NULL,
  `partyURL` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
CREATE TABLE `results` (
  `resultID` int(10) UNSIGNED NOT NULL,
  `resultsElectionID` int(10) UNSIGNED NOT NULL,
  `resultsTotalVoters` int(10) UNSIGNED NOT NULL,
  `resultsTotalVotesCast` int(10) UNSIGNED NOT NULL,
  `resultsCounted` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resultsSuperseedsResultID` int(10) UNSIGNED NOT NULL,
  `resultsWinners` text NOT NULL,
  `resultsDetails` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `resultsCash`
--

DROP TABLE IF EXISTS `resultsCash`;
CREATE TABLE `resultsCash` (
  `resultID` int(10) UNSIGNED NOT NULL,
  `resultsElectionID` int(10) UNSIGNED NOT NULL,
  `resultsTotalVoters` int(10) UNSIGNED NOT NULL,
  `resultsTotalVotesCast` int(10) UNSIGNED NOT NULL,
  `resultsCounted` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resultsSuperseedsResultID` int(10) UNSIGNED DEFAULT NULL,
  `resultsWinners` text NOT NULL,
  `resultsDetails` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `rules`
--

DROP TABLE IF EXISTS `rules`;
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
  ADD KEY `I_ballotElectionID` (`ballotElectionID`);

--
-- Indexes for table `candidate`
--
ALTER TABLE `candidate`
  ADD PRIMARY KEY (`candidateID`),
  ADD UNIQUE KEY `candidateID` (`candidateID`,`candidateElectionID`),
  ADD KEY `I_candidatevoterElectionID` (`candidateElectionID`),
  ADD KEY `I_candidateVoterID` (`candidateVoterID`),
  ADD KEY `I_candidateEndorsedByPartyID` (`candidateEndorsedByPartyID`),
  ADD KEY `I_candidateEndorsementStatus` (`candidateEndorsementStatus`),
  ADD KEY `I_candidateUpdatedByAdminID` (`candidateUpdatedByAdminID`),
  ADD KEY `I_electionParty` (`candidateElectionID`,`candidateEndorsedByPartyID`,`candidateEndorsementStatus`);

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
-- Indexes for table `election`
--
ALTER TABLE `election`
  ADD PRIMARY KEY (`electionID`),
  ADD UNIQUE KEY `U_electionURL` (`electionYear`,`electionURL`) USING BTREE,
  ADD UNIQUE KEY `U_electionName` (`electionName`,`electionYear`) USING BTREE,
  ADD KEY `I_electionCohortFilterID` (`electionCohortFilterID`),
  ADD KEY `I_electionRuleID` (`electionRuleID`),
  ADD KEY `I_electionReturningOfficerID` (`electionReturningOfficerID`),
  ADD KEY `I_electionContactOfficerID` (`electionContactOfficerID`),
  ADD KEY `I_electionIsPublic` (`electionIsPublic`),
  ADD KEY `I_electionIsReferendum` (`electionIsReferendum`),
  ADD KEY `I_electionCreatedByID` (`electionCreatedBy`),
  ADD KEY `I_electionUpdatedByID` (`electionUpdatedByID`),
  ADD KEY `I_electionStatus` (`electionStatus`) USING BTREE,
  ADD KEY `I_electionYear` (`electionYear`);

--
-- Indexes for table `electorate`
--
ALTER TABLE `electorate`
  ADD PRIMARY KEY (`voterID`),
  ADD UNIQUE KEY `U_voterIsUnique` (`voterElectionID`,`voterUserID`,`voterCohortSourceID`),
  ADD UNIQUE KEY `U_voterCandiateStatus` (`voterElectionID`,`voterUserID`,`voterCohortSourceID`,`voterCandidateStatus`),
  ADD KEY `I_voterElectionID` (`voterElectionID`),
  ADD KEY `I_voterUserID` (`voterUserID`),
  ADD KEY `I_voterCohortSourceID` (`voterCohortSourceID`),
  ADD KEY `I_voterVoted` (`voterStatus`),
  ADD KEY `I_voterCandidateStatus` (`voterCandidateStatus`),
  ADD KEY `I_voterHasVotedInElection` (`voterElectionID`,`voterUserID`,`voterCohortSourceID`,`voterStatus`);

--
-- Indexes for table `email`
--
ALTER TABLE `email`
  ADD PRIMARY KEY (`emailID`),
  ADD UNIQUE KEY `U_electionTypeFrom` (`emailElectionID`,`emailType`,`emailFromReturningOfficer`),
  ADD KEY `I_emailElectionID` (`emailElectionID`),
  ADD KEY `I_emailType` (`emailType`),
  ADD KEY `I_emailFromReturningOfficer` (`emailFromReturningOfficer`),
  ADD KEY `I_emailSendCount` (`emailSendCount`),
  ADD KEY `I_emailCreatedByAdminID` (`emailCreatedByAdminID`),
  ADD KEY `I_emailUpdatedByAdminID` (`emailUpdatedByAdminID`),
  ADD KEY `I_emailReplyTo` (`emailReplyTo`),
  ADD KEY `I_emailIsTemplate` (`emailIsTemplate`);

--
-- Indexes for table `joinElectionAdmin`
--
ALTER TABLE `joinElectionAdmin`
  ADD PRIMARY KEY (`joinElectionAdminElectionID`),
  ADD UNIQUE KEY `U_joinElectionAdminElectionAdmin` (`joinElectionAdminElectionID`,`joinElectionAdminAdminID`),
  ADD KEY `I_joinElectionAdminAdminID` (`joinElectionAdminAdminID`),
  ADD KEY `I_joinElectionAdminEnabled` (`joinElectionAdminEnabled`),
  ADD KEY `I_joinElectionAdminCreatedByAdminID` (`joinElectionAdminCreatedByAdminID`),
  ADD KEY `I_joinElectionAdminUpdatedByAdminID` (`joinElectionAdminUpdatedByAdminID`),
  ADD KEY `I_joinElectionAdminElectionID` (`joinElectionAdminElectionID`);

--
-- Indexes for table `joinEmailVoter`
--
ALTER TABLE `joinEmailVoter`
  ADD KEY `I_joinEmailVoterEmailID` (`joinEmailVoterEmailID`),
  ADD KEY `I_joinEmailVoterVoterID` (`joinEmailVoterVoterID`);

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
-- Indexes for table `logElection`
--
ALTER TABLE `logElection`
  ADD PRIMARY KEY (`logID`),
  ADD KEY `I_logElectionID` (`logElectionID`),
  ADD KEY `I_logType` (`logType`),
  ADD KEY `I_logTypeSub` (`logTypeSub`),
  ADD KEY `I_typeSubtype` (`logType`,`logTypeSub`) USING BTREE,
  ADD KEY `I_electionType` (`logElectionID`,`logType`),
  ADD KEY `I_electionSubType` (`logElectionID`,`logTypeSub`),
  ADD KEY `I_electionTypeSubtype` (`logElectionID`,`logType`,`logTypeSub`),
  ADD KEY `I_logCode` (`logCode`),
  ADD KEY `I_logElectionSubTypeCode` (`logElectionID`,`logTypeSub`,`logCode`),
  ADD KEY `I_logElectionCode` (`logElectionID`,`logCode`) USING BTREE;

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
  ADD KEY `I_resultsElectionID` (`resultsElectionID`),
  ADD KEY `I_resultsTotalVoters` (`resultsTotalVoters`),
  ADD KEY `I_resultsTotalVotesCast` (`resultsTotalVotesCast`),
  ADD KEY `I_resultsSuperseedsResultID` (`resultsSuperseedsResultID`),
  ADD KEY `I_resultsSuperseeded` (`resultID`,`resultsSuperseedsResultID`),
  ADD KEY `I_resultsTotalVotersAndVotes` (`resultsTotalVoters`,`resultsTotalVotesCast`) USING BTREE,
  ADD KEY `I_resultsSuperseededByElection` (`resultsElectionID`,`resultsSuperseedsResultID`);

--
-- Indexes for table `resultsCash`
--
ALTER TABLE `resultsCash`
  ADD PRIMARY KEY (`resultID`),
  ADD KEY `I_resultsElectionID` (`resultsElectionID`),
  ADD KEY `I_resultsTotalVoters` (`resultsTotalVoters`),
  ADD KEY `I_resultsTotalVotesCast` (`resultsTotalVotesCast`),
  ADD KEY `I_resultsSuperseedsResultID` (`resultsSuperseedsResultID`);

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
-- AUTO_INCREMENT for table `election`
--
ALTER TABLE `election`
  MODIFY `electionID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
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
-- AUTO_INCREMENT for table `joinElectionAdmin`
--
ALTER TABLE `joinElectionAdmin`
  MODIFY `joinElectionAdminElectionID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `logElection`
--
ALTER TABLE `logElection`
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
-- AUTO_INCREMENT for table `resultsCash`
--
ALTER TABLE `resultsCash`
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
  ADD CONSTRAINT `ballotBox_ibfk_1` FOREIGN KEY (`ballotElectionID`) REFERENCES `election` (`electionID`) ON UPDATE CASCADE;

--
-- Constraints for table `candidate`
--
ALTER TABLE `candidate`
  ADD CONSTRAINT `candidate_ibfk_1` FOREIGN KEY (`candidateElectionID`) REFERENCES `election` (`electionID`) ON UPDATE CASCADE,
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
-- Constraints for table `election`
--
ALTER TABLE `election`
  ADD CONSTRAINT `election_ibfk_1` FOREIGN KEY (`electionID`) REFERENCES `electorate` (`voterElectionID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `election_ibfk_2` FOREIGN KEY (`electionCohortFilterID`) REFERENCES `cohortFilter` (`cohortFilterID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `election_ibfk_3` FOREIGN KEY (`electionRuleID`) REFERENCES `rules` (`ruleID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `election_ibfk_5` FOREIGN KEY (`electionUpdatedByID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `electorate`
--
ALTER TABLE `electorate`
  ADD CONSTRAINT `electorate_ibfk_1` FOREIGN KEY (`voterCohortSourceID`) REFERENCES `cohortFilter` (`cohortFilterID`) ON UPDATE CASCADE;

--
-- Constraints for table `email`
--
ALTER TABLE `email`
  ADD CONSTRAINT `email_ibfk_1` FOREIGN KEY (`emailElectionID`) REFERENCES `election` (`electionID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `email_ibfk_2` FOREIGN KEY (`emailCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `email_ibfk_3` FOREIGN KEY (`emailUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `joinElectionAdmin`
--
ALTER TABLE `joinElectionAdmin`
  ADD CONSTRAINT `joinElectionAdmin_ibfk_1` FOREIGN KEY (`joinElectionAdminUpdatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinElectionAdmin_ibfk_2` FOREIGN KEY (`joinElectionAdminCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinElectionAdmin_ibfk_3` FOREIGN KEY (`joinElectionAdminAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `joinElectionAdmin_ibfk_4` FOREIGN KEY (`joinElectionAdminElectionID`) REFERENCES `election` (`electionID`) ON UPDATE CASCADE;

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
  ADD CONSTRAINT `joinRuleAdmin_ibfk_1` FOREIGN KEY (`joinRuleAdminAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `logChanges`
--
ALTER TABLE `logChanges`
  ADD CONSTRAINT `logChanges_ibfk_1` FOREIGN KEY (`changeByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

--
-- Constraints for table `logElection`
--
ALTER TABLE `logElection`
  ADD CONSTRAINT `logElection_ibfk_1` FOREIGN KEY (`logElectionID`) REFERENCES `election` (`electionID`) ON UPDATE CASCADE;

--
-- Constraints for table `results`
--
ALTER TABLE `results`
  ADD CONSTRAINT `results_ibfk_1` FOREIGN KEY (`resultsElectionID`) REFERENCES `election` (`electionID`) ON UPDATE CASCADE;

--
-- Constraints for table `resultsCash`
--
ALTER TABLE `resultsCash`
  ADD CONSTRAINT `resultsCash_ibfk_1` FOREIGN KEY (`resultsElectionID`) REFERENCES `election` (`electionID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `resultsCash_ibfk_2` FOREIGN KEY (`resultsSuperseedsResultID`) REFERENCES `resultsCash` (`resultID`) ON UPDATE CASCADE;

--
-- Constraints for table `rules`
--
ALTER TABLE `rules`
  ADD CONSTRAINT `rules_ibfk_1` FOREIGN KEY (`ruleID`) REFERENCES `joinRuleAdmin` (`joinRuleAdminRuleID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `rules_ibfk_2` FOREIGN KEY (`ruleCountMethodID`) REFERENCES `countMethod` (`countMethodID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `rules_ibfk_3` FOREIGN KEY (`ruleCreatedByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `rules_ibfk_4` FOREIGN KEY (`ruleUpdateByAdminID`) REFERENCES `admin` (`adminID`) ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
