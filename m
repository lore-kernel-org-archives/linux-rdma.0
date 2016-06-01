From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 libibverbs 2/7] Add member functions to poll an extended CQ
Date: Wed,  1 Jun 2016 16:05:35 +0300
Message-ID: <1464786340-7630-3-git-send-email-yishaih@mellanox.com>
References: <1464786340-7630-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464786340-7630-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, ibv_poll_cq is one stop shop for polling all the
completion's attribute. The current implementation has a few
implications:
1. The vendor's completion format is transformed to an agnostic IB
   format (copying data which might has been used directly).
2. Adding new completion attributes means wasting more time in copies.
3. Extensible functions require wasting cycles on logic which
   determines whether a function is known and implemented in the
   provider.

In order to solve these problems, we introduce a new poll_cq mechanism
for extensible CQs. Polling is done in batches, where every batch
could contain more than one completion. A batch is started with
calling to start_poll function. This already fetches a completion
that the user can now query using the various query functions.
Advancing to the next completion is done using next_poll.
After querying all completions (or when the user wants to stop
fetching completions in the current batch), end_poll is called.

As 'wr_id' and 'status' are mostly used, they can be accessed directly
and there is no function call for.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 man/ibv_create_cq_ex.3     | 75 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 161 insertions(+)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index d6df5f1..5f4dcbf 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -858,6 +858,10 @@ struct ibv_cq {
 	uint32_t		async_events_completed;
 };
 
+struct ibv_poll_cq_attr {
+	uint32_t comp_mask;
+};
+
 struct ibv_cq_ex {
 	struct ibv_context     *context;
 	struct ibv_comp_channel *channel;
@@ -871,6 +875,22 @@ struct ibv_cq_ex {
 	uint32_t		async_events_completed;
 
 	uint32_t		comp_mask;
+	enum ibv_wc_status status;
+	uint64_t wr_id;
+	int (*start_poll)(struct ibv_cq_ex *current,
+			     struct ibv_poll_cq_attr *attr);
+	int (*next_poll)(struct ibv_cq_ex *current);
+	void (*end_poll)(struct ibv_cq_ex *current);
+	enum ibv_wc_opcode (*read_opcode)(struct ibv_cq_ex *current);
+	uint32_t (*read_vendor_err)(struct ibv_cq_ex *current);
+	uint32_t (*read_byte_len)(struct ibv_cq_ex *current);
+	uint32_t (*read_imm_data)(struct ibv_cq_ex *current);
+	uint32_t (*read_qp_num)(struct ibv_cq_ex *current);
+	uint32_t (*read_src_qp)(struct ibv_cq_ex *current);
+	int (*read_wc_flags)(struct ibv_cq_ex *current);
+	uint32_t (*read_slid)(struct ibv_cq_ex *current);
+	uint8_t (*read_sl)(struct ibv_cq_ex *current);
+	uint8_t (*read_dlid_path_bits)(struct ibv_cq_ex *current);
 };
 
 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -878,6 +898,72 @@ static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
 	return (struct ibv_cq *)cq;
 }
 
+static inline int ibv_start_poll(struct ibv_cq_ex *cq,
+				    struct ibv_poll_cq_attr *attr)
+{
+	return cq->start_poll(cq, attr);
+}
+
+static inline int ibv_next_poll(struct ibv_cq_ex *cq)
+{
+	return cq->next_poll(cq);
+}
+
+static inline void ibv_end_poll(struct ibv_cq_ex *cq)
+{
+	cq->end_poll(cq);
+}
+
+static inline enum ibv_wc_opcode ibv_wc_read_opcode(struct ibv_cq_ex *cq)
+{
+	return cq->read_opcode(cq);
+}
+
+static inline uint32_t ibv_wc_read_vendor_err(struct ibv_cq_ex *cq)
+{
+	return cq->read_vendor_err(cq);
+}
+
+static inline uint32_t ibv_wc_read_byte_len(struct ibv_cq_ex *cq)
+{
+	return cq->read_byte_len(cq);
+}
+
+static inline uint32_t ibv_wc_read_imm_data(struct ibv_cq_ex *cq)
+{
+	return cq->read_imm_data(cq);
+}
+
+static inline uint32_t ibv_wc_read_qp_num(struct ibv_cq_ex *cq)
+{
+	return cq->read_qp_num(cq);
+}
+
+static inline uint32_t ibv_wc_read_src_qp(struct ibv_cq_ex *cq)
+{
+	return cq->read_src_qp(cq);
+}
+
+static inline int ibv_wc_read_wc_flags(struct ibv_cq_ex *cq)
+{
+	return cq->read_wc_flags(cq);
+}
+
+static inline uint32_t ibv_wc_read_slid(struct ibv_cq_ex *cq)
+{
+	return cq->read_slid(cq);
+}
+
+static inline uint8_t ibv_wc_read_sl(struct ibv_cq_ex *cq)
+{
+	return cq->read_sl(cq);
+}
+
+static inline uint8_t ibv_wc_read_dlid_path_bits(struct ibv_cq_ex *cq)
+{
+	return cq->read_dlid_path_bits(cq);
+}
+
 struct ibv_ah {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
diff --git a/man/ibv_create_cq_ex.3 b/man/ibv_create_cq_ex.3
index e8e4eb8..3e113b8 100644
--- a/man/ibv_create_cq_ex.3
+++ b/man/ibv_create_cq_ex.3
@@ -40,6 +40,81 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 6,  /* Require dlid path bits in WC */
 };
 
