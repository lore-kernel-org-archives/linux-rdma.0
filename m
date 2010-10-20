From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] RPING: Remove printf for FLUSH completion.
Date: Wed, 20 Oct 2010 14:29:05 -0500
Message-ID: <20101020192905.1431.40267.stgit@build.ogc.int>
References: <20101020192859.1431.68877.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020192859.1431.68877.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 examples/rping.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/examples/rping.c b/examples/rping.c
index e603d3b..5eb71e2 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -280,10 +280,12 @@ static int rping_cq_event_handler(struct rping_cb *cb)
 		ret = 0;
 
 		if (wc.status) {
-			fprintf(stderr, "cq completion failed status %d\n",
-				wc.status);
-			if (wc.status != IBV_WC_WR_FLUSH_ERR)
+			if (wc.status != IBV_WC_WR_FLUSH_ERR) {
+				fprintf(stderr, 
+					"cq completion failed status %d\n",
+					wc.status);
 				ret = -1;
+			}
 			goto error;
 		}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
