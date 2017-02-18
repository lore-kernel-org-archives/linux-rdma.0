From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 07/29] IB/mlx4: Split a condition check in
 handle_slaves_guid_change()
Date: Sat, 18 Feb 2017 21:55:08 +0100
Message-ID: <951c0746-b88e-8ee7-78e8-5be2a53a2e43@users.sourceforge.net>
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
Date: Fri, 17 Feb 2017 21:41:25 +0100

The kfree() function was called in up to two cases by the
handle_slaves_guid_change() function during error handling even if
the passed variable contained a null pointer.

* Split a condition check for memory allocation failures.

* Adjust jump targets according to the Linux coding style convention.

* Delete an initialisation for these variables at the beginning
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index cf33efce69d2..75b6522b3a8f 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1128,17 +1128,20 @@ static void propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
 static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 				      u32 guid_tbl_blk_num, u32 change_bitmap)
 {
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad  = NULL;
+	struct ib_smp *in_mad;
+	struct ib_smp *out_mad;
 	u16 i;
 
 	if (!mlx4_is_mfunc(dev->dev) || !mlx4_is_master(dev->dev))
 		return;
 
 	in_mad  = kmalloc(sizeof *in_mad, GFP_KERNEL);
+	if (!in_mad)
+		return;
+
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
+	if (!out_mad)
+		goto free_in_mad;
 
 	guid_tbl_blk_num  *= 4;
 
@@ -1171,8 +1174,9 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 	}
 
 out:
-	kfree(in_mad);
 	kfree(out_mad);
+free_in_mad:
+	kfree(in_mad);
 }
 
 void handle_port_mgmt_change_event(struct work_struct *work)
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
