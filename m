From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch 2/2] IB/hns: Fix some error handling in hns_roce_v1_query_qp()
Date: Fri, 14 Oct 2016 10:34:42 +0300
Message-ID: <20161014073441.GB15238@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

to_ib_qp_state() returns IB_QPS_ERR (6) on error, it doesn't return -1.

Fixes: 9a4435375cd1 ('IB/hns: Add driver files for hns RoCE driver')
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 58b150e..280abac 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2544,7 +2544,7 @@ int hns_roce_v1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
 			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S);
 	tmp_qp_state = (int)to_ib_qp_state((enum hns_roce_qp_state)state);
-	if (tmp_qp_state == -1) {
+	if (tmp_qp_state == IB_QPS_ERR) {
 		dev_err(dev, "to_ib_qp_state error\n");
 		ret = -EINVAL;
 		goto out;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
