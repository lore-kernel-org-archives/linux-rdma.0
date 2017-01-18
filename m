From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] IB/qib: Remove empty function
Date: Wed, 18 Jan 2017 07:57:58 +0200
Message-ID: <20170118055758.27237-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit f06267104dd9 ("RDMA: Update workqueue usage") removed
content of qib_qsfp_deinit(...) and left it empty.

This patch deletes all leftovers of that function.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |  1 -
 drivers/infiniband/hw/qib/qib_qsfp.c    | 10 ----------
 drivers/infiniband/hw/qib/qib_qsfp.h    |  1 -
 3 files changed, 12 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index c4a36160..9cc97bd 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2893,7 +2893,6 @@ static void qib_setup_7322_cleanup(struct qib_devdata *dd)
 			dd->cspec->gpio_mask &= ~mask;
 			qib_write_kreg(dd, kr_gpio_mask, dd->cspec->gpio_mask);
 			spin_unlock_irqrestore(&dd->cspec->gpio_lock, flags);
-			qib_qsfp_deinit(&dd->pport[i].cpspec->qsfp_data);
 		}
 	}
 }
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.c b/drivers/infiniband/hw/qib/qib_qsfp.c
index 4c7c3c8..295d40a 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.c
+++ b/drivers/infiniband/hw/qib/qib_qsfp.c
@@ -485,16 +485,6 @@ void qib_qsfp_init(struct qib_qsfp_data *qd,
 	dd->f_gpio_mod(dd, mask, mask, mask);
 }
 
-void qib_qsfp_deinit(struct qib_qsfp_data *qd)
-{
-	/*
-	 * There is nothing to do here for now.  our work is scheduled
-	 * with queue_work(), and flush_workqueue() from remove_one
-	 * will block until all work setup with queue_work()
-	 * completes.
-	 */
-}
-
 int qib_qsfp_dump(struct qib_pportdata *ppd, char *buf, int len)
 {
 	struct qib_qsfp_cache cd;
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.h b/drivers/infiniband/hw/qib/qib_qsfp.h
index 91908f5..ad8dbd6 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.h
+++ b/drivers/infiniband/hw/qib/qib_qsfp.h
@@ -186,4 +186,3 @@ extern int qib_refresh_qsfp_cache(struct qib_pportdata *ppd,
 extern int qib_qsfp_mod_present(struct qib_pportdata *ppd);
 extern void qib_qsfp_init(struct qib_qsfp_data *qd,
 			  void (*fevent)(struct work_struct *));
-extern void qib_qsfp_deinit(struct qib_qsfp_data *qd);
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
