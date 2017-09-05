From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 0/3] Final NFS/RDMA server patches proposed for v4.14
Date: Tue, 5 Sep 2017 14:59:21 -0400
Message-ID: <20170905185921.GB7557@fieldses.org>
References: <20170828190229.13285.76410.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170828190229.13285.76410.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks, applying for 4.14.

--b.

On Mon, Aug 28, 2017 at 03:05:57PM -0400, Chuck Lever wrote:
> Hi Bruce-
> 
> These patches allow svcrdma to adjust more precisely to the limits
> of the underlying RDMA device on the server.
> 
> These have been floating around for several months, and were posted
> a few weeks ago for review on linux-rdma. They should be ready for
> you to take for v4.14.
> 
> These are the final server-side patches I have for for v4.14 cycle.
> 
> 
> ---
> 
> Chuck Lever (3):
>       svcrdma: Limit RQ depth
>       rdma core: Add rdma_rw_mr_payload()
>       svcrdma: Estimate Send Queue depth properly
> 
> 
>  drivers/infiniband/core/rw.c             |   24 ++++++++++++++++++++
>  include/rdma/rw.h                        |    2 ++
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |   36 +++++++++++++++++++++---------
>  3 files changed, 51 insertions(+), 11 deletions(-)
> 
> --
> Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
