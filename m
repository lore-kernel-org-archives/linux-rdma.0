From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 09/10] verbs: Tag matching receive interface
Date: Mon, 23 Oct 2017 16:18:00 +0300
Message-ID: <1508764681-4531-10-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

It includes:
- Extending enum ibv_wc_status and enum ibv_wc_flags to hold tag
  matching information.
- Adding new read function ibv_wc_read_tm_info() to read
  additional TM related information from the CQE.

Detailed description of the TM receiver mechanism was added to
Documentation/tag_matching.md.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/tag_matching.md     | 41 +++++++++++++++++++++++++++++++++++++++
 libibverbs/enum_strs.c            |  3 ++-
 libibverbs/man/ibv_create_cq_ex.3 | 11 +++++++++++
 libibverbs/verbs.h                | 22 ++++++++++++++++++++-
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/Documentation/tag_matching.md b/Documentation/tag_matching.md
index 23d6532..81d4dd8 100644
--- a/Documentation/tag_matching.md
+++ b/Documentation/tag_matching.md
@@ -298,3 +298,44 @@ Tag-manipulation operations generate the following completion opcodes:
 These completions are complemented by the **IBV_WC_TM_SYNC_REQ** flag, which
 indicates whether further HW synchronization is needed.
 
+TM receive completions generate the following completion codes:
+* **IBV_WC_RECV** - standard SRQ completion; used for unexpected messages
+* **IBV_WC_TM_NO_TAG** - completion of a message sent with the
+  **IBV_TM_NO_TAG** opcode.
+* **IBV_WC_TM_RECV** - completion of a tag-matching operation
+
+The **IBV_WC_TM_RECV** completion is complemented by the following completion
+flags:
+-	**IBV_WC_TM_MATCH** - a match was performed
+-	**IBV_WC_TM_DATA_VALID** - all data of the matched message has been
+	delivered to memory
+
+In single-packet eager messages, both flags are set. When larger messages or
+rendezvous transfers are involved, matching and data transfer completion are
+distinct events that generate 2 completion events for the same **recv_wr_id**.
+While data transfer completions may be arbitrarily delayed depending on
+message size, matching completion is reported immediately and is always
+serialized with respect to other matches and the completion of unexpected
+messages.
+
+In addition, **IBV_WC_TM_RECV** completions provide further information about
+the matched message. This information is obtained using extended CQ processing
+via the following extractor function:
+
+```h
+static inline void ibv_wc_read_tm_info(struct ibv_cq_ex *cq,
+                                       struct ibv_wc_tm_info *tm_info);
+```
+```h
+struct ibv_wc_tm_info {
+	  uint64_t		  tag;	   /* tag from TMH */
+	  uint32_t		  priv;    /* opaque user data from TMH */
+};
+```
+
+Finally, when a posted tagged buffer is insufficient to hold the data of a
+rendezvous request, the HW completes the buffer with an
+IBV_WC_TM_RNDV_INCOMPLETE status. In this case, the TMH and RVH headers are
+scattered into the tagged buffer (tag-matching has still been completed!), and
+message handling is resumed by SW.
+
diff --git a/libibverbs/enum_strs.c b/libibverbs/enum_strs.c
index 93f2c56..c6f6e0f 100644
--- a/libibverbs/enum_strs.c
+++ b/libibverbs/enum_strs.c
@@ -123,9 +123,10 @@ const char *ibv_wc_status_str(enum ibv_wc_status status)
 		[IBV_WC_RESP_TIMEOUT_ERR]	= "response timeout error",
 		[IBV_WC_GENERAL_ERR]		= "general error",
 		[IBV_WC_TM_ERR]			= "TM error",
+		[IBV_WC_TM_RNDV_INCOMPLETE]     = "TM software rendezvous",
 	};
 
-	if (status < IBV_WC_SUCCESS || status > IBV_WC_TM_ERR)
+	if (status < IBV_WC_SUCCESS || status > IBV_WC_TM_RNDV_INCOMPLETE)
 		return "unknown";
 
 	return wc_status_str[status];
diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_create_cq_ex.3
index e943e0e..23f867c 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -140,6 +140,17 @@ Below members and functions are used in order to poll the current completion. Th
 .BI "uint32_t ibv_wc_read_flow_tag(struct ibv_cq_ex " "*cq"); \c
  Get flow tag from the current completion.
 
