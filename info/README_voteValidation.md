# Vote validation

Vote validation allows a voter to review the complete vote they cast,
as stored in the "Ballot box", to confirm that what was recorded
matches the choices the made.

The aim is to create a safe, anonymous way for votes to be varified
by the voter who cast that vote and to prevent tampering with votes
while stored in the database.

> __Note:__ It could, in theory, be used allow a voter to recast
> their vote with a different choice of options (while voting is
> still open). However, there is no plan to implement that.

-----

> __NOTE:__ It doesn't prevent against tampering with votes on the
> client side or in transit.

> __NOTE ALSO:__ It doesn't prevent voters being cooerced to login to
> show their vote.

-----

## How validation works

### When the voter logs in and votes:

1. A recreatable, one way, sha256 hash is made by combing:
   * The voter's log in credentials,
   * The application's "salt" and
   * The parts of the voter's info (that will not change) as stored
     with their electorate details.

2. The hash becomes the _voter salt_

3. When the voter casts their vote (and it is confirmed as valid) a
   new hash is created using
   * A random number provided by the system and
   * The _voter salt_
   * The micro-time the vote was received and
   * The details of the vote itself and
   * Whatever other entropy is available
     (e.g. request user agent, IP, etc)

   This new hash becomes the _verification key_ the voter supplies
   when verifying their vote. But is never persisted to the database

4. The _voter salt_ and _verification key_ are combined to create an
   _identifier_ which is stored with the vote in the "Ballot box"

5. The _voter salt_, _verification key_, _identifier_ and the details
   of the vote itself are combined to form a checksum of the vote
   which is stored with the voters details

6. The _verification key_ is displayed to the voter as part of a URL
   when the vote is confirmed, along with a note saying that the key
   is unique, it is not stored on the system and without it, the vote
   cannot be verified.
   
   e.g. `https://my-election.org/election_path?key=[_verification key_]`

### When a voter verifies their vote

1. The voter goes to the URL the saved when they voted e.g.

   e.g. `https://my-election.org/election_path?key=[_verification key_]`
2. A one way, sha256 hash is made the combing:
   * The voter's log in credentials,
   * The application's "salt" and
   * The parts of the voter's info (that will not change) as stored
     with their electorate details.

   (recreating the _voter salt_ from casting the vote)

3. The _voter salt_ and _verification key_ are combined to create the
   _identifier_ which is used to match the vote in the "Ballot box"

4. Attempt to retrieve the vote The vote is retrieved
   1. If the _identifier_ is found in the "Ballot box" retrieve it
   2. If no _identifier_ could be found warn the voter that it was
      not possible to verify, one way, or the other, whether their
      vote was valid.

5. The _voter salt_, _verification key_, _identifier_ and the details
   of the vote itself are combined to form a _checksum_ of the vote

6. The created _checksum_ is compared with the checksum in the voter's
   details
   1. If the created _checksum_ and stored _checksum_ match, details
      of the cast vote are displayed along with confirmation that the
      vote has _not_ been tampered.

      > If there is a risk of voters being coerced into showing their
      > votes against their will, details of the cast vote can be
      > omitted, instead only showing that the confirmation has not
      > been tampered with.

   2. If the created _checksum_ and stored _checksum_ __do not__
      match, a warning is shown that the vote had changed since it
      was stored in the DB
