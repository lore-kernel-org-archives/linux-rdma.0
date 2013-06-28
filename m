From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm] Makefile.am: Remove eliminated config files from EXTRA_DIST
Date: Fri, 28 Jun 2013 11:18:39 -0400
Message-ID: <51CDA94F.80605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/Makefile.am b/Makefile.am
index c97326a..0de7799 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -19,8 +19,7 @@ man_MANS = \
 	man/ibacm.7
 
 EXTRA_DIST = src/acm_mad.h src/libacm.h ibacm.init.in \
-	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_opts.cfg \
-	     ibacm_addr.cfg ibacm_hosts.cfg
+	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_hosts.cfg
 
 install-exec-hook:
 	install -D -m 755 ibacm.init $(DESTDIR)$(sysconfdir)/init.d/ibacm;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
