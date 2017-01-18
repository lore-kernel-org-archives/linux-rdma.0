From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [patch] i40iw: silence an uninitialized variable warning
Date: Wed, 18 Jan 2017 13:19:38 +0200
Message-ID: <20170118111938.GB7544@yuval-lap.uk.oracle.com>
References: <20170118103452.GA12778@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170118103452.GA12778@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2017 at 01:34:53PM +0300, Dan Carpenter wrote:
> These can be used without being uninitialized but it's only a printk()
> so it's not the end of the world.

In an ideal world i would expect cqp_create function to set maj_err and
min_err when replying with error return code.

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
> index 2728af3..7b78a17 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_main.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
> @@ -561,7 +561,7 @@ static enum i40iw_status_code i40iw_create_cqp(struct i40iw_device *iwdev)
>  	struct i40iw_sc_dev *dev = &iwdev->sc_dev;
>  	struct i40iw_cqp_init_info cqp_init_info;
>  	struct i40iw_cqp *cqp = &iwdev->cqp;
> -	u16 maj_err, min_err;
> +	u16 maj_err = 0, min_err = 0;
>  	int i;
>  
>  	cqp->cqp_requests = kcalloc(sqsize, sizeof(*cqp->cqp_requests), GFP_KERNEL);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
