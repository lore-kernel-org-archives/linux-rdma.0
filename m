From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/14] RDMA/ocrdma: Fill PVID in UMC case.
Date: Mon, 26 Aug 2013 15:27:50 +0530
Message-ID: <c7d8703e-0345-480b-b6dc-dd8ac40e2e15@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

In UMC case, Driver needs to fill PVID in the address vector
template for UD traffic.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h     |  1 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c  |  2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c  | 32 +++++++++++++++++++++++++++++--
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h | 18 ++++++++++++++++-
 4 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index fde8fb0..adc11d1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -170,6 +170,7 @@ struct ocrdma_dev {
 	struct rcu_head rcu;
 	int id;
 	u64 stag_arr[OCRDMA_MAX_STAG];
+	u16 pvid;
 };
 
 struct ocrdma_cq {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index df9e737..ee499d9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -50,6 +50,8 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	ah->sgid_index = attr->grh.sgid_index;
 
 	vlan_tag = rdma_get_vlan_id(&attr->grh.dgid);
+	if (!vlan_tag || (vlan_tag > 0xFFF))
+		vlan_tag = dev->pvid;
 	if (vlan_tag && (vlan_tag < 0x1000)) {
 		eth.eth_type = cpu_to_be16(0x8100);
 		eth.roce_eth_type = cpu_to_be16(OCRDMA_ROCE_ETH_TYPE);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index ea3d723..acf5441 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -544,7 +544,10 @@ static int ocrdma_mbx_create_mq(struct ocrdma_dev *dev,
 	cmd->cqid_pages = num_pages;
 	cmd->cqid_pages |= (cq->id << OCRDMA_CREATE_MQ_CQ_ID_SHIFT);
 	cmd->async_cqid_valid = OCRDMA_CREATE_MQ_ASYNC_CQ_VALID;
-	cmd->async_event_bitmap = Bit(20);
+
+	cmd->async_event_bitmap = Bit(OCRDMA_ASYNC_GRP5_EVE_CODE);
+	cmd->async_event_bitmap |= Bit(OCRDMA_ASYNC_RDMA_EVE_CODE);
+
 	cmd->async_cqid_ringsize = cq->id;
 	cmd->async_cqid_ringsize |= (ocrdma_encoded_q_len(mq->len) <<
 				OCRDMA_CREATE_MQ_RING_SIZE_SHIFT);
@@ -727,6 +730,29 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 
 }
 
+static void ocrdma_process_grp5_aync(struct ocrdma_dev *dev,
+					struct ocrdma_ae_mcqe *cqe)
+{
+	struct ocrdma_ae_pvid_mcqe *evt;
+	int type = (cqe->valid_ae_event & OCRDMA_AE_MCQE_EVENT_TYPE_MASK) >>
+			OCRDMA_AE_MCQE_EVENT_TYPE_SHIFT;
+
+	switch (type) {
+	case OCRDMA_ASYNC_EVENT_PVID_STATE:
+		evt = (struct ocrdma_ae_pvid_mcqe *)cqe;
+		if ((evt->tag_enabled & OCRDMA_AE_PVID_MCQE_ENABLED_MASK) >>
+			OCRDMA_AE_PVID_MCQE_ENABLED_SHIFT)
+			dev->pvid = ((evt->tag_enabled &
+					OCRDMA_AE_PVID_MCQE_TAG_MASK) >>
+					OCRDMA_AE_PVID_MCQE_TAG_SHIFT);
+		break;
+	default:
+		/* Not interested evts. */
+		break;
+	}
+}
+
+
 static void ocrdma_process_acqe(struct ocrdma_dev *dev, void *ae_cqe)
 {
 	/* async CQE processing */
@@ -734,8 +760,10 @@ static void ocrdma_process_acqe(struct ocrdma_dev *dev, void *ae_cqe)
 	u32 evt_code = (cqe->valid_ae_event & OCRDMA_AE_MCQE_EVENT_CODE_MASK) >>
 			OCRDMA_AE_MCQE_EVENT_CODE_SHIFT;
 
-	if (evt_code == OCRDMA_ASYNC_EVE_CODE)
+	if (evt_code == OCRDMA_ASYNC_RDMA_EVE_CODE)
 		ocrdma_dispatch_ibevent(dev, cqe);
+	else if (evt_code == OCRDMA_ASYNC_GRP5_EVE_CODE)
+		ocrdma_process_grp5_aync(dev, cqe);
 	else
 		pr_err("%s(%d) invalid evt code=0x%x\n", __func__,
 		       dev->id, evt_code);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 9e975d8..9f9570e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -339,6 +339,20 @@ struct ocrdma_ae_mcqe {
 };
 
 enum {
+	OCRDMA_AE_PVID_MCQE_ENABLED_SHIFT = 0,
+	OCRDMA_AE_PVID_MCQE_ENABLED_MASK  = 0xFF,
+	OCRDMA_AE_PVID_MCQE_TAG_SHIFT = 16,
+	OCRDMA_AE_PVID_MCQE_TAG_MASK = 0xFFFF << OCRDMA_AE_PVID_MCQE_TAG_SHIFT
+};
+
+struct ocrdma_ae_pvid_mcqe {
+	u32 tag_enabled;
+	u32 event_tag;
+	u32 rsvd1;
+	u32 rsvd2;
+};
+
+enum {
 	OCRDMA_AE_MPA_MCQE_REQ_ID_SHIFT		= 16,
 	OCRDMA_AE_MPA_MCQE_REQ_ID_MASK		= 0xFFFF <<
 					OCRDMA_AE_MPA_MCQE_REQ_ID_SHIFT,
@@ -388,7 +402,9 @@ struct ocrdma_ae_qp_mcqe {
 	u32 valid_ae_event;
 };
 
-#define OCRDMA_ASYNC_EVE_CODE 0x14
+#define OCRDMA_ASYNC_RDMA_EVE_CODE 0x14
+#define OCRDMA_ASYNC_GRP5_EVE_CODE 0x5
+#define OCRDMA_ASYNC_EVENT_PVID_STATE 0x3
 
 enum OCRDMA_ASYNC_EVENT_TYPE {
 	OCRDMA_CQ_ERROR			= 0x00,
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
