From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ibsim: support MFT for switches with up to 48 ports
Date: Mon, 13 Sep 2010 14:09:20 +0200
Message-ID: <4C8E1470.8070106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

support MFT for switches with up to 48 ports

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 ibsim/sim.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ibsim/sim.h b/ibsim/sim.h
index 5a8a92f..0de7fdc 100644
--- a/ibsim/sim.h
+++ b/ibsim/sim.h
@@ -45,8 +45,8 @@
 #define MAXLINEARCAP	(30*1024)
 #define MAXMCASTCAP	1024
 #define LASTBLOCK32	(MAXMCASTCAP/32-1)
-// NUMBEROFPORTMASK means that 32port switches could only be build
-#define	NUMBEROFPORTMASK 2
+// NUMBEROFPORTMASK means that 48port switches could only be build
+#define	NUMBEROFPORTMASK 3
 #define LASTPORTMASK	(NUMBEROFPORTMASK-1)
 // linkwidth == 4X - must be one width only 1,2 or 8
 #define LINKWIDTH_1x        1
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
