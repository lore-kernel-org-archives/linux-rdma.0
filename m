From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 1/5] IB/core: Add DC transport support
Date: Thu,  6 Nov 2014 17:52:35 +0200
Message-ID: <1415289159-4376-2-git-send-email-eli@mellanox.com>
References: <1415289159-4376-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415289159-4376-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The Dynamically Connected (DC) Transport Service provides a reliable
datagram-like model that allows a single sender to target multiple destinations
from the same QP, keeping the communication resource footprint essentially
independent of system size. DC supports RDMA read and write operations, as well
as atomic variable updates.  With this transport a DC initiator QP may be used
to target multiple remote DC Targets, in one or more remote processes.  As far
as reachability is concerned, the DC model is somewhat similar to the
Unreliable Datagram (UD) model in the sense that each WR submitted to the DC SQ
carries the information that identifies the remote destination. DC contexts are
then dynamically tied to each other across the network to create a temporary
RC-equivalent connection that is used to reliably deliver one or more messages.
This dynamic connection is created in-band and pipelined with the subsequent
data communication thus eliminating most of the cost associated with the 3-way
handshake off the Connection Manager protocol used for connecting RC QPs. When
all WRs posted to that remote network address are acknowledged, the initiator
sends a disconnect request to the responder, thereby releasing the responder
resources.
A DC initiator is yet another type of QP identified by a new transport type,
IB_QPT_DC_INI. The target is end is presented by a new object of type ib_dct.

This patch extend the verbs API with the following new APIs:
ib_create_dc - Create a DC target
ib_destroy_dct - Destroy a DC target
ib_query_dct - query DC target
ib_arm_dct - Arm a DC target to generate asynchronous event on DC key
violation. Once a event is generated, the DC target moves to a fired state and
will not generated further key violation events unless re-armed.

