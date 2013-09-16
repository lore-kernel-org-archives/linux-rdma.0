From: Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/mlx5: use module_pci_driver()
Date: Mon, 16 Sep 2013 14:01:43 +0900
Message-ID: <000401ceb299$d66e0d00$834a2700$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-language: ko
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Eli Cohen' <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jingoo Han' <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use module_pci_driver() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3f831de..7303d21 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1493,15 +1493,4 @@ static struct pci_driver mlx5_ib_driver = {
 	.remove		= remove_one
 };
 
-static int __init mlx5_ib_init(void)
-{
-	return pci_register_driver(&mlx5_ib_driver);
-}
-
-static void __exit mlx5_ib_cleanup(void)
-{
-	pci_unregister_driver(&mlx5_ib_driver);
-}
-
-module_init(mlx5_ib_init);
-module_exit(mlx5_ib_cleanup);
+module_pci_driver(mlx5_ib_driver);
-- 
1.7.10.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
