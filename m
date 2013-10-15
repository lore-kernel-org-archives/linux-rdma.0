From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 2/9] IB/core: Introduce Signature Verbs API
Date: Tue, 15 Oct 2013 18:38:23 +0300
Message-ID: <1381851510-17290-3-git-send-email-sagig@mellanox.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381851510-17290-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This commit Introduces the Verbs Interface for signature related
operations. A signature handover operation shall configure the
layouts of data and protection attributes both in memory and wire
domains. Once the signature handover opration is done, the HCA will
offload data integrity generation/validation while performing
the actual data transfer.

Additions:
1. HCA signature capabilities in device attributes
    Verbs provider supporting Signature handover operations shall
    fill relevant fields in device attributes structure returned
    by ib_query_device.

2. QP creation flag IB_QP_CREATE_SIGNATURE_EN
    Creating QP that will carry signature handover operations
    may require some special preperations from the verbs provider.
    So we add QP creation flag IB_QP_CREATE_SIGNATURE_EN to declare
    that the created QP may carry out signature handover operations.
    Expose signature support to verbs layer (no support for now)

3. New send work request IB_WR_REG_SIG_MR
    Signature handover work request. This WR will define
    the signature handover properties of the memory/wire
    domains as well as the domains layout.
    * Currently expose just T10-DIF layout.

4. New Verb ib_check_sig_status
    check_sig_status Verb shall check if any signature errors
    are pending for a specific signature related ib_mr.
    User should provide the ib_qp that executed the RDMA operation
    involving the given ib_mr.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    8 ++
 include/rdma/ib_verbs.h         |  140 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 147 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 1d94a5c..5636d65 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1293,3 +1293,11 @@ int ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 	return xrcd->device->dealloc_xrcd(xrcd);
 }
 EXPORT_SYMBOL(ib_dealloc_xrcd);
