From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libmlx4: Add new device IDs
Date: Wed, 19 Jan 2011 17:13:38 +0200
Message-ID: <20110119151338.GA13287@vlad-laptop>
Reply-To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 src/mlx4.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 1295c53..034f9ec 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -66,6 +66,29 @@ struct {
 	HCA(MELLANOX, 0x6354),	/* MT25408 "Hermon" QDR */
 	HCA(MELLANOX, 0x6732),	/* MT25408 "Hermon" DDR PCIe gen2 */
 	HCA(MELLANOX, 0x673c),	/* MT25408 "Hermon" QDR PCIe gen2 */
+	HCA(MELLANOX, 0x6368),	/* MT25448 [ConnectX EN 10GigE, PCIe 2.0 2.5GT/s] */
+	HCA(MELLANOX, 0x6750),	/* MT26448 [ConnectX EN 10GigE, PCIe 2.0 5GT/s] */
+	HCA(MELLANOX, 0x6372),	/* MT25408 [ConnectX EN 10GigE 10GBaseT, PCIe 2.0 2.5GT/s] */
+	HCA(MELLANOX, 0x675a),	/* MT25408 [ConnectX EN 10GigE 10GBaseT, PCIe Gen2 5GT/s] */
+	HCA(MELLANOX, 0x6764),	/* MT26468 [ConnectX EN 10GigE, PCIe 2.0 5GT/s Virt+] */
+	HCA(MELLANOX, 0x6746),	/* MT26438 [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE Virt+] */
+	HCA(MELLANOX, 0x676e),	/* MT26478 [ConnectX EN 40GigE PCIe 2.0 5GT/s] */
+	HCA(MELLANOX, 0x6778),	/* MT26488 [ConnectX VPI PCIe 2.0 5GT/s - IB DDR / 10GigE Virt+] */
+	HCA(MELLANOX, 0x1002),	/* MT25400 Family [ConnectX-2 Virtual Function] */
+	HCA(MELLANOX, 0x1003),	/* MT27500 Family [ConnectX-3] */
+	HCA(MELLANOX, 0x1004),	/* MT27500 Family [ConnectX-3 Virtual Function] */
+	HCA(MELLANOX, 0x1005),	/* MT27510 Family */
+	HCA(MELLANOX, 0x1006),	/* MT27511 Family */
+	HCA(MELLANOX, 0x1007),	/* MT27520 Family */
+	HCA(MELLANOX, 0x1008),	/* MT27521 Family */
+	HCA(MELLANOX, 0x1009),	/* MT27530 Family */
+	HCA(MELLANOX, 0x100a),	/* MT27531 Family */
+	HCA(MELLANOX, 0x100b),	/* MT27540 Family */
+	HCA(MELLANOX, 0x100c),	/* MT27541 Family */
+	HCA(MELLANOX, 0x100d),	/* MT27550 Family */
+	HCA(MELLANOX, 0x100e),	/* MT27551 Family */
+	HCA(MELLANOX, 0x100f),	/* MT27560 Family */
+	HCA(MELLANOX, 0x1010),	/* MT27561 Family */
 };
 
 static struct ibv_context_ops mlx4_ctx_ops = {
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
