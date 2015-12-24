From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 3/4] RDMA/ocrdma: Depend on async link events from CNA
Date: Thu, 24 Dec 2015 13:14:07 -0500
Message-ID: <1450980848-18945-4-git-send-email-devesh.sharma@avagotech.com>
References: <1450980848-18945-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450980848-18945-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sathya Perla <sathya.perla-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Recently Dough Ledford reported a deadlock happening
between ocrdma-load sequence and NetworkManager service
issuing "open" on be2net interface.

The deadlock happens when any be2net hook (e.g. open/close) is called
in parallel to insmod ocrdma.ko.

A. be2net is sending administrative open/close event to ocrdma holding
   device_list_mutex. It does this from ndo_open/ndo_stop hooks of be2net.
   So sequence of locks is rtnl_lock---> device_list lock

B.  When new ocrdma roce device gets registered, infiniband stack now
    takes rtnl_lock in ib_register_device() in GID initialization routines.
    So sequence of locks in this path is device_list lock ---> rtnl_lock.

This improper locking sequence causes deadlock.

With this patch we stop using administrative open and close events
injected by be2net driver. These events were used to dispatch PORT_ACTIVE
and PORT_ERROR events to the IB-stack. This patch implements a logic
to receive async-link-events generated from CNA whenever link-state-change
is detected. Now on, these async-events will be used to dispatch
PORT_ACTIVE and PORT_ERROR events to IB-stack.

Depending on async-events from CNA removes the need to hold device-list-mutex
and thus breaks the busy-wait scenario.

Reported-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Sathya Perla <sathya.perla-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       | 10 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 42 ++++++++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |  4 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 34 ++++++++++++++------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 49 ++++++++++++++++++++++++++---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 +-
 6 files changed, 119 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index ae80590..040bb8b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -232,6 +232,10 @@ struct phy_info {
 	u16 interface_type;
 };
 
