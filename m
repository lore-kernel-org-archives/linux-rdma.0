From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Thu, 03 Aug 2017 08:22:53 -0400
Message-ID: <1501762973.117042.7.camel@redhat.com>
References: <20170801120536.540-1-leon@kernel.org>
         <20170801120536.540-2-leon@kernel.org>
         <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
         <20170801141023.GM13672@mtr-leonro.local>
         <1501696661.109555.6.camel@redhat.com>
         <20170802185405.GE13672@mtr-leonro.local>
         <1501719575.117042.4.camel@redhat.com>
         <20170803051032.GF13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170803051032.GF13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-03 at 08:10 +0300, Leon Romanovsky wrote:
> On Wed, Aug 02, 2017 at 08:19:35PM -0400, Doug Ledford wrote:
> > On Wed, 2017-08-02 at 21:54 +0300, Leon Romanovsky wrote:
> > > 
> 
> Are you kidding me? Reply to the series from the maintainer that "it
> is
> postponed till both sides are happy" is too much for you?

I was a bit busy the last few weeks fixing a mess of my own.  And I'm
still extremely busy working on getting our test cluster in Red Hat
back operational....it's been down now for almost four weeks in total
(well, planning and downtime has now extended to four weeks, only three
weeks have been downtime).  I don't delete emails from my linux-rdma
folder until they've been fully processed and won't be needed any more.
 Between the problems I created for myself by missing the merge window,
and the downtime of the Red Hat cluster I've been working on, I have
1500 emails in that folder.  So, yes, I punted on what looked like a
squabble and worked on other stuff.

> > 
> > > It is his responsibility to drive to the resolution for the
> > > important
> > > core patches.
> > 
> > This was really only a core patch of minor importance to begin
> > with,
> > and once Chien wrote a patch to give you what you wanted without
> > breaking the existing user space packages, it really became a
> > trivial
> > core patch.  Hardly worthy of pulling the "I demand you make a
> > maintainer call" card.
> 
> No, Chien never explained why he needs this fix and what this fix is
> actually fixing.

I understood his explanation.  He wasn't as clear as he could have
been, but then again he's ESL just like you (English as Second
Language, it's the term they use in my wife's job for situations like
this).  I'd be happy to explain if it will help.

> > 
> > > This revert was discussed for something like month+, as an
> > > outcome of
> > > it, Chien reviewed and sent much more improved version of their
> > > original
> > > patch, without socket timeout and with minimal blocking places.
> > 
> > That would have been a perfect moment for you to work with Chien to
> > take his patch as the first of your series instead of sticking to
> > the
> > revert.
> 
> I can't work on the solution if other side didn't explain why it is
> needed.

He's ESL just like you are, with both of you I expect unintentional
shortcomings in explanations, and when that happens I attempt to
clarify for the sake of all parties.  He tried, as best he could, to
give you what you asked for.  I got it, if you need help understanding
it I'd be glad to help.

> > 
> > > So please, don't say "school yard",
> > 
> > I stand by my statement.  So many school yard arguments make no
> > real
> > sense, and given you had every opportunity to resolve this problem
> > with
> > a community viable alternative patch, and in so doing would have
> > actually fulfilled the edict that "we don't break user space"
> > instead
> > of violating it as you were doing, the metaphor seems entirely
> > appropriate.
> 
> And the fact that the reverted patch broke the user space behavior
> before, didn't bother you?

Breakage how?  If you mean that the fact that it broke the behavior
pattern you expected, that breakage doesn't really exist until your
patches are accepted, so it's not really broke right now, it just isn't
what you want.

> > 
> > >  especially after your silence.
> > 
> > I want to address this separate from everything else.
> > 
> > With as much hostility and accusations as I saw fly on the original
> > submission, several things happened:
> > 
> > 1) The submission got bumped to the bottom of my queue because
> > settling
> > squables is not the sort of thing maintainers want to deal with.
> > 2) The submission got bumped to the bottom of my queue so you would
> > have a chance to work things out and come to a mutually agreed
> > solution.  Such resolution is in the best interest of both the
> > community and the technical correctness of the fix as, generally,
> > an
> > agreed upon fix will have had more community input and refinement
> > prior
> > to being accepted.
> > 3) The submission will get put on hold for a short while regardless
> > of
> > points 1 and 2 just so you have a moment to settle down, rethink
> > things
> > a little bit, and decide if you really want to pull that "put the
> > maintainer in this position" trigger.  Have you really examined all
> > the
> > possible solutions?  Is there really no superior alternative?  Is
> > there
> > really no way to come to agreement with the other community
> > member(s)
> > you are disagreeing with?
> 
> And did you go to the mailing list and write something like that "the
> series on hold till solution will be found", like it was with hfi1-
> vnic
> and ipoib?

No, and if you recall, there was a decent period of silence on that
before I told you guys to work it out too.

> The Answer is no, you didn't do it, you silently ignored discussion,
> understood
> that the series is stuck and continued down the road.
> 
> > 
> > In the end, there will always be those things that a maintainer
> > will
> > simply need to make a call on because there won't be a clear right
> > or
> > wrong side and it just becomes a judgment call.  But I don't think
> > this
> > one even came close to being that unclear, so again I'm confused by
> > your insistence on going this route instead of just working things
> > out
> > with Chien.
> 
> Because, I truly believe that they proposed the nasty hack, which
> doesn't fix the real problem - inability to deal with losses of
> netlink
> messages.

In so much as the iwpmd needs to be modified to do a resync, I agree
with you.  But, the fix they made caused the system to be "reliable
enough" that the problem more or less disappeared.  It is true that,
given enough load, the problem could resurface, but that hasn't
happened yet in the real world.

However, iwpmd is part of rdma-core now, so *anyone* can fix it to do
the resyncs as needed (and I don't know, maybe it does, I just did a
quick grep for ENOBUFS to see if they capture that error and do a
resync on it, and saw no hits for that with grep).

> And I realized it after I started to work on RDMA netlink and read
> RFC
> and design documents and assumptions about netlink.
> 
> In my opinion, it is one of the small examples why RDMA subsystem is
> so
> hated. It is full of "custom" solutions to known problems and many of
> those "custom" solutions are mix of hacks and band aids.

I don't believe this solution was as custom as you say it is.  The
netlink core supports it and we aren't the only consumer.  That makes
it a bit more generic than you paint it here IMO.

> There is no need to reply on it.
> It is my personal opinion and my view of the RDMA subsystem as a
> newcomer.
> 
> I'm OOO till Monday.
> Happy weekends.
> 
> > 
> > 
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >     GPG KeyID: B826A3330E572FDD
> >     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> > 2FDD
> > 
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
