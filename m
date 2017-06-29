From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 7/7] mlx4: Export mlx4 direct verbs interface
Date: Thu, 29 Jun 2017 14:47:08 +0300
Message-ID: <1498736828-17875-8-git-send-email-yishaih@mellanox.com>
References: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498736828-17875-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Install direct verbs header file into /usr/include/infiniband/
folder and allow possible users to explicitly include it
into their applications.
In addition, make the required packaging changes needed for both
RedHat and Debian users to link with libmlx4 directly.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/ibverbs-providers.install | 1 +
 debian/ibverbs-providers.symbols | 4 ++++
 debian/libibverbs-dev.install    | 4 ++++
 providers/mlx4/CMakeLists.txt    | 7 ++++++-
 providers/mlx4/libmlx4.map       | 7 +++++++
 redhat/rdma-core.spec            | 3 +++
 6 files changed, 25 insertions(+), 1 deletion(-)
 create mode 100644 providers/mlx4/libmlx4.map

diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
index 1d234ba..1d693fe 100644
--- a/debian/ibverbs-providers.install
+++ b/debian/ibverbs-providers.install
@@ -3,6 +3,7 @@ etc/modprobe.d/truescale.conf
 usr/bin/rxe_cfg
 usr/lib/*/libibverbs/lib*-rdmav2.so
 usr/lib/*/libmlx5.so.*
+usr/lib/*/libmlx4.so.*
 usr/lib/truescale-serdes.cmds
 usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
 usr/share/man/man7/rxe.7
diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index ea63da8..d64e3ef 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -4,3 +4,7 @@ libmlx5.so.1 ibverbs-providers #MINVER#
  mlx5dv_init_obj@MLX5_1.0 13
  mlx5dv_query_device@MLX5_1.0 13
  mlx5dv_create_cq@MLX5_1.1 14
+
+libmlx4.so.1 ibverbs-providers #MINVER#
+ MLX4_1.0@MLX4_1.0 15
+ mlx4dv_init_obj@MLX4_1.0 15
diff --git a/debian/libibverbs-dev.install b/debian/libibverbs-dev.install
index ed7a276..3773d00 100644
--- a/debian/libibverbs-dev.install
+++ b/debian/libibverbs-dev.install
@@ -1,14 +1,18 @@
 usr/include/infiniband/arch.h
 usr/include/infiniband/kern-abi.h
 usr/include/infiniband/mlx5dv.h
+usr/include/infiniband/mlx4dv.h
 usr/include/infiniband/opcode.h
 usr/include/infiniband/sa-kern-abi.h
 usr/include/infiniband/sa.h
 usr/include/infiniband/verbs.h
 usr/lib/*/libibverbs*.so
 usr/lib/*/libmlx5.so
+usr/lib/*/libmlx4.so
 usr/share/man/man3/ibv_*
 usr/share/man/man3/mbps_to_ibv_rate.3
 usr/share/man/man3/mlx5dv_*.3
+usr/share/man/man3/mlx4dv_*.3
 usr/share/man/man3/mult_to_ibv_rate.3
 usr/share/man/man7/mlx5dv.7
+usr/share/man/man7/mlx4dv.7
diff --git a/providers/mlx4/CMakeLists.txt b/providers/mlx4/CMakeLists.txt
index d64d817..f6739d2 100644
--- a/providers/mlx4/CMakeLists.txt
+++ b/providers/mlx4/CMakeLists.txt
@@ -1,4 +1,5 @@
-rdma_provider(mlx4
+rdma_shared_provider(mlx4 libmlx4.map
+  1 1.0.${PACKAGE_VERSION}
   buf.c
   cq.c
   dbrec.c
@@ -7,3 +8,7 @@ rdma_provider(mlx4
   srq.c
   verbs.c
 )
+
+publish_headers(infiniband
+  mlx4dv.h
+)
diff --git a/providers/mlx4/libmlx4.map b/providers/mlx4/libmlx4.map
new file mode 100644
index 0000000..0e53f83
--- /dev/null
+++ b/providers/mlx4/libmlx4.map
@@ -0,0 +1,7 @@
+/* Export symbols should be added below according to
+   Documentation/versioning.md document. */
+MLX4_1.0 {
+	global:
+		mlx4dv_init_obj;
+	local: *;
+};
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 1f5cd14..5cebc25 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -355,7 +355,9 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{_mandir}/man3/*_to_ibv_rate.*
 %{_mandir}/man7/rdma_cm.*
 %{_mandir}/man3/mlx5dv*
+%{_mandir}/man3/mlx4dv*
 %{_mandir}/man7/mlx5dv*
+%{_mandir}/man7/mlx4dv*
 
 %files -n libibverbs
 %dir %{_sysconfdir}/libibverbs.d
@@ -363,6 +365,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 %{_libdir}/libibverbs*.so.*
 %{_libdir}/libibverbs/*.so
 %{_libdir}/libmlx5.so*
+%{_libdir}/libmlx4.so*
 %config(noreplace) %{_sysconfdir}/libibverbs.d/*.driver
 %doc %{_docdir}/%{name}-%{version}/libibverbs.md
 %doc %{_docdir}/%{name}-%{version}/rxe.md
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
