From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 01/10] IB/core: Add XRQ capabilities
Date: Sun, 28 Aug 2016 14:00:41 +0300
Message-ID: <1472382050-25908-2-git-send-email-leon@kernel.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds following XRQ capabilities:

* max_unexpected_tags - The maximum number of tags
    in the unexpected message list

* tag_mask_length - Number of bits in a tag matching mask

* header_size - The maximum size for the TM header including RNDV info

* app_context_size - The size for the application context field in the
    XRQ context

* max_match_list - Maximal number of tags which can be matched
    simultaneously

* capability_flags - Tag matching message type supported:
    - IBV_NO_TAG - The HW supports messages without tag
	sent on QPs attached to a XRQ
    - IBV_EAGER_EXPECTED - The HW supports tag matching
	for EAGER messages when the send arrives after
	the corresponding receive
    - IBV_EAGER_UNEXPECTED - The HW supports tag matching
	for EAGER messages when the send arrives before
	the corresponding receive
    - IBV_RNDV_MATCHED - The HW supports tag matching
	for RENDEZVOUS messages when the send arrives after
	the corresponding receive
    - IBV_RNDV_UNEXPECTED - The HW supports tag matching
	for RENDEZVOUS messages when the send arrives before
	the corresponding receive

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8e90dd2..000f57d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -261,6 +261,38 @@ struct ib_odp_caps {
 	} per_transport_caps;
 };
 
+enum ibv_xrq_cap_flags {
+	/* The HW supports messages without tag
+	 * sent on QPs attached to a XRQ
+	 */
+	IBV_NO_TAG	     = 1 << 0,
+	/* The HW supports tag matching for EAGER messages when
+	 * the send arrives after the corresponding receive
+	 */
+	IBV_EAGER_EXPECTED   = 1 << 1,
+	/* The HW supports tag matching for EAGER messages when
+	 * the send arrives before the corresponding receive
+	 */
+	IBV_EAGER_UNEXPECTED = 1 << 2,
+	/* The HW supports tag matching for RANDEZVOUS messages when
+	 * the send arrives after the corresponding receive (for RC QPs)
+	 */
+	IBV_RNDV_EXPECTED_RC = 1 << 3,
+	/* The HW supports tag matching for RANDEZVOUS messages when
+	 * the send arrives before the corresponding receive
+	 */
+	IBV_RNDV_UNEXPECTED  = 1 << 5,
+};
+
+struct ib_xrq_caps {
+	uint32_t max_unexpected_tags;
+	uint32_t tag_mask_length;
+	uint32_t header_size;
+	uint32_t app_context_size;
+	uint32_t max_match_list;
+	uint32_t capability_flags;
+};
+
 enum ib_cq_creation_flags {
 	IB_CQ_FLAGS_TIMESTAMP_COMPLETION   = 1 << 0,
 	IB_CQ_FLAGS_IGNORE_OVERRUN	   = 1 << 1,
@@ -318,6 +350,7 @@ struct ib_device_attr {
 	struct ib_odp_caps	odp_caps;
 	uint64_t		timestamp_mask;
 	uint64_t		hca_core_clock; /* in KHZ */
+	struct ib_xrq_caps	xrq_caps;
 };
 
 enum ib_mtu {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
