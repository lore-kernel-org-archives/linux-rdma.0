From: Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>
Subject: [PATCH 1/1] i40iw: do not print unitialized variables in error message
Date: Sat, 25 Jun 2016 17:55:07 +0200
Message-ID: <20160625155507.23961-1-nicolas.iooss_linux@m4x.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

i40iw_create_cqp() printed the contents of variables maj_err and min_err
in an error message before they could be initialized (by calling
dev->cqp_ops->cqp_create).

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index c963cad92f5a..6e9081380a27 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -600,8 +600,7 @@ static enum i40iw_status_code i40iw_create_cqp(struct i40iw_device *iwdev)
 	cqp_init_info.scratch_array = cqp->scratch_array;
 	status = dev->cqp_ops->cqp_init(dev->cqp, &cqp_init_info);
 	if (status) {
-		i40iw_pr_err("cqp init status %d maj_err %d min_err %d\n",
-			     status, maj_err, min_err);
+		i40iw_pr_err("cqp init status %d\n", status);
 		goto exit;
 	}
 	status = dev->cqp_ops->cqp_create(dev->cqp, true, &maj_err, &min_err);
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