+.BI "void ibv_wc_read_tm_info(struct ibv_cq_ex " *cq ","
+.BI "struct ibv_wc_tm_info " *tm_info "); \c
+ Get tag matching info from the current completion.
+.nf
+struct ibv_wc_tm_info {
+.in +8
+uint64_t tag;  /* tag from TMH */
+uint32_t priv; /* opaque user data from TMH */
+.in -8
+};
+
 .SH "RETURN VALUE"
 .B ibv_create_cq_ex()
 returns a pointer to the CQ, or NULL if the request fails.
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 66f8c95..5bceb7b 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -429,6 +429,7 @@ enum ibv_wc_status {
 	IBV_WC_RESP_TIMEOUT_ERR,
 	IBV_WC_GENERAL_ERR,
 	IBV_WC_TM_ERR,
+	IBV_WC_TM_RNDV_INCOMPLETE,
 };
 const char *ibv_wc_status_str(enum ibv_wc_status status);
 
@@ -451,6 +452,8 @@ enum ibv_wc_opcode {
 	IBV_WC_TM_ADD,
 	IBV_WC_TM_DEL,
 	IBV_WC_TM_SYNC,
+	IBV_WC_TM_RECV,
+	IBV_WC_TM_NO_TAG,
 };
 
 enum {
@@ -468,6 +471,7 @@ enum ibv_create_cq_wc_flags {
 	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP	= 1 << 7,
 	IBV_WC_EX_WITH_CVLAN		= 1 << 8,
 	IBV_WC_EX_WITH_FLOW_TAG		= 1 << 9,
+	IBV_WC_EX_WITH_TM_INFO		= 1 << 10,
 };
 
 enum {
@@ -484,7 +488,8 @@ enum {
 	IBV_CREATE_CQ_SUP_WC_FLAGS = IBV_WC_STANDARD_FLAGS |
 				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
 				IBV_WC_EX_WITH_CVLAN |
-				IBV_WC_EX_WITH_FLOW_TAG
+				IBV_WC_EX_WITH_FLOW_TAG |
+				IBV_WC_EX_WITH_TM_INFO
 };
 
 enum ibv_wc_flags {
@@ -493,6 +498,8 @@ enum ibv_wc_flags {
 	IBV_WC_IP_CSUM_OK	= 1 << IBV_WC_IP_CSUM_OK_SHIFT,
 	IBV_WC_WITH_INV		= 1 << 3,
 	IBV_WC_TM_SYNC_REQ	= 1 << 4,
+	IBV_WC_TM_MATCH		= 1 << 5,
+	IBV_WC_TM_DATA_VALID	= 1 << 6,
 };
 
 struct ibv_wc {
@@ -1148,6 +1155,11 @@ struct ibv_poll_cq_attr {
 	uint32_t comp_mask;
 };
 
+struct ibv_wc_tm_info {
+	uint64_t		tag;	 /* tag from TMH */
+	uint32_t		priv;	 /* opaque user data from TMH */
+};
+
 struct ibv_cq_ex {
 	struct ibv_context     *context;
 	struct ibv_comp_channel *channel;
@@ -1180,6 +1192,8 @@ struct ibv_cq_ex {
 	uint64_t (*read_completion_ts)(struct ibv_cq_ex *current);
 	uint16_t (*read_cvlan)(struct ibv_cq_ex *current);
 	uint32_t (*read_flow_tag)(struct ibv_cq_ex *current);
+	void (*read_tm_info)(struct ibv_cq_ex *current,
+			     struct ibv_wc_tm_info *tm_info);
 };
 
 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -1277,6 +1291,12 @@ static inline uint32_t ibv_wc_read_flow_tag(struct ibv_cq_ex *cq)
 	return cq->read_flow_tag(cq);
 }
 
+static inline void ibv_wc_read_tm_info(struct ibv_cq_ex *cq,
+				       struct ibv_wc_tm_info *tm_info)
+{
+	cq->read_tm_info(cq, tm_info);
+}
+
 static inline int ibv_post_wq_recv(struct ibv_wq *wq,
 				   struct ibv_recv_wr *recv_wr,
 				   struct ibv_recv_wr **bad_recv_wr)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
