From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [ibacm] ibacm: Remove umask(0)
Date: Wed, 10 Oct 2012 15:55:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346AA40BB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This causes ibacm files to be created as world writable.

Problem reported by Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 00fc35d..725cde2 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -3182,8 +3182,6 @@ static void daemonize(void)
 	if (pid)
 		exit(pid < 0);
 
-	umask(0);
-
 	sid = setsid();
 	if (sid < 0)
 		exit(1);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
