From: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: RESUBMIT: [PATCH] libibmad: To reserve upper 8 bits of tid used by
 solaris SRIOV driver
Date: Tue, 26 Mar 2013 11:31:15 -0700
Message-ID: <5151E973.80901@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060808020905030105050909"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060808020905030105050909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------060808020905030105050909
Content-Type: text/x-patch;
 name="0001-libibmad-To-reserve-upper-8-bits-of-tid-used-by-sola.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-libibmad-To-reserve-upper-8-bits-of-tid-used-by-sola.pa";
 filename*1="tch"

>From 493e8ed95e32f9c3e337f758a979120392c9e412 Mon Sep 17 00:00:00 2001
From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Tue, 12 Mar 2013 19:38:52 +0000
Subject: [PATCH] libibmad: To reserve upper 8 bits of tid used by solaris
 SRIOV driver

Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 src/mad.c |    8 ++++++++
 src/rpc.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/src/mad.c b/src/mad.c
index 70a69dd..fe1305d 100644
--- a/src/mad.c
+++ b/src/mad.c
@@ -50,6 +50,13 @@
 #undef DEBUG
 #define DEBUG	if (ibdebug)	IBWARN
 
+#define GET_IB_USERLAND_TID(tid)	(tid & 0x00000000ffffffff)
+/*
+ * Generate the 64 bit MAD transaction ID. The upper 32 bits are reserved for
+ * use by the kernel. We clear the upper 32 bits here, but MADs received from
+ * the kernel may contain kernel specific data in these bits, consequently
+ * userland TID matching should only be done on the lower 32 bits.
+ */
 uint64_t mad_trid(void)
 {
 	static uint64_t base;
@@ -62,6 +69,7 @@ uint64_t mad_trid(void)
 		trid = random();
 	}
 	next = ++trid | (base << 32);
+	next = GET_IB_USERLAND_TID(next);
 	return next;
 }
 
diff --git a/src/rpc.c b/src/rpc.c
index 5cb13f1..7d93180 100644
--- a/src/rpc.c
+++ b/src/rpc.c
@@ -129,7 +129,7 @@ static int
 _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
 	   int timeout, int max_retries, int *p_error)
 {
-	uint32_t trid;		/* only low 32 bits */
+	uint32_t trid;		/* only low 32 bits - see mad_trid() */
 	int retries;
 	int length, status;
 
-- 
1.7.9.2


--------------060808020905030105050909--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
