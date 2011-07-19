From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 7/7] libmlx4: align the list of ConnectX devices supported
 with the kernel
Date: Tue, 19 Jul 2011 12:36:13 +0300
Message-ID: <alpine.LRH.2.00.1107191234410.5580@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1107191223460.5580-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

align the list of ConnectX devices supported by the library to be
the same as the mlx4 driver from the upstream kernel

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Roland, these two simple awk/cut commands can be used to
actually validate the claim made by the change log...

$ grep MELLANOX libmlx4.git/src/mlx4.c | grep HCA | awk '{ print $2 }' | cut -d ")" -f 1 > lib
$ grep MELLANOX linux-2.6.git/drivers/net/mlx4/main.c | awk '{ print $3 }' | cut -d ")" -f 1 > ker
$ diff lib ker

The patch previously posted @ http://www.spinics.net/lists/linux-rdma/msg07237.html
contains also the VPI/DDR device which isn't present in the kernel (device id 0x6778).
Once the table cleanup brought by this patch takes place, we can add further
patches to both the library and the kernel e.g with that DDR device, etc.

 src/mlx4.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 1295c53..ab18b4a 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -66,8 +66,31 @@ struct {
 	HCA(MELLANOX, 0x6354),	/* MT25408 "Hermon" QDR */
 	HCA(MELLANOX, 0x6732),	/* MT25408 "Hermon" DDR PCIe gen2 */
 	HCA(MELLANOX, 0x673c),	/* MT25408 "Hermon" QDR PCIe gen2 */
+	HCA(MELLANOX, 0x6368),	/* MT25408 "Hermon" EN 10GigE */
+	HCA(MELLANOX, 0x6750),	/* MT25408 "Hermon" EN 10GigE PCIe gen2 */
+	HCA(MELLANOX, 0x6372),	/* MT25458 ConnectX EN 10GBASE-T 10GigE */
+	HCA(MELLANOX, 0x675a),	/* MT25458 ConnectX EN 10GBASE-T+Gen2 10GigE */
+	HCA(MELLANOX, 0x6764),	/* MT26468 ConnectX EN 10GigE PCIe gen2*/
+	HCA(MELLANOX, 0x6746),	/* MT26438 ConnectX EN 40GigE PCIe gen2 5GT/s */
+	HCA(MELLANOX, 0x676e),	/* MT26478 ConnectX2 40GigE PCIe gen2 */
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

+
 static struct ibv_context_ops mlx4_ctx_ops = {
 	.query_device  = mlx4_query_device,
 	.query_port    = mlx4_query_port,
-- 
1.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
