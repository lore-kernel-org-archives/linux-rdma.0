From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v5 00/14] NFS/RDMA server patches for v4.6
Date: Tue, 1 Mar 2016 17:00:52 -0500
Message-ID: <20160301220052.GF23792@fieldses.org>
References: <20160301180337.2492.4255.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160301180337.2492.4255.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 01:05:14PM -0500, Chuck Lever wrote:
> Hi Bruce-
> 
> I think these are ready for linux-next.

OK, applying for 4.6, thanks.

I still wonder whether the code makes incorrect assumptions about how
the server xdr encoder uses the reply xdr_buf.  That might only affect
clients which constructed rather strange compounds.  And shouldn't be
made any worse by these patches.

--b.

> 
> Two major changes: Finish server-side support for RDMA_ERROR type
> messages, and convert the server's completion handlers to the new
> core CQ API.
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
> 
> Changes since v4:
> - Rebased on v4.5-rc6
> - Replace confusing comments about NFSv4.1 over RDMA support
> 
> 
> Changes since v3:
> - Rebased on v4.5-rc5
> - Completed fix for Write chunk XDR padding
> - On error, svc_rdma_sendto() should close connection
> 
> 
> Changes since v2:
> - Rebased on v4.5-rc4
> - checkpatch.pl passes
> - Fix iWARP RDMA Read path regression
> - Reduce NFSv4.1 CB message size maximum in CREATE_SESSION
> - Another pass at fixing Write chunk XDR padding
> - Various clean ups
> 
> 
> Changes since v1:
> - Rebased on v4.5-rc3
> - Patch 02/10 (pre-allocate frmrs) dropped
> - Patch 04/10 replaced with more surgical patch
> - Refined reporting of flushed completions
> - Function names of completion methods changed to match client's
> new completion function naming convention
> 
> ---
> 
> Chuck Lever (14):
>       nfsd: Update NFS server comments related to RDMA support
>       svcrdma: Find client-provided write and reply chunks once per reply
>       svcrdma: Do not write xdr_buf::tail in a Write chunk
>       svcrdma: Do not send Write chunk XDR pad with inline content
>       nfsd: Lower NFSv4.1 callback message size limit
>       svcrdma: Close connection when a send error occurs
>       svcrdma: svc_rdma_post_recv() should close connection on error
>       rpcrdma: Add RPCRDMA_HDRLEN_ERR
>       svcrdma: Make RDMA_ERROR messages work
>       svcrdma: Use correct XID in error replies
>       svcrdma: Hook up the logic to return ERR_CHUNK
>       svcrdma: Remove close_out exit path
>       svcrdma: Use new CQ API for RPC-over-RDMA server receive CQs
>       svcrdma: Use new CQ API for RPC-over-RDMA server send CQs
> 
> 
>  fs/nfsd/nfs4state.c                        |   26 +-
>  fs/nfsd/nfs4xdr.c                          |    2 
>  include/linux/sunrpc/auth.h                |    7 
>  include/linux/sunrpc/rpc_rdma.h            |    1 
>  include/linux/sunrpc/svc_rdma.h            |   20 +
>  net/sunrpc/auth_null.c                     |    4 
>  net/sunrpc/auth_unix.c                     |    6 
>  net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   17 -
>  net/sunrpc/xprtrdma/svc_rdma_marshal.c     |   64 +++-
>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   60 ++--
>  net/sunrpc/xprtrdma/svc_rdma_sendto.c      |  196 ++++++++----
>  net/sunrpc/xprtrdma/svc_rdma_transport.c   |  445 +++++++++-------------------
>  12 files changed, 393 insertions(+), 455 deletions(-)
> 
> --
> Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
