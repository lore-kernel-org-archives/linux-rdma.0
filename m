From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Thu, 26 Jan 2017 17:56:22 +0200
Message-ID: <1485446182-5109-8-git-send-email-yishaih@mellanox.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485446182-5109-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Install direct verbs related files into
/usr/include/infiniband/mlx5 folder and allow
for possible users to explicitly include them
into their applications.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/provider.map                 | 13 +++++++++----
 providers/mlx5/include/CMakeLists.txt |  6 +++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/buildlib/provider.map b/buildlib/provider.map
index e985a6f..8c7875f 100644
--- a/buildlib/provider.map
+++ b/buildlib/provider.map
@@ -1,6 +1,11 @@
-/* The providers do not export any symbols at all. Instead they rely on
-   attribute(constructor) to cause their init function to run at dlopen
-   time. */
-{
+/* The providers usually do not export any symbols at all. Instead
+   they rely on attribute(constructor) to cause their init function to
+   run at dlopen time.
+   Providers that wish to export symbols should add them below according to
+   Documentation/versioning.md document. */
+MLX5_1.0 {
+	global:
+		mlx5dv_query_device;
+		mlx5dv_init_obj;
 	local: *;
 };
diff --git a/providers/mlx5/include/CMakeLists.txt b/providers/mlx5/include/CMakeLists.txt
index 11a2839..8e2dc4a 100644
--- a/providers/mlx5/include/CMakeLists.txt
+++ b/providers/mlx5/include/CMakeLists.txt
@@ -1 +1,5 @@
-# Empty CMakelists.txt to avoid compilation error
+publish_headers(infiniband/mlx5
+	dv.h
+	dv-wqe.h
+	dv-cqe.h
+)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
