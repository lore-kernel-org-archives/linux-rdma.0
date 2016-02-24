From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Wed, 24 Feb 2016 11:41:57 +0200
Message-ID: <1456306924-31298-2-git-send-email-yishaih@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456306924-31298-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is an extension verb for ibv_poll_cq. It allows the user to poll
the cq for specific wc fields only, while allowing to extend the wc.
The verb calls the provider in order to fill the WC with the required
information.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 107 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 6451d0f..99d6265 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -386,6 +386,79 @@ struct ibv_wc {
 	uint8_t			dlid_path_bits;
 };
 
+enum ibv_wc_flags_ex {
+	IBV_WC_EX_GRH			= 1 << 0,
+	IBV_WC_EX_IMM			= 1 << 1,
+	IBV_WC_EX_CSUM_OK		= 1 << 2,
+	IBV_WC_EX_INV			= 1 << 3,
+	IBV_WC_EX_WITH_BYTE_LEN		= 1 << 4,
+	IBV_WC_EX_WITH_IMM		= 1 << 5,
+	IBV_WC_EX_WITH_QP_NUM		= 1 << 6,
+	IBV_WC_EX_WITH_SRC_QP		= 1 << 7,
+	IBV_WC_EX_WITH_PKEY_INDEX	= 1 << 8,
+	IBV_WC_EX_WITH_SLID		= 1 << 9,
+	IBV_WC_EX_WITH_SL		= 1 << 10,
+	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 11,
+};
+
+enum {
+	IBV_WC_STANDARD_FLAGS = IBV_WC_EX_WITH_BYTE_LEN		|
+				 IBV_WC_EX_WITH_IMM		|
+				 IBV_WC_EX_WITH_QP_NUM		|
+				 IBV_WC_EX_WITH_SRC_QP		|
+				 IBV_WC_EX_WITH_PKEY_INDEX	|
+				 IBV_WC_EX_WITH_SLID		|
+				 IBV_WC_EX_WITH_SL		|
+				 IBV_WC_EX_WITH_DLID_PATH_BITS
+};
+
+/* fields order in wc_ex
+ * Note: To guarantee compatibility a new field will be added after fields
+ * of the same size.
+ *	uint32_t		byte_len,
+ *	uint32_t		imm_data;
+ *	uint32_t		qp_num;
+ *	uint32_t		src_qp;
+ *	uint16_t		pkey_index;
+ *	uint16_t		slid;
+ *	uint8_t			sl;
+ *	uint8_t			dlid_path_bits;
+ */
+
+enum {
+	IBV_WC_EX_WITH_64BIT_FIELDS = 0
+};
+
+enum {
+	IBV_WC_EX_WITH_32BIT_FIELDS = IBV_WC_EX_WITH_BYTE_LEN		|
+				      IBV_WC_EX_WITH_IMM		|
+				      IBV_WC_EX_WITH_QP_NUM		|
+				      IBV_WC_EX_WITH_SRC_QP
+};
+
+enum {
+	IBV_WC_EX_WITH_16BIT_FIELDS = IBV_WC_EX_WITH_PKEY_INDEX		|
+				      IBV_WC_EX_WITH_SLID
+};
+
+enum {
+	IBV_WC_EX_WITH_8BIT_FIELDS = IBV_WC_EX_WITH_SL			|
+				     IBV_WC_EX_WITH_DLID_PATH_BITS
+};
+
+struct ibv_wc_ex {
+	uint64_t		wr_id;
+	/* wc_flags is a combination of ibv_wc_flags_ex flags. The IBV_WC_EX_WITH_XXX
+	 * flags dynamically define the valid fields in buffer[0].
+	 */
+	uint64_t		wc_flags;
+	uint32_t		status;
+	uint32_t		opcode;
+	uint32_t		vendor_err;
+	uint32_t		reserved;
+	uint8_t			buffer[0];
+};
+
 enum ibv_access_flags {
 	IBV_ACCESS_LOCAL_WRITE		= 1,
 	IBV_ACCESS_REMOTE_WRITE		= (1<<1),
@@ -1052,8 +1125,16 @@ enum verbs_context_mask {
 	VERBS_CONTEXT_RESERVED	= 1 << 5
 };
 
+struct ibv_poll_cq_ex_attr {
+	unsigned int	max_entries;
+	uint32_t	comp_mask;
+};
+
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*poll_cq_ex)(struct ibv_cq *ibcq,
+			  struct ibv_wc_ex *wc,
+			  struct ibv_poll_cq_ex_attr *attr);
 	int (*query_device_ex)(struct ibv_context *context,
 			       const struct ibv_query_device_ex_input *input,
 			       struct ibv_device_attr_ex *attr,
@@ -1454,6 +1535,32 @@ ibv_create_srq_ex(struct ibv_context *context,
 }
 
 /**
+ * ibv_poll_cq_ex - Poll a CQ for work completions
+ * @cq:the CQ being polled
+ * @wc:array of @max_entries of &struct ibv_wc_ex where completions
+ *   will be returned
+ * @attr: Poll cq attributs
+ *
+ * Poll a CQ for (possibly multiple) completions.  If the return value
+ * is < 0, an error occurred.  If the return value is >= 0, it is the
+ * number of completions returned.  If the return value is
+ * non-negative and strictly less than max_entries, then the CQ was
+ * emptied.
+ */
+
+static inline int ibv_poll_cq_ex(struct ibv_cq *ibcq,
+				 struct ibv_wc_ex *wc,
+				 struct ibv_poll_cq_ex_attr *attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(ibcq->context,
+						      poll_cq_ex);
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->poll_cq_ex(ibcq, wc, attr);
+}
+
+/**
  * ibv_modify_srq - Modifies the attributes for the specified SRQ.
  * @srq: The SRQ to modify.
  * @srq_attr: On input, specifies the SRQ attributes to modify.  On output,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
