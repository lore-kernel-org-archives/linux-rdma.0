From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: cma, scm: add new provider entries for Mellanox
 RDMA over Ethernet device
Date: Wed, 19 May 2010 16:31:16 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C701360E@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add options for netdev eth2/eth3 for cma and for device mlx4_0 port 1/2 for scm.

ofa-v2-cma-roe-eth2 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth2 0" ""
ofa-v2-cma-roe-eth3 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth3 0" ""
ofa-v2-scm-roe-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 "mlx4_0 1" ""
ofa-v2-scm-roe-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 "mlx4_0 2" ""

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 
diff --git a/Makefile.am b/Makefile.am
index bf82853..bef95ec 100755
--- a/Makefile.am
+++ b/Makefile.am
@@ -562,7 +562,11 @@ install-exec-hook:
 	echo ofa-v2-mlx4_0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
 	echo ofa-v2-mlx4_0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
 	echo ofa-v2-mthca0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
-	echo ofa-v2-mthca0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf;
+	echo ofa-v2-mthca0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
+	echo ofa-v2-cma-roe-eth2 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth2 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
+	echo ofa-v2-cma-roe-eth3 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth3 0" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
+	echo ofa-v2-scm-roe-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; \
+	echo ofa-v2-scm-roe-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> $(DESTDIR)$(sysconfdir)/dat.conf; 
 
 uninstall-hook:
 	if test -e $(DESTDIR)$(sysconfdir)/dat.conf; then \
 
diff --git a/dapl.spec.in b/dapl.spec.in
index 0f2c380..45187db 100644
--- a/dapl.spec.in
+++ b/dapl.spec.in
@@ -110,6 +110,10 @@ echo ofa-v2-mlx4_0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mlx
 echo ofa-v2-mlx4_0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> %{_sysconfdir}/dat.conf
 echo ofa-v2-mthca0-1u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 1" ""' >> %{_sysconfdir}/dat.conf
 echo ofa-v2-mthca0-2u u2.0 nonthreadsafe default libdaploucm.so.2 dapl.2.0 '"mthca0 2" ""' >> %{_sysconfdir}/dat.conf
+echo ofa-v2-cma-roe-eth2 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth2 0" ""' >> %{_sysconfdir}/dat.conf
+echo ofa-v2-cma-roe-eth3 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 '"eth3 0" ""' >> %{_sysconfdir}/dat.conf
+echo ofa-v2-scm-roe-mlx4_0-1 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 1" ""' >> %{_sysconfdir}/dat.conf
+echo ofa-v2-scm-roe-mlx4_0-2 u2.0 nonthreadsafe default libdaploscm.so.2 dapl.2.0 '"mlx4_0 2" ""' >> %{_sysconfdir}/dat.conf
 
 %postun 
 /sbin/ldconfig
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
