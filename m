From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Fri, 12 Jan 2018 09:58:43 -0700
Message-ID: <20180112165843.GC15974@ziepe.ca>
References: <20180112055842.23125-1-leon@kernel.org>
 <20180112141524.GA16256@ctung-MOBL3.amr.corp.intel.com>
 <20180112150602.GN15760@mtr-leonro.local>
 <20180112153402.GA12452@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112153402.GA12452-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 09:34:02AM -0600, Chien Tin Tung wrote:
> On Fri, Jan 12, 2018 at 05:06:02PM +0200, Leon Romanovsky wrote:
> > On Fri, Jan 12, 2018 at 08:15:24AM -0600, Chien Tin Tung wrote:
> > > On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:
> > > > Hi,
> > > >
> > > > There is small set of fixes targeted for rdma-rc.
> > >
> > > For RC?  Are these fixing regressions?  We are already in RC7.
> > 
> > Jason was clear last time, he wants to work like Dave, fixes go always
> > without any relation to -RC.
> 
> I won't claim to know Dave's process since I don't drectly submit
> patches to Netdev.  However given Dave's history with the kernel,
> I highly doubt he would accept patches late in RC cycle that would
> jeopardize a kernel release.

Well, my definition of 'fixes' is pretty high. For instance fixing a
performance regression is not a 'fix', IMHO.

Fixing a user triggerable out-of-bound oops would be though - as in
these modern times I'm sure someone smart can escalate stuff like that
to a full security compromise of a trusted boot system..

This is why I keep asking for good commit messages for -rc
patches. Explain why you think this deserves to be in -rc, in terms
other people can understand:

 - Can userspace trigger an oops or memory corruption? How?
 - Can the kernel oops or memory corrupt in a actual demonstrated way
   (not theoretical)?
 - Did this actually get hit durring real world testing?
 - Could this escalate to some kind of security issue for a
   trusted-boot kernel?
 
etc.

So, when I've said 'fixes should go to rc', I mean fixes that qualify
as important here:

...  Bugs that have always existed are not regressions, so
     only push these kinds of fixes if they are important.  ...

and I haven't ment 'just anything with a Fixes: tag'.

If I think I can't defend why your patch is 'important' to Linus,
then the likely hood of taking it decreases as we move along the rc
cycle. It is up to the submitter to write a good commit message.

Doug also likes to see patches with a small LOC late in the cycle.

eg if we look at the recent patches:
 - Two security related issues for SRP
 - A locking issue leading to user triggerable memory corruption
   (eg add/remove rxe devices in parallel with netlink queries)
 - In-kernel oops under error situations potentially triggerable
 - Real world oops caused by SE Linux checking, hit during testing
 - A issue that damages our potential future ABI compatability in uverbs
 - User triggerable kernel data corruption due to missing locking

etc..

and some counter examples that went to -next:

- 'RDMA/cma: Fix rdma_cm path querying for RoCE'
  The uAPI has been broken here since v4.12 and nobody noticed
  The use case in user space is very obscure
  Probably would have taken this to -rc around rc1/2/3
- 'net/mlx5: Fix race for multiple RoCE enable'
  This has been broken since v4.13
  Unclear from commit message if this is theoretical, user
  triggerable, or seen in the real world
  Could have been -rc if the risks were identified as real world
- 'IB/{hfi1, qib}: Fix a concurrency issue with device name in
  logging'
  Seems kinda -rc worthy but the LOC is high, the bug has existed
  for soemthing like a decade, and the commit message doesn't
  explain why computing the wrong string is 'important'. Doesn't
  seem to be a oops or security issue.

At the very least this is the best thinking I've come up with after
talking to several people - advice welcome of course.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
