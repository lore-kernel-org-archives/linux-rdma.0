From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/31] staging/rdma/hfi1: Remove query_device function
Date: Tue, 19 Jan 2016 14:43:17 -0800
Message-ID: <20160119224317.32765.96489.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Removed hfi1 query_device function to use rdmavt rvt_query_device function
The rvt dev info device attributes still need to be filled in by the driver

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |  101 +++++++++++++++++--------------------
 1 files changed, 47 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 3f02d0a..70af487 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1362,55 +1362,49 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	return ret;
 }
 
-static int query_device(struct ib_device *ibdev,
-			struct ib_device_attr *props,
-			struct ib_udata *uhw)
+/**
+ * hfi1_fill_device_attr - Fill in rvt dev info device attributes.
+ * @dd: the device data structure
+ */
+static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 {
-	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	struct hfi1_ibdev *dev = to_idev(ibdev);
-
-	if (uhw->inlen || uhw->outlen)
-		return -EINVAL;
-	memset(props, 0, sizeof(*props));
-
-	props->device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
-		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
-		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
-		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
-
-	props->page_size_cap = PAGE_SIZE;
-	props->vendor_id =
-		dd->oui1 << 16 | dd->oui2 << 8 | dd->oui3;
-	props->vendor_part_id = dd->pcidev->device;
-	props->hw_ver = dd->minrev;
-	props->sys_image_guid = ib_hfi1_sys_image_guid;
-	props->max_mr_size = ~0ULL;
-	props->max_qp = hfi1_max_qps;
-	props->max_qp_wr = hfi1_max_qp_wrs;
-	props->max_sge = hfi1_max_sges;
-	props->max_sge_rd = hfi1_max_sges;
-	props->max_cq = hfi1_max_cqs;
-	props->max_ah = hfi1_max_ahs;
-	props->max_cqe = hfi1_max_cqes;
-	props->max_mr = dev->rdi.lkey_table.max;
-	props->max_fmr = dev->rdi.lkey_table.max;
-	props->max_map_per_fmr = 32767;
-	props->max_pd = dev->rdi.dparms.props.max_pd;
-	props->max_qp_rd_atom = HFI1_MAX_RDMA_ATOMIC;
-	props->max_qp_init_rd_atom = 255;
-	/* props->max_res_rd_atom */
-	props->max_srq = hfi1_max_srqs;
-	props->max_srq_wr = hfi1_max_srq_wrs;
-	props->max_srq_sge = hfi1_max_srq_sges;
-	/* props->local_ca_ack_delay */
-	props->atomic_cap = IB_ATOMIC_GLOB;
-	props->max_pkeys = hfi1_get_npkeys(dd);
-	props->max_mcast_grp = hfi1_max_mcast_grps;
-	props->max_mcast_qp_attach = hfi1_max_mcast_qp_attached;
-	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
-		props->max_mcast_grp;
-
-	return 0;
+	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
+
+	memset(&rdi->dparms.props, 0, sizeof(rdi->dparms.props));
+
+	rdi->dparms.props.device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
+			IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
+			IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
+			IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
+	rdi->dparms.props.page_size_cap = PAGE_SIZE;
+	rdi->dparms.props.vendor_id = dd->oui1 << 16 | dd->oui2 << 8 | dd->oui3;
+	rdi->dparms.props.vendor_part_id = dd->pcidev->device;
+	rdi->dparms.props.hw_ver = dd->minrev;
+	rdi->dparms.props.sys_image_guid = ib_hfi1_sys_image_guid;
+	rdi->dparms.props.max_mr_size = ~0ULL;
+	rdi->dparms.props.max_qp = hfi1_max_qps;
+	rdi->dparms.props.max_qp_wr = hfi1_max_qp_wrs;
+	rdi->dparms.props.max_sge = hfi1_max_sges;
+	rdi->dparms.props.max_sge_rd = hfi1_max_sges;
+	rdi->dparms.props.max_cq = hfi1_max_cqs;
+	rdi->dparms.props.max_ah = hfi1_max_ahs;
+	rdi->dparms.props.max_cqe = hfi1_max_cqes;
+	rdi->dparms.props.max_mr = rdi->lkey_table.max;
+	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
+	rdi->dparms.props.max_map_per_fmr = 32767;
+	rdi->dparms.props.max_pd = hfi1_max_pds;
+	rdi->dparms.props.max_qp_rd_atom = HFI1_MAX_RDMA_ATOMIC;
+	rdi->dparms.props.max_qp_init_rd_atom = 255;
+	rdi->dparms.props.max_srq = hfi1_max_srqs;
+	rdi->dparms.props.max_srq_wr = hfi1_max_srq_wrs;
+	rdi->dparms.props.max_srq_sge = hfi1_max_srq_sges;
+	rdi->dparms.props.atomic_cap = IB_ATOMIC_GLOB;
+	rdi->dparms.props.max_pkeys = hfi1_get_npkeys(dd);
+	rdi->dparms.props.max_mcast_grp = hfi1_max_mcast_grps;
+	rdi->dparms.props.max_mcast_qp_attach = hfi1_max_mcast_qp_attached;
+	rdi->dparms.props.max_total_mcast_qp_attach =
+					rdi->dparms.props.max_mcast_qp_attach *
+					rdi->dparms.props.max_mcast_grp;
 }
 
 static inline u16 opa_speed_to_ib(u16 in)
@@ -1797,7 +1791,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->phys_port_cnt = dd->num_pports;
 	ibdev->num_comp_vectors = 1;
 	ibdev->dma_device = &dd->pcidev->dev;
-	ibdev->query_device = query_device;
+	ibdev->query_device = NULL;
 	ibdev->modify_device = modify_device;
 	ibdev->query_port = query_port;
 	ibdev->modify_port = modify_port;
@@ -1854,13 +1848,12 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = hfi1_check_ah;
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = hfi1_notify_new_ah;
-	dd->verbs_dev.rdi.dparms.props.max_ah = hfi1_max_ahs;
-	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
-	dd->verbs_dev.rdi.dparms.props.max_sge = hfi1_max_sges;
+	/*
+	 * Fill in rvt info device attributes.
+	 */
+	hfi1_fill_device_attr(dd);
 
 	/* queue pair */
-	dd->verbs_dev.rdi.dparms.props.max_qp = hfi1_max_qps;
-	dd->verbs_dev.rdi.dparms.props.max_qp_wr = hfi1_max_qp_wrs;
 	dd->verbs_dev.rdi.dparms.qp_table_size = hfi1_qp_table_size;
 	dd->verbs_dev.rdi.dparms.qpn_start = 0;
 	dd->verbs_dev.rdi.dparms.qpn_inc = 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
