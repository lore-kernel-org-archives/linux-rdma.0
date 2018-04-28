From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] IB/cxgb4: use skb_put_zero()/__skb_put_zero
Date: Sat, 28 Apr 2018 15:31:06 +0800
Message-ID: <20180428073106.14696-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: swise@chelsio.com, dledford@redhat.com, jgg@ziepe.ca, monis@mellanox.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Use the recently introduced helper to replace the pattern of
skb_put_zero/__skb_put() && memset().

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/cxgb4/qp.c    | 9 +++------
 drivers/infiniband/sw/rxe/rxe_net.c | 4 +---
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index de77b60..2dc9499 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1297,8 +1297,7 @@ static void post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe,
 
 	set_wr_txq(skb, CPL_PRIORITY_DATA, qhp->ep->txq_idx);
 
-	wqe = __skb_put(skb, sizeof(*wqe));
-	memset(wqe, 0, sizeof *wqe);
+	wqe = __skb_put_zero(skb, sizeof(*wqe));
 	wqe->op_compl = cpu_to_be32(FW_WR_OP_V(FW_RI_INIT_WR));
 	wqe->flowid_len16 = cpu_to_be32(
 		FW_WR_FLOWID_V(qhp->ep->hwtid) |
@@ -1421,8 +1420,7 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ep->txq_idx);
 
-	wqe = __skb_put(skb, sizeof(*wqe));
-	memset(wqe, 0, sizeof *wqe);
+	wqe = __skb_put_zero(skb, sizeof(*wqe));
 	wqe->op_compl = cpu_to_be32(
 		FW_WR_OP_V(FW_RI_INIT_WR) |
 		FW_WR_COMPL_F);
@@ -1487,8 +1485,7 @@ static int rdma_init(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 	}
 	set_wr_txq(skb, CPL_PRIORITY_DATA, qhp->ep->txq_idx);
 
-	wqe = __skb_put(skb, sizeof(*wqe));
-	memset(wqe, 0, sizeof *wqe);
+	wqe = __skb_put_zero(skb, sizeof(*wqe));
 	wqe->op_compl = cpu_to_be32(
 		FW_WR_OP_V(FW_RI_INIT_WR) |
 		FW_WR_COMPL_F);
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 9da6e37..95dcd10 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -562,11 +562,9 @@ struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 
 	pkt->rxe	= rxe;
 	pkt->port_num	= port_num;
-	pkt->hdr	= skb_put(skb, paylen);
+	pkt->hdr	= skb_put_zero(skb, paylen);
 	pkt->mask	|= RXE_GRH_MASK;
 
-	memset(pkt->hdr, 0, paylen);
-
 	dev_put(ndev);
 	return skb;
 }
-- 
2.7.0