ib_modify_qp_ex - is an extension to ib_modify_qp which allows to pass the 64
bit DC key.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 87 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         | 87 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 172 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c2b89cc5dbca..c2b2d00c9794 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -521,6 +521,9 @@ static const struct {
 				[IB_QPT_RC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
+				[IB_QPT_DC_INI]  = (IB_QP_PKEY_INDEX		|
+						    IB_QP_PORT			|
+						    IB_QP_DC_KEY),
 				[IB_QPT_XRC_INI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
@@ -549,6 +552,9 @@ static const struct {
 				[IB_QPT_RC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
+				[IB_QPT_DC_INI]  = (IB_QP_PKEY_INDEX		|
+						    IB_QP_PORT			|
+						    IB_QP_DC_KEY),
 				[IB_QPT_XRC_INI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
@@ -574,6 +580,8 @@ static const struct {
 						IB_QP_RQ_PSN			|
 						IB_QP_MAX_DEST_RD_ATOMIC	|
 						IB_QP_MIN_RNR_TIMER),
+				[IB_QPT_DC_INI]  = (IB_QP_AV			|
+						    IB_QP_PATH_MTU),
 				[IB_QPT_XRC_INI] = (IB_QP_AV			|
 						IB_QP_PATH_MTU			|
 						IB_QP_DEST_QPN			|
@@ -600,6 +608,8 @@ static const struct {
 				 [IB_QPT_RC]  = (IB_QP_ALT_PATH			|
 						 IB_QP_ACCESS_FLAGS		|
 						 IB_QP_PKEY_INDEX),
+				 [IB_QPT_DC_INI]  = (IB_QP_PKEY_INDEX		|
+						     IB_QP_DC_KEY),
 				 [IB_QPT_XRC_INI] = (IB_QP_ALT_PATH		|
 						 IB_QP_ACCESS_FLAGS		|
 						 IB_QP_PKEY_INDEX),
@@ -640,6 +650,10 @@ static const struct {
 						IB_QP_RNR_RETRY			|
 						IB_QP_SQ_PSN			|
 						IB_QP_MAX_QP_RD_ATOMIC),
+				[IB_QPT_DC_INI]  = (IB_QP_TIMEOUT		|
+						    IB_QP_RETRY_CNT		|
+						    IB_QP_RNR_RETRY		|
+						    IB_QP_MAX_QP_RD_ATOMIC),
 				[IB_QPT_XRC_INI] = (IB_QP_TIMEOUT		|
 						IB_QP_RETRY_CNT			|
 						IB_QP_RNR_RETRY			|
@@ -662,6 +676,10 @@ static const struct {
 						 IB_QP_ACCESS_FLAGS		|
 						 IB_QP_MIN_RNR_TIMER		|
 						 IB_QP_PATH_MIG_STATE),
+				[IB_QPT_DC_INI] = (IB_QP_CUR_STATE		|
+						   IB_QP_ALT_PATH		|
+						   IB_QP_MIN_RNR_TIMER		|
+						   IB_QP_PATH_MIG_STATE),
 				 [IB_QPT_XRC_INI] = (IB_QP_CUR_STATE		|
 						 IB_QP_ALT_PATH			|
 						 IB_QP_ACCESS_FLAGS		|
@@ -695,6 +713,10 @@ static const struct {
 						IB_QP_ALT_PATH			|
 						IB_QP_PATH_MIG_STATE		|
 						IB_QP_MIN_RNR_TIMER),
+				[IB_QPT_DC_INI]  = (IB_QP_CUR_STATE		|
+						    IB_QP_ALT_PATH		|
+						    IB_QP_PATH_MIG_STATE	|
+						    IB_QP_MIN_RNR_TIMER),
 				[IB_QPT_XRC_INI] = (IB_QP_CUR_STATE		|
 						IB_QP_ACCESS_FLAGS		|
 						IB_QP_ALT_PATH			|
@@ -1438,6 +1460,71 @@ int ib_destroy_flow(struct ib_flow *flow_id)
 }
 EXPORT_SYMBOL(ib_destroy_flow);
 
+struct ib_dct *ib_create_dct(struct ib_pd *pd, struct ib_dct_init_attr *attr,
+			     struct ib_udata *uhw)
+{
+	struct ib_dct *dct;
+
+	if (!pd->device->create_dct)
+		return ERR_PTR(-ENOSYS);
+
+	dct = pd->device->create_dct(pd, attr, uhw);
+	if (!IS_ERR(dct)) {
+		dct->pd = pd;
+		dct->srq = attr->srq;
+		dct->cq = attr->cq;
+		atomic_inc(&dct->srq->usecnt);
+		atomic_inc(&dct->cq->usecnt);
+		atomic_inc(&dct->pd->usecnt);
+	}
+
+	return dct;
+}
+EXPORT_SYMBOL(ib_create_dct);
+
+int ib_destroy_dct(struct ib_dct *dct, struct ib_udata *uhw)
+{
+	struct ib_srq *srq;
+	struct ib_cq *cq;
+	struct ib_pd *pd;
+	int err;
+
+	if (!dct->device->destroy_dct)
+		return -ENOSYS;
+
+	srq = dct->srq;
+	cq = dct->cq;
+	pd = dct->pd;
+	err = dct->device->destroy_dct(dct, uhw);
+	if (!err) {
+		atomic_dec(&srq->usecnt);
+		atomic_dec(&cq->usecnt);
+		atomic_dec(&pd->usecnt);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(ib_destroy_dct);
+
+int ib_query_dct(struct ib_dct *dct, struct ib_dct_attr *attr,
+		 struct ib_udata *uhw)
+{
+	if (!dct->device->query_dct)
+		return -ENOSYS;
+
+	return dct->device->query_dct(dct, attr, uhw);
+}
+EXPORT_SYMBOL(ib_query_dct);
+
+int ib_arm_dct(struct ib_dct *dct, struct ib_udata *uhw)
+{
+	if (!dct->device->arm_dct)
+		return -ENOSYS;
+
+	return dct->device->arm_dct(dct, uhw);
+}
+EXPORT_SYMBOL(ib_arm_dct);
+
 int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
 		       struct ib_mr_status *mr_status)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2b65e31ca298..9c67cffe1ecc 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -123,7 +123,14 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
 	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
 	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
-	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30)
+	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
+	IB_DEVICE_DC_TRANSPORT		= ((u64)1<<32),
+};
+
+enum {
+	IB_DCT_STATE_ACTIVE,
+	IB_DCT_STATE_DRAINING,
+	IB_DCT_STATE_DRAINED
 };
 
 enum ib_signature_prot_cap {
@@ -155,7 +162,7 @@ struct ib_device_attr {
 	u32			hw_ver;
 	int			max_qp;
 	int			max_qp_wr;
-	int			device_cap_flags;
+	u64			device_cap_flags;
 	int			max_sge;
 	int			max_sge_rd;
 	int			max_cq;
@@ -191,6 +198,8 @@ struct ib_device_attr {
 	u32			log_atomic_arg_sizes; /* bit-mask of supported sizes */
 	u32			max_fa_bit_boundary;
 	u32			log_max_atomic_inline;
+	uint32_t		dc_rd_req;
+	uint32_t		dc_rd_res;
 };
 
 enum ib_mtu {
@@ -391,6 +400,9 @@ enum ib_event_type {
 	IB_EVENT_QP_LAST_WQE_REACHED,
 	IB_EVENT_CLIENT_REREGISTER,
 	IB_EVENT_GID_CHANGE,
+	IB_EVENT_DCT_KEY_VIOLATION,
+	IB_EVENT_DCT_ACCESS_ERR,
+	IB_EVENT_DCT_REQ_ERR,
 };
 
 struct ib_event {
@@ -399,6 +411,7 @@ struct ib_event {
 		struct ib_cq	*cq;
 		struct ib_qp	*qp;
 		struct ib_srq	*srq;
+		struct ib_dct	*dct;
 		u8		port_num;
 	} element;
 	enum ib_event_type	event;
@@ -762,6 +775,7 @@ enum ib_qp_type {
 	IB_QPT_RAW_PACKET = 8,
 	IB_QPT_XRC_INI = 9,
 	IB_QPT_XRC_TGT,
+	IB_QPT_DC_INI,
 	IB_QPT_MAX,
 	/* Reserve a range for qp types internal to the low level driver.
 	 * These qp types will not be visible at the IB core layer, so the
@@ -878,6 +892,7 @@ enum ib_qp_attr_mask {
 	IB_QP_ALT_SMAC			= (1<<22),
 	IB_QP_VID			= (1<<23),
 	IB_QP_ALT_VID			= (1<<24),
+	IB_QP_DC_KEY			= (1<<25),
 };
 
 enum ib_qp_state {
@@ -931,6 +946,7 @@ struct ib_qp_attr {
 	u8			alt_smac[ETH_ALEN];
 	u16			vlan_id;
 	u16			alt_vlan_id;
+	u64			dct_key;
 };
 
 enum ib_wr_opcode {
@@ -1393,6 +1409,58 @@ struct ib_cache {
 	u8                     *lmc_cache;
 };
 
+struct ib_dct {
+	struct ib_device       *device;
+	struct ib_uobject      *uobject;
+	struct ib_pd	       *pd;
+	struct ib_cq	       *cq;
+	struct ib_srq	       *srq;
+	void		       *dct_context;
+	u32			dct_num;
+
+	void		      (*event_handler)(struct ib_event *, void *);
+};
+
+enum {
+	IB_DCT_CREATE_FLAGS_MASK		= 0,
+};
+
+struct ib_dct_init_attr {
+	struct ib_pd	       *pd;
+	struct ib_cq	       *cq;
+	struct ib_srq	       *srq;
+	u64			dc_key;
+	u8			port;
+	u32			access_flags;
+	u8			min_rnr_timer;
+	u8			tclass;
+	u32			flow_label;
+	enum ib_mtu		mtu;
+	u8			pkey_index;
+	u8			gid_index;
+	u8			hop_limit;
+	u32			create_flags;
+	u32			inline_size;
+	void		       *dct_context;
+
+	void		      (*event_handler)(struct ib_event *, void *);
+};
+
+struct ib_dct_attr {
+	u64			dc_key;
+	u8			port;
+	u32			access_flags;
+	u8			min_rnr_timer;
+	u8			tclass;
+	u32			flow_label;
+	enum ib_mtu		mtu;
+	u8			pkey_index;
+	u8			gid_index;
+	u8			hop_limit;
+	u32			key_violations;
+	u8			state;
+};
+
 struct ib_dma_mapping_ops {
 	int		(*mapping_error)(struct ib_device *dev,
 					 u64 dma_addr);
@@ -1612,6 +1680,15 @@ struct ib_device {
 	int			   (*destroy_flow)(struct ib_flow *flow_id);
 	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
 						      struct ib_mr_status *mr_status);
+	struct ib_dct *		   (*create_dct)(struct ib_pd *pd,
+						 struct ib_dct_init_attr *attr,
+						 struct ib_udata *uhw);
+	int			   (*destroy_dct)(struct ib_dct *dct,
+						  struct ib_udata *uhw);
+	int			   (*query_dct)(struct ib_dct *dct,
+						struct ib_dct_attr *attr,
+						struct ib_udata *uhw);
+	int			   (*arm_dct)(struct ib_dct *dct, struct ib_udata *uhw);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -2602,6 +2679,12 @@ int ib_dealloc_xrcd(struct ib_xrcd *xrcd);
 struct ib_flow *ib_create_flow(struct ib_qp *qp,
 			       struct ib_flow_attr *flow_attr, int domain);
 int ib_destroy_flow(struct ib_flow *flow_id);
+struct ib_dct *ib_create_dct(struct ib_pd *pd, struct ib_dct_init_attr *attr,
+			     struct ib_udata *uhw);
+int ib_destroy_dct(struct ib_dct *dct, struct ib_udata *uhw);
+int ib_query_dct(struct ib_dct *dct, struct ib_dct_attr *attr,
+		 struct ib_udata *uhw);
+int ib_arm_dct(struct ib_dct *dct, struct ib_udata *uhw);
 
 static inline int ib_check_mr_access(int flags)
 {
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
