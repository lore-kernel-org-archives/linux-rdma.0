From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 3/3] debian: Add new mlx5dv_set_context_attr symbol
Date: Mon, 11 Sep 2017 13:28:21 +0200
Message-ID: <20170911112821.2094-3-benjamin.drung@profitbricks.com>
References: <20170911112821.2094-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911112821.2094-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/ibverbs-providers.symbols | 1 +
 1 file changed, 1 insertion(+)

diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index b03c33a2..1e51aa86 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -9,3 +9,4 @@ libmlx5.so.1 ibverbs-providers #MINVER#
  mlx5dv_init_obj@MLX5_1.2 15
  mlx5dv_query_device@MLX5_1.0 13
  mlx5dv_create_cq@MLX5_1.1 14
+ mlx5dv_set_context_attr@MLX5_1.2 15
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