+enum ocrdma_flags {
+	OCRDMA_FLAGS_LINK_STATUS_INIT = 0x01
+};
+
 struct ocrdma_dev {
 	struct ib_device ibdev;
 	struct ocrdma_dev_attr attr;
@@ -287,6 +291,7 @@ struct ocrdma_dev {
 	atomic_t update_sl;
 	u16 pvid;
 	u32 asic_id;
+	u32 flags;
 
 	ulong last_stats_time;
 	struct mutex stats_lock; /* provide synch for debugfs operations */
@@ -591,4 +596,9 @@ static inline u8 ocrdma_is_enabled_and_synced(u32 state)
 		(state & OCRDMA_STATE_FLAG_SYNC);
 }
 
+static inline u8 ocrdma_get_ae_link_state(u32 ae_state)
+{
+	return ((ae_state & OCRDMA_AE_LSC_LS_MASK) >> OCRDMA_AE_LSC_LS_SHIFT);
+}
+
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 4fc2bb4..283ca84 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -579,6 +579,8 @@ static int ocrdma_mbx_create_mq(struct ocrdma_dev *dev,
 
 	cmd->async_event_bitmap = BIT(OCRDMA_ASYNC_GRP5_EVE_CODE);
 	cmd->async_event_bitmap |= BIT(OCRDMA_ASYNC_RDMA_EVE_CODE);
+	/* Request link events on this  MQ. */
+	cmd->async_event_bitmap |= BIT(OCRDMA_ASYNC_LINK_EVE_CODE);
 
 	cmd->async_cqid_ringsize = cq->id;
 	cmd->async_cqid_ringsize |= (ocrdma_encoded_q_len(mq->len) <<
@@ -819,20 +821,42 @@ static void ocrdma_process_grp5_aync(struct ocrdma_dev *dev,
 	}
 }
 
+static void ocrdma_process_link_state(struct ocrdma_dev *dev,
+				      struct ocrdma_ae_mcqe *cqe)
+{
+	struct ocrdma_ae_lnkst_mcqe *evt;
+	u8 lstate;
+
+	evt = (struct ocrdma_ae_lnkst_mcqe *)cqe;
+	lstate = ocrdma_get_ae_link_state(evt->speed_state_ptn);
+
+	if (!(lstate & OCRDMA_AE_LSC_LLINK_MASK))
+		return;
+
+	if (dev->flags & OCRDMA_FLAGS_LINK_STATUS_INIT)
+		ocrdma_update_link_state(dev, (lstate & OCRDMA_LINK_ST_MASK));
+}
+
 static void ocrdma_process_acqe(struct ocrdma_dev *dev, void *ae_cqe)
 {
 	/* async CQE processing */
 	struct ocrdma_ae_mcqe *cqe = ae_cqe;
 	u32 evt_code = (cqe->valid_ae_event & OCRDMA_AE_MCQE_EVENT_CODE_MASK) >>
 			OCRDMA_AE_MCQE_EVENT_CODE_SHIFT;
-
-	if (evt_code == OCRDMA_ASYNC_RDMA_EVE_CODE)
+	switch (evt_code) {
+	case OCRDMA_ASYNC_LINK_EVE_CODE:
+		ocrdma_process_link_state(dev, cqe);
+		break;
+	case OCRDMA_ASYNC_RDMA_EVE_CODE:
 		ocrdma_dispatch_ibevent(dev, cqe);
-	else if (evt_code == OCRDMA_ASYNC_GRP5_EVE_CODE)
+		break;
+	case OCRDMA_ASYNC_GRP5_EVE_CODE:
 		ocrdma_process_grp5_aync(dev, cqe);
-	else
+		break;
+	default:
 		pr_err("%s(%d) invalid evt code=0x%x\n", __func__,
 		       dev->id, evt_code);
+	}
 }
 
 static void ocrdma_process_mcqe(struct ocrdma_dev *dev, struct ocrdma_mcqe *cqe)
@@ -1363,7 +1387,8 @@ mbx_err:
 	return status;
 }
 
-int ocrdma_mbx_get_link_speed(struct ocrdma_dev *dev, u8 *lnk_speed)
+int ocrdma_mbx_get_link_speed(struct ocrdma_dev *dev, u8 *lnk_speed,
+			      u8 *lnk_state)
 {
 	int status = -ENOMEM;
 	struct ocrdma_get_link_speed_rsp *rsp;
@@ -1384,8 +1409,11 @@ int ocrdma_mbx_get_link_speed(struct ocrdma_dev *dev, u8 *lnk_speed)
 		goto mbx_err;
 
 	rsp = (struct ocrdma_get_link_speed_rsp *)cmd;
-	*lnk_speed = (rsp->pflt_pps_ld_pnum & OCRDMA_PHY_PS_MASK)
-			>> OCRDMA_PHY_PS_SHIFT;
+	if (lnk_speed)
+		*lnk_speed = (rsp->pflt_pps_ld_pnum & OCRDMA_PHY_PS_MASK)
+			      >> OCRDMA_PHY_PS_SHIFT;
+	if (lnk_state)
+		*lnk_state = (rsp->res_lnk_st & OCRDMA_LINK_ST_MASK);
 
 mbx_err:
 	kfree(cmd);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index 7ed885c..ebc1f44 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -106,7 +106,8 @@ void ocrdma_ring_cq_db(struct ocrdma_dev *, u16 cq_id, bool armed,
 		       bool solicited, u16 cqe_popped);
 
 /* verbs specific mailbox commands */
-int ocrdma_mbx_get_link_speed(struct ocrdma_dev *dev, u8 *lnk_speed);
+int ocrdma_mbx_get_link_speed(struct ocrdma_dev *dev, u8 *lnk_speed,
+			      u8 *lnk_st);
 int ocrdma_query_config(struct ocrdma_dev *,
 			struct ocrdma_mbx_query_config *config);
 
@@ -153,5 +154,6 @@ char *port_speed_string(struct ocrdma_dev *dev);
 void ocrdma_init_service_level(struct ocrdma_dev *);
 void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev);
 void ocrdma_free_pd_range(struct ocrdma_dev *dev);
+void ocrdma_update_link_state(struct ocrdma_dev *dev, u8 lstate);
 
 #endif				/* __OCRDMA_HW_H__ */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index ebe40b4..3afb40b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -290,6 +290,7 @@ static void ocrdma_remove_sysfiles(struct ocrdma_dev *dev)
 static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 {
 	int status = 0, i;
+	u8 lstate = 0;
 	struct ocrdma_dev *dev;
 
 	dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(struct ocrdma_dev));
@@ -319,6 +320,11 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 	if (status)
 		goto alloc_err;
 
+	/* Query Link state and update */
+	status = ocrdma_mbx_get_link_speed(dev, NULL, &lstate);
+	if (!status)
+		ocrdma_update_link_state(dev, lstate);
+
 	for (i = 0; i < ARRAY_SIZE(ocrdma_attributes); i++)
 		if (device_create_file(&dev->ibdev.dev, ocrdma_attributes[i]))
 			goto sysfs_err;
@@ -373,7 +379,7 @@ static void ocrdma_remove(struct ocrdma_dev *dev)
 	ocrdma_remove_free(dev);
 }
 
