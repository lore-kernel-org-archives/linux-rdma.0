From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: do not pass uninitialized ai_hints into
 getaddrinfo
Date: Wed, 8 Sep 2010 11:12:36 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB4EA12B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If rdma_getaddrinfo is called with hints set to NULL, then an
uninitialized ai_hints structure will be passed into getaddrinfo.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/addrinfo.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)
 mode change 100644 => 100755 src/addrinfo.c

diff --git a/src/addrinfo.c b/src/addrinfo.c
index c8d9f0c..7c7056f
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -136,17 +136,21 @@ int rdma_getaddrinfo(char *node, char *service,
 {
 	struct rdma_addrinfo *rai;
 	struct addrinfo ai_hints;
-	struct addrinfo *ai;
+	struct addrinfo *ai, *aih;
 	int ret;
 
 	ret = ucma_init();
 	if (ret)
 		return ret;
 
-	if (hints)
+	if (hints) {
 		ucma_convert_to_ai(&ai_hints, hints);
+		aih = &ai_hints;
+	} else {
+		aih = NULL;
+	}
 
-	ret = getaddrinfo(node, service, &ai_hints, &ai);
+	ret = getaddrinfo(node, service, aih, &ai);
 	if (ret)
 		return ret;
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
