From: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] Add new device IDs for ConnectX VPI HCAs
Date: Mon, 8 Feb 2010 16:04:55 +0200
Message-ID: <20100208140455.GA24593@vlad-laptop>
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
 src/mlx4.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 1295c53..973df68 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -66,6 +66,8 @@ struct {
 	HCA(MELLANOX, 0x6354),	/* MT25408 "Hermon" QDR */
 	HCA(MELLANOX, 0x6732),	/* MT25408 "Hermon" DDR PCIe gen2 */
 	HCA(MELLANOX, 0x673c),	/* MT25408 "Hermon" QDR PCIe gen2 */
+	HCA(MELLANOX, 0x6746),	/* MT26438 ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE Virt+ */
+	HCA(MELLANOX, 0x6778),	/* MT26488 ConnectX VPI PCIe 2.0 5GT/s - IB DDR / 10GigE Virt+ */
 };
 
 static struct ibv_context_ops mlx4_ctx_ops = {
-- 
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
