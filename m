From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 00/10] NFS/RDMA server patches for v4.6
Date: Fri, 5 Feb 2016 16:29:07 +0530
Message-ID: <CANjDDBhaEfkssb+HzGovpJUn+9mVFm=H4mcLyYR6Lf7=cOC7LA@mail.gmail.com>
References: <20160203154411.13868.48268.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203154411.13868.48268.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While there are some bug fixes for ocrdma are on the way, I tested
this series with a modified ocrdma driver.
following tests passed:
iozone, cable-pull short duration, cable pull long duration (more than 5 mins).

Series Reviewed-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Series Tested-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>




On Wed, Feb 3, 2016 at 9:21 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> For review.
>
> - Fix XDR round-up in write chunks (take 3)
> - Pre-allocate FRWRs when accepting a connection
> - Add proper handling of bad header XDR
> - Convert the server to use the new core CQ API added in v4.5.
>
> Also available in the "nfsd-rdma-for-4.6" topic branch of this git
> repo:
>
> git://git.linux-nfs.org/projects/cel/cel-2.6.git
>
> Or for browsing:
>
> http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.6
>
> ---
>
> Chuck Lever (10):
>       svcrdma: Do not send XDR roundup bytes for a write chunk
>       svcrdma: Make svc_rdma_get_frmr() not sleep
>       svcrdma: svc_rdma_post_recv() should close connection on error
>       rpcrdma: Add missing XDR union fields for RDMA errors
>       svcrdma: Make RDMA_ERROR messages work
>       svcrdma: Use correct XID in error replies
>       svcrdma: Hook up the logic to return ERR_CHUNK
>       svcrdma: Remove close_out exit path
>       svcrdma: Use new CQ API for RPC-over-RDMA server receive CQs
>       svcrdma: Use new CQ API for RPC-over-RDMA server send CQs
>
>
>  include/linux/sunrpc/rpc_rdma.h            |   13 +
>  include/linux/sunrpc/svc_rdma.h            |   18 +
>  net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   15 -
>  net/sunrpc/xprtrdma/svc_rdma_marshal.c     |   62 ++--
>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   61 +---
>  net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   79 ++++-
>  net/sunrpc/xprtrdma/svc_rdma_transport.c   |  488 +++++++++++-----------------
>  7 files changed, 346 insertions(+), 390 deletions(-)
>
> --
> Chuck Lever
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
