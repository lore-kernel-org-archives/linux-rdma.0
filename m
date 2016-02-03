From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] IB/qib: Support query gid in rdmavt
Date: Wed, 03 Feb 2016 14:20:44 -0800
Message-ID: <20160203222040.4030.80379.stgit@scvm10.sc.intel.com>
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

Query gid is in rdmavt, but still relies on the driver to maintain the
guid table. Add the necessary driver call back and remove the existing
verb handler.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index e534355..a3a13a5 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1421,28 +1421,20 @@ static int qib_modify_port(struct ib_device *ibdev, u8 port,
 	return 0;
 }
 
-static int qib_query_gid(struct ib_device *ibdev, u8 port,
-			 int index, union ib_gid *gid)
+static int qib_get_guid_be(struct rvt_dev_info *rdi, struct rvt_ibport *rvp,
+			   int guid_index, __be64 *guid)
 {
-	struct qib_devdata *dd = dd_from_ibdev(ibdev);
-	int ret = 0;
-
-	if (!port || port > dd->num_pports)
-		ret = -EINVAL;
-	else {
-		struct qib_ibport *ibp = to_iport(ibdev, port);
-		struct qib_pportdata *ppd = ppd_from_ibp(ibp);
+	struct qib_ibport *ibp = container_of(rvp, struct qib_ibport, rvp);
+	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 
-		gid->global.subnet_prefix = ibp->rvp.gid_prefix;
-		if (index == 0)
-			gid->global.interface_id = ppd->guid;
-		else if (index < QIB_GUIDS_PER_PORT)
-			gid->global.interface_id = ibp->guids[index - 1];
-		else
-			ret = -EINVAL;
-	}
+	if (guid_index == 0)
+		*guid = ppd->guid;
+	else if (guid_index < QIB_GUIDS_PER_PORT)
+		*guid = ibp->guids[guid_index - 1];
+	else
+		return -EINVAL;
 
-	return ret;
+	return 0;
 }
 
 int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
@@ -1696,7 +1688,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->modify_device = qib_modify_device;
 	ibdev->query_port = qib_query_port;
 	ibdev->modify_port = qib_modify_port;
-	ibdev->query_gid = qib_query_gid;
 	ibdev->process_mad = qib_process_mad;
 	ibdev->get_port_immutable = qib_port_immutable;
 
@@ -1727,6 +1718,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = get_pmtu_from_attr;
 
 	dd->verbs_dev.rdi.dparms.max_rdma_atomic = QIB_MAX_RDMA_ATOMIC;
+	dd->verbs_dev.rdi.driver_f.get_guid_be = qib_get_guid_be;
 	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
 	dd->verbs_dev.rdi.dparms.qp_table_size = ib_qib_qp_table_size;
 	dd->verbs_dev.rdi.dparms.qpn_start = 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