+.SH "Polling an extended CQ"
+In order to poll an extended CQ efficiently, a user could use the following functions.
+
+.TP
+.B Completion iterator functions
+
+.BI "int ibv_start_poll(struct ibv_cq_ex " "*cq" ", struct ibv_poll_cq_attr " "*attr")
+.br
+Start polling a batch of work completions.
+.I attr
+is given in order to make this function
+easily extensible in the future. This function either returns 0 on success or an error code
+otherwise. When no completions are available on the CQ, ENOENT is returned, but the CQ remains
+in a valid state. On success, querying the completion's attribute could be done using the query
+functions described below. If an error code is given, end_poll shouldn't be called.
+
+.BI "int ibv_next_poll(struct ibv_cq_ex " "*cq")
+.br
+This function is called in order to get the next work completion. It has to be called after
+.I start_poll
+and before
+.I end_poll
+are called. This function either returns 0 on success or an error code
+otherwise. When no completions are available on the CQ, ENOENT is returned, but the CQ remains
+in a valid state. On success, querying the completion's attribute could be done using the query
+functions described below. If an error code is given, end_poll should still be called,
+indicating this is the end of the polled batch.
+
+.BI "void ibv_end_poll(struct ibv_cq_ex " "*cq")
+.br
+This function indicates the end of polling batch of work completions. After calling this function, the user should start a new batch
+by calling
+.I start_poll.
+
+.TP
+.B Polling fields in the completion
+Below members and functions are used in order to poll the current completion. The current completion is the completion which the iterator points to (start_poll and next_poll advances this iterator). Only fields that the user requested via wc_flags in ibv_create_cq_ex could be queried. In addition, some fields are only valid in certain opcodes and status codes.
+
+.BI "uint64_t wr_id - Can be accessed directly from struct ibv_cq_ex".
+
+.BI "enum ibv_wc_status - Can be accessed directly from struct ibv_cq_ex".
+
+.BI "enum ibv_wc_opcode ibv_wc_read_opcode(struct ibv_cq_ex " "*cq"); \c
+ Get the opcode from the current completion.
+
+.BI "uint32_t ibv_wc_read_vendor_err(struct ibv_cq_ex " "*cq"); \c
+ Get the vendor error from the current completion.
+
+.BI "uint32_t ibv_wc_read_byte_len(struct ibv_cq_ex " "*cq"); \c
+ Get the vendor error from the current completion.
+
+.BI "uint32_t ibv_wc_read_imm_data(struct ibv_cq_ex " "*cq"); \c
+ Get the immediate data field from the current completion.
+
+.BI "uint32_t ibv_wc_read_qp_num(struct ibv_cq_ex " "*cq"); \c
+ Get the QP number field from the current completion.
+
+.BI "uint32_t ibv_wc_read_src_qp(struct ibv_cq_ex " "*cq"); \c
+ Get the source QP number field from the current completion.
+
+.BI "int ibv_wc_read_wc_flags(struct ibv_cq_ex " "*cq"); \c
+ Get the QP flags field from the current completion.
+
+.BI "uint16_t ibv_wc_read_pkey_index(struct ibv_cq_ex " "*cq"); \c
+ Get the pkey index field from the current completion.
+
+.BI "uint32_t ibv_wc_read_slid(struct ibv_cq_ex " "*cq"); \c
+ Get the slid field from the current completion.
+
+.BI "uint8_t ibv_wc_read_sl(struct ibv_cq_ex " "*cq"); \c
+ Get the sl field from the current completion.
+
+.BI "uint8_t ibv_wc_read_dlid_path_bits(struct ibv_cq_ex " "*cq"); \c
+ Get the dlid_path_bits field from the current completion.
+
 .SH "RETURN VALUE"
 .B ibv_create_cq_ex()
 returns a pointer to the CQ, or NULL if the request fails.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
