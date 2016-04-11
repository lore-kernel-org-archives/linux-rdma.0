From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/18] NFS/RDMA client patches for 4.7
Date: Mon, 11 Apr 2016 16:11:48 -0400
Message-ID: <0CBC734B-4EBC-40E2-943C-DA8A92A9C70A@oracle.com>
References: <20160411200323.20531.8893.stgit@manet.1015granger.net>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160411200323.20531.8893.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 11, 2016, at 4:10 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> One larger change: Attempt to fence memory regions after a signal
> interrupts a synchronous RPC. This should prevent a server from
> writing a reply into a client's memory after the memory has been
> released.
> 
> In addition, the following changes and fixes:
> 
> - Use new ib_drain_qp() API
> - Advertise max size of NFSv4.1 callbacks on RPC/RDMA
> - Prevent overflowing the server's receive buffers
> - Read list + Reply chunk (to support krb5i and krbp on RPC/RDMA)
> - Detect connection loss sooner

Forgot to add:

Available in the "nfs-rdma-for-4.7" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.7


> ---
> 
> Chuck Lever (18):
>      sunrpc: Advertise maximum backchannel payload size
>      xprtrdma: Bound the inline threshold values
>      xprtrdma: Limit number of RDMA segments in RPC-over-RDMA headers
>      xprtrdma: Prevent inline overflow
>      xprtrdma: Avoid using Write list for small NFS READ requests
>      xprtrdma: Update comments in rpcrdma_marshal_req()
>      xprtrdma: Allow Read list and Reply chunk simultaneously
>      xprtrdma: Remove rpcrdma_create_chunks()
>      xprtrdma: Use core ib_drain_qp() API
>      xprtrdma: Rename rpcrdma_frwr::sg and sg_nents
>      xprtrdma: Save I/O direction in struct rpcrdma_frwr
>      xprtrdma: Reset MRs in frwr_op_unmap_sync()
>      xprtrdma: Refactor the FRWR recovery worker
>      xprtrdma: Move fr_xprt and fr_worker to struct rpcrdma_mw
>      xprtrdma: Refactor __fmr_dma_unmap()
>      xprtrdma: Add ro_unmap_safe memreg method
>      xprtrdma: Remove ro_unmap() from all registration modes
>      xprtrdma: Faster server reboot recovery
> 
> 
> fs/nfs/nfs4proc.c                  |   10 -
> include/linux/sunrpc/clnt.h        |    1 
> include/linux/sunrpc/xprt.h        |    1 
> include/linux/sunrpc/xprtrdma.h    |    4 
> net/sunrpc/clnt.c                  |   17 +
> net/sunrpc/xprtrdma/backchannel.c  |   16 +
> net/sunrpc/xprtrdma/fmr_ops.c      |  134 +++++++--
> net/sunrpc/xprtrdma/frwr_ops.c     |  214 ++++++++-------
> net/sunrpc/xprtrdma/physical_ops.c |   39 ++-
> net/sunrpc/xprtrdma/rpc_rdma.c     |  517 ++++++++++++++++++++++--------------
> net/sunrpc/xprtrdma/transport.c    |   16 +
> net/sunrpc/xprtrdma/verbs.c        |   91 ++----
> net/sunrpc/xprtrdma/xprt_rdma.h    |   42 ++-
> net/sunrpc/xprtsock.c              |    6 
> 14 files changed, 674 insertions(+), 434 deletions(-)
> 
> --
> Chuck Lever
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
