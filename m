From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 20/21] Move rxe_cfg to the rdma-core package
Date: Mon, 24 Jul 2017 14:00:28 -0600
Message-ID: <1500926429-31822-21-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rx_cfg is used to setup the kernel rxe device, it belongs with the
rest of the kernel support items.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/ibverbs-providers.install | 4 ----
 debian/rdma-core.install         | 4 ++++
 redhat/rdma-core.spec            | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
index 93144527be04ef..73088d82f6e0e8 100644
--- a/debian/ibverbs-providers.install
+++ b/debian/ibverbs-providers.install
@@ -1,8 +1,4 @@
 etc/libibverbs.d/
-usr/bin/rxe_cfg
 usr/lib/*/libibverbs/lib*-rdmav2.so
 usr/lib/*/libmlx4.so.*
 usr/lib/*/libmlx5.so.*
-usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
-usr/share/man/man7/rxe.7
-usr/share/man/man8/rxe_cfg.8
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 4bab264208b691..3d8cddab9297a5 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -1,8 +1,12 @@
 etc/modprobe.d/truescale.conf
 lib/systemd/system/rdma-ndd.service
 lib/udev/rules.d/60-rdma-ndd.rules
+usr/bin/rxe_cfg
 usr/lib/truescale-serdes.cmds
 usr/sbin/rdma-ndd
 usr/share/doc/rdma-core/MAINTAINERS
 usr/share/doc/rdma-core/README.md
+usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
+usr/share/man/man7/rxe.7
 usr/share/man/man8/rdma-ndd.8
+usr/share/man/man8/rxe_cfg.8
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index fb6d7ffc4f29fa..40797f268e3d18 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -319,6 +319,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 %dir %{_sysconfdir}/rdma
 %dir %{_docdir}/%{name}-%{version}
 %doc %{_docdir}/%{name}-%{version}/README.md
+%doc %{_docdir}/%{name}-%{version}/rxe.md
 %config(noreplace) %{_sysconfdir}/rdma/mlx4.conf
 %config(noreplace) %{_sysconfdir}/rdma/rdma.conf
 %config(noreplace) %{_sysconfdir}/rdma/sriov-vfs
@@ -339,9 +340,12 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{_libexecdir}/rdma-fixup-mtrr.awk
 %{_libexecdir}/mlx4-setup.sh
 %{_libexecdir}/truescale-serdes.cmds
+%{_bindir}/rxe_cfg
 %{_sbindir}/rdma-ndd
 %{_unitdir}/rdma-ndd.service
+%{_mandir}/man7/rxe*
 %{_mandir}/man8/rdma-ndd.*
+%{_mandir}/man8/rxe*
 %license COPYING.*
 
 %files devel
@@ -370,10 +374,6 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{_libdir}/libmlx4.so.*
 %config(noreplace) %{_sysconfdir}/libibverbs.d/*.driver
 %doc %{_docdir}/%{name}-%{version}/libibverbs.md
-%doc %{_docdir}/%{name}-%{version}/rxe.md
-%{_bindir}/rxe_cfg
-%{_mandir}/man7/rxe*
-%{_mandir}/man8/rxe*
 
 %files -n libibverbs-utils
 %{_bindir}/ibv_*
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
