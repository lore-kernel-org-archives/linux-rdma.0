From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 11/28] ocrdma: Fix incorrect type of ibwc_status
Date: Mon,  5 Sep 2016 15:08:01 -0600
Message-ID: <1473109698-31408-12-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
