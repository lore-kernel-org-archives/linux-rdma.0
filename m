From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: ibnetdisc Wrap header for use in C++ code
Date: Tue, 20 Sep 2011 10:45:42 -0700
Message-ID: <20110920104542.9e24c01c.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 4ec00110f416643f6715c89c4776fc9e0ea51d6f Mon Sep 17 00:00:00 2001
From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 19 Sep 2011 14:05:09 -0700


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libibnetdisc/include/infiniband/ibnetdisc.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/libibnetdisc/include/infiniband/ibnetdisc.h b/libibnetdisc/include/infiniband/ibnetdisc.h
index 59c5606..24df787 100644
--- a/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -36,6 +36,10 @@
 #ifndef _IBNETDISC_H_
 #define _IBNETDISC_H_
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 #include <stdio.h>
 #include <infiniband/mad.h>
 #include <iba/ib_types.h>
@@ -237,4 +241,8 @@ IBND_EXPORT int ibnd_is_xsigo_guid(uint64_t guid);
 IBND_EXPORT int ibnd_is_xsigo_tca(uint64_t guid);
 IBND_EXPORT int ibnd_is_xsigo_hca(uint64_t guid);
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif				/* _IBNETDISC_H_ */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
