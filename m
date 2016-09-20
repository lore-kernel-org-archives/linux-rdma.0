From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 16/19] IB/hns: Update the rq head when modify qp state
Date: Tue, 20 Sep 2016 17:07:09 +0100
Message-ID: <20160920160712.1190216-17-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

The rq head in qpc was zero will miss the rq wqes which
have be sent, so here we should take the real value.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index bc06004..2070e9e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2248,7 +2248,8 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 
 		roce_set_field(context->qpc_bytes_68,
 			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_M,
-			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_S, 0);
+			       QP_CONTEXT_QPC_BYTES_68_RQ_HEAD_S,
+			       hr_qp->rq.head);
 		roce_set_field(context->qpc_bytes_68,
 			       QP_CONTEXT_QPC_BYTES_68_RQ_CUR_INDEX_M,
 			       QP_CONTEXT_QPC_BYTES_68_RQ_CUR_INDEX_S, 0);
-- 
1.9.1
