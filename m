From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH fixed] libibmad: Add MKey support to SMP requests via
	smp_mkey_get/set()
Date: Thu, 15 Mar 2012 17:27:12 -0700
Message-ID: <1331857632.17729.751.camel@auk75.llnl.gov>
References: <1331064594.10889.8.camel@auk75.llnl.gov>
	 <1331071949.17729.11.camel@auk75.llnl.gov>
	 <4F59FECE.4030107@dev.mellanox.co.il>
	 <20120309180459.GB29961@obsidianresearch.com>
	 <1331325175.17729.112.camel@auk75.llnl.gov>
	 <20120309210151.GA32353@obsidianresearch.com>
	 <1331341747.17729.253.camel@auk75.llnl.gov>
	 <20120313165020.GE9585@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120313165020.GE9585-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Tue, 2012-03-13 at 09:50 -0700, Jason Gunthorpe wrote: 
> On Fri, Mar 09, 2012 at 05:09:07PM -0800, Jim Foraker wrote:
> 
> > > I don't think using passwords for this sort of thing is really a good
> > > idea. It has been shown again and again the extrapolating keys from
> > > passwords does not stand up. Better to design around a large true
> > > random key (eg how bind's rndc works) than a password. In that
> > > instance truncated HMAC-SHA2-512 is entirely sufficient.
> 
> >      Large random strings end up having to be stored on disk, which may
> > be its own issue.  An attacker need not bother with a preimage attack at
> > all if the admin has copied a bulky keyfile to every host so as to make
> > their lives tenable.  "Well they shouldn't do that" may not be listened
> > to any better than "don't use weak passwords" has been.
> 
> Sure, but the only other options that have been brought up:
>   a) A config file of keys - that has to be copied too
>   b) completely random keys (in a file) - that has to be copied
>   c) A password - is weak to offline attacks, and if an attaker can
>      compromise a secure file then they can probably compromise the
>      tool that accepts the password from the admin.
> 
> So, it really isn't much of a difference at all.
     If the random keys in b) are stored in a file, then it simply
becomes a specific case of a).  A better way of phrasing the b) idea
would be, the SM generates the MKey, and if you wish to use it, your
only choice is to ask the SM for it.
     a) is certainly the same as your suggestion of a KDF with a long
string stored in a file, inasmuch as access to the file gives you quick
access to the keys.  Actually, it's a little worse with a) -- at
protection level 2, one could just send SMPs to a port iterating thru
all the mkeys in the file until one works, whereas with the KDF, you're
going to have to figure out its guid first (although that's still
probably not hard).
     I see the essential difference between "large random strings" and
"passwords" as being, where is keying material stored?  Regardless of
key length or strength, if the means of providing tools with the key is
sufficiently onerous, it will be worked around.  For passwords, that
means post-it notes under keyboards.  For keyfiles, that means copying
the file to a network filesystem and/or every host you might want to use
it from.  This works for rndc, because there's generally little reason
for domain admins to "stray" too far from a small number of DNS servers
for zone work.  My impression is that most IB admins want to be able to
run diagnostics from anywhere on the fabric, which implies much wider
deployment.  For the most part, if the keyfile ends up on every host,
it's not all that different than just using a single mkey across the
fabric.
     Certainly, if a text file can be compromised, a binary can too.
But the admin still has to go login to the compromised host and type the
password -- it's not there waiting to be taken on every host.  It's a
tradeoff of risks.
     Another option would be to use a "hybrid" distribution method, a la
HKDF.  Jason's suggestion is trivially close to the HKDF "expand" step
(given that output is less than hash size), either of which could be
used with appropriate host-specific information thrown in.  One could
optionally either read that master key directly from a keyfile, or
frontend it with one of the popular strengthening algorithms that
derives the master key from an easier-to-type/remember password.  Since
this strengthening only needs to be done once (unlike my earlier PBKDF2
suggestion), some serious CPU power could be devoted to it (seconds or
fractions thereof).  Combined with some good salting based on other
config file values, this would make it reasonably difficult to crack
most non-trivial passwords.

> In truth, we probably don't want to distribute anything to the
> hosts, but rely on some kind of authenticated transaction with the SA
> to fetch the mkey data. Eg the admin could use his kerberos login
> ticket to get the mkey of a node from the SA's database. (Of course, if
> you could steal the key file, you can probably steal a kerberos ticket
> as well..)
     This already exists, in the form of smkey-authenticated access to
