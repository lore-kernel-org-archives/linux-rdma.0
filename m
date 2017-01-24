From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5 v2] qedr: fix formatting
Date: Tue, 24 Jan 2017 13:51:40 +0200
Message-ID: <1485258703-11949-3-git-send-email-Ram.Amrani@cavium.com>
References: <1485258703-11949-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485258703-11949-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

remove standalone ';'.
list function's parameters in a single line.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/main.c  | 3 +--
 drivers/infiniband/hw/qedr/verbs.c | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 7b74d09..eac0bfc 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -576,8 +576,7 @@ static int qedr_set_device_attr(struct qedr_dev *dev)
 	return 0;
 }
 
-void qedr_unaffiliated_event(void *context,
-			     u8 event_code)
+void qedr_unaffiliated_event(void *context, u8 event_code)
 {
 	pr_err("unaffiliated event not implemented yet\n");
 }
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 2d55597..25fb75d 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1874,7 +1874,6 @@ int qedr_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			 qp_params.sgid.dwords[2], qp_params.sgid.dwords[3]);
 		DP_DEBUG(dev, QEDR_MSG_QP, "remote_mac=[%pM]\n",
 			 qp_params.remote_mac_addr);
-;
 
 		qp_params.mtu = qp->mtu;
 		qp_params.lb_indication = false;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
