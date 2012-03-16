From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH fixed] libibmad: Add MKey support to SMP requests via
 smp_mkey_get/set()
Date: Fri, 16 Mar 2012 00:19:44 -0600
Message-ID: <20120316061943.GA15978@obsidianresearch.com>
References: <1331064594.10889.8.camel@auk75.llnl.gov>
 <1331071949.17729.11.camel@auk75.llnl.gov>
 <4F59FECE.4030107@dev.mellanox.co.il>
 <20120309180459.GB29961@obsidianresearch.com>
 <1331325175.17729.112.camel@auk75.llnl.gov>
 <20120309210151.GA32353@obsidianresearch.com>
 <1331341747.17729.253.camel@auk75.llnl.gov>
 <20120313165020.GE9585@obsidianresearch.com>
 <1331857632.17729.751.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1331857632.17729.751.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 15, 2012 at 05:27:12PM -0700, Jim Foraker wrote:

> for zone work.  My impression is that most IB admins want to be able to
> run diagnostics from anywhere on the fabric, which implies much wider
> deployment.  For the most part, if the keyfile ends up on every host,
> it's not all that different than just using a single mkey across the
> fabric.

It is really hard to make something that is reistant to a potentially
compromised host while still allowing that hose to access a shared
secret key.. That is a loosing battle. People who care about MKey
security have to give up runing diags on potentially compromised hosts.

>      Another option would be to use a "hybrid" distribution method, a la
> HKDF.  Jason's suggestion is trivially close to the HKDF "expand"
> step

Specifying HMAC-something-something as the MKey generator and then
providing an option to produce the fixed length HMAC key via password
expander algorithm seems reasonable to me. People who want that can
generate their key blob file from a password, or do it on the fly in a
tool.

The HMAC-something-something key file could even be password encrypted
for use by the diags, and this could be done in a diag-tool-specific
manner. The SM need not care about that.

These address both of your concerns while keeping the SM operation,
and the actual generation of the MKey straightforward and something we
should be able to agree on.

> > In truth, we probably don't want to distribute anything to the
> > hosts, but rely on some kind of authenticated transaction with the SA
> > to fetch the mkey data. Eg the admin could use his kerberos login
> > ticket to get the mkey of a node from the SA's database. (Of course, if
> > you could steal the key file, you can probably steal a kerberos ticket
> > as well..)

>      This already exists, in the form of smkey-authenticated access to
> SA PortInfo Records, and should probably be the preferred way of

I'm not sure SMKey is well specified enough for this, and even if it
is, you've just re-created the global well known mkey problem.

> fetching mkeys.  The question is, how do you determine mkeys when the SA
> is hosed or otherwise inoperative?  If the answer is, "you don't," then
> there's no reason to bother with a KDF over random assignment.

My preference for a algorithmic derivation and outright rejection of
other options is due to recovery and clustering of the SM. It should
not be possible to loose or corrupt the SM MKey database, even when it
is being dynamically modified as nodes come and go. The simplest
approach is via a GUID hashing scheme, eg HMAC, or something
functionally analogous.

Considering the case of a clustered SM, it is simply too much
complexity for no real gain to make MKey into an actual transactional
database, which is pretty much required for any other scheme.

> > > exploitable weaknesses in the code.  If we want to install a stronger
> > > front door, it would behoove us to make sure the windows aren't already
> > > the weakest link.
> > 
> > Unless someone gets a viable mkey model working none of the vendors
> > are really going to care if their implementations are any good..

>      That's the thing I'm hoping we can do here -- and where I think the
> real concern is.  What particular key model to use is secondary to
> determining what rules must be followed to ensure keys aren't
> accidentally disclosed.

>      For instance, one could imagine an attacker sitting on a
> compromised host and changing the port guid of the HCA to the guid of
> another host on the fabric.  I previously found code in OpenSM (although
> I'm not seeing it at the moment) that looked like it would prevent this
> attack, but only as a side effect.  This could fail however if a) the
> attacker has managed to temporarily force the other HCA offline somehow,
> b) the SM is not the current OpenSM and lacks this protection, or c) the
> attacker convinces OpenSM to restart and gets initialized before the
> legitimate HCA.  If the SM uses a mapping based solely on port guid, it
> will generously hand a valid mkey over to the attacker.

Yes, you are absolutely right. A compromised end port discloses many
mkeys without heroics on the part of the SM to prevent that.

A SM would have to tie port GUIDs to valid locations within the
fabric, which would greatly complicate administration of some classes
of system.

Or the spec has to be updated to use real crypto, and out of band
keying to secure SMPs. (This would not be a bad thing...)

>      Adding LID to the keying information seems like it might be useful,
> since it's harder for the attacker to control, but this doesn't help in
> case c, since the impostor HCA will probably also get assigned the
> legitimate HCA's LID, pulled from the guid2lid file. 

Yes, the LID doesn't really add value.

> Adding directed route information seems like the hardest thing for
> an attacker to foil, but I don't know that random clients can easily
> compute the directed route the SM happens to use on all fabrics.

The SM would have to essentially tie a port GUID to being connected to
a specific switch port, and an admin would have to intervene if things
are re-cabled.

We can't include directed route information in the MKey value, if you
re-cable then you have to reset the MKeys, which is not the intended
use-model for MKey.

>      I suspect that there are a number of cases like this lurking, which
> we should try to understand so that we know whether a KDF (or
> potentially any multi-key algorithm) can be securely deployed, and what
> types of seed information will be needed to do so.

Unfortunately I don't think the spec was really intended to be secure
against a rouge end point..

> > These folks should be using pkey to prevent SMA's from even being
> > contacted by an untrustable end port.
>      SMPs are not bound by partitioning.  The SA will respect
> partitioning WRT filtering results, but any host can talk directly to
> any endpoint's SMA, even if the spec says they should refrain from doing
> so.

... case in point. I think you are right (I was thinking of GMPs, eg
for perfmon). Adding PKey filtering for SMPs ultimately would be of
more help than all this mkey stuff.
 
> > > A's security depends on how that config file is generated and
> > > distributed.  Its key benefit is simplicity and configurability --
> > > the admin gets free reign to generate keys however they want,
> > > according to local needs and policy.  
> > 
> > That would almost certainly be a distaster, very few sites would have
> > the skills to make this work, and IMHO, the gain over a secure
> > generator is very negligible.
>      My suspicion is that very few sites with sufficient clue to
> successfully deploy IB are really going to trip horribly over
> maintaining a text file.  Certainly, distributing a file with n keys is
> no harder than distributing a file with one master key. 

Maintaing a text file with N securely created random numbers mapped
exactly to GUIDs in the fabric, such that GUIDs are in the text file
before joining the fabric and once a line it added it is never
lost, removed or changed? Kept perfectly in sync across all SMs in the
cluster? That is a pretty aweful problem to saddle someone with.

You've already pointed out many real ways the mkey can be exposed, so
I'm not seeing the point in overkilling the generation of the
key. Or really even a reason to provide choice. Nobody would ever
attack the source of MKeys when there are much easier avenues to
approach.

The only value is going from a well known single mkey to port-unique
mkeys, and I think that should be the only choice presented to the
user.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
