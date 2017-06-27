From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/5] IB/ipoib: Limit call to free rdma_netdev for
 capable devices
Date: Tue, 27 Jun 2017 10:34:07 -0700
Message-ID: <20170627173407.GA55945@knc-06.sc.intel.com>
References: <20170614065909.23650-1-leon@kernel.org>
 <20170614065909.23650-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170614065909.23650-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 14, 2017 at 09:59:06AM +0300, Leon Romanovsky wrote:
>From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
>Limit calls to free_rdma_netdev() for capable devices only.
>
>Fixes: cd565b4b51e5 ('IB/IPoIB: Support acceleration options callbacks')
>Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>---
> drivers/infiniband/hw/mlx5/main.c         | 6 ++++--
> drivers/infiniband/ulp/ipoib/ipoib_main.c | 5 ++++-
> 2 files changed, 8 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>index 0c79983c8b1a..9ecc089d4529 100644
>--- a/drivers/infiniband/hw/mlx5/main.c
>+++ b/drivers/infiniband/hw/mlx5/main.c
>@@ -3692,8 +3692,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
> 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
> 	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
> 	dev->ib_dev.get_dev_fw_str      = get_dev_fw_str;
>-	dev->ib_dev.alloc_rdma_netdev	= mlx5_ib_alloc_rdma_netdev;
>-	dev->ib_dev.free_rdma_netdev	= mlx5_ib_free_rdma_netdev;
>+	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads)) {
>+		dev->ib_dev.alloc_rdma_netdev	= mlx5_ib_alloc_rdma_netdev;
>+		dev->ib_dev.free_rdma_netdev	= mlx5_ib_free_rdma_netdev;
>+	}
> 	if (mlx5_core_is_pf(mdev)) {
> 		dev->ib_dev.get_vf_config	= mlx5_ib_get_vf_config;
> 		dev->ib_dev.set_vf_link_state	= mlx5_ib_set_vf_link_state;
>diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>index 0ddd9709e1df..91fae34bdd4f 100644
>--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>@@ -2301,7 +2301,10 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
> 		flush_workqueue(priv->wq);
>
> 		unregister_netdev(priv->dev);
>-		free_netdev(priv->dev);
>+		if (device->free_rdma_netdev)
>+			device->free_rdma_netdev(priv->dev);
>+		else
>+			free_netdev(priv->dev);

This is causing an crash in hfi1 driver.
If the call to alloc_rdma_netdev() has returned -EOPNOTSUPP, we shouldn't be 
calling free_rdma_netdev() here (as device driver doesn't own that netdev).
I will send out a patch to hfi1 driver to guard check for the type in its 
free_rdma_netdev() call to handle such issues.

But we need to properly free the netdev here, probably by something like this.

if ((priv->dev->netdev_ops != ipoib_netdev_default_pf) &&
     device->free_rdma_netdev)
	device->free_rdma_netdev(priv->dev);
else
	free_netdev(priv->dev);

Niranjana

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
