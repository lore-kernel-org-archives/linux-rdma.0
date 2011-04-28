From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/7] libibumad: Add new umad header files to release
Date: Thu, 28 Apr 2011 16:04:06 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F412C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
