From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Use correct src address in memcpy to rdma stats counters
Date: Fri, 11 Nov 2016 10:55:41 -0600
Message-ID: <1478883341-22124-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

hw_stats is a pointer to i40_iw_dev_stats struct in i40iw_get_hw_stats().
Use hw_stats and not &hw_stats in the memcpy to copy the i40iw device stats
data into rdma_hw_stats counters.

Fixes: b40f4757daa1 ("IB/core: Make device counter infrastructure dynamic")

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index b71394b..02c8f9a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2498,7 +2498,7 @@ static int i40iw_get_hw_stats(struct ib_device *ibdev,
 			return -ENOSYS;
 	}
 
-	memcpy(&stats->value[0], &hw_stats, sizeof(*hw_stats));
+	memcpy(&stats->value[0], hw_stats, sizeof(*hw_stats));
 
 	return stats->num_counters;
 }
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
