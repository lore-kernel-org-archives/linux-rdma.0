From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] libibmad: Makefile.am: Fix INCLUDES warning
Date: Mon, 26 Sep 2016 02:20:54 -0400
Message-ID: <1474870855-21158-2-git-send-email-ira.weiny@intel.com>
References: <1474870855-21158-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474870855-21158-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change INCLUDES to AM_CPPFLAGS to avoid the following warning

Makefile.am:4: warning: 'INCLUDES' is the old name for 'AM_CPPFLAGS' (or '*_CPPFLAGS')

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index b96657eb8d8a..acd0ae219a82 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 ACLOCAL_AMFLAGS = -I config
 SUBDIRS = .
 
-INCLUDES = -I$(srcdir)/include -I$(includedir)
+AM_CPPFLAGS = -I$(srcdir)/include -I$(includedir)
 
 lib_LTLIBRARIES = libibmad.la
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
