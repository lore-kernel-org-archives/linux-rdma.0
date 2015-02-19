From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 26/30] IB/mlx4: Translate cache gid index to real index
Date: Fri, 20 Feb 2015 03:32:41 +0530
Message-ID: <7bc71a06-2f8d-4aae-a981-b061fd94f112@CMEXHTCAS2.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424383365-19337-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When QP is modified with path the given sgid_index is not necessarily
the index that HW knows. This is due to optimizations that can save
place in the HW table. Therefore, translation is required.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 9731c07..b06e9fc 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1256,14 +1256,18 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 		path->static_rate = 0;
 
 	if (ah->ah_flags & IB_AH_GRH) {
-		if (ah->grh.sgid_index >= dev->dev->caps.gid_table_len[port]) {
+		int real_sgid_index = mlx4_ib_gid_index_to_real_index(dev,
+								      port,
+								      ah->grh.sgid_index);
+
+		if (real_sgid_index >= dev->dev->caps.gid_table_len[port]) {
 			pr_err("sgid_index (%u) too large. max is %d\n",
-			       ah->grh.sgid_index, dev->dev->caps.gid_table_len[port] - 1);
+			       real_sgid_index, dev->dev->caps.gid_table_len[port] - 1);
 			return -1;
 		}
 
 		path->grh_mylmc |= 1 << 7;
-		path->mgid_index = ah->grh.sgid_index;
+		path->mgid_index = real_sgid_index;
 		path->hop_limit  = ah->grh.hop_limit;
 		path->tclass_flowlabel =
 			cpu_to_be32((ah->grh.traffic_class << 20) |
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
