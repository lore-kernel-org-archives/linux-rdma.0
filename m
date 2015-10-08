From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2] IB/mlx4: Use correct order of variables in log message
Date: Thu,  8 Oct 2015 13:21:33 +0800
Message-ID: <1444281693-11195-1-git-send-email-wen.gang.wang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is a mis-order in mlx4 log. Fix it.

Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 0a32020..150fbb3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1010,7 +1010,7 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 		if (!(smp->mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED &&
 		      smp->method == IB_MGMT_METHOD_GET) || network_view) {
 			mlx4_err(dev, "Unprivileged slave %d is trying to execute a Subnet MGMT MAD, class 0x%x, method 0x%x, view=%s for attr 0x%x. Rejecting\n",
-				 slave, smp->method, smp->mgmt_class,
+				 slave, smp->mgmt_class, smp->method,
 				 network_view ? "Network" : "Host",
 				 be16_to_cpu(smp->attr_id));
 			return -EPERM;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
