From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Update documentation link
Date: Tue, 28 Feb 2017 19:11:24 -0500
Message-ID: <20170301001123.GB3001@phlsvsds.ph.intel.com>
References: <20170228194253.11759-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170228194253.11759-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 28, 2017 at 09:42:53PM +0200, Leon Romanovsky wrote:
> All Soft-RoCE (rxe) is handled now in rdma-core user space library,
> so the documentation. The patch below updates the documentation
> link to that new location.
> 
> Reported-by: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/sw/rxe/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/Kconfig b/drivers/infiniband/sw/rxe/Kconfig
> index 1e4e628fe7b0..71971d301638 100644
> --- a/drivers/infiniband/sw/rxe/Kconfig
> +++ b/drivers/infiniband/sw/rxe/Kconfig
> @@ -21,4 +21,4 @@ config RDMA_RXE
>  	To configure and work with soft-RoCE driver please use the
>  	following wiki page under "configure Soft-RoCE (RXE)" section:
> 
> -	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
> +	https://github.com/linux-rdma/rdma-core/blob/master/Documentation/rxe.md
> --
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
