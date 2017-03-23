From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 6/6] Bump version and update debian
Date: Thu, 23 Mar 2017 15:55:29 +0200
Message-ID: <1490277329-8738-7-git-send-email-yishaih@mellanox.com>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490277329-8738-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt                   | 2 +-
 debian/changelog                 | 5 ++++-
 debian/ibverbs-providers.symbols | 2 ++
 debian/libibverbs1.symbols       | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index da80344..24542a7 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -44,7 +44,7 @@ endif()
 set(PACKAGE_NAME "RDMA")
 
 # See Documentation/versioning.md
-set(PACKAGE_VERSION "13")
+set(PACKAGE_VERSION "14")
 
 #-------------------------
 # Basic standard paths
diff --git a/debian/changelog b/debian/changelog
index 3defc05..f47fcec 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,5 +1,8 @@
-rdma-core (13-1) unstable; urgency=low
+rdma-core (14-1) unstable; urgency=low
+
+  * Bump version.
 
+rdma-core (13-1) unstable; urgency=low
   * New version.
   * Adding debian/copyright.
   * Close ITP (Closes: #848971).
diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index b114deb..9c10852 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -1,4 +1,6 @@
 libmlx5.so.1 ibverbs-providers #MINVER#
  MLX5_1.0@MLX5_1.0 13-1
+ MLX5_1.14@MLX5_1.14 14-1
  mlx5dv_init_obj@MLX5_1.0 13-1
  mlx5dv_query_device@MLX5_1.0 13-1
+ mlx5dv_create_cq@MLX5_1.14 14-1
diff --git a/debian/libibverbs1.symbols b/debian/libibverbs1.symbols
index d70afd0..b96ef46 100644
--- a/debian/libibverbs1.symbols
+++ b/debian/libibverbs1.symbols
@@ -1,7 +1,7 @@
 libibverbs.so.1 libibverbs1 #MINVER#
  IBVERBS_1.0@IBVERBS_1.0 1.1.6
  IBVERBS_1.1@IBVERBS_1.1 1.1.6
- (symver)IBVERBS_PRIVATE_13 13
+ (symver)IBVERBS_PRIVATE_14 14
  ibv_ack_async_event@IBVERBS_1.0 1.1.6
  ibv_ack_async_event@IBVERBS_1.1 1.1.6
  ibv_ack_cq_events@IBVERBS_1.0 1.1.6
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
