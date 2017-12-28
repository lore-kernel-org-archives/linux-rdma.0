From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 4/4] RDMA/vmw_pvrdma: Remove usage of BIT() from
 UAPI header
Date: Wed, 27 Dec 2017 21:49:13 -0700
Message-ID: <20171228044913.GC5343@ziepe.ca>
References: <20171220192305.GA28403@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171220192721.GA32622@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220192721.GA32622-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 20, 2017 at 11:27:28AM -0800, Bryan Tan wrote:
> BIT() should not be used in the UAPI header. Remove it.
> 
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>  include/uapi/rdma/vmw_pvrdma-abi.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
> index 4007cac..02ca0d0 100644
> +++ b/include/uapi/rdma/vmw_pvrdma-abi.h
> @@ -52,14 +52,14 @@
>  #define PVRDMA_UVERBS_ABI_VERSION	3		/* ABI Version. */
>  #define PVRDMA_UAR_HANDLE_MASK		0x00FFFFFF	/* Bottom 24 bits. */
>  #define PVRDMA_UAR_QP_OFFSET		0		/* QP doorbell. */
> -#define PVRDMA_UAR_QP_SEND		BIT(30)		/* Send bit. */
> -#define PVRDMA_UAR_QP_RECV		BIT(31)		/* Recv bit. */
> +#define PVRDMA_UAR_QP_SEND		(1 << 30)	/* Send bit. */
> +#define PVRDMA_UAR_QP_RECV		(1 << 31)	/* Recv bit. */

I changed the '1<<31' to '1UL<<31' when I applied this to for-next,
the constants should be unsigned to avoid problems with sign
extensions on the high bit.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
