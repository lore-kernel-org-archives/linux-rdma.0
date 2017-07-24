From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 21/21] Make /etc/modprobe.d/mlx4.conf common
Date: Mon, 24 Jul 2017 14:00:29 -0600
Message-ID: <1500926429-31822-22-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move it out of the redhat directory and into providers/mlx4, this follows
the existing pattern of truescale.conf.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/rdma-core.install                                   | 1 +
 providers/mlx4/CMakeLists.txt                              | 2 ++
 redhat/rdma.mlx4.user.modprobe => providers/mlx4/mlx4.conf | 0
 redhat/rdma-core.spec                                      | 1 -
 4 files changed, 3 insertions(+), 1 deletion(-)
 rename redhat/rdma.mlx4.user.modprobe => providers/mlx4/mlx4.conf (100%)

diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 3d8cddab9297a5..c19d766fc0f48e 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -1,3 +1,4 @@
+etc/modprobe.d/mlx4.conf
 etc/modprobe.d/truescale.conf
 lib/systemd/system/rdma-ndd.service
 lib/udev/rules.d/60-rdma-ndd.rules
diff --git a/providers/mlx4/CMakeLists.txt b/providers/mlx4/CMakeLists.txt
index f6739d2dd0a7a2..2cd668cbbe213e 100644
--- a/providers/mlx4/CMakeLists.txt
+++ b/providers/mlx4/CMakeLists.txt
@@ -12,3 +12,5 @@ rdma_shared_provider(mlx4 libmlx4.map
 publish_headers(infiniband
   mlx4dv.h
 )
+
+install(FILES "mlx4.conf" DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/modprobe.d/")
diff --git a/redhat/rdma.mlx4.user.modprobe b/providers/mlx4/mlx4.conf
similarity index 100%
rename from redhat/rdma.mlx4.user.modprobe
rename to providers/mlx4/mlx4.conf
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 40797f268e3d18..2565290e72c04e 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -257,7 +257,6 @@ install -D -m0755 redhat/rdma.ifup-ib %{buildroot}/%{_sysconfdir}/sysconfig/netw
 install -D -m0755 redhat/rdma.ifdown-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifdown-ib
 install -D -m0644 redhat/rdma.service %{buildroot}%{_unitdir}/rdma.service
 install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_sysconfdir}/udev/rules.d/70-persistent-ipoib.rules
-install -D -m0644 redhat/rdma.mlx4.user.modprobe %{buildroot}%{_sysconfdir}/modprobe.d/mlx4.conf
 install -D -m0755 redhat/rdma.modules-setup.sh %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
 install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules
 install -D -m0644 redhat/rdma.mlx4.sys.modprobe %{buildroot}%{sysmodprobedir}/libmlx4.conf
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
