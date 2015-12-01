From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 08/17] staging/rdma/hfi1: Add a credit push on diagpkt allocate fail
Date: Tue,  1 Dec 2015 15:38:17 -0500
Message-ID: <1449002306-15180-9-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When sending a diagnostic packet, if the send context does not
have enough room, force a credit return and try again.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- No changes

 drivers/staging/rdma/hfi1/diag.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 0aaad74..e4cd333 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -379,6 +379,7 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 	pio_release_cb credit_cb = NULL;
 	void *credit_arg = NULL;
 	struct diagpkt_wait *wait = NULL;
+	int trycount = 0;
 
 	dd = hfi1_lookup(dp->unit);
 	if (!dd || !(dd->flags & HFI1_PRESENT) || !dd->kregbase) {
@@ -493,8 +494,15 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 		credit_arg = wait;
 	}
 
+retry:
 	pbuf = sc_buffer_alloc(sc, total_len, credit_cb, credit_arg);
 	if (!pbuf) {
+		if (trycount == 0) {
+			/* force a credit return and try again */
+			sc_return_credits(sc);
+			trycount = 1;
+			goto retry;
+		}
 		/*
 		 * No send buffer means no credit callback.  Undo
 		 * the wait set-up that was done above.  We free wait
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
