From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/5] IB/core: Introduce delay drop for a WQ
Date: Tue, 30 May 2017 10:29:10 +0300
Message-ID: <20170530072914.9709-2-leon@kernel.org>
References: <20170530072914.9709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530072914.9709-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Work queue which is created with IB_WQ_FLAGS_DELAY_DROP won't
cause packet drops when there aren't receive WQEs, but will wait until
posting of receive WQEs or for some period of time that the device
was configured with.

It includes:
 * Add a new creation flag to enable delay drop functionality in a WQ.
 * A new capability was introduced - IB_RAW_PACKET_CAP_DELAY_DROP, which
   is the device's ability to delay packet drops when there aren't receive
   WQEs.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ba8314ec5768..7574c52dc355 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1546,6 +1546,10 @@ enum ib_raw_packet_caps {
 	IB_RAW_PACKET_CAP_SCATTER_FCS		= (1 << 1),
 	/* Checksum offloads are supported (for both send and receive). */
 	IB_RAW_PACKET_CAP_IP_CSUM		= (1 << 2),
+	/* When a packet is received for an RQ with no receive WQEs, the
+	 * packet processing is delayed.
+	 */
+	IB_RAW_PACKET_CAP_DELAY_DROP		= (1 << 3),
 };

 enum ib_wq_type {
@@ -1574,6 +1578,7 @@ struct ib_wq {
 enum ib_wq_flags {
 	IB_WQ_FLAGS_CVLAN_STRIPPING	= 1 << 0,
 	IB_WQ_FLAGS_SCATTER_FCS		= 1 << 1,
+	IB_WQ_FLAGS_DELAY_DROP		= 1 << 2,
 };

 struct ib_wq_init_attr {
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
