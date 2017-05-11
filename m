From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: [PATCH v2] net/mlx4_core: Use min_t instead of if for consistency
Date: Thu, 11 May 2017 13:36:02 +0300
Message-ID: <1494498962-16852-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: yishaih@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
---
v0 -> v1:
	* s/"min_t("/"min_t(int"
v1 -> v2:
	* Use min3 instead of min_t twice
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 7032054..2afa340 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2862,12 +2862,9 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 	int port = 0;
 
 	if (msi_x) {
-		int nreq = dev->caps.num_ports * num_online_cpus() + 1;
-
-		nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
-			     nreq);
-		if (nreq > MAX_MSIX)
-			nreq = MAX_MSIX;
+		int nreq = min3(dev->caps.num_ports * num_online_cpus() + 1,
+				dev->caps.num_eqs - dev->caps.reserved_eqs,
+				MAX_MSIX);
 
 		entries = kcalloc(nreq, sizeof *entries, GFP_KERNEL);
 		if (!entries)
-- 
2.7.4
