From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: IB: INFINIBAND should depend on HAS_DMA
Date: Fri, 1 Dec 2017 17:01:30 -0700
Message-ID: <20171202000130.GB20454@ziepe.ca>
References: <1511117910-25003-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511117910-25003-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 19, 2017 at 07:58:30PM +0100, Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
>     ERROR: "bad_dma_ops" [net/sunrpc/xprtrdma/rpcrdma.ko] undefined!
>     ERROR: "bad_dma_ops" [net/smc/smc.ko] undefined!
>     ERROR: "bad_dma_ops" [net/rds/rds_rdma.ko] undefined!
>     ERROR: "bad_dma_ops" [net/9p/9pnet_rdma.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/nvme/target/nvmet-rdma.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/nvme/host/nvme-rdma.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/srpt/ib_srpt.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/srp/ib_srp.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/isert/ib_isert.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/ulp/ipoib/ib_ipoib.ko] undefined!
>     ERROR: "bad_dma_ops" [drivers/infiniband/core/ib_core.ko] undefined!
> 
> Before, this was handled implicitly by the dependency on PCI.
> Add an explicit dependency on HAS_DMA to fix this.
> 
> Fixes: 931bc0d91639f8fb ("IB: Move PCI dependency from root KConfig to HW's KConfigs")
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-rc, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
