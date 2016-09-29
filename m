From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 5/9] Remove HAVE_SYMVER_SUPPORT
Date: Thu, 29 Sep 2016 14:47:52 -0600
Message-ID: <1475182076-5411-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

cmake now hard requires GNU style symbol version support in the
assembler and linker.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/config.h.in     |  3 ---
 libibverbs/src/ibverbs.h | 11 ++---------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index 3b94ea3e4f51..99103b779baf 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -9,9 +9,6 @@
 // FIXME: Remove this, we provide the netlink kernel headers ibacm needs
 #define HAVE_NETLINK 1
 
-// FIXME: Remove this, The cmake version hard-requires symbol version support
-#define HAVE_SYMVER_SUPPORT 1
-
 // FIXME: Remove this, The cmake version hard-requires new style CLOEXEC support
 #define STREAM_CLOEXEC "e"
 
diff --git a/libibverbs/src/ibverbs.h b/libibverbs/src/ibverbs.h
index 7892af4ad247..a01dff2b4638 100644
--- a/libibverbs/src/ibverbs.h
+++ b/libibverbs/src/ibverbs.h
@@ -47,16 +47,9 @@
 
 #define DEFAULT_ABI	"IBVERBS_1.1"
 
-#ifdef HAVE_SYMVER_SUPPORT
-#  define symver(name, api, ver) \
-	asm(".symver " #name "," #api "@" #ver)
-#  define default_symver(name, api) \
+#define symver(name, api, ver) asm(".symver " #name "," #api "@" #ver)
+#define default_symver(name, api)                                              \
 	asm(".symver " #name "," #api "@@" DEFAULT_ABI)
-#else
-#  define symver(name, api, ver)
-#  define default_symver(name, api) \
-	extern __typeof(name) api __attribute__((alias(#name)))
-#endif /* HAVE_SYMVER_SUPPORT */
 
 #define PFX		"libibverbs: "
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
