From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/11]  ucm: fix build problem with latest windows ucm
 changes
Date: Fri, 16 Oct 2009 16:51:41 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CCA@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


define dapls_thread_signal as inline

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/linux/openib_osd.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_ucm/linux/openib_osd.h b/dapl/openib_ucm/linux/openib_osd.h
index cf40fc9..fe60aa0 100644
--- a/dapl/openib_ucm/linux/openib_osd.h
+++ b/dapl/openib_ucm/linux/openib_osd.h
@@ -11,6 +11,12 @@
 #define htonll(x)  bswap_64(x)
 #define ntohll(x)  bswap_64(x)
 #endif
+#ifndef STATIC
+#define STATIC static
+#endif /* STATIC */
+#ifndef _INLINE_
+#define _INLINE_ __inline__
+#endif /* _INLINE_ */
 
 #define DAPL_SOCKET int
 #define DAPL_INVALID_SOCKET -1
@@ -23,7 +29,7 @@ struct dapl_thread_signal
 	DAPL_SOCKET scm[2];
 };
 
-static void dapls_thread_signal(struct dapl_thread_signal *signal)
+STATIC _INLINE_ void dapls_thread_signal(struct dapl_thread_signal *signal)
 {
 	send(signal->scm[1], "w", sizeof "w", 0);
 }
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
