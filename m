From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: Re: [patch] IB/mlx5: stack info leak in mlx5_ib_alloc_ucontext()
Date: Sun, 28 Jul 2013 10:23:36 +0300
Message-ID: <20130728072336.GB29427@mtldesk30>
References: <20130725170436.GC7026@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130725170436.GC7026@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eli Cohen <eli@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 25, 2013 at 08:04:36PM +0300, Dan Carpenter wrote:
> We don't set "resp.reserved".  Since it's at the end of the struct that
> means we don't have to copy it to the user.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 8000fff..43dfb84 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -619,7 +619,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
>  
>  	resp.tot_uuars = req.total_num_uuars;
>  	resp.num_ports = dev->mdev.caps.num_ports;
> -	err = ib_copy_to_udata(udata, &resp, sizeof(resp));
> +	err = ib_copy_to_udata(udata, &resp,
> +			       sizeof(resp) - sizeof(resp.reserved));
>  	if (err)
>  		goto out_uars;
>

I don't have strong opinion on this one. The title of the patch is
stack info leak but the only leak of a reserved field. Other opinions?
