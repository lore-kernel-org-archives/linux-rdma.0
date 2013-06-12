From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] libibnetdisc/Makefile.am: Add missing makefile
 dependency
Date: Wed, 12 Jun 2013 07:04:15 -0400
Message-ID: <51B855AF.1070607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Found-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/Makefile.am b/libibnetdisc/Makefile.am
index d05604f..2cfcc33 100644
--- a/libibnetdisc/Makefile.am
+++ b/libibnetdisc/Makefile.am
@@ -35,6 +35,7 @@ libibnetdiscincludedir = $(includedir)/infiniband
 test_testleaks_SOURCES = test/testleaks.c
 test_testleaks_CFLAGS = -Wall $(DBGFLAGS)
 test_testleaks_LDFLAGS = -libnetdisc
+test_testleaks_DEPENDENCIES = libibnetdisc.la
 
 libibnetdiscinclude_HEADERS = $(srcdir)/include/infiniband/ibnetdisc.h \
 				$(srcdir)/include/infiniband/ibnetdisc_osd.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
