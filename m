From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] rping: security fix: replace sprintf with snprintf
Date: Tue, 24 Apr 2012 14:38:28 +0300
Message-ID: <201204241438.28483.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Replace sprintf with snprintf to protects from buffer overflow.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 examples/rping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/examples/rping.c b/examples/rping.c
index ee292ec..785338e 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -909,7 +909,7 @@ static int rping_test_client(struct rping_cb *cb)
 		cb->state = RDMA_READ_ADV;
 
 		/* Put some ascii text in the buffer. */
-		cc = sprintf(cb->start_buf, RPING_MSG_FMT, ping);
+		cc = snprintf(cb->start_buf, cb->size, RPING_MSG_FMT, ping);
 		for (i = cc, c = start; i < cb->size; i++) {
 			cb->start_buf[i] = c;
 			c++;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
