From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 09:18:42 -0500
Message-ID: <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170801141023.GM13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 01, 2017 at 05:10:23PM +0300, Leon Romanovsky wrote:
> On Tue, Aug 01, 2017 at 08:38:32AM -0500, Chien Tin Tung wrote:
> > On Tue, Aug 01, 2017 at 03:05:04PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > The commit cea05eadded0 ("IB/core: Add flow control to the portmapper netlink calls")
> > > changed netlink to be blocked for all RDMA clients. This workaround
> > > worked perfectly for portmapper, but is not correct for the whole
> > > NETLINK_RDMA family.
> >
> > Leon,
> >
> > I've already told you I'm opposed to the revert.  There is a patch that will work
> > with your usage of ibnl_unicast() but you chose to abandon that discussion on June 29, 2017
> > (RDMA/core: Add wait/retry version of ibnl_unicast).  Either you step up with good sound
> > technical evidence to convince me that patch won't work for you or you stop trying to
> > break existing functionality with this revert.
> 
> Chien,
> 
> You never explained us what exactly your original patch fixed and why it
> should be fixed in kernel and not in user space. I saw that our
> discussion wasn't useful and brought bad blood instead of good will,
> so I stepped out in waited for RDMA maintainer (Doug) step in.

Why do I need to explain the original patch?  It was accepted many kernels
ago.  Your questions on the original were based on false assumptions and
facts which I've proven over and over.  You are right in that I do
not want to revisit those either.  There is a patch that can solve
the problem you are facing but yet you insist on the revert.  This is
very puzzling to me.  You simply refuse to move this forward.  That
is your choice but revert is a no go for me.

> I never heard anything from Doug on the matter, so proceeded and
> resubmitted it.

Fine.  Your choice to resubmit and my choice to say no to the revert.

Chien


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
