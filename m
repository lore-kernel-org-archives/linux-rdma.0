From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 10/12] IB/mlx4: Implement ib_device callbacks
Date: Thu, 11 Jun 2015 00:31:08 -0600
Message-ID: <20150611063108.GE22369@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1433772735-22416-11-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433772735-22416-11-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 05:12:13PM +0300, Matan Barak wrote:

> +static struct net_device *mlx4_ib_get_netdev(struct ib_device *device, u8 port_num)
> +{

This function is never referenced in this patch, so we get compile
warnings?

Warnings are not a huge deal, but you did compile test every patch in
the series??

> +	if (mlx4_is_bonded(ibdev->dev)) {
> +		struct net_device *dev;
> +		struct net_device *upper = NULL;

So, I see this code in mlx4 touching bonding, but I don't see similar
code in ocrdma..

If bonding is a general feature why is this bit in the driver? Should
the core code be doing this?

Does bonding work in ocrdma at the end of this series? I was expecting
it to..

> +	gid_tbl = mailbox->buf;
> +
> +	for (i = 0; i < MLX4_MAX_PORT_GIDS; ++i)
> +		memcpy(&gid_tbl[i], &gids[i].gid, sizeof(union ib_gid));
> +
> +	err = mlx4_cmd(dev, mailbox->dma,
> +		       MLX4_SET_PORT_GID_TABLE << 8 | port_num,
> +		       1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
> +		       MLX4_CMD_WRAPPED);
> +	if (mlx4_is_bonded(dev))
> +		err += mlx4_cmd(dev, mailbox->dma,
> +				MLX4_SET_PORT_GID_TABLE << 8 | 2,
> +				1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
> +				MLX4_CMD_WRAPPED);

Again, wonder why the driver is sensitive to bonding, and ocrdma is not..

> @@ -477,11 +673,22 @@ out:
>  static int iboe_query_gid(struct ib_device *ibdev, u8 port, int index,
>  			  union ib_gid *gid)
>  {
> -	struct mlx4_ib_dev *dev = to_mdev(ibdev);
> +	int ret;
>  
> -	*gid = dev->iboe.gid_table[port - 1][index];
> +	if (!rdma_cap_roce_gid_table(ibdev, port)) {
> +		struct mlx4_ib_dev *dev = to_mdev(ibdev);
>  
> -	return 0;
> +		*gid = dev->iboe.gid_table[port - 1][index];
> +		return 0;
> +	}
> +
> +	ret = ib_get_cached_gid(ibdev, port, index, gid);
> +	if (ret == -EAGAIN) {
> +		memcpy(gid, &zgid, sizeof(*gid));
> +		return 0;
> +	}
> +
> +	return ret;
>  }

Hum, is it Ok to change iboe_query_gid like this at this point in the
series? Should this be in patch 11?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
