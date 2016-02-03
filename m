From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] IB/qib: Remove modify_port and port_immutable functions
Date: Wed, 03 Feb 2016 14:20:52 -0800
Message-ID: <20160203222049.4030.80116.stgit@scvm10.sc.intel.com>
References: <20160203221808.4030.95183.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221808.4030.95183.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Delete code from query_port which has been moved into rvt_query_port
Create a call back function to shut down a port which may be called from
rvt_modify_port

Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c   |    5 ++-
 drivers/infiniband/hw/qib/qib_verbs.c |   63 ++++++++-------------------------
 drivers/infiniband/hw/qib/qib_verbs.h |    2 +
 3 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 1273537..73ca2c2 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -206,8 +206,11 @@ static void qib_bad_mkey(struct qib_ibport *ibp, struct ib_smp *smp)
 /*
  * Send a Port Capability Mask Changed trap (ch. 14.3.11).
  */
-void qib_cap_mask_chg(struct qib_ibport *ibp)
+void qib_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num)
 {
+	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = dd_from_dev(ibdev);
+	struct qib_ibport *ibp = &dd->pport[port_num - 1].ibport_data;
 	struct ib_mad_notice_attr data;
 
 	data.generic_type = IB_NOTICE_TYPE_INFO;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index a3a13a5..4158362 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1311,33 +1311,24 @@ full:
 	}
 }
 
-static int qib_query_port(struct ib_device *ibdev, u8 port,
+static int qib_query_port(struct rvt_dev_info *rdi, u8 port_num,
 			  struct ib_port_attr *props)
 {
-	struct qib_devdata *dd = dd_from_ibdev(ibdev);
-	struct qib_ibport *ibp = to_iport(ibdev, port);
-	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
+	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = dd_from_dev(ibdev);
+	struct qib_pportdata *ppd = &dd->pport[port_num - 1];
 	enum ib_mtu mtu;
 	u16 lid = ppd->lid;
 
-	memset(props, 0, sizeof(*props));
 	props->lid = lid ? lid : be16_to_cpu(IB_LID_PERMISSIVE);
 	props->lmc = ppd->lmc;
-	props->sm_lid = ibp->rvp.sm_lid;
-	props->sm_sl = ibp->rvp.sm_sl;
 	props->state = dd->f_iblink_state(ppd->lastibcstat);
 	props->phys_state = dd->f_ibphys_portstate(ppd->lastibcstat);
-	props->port_cap_flags = ibp->rvp.port_cap_flags;
 	props->gid_tbl_len = QIB_GUIDS_PER_PORT;
-	props->max_msg_sz = 0x80000000;
-	props->pkey_tbl_len = qib_get_npkeys(dd);
-	props->bad_pkey_cntr = ibp->rvp.pkey_violations;
-	props->qkey_viol_cntr = ibp->rvp.qkey_violations;
 	props->active_width = ppd->link_width_active;
 	/* See rate_show() */
 	props->active_speed = ppd->link_speed_active;
 	props->max_vl_num = qib_num_vls(ppd->vls_supported);
-	props->init_type_reply = 0;
 
 	props->max_mtu = qib_ibmtu ? qib_ibmtu : IB_MTU_4096;
 	switch (ppd->ibmtu) {
@@ -1360,7 +1351,6 @@ static int qib_query_port(struct ib_device *ibdev, u8 port,
 		mtu = IB_MTU_2048;
 	}
 	props->active_mtu = mtu;
-	props->subnet_timeout = ibp->rvp.subnet_timeout;
 
 	return 0;
 }
@@ -1404,20 +1394,14 @@ bail:
 	return ret;
 }
 
-static int qib_modify_port(struct ib_device *ibdev, u8 port,
-			   int port_modify_mask, struct ib_port_modify *props)
+static int shut_down_port(struct rvt_dev_info *rdi, u8 port_num)
 {
-	struct qib_ibport *ibp = to_iport(ibdev, port);
-	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
+	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = dd_from_dev(ibdev);
+	struct qib_pportdata *ppd = &dd->pport[port_num - 1];
+
+	qib_set_linkstate(ppd, QIB_IB_LINKDOWN);
 
-	ibp->rvp.port_cap_flags |= props->set_port_cap_mask;
-	ibp->rvp.port_cap_flags &= ~props->clr_port_cap_mask;
-	if (props->set_port_cap_mask || props->clr_port_cap_mask)
-		qib_cap_mask_chg(ibp);
-	if (port_modify_mask & IB_PORT_SHUTDOWN)
-		qib_set_linkstate(ppd, QIB_IB_LINKDOWN);
-	if (port_modify_mask & IB_PORT_RESET_QKEY_CNTR)
-		ibp->rvp.qkey_violations = 0;
 	return 0;
 }
 
@@ -1553,24 +1537,6 @@ static void init_ibport(struct qib_pportdata *ppd)
 	RCU_INIT_POINTER(ibp->rvp.qp[1], NULL);
 }
 
