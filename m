From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: ibqueryerrors fix null threshold_str
Date: Wed, 20 Jul 2011 17:04:11 -0700
Message-ID: <20110720170411.9ae1fc90.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When printing "(null)" was being printed if there was no threshold file

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibqueryerrors.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 1bba0e0..869316b 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -90,7 +90,7 @@ static char *threshold_file = DEF_THRES_FILE;
 
 /* define a "packet" with threshold values in it */
 uint8_t thresholds[1204] = { 0 };
-char * threshold_str = NULL;
+char * threshold_str = "";
 
 static void set_thres(char *name, uint32_t val)
 {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
