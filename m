From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: remove mad.h from ibstat
Date: Mon, 30 Apr 2012 14:02:26 -0700
Message-ID: <20120430140226.4f5ef7c9.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


ibstat does not require libibmad directly.

The change to ibdiag_common was required because of the conflict between the
define in ib_types.h and enum in mad.h which presented itself after the fix in
ibstat.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    2 +-
 src/ibstat.c            |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 09dc319..6645322 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -39,8 +39,8 @@
 #ifndef _IBDIAG_COMMON_H_
 #define _IBDIAG_COMMON_H_
 
-#include <infiniband/iba/ib_types.h>
 #include <infiniband/mad.h>
+#include <infiniband/iba/ib_types.h>
 #include <infiniband/ibnetdisc.h>
 
 extern int ibverbose;
diff --git a/src/ibstat.c b/src/ibstat.c
index ade5d7a..f953cf4 100644
--- a/src/ibstat.c
+++ b/src/ibstat.c
@@ -50,7 +50,6 @@
 #include <errno.h>
 
 #include <infiniband/umad.h>
-#include <infiniband/mad.h>
 
 #include <ibdiag_common.h>
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
