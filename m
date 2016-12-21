From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 4/6] redhat/spec: fix up %post scriptlets
Date: Wed, 21 Dec 2016 17:08:38 -0500
Message-ID: <20161221220840.36268-5-jarod@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The split packaging spec is missing systemd restart bits for ibacm and
iwpmd, and has incorrect ldconfig calls. The base package has no libs in
it, that should have been on the libibverbs sub-package, and the other
lib sub-packages need one as well.

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 42d624b..1f51720 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -267,20 +267,45 @@ install -D -m0644 redhat/srp_daemon.service %{buildroot}%{_unitdir}/
 # Delete the package's init.d scripts
 rm -rf %{buildroot}/%{_initrddir}/
 
-%post -p /sbin/ldconfig
-%postun -p /sbin/ldconfig
+# libibverbs
+%post -n libibverbs -p /sbin/ldconfig
+%postun -n libibverbs -p /sbin/ldconfig
 
+# libibcm
+%post -n libibcm -p /sbin/ldconfig
+%postun -n libibcm -p /sbin/ldconfig
+
+# libibumad
+%post -n libibumad -p /sbin/ldconfig
+%postun -n libibumad -p /sbin/ldconfig
+
+# librdmacm
+%post -n librdmacm -p /sbin/ldconfig
+%postun -n librdmacm -p /sbin/ldconfig
+
+# ibacm
 %post -n ibacm
 %systemd_post ibacm.service
-
 %preun -n ibacm
 %systemd_preun ibacm.service
-
 %postun -n ibacm
 %systemd_postun_with_restart ibacm.service
 
-%post -n libibcm -p /sbin/ldconfig
-%postun -n libibcm -p /sbin/ldconfig
+# srp_daemon
+%post -n srp_daemon
+%systemd_post srp_daemon.service
+%preun -n srp_daemon
+%systemd_preun srp_daemon.service
+%postun -n srp_daemon
+%systemd_postun_with_restart srp_daemon.service
+
+# iwpmd
+%post -n iwpmd
+%systemd_post iwpmd.service
+%preun -n iwpmd
+%systemd_preun iwpmd.service
+%postun -n iwpmd
+%systemd_postun_with_restart iwpmd.service
 
 %files
 %dir %{_sysconfdir}/rdma
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
