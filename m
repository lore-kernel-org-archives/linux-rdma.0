From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 44/54] staging/rdma/hfi1: Remove modify_port and
 port_immutable functions
Date: Wed, 03 Feb 2016 14:36:49 -0800
Message-ID: <20160203223645.5923.54469.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
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
 drivers/staging/rdma/hfi1/hfi.h   |    5 +++
 drivers/staging/rdma/hfi1/mad.c   |    5 ++-
 drivers/staging/rdma/hfi1/verbs.c |   71 +++++++++----------------------------
 drivers/staging/rdma/hfi1/verbs.h |    2 +
 4 files changed, 28 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 18508c9..363e6ef 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1536,6 +1536,11 @@ static inline struct hfi1_pportdata *ppd_from_ibp(struct hfi1_ibport *ibp)
 	return container_of(ibp, struct hfi1_pportdata, ibport_data);
 }
 
+static inline struct hfi1_ibdev *dev_from_rdi(struct rvt_dev_info *rdi)
+{
+	return container_of(rdi, struct hfi1_ibdev, rdi);
+}
+
 static inline struct hfi1_ibport *to_iport(struct ib_device *ibdev, u8 port)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 6976f93..3df1c8e 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -234,9 +234,12 @@ static void bad_mkey(struct hfi1_ibport *ibp, struct ib_mad_hdr *mad,
 /*
  * Send a Port Capability Mask Changed trap (ch. 14.3.11).
  */
-void hfi1_cap_mask_chg(struct hfi1_ibport *ibp)
+void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num)
 {
 	struct opa_mad_notice_attr data;
+	struct hfi1_ibdev *verbs_dev = dev_from_rdi(rdi);
+	struct hfi1_devdata *dd = dd_from_dev(verbs_dev);
+	struct hfi1_ibport *ibp = &dd->pport[port_num - 1].ibport_data;
 	u32 lid = ppd_from_ibp(ibp)->lid;
 
 	memset(&data, 0, sizeof(data));
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index a85fd81..0ee6b1d 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1220,33 +1220,24 @@ static inline u16 opa_width_to_ib(u16 in)
 	}
 }
 
