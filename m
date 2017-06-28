From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Add wait/retry version of ibnl_unicast
Date: Wed, 28 Jun 2017 09:12:11 -0500
Message-ID: <20170628141211.GA16312@ctung-MOBL3.amr.corp.intel.com>
References: <1498658565-3408-1-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498658565-3408-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 28, 2017 at 09:02:45AM -0500, Mustafa Ismail wrote:
> Add a wait/retry version of ibnl_unicast, ibnl_unicast_wait,
> and modify ibnl_unicast to not wait/retry.  This eliminates
> the undesirable wait for future users of ibnl_unicast.
> 
> Change Portmapper calls originating from kernel to user-space
> to use ibnl_unicast_wait and take advantage of the wait/retry
> logic in netlink_unicast.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/iwpm_msg.c |  6 +++---
>  drivers/infiniband/core/netlink.c  | 12 +++++++++++-
>  include/rdma/rdma_netlink.h        | 10 ++++++++++
>  3 files changed, 24 insertions(+), 4 deletions(-)

Please apply this patch instead of Leon's patch to revert
"IB/core: Add flow control to the portmapper netlink calls".

Leon, we can work out names and parameters if this works for you.

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
