From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 04/10] IB/uverbs: Expose tag matching capabilties to UAPI
Date: Sun, 28 Aug 2016 14:00:44 +0300
Message-ID: <1472382050-25908-5-git-send-email-leon@kernel.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose following tag matching capabilities to UAPI:

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
 include/uapi/rdma/ib_user_verbs.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 7f035f4b..4da8f90 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -224,6 +224,39 @@ struct ib_uverbs_odp_caps {
 	__u32 reserved;
 };

+
+enum ibv_tm_cap_flags {
+	/* The HW supports messages without tag
+	 * sent on QPs attached to a XRQ
+	 */
+	IB_NO_TAG	     = 1 << 0,
+	/* The HW supports tag matching for EAGER messages when
+	 * the send arrives after the corresponding receive
+	 */
+	IB_EAGER_EXPECTED   = 1 << 1,
+	/* The HW supports tag matching for EAGER messages when
+	 * the send arrives before the corresponding receive
+	 */
+	IB_EAGER_UNEXPECTED = 1 << 2,
+	/* The HW supports tag matching for RANDEZVOUS messages when
+	 * the send arrives after the corresponding receive (for RC QPs)
+	 */
+	IB_RNDV_EXPECTED    = 1 << 3,
+	/* The HW supports tag matching for RANDEZVOUS messages when
+	 * the send arrives before the corresponding receive
+	 */
+	IB_RNDV_UNEXPECTED  = 1 << 5,
+};
+
+struct ib_uverbs_tm_caps {
+	__u32 max_unexpected_tags;
+	__u32 tag_mask_length;
+	__u32 header_size;
+	__u32 app_context_size;
+	__u32 max_match_list;
+	__u32 capability_flags;
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
@@ -232,6 +265,7 @@ struct ib_uverbs_ex_query_device_resp {
 	__u64 timestamp_mask;
 	__u64 hca_core_clock; /* in KHZ */
 	__u64 device_cap_flags_ex;
+	struct ib_uverbs_tm_caps xrq_caps;
 };

 struct ib_uverbs_query_port {
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
