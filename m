From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/mlx5: Fix mlx5_ib_alloc_mr error flow
Date: Wed, 27 Dec 2017 15:32:57 -0700
Message-ID: <20171227223257.GB1523@ziepe.ca>
References: <20171226092020.8106-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171226092020.8106-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitzan Carmi <nitzanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 26, 2017 at 11:20:20AM +0200, Leon Romanovsky wrote:
> From: Nitzan Carmi <nitzanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> ibmr.device is being set only after ib_alloc_mr() is
> (successfully) complete. Therefore, in case mlx5_core_create_mkey()
> return with error, the error flow calls mlx5_free_priv_descs()
> which uses ibmr.device (which doesn't exist yet), causing
> NULL dereference and gets the system into kernel panic.
> 
> To fix this, the IB device should be given to mr struct in earlier
> stage (e.g. prior to calling mlx5_core_create_mkey()).
> 
> Fixes: 8a187ee52b04 ("IB/mlx5: Support the new memory registration API")
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Nitzan Carmi <nitzanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>  drivers/infiniband/hw/mlx5/mr.c | 1 +
>  1 file changed, 1 insertion(+)

Applied to for-rc, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
