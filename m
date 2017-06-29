From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Add wait/retry version of ibnl_unicast
Date: Thu, 29 Jun 2017 10:02:49 -0500
Message-ID: <20170629150249.GA21856@ctung-MOBL3.amr.corp.intel.com>
References: <1498658565-3408-1-git-send-email-mustafa.ismail@intel.com>
 <20170628141211.GA16312@ctung-MOBL3.amr.corp.intel.com>
 <20170628153639.GF1248@mtr-leonro.local>
 <20170628203003.GA23300@ctung-MOBL3.amr.corp.intel.com>
 <20170629050436.GO1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170629050436.GO1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 29, 2017 at 08:04:36AM +0300, Leon Romanovsky wrote:
> On Wed, Jun 28, 2017 at 03:30:03PM -0500, Chien Tin Tung wrote:
> > On Wed, Jun 28, 2017 at 06:36:39PM +0300, Leon Romanovsky wrote:
> > > On Wed, Jun 28, 2017 at 09:12:11AM -0500, Chien Tin Tung wrote:
> > > > On Wed, Jun 28, 2017 at 09:02:45AM -0500, Mustafa Ismail wrote:
> > > > > Add a wait/retry version of ibnl_unicast, ibnl_unicast_wait,
> > > > > and modify ibnl_unicast to not wait/retry.  This eliminates
> > > > > the undesirable wait for future users of ibnl_unicast.
> > > > >
> > > > > Change Portmapper calls originating from kernel to user-space
> > > > > to use ibnl_unicast_wait and take advantage of the wait/retry
> > > > > logic in netlink_unicast.
> > > > >
> > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > ---
> > > > >  drivers/infiniband/core/iwpm_msg.c |  6 +++---
> > > > >  drivers/infiniband/core/netlink.c  | 12 +++++++++++-
> > > > >  include/rdma/rdma_netlink.h        | 10 ++++++++++
> > > > >  3 files changed, 24 insertions(+), 4 deletions(-)
> > > >
> > > > Please apply this patch instead of Leon's patch to revert
> > > > "IB/core: Add flow control to the portmapper netlink calls".
> > > >
> > > > Leon, we can work out names and parameters if this works for you.
> > >
> > > Chien,
> > >
> > > The names are less my worries with this patch. First of all, it misleads
> > > by using wait/retry naming, because it blocks and not waits.
> >
> > Nope.  It does a single shot retry and waits in a waitqueue.
> > Go look at netlink_unicast and in turn netlink_attachskb.  If you still
> > disagree, please flag specific code where it blocks.
> 
> I agree, it wouldn't block in your scenario. However will it work in more hostile
> environments?

The reason behind the original patch was to make it more tolerable to "hostile"
environments by giving it one more try allocate buffer to send the message.
So yes, it does work in more hostile environment.

> 
> For example, malicious user can open RDMA netlink socket directly (socket(...)),
> set sndtimeo to be MAX_SCHEDULE_TIMEOUT - 1 (LONG_MAX - 1)

How do you open the _kernel_ RDMA netlink socket directly from user-space and
set the timeout value?

> and send custom
> netlink messages right to your new _wait function. If I understand correctly
> from the code, it will add them to waitqueue and won't release skb till
> the end of processing.

The only caller of ibnl_unicast_wait is portmapper kernel client.  The call is
initiated from kernel not in response to user message so you did not understand
the code correctly.

> Will it cause to mark whole netlink socket as NETLINK_S_CONGESTED?

No.  It has nothing to do with the new function or relevant to this discussion.

> Will other users will be able to progress with their messages or they
> will need to wait till those _wait calls finish?

Short answer is yes.  With this patch other users of ibnl_unicast would not
get the retry/wait.  If you choose to use the wait version, obviousely you will
have retry/wait.  For the work you are doing, you should stick with ibnl_unicast
and there's no impact to your code.  This is the reason for the two functions as
proposed originally.

> > > The second, I disagree with solution in kernel for user space application which can't
> > > handle the netlink errors.
> >
> > There is no guarantee delivery nor blocking on send.  Like I mentioned above,
> > it is a 1 shot retry with a set wait time.  The code obviousely handles error
> > condition as it can happen.
> 
> So, can you please refresh our memory and explain again what exactly
> this patch is fixing if user-space handles errors correctly?

You assertion of user-space flaw is incorrect.  It is based on incorrect
conclusion of deadlock and blocking.

There is no deadlock and no blocking, period.


So what's the issue with taking this patch instead of the revert?

Chien

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
