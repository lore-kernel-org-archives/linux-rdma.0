From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/4] IB/mlx4: In sysfs under RoCE, do not allow changing the paravirtualization mapping for pkeys
Date: Thu, 30 Jul 2015 17:34:23 +0300
Message-ID: <1438266864-3584-4-git-send-email-ogerlitz@mellanox.com>
References: <1438266864-3584-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438266864-3584-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

The pkey mapping for RoCE must remain the default mapping:
VFs:
  virtual index 0 = mapped to real index 0 (0xFFFF)
  All others indices: mapped to a real pkey index containing an
                      invalid pkey.
PF:
  virtual index i = real index i.

Fixes: c1e7e466120b ('IB/mlx4: Add iov directory in sysfs under the ib device')
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index 6797108..69fb5ba 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -640,6 +640,8 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 	struct mlx4_port *p;
 	int i;
 	int ret;
+	int is_eth = rdma_port_get_link_layer(&dev->ib_dev, port_num) ==
+			IB_LINK_LAYER_ETHERNET;
 
 	p = kzalloc(sizeof *p, GFP_KERNEL);
 	if (!p)
@@ -657,7 +659,8 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 
 	p->pkey_group.name  = "pkey_idx";
 	p->pkey_group.attrs =
-		alloc_group_attrs(show_port_pkey, store_port_pkey,
+		alloc_group_attrs(show_port_pkey,
+				  is_eth ? NULL : store_port_pkey,
 				  dev->dev->caps.pkey_table_len[port_num]);
 	if (!p->pkey_group.attrs) {
 		ret = -ENOMEM;
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
