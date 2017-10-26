From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH] IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Thu, 26 Oct 2017 18:12:31 +0200
Message-ID: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Thu, 26 Oct 2017 17:54:15 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c636842c5be0..4a598c48ea1c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1691,8 +1691,8 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_att
 				mdev, qp, default_table + default_flow,
 				mailbox->buf + size);
 		if (ret < 0) {
-			mlx4_free_cmd_mailbox(mdev->dev, mailbox);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_mailbox;
 		}
 		size += ret;
 	}
@@ -1700,8 +1700,8 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_att
 		ret = parse_flow_attr(mdev->dev, qp->qp_num, ib_flow,
 				      mailbox->buf + size);
 		if (ret < 0) {
-			mlx4_free_cmd_mailbox(mdev->dev, mailbox);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_mailbox;
 		}
 		ib_flow += ((union ib_flow_spec *) ib_flow)->size;
 		size += ret;
@@ -1726,7 +1726,7 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_att
 		pr_err("Device managed flow steering is disabled. Fail to register network rule.\n");
 	else if (ret)
 		pr_err("Invalid argument. Fail to register network rule.\n");
-
+free_mailbox:
 	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
 	return ret;
 }
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
