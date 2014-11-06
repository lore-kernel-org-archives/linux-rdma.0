From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] rping: ignore flushed completions
Date: Thu,  6 Nov 2014 14:42:57 +0530
Message-ID: <1415265177-7616-2-git-send-email-hariprasad@chelsio.com>
References: <1415265177-7616-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415265177-7616-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Based on original work by Steve Wise <steve-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 examples/rping.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/examples/rping.c b/examples/rping.c
index f0414de..58b642e 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -277,15 +277,20 @@ static int rping_cq_event_handler(struct rping_cb *cb)
 	struct ibv_wc wc;
 	struct ibv_recv_wr *bad_wr;
 	int ret;
+	int flushed = 0;
 
 	while ((ret = ibv_poll_cq(cb->cq, 1, &wc)) == 1) {
 		ret = 0;
 
 		if (wc.status) {
-			if (wc.status != IBV_WC_WR_FLUSH_ERR)
-				fprintf(stderr,
-					"cq completion failed status %d\n",
-					wc.status);
+			if (wc.status == IBV_WC_WR_FLUSH_ERR) {
+				flushed = 1;
+				continue;
+
+			}
+			fprintf(stderr,
+				"cq completion failed status %d\n",
+				wc.status);
 			ret = -1;
 			goto error;
 		}
@@ -334,7 +339,7 @@ static int rping_cq_event_handler(struct rping_cb *cb)
 		fprintf(stderr, "poll error %d\n", ret);
 		goto error;
 	}
-	return 0;
+	return flushed;
 
 error:
 	cb->state = ERROR;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