-static int ocrdma_open(struct ocrdma_dev *dev)
+static int ocrdma_dispatch_port_active(struct ocrdma_dev *dev)
 {
 	struct ib_event port_event;
 
@@ -384,7 +390,7 @@ static int ocrdma_open(struct ocrdma_dev *dev)
 	return 0;
 }
 
-static int ocrdma_close(struct ocrdma_dev *dev)
+static int ocrdma_dispatch_port_error(struct ocrdma_dev *dev)
 {
 	struct ib_event err_event;
 
@@ -397,7 +403,7 @@ static int ocrdma_close(struct ocrdma_dev *dev)
 
 static void ocrdma_shutdown(struct ocrdma_dev *dev)
 {
-	ocrdma_close(dev);
+	ocrdma_dispatch_port_error(dev);
 	ocrdma_remove(dev);
 }
 
@@ -408,18 +414,28 @@ static void ocrdma_shutdown(struct ocrdma_dev *dev)
 static void ocrdma_event_handler(struct ocrdma_dev *dev, u32 event)
 {
 	switch (event) {
-	case BE_DEV_UP:
-		ocrdma_open(dev);
-		break;
-	case BE_DEV_DOWN:
-		ocrdma_close(dev);
-		break;
 	case BE_DEV_SHUTDOWN:
 		ocrdma_shutdown(dev);
 		break;
+	default:
+		break;
 	}
 }
 
+void ocrdma_update_link_state(struct ocrdma_dev *dev, u8 lstate)
+{
+	if (!(dev->flags & OCRDMA_FLAGS_LINK_STATUS_INIT)) {
+		dev->flags |= OCRDMA_FLAGS_LINK_STATUS_INIT;
+		if (!lstate)
+			return;
+	}
+
+	if (!lstate)
+		ocrdma_dispatch_port_error(dev);
+	else
+		ocrdma_dispatch_port_active(dev);
+}
+
 static struct ocrdma_driver ocrdma_drv = {
 	.name			= "ocrdma_driver",
 	.add			= ocrdma_add,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 6a38268..99dd6fd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -465,8 +465,11 @@ struct ocrdma_ae_qp_mcqe {
 	u32 valid_ae_event;
 };
 
-#define OCRDMA_ASYNC_RDMA_EVE_CODE 0x14
-#define OCRDMA_ASYNC_GRP5_EVE_CODE 0x5
+enum ocrdma_async_event_code {
+	OCRDMA_ASYNC_LINK_EVE_CODE	= 0x01,
+	OCRDMA_ASYNC_GRP5_EVE_CODE	= 0x05,
+	OCRDMA_ASYNC_RDMA_EVE_CODE	= 0x14
+};
 
 enum ocrdma_async_grp5_events {
 	OCRDMA_ASYNC_EVENT_QOS_VALUE	= 0x01,
@@ -489,6 +492,44 @@ enum OCRDMA_ASYNC_EVENT_TYPE {
 	OCRDMA_MAX_ASYNC_ERRORS
 };
 
+struct ocrdma_ae_lnkst_mcqe {
+	u32 speed_state_ptn;
+	u32 qos_reason_falut;
+	u32 evt_tag;
+	u32 valid_ae_event;
+};
+
+enum {
+	OCRDMA_AE_LSC_PORT_NUM_MASK	= 0x3F,
+	OCRDMA_AE_LSC_PT_SHIFT		= 0x06,
+	OCRDMA_AE_LSC_PT_MASK		= (0x03 <<
+			OCRDMA_AE_LSC_PT_SHIFT),
+	OCRDMA_AE_LSC_LS_SHIFT		= 0x08,
+	OCRDMA_AE_LSC_LS_MASK		= (0xFF <<
+			OCRDMA_AE_LSC_LS_SHIFT),
+	OCRDMA_AE_LSC_LD_SHIFT		= 0x10,
+	OCRDMA_AE_LSC_LD_MASK		= (0xFF <<
+			OCRDMA_AE_LSC_LD_SHIFT),
+	OCRDMA_AE_LSC_PPS_SHIFT		= 0x18,
+	OCRDMA_AE_LSC_PPS_MASK		= (0xFF <<
+			OCRDMA_AE_LSC_PPS_SHIFT),
+	OCRDMA_AE_LSC_PPF_MASK		= 0xFF,
+	OCRDMA_AE_LSC_ER_SHIFT		= 0x08,
+	OCRDMA_AE_LSC_ER_MASK		= (0xFF <<
+			OCRDMA_AE_LSC_ER_SHIFT),
+	OCRDMA_AE_LSC_QOS_SHIFT		= 0x10,
+	OCRDMA_AE_LSC_QOS_MASK		= (0xFFFF <<
+			OCRDMA_AE_LSC_QOS_SHIFT)
+};
+
+enum {
+	OCRDMA_AE_LSC_PLINK_DOWN	= 0x00,
+	OCRDMA_AE_LSC_PLINK_UP		= 0x01,
+	OCRDMA_AE_LSC_LLINK_DOWN	= 0x02,
+	OCRDMA_AE_LSC_LLINK_MASK	= 0x02,
+	OCRDMA_AE_LSC_LLINK_UP		= 0x03
+};
+
 /* mailbox command request and responses */
 enum {
 	OCRDMA_MBX_QUERY_CFG_CQ_OVERFLOW_SHIFT		= 2,
@@ -676,7 +717,7 @@ enum {
 	OCRDMA_PHY_PFLT_SHIFT	= 0x18,
 	OCRDMA_QOS_LNKSP_MASK	= 0xFFFF0000,
 	OCRDMA_QOS_LNKSP_SHIFT	= 0x10,
-	OCRDMA_LLST_MASK	= 0xFF,
+	OCRDMA_LINK_ST_MASK	= 0x01,
 	OCRDMA_PLFC_MASK	= 0x00000400,
 	OCRDMA_PLFC_SHIFT	= 0x8,
 	OCRDMA_PLRFC_MASK	= 0x00000200,
@@ -691,7 +732,7 @@ struct ocrdma_get_link_speed_rsp {
 
 	u32 pflt_pps_ld_pnum;
 	u32 qos_lsp;
-	u32 res_lls;
+	u32 res_lnk_st;
 };
 
 enum {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 583001b..76e96f9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -171,7 +171,7 @@ static inline void get_link_speed_and_width(struct ocrdma_dev *dev,
 	int status;
 	u8 speed;
 
-	status = ocrdma_mbx_get_link_speed(dev, &speed);
+	status = ocrdma_mbx_get_link_speed(dev, &speed, NULL);
 	if (status)
 		speed = OCRDMA_PHYS_LINK_SPEED_ZERO;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
