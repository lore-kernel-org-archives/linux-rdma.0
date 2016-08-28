From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/3] IB/core: Expose RSS related capabilities
Date: Sun, 28 Aug 2016 11:28:43 +0300
Message-ID: <1472372925-17660-2-git-send-email-leon@kernel.org>
References: <1472372925-17660-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472372925-17660-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose RSS related capabilities, it includes both direct ones (i.e.
struct ib_rss_caps) and max_wq_type_rq which may be used in both
RSS and non RSS flows.

Specifically,
supported_qpts:
- QP types that support RSS on the device.

max_rwq_indirection_tables:
- Max number of receive work queue indirection tables that
  could be opened on the device.

max_rwq_indirection_table_size:
- Max size of a receive work queue indirection table.

max_wq_type_rq:
- Max number of work queues of receive type that
  could be opened on the device.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8e90dd2..eacbde7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -261,6 +261,16 @@ struct ib_odp_caps {
 	} per_transport_caps;
 };

+struct ib_rss_caps {
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_UD
+	 */
+	u32 supported_qpts;
+	u32 max_rwq_indirection_tables;
+	u32 max_rwq_indirection_table_size;
+};
+
 enum ib_cq_creation_flags {
 	IB_CQ_FLAGS_TIMESTAMP_COMPLETION   = 1 << 0,
 	IB_CQ_FLAGS_IGNORE_OVERRUN	   = 1 << 1,
@@ -318,6 +328,8 @@ struct ib_device_attr {
 	struct ib_odp_caps	odp_caps;
 	uint64_t		timestamp_mask;
 	uint64_t		hca_core_clock; /* in KHZ */
+	struct ib_rss_caps	rss_caps;
+	u32			max_wq_type_rq;
 };

 enum ib_mtu {
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
