From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] IB/mlx4: fix bug unwinding on error in mlx4_ib_init_sriov()
Date: Mon, 4 Feb 2013 14:22:36 +0300
Message-ID: <20130204112236.GA8878@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have to decrement "i" before calling mlx4_ib_free_demux_ctx() or we
free something that wasn't allocated.  That's fine for free_pv_object()
but it would lead to a NULL dereference calling
mlx4_ib_free_demux_ctx().  The null dereference is because ->tun is NULL
when we check:

	if (!ctx->tun[i])

Also we didn't free ->sriov.demux[0] so it was a small leak.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
Static checker stuff.  I have not tested this.

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 0a903c1..934792c 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1999,16 +1999,17 @@ int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
 			goto demux_err;
 		err = mlx4_ib_alloc_demux_ctx(dev, &dev->sriov.demux[i], i + 1);
 		if (err)
-			goto demux_err;
+			goto free_pv;
 	}
 	mlx4_ib_master_tunnels(dev, 1);
 	return 0;
 
+free_pv:
+	free_pv_object(dev, mlx4_master_func_num(dev->dev), i + 1);
 demux_err:
-	while (i > 0) {
+	while (--i >= 0) {
 		free_pv_object(dev, mlx4_master_func_num(dev->dev), i + 1);
 		mlx4_ib_free_demux_ctx(&dev->sriov.demux[i]);
-		--i;
 	}
 	mlx4_ib_device_unregister_sysfs(dev);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
