From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1] RDMA/vmw_pvrdma: Add shared receive queue
 support
Date: Tue, 7 Nov 2017 08:53:27 +0200
Message-ID: <20171107065326.GA4672@yuvallap>
References: <20171106194847.GA5038@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171106194847.GA5038-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 06, 2017 at 11:48:53AM -0800, Bryan Tan wrote:
> Add the required functions needed to support SRQs. Currently, kernel
> clients are not supported. SRQs will only be available in userspace.
> 
> Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Nitish Bhat <bnitish-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1 Changelog:
> - Change SRQ functions to be more consistent with the QP functions
> - Move check for kernel clients to before resource initialization
> - Use refcount_t instead of atomic_t
> - Change allocation from (void *) to (struct pvrdma_srq *)
> - Remove unnecessary initialization of srq_tbl to NULL
> - Check for srq_tbl in SRQ event handler
> - Only register SRQ functions with IB/core when the underlying
>   device has SRQ capabilities.
> ---
>  drivers/infiniband/hw/vmw_pvrdma/Makefile         |   2 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |  25 ++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h |  54 ++++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    |  59 +++-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c      |  55 +++-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c     | 319 ++++++++++++++++++++++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |   3 +
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  18 ++
>  include/uapi/rdma/vmw_pvrdma-abi.h                |   2 +
>  9 files changed, 523 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
