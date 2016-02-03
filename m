From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 43/54] staging/rdma/hfi1: Support query gid in rdmavt
Date: Wed, 03 Feb 2016 14:36:40 -0800
Message-ID: <20160203223636.5923.37863.stgit@scvm10.sc.intel.com>
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

Query gid is in rdmavt, but still relies on the driver to maintain the
guid table. Add the necessary driver call back and remove the existing
verb handler.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 8f351bc..a85fd81 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1345,28 +1345,20 @@ static int modify_port(struct ib_device *ibdev, u8 port,
 	return ret;
 }
 
-static int query_gid(struct ib_device *ibdev, u8 port,
-		     int index, union ib_gid *gid)
+static int hfi1_get_guid_be(struct rvt_dev_info *rdi, struct rvt_ibport *rvp,
+			    int guid_index, __be64 *guid)
 {
-	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	int ret = 0;
+	struct hfi1_ibport *ibp = container_of(rvp, struct hfi1_ibport, rvp);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 
-	if (!port || port > dd->num_pports)
-		ret = -EINVAL;
-	else {
-		struct hfi1_ibport *ibp = to_iport(ibdev, port);
-		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-
-		gid->global.subnet_prefix = ibp->rvp.gid_prefix;
-		if (index == 0)
-			gid->global.interface_id = cpu_to_be64(ppd->guid);
-		else if (index < HFI1_GUIDS_PER_PORT)
-			gid->global.interface_id = ibp->guids[index - 1];
-		else
-			ret = -EINVAL;
-	}
+	if (guid_index == 0)
+		*guid = cpu_to_be64(ppd->guid);
+	else if (guid_index < HFI1_GUIDS_PER_PORT)
+		*guid = ibp->guids[guid_index - 1];
+	else
+		return -EINVAL;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -1538,7 +1530,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->modify_device = modify_device;
 	ibdev->query_port = query_port;
 	ibdev->modify_port = modify_port;
-	ibdev->query_gid = query_gid;
 
 	/* keep process mad in the driver */
 	ibdev->process_mad = hfi1_process_mad;
@@ -1555,6 +1546,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = hfi1_check_ah;
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = hfi1_notify_new_ah;
+	dd->verbs_dev.rdi.driver_f.get_guid_be = hfi1_get_guid_be;
 	/*
 	 * Fill in rvt info device attributes.
 	 */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
