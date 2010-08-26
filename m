From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv10 2/2] libmlx4: Add Eth devices to ib devices list
Date: Thu, 26 Aug 2010 17:20:03 +0300
Message-ID: <20100826142003.GS8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With the new IBoE implementation, Ethernet devices expose also IB devices.
Update the list of supported devices with that of the kernel.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 src/mlx4.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 1295c53..6068208 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -66,6 +66,13 @@ struct {
 	HCA(MELLANOX, 0x6354),	/* MT25408 "Hermon" QDR */
 	HCA(MELLANOX, 0x6732),	/* MT25408 "Hermon" DDR PCIe gen2 */
 	HCA(MELLANOX, 0x673c),	/* MT25408 "Hermon" QDR PCIe gen2 */
+	HCA(MELLANOX, 0x6368), /* MT25448 [ConnectX EN 10GigE, PCIe 2.0 2.5GT/s] */
+	HCA(MELLANOX, 0x6750), /* MT26448 [ConnectX EN 10GigE, PCIe 2.0 5GT/s] */
+	HCA(MELLANOX, 0x6372), /* MT25408 [ConnectX EN 10GigE 10GBaseT, PCIe 2.0 2.5GT/s] */
+	HCA(MELLANOX, 0x675a), /* MT25408 [ConnectX EN 10GigE 10GBaseT, PCIe Gen2 5GT/s] */
+	HCA(MELLANOX, 0x6764), /* MT26468 [ConnectX EN 10GigE, PCIe 2.0 5GT/s] */
+	HCA(MELLANOX, 0x6746), /* MT26438 ConnectX EN 40GigE PCIe gen2 5GT/s */
+	HCA(MELLANOX, 0x676e), /* MT26478 ConnectX2 40GigE PCIe gen2 */
 };
 
 static struct ibv_context_ops mlx4_ctx_ops = {
-- 
1.7.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
