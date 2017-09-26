From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/ocrdma: pr_err() strings should end with newlines
Date: Tue, 26 Sep 2017 10:52:08 +0300
Message-ID: <20170926075207.GE5825@yuvallap>
References: <48e72f72b25c067588b3da9142c7849636615df9.1506410780.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <48e72f72b25c067588b3da9142c7849636615df9.1506410780.git.arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 12:59:51PM +0530, Arvind Yadav wrote:
> pr_err() messages should end with a new-line to avoid other messages
> being concatenated.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> changes in v2 :
>                Add same changes for 'ocrdma_hw.c'
> 
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index dcb5942..b5cb69f 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -1090,7 +1090,7 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
>  		rsp = &mqe->u.rsp;
>  
>  	if (cqe_status || ext_status) {
> -		pr_err("%s() cqe_status=0x%x, ext_status=0x%x,",
> +		pr_err("%s() cqe_status=0x%x, ext_status=0x%x,\n",
>  		       __func__, cqe_status, ext_status);
>  		if (rsp) {
>  			/* This is for embedded cmds. */
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> index 66056f9..e528d7a 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> @@ -658,7 +658,7 @@ static ssize_t ocrdma_dbgfs_ops_write(struct file *filp,
>  		if (reset) {
>  			status = ocrdma_mbx_rdma_stats(dev, true);
>  			if (status) {
> -				pr_err("Failed to reset stats = %d", status);
> +				pr_err("Failed to reset stats = %d\n", status);
>  				goto err;
>  			}
>  		}
> -- 

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
