From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] mlx4_core: Fix device capabilities dumping
Date: Wed, 17 Dec 2014 07:17:13 +0200
Message-ID: <1418793433-4699-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are dumping device capabilities which are supported both by the
firmware and the driver. Align the arrary that holds the capability
strings with this practice.

Reported-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index ef3b95b..4a4e652 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -84,13 +84,10 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 		[ 1] = "UC transport",
 		[ 2] = "UD transport",
 		[ 3] = "XRC transport",
-		[ 4] = "reliable multicast",
-		[ 5] = "FCoIB support",
 		[ 6] = "SRQ support",
 		[ 7] = "IPoIB checksum offload",
 		[ 8] = "P_Key violation counter",
 		[ 9] = "Q_Key violation counter",
-		[10] = "VMM",
 		[12] = "Dual Port Different Protocol (DPDP) support",
 		[15] = "Big LSO headers",
 		[16] = "MW support",
@@ -99,12 +96,11 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 		[19] = "Raw multicast support",
 		[20] = "Address vector port checking support",
 		[21] = "UD multicast support",
-		[24] = "Demand paging support",
-		[25] = "Router support",
 		[30] = "IBoE support",
 		[32] = "Unicast loopback support",
 		[34] = "FCS header control",
-		[38] = "Wake On LAN support",
+		[37] = "Wake On LAN (port1) support",
+		[38] = "Wake On LAN (port2) support",
 		[40] = "UDP RSS support",
 		[41] = "Unicast VEP steering support",
 		[42] = "Multicast VEP steering support",
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
