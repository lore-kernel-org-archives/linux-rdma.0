From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-rc 2/2] RDMA/qedr: Parse vlan priority as sl
Date: Tue, 3 Oct 2017 14:47:27 +0300
Message-ID: <1507031247-7972-3-git-send-email-Ram.Amrani@cavium.com>
References: <1507031247-7972-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507031247-7972-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Parse the vlan priority from the vlan tag and configure it to the
WC's sl field.

Fixes: abd49676c707 ("qed: Add RoCE ll2 & GSI support")
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/qedr_cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
index 5ebbe49..ad89653 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_cm.c
@@ -719,6 +719,8 @@ int qedr_gsi_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 		if (vlan_id) {
 			wc[i].wc_flags |= IB_WC_WITH_VLAN;
 			wc[i].vlan_id = vlan_id;
+			wc[i].sl = (qp->rqe_wr_id[qp->rq.cons].vlan &
+				    VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 		}
 
 		qedr_inc_sw_cons(&qp->rq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
