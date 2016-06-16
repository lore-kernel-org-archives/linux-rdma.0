From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 rdma-next 24/29] IB/rxe: Invariant CRC implementation
Date: Thu, 16 Jun 2016 16:45:46 +0300
Message-ID: <1466084751-29901-25-git-send-email-monis@mellanox.com>
References: <1466084751-29901-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466084751-29901-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Compute and match ICRC as defined in spec for sent and received packets.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/rxe/rxe_icrc.c | 96 ++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 drivers/infiniband/hw/rxe/rxe_icrc.c

diff --git a/drivers/infiniband/hw/rxe/rxe_icrc.c b/drivers/infiniband/hw/rxe/rxe_icrc.c
new file mode 100644
index 0000000..413b56b
--- /dev/null
+++ b/drivers/infiniband/hw/rxe/rxe_icrc.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include "rxe.h"
+#include "rxe_loc.h"
+
+/* Compute a partial ICRC for all the IB transport headers. */
+u32 rxe_icrc_hdr(struct rxe_pkt_info *pkt, struct sk_buff *skb)
+{
+	unsigned int bth_offset = 0;
+	struct iphdr *ip4h = NULL;
+	struct ipv6hdr *ip6h = NULL;
+	struct udphdr *udph;
+	struct rxe_bth *bth;
+	int crc;
+	int length;
+	int hdr_size = sizeof(struct udphdr) +
+		(skb->protocol == htons(ETH_P_IP) ?
+		sizeof(struct iphdr) : sizeof(struct ipv6hdr));
+	/* pseudo header buffer size is calculate using ipv6 header size since
+	 * it is bigger than ipv4
+	 */
+	u8 pshdr[sizeof(struct udphdr) +
+		sizeof(struct ipv6hdr) +
+		RXE_BTH_BYTES];
+
+	/* This seed is the result of computing a CRC with a seed of
+	 * 0xfffffff and 8 bytes of 0xff representing a masked LRH.
+	 */
+	crc = 0xdebb20e3;
+
+	if (skb->protocol == htons(ETH_P_IP)) { /* IPv4 */
+		memcpy(pshdr, ip_hdr(skb), hdr_size);
+		ip4h = (struct iphdr *)pshdr;
+		udph = (struct udphdr *)(ip4h + 1);
+
+		ip4h->ttl = 0xff;
+		ip4h->check = CSUM_MANGLED_0;
+		ip4h->tos = 0xff;
+	} else {				/* IPv6 */
+		memcpy(pshdr, ipv6_hdr(skb), hdr_size);
+		ip6h = (struct ipv6hdr *)pshdr;
+		udph = (struct udphdr *)(ip6h + 1);
+
+		memset(ip6h->flow_lbl, 0xff, sizeof(ip6h->flow_lbl));
+		ip6h->priority = 0xf;
+		ip6h->hop_limit = 0xff;
+	}
+	udph->check = CSUM_MANGLED_0;
+
+	bth_offset += hdr_size;
+
+	memcpy(&pshdr[bth_offset], pkt->hdr, RXE_BTH_BYTES);
+	bth = (struct rxe_bth *)&pshdr[bth_offset];
+
+	/* exclude bth.resv8a */
+	bth->qpn |= cpu_to_be32(~BTH_QPN_MASK);
+
+	length = hdr_size + RXE_BTH_BYTES;
+	crc = crc32_le(crc, pshdr, length);
+
+	/* And finish to compute the CRC on the remainder of the headers. */
+	crc = crc32_le(crc, pkt->hdr + RXE_BTH_BYTES,
+		       rxe_opcode[pkt->opcode].length - RXE_BTH_BYTES);
+	return crc;
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
