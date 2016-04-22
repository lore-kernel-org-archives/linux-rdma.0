From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] RDMA/i40iw: Fix for removing quad hash entries
Date: Fri, 22 Apr 2016 14:14:29 -0500
Message-ID: <1461352469-16504-8-git-send-email-tatyana.e.nikolova@intel.com>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461352469-16504-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for removing a quad hash entry when the
corresponding quad hash entry hasn't been added,
which is the case in loopback connections

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 8cb4b87..d2fa725 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3729,6 +3729,7 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct sockaddr_in *raddr;
 	struct sockaddr_in6 *laddr6;
 	struct sockaddr_in6 *raddr6;
+	bool qhash_set = false;
 	int apbvt_set = 0;
 	enum i40iw_status_code status;
 
@@ -3787,6 +3788,7 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 					    true);
 		if (status)
 			return -EINVAL;
+		qhash_set = true;
 	}
 	status = i40iw_manage_apbvt(iwdev, cm_info.loc_port, I40IW_MANAGE_APBVT_ADD);
 	if (status) {
@@ -3814,7 +3816,7 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		cm_node->ord_size = 1;
 
 	cm_node->apbvt_set = apbvt_set;
-	cm_node->qhash_set = true;
+	cm_node->qhash_set = qhash_set;
 	iwqp->cm_node = cm_node;
 	cm_node->iwqp = iwqp;
 	iwqp->cm_id = cm_id;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
