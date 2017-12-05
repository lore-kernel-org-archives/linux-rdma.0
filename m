From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/mlx4: Potential buffer overflow in _mlx4_set_path()
Date: Tue, 5 Dec 2017 17:39:23 +0300
Message-ID: <20171205143923.26dqc3ekhbmtmsgt@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Smatch complains about this code:

    drivers/infiniband/hw/mlx4/qp.c:1827 _mlx4_set_path()
    error: buffer overflow 'dev->dev->caps.gid_table_len' 3 <= 255

The mlx4_ib_gid_index_to_real_index() does check that "port" is within
bounds, but we don't check the return value for errors.  It seems simple
enough to add a check for that.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
Static analysis.  Not tested.

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 013049bcdb53..817257f105aa 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1824,6 +1824,8 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev,
 			mlx4_ib_gid_index_to_real_index(dev, port,
 							grh->sgid_index);
 
+		if (real_sgid_index < 0)
+			return real_sgid_index;
 		if (real_sgid_index >= dev->dev->caps.gid_table_len[port]) {
 			pr_err("sgid_index (%u) too large. max is %d\n",
 			       real_sgid_index, dev->dev->caps.gid_table_len[port] - 1);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
