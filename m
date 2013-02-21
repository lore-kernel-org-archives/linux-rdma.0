From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] librdmacm/rstream: Reduce default transfer count
Date: Thu, 21 Feb 2013 06:48:47 -0800
Message-ID: <1361458128-10134-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

1 million ping-pong transfers takes over 3 seconds to
complete, and I'm impatient.  Reduce the default number of
transfers for small messsages to speed up running
performance tests, especially when running over slower
connections, like TCP sockets or over a WAN.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/common.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/examples/common.c b/examples/common.c
index 939f50c..4eb5bbe 100644
--- a/examples/common.c
+++ b/examples/common.c
@@ -117,16 +117,14 @@ void cnt_str(char *str, size_t ssize, long long cnt)
 
 int size_to_count(int size)
 {
-	if (size >= 1000000)
+	if (size >= (1 << 20))
 		return 100;
-	else if (size >= 100000)
+	else if (size >= (1 << 16))
 		return 1000;
-	else if (size >= 10000)
+	else if (size >= (1 << 10))
 		return 10000;
-	else if (size >= 1000)
-		return 100000;
 	else
-		return 1000000;
+		return 100000;
 }
 
 void format_buf(void *buf, int size)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
