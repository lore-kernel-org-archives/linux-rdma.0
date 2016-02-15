From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 0/8] NFS/RDMA client patches for v4.6
Date: Mon, 15 Feb 2016 20:01:06 +0530
Message-ID: <CANjDDBhmdJk8HeHhEQFaNRsUddBCnuncLNnJaFy5z+zvaFVa-A@mail.gmail.com>
References: <20160212205107.5278.55938.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160212205107.5278.55938.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I shell test this series with ocrdma and update the testing status.

Series Reviewed-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Sat, Feb 13, 2016 at 2:35 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> There continues to be some fallout from enabling NFSv4.1/RDMA, and
> from converting the reply handler to use a work queue.  This series
> includes some bug fixes for those issues.
>
> Logic to handle the RPC-over-RDMA RDMA_ERROR message type is also
> introduced into the RPC reply handler.
>
> Also included is a patch set to convert xprtrdma to use the new core
> CQ API.
>
> Available in the "nfs-rdma-for-4.6" topic branch of this git repo:
>
> git://git.linux-nfs.org/projects/cel/cel-2.6.git
>
> Or for browsing:
>
> http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.6
>
>
> Chuck Lever (8):
>       xprtrdma: Segment head and tail XDR buffers on page boundaries
>       xprtrdma: Invalidate memory when a signal is caught
>       rpcrdma: Add RPCRDMA_HDRLEN_ERR
>       xprtrdma: Properly handle RDMA_ERROR replies
>       xprtrdma: Serialize credit accounting again
>       xprtrdma: Use new CQ API for RPC-over-RDMA client receive CQs
>       xprtrdma: Use an anonymous union in struct rpcrdma_mw
>       xprtrdma: Use new CQ API for RPC-over-RDMA client send CQs
>
>
>  include/linux/sunrpc/rpc_rdma.h |   12 +-
>  net/sunrpc/xprtrdma/fmr_ops.c   |   28 +++---
>  net/sunrpc/xprtrdma/frwr_ops.c  |  137 ++++++++++++++++++---------
>  net/sunrpc/xprtrdma/rpc_rdma.c  |   89 +++++++++++++-----
>  net/sunrpc/xprtrdma/transport.c |   41 +++++++-
>  net/sunrpc/xprtrdma/verbs.c     |  198 ++++++++++++---------------------------
>  net/sunrpc/xprtrdma/xprt_rdma.h |   15 +--
>  7 files changed, 279 insertions(+), 241 deletions(-)
>
> --
> Chuck Lever
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
