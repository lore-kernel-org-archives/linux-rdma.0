From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH fixed] libibmad: Add MKey support to SMP requests via
 smp_mkey_get/set()
Date: Tue, 13 Mar 2012 10:50:20 -0600
Message-ID: <20120313165020.GE9585@obsidianresearch.com>
References: <1331064594.10889.8.camel@auk75.llnl.gov>
 <1331071949.17729.11.camel@auk75.llnl.gov>
 <4F59FECE.4030107@dev.mellanox.co.il>
 <20120309180459.GB29961@obsidianresearch.com>
 <1331325175.17729.112.camel@auk75.llnl.gov>
 <20120309210151.GA32353@obsidianresearch.com>
 <1331341747.17729.253.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1331341747.17729.253.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 09, 2012 at 05:09:07PM -0800, Jim Foraker wrote:

> > I don't think using passwords for this sort of thing is really a good
> > idea. It has been shown again and again the extrapolating keys from
> > passwords does not stand up. Better to design around a large true
> > random key (eg how bind's rndc works) than a password. In that
> > instance truncated HMAC-SHA2-512 is entirely sufficient.

>      Large random strings end up having to be stored on disk, which may
> be its own issue.  An attacker need not bother with a preimage attack at
> all if the admin has copied a bulky keyfile to every host so as to make
> their lives tenable.  "Well they shouldn't do that" may not be listened
> to any better than "don't use weak passwords" has been.

Sure, but the only other options that have been brought up:
  a) A config file of keys - that has to be copied too
  b) completely random keys (in a file) - that has to be copied
  c) A password - is weak to offline attacks, and if an attaker can
     compromise a secure file then they can probably compromise the
     tool that accepts the password from the admin.

So, it really isn't much of a difference at all.

In truth, we probably don't want to distribute anything to the
hosts, but rely on some kind of authenticated transaction with the SA
to fetch the mkey data. Eg the admin could use his kerberos login
ticket to get the mkey of a node from the SA's database. (Of course, if
you could steal the key file, you can probably steal a kerberos ticket
as well..)

> exploitable weaknesses in the code.  If we want to install a stronger
> front door, it would behoove us to make sure the windows aren't already
> the weakest link.

Unless someone gets a viable mkey model working none of the vendors
are really going to care if their implementations are any good..

>      B is potentially equivalent to using a perfectly secure KDF of some
> sort.  "Perfect security" being what it is though, there may be some
> folks who just don't want to risk any sort of preimage attack. 

These folks should be using pkey to prevent SMA's from even being
contacted by an untrustable end port.

> A's security depends on how that config file is generated and
> distributed.  Its key benefit is simplicity and configurability --
> the admin gets free reign to generate keys however they want,
> according to local needs and policy.  

That would almost certainly be a distaster, very few sites would have
the skills to make this work, and IMHO, the gain over a secure
generator is very negligible.

> up to date with new guids as hardware comes and goes.  In my mind,
> the most useful way forward is derived keys of some sort.  However,
> I don't think it's necessarily a one-size-fits-all solution, and
> supporting a few differing schemes seems reasonable to me.

It is always prudent to have some way to upgrade algorithms when doing
crypto, but I really disagree that introducing complexity for
something as minor as mkey is a good choice. People are far more
likely to make a bad choice and get no meaningful security at all.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
