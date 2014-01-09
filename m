From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 5/5] IB/usnic: Port over sysfs to new usnic_fwd.h
Date: Thu,  9 Jan 2014 14:48:10 -0800
Message-ID: <1389307690-11493-6-git-send-email-umalhi@cisco.com>
References: <1389307690-11493-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307690-11493-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch ports usnic_ib_sysfs.c to the new interface of
usnic_fwd.h.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
index bad985e..3e58842 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -104,7 +104,7 @@ usnic_ib_show_config(struct device *device, struct device_attribute *attr,
 			PCI_SLOT(us_ibdev->pdev->devfn),
 			PCI_FUNC(us_ibdev->pdev->devfn),
 			netdev_name(us_ibdev->netdev),
-			us_ibdev->mac,
+			us_ibdev->ufdev->mac,
 			atomic_read(&us_ibdev->vf_cnt.refcount));
 		UPDATE_PTR_LEFT(n, ptr, left);
 
@@ -239,21 +239,17 @@ static ssize_t summary_show(struct usnic_ib_qp_grp *qp_grp, char *buf)
 	int left;
 	char *ptr;
 	struct usnic_vnic_res_chunk *res_chunk;
-	struct usnic_fwd_filter_hndl *default_filter_hndl;
 	struct usnic_vnic_res *vnic_res;
 
 	left = PAGE_SIZE;
 	ptr = buf;
-	default_filter_hndl = list_first_entry(&qp_grp->filter_hndls,
-					struct usnic_fwd_filter_hndl, link);
 
 	n = scnprintf(ptr, left,
-			"QPN: %d State: (%s) PID: %u VF Idx: %hu Filter ID: 0x%x ",
+			"QPN: %d State: (%s) PID: %u VF Idx: %hu ",
 			qp_grp->ibqp.qp_num,
 			usnic_ib_qp_grp_state_to_string(qp_grp->state),
 			qp_grp->owner_pid,
-			usnic_vnic_get_index(qp_grp->vf->vnic),
-			default_filter_hndl->id);
+			usnic_vnic_get_index(qp_grp->vf->vnic));
 	UPDATE_PTR_LEFT(n, ptr, left);
 
 	for (i = 0; qp_grp->res_chunk_list[i]; i++) {
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
