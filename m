From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: Re: [PATCH] mlx5: shift wrapping bug in mlx5_ib_get_buf_offset()
Date: Sun, 10 Nov 2013 09:09:13 +0200
Message-ID: <20131110070913.GA30354@mtldesk30>
References: <20131108095259.GK27977@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131108095259.GK27977@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eli Cohen <eli@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 08, 2013 at 12:52:59PM +0300, Dan Carpenter wrote:
> "page_size" is declared as u64 but the (1 << page_shift) shift will wrap
> at 32 bits.

I hope to live when this happnes :-)
I prefer to be explicit and use:
        page_size = (u64)1 << page_shift;

> 
> Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
> index 3a53228..3020ec2 100644
> --- a/drivers/infiniband/hw/mlx5/mem.c
> +++ b/drivers/infiniband/hw/mlx5/mem.c
> @@ -148,7 +148,7 @@ int mlx5_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset)
>  	u64 off_mask;
>  	u64 buf_off;
>  
> -	page_size = 1 << page_shift;
> +	page_size = 1ULL << page_shift;
>  	page_mask = page_size - 1;
>  	buf_off = addr & page_mask;
>  	off_size = page_size >> 6;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
