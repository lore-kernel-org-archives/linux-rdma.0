From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/5] IB/core: Introduce Fast Indirect Memory Registration verbs API
Date: Mon,  8 Jun 2015 16:15:35 +0300
Message-ID: <1433769339-949-2-git-send-email-sagig@mellanox.com>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433769339-949-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to support that we provide the user with an interface
to pass a scattered list of buffers to the IB core layer called
ib_indir_reg_list and provide a new send work request opcode
called IB_WR_REG_INDIR_MR. We extend wr union with a new type of
memory registration called indir_reg where the user can place the
relevant information to perform such a memory registration.

The verbs user is expected to perform these steps:
0. Make sure that the device supports Indirect memory registration via
   ib_device_cap_flag IB_DEVICE_INDIR_REGISTRATION and make sure
   that ib_device_attr max_indir_reg_mr_list_len suffice for the
   expected scatterlist length

1. Allocate a memory region with IB_MR_INDIRECT_REG creation flag
   This is done via ib_create_mr() with:
   mr_init_attr.flags = IB_MR_INDIRECT_REG

2. Allocate an ib_indir_reg_list structure to hold the scattered buffers
   pointers. This is done via new ib_alloc_indir_reg_list() verb

3. Fill the scattered buffers in ib_indir_reg_list.sg_list

4. Post a work request with a new opcode IB_WR_REG_INDIR_MR and
   provide the filled ib_indir_reg_list

5. Perform data transfer

6. Get completion of kind IB_WC_REG_INDIR_MR (if requested)

7. Free indirect MR and ib_indir_reg_list via
   ib_dereg_mr() and ib_free_indir_reg_list()

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   28 +++++++++++++++++++++
 include/rdma/ib_verbs.h         |   52 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 927cf2e..ad2a4d3 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1493,3 +1493,31 @@ int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
 		mr->device->check_mr_status(mr, check_mask, mr_status) : -ENOSYS;
 }
 EXPORT_SYMBOL(ib_check_mr_status);
+
+struct ib_indir_reg_list *
+ib_alloc_indir_reg_list(struct ib_device *device,
+			unsigned int max_indir_list_len)
+{
+	struct ib_indir_reg_list *indir_list;
+
+	if (!device->alloc_indir_reg_list)
+		return ERR_PTR(-ENOSYS);
+
+	indir_list = device->alloc_indir_reg_list(device,
+						  max_indir_list_len);
+	if (!IS_ERR(indir_list)) {
+		indir_list->device = device;
+		indir_list->max_indir_list_len = max_indir_list_len;
+	}
+
+	return indir_list;
+}
+EXPORT_SYMBOL(ib_alloc_indir_reg_list);
+
+void
+ib_free_indir_reg_list(struct ib_indir_reg_list *indir_list)
+{
+	if (indir_list->device->free_indir_reg_list)
+		indir_list->device->free_indir_reg_list(indir_list);
+}
+EXPORT_SYMBOL(ib_free_indir_reg_list);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 3fedea5..51563f4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -133,6 +133,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
 	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
 	IB_DEVICE_ON_DEMAND_PAGING	= (1<<31),
