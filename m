From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/16] NFS/RDMA client side for Linux 4.3
Date: Thu, 6 Aug 2015 10:28:01 -0400
Message-ID: <55C36EF1.2040905@Netapp.com>
References: <20150803165807.9115.23842.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150803165807.9115.23842.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

I've applied these patches locally without a problem (and I made sure to remove the pr_warns() in the last patch).  Are you planning to submit a v5, or are these ready for me now?

Thanks,
Anna

On 08/03/2015 01:02 PM, Chuck Lever wrote:
> Several important client-side performance and scalability
> improvements are made in this series, proposed for the 4.3
> kernel, including:
> 
> - Increase maximum RPC/RDMA credits to 128
> - Increase maximum NFS/RDMA r/wsize to one megabyte
> - Prefer inline rather than reply chunk replies
> 
> And these fixes:
> 
> - Send NFSv4 WRITE compounds correctly
> - Support RDMA_NOMSG calls
> - Remove support for RDMA_MSGP calls
> - Fix large NFS symlink operations
> - Get inline threshold accounting right
> 
> Also available in the "nfs-rdma-for-4.3" topic branch of this git repo:
> 
> git://git.linux-nfs.org/projects/cel/cel-2.6.git
> 
> Or for browsing:
> 
> http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.3
> 
> 
> Changes since v3:
> - Rebased on Linux v4.2-rc5
> - Added v2 of Devesh's reboot crash fix
> - Clarified description of NFSv4 WRITE fix
> 
> 
> Changes since v2:
> - Rebased on Linux v4.2-rc3
> - Corrected RPCRDMA_MAX_IOVS macro
> - Included patch to remove core ib_reg_phys_mr() API
> 
> 
> Changes since v1:
> - Rebased on Linux v4.2-rc2
> - PHYSICAL registration, being insecure, must now be explicitly selected
> - Further clean-ups were done because ib_reg_phys_mr() is gone
> - Support for RDMA_MSGP type calls has been removed
> - Some patch descriptions have been clarified
> 
> ---
> 
> Chuck Lever (15):
>       xprtrdma: Make xprt_setup_rdma() agnostic to family of server address
>       xprtrdma: Raise maximum payload size to one megabyte
>       xprtrdma: Increase default credit limit
>       xprtrdma: Don't fall back to PHYSICAL memory registration
>       xprtrdma: Remove last ib_reg_phys_mr() call site
>       xprtrdma: Clean up rpcrdma_ia_open()
>       xprtrdma: Remove logic that constructs RDMA_MSGP type calls
>       xprtrdma: Account for RPC/RDMA header size when deciding to inline
>       xprtrdma: Always provide a write list when sending NFS READ
>       xprtrdma: Don't provide a reply chunk when expecting a short reply
>       xprtrdma: Fix XDR tail buffer marshalling
>       xprtrdma: Fix large NFS SYMLINK calls
>       xprtrdma: Clean up xprt_rdma_print_stats()
>       xprtrdma: Count RDMA_NOMSG type calls
>       core: Remove the ib_reg_phys_mr() and ib_rereg_phys_mr() verbs
> 
> Devesh Sharma (1):
>       xprtrdma: take HCA driver refcount at client
> 
> 
>  drivers/infiniband/core/verbs.c    |   67 ----------
>  fs/nfs/nfs3xdr.c                   |    1 
>  fs/nfs/nfs4xdr.c                   |    4 -
>  include/linux/sunrpc/xprtrdma.h    |    2 
>  include/rdma/ib_verbs.h            |   46 -------
>  net/sunrpc/xprtrdma/fmr_ops.c      |   19 +++
>  net/sunrpc/xprtrdma/frwr_ops.c     |    5 +
>  net/sunrpc/xprtrdma/physical_ops.c |   25 ++++
>  net/sunrpc/xprtrdma/rpc_rdma.c     |  197 +++++++++++++++---------------
>  net/sunrpc/xprtrdma/transport.c    |   77 +++++-------
>  net/sunrpc/xprtrdma/verbs.c        |  238 +++++++++++++-----------------------
>  net/sunrpc/xprtrdma/xprt_rdma.h    |   27 ++--
>  12 files changed, 285 insertions(+), 423 deletions(-)
> 
> --
> Chuck Lever
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
