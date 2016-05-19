From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 libibverbs 4/7] Add completion timestamp to poll_cq
Date: Thu, 19 May 2016 14:51:39 +0300
Message-ID: <1463658702-9975-5-git-send-email-yishaih@mellanox.com>
References: <1463658702-9975-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463658702-9975-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to report when a completion was created, we add a member
function to the CQ which reads the completion timestamp from the
current CQ. The time is given in raw format.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/kern-abi.h | 4 ++++
 include/infiniband/verbs.h    | 7 +++++++
 man/ibv_create_cq_ex.3        | 4 ++++
 src/cmd.c                     | 6 ++++++
 4 files changed, 21 insertions(+)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index a2c0c46..f882cc9 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -447,6 +447,10 @@ struct ibv_create_cq_resp {
 	__u32 cqe;
 };
 
+enum ibv_create_cq_ex_kernel_flags {
+	IBV_CREATE_CQ_EX_KERNEL_FLAG_COMPLETION_TIMESTAMP = 1 << 0,
+};
+
 struct ibv_create_cq_ex {
 	struct ex_hdr	hdr;
 	__u64		user_handle;
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 054d6a7..c5a0177 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -371,6 +371,7 @@ enum ibv_create_cq_wc_flags {
 	IBV_WC_EX_WITH_SLID		= 1 << 5,
 	IBV_WC_EX_WITH_SL		= 1 << 6,
 	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 7,
+	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP	= 1 << 8,
 };
 
 enum {
@@ -892,6 +893,7 @@ struct ibv_cq_ex {
 	uint16_t (*read_slid)(struct ibv_cq_ex *current);
 	uint8_t (*read_sl)(struct ibv_cq_ex *current);
 	uint8_t (*read_dlid_path_bits)(struct ibv_cq_ex *current);
+	uint64_t (*read_completion_ts)(struct ibv_cq_ex *current);
 };
 
 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -980,6 +982,11 @@ static inline uint8_t ibv_wc_read_dlid_path_bits(struct ibv_cq_ex *cq)
 	return cq->read_dlid_path_bits(cq);
 }
 
+static inline uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex *cq)
+{
+	return cq->read_completion_ts(cq);
+}
+
 struct ibv_ah {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
diff --git a/man/ibv_create_cq_ex.3 b/man/ibv_create_cq_ex.3
index 1dc3e43..4f8ff4b 100644
--- a/man/ibv_create_cq_ex.3
+++ b/man/ibv_create_cq_ex.3
@@ -39,6 +39,7 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_SLID                  = 1 << 5,  /* Require slid in WC */
         IBV_WC_EX_WITH_SL                    = 1 << 6,  /* Require sl in WC */
         IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 7,  /* Require dlid path bits in WC */
+        IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 8,  /* Require completion timestamp in WC /*
 };
 
 .SH "Polling an extended CQ"
@@ -118,6 +119,9 @@ These functions are used in order to poll the current completion. The current co
 .BI "uint8_t ibv_wc_read_dlid_path_bits(struct ibv_cq_ex " "*cq"); \c
  Get the dlid_path_bits field from the current completion.
 
+.BI "uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex " "*cq"); \c
+ Get the completion timestamp from the current completion.
+
 .SH "RETURN VALUE"
 .B ibv_create_cq_ex()
 returns a pointer to the CQ, or NULL if the request fails.
diff --git a/src/cmd.c b/src/cmd.c
index 777fded..647fbbb 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -484,6 +484,12 @@ int ibv_cmd_create_cq_ex(struct ibv_context *context,
 	cmd->comp_channel  = cq_attr->channel ? cq_attr->channel->fd : -1;
 	cmd->comp_mask = 0;
 
+	if (cmd_core_size >= offsetof(struct ibv_create_cq_ex, flags) +
+	    sizeof(cmd->flags)) {
+		if (cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)
+			cmd->flags |= IBV_CREATE_CQ_EX_KERNEL_FLAG_COMPLETION_TIMESTAMP;
+	}
+
 	err = write(context->cmd_fd, cmd, cmd_size);
 	if (err != cmd_size)
 		return errno;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