+
+int ib_check_sig_status(struct ib_mr *sig_mr,
+			struct ib_sig_err *sig_err)
+{
+	return sig_mr->device->check_sig_status ?
+		sig_mr->device->check_sig_status(sig_mr, sig_err) : -ENOSYS;
+}
+EXPORT_SYMBOL(ib_check_sig_status);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65b7e79..cf46a83 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -116,7 +116,19 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
-	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24)
+	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
+	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<25),
+};
+
+enum ib_signature_prot_cap {
+	IB_PROT_T10DIF_TYPE_1 = 1,
+	IB_PROT_T10DIF_TYPE_2 = 1 << 1,
+	IB_PROT_T10DIF_TYPE_3 = 1 << 2,
+};
+
+enum ib_signature_guard_cap {
+	IB_GUARD_T10DIF_CRC	= 1,
+	IB_GUARD_T10DIF_CSUM	= 1 << 1,
 };
 
 enum ib_atomic_cap {
@@ -166,6 +178,8 @@ struct ib_device_attr {
 	unsigned int		max_fast_reg_page_list_len;
 	u16			max_pkeys;
 	u8			local_ca_ack_delay;
+	enum ib_signature_prot_cap	sig_prot_cap;
+	enum ib_signature_guard_cap	sig_guard_cap;
 };
 
 enum ib_mtu {
@@ -630,6 +644,7 @@ enum ib_qp_type {
 enum ib_qp_create_flags {
 	IB_QP_CREATE_IPOIB_UD_LSO		= 1 << 0,
 	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
+	IB_QP_CREATE_SIGNATURE_EN		= 1 << 2,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
@@ -780,6 +795,7 @@ enum ib_wr_opcode {
 	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
 	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
 	IB_WR_BIND_MW,
+	IB_WR_REG_SIG_MR,
 	/* reserve values for low level drivers' internal use.
 	 * These values will not be used at all in the ib core layer.
 	 */
@@ -885,6 +901,19 @@ struct ib_send_wr {
 			u32                      rkey;
 			struct ib_mw_bind_info   bind_info;
 		} bind_mw;
+		struct {
+			struct ib_sig_attrs    *sig_attrs;
+			struct ib_mr	       *sig_mr;
+			int			access_flags;
+			/* Registered data mr */
+			struct ib_mr	       *data_mr;
+			u32			data_size;
+			u64			data_va;
+			/* Registered protection mr */
+			struct ib_mr	       *prot_mr;
+			u32			prot_size;
+			u64			prot_va;
+		} sig_handover;
 	} wr;
 	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */
 };
@@ -949,6 +978,97 @@ struct ib_mr_init_attr {
 	enum ib_mr_create_flags	flags;
 };
 
+enum ib_signature_type {
+	IB_SIG_TYPE_T10_DIF,
+};
+
+/**
+ * T10-DIF Signature types
+ * T10-DIF types are defined by SCSI
+ * specifications.
+ */
+enum ib_t10_dif_type {
+	IB_T10DIF_NONE,
+	IB_T10DIF_TYPE1,
+	IB_T10DIF_TYPE2,
+	IB_T10DIF_TYPE3
+};
+
+/**
+ * Signature T10-DIF block-guard types
+ */
+enum ib_t10_dif_bg_type {
+	IB_T10DIF_CRC,
+	IB_T10DIF_CSUM
+};
+
+/**
+ * struct ib_sig_domain - Parameters specific for T10-DIF
+ * 	domain.
+ * @sig_type: specific signauture type
+ * @sig: union of all signature domain attributes that may
+ * 	 be used to set domaim layout.
+ * 	 @dif:
+ * 		@type: T10-DIF type (0|1|2|3)
+ * 		@bg_type: T10-DIF block guard type (CRC|CSUM)
+ * 		@block_size: block size in signature domain.
+ * 		@app_tag: if app_tag is not owned be the user
+ * 			HCA will take this value to be app_tag.
+ * 		@ref_tag: initial ref_tag of signature handover.
+ * 		@type3_inc_reftag: T10-DIF type 3 does not state
+ *			about the reference tag, it is the user
+ *			choice to increment it or not.
+ */
+struct ib_sig_domain {
+	enum ib_signature_type 	sig_type;
+	union {
+		struct {
+			enum ib_t10_dif_type	type;
+			enum ib_t10_dif_bg_type bg_type;
+			u16			block_size;
+			u16			bg;
+			u16			app_tag;
+			u32			ref_tag;
+			bool			type3_inc_reftag;
+		} dif;
+	} sig;
+};
+
+/**
+ * struct ib_sig_attrs - Parameters for signature handover operation
+ * @check_mask: bitmask for signature byte check (8 bytes)
+ * @mem: memory domain layout desciptor.
+ * @wire: wire domain layout desciptor.
+ */
+struct ib_sig_attrs {
+	u8			check_mask;
+	struct ib_sig_domain	mem;
+	struct ib_sig_domain	wire;
+};
+
+enum ib_sig_err_type {
+	IB_SIG_BAD_CRC,
+	IB_SIG_BAD_REFTAG,
+	IB_SIG_BAD_APPTAG,
+};
+
+/**
+ * struct ib_sig_err - signature error descriptor
+ * @err_type: Type of signature error.
+ * @err_block_idx: Block index of signature error.
+ */
+struct ib_sig_err {
+	enum ib_sig_err_type	err_type;
+	u16			expected_guard;
+	u16			actual_guard;
+	u32			expected_logical_block;
+	u32			actual_logical_block;
+	u64			sig_err_offset;
+	u32			qpn;
+	u32			key;
+	struct list_head	list;
+};
+
 /**
  * struct ib_mw_bind - Parameters for a type 1 memory window bind operation.
  * @wr_id:      Work request id.
@@ -1327,6 +1447,8 @@ struct ib_device {
 						 struct ib_ucontext *ucontext,
 						 struct ib_udata *udata);
 	int			   (*dealloc_xrcd)(struct ib_xrcd *xrcd);
+	int			   (*check_sig_status)(struct ib_mr *sig_mr,
+						       struct ib_sig_err *sig_err);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -2306,4 +2428,20 @@ struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device);
  */
 int ib_dealloc_xrcd(struct ib_xrcd *xrcd);
 
+/**
+ * ib_check_sig_result: lightweight check of signature result
+ * 	on specific signature enabled MR and QP.
+ * Return value:
+ * - 0 for signature status SUCCESS.
+ * - 1 for signature status FAILURE.
+ *
+ * @qp: The signature enabled QP that was used in signature
+ * 	transaction.
+ * @sig_mr: The signature enabled MR that describes the
+ * 	protected domain.
+ * @sig_err: The container of the signature error in
+ * 	case of signature error indeed occured.
+ */
+int ib_check_sig_status(struct ib_mr *sig_mr, struct ib_sig_err *sig_err);
+
 #endif /* IB_VERBS_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
