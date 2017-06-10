From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-rdma 3/5] IB/hns: Fix the bug with rdma operation
Date: Sat, 10 Jun 2017 18:49:23 +0800
Message-ID: <1497091765-10513-4-git-send-email-oulijun@huawei.com>
References: <1497091765-10513-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497091765-10513-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When opcode of work request is RDMA read and write, it
should use rdma_wr to get remote_addr and rkey. This
patch fixes it.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 1db10d1..fa30989 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -228,14 +228,14 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			switch (wr->opcode) {
 			case IB_WR_RDMA_READ:
 				ps_opcode = HNS_ROCE_WQE_OPCODE_RDMA_READ;
-				set_raddr_seg(wqe, atomic_wr(wr)->remote_addr,
-					      atomic_wr(wr)->rkey);
+				set_raddr_seg(wqe,  rdma_wr(wr)->remote_addr,
+					       rdma_wr(wr)->rkey);
 				break;
 			case IB_WR_RDMA_WRITE:
 			case IB_WR_RDMA_WRITE_WITH_IMM:
 				ps_opcode = HNS_ROCE_WQE_OPCODE_RDMA_WRITE;
-				set_raddr_seg(wqe, atomic_wr(wr)->remote_addr,
-					      atomic_wr(wr)->rkey);
+				set_raddr_seg(wqe,  rdma_wr(wr)->remote_addr,
+					      rdma_wr(wr)->rkey);
 				break;
 			case IB_WR_SEND:
 			case IB_WR_SEND_WITH_INV:
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
