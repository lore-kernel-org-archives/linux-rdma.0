From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/6] hns: Fix strange placement of fprintf:
Date: Tue, 31 Jan 2017 14:08:02 -0700
Message-ID: <1485896886-23517-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1485896886-23517-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485896886-23517-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

gcc 7.0.1 observes:

providers/hns/hns_roce_u_hw_v1.c:121:3: warning: statement will never be executed [-Wswitch-unreachable]
   fprintf(stderr, PFX "error cqe!\n");

Due to the strange placement in the switch statement.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/hns/hns_roce_u_hw_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/hns/hns_roce_u_hw_v1.c b/providers/hns/hns_roce_u_hw_v1.c
index ff39593e8740f8..263502d4a85610 100644
--- a/providers/hns/hns_roce_u_hw_v1.c
+++ b/providers/hns/hns_roce_u_hw_v1.c
@@ -114,11 +114,11 @@ static void hns_roce_update_cq_cons_index(struct hns_roce_context *ctx,
 static void hns_roce_handle_error_cqe(struct hns_roce_cqe *cqe,
 				      struct ibv_wc *wc)
 {
+	fprintf(stderr, PFX "error cqe!\n");
 	switch (roce_get_field(cqe->cqe_byte_4,
 			       CQE_BYTE_4_STATUS_OF_THE_OPERATION_M,
 			       CQE_BYTE_4_STATUS_OF_THE_OPERATION_S) &
 		HNS_ROCE_CQE_STATUS_MASK) {
-		fprintf(stderr, PFX "error cqe!\n");
 	case HNS_ROCE_CQE_SYNDROME_LOCAL_LENGTH_ERR:
 		wc->status = IBV_WC_LOC_LEN_ERR;
 		break;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
