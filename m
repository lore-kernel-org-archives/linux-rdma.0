From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/mlx5: fix error return code in init_one()
Date: Tue, 30 Jul 2013 07:54:26 +0800
Message-ID: <CAPgLHd9-0jHB1wCoc=qw0pRdEYGTMBXTqF2UrAvu2e3Zx+FveA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8000fff..0b3e29d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1426,7 +1426,8 @@ static int init_one(struct pci_dev *pdev,
 	if (err)
 		goto err_eqs;
 
-	if (ib_register_device(&dev->ib_dev, NULL))
+	err = ib_register_device(&dev->ib_dev, NULL);
+	if (err)
 		goto err_rsrc;
 
 	err = create_umr_res(dev);
@@ -1434,8 +1435,9 @@ static int init_one(struct pci_dev *pdev,
 		goto err_dev;
 
 	for (i = 0; i < ARRAY_SIZE(mlx5_class_attributes); i++) {
-		if (device_create_file(&dev->ib_dev.dev,
-				       mlx5_class_attributes[i]))
+		err = device_create_file(&dev->ib_dev.dev,
+					 mlx5_class_attributes[i]);
+		if (err)
 			goto err_umrc;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
