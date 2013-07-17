From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] IB/mlx5: use module_pci_driver to simplify the code
Date: Wed, 17 Jul 2013 09:56:41 +0800
Message-ID: <CAPgLHd917tqPE=CBP0OezF=v+M61GY=cUX-GTUbUKYhoeoj3hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Use the module_pci_driver() macro to make the code simpler
by eliminating module_init and module_exit calls.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8000fff..0cdc185 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1490,15 +1490,4 @@ static struct pci_driver mlx5_ib_driver = {
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
