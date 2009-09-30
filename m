From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] dapl/dtest: remove gettimeofday definition
Date: Wed, 30 Sep 2009 16:15:07 -0700
Message-ID: <E9F6461C37494A9586069CB583DF5E14@amr.corp.intel.com>
References: <E61D2EAC1B404A49ACB04B4092C00BEC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E61D2EAC1B404A49ACB04B4092C00BEC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

WinOF provides a common implementation of gettimeofday that should
be used instead.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 test/dtest/dtest.c   |   17 +++--------------
 test/dtest/dtestcm.c |   19 +++----------------
 test/dtest/dtestx.c  |    6 +++---
 3 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/test/dtest/dtest.c b/test/dtest/dtest.c
index 22999f7..1ae279f 100755
--- a/test/dtest/dtest.c
+++ b/test/dtest/dtest.c
@@ -723,17 +723,6 @@ complete:
 	return (0);
 }
 
-#if defined(_WIN32) || defined(_WIN64)
-void gettimeofday(struct timeval *t, char *jnk)
-{
-	SYSTEMTIME now;
-	GetLocalTime(&now);
-	t->tv_sec = now.wMinute * 60;
-	t->tv_sec += now.wSecond;
-	t->tv_usec = now.wMilliseconds;
-}
-#endif
-
 double get_time(void)
 {
 	struct timeval tp;
diff --git a/test/dtest/dtestcm.c b/test/dtest/dtestcm.c
index 427a25e..d1e5712 100644
--- a/test/dtest/dtestcm.c
+++ b/test/dtest/dtestcm.c
@@ -547,19 +547,6 @@ bail:
 	return (0);
 }
 
-#if defined(_WIN32) || defined(_WIN64)
-
-void gettimeofday(struct timeval *t, char *jnk)
-{
-	SYSTEMTIME now;
-	GetLocalTime(&now);
-	t->tv_sec = now.wMinute * 60;
-	t->tv_sec += now.wSecond;
-	t->tv_usec = now.wMilliseconds;
-}
-
-#endif
-
 double get_time(void)
 {
 	struct timeval tp;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
