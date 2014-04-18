From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH librdmacm 2/4] rsocket: Dedicate a fixed number of SQEs for control messages
Date: Fri, 18 Apr 2014 14:55:41 -0700
Message-ID: <1397858143-22402-2-git-send-email-sean.hefty@intel.com>
References: <1397858143-22402-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397858143-22402-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The number of SQEs allocated for control messages is set
to 1 of 2 constant values (either 4 or 2).  A default
value is used unless the size of the SQ is below a certain
threshold (16 entries).  This results in additional code
complexity, and it is highly unlikely that the SQ would
ever be allocated smaller than 16 entries.

Simplify the code to use a single constant value for the
number of SQEs allocated for control messages.  This will
also help in subsequent patches that will need to deal
with HCAs that do not support inline data.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 7c5083c..ea18ba7 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -59,6 +59,7 @@
 #define RS_OLAP_START_SIZE 2048
 #define RS_MAX_TRANSFER 65536
 #define RS_SNDLOWAT 2048
+#define RS_QP_MIN_SIZE 16
 #define RS_QP_MAX_SIZE 0xFFFE
 #define RS_QP_CTRL_SIZE 4
 #define RS_CONN_RETRIES 6
@@ -642,15 +643,13 @@ static void rs_set_qp_size(struct rsocket *rs)
 
 	if (rs->sq_size > max_size)
 		rs->sq_size = max_size;
-	else if (rs->sq_size < 4)
-		rs->sq_size = 4;
-	if (rs->sq_size <= (RS_QP_CTRL_SIZE << 2))
-		rs->ctrl_avail = 2;
+	else if (rs->sq_size < RS_QP_MIN_SIZE)
+		rs->sq_size = RS_QP_MIN_SIZE;
 
 	if (rs->rq_size > max_size)
 		rs->rq_size = max_size;
-	else if (rs->rq_size < 4)
-		rs->rq_size = 4;
+	else if (rs->rq_size < RS_QP_MIN_SIZE)
+		rs->rq_size = RS_QP_MIN_SIZE;
 }
 
 static void ds_set_qp_size(struct rsocket *rs)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
