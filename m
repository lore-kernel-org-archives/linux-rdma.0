From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: Re: [patch -next] mlx5: return -EFAULT instead of -EPERM
Date: Wed, 17 Jul 2013 19:20:09 +0300
Message-ID: <20130717162009.GA32704@mtldesk30>
References: <20130710105859.GD31232@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130710105859.GD31232@longonot.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eli Cohen <eli@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-by Eli Cohen <eli@mellanox.com>

On Wed, Jul 10, 2013 at 01:58:59PM +0300, Dan Carpenter wrote:
> For copy_to/from_user() failure, the correct error code is -EFAULT not
> -EPERM.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index e2daa8f..bd41df9 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -171,7 +171,7 @@ static ssize_t size_write(struct file *filp, const char __user *buf,
>  	int c;
>  
>  	if (copy_from_user(lbuf, buf, sizeof(lbuf)))
> -		return -EPERM;
> +		return -EFAULT;
>  
>  	c = order2idx(dev, ent->order);
>  	lbuf[sizeof(lbuf) - 1] = 0;
> @@ -208,7 +208,7 @@ static ssize_t size_read(struct file *filp, char __user *buf, size_t count,
>  		return err;
>  
>  	if (copy_to_user(buf, lbuf, err))
> -		return -EPERM;
> +		return -EFAULT;
>  
>  	*pos += err;
>  
> @@ -233,7 +233,7 @@ static ssize_t limit_write(struct file *filp, const char __user *buf,
>  	int c;
>  
>  	if (copy_from_user(lbuf, buf, sizeof(lbuf)))
> -		return -EPERM;
> +		return -EFAULT;
>  
>  	c = order2idx(dev, ent->order);
>  	lbuf[sizeof(lbuf) - 1] = 0;
> @@ -270,7 +270,7 @@ static ssize_t limit_read(struct file *filp, char __user *buf, size_t count,
>  		return err;
>  
>  	if (copy_to_user(buf, lbuf, err))
> -		return -EPERM;
> +		return -EFAULT;
>  
>  	*pos += err;
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index c1c0eef..205753a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -693,7 +693,7 @@ static ssize_t dbg_write(struct file *filp, const char __user *buf,
>  		return -ENOMEM;
>  
>  	if (copy_from_user(lbuf, buf, sizeof(lbuf)))
> -		return -EPERM;
> +		return -EFAULT;
>  
>  	lbuf[sizeof(lbuf) - 1] = 0;
>  
> @@ -889,7 +889,7 @@ static ssize_t data_write(struct file *filp, const char __user *buf,
>  		return -ENOMEM;
>  
>  	if (copy_from_user(ptr, buf, count)) {
> -		err = -EPERM;
> +		err = -EFAULT;
>  		goto out;
>  	}
>  	dbg->in_msg = ptr;
> @@ -919,7 +919,7 @@ static ssize_t data_read(struct file *filp, char __user *buf, size_t count,
>  
>  	copy = min_t(int, count, dbg->outlen);
>  	if (copy_to_user(buf, dbg->out_msg, copy))
> -		return -EPERM;
> +		return -EFAULT;
>  
>  	*pos += copy;
>  
> @@ -949,7 +949,7 @@ static ssize_t outlen_read(struct file *filp, char __user *buf, size_t count,
>  		return err;
>  
>  	if (copy_to_user(buf, &outlen, err))
> -		return -EPERM;
> +		return -EFAULT;
>  
>  	*pos += err;
>  
> @@ -974,7 +974,7 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
>  	dbg->outlen = 0;
>  
>  	if (copy_from_user(outlen_str, buf, count))
> -		return -EPERM;
> +		return -EFAULT;
>  
>  	outlen_str[7] = 0;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
