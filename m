From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags: Fix RPM build error
Date: Wed, 11 Jul 2012 10:06:16 -0400
Message-ID: <4FFD8858.3030205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


RPM build errors:
Installed (but unpackaged) file(s) found:
/etc/infiniband-diags

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/Makefile.am b/Makefile.am
index 33b5f90..2265110 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -147,5 +147,5 @@ install-data-hook:
 		$(top_srcdir)/config/install-sh -m 755 -d $(DESTDIR)/$(sysconfdir)/infiniband-diags; \
 	fi
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
-	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
-	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
+	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags/error_thresholds
+	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags/ibdiag.conf
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index d3fcd13..86db3fd 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -158,6 +158,7 @@ rm -rf $RPM_BUILD_ROOT
 %{_mandir}/man8/infiniband-diags.8.gz
 %{_libdir}/*.a
 %{_libdir}/*.so*
+%{_sysconfdir}/*
 %{_mandir}/man3/*
 %{_includedir}/infiniband/*.h
 %define _perldir %(perl -e 'use Config; $T=$Config{installvendorlib}; print $T;')
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
