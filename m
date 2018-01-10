From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 2/7] RDMA/hns: Create gsi qp in hip08
Date: Wed, 10 Jan 2018 14:39:48 +0800
Message-ID: <1515566393-63888-3-git-send-email-oulijun@huawei.com>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515566393-63888-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The gsi qp and rc qp use the same qp context
structure and the created flow, only
differentiate them by qpn and qp type.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 351fa31..4414cea 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -455,6 +455,13 @@ static int hns_roce_set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 		hr_qp->sge.sge_shift = 4;
 	}
 
+	/* ud sqwqe's sge use extend sge */
+	if (hr_dev->caps.max_sq_sg > 2 && hr_qp->ibqp.qp_type == IB_QPT_GSI) {
+		hr_qp->sge.sge_cnt = roundup_pow_of_two(hr_qp->sq.wqe_cnt *
+				     hr_qp->sq.max_gs);
+		hr_qp->sge.sge_shift = 4;
+	}
+
 	/* Get buf size, SQ and RQ are aligned to PAGE_SIZE */
 	page_size = 1 << (hr_dev->caps.mtt_buf_pg_sz + PAGE_SHIFT);
 	hr_qp->sq.offset = 0;
@@ -502,6 +509,8 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 
 	hr_qp->state = IB_QPS_RESET;
 
+	hr_qp->ibqp.qp_type = init_attr->qp_type;
+
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		hr_qp->sq_signal_bits = IB_SIGNAL_ALL_WR;
 	else
@@ -764,8 +773,13 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *pd,
 		hr_qp = &hr_sqp->hr_qp;
 		hr_qp->port = init_attr->port_num - 1;
 		hr_qp->phy_port = hr_dev->iboe.phy_port[hr_qp->port];
-		hr_qp->ibqp.qp_num = HNS_ROCE_MAX_PORTS +
-				     hr_dev->iboe.phy_port[hr_qp->port];
+
+		/* when hw version is v1, the sqpn is allocated */
+		if (hr_dev->caps.max_sq_sg <= 2)
+			hr_qp->ibqp.qp_num = HNS_ROCE_MAX_PORTS +
+					     hr_dev->iboe.phy_port[hr_qp->port];
+		else
+			hr_qp->ibqp.qp_num = 1;
 
 		ret = hns_roce_create_qp_common(hr_dev, pd, init_attr, udata,
 						hr_qp->ibqp.qp_num, hr_qp);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
