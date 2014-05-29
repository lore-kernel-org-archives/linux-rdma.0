From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/6] mlx4_core: Fix incorrect FLAGS1 bitmap test in mlx4_QUERY_FUNC_CAP
Date: Thu, 29 May 2014 16:31:00 +0300
Message-ID: <1401370264-4818-3-git-send-email-ogerlitz@mellanox.com>
References: <1401370264-4818-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401370264-4818-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Commit eb17711bc1 did:
	if (func_cap->flags1 & QUERY_FUNC_CAP_FLAGS1_OFFSET) {

which should be:
	if (func_cap->flags1 & QUERY_FUNC_CAP_FLAGS1_FORCE_VLAN) {

Fix that.


Fixes: eb17711 ("net/mlx4_core: Introduce nic_info new flag in QUERY_FUNC_CAP")
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index d16a4d1..ef242e1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -414,7 +414,7 @@ int mlx4_QUERY_FUNC_CAP(struct mlx4_dev *dev, u32 gen_or_port,
 
 	MLX4_GET(func_cap->flags1, outbox, QUERY_FUNC_CAP_FLAGS1_OFFSET);
 	if (dev->caps.port_type[gen_or_port] == MLX4_PORT_TYPE_ETH) {
-		if (func_cap->flags1 & QUERY_FUNC_CAP_FLAGS1_OFFSET) {
+		if (func_cap->flags1 & QUERY_FUNC_CAP_FLAGS1_FORCE_VLAN) {
 			mlx4_err(dev, "VLAN is enforced on this port\n");
 			err = -EPROTONOSUPPORT;
 			goto out;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
