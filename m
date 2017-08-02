From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 02 Aug 2017 13:57:41 -0400
Message-ID: <1501696661.109555.6.camel@redhat.com>
References: <20170801120536.540-1-leon@kernel.org>
         <20170801120536.540-2-leon@kernel.org>
         <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
         <20170801141023.GM13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801141023.GM13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-01 at 17:10 +0300, Leon Romanovsky wrote:
> On Tue, Aug 01, 2017 at 08:38:32AM -0500, Chien Tin Tung wrote:
> > On Tue, Aug 01, 2017 at 03:05:04PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > 
> > > The commit cea05eadded0 ("IB/core: Add flow control to the
> > > portmapper netlink calls")
> > > changed netlink to be blocked for all RDMA clients. This
> > > workaround
> > > worked perfectly for portmapper, but is not correct for the whole
> > > NETLINK_RDMA family.
> > 
> > Leon,
> > 
> > I've already told you I'm opposed to the revert.  There is a patch
> > that will work
> > with your usage of ibnl_unicast() but you chose to abandon that
> > discussion on June 29, 2017
> > (RDMA/core: Add wait/retry version of ibnl_unicast).  Either you
> > step up with good sound
> > technical evidence to convince me that patch won't work for you or
> > you stop trying to
> > break existing functionality with this revert.
> 
> Chien,
> 
> You never explained us what exactly your original patch fixed and why
> it
> should be fixed in kernel and not in user space. I saw that our
> discussion wasn't useful and brought bad blood instead of good will,
> so I stepped out in waited for RDMA maintainer (Doug) step in.
> 
> I never heard anything from Doug on the matter, so proceeded and
> resubmitted it.

What makes you think *I* want to be in the middle of a school yard
squabble like this?

Regardless,  here's what I think:

1) The blocking/timeout functionality that Chien is using is in the
netlink core, not something he grafted onto netlink himself.  Since
it's a core netlink feature, I see no reason he shouldn't be allowed to
use it.

2) We don't break API for user space programs.  Reverting this could
have a significant deleterious influence on programs already in the
wild.  While those programs should resync on a failure, clearly,
failure is much more frequent without this patch than with it, and as a
resync can be expensive, it is a judgment call whether it is preferable
to resync more frequently because of dropped packets, or utilize a
backlog queue to reduce the frequency of resyncs.  Clearly, Intel is of
the position that the backlog queue is worth avoiding the resyncs.

3) Chien submitted a patch that would allow just the iwpmd to get the
behavior they find preferable, while allowing Leon's new code to get
the behavior Leon wants.

Given that #1 and #2 are true and that #3 provides a reasonable
solution, the revert is rejected.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
