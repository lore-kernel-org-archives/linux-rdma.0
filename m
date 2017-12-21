From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: hw: Fix permissions for OCRDMA_RESET_STATS
Date: Wed, 20 Dec 2017 19:59:02 -0700
Message-ID: <20171221025902.GA10170@ziepe.ca>
References: <1502207797-25589-1-git-send-email-vasilyev@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502207797-25589-1-git-send-email-vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anton Vasilyev <vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 08, 2017 at 06:56:37PM +0300, Anton Vasilyev wrote:
> Debugfs file reset_stats is created with S_IRUSR permissions,
> but ocrdma_dbgfs_ops_read() doesn't support OCRDMA_RESET_STATS,
> whereas ocrdma_dbgfs_ops_write() supports only OCRDMA_RESET_STATS.
> 
> The patch fixes misstype with permissions.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Anton Vasilyev <vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>
> Acked-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> index 66056f9..d42c617 100644
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> @@ -834,7 +834,7 @@ void ocrdma_add_port_stats(struct ocrdma_dev *dev)
>  
>  	dev->reset_stats.type = OCRDMA_RESET_STATS;
>  	dev->reset_stats.dev = dev;
> -	if (!debugfs_create_file("reset_stats", S_IRUSR, dev->dir,
> +	if (!debugfs_create_file("reset_stats", S_IWUSR, dev->dir,
>  				&dev->reset_stats, &ocrdma_dbg_ops))
>  		goto err;
>  

I changed the S_IWUSR to 0200 to make checkpatch happy, slowly we are
trying to move to the standard style throughout, but applied to
for-next now.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