+	IB_DEVICE_INDIR_REGISTRATION	= (1ULL << 32),
 };
 
 enum ib_signature_prot_cap {
@@ -183,7 +184,7 @@ struct ib_device_attr {
 	u32			hw_ver;
 	int			max_qp;
 	int			max_qp_wr;
-	int			device_cap_flags;
+	u64			device_cap_flags;
 	int			max_sge;
 	int			max_sge_rd;
 	int			max_cq;
@@ -212,6 +213,7 @@ struct ib_device_attr {
 	int			max_srq_wr;
 	int			max_srq_sge;
 	unsigned int		max_fast_reg_page_list_len;
+	unsigned int		max_indir_reg_mr_list_len;
 	u16			max_pkeys;
 	u8			local_ca_ack_delay;
 	int			sig_prot_cap;
@@ -543,7 +545,8 @@ __attribute_const__ int ib_rate_to_mult(enum ib_rate rate);
 __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate);
 
 enum ib_mr_create_flags {
-	IB_MR_SIGNATURE_EN = 1,
+	IB_MR_SIGNATURE_EN = 1 << 0,
+	IB_MR_INDIRECT_REG = 1 << 1
 };
 
 /**
@@ -720,6 +723,7 @@ enum ib_wc_opcode {
 	IB_WC_FAST_REG_MR,
 	IB_WC_MASKED_COMP_SWAP,
 	IB_WC_MASKED_FETCH_ADD,
+	IB_WC_REG_INDIR_MR,
 /*
  * Set value of IB_WC_RECV so consumers can test if a completion is a
  * receive by testing (opcode & IB_WC_RECV).
@@ -1014,6 +1018,7 @@ enum ib_wr_opcode {
 	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
 	IB_WR_BIND_MW,
 	IB_WR_REG_SIG_MR,
+	IB_WR_REG_INDIR_MR,
 	/* reserve values for low level drivers' internal use.
 	 * These values will not be used at all in the ib core layer.
 	 */
@@ -1053,6 +1058,12 @@ struct ib_fast_reg_page_list {
 	unsigned int		max_page_list_len;
 };
 
+struct ib_indir_reg_list {
+	struct ib_device       *device;
+	struct ib_sge          *sg_list;
+	unsigned int		max_indir_list_len;
+};
+
 /**
  * struct ib_mw_bind_info - Parameters for a memory window bind operation.
  * @mr: A memory region to bind the memory window to.
@@ -1125,6 +1136,14 @@ struct ib_send_wr {
 			int			access_flags;
 			struct ib_sge	       *prot;
 		} sig_handover;
+		struct {
+			u64				iova_start;
+			struct ib_indir_reg_list       *indir_list;
+			unsigned int			indir_list_len;
+			u64				length;
+			unsigned int			access_flags;
+			u32				mkey;
+		} indir_reg;
 	} wr;
 	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */
 };
@@ -1659,6 +1678,9 @@ struct ib_device {
 	struct ib_fast_reg_page_list * (*alloc_fast_reg_page_list)(struct ib_device *device,
 								   int page_list_len);
 	void			   (*free_fast_reg_page_list)(struct ib_fast_reg_page_list *page_list);
+	struct ib_indir_reg_list * (*alloc_indir_reg_list)(struct ib_device *device,
+							   unsigned int indir_list_len);
+	void			   (*free_indir_reg_list)(struct ib_indir_reg_list *indir_list);
 	int                        (*rereg_phys_mr)(struct ib_mr *mr,
 						    int mr_rereg_mask,
 						    struct ib_pd *pd,
@@ -2793,6 +2815,32 @@ struct ib_fast_reg_page_list *ib_alloc_fast_reg_page_list(
 void ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
 
 /**
+ * ib_alloc_indir_reg_list() - Allocates an indirect list array
+ * @device: ib device pointer
+ * @indir_list_len: size of the list array to be allocated
+ *
+ * Allocate a struct ib_indir_reg_list and a sg_list array
+ * that is at least indir_list_len in size. The actual size is
+ * returned in max_indir_list_len. The caller is responsible for
+ * initializing the contents of the sg_list array before posting
+ * a send work request with the IB_WC_INDIR_REG_MR opcode.
+ *
+ * The sg_list array entries should be set exactly the same way
+ * the ib_send_wr sg_list {lkey, addr, length}.
+ */
+struct ib_indir_reg_list *
+ib_alloc_indir_reg_list(struct ib_device *device,
+			unsigned int indir_list_len);
+
+/**
+ * ib_free_indir_reg_list() - Deallocates a previously allocated
+ *     indirect list array
+ * @indir_list: pointer to be deallocated
+ */
+void
+ib_free_indir_reg_list(struct ib_indir_reg_list *indir_list);
+
+/**
  * ib_update_fast_reg_key - updates the key portion of the fast_reg MR
  *   R_Key and L_Key.
  * @mr - struct ib_mr pointer to be updated.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
