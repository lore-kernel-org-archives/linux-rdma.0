From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 REPOST 01/10] IB/core: Add XRQ capabilities
Date: Thu, 17 Aug 2017 15:52:03 +0300
Message-ID: <20170817125212.3173-2-leon@kernel.org>
References: <20170817125212.3173-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125212.3173-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds following TM XRQ capabilities:

* max_rndv_hdr_size - Max size of rendezvous request message
* max_num_tags - Max number of entries in tag matching list
* max_ops - Max number of outstanding list operations
* max_sge - Max number of SGE in tag matching entry
* flags - the following flags are currently defined:
    - IB_TM_CAP_RC - Support tag matching on RC transport

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4ce188128aa9..afb863212419 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -280,6 +280,24 @@ struct ib_rss_caps {
 	u32 max_rwq_indirection_table_size;
 };

+enum ib_tm_cap_flags {
+	/*  Support tag matching on RC transport */
+	IB_TM_CAP_RC		    = 1 << 0,
+};
+
+struct ib_xrq_caps {
+	/* Max size of RNDV header */
+	u32 max_rndv_hdr_size;
+	/* Max number of entries in tag matching list */
+	u32 max_num_tags;
+	/* From enum ib_tm_cap_flags */
+	u32 flags;
+	/* Max number of outstanding list operations */
+	u32 max_ops;
+	/* Max number of SGE in tag matching entry */
+	u32 max_sge;
+};
+
 enum ib_cq_creation_flags {
 	IB_CQ_FLAGS_TIMESTAMP_COMPLETION   = 1 << 0,
 	IB_CQ_FLAGS_IGNORE_OVERRUN	   = 1 << 1,
@@ -340,6 +358,7 @@ struct ib_device_attr {
 	struct ib_rss_caps	rss_caps;
 	u32			max_wq_type_rq;
 	u32			raw_packet_caps; /* Use ib_raw_packet_caps enum */
+	struct ib_xrq_caps	xrq_caps;
 };

 enum ib_mtu {
--
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
