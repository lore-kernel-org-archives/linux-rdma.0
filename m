From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH] mlx4: Add copyright holder to man pages
Date: Fri, 14 Jul 2017 16:34:25 +0200
Message-ID: <20170714143425.2002-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Maor Gottlieb added the mlx4dv.7 and mlx4dv_init_obj.3 man pages, but
did not state the copyright owner of these files.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 providers/mlx4/man/mlx4dv.7          | 1 +
 providers/mlx4/man/mlx4dv_init_obj.3 | 1 +
 2 files changed, 2 insertions(+)

diff --git a/providers/mlx4/man/mlx4dv.7 b/providers/mlx4/man/mlx4dv.7
index 92ced995..e3e4cdce 100644
--- a/providers/mlx4/man/mlx4dv.7
+++ b/providers/mlx4/man/mlx4dv.7
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Copyright (c) 2017 Mellanox Technologies, Inc.
 .\" Licensed under the OpenIB.org (MIT) - See COPYING.md
 .\"
 .TH MLX4DV 7 2017-04-19 1.0.0
diff --git a/providers/mlx4/man/mlx4dv_init_obj.3 b/providers/mlx4/man/mlx4dv_init_obj.3
index 0d0a4a5d..7d10b933 100644
--- a/providers/mlx4/man/mlx4dv_init_obj.3
+++ b/providers/mlx4/man/mlx4dv_init_obj.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Copyright (c) 2017 Mellanox Technologies, Inc.
 .\" Licensed under the OpenIB.org (MIT) - See COPYING.md
 .\"
 .TH MLX4DV_INIT_OBJ 3 2017-02-02 1.0.0
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
