# Vote validation

Vote validation allows a voter to review the complete vote they cast as stored in the "Ballot box" to confirm that what was recorded matches the choices the made.

> **Note:** It could, in theory, allow a voter to recast their vote with a different choice of options (while voting is still open). However, there is no plan to implement that.

## How validation works

### When the voter logs in and votes:

1. A recreatable, one way, sha256 hash is made combing:
   * The voter's log in credentials,
   * The application's "salt" and
   * The full details of their voter info
2. The hash becomes the _voter salt_
3. When the voter casts their vote (and it is confirmed as valid) a new hash is created using
   * A random number provided by the system and
   * The _voter salt_
   * The micro-time the vote was received and
   * The details of the vote itself and
   * Whatever other entropy is available (e.g. request user agent, IP, etc)

   This new hash becomes the _verification key_ the voter supplies when verifying their vote. But is never persisted to the database
4. The _voter salt_ and _verification key_ are combined to create an _identifier_ which is stored with the vote
5. The _voter salt_, _verification key_, _identifier_ and the details of the vote itself are combined to form a checksum of the vote which is stored with the voters details
6. The _verification key_ is displayed to the voter as part of a URL when the vote is confirmed, along with a note saying that the key is never stored on the system and without it, the vote cannot be verified.
   E.g. https://my-election.org/election_path?key=[_verification key_]

### When a voter verifies their vote