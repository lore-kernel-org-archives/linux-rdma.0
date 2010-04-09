From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 26/37 v2] librdmacm: set src_addr in rdma_getaddrinfo
Date: Fri, 9 Apr 2010 11:54:14 -0700
Message-ID: <5E4FE051BB434C208F598D2EB2984FE2@amr.corp.intel.com>
References: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the user provides a source address as a hint, copy
the address to rdma_addrinfo ai_src_addr.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes from v1:
Only copy the source address if one is provided by the user though the hints.
Do not assign a source address otherwise.  The kernel will resolve the
source address for us via rdma_resolve_addr().

 src/addrinfo.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/src/addrinfo.c b/src/addrinfo.c
index 15ae071..f5f86a0 100644
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -39,6 +39,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netdb.h>
+#include <unistd.h>
 
 #include "cma.h"
 #include <rdma/rdma_cma.h>
@@ -159,6 +160,17 @@ int rdma_getaddrinfo(char *node, char *service,
 	if (ret)
 		goto err2;
 
+	if (!rai->ai_src_len && hints && hints->ai_src_len) {
+		rai->ai_src_addr = calloc(1, hints->ai_src_len);
+		if (!rai->ai_src_addr) {
+			ret = ERR(ENOMEM);
+			goto err2;
+		}
+		memcpy(rai->ai_src_addr, hints->ai_src_addr,
+		       hints->ai_src_len);
+		rai->ai_src_len = hints->ai_src_len;
+	}
+
 	freeaddrinfo(ai);
 	*res = rai;
 	return 0;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
