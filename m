From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/7] libibumad: Add new umad header files to release
Date: Mon, 28 Jan 2013 13:38:53 -0800
Message-ID: <1359409135-559-5-git-send-email-sean.hefty@intel.com>
References: <1359409135-559-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359409135-559-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 604f57a..14e2389 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -34,7 +34,11 @@ libibumad_la_DEPENDENCIES = $(srcdir)/src/libibumad.map
 
 libibumadincludedir = $(includedir)/infiniband
 
-libibumadinclude_HEADERS = $(srcdir)/include/infiniband/umad.h
+libibumadinclude_HEADERS = $(srcdir)/include/infiniband/umad.h \
+	$(srcdir)/include/infiniband/umad_types.h \
+	$(srcdir)/include/infiniband/umad_sa.h \
+	$(srcdir)/include/infiniband/umad_sm.h \
+	$(srcdir)/include/infiniband/umad_cm.h
 
 EXTRA_DIST = $(srcdir)/include/infiniband/umad.h \
 	libibumad.spec.in libibumad.spec \
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
