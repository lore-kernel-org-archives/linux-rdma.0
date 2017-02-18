From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 06/29] IB/mlx4: Delete three unnecessary return statements
Date: Sat, 18 Feb 2017 21:54:06 +0100
Message-ID: <7edfe4d6-156d-23c9-acef-a6606680a5eb@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Fri, 17 Feb 2017 21:34:27 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: void function return statements are not generally useful

Thus remove such a statement in the affected functions.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index d8c27e3ed69a..cf33efce69d2 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1173,7 +1173,6 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 out:
 	kfree(in_mad);
 	kfree(out_mad);
-	return;
 }
 
 void handle_port_mgmt_change_event(struct work_struct *work)
@@ -2140,7 +2139,6 @@ void mlx4_ib_tunnels_update_work(struct work_struct *work)
 	mlx4_ib_tunnels_update(dmxw->dev, dmxw->slave, (int) dmxw->port,
 			       dmxw->do_init);
 	kfree(dmxw);
-	return;
 }
 
 static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
@@ -2268,7 +2266,6 @@ static void mlx4_ib_master_tunnels(struct mlx4_ib_dev *dev, int do_init)
 	/* initialize or tear down tunnel QPs for the master */
 	for (i = 0; i < dev->dev->caps.num_ports; i++)
 		mlx4_ib_tunnels_update(dev, mlx4_master_func_num(dev->dev), i + 1, do_init);
-	return;
 }
 
 int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
