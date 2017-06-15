From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/5] IB/rxe: Use __func__ to print function's name
Date: Thu, 15 Jun 2017 11:29:06 +0300
Message-ID: <20170615082907.5658-5-leon@kernel.org>
References: <20170615082907.5658-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615082907.5658-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Its better to use __func__ to print functions name instead of writing
the name in the print statement.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_task.c  | 4 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index d2a14a1bdc7f..ea3810b29273 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -78,7 +78,7 @@ void rxe_do_task(unsigned long data)
 
 	default:
 		spin_unlock_irqrestore(&task->state_lock, flags);
-		pr_warn("bad state = %d in rxe_do_task\n", task->state);
+		pr_warn("%s failed with bad state %d\n", __func__, task->state);
 		return;
 	}
 
@@ -105,7 +105,7 @@ void rxe_do_task(unsigned long data)
 			break;
 
 		default:
-			pr_warn("bad state = %d in rxe_do_task\n",
+			pr_warn("%s failed with bad state %d\n", __func__,
 				task->state);
 		}
 		spin_unlock_irqrestore(&task->state_lock, flags);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 92156025db73..a65a330b15b6 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1336,15 +1336,15 @@ int rxe_register_device(struct rxe_dev *rxe)
 
 	err = ib_register_device(dev, NULL);
 	if (err) {
-		pr_warn("rxe_register_device failed, err = %d\n", err);
+		pr_warn("%s failed with error %d\n", __func__, err);
 		goto err1;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(rxe_dev_attributes); ++i) {
 		err = device_create_file(&dev->dev, rxe_dev_attributes[i]);
 		if (err) {
-			pr_warn("device_create_file failed, i = %d, err = %d\n",
-				i, err);
+			pr_warn("%s failed with error %d for attr number %d\n",
+				__func__, err, i);
 			goto err2;
 		}
 	}
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
