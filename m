From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 07/23] ocrdma: Fix incorrect type of ibwc_status
Date: Wed, 21 Sep 2016 16:08:33 -0600
Message-ID: <1474495729-17604-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

clang 3.6 remarks:

../providers/ocrdma/ocrdma_verbs.c:1517:35: warning: implicit conversion from enumeration type 'enum ibv_wc_status' to different enumeration type 'enum ibv_wc_opcode' [-Wenum-conversion]
        enum ibv_wc_opcode ibwc_status = IBV_WC_GENERAL_ERR;

And it is not wrong, the enum should be ib_wc_status not opcode.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libocrdma/src/ocrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libocrdma/src/ocrdma_verbs.c b/libocrdma/src/ocrdma_verbs.c
index 5248e7e26c7b..b3c77c47d660 100644
--- a/libocrdma/src/ocrdma_verbs.c
+++ b/libocrdma/src/ocrdma_verbs.c
@@ -1539,7 +1539,7 @@ int ocrdma_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 
 static enum ibv_wc_status ocrdma_to_ibwc_err(uint16_t status)
 {
-	enum ibv_wc_opcode ibwc_status = IBV_WC_GENERAL_ERR;
+	enum ibv_wc_status ibwc_status = IBV_WC_GENERAL_ERR;
 	switch (status) {
 	case OCRDMA_CQE_GENERAL_ERR:
 		ibwc_status = IBV_WC_GENERAL_ERR;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
