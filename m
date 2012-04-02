From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 2 Apr 2012 15:51:17 +0300
Message-ID: <4F79A0C5.2030805@mellanox.com>
References: <4F795880.4070306@acm.org> <4F798069.4030305@mellanox.com> <4F798A9B.7060805@acm.org> <4F798B9A.6090309@mellanox.com> <4F799222.3050306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F799222.3050306-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 2:48 PM, Bart Van Assche wrote:
> The two ports are connected back-to-back to another mlx4 HCA. I 
> noticed this behavior change since opensm stopped working after 
> rebooting into 3.4-rc1.

can you add these prints and send me the output after attempting to cat 
the rate file?

Or.

> diff --git a/drivers/infiniband/core/sysfs.c 
> b/drivers/infiniband/core/sysfs.c
> index 83b720e..d20e4a4 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -181,8 +181,13 @@ static ssize_t rate_show(struct ib_port *p, 
> struct port_attribute *unused,
>         char *speed = "";
>         int rate = -1;          /* in deci-Gb/sec */
>         ssize_t ret;
> +       enum rdma_link_layer ll;
>
>         ret = ib_query_port(p->ibdev, p->port_num, &attr);
> +
> +       ll = rdma_port_get_link_layer(p->ibdev, p->port_num);
> +       printk(KERN_ERR "%s ret %d for ib_query_port dev %s port %d 
> link %d\n",
> +               __func__, ret, p->ibdev->name, p->port_num, ll);
>         if (ret)
>                 return ret;
>
> diff --git a/drivers/infiniband/hw/mlx4/main.c 
> b/drivers/infiniband/hw/mlx4/main.c
> index 75d3056..26b67c6 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -256,6 +256,7 @@ static int ib_link_query_port(struct ib_device 
> *ibdev, u8 port,
>  out:
>         kfree(in_mad);
>         kfree(out_mad);
> +       printk(KERN_ERR "%s active_speed %d\n", __func__, 
> props->active_speed);
>         return err;
>  }
>
> @@ -312,6 +313,7 @@ out_unlock:
>         spin_unlock(&iboe->lock);
>  out:
>         mlx4_free_cmd_mailbox(mdev->dev, mailbox);
> +       printk(KERN_ERR "%s active_speed %d\n", __func__, 
> props->active_speed);
>         return err;
>  }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
