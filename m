From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc2 V1 5/5] IB/core: Set correct payload length for RoCEv2 over IPv6
Date: Thu, 28 Jan 2016 17:51:50 +0200
Message-ID: <1453996310-3360-6-git-send-email-matanb@mellanox.com>
References: <1453996310-3360-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453996310-3360-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For GSI QP traffic, the count of the udp header bytes was missing from
the IPv6 header, fix that.

Fixes: 25f40220e56b ('IB/core: Initialize UD header structure with IP
                     and UDP headers')
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ud_header.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index 19837d2..2116132 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -322,6 +322,8 @@ int ib_ud_header_init(int     payload_bytes,
 		      int    immediate_present,
 		      struct ib_ud_header *header)
 {
+	size_t udp_bytes = udp_present ? IB_UDP_BYTES : 0;
+
 	grh_present = grh_present && !ip_version;
 	memset(header, 0, sizeof *header);
 
@@ -353,7 +355,8 @@ int ib_ud_header_init(int     payload_bytes,
 	if (ip_version == 6 || grh_present) {
 		header->grh.ip_version      = 6;
 		header->grh.payload_length  =
-			cpu_to_be16((IB_BTH_BYTES     +
+			cpu_to_be16((udp_bytes        +
+				     IB_BTH_BYTES     +
 				     IB_DETH_BYTES    +
 				     payload_bytes    +
 				     4                + /* ICRC     */
@@ -362,8 +365,6 @@ int ib_ud_header_init(int     payload_bytes,
 	}
 
 	if (ip_version == 4) {
-		int udp_bytes = udp_present ? IB_UDP_BYTES : 0;
-
 		header->ip4.ver = 4; /* version 4 */
 		header->ip4.hdr_len = 5; /* 5 words */
 		header->ip4.tot_len =
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
