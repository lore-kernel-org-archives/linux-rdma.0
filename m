From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/9] IB/qib: Remove qib_query_device function
Date: Wed, 06 Jan 2016 10:23:36 -0800
Message-ID: <20160106182336.5401.86125.stgit@scvm10.sc.intel.com>
References: <20160106181837.5401.67435.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106181837.5401.67435.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Removed qib_query_device function to use rdmavt rvt_query_device function
The device attributes still need to be filled in by the driver.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |  102 ++++++++++++++++-----------------
 1 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index f785680..b20bc6f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1571,55 +1571,6 @@ full:
 	}
 }
 
-static int qib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
-			    struct ib_udata *uhw)
-{
-	struct qib_devdata *dd = dd_from_ibdev(ibdev);
-	struct qib_ibdev *dev = to_idev(ibdev);
-
-	if (uhw->inlen || uhw->outlen)
-		return -EINVAL;
-	memset(props, 0, sizeof(*props));
-
-	props->device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
-		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
-		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
-		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
-	props->page_size_cap = PAGE_SIZE;
-	props->vendor_id =
-		QIB_SRC_OUI_1 << 16 | QIB_SRC_OUI_2 << 8 | QIB_SRC_OUI_3;
-	props->vendor_part_id = dd->deviceid;
-	props->hw_ver = dd->minrev;
-	props->sys_image_guid = ib_qib_sys_image_guid;
-	props->max_mr_size = ~0ULL;
-	props->max_qp = ib_qib_max_qps;
-	props->max_qp_wr = ib_qib_max_qp_wrs;
-	props->max_sge = ib_qib_max_sges;
-	props->max_sge_rd = ib_qib_max_sges;
-	props->max_cq = ib_qib_max_cqs;
-	props->max_ah = ib_qib_max_ahs;
-	props->max_cqe = ib_qib_max_cqes;
-	props->max_mr = dev->rdi.lkey_table.max;
-	props->max_fmr = dev->rdi.lkey_table.max;
-	props->max_map_per_fmr = 32767;
-	props->max_pd = dev->rdi.dparms.props.max_pd;
-	props->max_qp_rd_atom = QIB_MAX_RDMA_ATOMIC;
-	props->max_qp_init_rd_atom = 255;
-	/* props->max_res_rd_atom */
-	props->max_srq = ib_qib_max_srqs;
-	props->max_srq_wr = ib_qib_max_srq_wrs;
-	props->max_srq_sge = ib_qib_max_srq_sges;
-	/* props->local_ca_ack_delay */
-	props->atomic_cap = IB_ATOMIC_GLOB;
-	props->max_pkeys = qib_get_npkeys(dd);
-	props->max_mcast_grp = ib_qib_max_mcast_grps;
-	props->max_mcast_qp_attach = ib_qib_max_mcast_qp_attached;
-	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
-		props->max_mcast_grp;
-
-	return 0;
-}
-
 static int qib_query_port(struct ib_device *ibdev, u8 port,
 			  struct ib_port_attr *props)
 {
@@ -1889,6 +1840,53 @@ static int qib_port_immutable(struct ib_device *ibdev, u8 port_num,
 }
 
 /**
+ * qib_fill_device_attr - Fill in rvt dev info device attributes.
+ * @dd: the device data structure
+ */
+static void qib_fill_device_attr(struct qib_devdata *dd)
+{
+	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
+
+	memset(&rdi->dparms.props, 0, sizeof(rdi->dparms.props));
+
+	rdi->dparms.props.max_pd = ib_qib_max_pds;
+	rdi->dparms.props.max_ah = ib_qib_max_ahs;
+	rdi->dparms.props.device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
+		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
+		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
+		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
+	rdi->dparms.props.page_size_cap = PAGE_SIZE;
+	rdi->dparms.props.vendor_id =
+		QIB_SRC_OUI_1 << 16 | QIB_SRC_OUI_2 << 8 | QIB_SRC_OUI_3;
+	rdi->dparms.props.vendor_part_id = dd->deviceid;
+	rdi->dparms.props.hw_ver = dd->minrev;
+	rdi->dparms.props.sys_image_guid = ib_qib_sys_image_guid;
+	rdi->dparms.props.max_mr_size = ~0ULL;
+	rdi->dparms.props.max_qp = ib_qib_max_qps;
+	rdi->dparms.props.max_qp_wr = ib_qib_max_qp_wrs;
+	rdi->dparms.props.max_sge = ib_qib_max_sges;
+	rdi->dparms.props.max_sge_rd = ib_qib_max_sges;
+	rdi->dparms.props.max_cq = ib_qib_max_cqs;
+	rdi->dparms.props.max_cqe = ib_qib_max_cqes;
+	rdi->dparms.props.max_ah = ib_qib_max_ahs;
+	rdi->dparms.props.max_mr = rdi->lkey_table.max;
+	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
+	rdi->dparms.props.max_map_per_fmr = 32767;
+	rdi->dparms.props.max_qp_rd_atom = QIB_MAX_RDMA_ATOMIC;
+	rdi->dparms.props.max_qp_init_rd_atom = 255;
+	rdi->dparms.props.max_srq = ib_qib_max_srqs;
+	rdi->dparms.props.max_srq_wr = ib_qib_max_srq_wrs;
+	rdi->dparms.props.max_srq_sge = ib_qib_max_srq_sges;
+	rdi->dparms.props.atomic_cap = IB_ATOMIC_GLOB;
+	rdi->dparms.props.max_pkeys = qib_get_npkeys(dd);
+	rdi->dparms.props.max_mcast_grp = ib_qib_max_mcast_grps;
+	rdi->dparms.props.max_mcast_qp_attach = ib_qib_max_mcast_qp_attached;
+	rdi->dparms.props.max_total_mcast_qp_attach =
+					rdi->dparms.props.max_mcast_qp_attach *
+					rdi->dparms.props.max_mcast_grp;
+}
+
+/**
  * qib_register_ib_device - register our device with the infiniband core
  * @dd: the device data structure
  * Return the allocated qib_ibdev pointer or NULL on error.
@@ -2011,7 +2009,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->phys_port_cnt = dd->num_pports;
 	ibdev->num_comp_vectors = 1;
 	ibdev->dma_device = &dd->pcidev->dev;
-	ibdev->query_device = qib_query_device;
+	ibdev->query_device = NULL;
 	ibdev->modify_device = qib_modify_device;
 	ibdev->query_port = qib_query_port;
 	ibdev->modify_port = qib_modify_port;
@@ -2068,14 +2066,14 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = qib_get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = qib_check_ah;
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = qib_notify_new_ah;
-	dd->verbs_dev.rdi.dparms.props.max_pd = ib_qib_max_pds;
-	dd->verbs_dev.rdi.dparms.props.max_ah = ib_qib_max_ahs;
 	dd->verbs_dev.rdi.flags = (RVT_FLAG_QP_INIT_DRIVER |
 				   RVT_FLAG_CQ_INIT_DRIVER);
 	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = qib_get_npkeys(dd);
 
+	qib_fill_device_attr(dd);
+
 	ppd = dd->pport;
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
 		ctxt = ppd->hw_pidx;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
