From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: fix "dist" target and subsequent rpm
 building
Date: Wed, 27 Apr 2011 10:25:53 -0700
Message-ID: <20110427102553.99abdec4.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 27 Apr 2011 10:08:03 -0700
Subject: [PATCH] infiniband-diags: fix "dist" target and subsequent rpm building

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libibnetdisc/Makefile.am |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/libibnetdisc/Makefile.am b/libibnetdisc/Makefile.am
index f30d3cc..fbf0e60 100644
--- a/libibnetdisc/Makefile.am
+++ b/libibnetdisc/Makefile.am
@@ -36,7 +36,8 @@ test_testleaks_SOURCES = test/testleaks.c
 test_testleaks_CFLAGS = -Wall $(DBGFLAGS)
 test_testleaks_LDFLAGS = -libnetdisc
 
-libibnetdiscinclude_HEADERS = $(srcdir)/include/infiniband/ibnetdisc.h
+libibnetdiscinclude_HEADERS = $(srcdir)/include/infiniband/ibnetdisc.h \
+				$(srcdir)/include/infiniband/ibnetdisc_osd.h
 
 man_MANS = man/ibnd_debug.3 \
 	man/ibnd_destroy_fabric.3 \
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
