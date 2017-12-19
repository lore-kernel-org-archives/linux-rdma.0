From: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA clean-ups and fixes
Date: Tue, 19 Dec 2017 10:28:28 -0500
Message-ID: <12801ec6-eb24-d9e1-f764-61f27bfd9ac6@Netapp.com>
References: <20171215015403.13776.46706.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171215015403.13776.46706.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

On 12/14/2017 08:55 PM, Chuck Lever wrote:
> Hi Anna-
> 
> This is the second series of NFS/RDMA client patches for v4.16.
> 
> This is a bunch of minor fixes and clean-ups in preparation for
> adding static trace points to the RPC-over-RDMA transport
> implementation. Please consider these for v4.16.

These patches look okay to me.  Thanks!

Anna

> 
> ---
> 
> Chuck Lever (16):
>       xprtrdma: Fix buffer leak after transport set up failure
>       xprtrdma: Fix backchannel allocation of extra rpcrdma_reps
>       xprtrdma: Eliminate unnecessary lock cycle in xprt_rdma_send_request
>       xprtrdma: Per-mode handling for Remote Invalidation
>       xprtrdma: Remove ri_reminv_expected
>       xprtrdma: Remove unused padding variables
>       xprtrdma: Initialize the xprt address string array earlier
>       xprtrdma: Remove another sockaddr_storage field (cdata::addr)
>       xprtrdma: Support IPv6 in xprt_rdma_set_port
>       xprtrdma: Move unmap-safe logic to rpcrdma_marshal_req
>       xprtrdma: buf_free not called for CB replies
>       xprtrdma: Split xprt_rdma_send_request
>       xprtrdma: Don't clear RPC_BC_PA_IN_USE on pre-allocated rpc_rqst's
>       xprtrdma: Replace all usage of "frmr" with "frwr"
>       xprtrdma: Remove usage of "mw"
>       xprtrdma: Introduce rpcrdma_mw_unmap_and_put
> 
> 
>  include/linux/sunrpc/xprtrdma.h   |    2 
>  net/sunrpc/xprtrdma/backchannel.c |   68 +++++---
>  net/sunrpc/xprtrdma/fmr_ops.c     |  155 +++++++++---------
>  net/sunrpc/xprtrdma/frwr_ops.c    |  317 +++++++++++++++++++------------------
>  net/sunrpc/xprtrdma/rpc_rdma.c    |   98 +++++------
>  net/sunrpc/xprtrdma/transport.c   |  102 +++++-------
>  net/sunrpc/xprtrdma/verbs.c       |  212 ++++++++++++++-----------
>  net/sunrpc/xprtrdma/xprt_rdma.h   |  112 +++++++------
>  8 files changed, 552 insertions(+), 514 deletions(-)
> 
> --
> Chuck Lever
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
