From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and immediate
Date: Wed, 1 Nov 2017 18:00:40 +0800
Message-ID: <1509530440-164400-4-git-send-email-oulijun@huawei.com>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509530440-164400-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In hip08, the immediate field of cqe need to set for big endian
format when rdma operation is rmda operation with immediate.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index 7777e75..4a8f63a 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -385,7 +385,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
 		case HNS_ROCE_RECV_OP_RDMA_WRITE_IMM:
 			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
 			wc->wc_flags = IBV_WC_WITH_IMM;
-			wc->imm_data = cqe->rkey_immtdata;
+			wc->imm_data = be32toh(cqe->rkey_immtdata);
 			break;
 
 		case HNS_ROCE_RECV_OP_SEND:
@@ -396,7 +396,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
 		case HNS_ROCE_RECV_OP_SEND_WITH_IMM:
 			wc->opcode = IBV_WC_RECV;
 			wc->wc_flags = IBV_WC_WITH_IMM;
-			wc->imm_data = cqe->rkey_immtdata;
+			wc->imm_data = be32toh(cqe->rkey_immtdata);
 			break;
 
 		case HNS_ROCE_RECV_OP_SEND_WITH_INV:
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