SA PortInfo Records, and should probably be the preferred way of
fetching mkeys.  The question is, how do you determine mkeys when the SA
is hosed or otherwise inoperative?  If the answer is, "you don't," then
there's no reason to bother with a KDF over random assignment.

> > exploitable weaknesses in the code.  If we want to install a stronger
> > front door, it would behoove us to make sure the windows aren't already
> > the weakest link.
> 
> Unless someone gets a viable mkey model working none of the vendors
> are really going to care if their implementations are any good..
     That's the thing I'm hoping we can do here -- and where I think the
real concern is.  What particular key model to use is secondary to
determining what rules must be followed to ensure keys aren't
accidentally disclosed.
     For instance, one could imagine an attacker sitting on a
compromised host and changing the port guid of the HCA to the guid of
another host on the fabric.  I previously found code in OpenSM (although
I'm not seeing it at the moment) that looked like it would prevent this
attack, but only as a side effect.  This could fail however if a) the
attacker has managed to temporarily force the other HCA offline somehow,
b) the SM is not the current OpenSM and lacks this protection, or c) the
attacker convinces OpenSM to restart and gets initialized before the
legitimate HCA.  If the SM uses a mapping based solely on port guid, it
will generously hand a valid mkey over to the attacker.
     Adding LID to the keying information seems like it might be useful,
since it's harder for the attacker to control, but this doesn't help in
case c, since the impostor HCA will probably also get assigned the
legitimate HCA's LID, pulled from the guid2lid file.  Adding directed
route information seems like the hardest thing for an attacker to foil,
but I don't know that random clients can easily compute the directed
route the SM happens to use on all fabrics.
     I suspect that there are a number of cases like this lurking, which
we should try to understand so that we know whether a KDF (or
potentially any multi-key algorithm) can be securely deployed, and what
types of seed information will be needed to do so.

> >      B is potentially equivalent to using a perfectly secure KDF of some
> > sort.  "Perfect security" being what it is though, there may be some
> > folks who just don't want to risk any sort of preimage attack. 
> 
> These folks should be using pkey to prevent SMA's from even being
> contacted by an untrustable end port.
     SMPs are not bound by partitioning.  The SA will respect
partitioning WRT filtering results, but any host can talk directly to
any endpoint's SMA, even if the spec says they should refrain from doing
so.

> > A's security depends on how that config file is generated and
> > distributed.  Its key benefit is simplicity and configurability --
> > the admin gets free reign to generate keys however they want,
> > according to local needs and policy.  
> 
> That would almost certainly be a distaster, very few sites would have
> the skills to make this work, and IMHO, the gain over a secure
> generator is very negligible.
     My suspicion is that very few sites with sufficient clue to
successfully deploy IB are really going to trip horribly over
maintaining a text file.  Certainly, distributing a file with n keys is
no harder than distributing a file with one master key.  Also, "how it's
distributed" may mean, "it's only available to the SM, and other clients
lose."  A is a poor solution in terms of protecting users from
themselves.  A is a great solution in terms of flexibility and tool
simplicity.  It abdicates SMs and utils from fretting about policy, and
lets them concentrate on implementation.  It's yet another variant on
"do one thing and do it well."  That doesn't mean I'm keen to deploy it.

> > up to date with new guids as hardware comes and goes.  In my mind,
> > the most useful way forward is derived keys of some sort.  However,
> > I don't think it's necessarily a one-size-fits-all solution, and
> > supporting a few differing schemes seems reasonable to me.
> 
> It is always prudent to have some way to upgrade algorithms when doing
> crypto, but I really disagree that introducing complexity for
> something as minor as mkey is a good choice. People are far more
> likely to make a bad choice and get no meaningful security at all.
     Most likely, people will make no choice at all and use a default,
until they find it annoying or insufficient for their purposes.  I think
ideally we need as few methods as possible, as many as necessary, and a
really good default.  I won't claim to know how many are truly
necessary, but I can certainly see wanting two (a KDF of some form, and
random distributed via SA only), if not three ("legacy" single key).
None of these seem outrageous, and provide clear tradeoffs between
security and ease of use to meet different organization's needs.
     Pragmatically though, I don't think there's a necessity for
complete standardization.  There is great benefit to using common
methods, and that should be encouraged, but maintainers should implement
(or choose not to implement) policies in the manner they believe is in
the best interests of their users.  

     Jim
> 
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
