# openElection

`openElection` aims to provide a complete, flexible platform for managing elections and referenda.

This project is based on lessons learned from maintaining the ACU's (Australian Catholic University) internal, home grown election system.

## Definitions

* __Electorate:__ A group of users who can vote in a given election
* __Ballot paper:__ The vote cast by a single voter defining their choice/ranking of candidates in a given election (stored as a row in a database
* __Ballot box:__ the complete list of all _ballot papers_ (votes cast) in a given election

## Features

### Manage the whole election cycle

There are many steps for an election from working out who can vote to taking nominations and collecting votes to counting the votes. Most of these things are the same year in year out for every election. Many of them can be automated.

1. Election admin creates the election/referendum defining
   * the _electorate_,
   * the count method,
   * the date voting starts and for how long votes will be accepted
  
   Plus a number of other details

2. Nominations open automatically as per configuration

3. Emails are sent to all voters inviting them to nominate (if required)

4. Voters can nominate to stand for election via the system

5. Voters can _second_ a nomination (if required) via the system

6. A voter registered with a party can "_endorse_" a cadidate for
   that party (if required) via the system

8. Reminder email is sent to voters about nominations (if required)

9. Nominations close automatically

10. Emails are sent to all voters inviting them to vote (if required)

11. Voting opens automatically

12. Voters can vote during the voting period

13. Emails are sent to all voters who have not yet voted reminding
    them to vote before voting closes (if required)

15. Voting closes automatically

16. Votes are automatically counted when voting closes

17. Results are automatically posted when counting is complete

18. Election/referendum is archived automatically as per configuration

### Reusable election rule sets

Many elections share the same requirements/rules: e.g. who makes up the voting cohort, what the count method is. When candidates can nominate for election etc.

openElection provides a way of persisting or sharing rules that govern elections/referenda to make it easier to re-run elections/referenda again and again.

__Rules include:__

* Duration of nomination period _(`14 days`)_
* Duration of campaign period (time between close of nominations and opening of voting) _(`28 days`)_
* Duration of voting period _(`14 days`)_
* Duration of results period (time between when voting closes and when the "_Ballot box_" is archived) _(`30 days`)_
* Number of positions being elected _(`1`)_
* Number of seconders required before a candidate is eligible to stand _(`0`)_
* Default returning officer
* Count method
* Count method options
* Allow vote validation _(`yes`)_
* Allow vote recasting _(`no`)_

### Voter sources & Reusable cohorts filters

A large institution may have a number of distinct groups of members, with each group being managed by a different system. `openElection` provides an API to allow for custom sources to be used for filtering and importing voters into a voting cohort.

There are many instances when the same group of voters are asked to vote for different positions or on different issues. `openElection` provides a way of storing the filters used to specify who can be in a voting cohort even though who fits the voting cohort can change at any time.

### Manage nominations

`openElection` assumes that only voters in a given cohort can nominate to be elected in a given election. Voters can nominate via `openElection`, submitting a brief statement, a link to their campaign website and a photo.

Where candidates are required to have other voters second their nomination `openElection` can manage seconding.

Where elections are contested by official parties `openElection` allows for "_endorsing_" candidates (although I'm not sure how this will work in practice.)

By having the system manage nominations and candidates you minimise the risk of inelegable candidates standing for election.

### Multiple vote counting methods

There are many different ways of counting votes. `openElection` provides an API for ingesting "_ballot papers_" in the form of a 2D array, counting the votes the producing both a simple result listing the winner(s) and a detailed result showing a breakdown votes were assigned to each candidate.

Out of the box `openElection` comes with four count methods:
* [First passed the post](https://en.wikipedia.org/wiki/First-past-the-post_voting) (no preferences)
* [Instant-runoff voting](https://en.wikipedia.org/wiki/Instant-runoff_voting) (IRV) Also called [Two Party Preferred](https://en.wikipedia.org/wiki/Two-party-preferred_vote) (TPP) or Two Candidate Preferred (TCP) ([AEC](https://www.aec.gov.au/voting/counting/hor_count.htm) - Australian Electoral Commission)
* [AEC Proportional representation](https://www.aec.gov.au/voting/counting/senate_count.htm) (used for count votes for Australian Senate seats)
* [Borda count](https://en.wikipedia.org/wiki/Borda_count) points based counting method.

But it supports adding others.

### Email communications

### Automated steps

### Data integrity & Vote validation
