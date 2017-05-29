From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 1/2] RDMA/qedr: Initialize byte_len in WC of READ and SEND commands
Date: Mon, 29 May 2017 16:23:10 +0300
Message-ID: <1496064191-11442-2-git-send-email-Ram.Amrani@cavium.com>
References: <1496064191-11442-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496064191-11442-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

Initialize byte_len in work completion of RDMA_READ and RDMA_SEND.
Exposed by uDAPL application.

Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 6b3bb32..f3ed4cc 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3149,6 +3149,11 @@ static int process_req(struct qedr_dev *dev, struct qedr_qp *qp,
 		case IB_WC_REG_MR:
 			qp->wqe_wr_id[qp->sq.cons].mr->info.completed++;
 			break;
+		case IB_WC_RDMA_READ:
+		case IB_WC_SEND:
+			wc->byte_len = qp->wqe_wr_id[qp->sq.cons].bytes_len;
+
+			break;
 		default:
 			break;
 		}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
