From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 02/10] IB/core: Introduce Signature Verbs API
Date: Thu,  7 Nov 2013 17:54:00 +0200
Message-ID: <1383839648-19000-3-git-send-email-sagig@mellanox.com>
References: <1383839648-19000-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383839648-19000-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This commit Introduces the Verbs Interface for signature related
operations. A signature handover operation shall configure the
layouts of data and protection attributes both in memory and wire
domains.

Signature operations are:
- INSERT
  Generate and insert protection information when handing over
  data from input space to output space.
- vaildate and STRIP:
  Validate protection information and remove it when handing over
  data from input space to output space.
- validate and PASS:
  Validate protection information and pass it when handing over
  data from input space to output space.

Once the signature handover opration is done, the HCA will
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
    Signature handover work request. This WR will define the signature
    handover properties of the memory/wire domains as well as the domains
    layout. The purpose of this work request is to bind all the needed
    information for the signature operation:
    - data to be transferred:  wr->sg_list (ib_sge).
      * The raw data, pre-registered to a single MR (normally, before
        signature, this MR would have been used directly for the data
        transfer)
    - data protection guards: sig_handover.prot (ib_sge).
      * The data protection buffer, pre-registered to a single MR, which
        contains the data integrity guards of the raw data blocks.
        Note that it may not always exist, only in cases where the user is
        interested in storing protection guards in memory.
    - signature operation attributes: sig_handover.sig_attrs.
      * Tells the HCA how to validate/generate the protection information.

    Once the work request is executed, the memory region which
    will describe the signature transaction will be the sig_mr. The
    application can now go ahead and send the sig_mr.rkey or use the
    sig_mr.lkey for data transfer.

4. New Verb ib_check_sig_status
    check_sig_status Verb shall check if any signature errors
    are pending for a specific signature-enabled ib_mr.
    This Verb is a lightwight check and is allowed to be taken
    from interrupt context. Application must call this verb after
    it is known that the actual data transfer has finished.

issue: 333508
Change-Id: I0cce750a6b77cd1eae102c5982c8c31e46237af8
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    8 +++
 include/rdma/ib_verbs.h         |  132 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 139 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index ef47667..d3d2ce5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1323,3 +1323,11 @@ int ib_destroy_flow(struct ib_flow *flow_id)
 	return err;
 }
 EXPORT_SYMBOL(ib_destroy_flow);
+
+int ib_check_sig_status(struct ib_mr *sig_mr,
+			struct ib_sig_err *sig_err)
+{
+	return sig_mr->device->check_sig_status ?
+		sig_mr->device->check_sig_status(sig_mr, sig_err) : -ENOSYS;
+}
+EXPORT_SYMBOL(ib_check_sig_status);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index af1bd1a..e71dae6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -117,7 +117,19 @@ enum ib_device_cap_flags {
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
 	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
-	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29)
+	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
+	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30)
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
@@ -167,6 +179,8 @@ struct ib_device_attr {
 	unsigned int		max_fast_reg_page_list_len;
 	u16			max_pkeys;
 	u8			local_ca_ack_delay;
+	int			sig_prot_cap;
+	int			sig_guard_cap;
 };
 
 enum ib_mtu {
@@ -471,6 +485,98 @@ struct ib_mr_init_attr {
 	u32	    flags;
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
+ * IB_T10DIF_CRC: Corresponds to T10-PI mandated CRC checksum rules.
+ * IB_T10DIF_CSUM: Corresponds to IP checksum rules.
+ */
+enum ib_t10_dif_bg_type {
+	IB_T10DIF_CRC,
+	IB_T10DIF_CSUM
+};
+
+/**
+ * struct ib_t10_dif_domain - Parameters specific for T10-DIF
+ *     domain.
+ * @type: T10-DIF type (0|1|2|3)
+ * @bg_type: T10-DIF block guard type (CRC|CSUM)
+ * @pi_interval: protection information interval.
+ * @app_tag: application tag of guard block
+ * @ref_tag: initial guard block reference tag.
+ * @type3_inc_reftag: T10-DIF type 3 does not state
+ *     about the reference tag, it is the user
+ *     choice to increment it or not.
+ */
+struct ib_t10_dif_domain {
+	enum ib_t10_dif_type	type;
+	enum ib_t10_dif_bg_type bg_type;
+	u16			pi_interval;
+	u16			bg;
+	u16			app_tag;
+	u32			ref_tag;
+	bool			type3_inc_reftag;
+};
+
+/**
+ * struct ib_sig_domain - Parameters for signature domain
+ * @sig_type: specific signauture type
+ * @sig: union of all signature domain attributes that may
+ *     be used to set domain layout.
+ */
+struct ib_sig_domain {
+	enum ib_signature_type sig_type;
+	union {
+		struct ib_t10_dif_domain dif;
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
+ */
+struct ib_sig_err {
+	enum ib_sig_err_type	err_type;
+	u16			expected_guard;
+	u16			actual_guard;
+	u32			expected_logical_block;
+	u32			actual_logical_block;
+	u64			sig_err_offset;
+	u32			key;
+};
+
 /**
  * mult_to_ib_rate - Convert a multiple of 2.5 Gbit/sec to an IB rate
  * enum.
@@ -647,6 +753,7 @@ enum ib_qp_type {
 enum ib_qp_create_flags {
 	IB_QP_CREATE_IPOIB_UD_LSO		= 1 << 0,
 	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
+	IB_QP_CREATE_SIGNATURE_EN		= 1 << 2,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
@@ -803,6 +910,7 @@ enum ib_wr_opcode {
 	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
 	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
 	IB_WR_BIND_MW,
+	IB_WR_REG_SIG_MR,
 	/* reserve values for low level drivers' internal use.
 	 * These values will not be used at all in the ib core layer.
 	 */
@@ -908,6 +1016,12 @@ struct ib_send_wr {
 			u32                      rkey;
 			struct ib_mw_bind_info   bind_info;
 		} bind_mw;
+		struct {
+			struct ib_sig_attrs    *sig_attrs;
+			struct ib_mr	       *sig_mr;
+			int			access_flags;
+			struct ib_sge	       *prot;
+		} sig_handover;
 	} wr;
 	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */
 };
@@ -1439,6 +1553,8 @@ struct ib_device {
 						  *flow_attr,
 						  int domain);
 	int			   (*destroy_flow)(struct ib_flow *flow_id);
+	int			   (*check_sig_status)(struct ib_mr *sig_mr,
+						       struct ib_sig_err *sig_err);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -2422,4 +2538,18 @@ struct ib_flow *ib_create_flow(struct ib_qp *qp,
 			       struct ib_flow_attr *flow_attr, int domain);
 int ib_destroy_flow(struct ib_flow *flow_id);
 
+/**
+ * ib_check_sig_status: lightweight check of signature result
+ *     on specific signature enabled MR.
+ * Return value:
+ * - 0 for signature status SUCCESS.
+ * - 1 for signature status FAILURE.
+ *
+ * @sig_mr: The signature enabled MR that describes the
+ *     protected domain.
+ * @sig_err: The container of the signature error in
+ *     case of signature error indeed occured.
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
