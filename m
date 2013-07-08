From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mlx5: Use simple_open when possible
Date: Mon, 8 Jul 2013 20:34:03 +0800
Message-ID: <20130708123403.GA10667@localhost>
References: <1373286607-3110-1-git-send-email-ogerlitz@mellanox.com>
 <1373286607-3110-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1373286607-3110-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Or,

>  static const struct file_operations limit_fops = {
>  	.owner	= THIS_MODULE,
> -	.open	= file_open,
> +	.open = simple_open,
>  	.write	= limit_write,
>  	.read	= limit_read,

>  static const struct file_operations dfops = {
>  	.owner	= THIS_MODULE,
> -	.open	= dbg_open,
> +	.open = simple_open,
>  	.write	= data_write,
>  	.read	= data_read,
>  };
> @@ -1003,7 +996,7 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
>  
>  static const struct file_operations olfops = {
>  	.owner	= THIS_MODULE,
> -	.open	= dbg_open,
> +	.open = simple_open,
>  	.write	= outlen_write,
>  	.read	= outlen_read,

>  static const struct file_operations fops = {
>  	.owner	= THIS_MODULE,
> -	.open	= dbg_open,
> +	.open = simple_open,
>  	.read	= dbg_read,
>  };

The above chunks will need to fix alignments.

Thanks,
Fengguang
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