-static int query_port(struct ib_device *ibdev, u8 port,
+static int query_port(struct rvt_dev_info *rdi, u8 port_num,
 		      struct ib_port_attr *props)
 {
-	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	struct hfi1_ibport *ibp = to_iport(ibdev, port);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct hfi1_ibdev *verbs_dev = dev_from_rdi(rdi);
+	struct hfi1_devdata *dd = dd_from_dev(verbs_dev);
+	struct hfi1_pportdata *ppd = &dd->pport[port_num - 1];
 	u16 lid = ppd->lid;
 
-	memset(props, 0, sizeof(*props));
 	props->lid = lid ? lid : 0;
 	props->lmc = ppd->lmc;
-	props->sm_lid = ibp->rvp.sm_lid;
-	props->sm_sl = ibp->rvp.sm_sl;
 	/* OPA logical states match IB logical states */
 	props->state = driver_lstate(ppd);
 	props->phys_state = hfi1_ibphys_portstate(ppd);
-	props->port_cap_flags = ibp->rvp.port_cap_flags;
 	props->gid_tbl_len = HFI1_GUIDS_PER_PORT;
-	props->max_msg_sz = 0x80000000;
-	props->pkey_tbl_len = hfi1_get_npkeys(dd);
-	props->bad_pkey_cntr = ibp->rvp.pkey_violations;
-	props->qkey_viol_cntr = ibp->rvp.qkey_violations;
 	props->active_width = (u8)opa_width_to_ib(ppd->link_width_active);
 	/* see rate_show() in ib core/sysfs.c */
 	props->active_speed = (u8)opa_speed_to_ib(ppd->link_speed_active);
 	props->max_vl_num = ppd->vls_supported;
-	props->init_type_reply = 0;
 
 	/* Once we are a "first class" citizen and have added the OPA MTUs to
 	 * the core we can advertise the larger MTU enum to the ULPs, for now
@@ -1260,27 +1251,6 @@ static int query_port(struct ib_device *ibdev, u8 port,
 				      4096 : hfi1_max_mtu), IB_MTU_4096);
 	props->active_mtu = !valid_ib_mtu(ppd->ibmtu) ? props->max_mtu :
 		mtu_to_enum(ppd->ibmtu, IB_MTU_2048);
-	props->subnet_timeout = ibp->rvp.subnet_timeout;
-
-	return 0;
-}
-
-static int port_immutable(struct ib_device *ibdev, u8 port_num,
-			  struct ib_port_immutable *immutable)
-{
-	struct ib_port_attr attr;
-	int err;
-
-	err = query_port(ibdev, port_num, &attr);
-	if (err)
-		return err;
-
-	memset(immutable, 0, sizeof(*immutable));
-
-	immutable->pkey_tbl_len = attr.pkey_tbl_len;
-	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_INTEL_OPA;
-	immutable->max_mad_size = OPA_MGMT_MAD_SIZE;
 
 	return 0;
 }
@@ -1324,24 +1294,16 @@ bail:
 	return ret;
 }
 
-static int modify_port(struct ib_device *ibdev, u8 port,
-		       int port_modify_mask, struct ib_port_modify *props)
+static int shut_down_port(struct rvt_dev_info *rdi, u8 port_num)
 {
-	struct hfi1_ibport *ibp = to_iport(ibdev, port);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	int ret = 0;
+	struct hfi1_ibdev *verbs_dev = dev_from_rdi(rdi);
+	struct hfi1_devdata *dd = dd_from_dev(verbs_dev);
+	struct hfi1_pportdata *ppd = &dd->pport[port_num - 1];
+	int ret;
 
-	ibp->rvp.port_cap_flags |= props->set_port_cap_mask;
-	ibp->rvp.port_cap_flags &= ~props->clr_port_cap_mask;
-	if (props->set_port_cap_mask || props->clr_port_cap_mask)
-		hfi1_cap_mask_chg(ibp);
-	if (port_modify_mask & IB_PORT_SHUTDOWN) {
-		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_UNKNOWN, 0,
-		  OPA_LINKDOWN_REASON_UNKNOWN);
-		ret = set_link_state(ppd, HLS_DN_DOWNDEF);
-	}
-	if (port_modify_mask & IB_PORT_RESET_QKEY_CNTR)
-		ibp->rvp.qkey_violations = 0;
+	set_link_down_reason(ppd, OPA_LINKDOWN_REASON_UNKNOWN, 0,
+			     OPA_LINKDOWN_REASON_UNKNOWN);
+	ret = set_link_state(ppd, HLS_DN_DOWNDEF);
 	return ret;
 }
 
@@ -1528,12 +1490,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->phys_port_cnt = dd->num_pports;
 	ibdev->dma_device = &dd->pcidev->dev;
 	ibdev->modify_device = modify_device;
-	ibdev->query_port = query_port;
-	ibdev->modify_port = modify_port;
 
 	/* keep process mad in the driver */
 	ibdev->process_mad = hfi1_process_mad;
-	ibdev->get_port_immutable = port_immutable;
 
 	strncpy(ibdev->node_desc, init_utsname()->nodename,
 		sizeof(ibdev->node_desc));
@@ -1547,6 +1506,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.check_ah = hfi1_check_ah;
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = hfi1_notify_new_ah;
 	dd->verbs_dev.rdi.driver_f.get_guid_be = hfi1_get_guid_be;
+	dd->verbs_dev.rdi.driver_f.query_port_state = query_port;
+	dd->verbs_dev.rdi.driver_f.shut_down_port = shut_down_port;
+	dd->verbs_dev.rdi.driver_f.cap_mask_chg = hfi1_cap_mask_chg;
 	/*
 	 * Fill in rvt info device attributes.
 	 */
@@ -1564,6 +1526,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.dparms.psn_mask = PSN_MASK;
 	dd->verbs_dev.rdi.dparms.psn_shift = PSN_SHIFT;
 	dd->verbs_dev.rdi.dparms.psn_modify_mask = PSN_MODIFY_MASK;
+	dd->verbs_dev.rdi.dparms.core_cap_flags = RDMA_CORE_PORT_INTEL_OPA;
+	dd->verbs_dev.rdi.dparms.max_mad_size = OPA_MGMT_MAD_SIZE;
+
 	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qp_priv_alloc;
 	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
 	dd->verbs_dev.rdi.driver_f.free_all_qps = free_all_qps;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index afb2d7f..a157e64 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -327,7 +327,7 @@ static inline int hfi1_send_ok(struct rvt_qp *qp)
  */
 void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 		    u32 qp1, u32 qp2, u16 lid1, u16 lid2);
-void hfi1_cap_mask_chg(struct hfi1_ibport *ibp);
+void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num);
 void hfi1_sys_guid_chg(struct hfi1_ibport *ibp);
 void hfi1_node_desc_chg(struct hfi1_ibport *ibp);
 int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