-static int qib_port_immutable(struct ib_device *ibdev, u8 port_num,
-			      struct ib_port_immutable *immutable)
-{
-	struct ib_port_attr attr;
-	int err;
-
-	err = qib_query_port(ibdev, port_num, &attr);
-	if (err)
-		return err;
-
-	immutable->pkey_tbl_len = attr.pkey_tbl_len;
-	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
-	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
-
-	return 0;
-}
-
 /**
  * qib_fill_device_attr - Fill in rvt dev info device attributes.
  * @dd: the device data structure
@@ -1686,10 +1652,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->phys_port_cnt = dd->num_pports;
 	ibdev->dma_device = &dd->pcidev->dev;
 	ibdev->modify_device = qib_modify_device;
-	ibdev->query_port = qib_query_port;
-	ibdev->modify_port = qib_modify_port;
 	ibdev->process_mad = qib_process_mad;
-	ibdev->get_port_immutable = qib_port_immutable;
 
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
 		 "Intel Infiniband HCA %s", init_utsname()->nodename);
@@ -1716,6 +1679,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = mtu_to_path_mtu;
 	dd->verbs_dev.rdi.driver_f.mtu_from_qp = mtu_from_qp;
 	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = get_pmtu_from_attr;
+	dd->verbs_dev.rdi.driver_f.query_port_state = qib_query_port;
+	dd->verbs_dev.rdi.driver_f.shut_down_port = shut_down_port;
+	dd->verbs_dev.rdi.driver_f.cap_mask_chg = qib_cap_mask_chg;
 
 	dd->verbs_dev.rdi.dparms.max_rdma_atomic = QIB_MAX_RDMA_ATOMIC;
 	dd->verbs_dev.rdi.driver_f.get_guid_be = qib_get_guid_be;
@@ -1732,6 +1698,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = qib_get_npkeys(dd);
 	dd->verbs_dev.rdi.dparms.node = dd->assigned_node_id;
+	dd->verbs_dev.rdi.dparms.core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	dd->verbs_dev.rdi.dparms.max_mad_size = IB_MGMT_MAD_SIZE;
+
 	snprintf(dd->verbs_dev.rdi.dparms.cq_name,
 		 sizeof(dd->verbs_dev.rdi.dparms.cq_name),
 		 "qib_cq%d", dd->unit);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index e12bb9d..cd73a97 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -317,7 +317,7 @@ static inline int qib_pkey_ok(u16 pkey1, u16 pkey2)
 
 void qib_bad_pqkey(struct qib_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 		   u32 qp1, u32 qp2, __be16 lid1, __be16 lid2);
-void qib_cap_mask_chg(struct qib_ibport *ibp);
+void qib_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num);
 void qib_sys_guid_chg(struct qib_ibport *ibp);
 void qib_node_desc_chg(struct qib_ibport *ibp);
 int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
