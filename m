From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] compat-dapl-1.2: cma, scm: add new provider entries for
 Mellanox RDMA over Ethernet device for uDAPL v1.2
Date: Mon, 24 May 2010 10:23:47 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C713AA5C@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add options for netdev eth2/eth3 for cma and for device mlx4_0 port 1/2 for scm for uDAPL v1.2.

OpenIB-cma-roe-eth2 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth2 0" ""
OpenIB-cma-roe-eth3 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth3 0" ""
OpenIB-scm-roe-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 "mlx4_0 1" ""
OpenIB-scm-roe-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 "mlx4_0 2" ""

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


diff --git a/Makefile.am b/Makefile.am
index b353180..3dd9c3a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -407,7 +407,11 @@ install-exec-hook:
         echo OpenIB-ipath0-1 u1.2 nonthreadsafe default libdaplscm.so.2 dapl.1.2 '"ipath0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
         echo OpenIB-ipath0-2 u1.2 nonthreadsafe default libdaplscm.so.2 dapl.1.2 '"ipath0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
         echo OpenIB-ehca0-2 u1.2 nonthreadsafe default libdaplscm.so.2 dapl.1.2 '"ehca0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-        echo OpenIB-iwarp u1.2 nonthreadsafe default libdaplcma.so.1 dapl.1.2 '"eth2 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf;
+        echo OpenIB-iwarp u1.2 nonthreadsafe default libdaplcma.so.1 dapl.1.2 '"eth2 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
+        echo OpenIB-cma-roe-eth2 u1.2 nonthreadsafe default libdaplcma.so.1 dapl.1.2 '"eth2 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
+        echo OpenIB-cma-roe-eth3 u1.2 nonthreadsafe default libdaplcma.so.1 dapl.1.2 '"eth3 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
+        echo OpenIB-scm-roe-mlx4_0-1 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 '"mlx4_0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
+        echo OpenIB-scm-roe-mlx4_0-2 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 '"mlx4_0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf;
 
 uninstall-hook:
 	if test -e $(DESTDIR)$(sysconfdir)/dat.conf; then \
diff --git a/dapl.spec.in b/dapl.spec.in
index 4b9234d..3cb8d09 100644
--- a/dapl.spec.in
+++ b/dapl.spec.in
@@ -106,6 +106,10 @@ echo OpenIB-ipath0-1 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 '"ipath
 echo OpenIB-ipath0-2 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 '"ipath0 2" ""' >> %{_sysconfdir}/dat.conf
 echo OpenIB-ehca0-1 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 '"ehca0 1" ""' >> %{_sysconfdir}/dat.conf
 echo OpenIB-iwarp u1.2 nonthreadsafe default libdaplcma.so.1 dapl.1.2 '"eth2 0" ""'  >> %{_sysconfdir}/dat.conf
+echo OpenIB-cma-roe-eth2 u1.2 nonthreadsafe default libdaplcma.so.1 dapl.1.2 '"eth2 0" ""'  >> %{_sysconfdir}/dat.conf
+echo OpenIB-cma-roe-eth3 u1.2 nonthreadsafe default libdaplcma.so.1 dapl.1.2 '"eth3 0" ""'  >> %{_sysconfdir}/dat.conf
+echo OpenIB-scm-roe-mlx4_0-1 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 '"mlx4_0 1" ""' >> %{_sysconfdir}/dat.conf
+echo OpenIB-scm-roe-mlx4_0-2 u1.2 nonthreadsafe default libdaplscm.so.1 dapl.1.2 '"mlx4_0 2" ""' >> %{_sysconfdir}/dat.conf
 
 %postun
 /sbin/ldconfig


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
