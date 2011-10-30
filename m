From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] rdma/cma: minor code refactoring when saving a string content
Date: Sun, 30 Oct 2011 13:48:04 +0200
Message-ID: <201110301348.05062.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In this case, using strdup will provide a cleaner code
(and maybe a little bit faster too).

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---

 src/addrinfo.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/src/addrinfo.c b/src/addrinfo.c
index 695430b..34c7fb4 100755
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -137,9 +137,7 @@ static int ucma_convert_to_rai(struct rdma_addrinfo *rai,
 	if (!addr)
 		return ERR(ENOMEM);
 
-	canonname = ai->ai_canonname ? malloc(strlen(ai->ai_canonname) + 1) : NULL;
-	if (canonname)
-		strcpy(canonname, ai->ai_canonname);
+	canonname = ai->ai_canonname ? strdup(ai->ai_canonname) : NULL;
 
 	memcpy(addr, ai->ai_addr, ai->ai_addrlen);
 	if (ai->ai_flags & RAI_PASSIVE) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
