From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 9/9] IB/mlx4: Check if GRH is available before using it in modify_qp
Date: Sat,  5 Nov 2016 21:57:22 +0200
Message-ID: <1478375842-21513-10-git-send-email-leonro@mellanox.com>
References: <1478375842-21513-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478375842-21513-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Before reading GRH attributes, need to make sure ah contains GRH
and initialize GID type, while we are there,

Fixes: dbf727de7440 ('IB/core: Use GID table in AH creation and dmac resolution')
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 570bc86..0914731 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1764,14 +1764,14 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		u8 port_num = mlx4_is_bonded(to_mdev(ibqp->device)->dev) ? 1 :
 			attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 		union ib_gid gid;
-		struct ib_gid_attr gid_attr;
+		struct ib_gid_attr gid_attr = {.gid_type = IB_GID_TYPE_IB};
 		u16 vlan = 0xffff;
 		u8 smac[ETH_ALEN];
 		int status = 0;
 		int is_eth = rdma_cap_eth_ah(&dev->ib_dev, port_num) &&
 			attr->ah_attr.ah_flags & IB_AH_GRH;
 
-		if (is_eth) {
+		if (is_eth && attr->ah_attr.ah_flags & IB_AH_GRH) {
 			int index = attr->ah_attr.grh.sgid_index;
 
 			status = ib_get_cached_gid(ibqp->device, port_num,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
