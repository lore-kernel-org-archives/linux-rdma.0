From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/15] uDAPL v2.0 config/build: remove post/postun hacking
 used to modify dat.conf
Date: Mon, 23 Apr 2012 20:01:13 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F9481202B7@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Return to the tried and true method of managing configuration
files via %config directive and remove ugly sed editing methods.
The dat.conf includes both v1 and v2 device entries to insure
backward compatibility.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am  |   36 +++---------------------------------
 dapl.spec.in |   35 +++--------------------------------
 2 files changed, 6 insertions(+), 65 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index edff7f8..7441348 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -50,6 +50,8 @@ else
 AM_CFLAGS = -g -Wall -D_GNU_SOURCE -DDAT_CONF="\"$(sysconfdir)/dat.conf\""
 endif
 
+sysconf_DATA = doc/dat.conf
+
 datlibdir = $(libdir)
 if DEFINE_CMA
 dapllibofadir = $(libdir)
@@ -559,6 +561,7 @@ EXTRA_DIST = dat/common/dat_dictionary.h \
 	     LICENSE.txt \
 	     LICENSE2.txt \
 	     LICENSE3.txt \
+	     doc/dat.conf \
 	     dapl.spec.in \
 	     $(man_MANS) \
 	     test/dapltest/include/dapl_bpool.h \
@@ -592,37 +595,4 @@ EXTRA_DIST = dat/common/dat_dictionary.h \
 dist-hook: dapl.spec 
 	cp dapl.spec $(distdir)
 	
-install-exec-hook:
-	if ! test -d $(DESTDIR)$(sysconfdir); then \
-		mkdir -p $(DESTDIR)$(sysconfdir); \
-	fi; \
-	if test -e $(DESTDIR)$(sysconfdir)/dat.conf; then \
-		sed -e '/ofa-v2-.* u2/d' < $(DESTDIR)$(sysconfdir)/dat.conf > /tmp/$$$$ofadapl; \
-		cp /tmp/$$$$ofadapl $(DESTDIR)$(sysconfdir)/dat.conf; \
-	fi; \
-	echo ofa-v2-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-ib0 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"ib0 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-ib1 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"ib1 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-mthca0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mthca0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-mthca0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mthca0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-ipath0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"ipath0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-ipath0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"ipath0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-ehca0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"ehca0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-iwarp u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth2 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-mlx4_0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-mlx4_0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-mthca0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-mthca0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-cma-roe-eth2 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth2 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-cma-roe-eth3 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth3 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-scm-roe-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-scm-roe-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; 
-
-uninstall-hook:
-	if test -e $(DESTDIR)$(sysconfdir)/dat.conf; then \
-		sed -e '/ofa-v2-.* u2/d' < $(DESTDIR)$(sysconfdir)/dat.conf > /tmp/$$$$ofadapl; \
-		cp /tmp/$$$$ofadapl $(DESTDIR)$(sysconfdir)/dat.conf; \
-	fi;
-
 SUBDIRS = . test/dtest test/dapltest
diff --git a/dapl.spec.in b/dapl.spec.in
index b779f9f..55b345e 100644
--- a/dapl.spec.in
+++ b/dapl.spec.in
@@ -85,46 +85,17 @@ rm -rf %{buildroot}
 make DESTDIR=%{buildroot} install
 # remove unpackaged files from the buildroot
 rm -f %{buildroot}%{_libdir}/*.la
-rm -f %{buildroot}%{_sysconfdir}/*.conf
 
 %clean
 rm -rf %{buildroot}
 
-%post 
-/sbin/ldconfig
-if [ -e %{_sysconfdir}/dat.conf ]; then
-    sed -e '/ofa-v2-.* u2/d' < %{_sysconfdir}/dat.conf > /tmp/$$ofadapl
-    mv /tmp/$$ofadapl %{_sysconfdir}/dat.conf
-fi
-echo ofa-v2-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-ib0 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"ib0 0" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-ib1 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"ib1 0" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-mthca0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mthca0 1" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-mthca0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mthca0 2" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-ipath0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"ipath0 1" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-ipath0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"ipath0 2" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-ehca0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"ehca0 1" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-iwarp u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth2 0" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-mlx4_0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-mlx4_0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-mthca0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 1" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-mthca0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 2" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-cma-roe-eth2 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth2 0" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-cma-roe-eth3 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth3 0" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-scm-roe-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> %{_sysconfdir}/dat.conf
-echo ofa-v2-scm-roe-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> %{_sysconfdir}/dat.conf
-
-%postun 
-/sbin/ldconfig
-if [ -e %{_sysconfdir}/dat.conf ]; then
-    sed -e '/ofa-v2-.* u2/d' < %{_sysconfdir}/dat.conf > /tmp/$$ofadapl
-    mv /tmp/$$ofadapl %{_sysconfdir}/dat.conf
-fi
+%post -p /sbin/ldconfig
+%postun -p /sbin/ldconfig
 
 %files
 %defattr(-,root,root,-)
 %{_libdir}/libda*.so.*
+%{_sysconfdir}/dat.conf
 %doc AUTHORS README COPYING ChangeLog LICENSE.txt LICENSE2.txt LICENSE3.txt
 
 %files devel
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
