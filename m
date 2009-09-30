From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] dapl/dtestx: add definition for getpid
Date: Wed, 30 Sep 2009 16:15:56 -0700
Message-ID: <6C197864FC9E4FC6A30D62E8D6255ACB@amr.corp.intel.com>
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

Add definition for getpid similar to that used by the other dtest apps.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 test/dtest/dtestcm.c |    1 +
 test/dtest/dtestx.c  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/test/dtest/dtestcm.c b/test/dtest/dtestcm.c
index d1e5712..cb2f262 100644
--- a/test/dtest/dtestcm.c
+++ b/test/dtest/dtestcm.c
@@ -49,6 +49,7 @@
 #include <complib/cl_types.h>
 #include "..\..\..\..\etc\user\getopt.c"
 
+#define getpid() ((int)GetCurrentProcessId())
 #define F64x "%I64x"
 #define F64d "%I64d"
 
diff --git a/test/dtest/dtestx.c b/test/dtest/dtestx.c
index 369d58b..6e078ec 100755
--- a/test/dtest/dtestx.c
+++ b/test/dtest/dtestx.c
@@ -44,6 +44,7 @@
 #include "..\..\..\..\etc\user\getopt.c"
 #define __BYTE_ORDER __LITTLE_ENDIAN
 
+#define getpid() ((int)GetCurrentProcessId())
 #define F64x "%I64x"
 #define F64u "%I64u"
 #define DAPL_PROVIDER "ibnic0v2"



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
