From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 4/5] staging/rdma/hfi1: Detect SDMA transmission error early
Date: Tue,  8 Dec 2015 17:10:12 -0500
Message-ID: <1449612613-6616-5-git-send-email-ira.weiny@intel.com>
References: <1449612613-6616-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449612613-6616-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It is possible for an SDMA transmission error to happen
during the processing of an user SDMA transfer. In that
case it is better to detect it early and abort any further
attempts to send more packets.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 060c2200757d..3033df5596f3 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -782,6 +782,12 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 
 	pq = req->pq;
 
+	/* If tx completion has reported an error, we are done. */
+	if (test_bit(SDMA_REQ_HAS_ERROR, &req->flags)) {
+		set_bit(SDMA_REQ_DONE_ERROR, &req->flags);
+		return -EFAULT;
+	}
+
 	/*
 	 * Check if we might have sent the entire request already
 	 */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
