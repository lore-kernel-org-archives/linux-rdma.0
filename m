From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 14/29] IB/mlx4: Delete an unnecessary variable in
 __mlx4_ib_query_gid()
Date: Sat, 18 Feb 2017 22:02:58 +0100
Message-ID: <cfca8f30-bb68-4ed8-3161-36d4808b06f1@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 18 Feb 2017 15:04:50 +0100

* Call the function "memset" directly in an if branch without using
  an intermediate variable.

* Delete the local variable "clear" which became unnecessary with
  this refactoring.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c0c299ffa0f6..89bbb61d62f5 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -777,7 +777,6 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	struct ib_smp *out_mad;
 	int err;
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
-	int clear = 0;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 
 	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
@@ -806,8 +805,8 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	if (mlx4_is_mfunc(dev->dev) && !netw_view) {
 		if (index) {
 			/* For any index > 0, return the null guid */
+			memset(gid->raw + 8, 0, 8);
 			err = 0;
-			clear = 1;
 			goto out;
 		}
 	}
@@ -824,8 +823,6 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	memcpy(gid->raw + 8, out_mad->data + (index % 8) * 8, 8);
 
 out:
-	if (clear)
-		memset(gid->raw + 8, 0, 8);
 	kfree(out_mad);
 free_in_mad:
 	kfree(in_mad);
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
