From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 1/5] RDMA/qedr: reset access control when registering a MR
Date: Thu, 27 Apr 2017 13:35:31 +0300
Message-ID: <1493289335-29350-2-git-send-email-Ram.Amrani@cavium.com>
References: <1493289335-29350-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493289335-29350-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 6b3bb32..62ab22a 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2624,6 +2624,8 @@ static int qedr_prepare_reg(struct qedr_qp *qp,
 	fwqe1->addr.lo = lower_32_bits(mr->ibmr.iova);
 	fwqe1->l_key = wr->key;
 
+	fwqe2->access_ctrl = 0;
+
 	SET_FIELD2(fwqe2->access_ctrl, RDMA_SQ_FMR_WQE_2ND_REMOTE_READ,
 		   !!(wr->access & IB_ACCESS_REMOTE_READ));
 	SET_FIELD2(fwqe2->access_ctrl, RDMA_SQ_FMR_WQE_2ND_REMOTE_WRITE,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
