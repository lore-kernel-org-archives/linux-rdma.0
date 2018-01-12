From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 1/5] i40iw: Remove extra call to i40iw_est_sd()
Date: Thu, 11 Jan 2018 18:10:50 -0600
Message-ID: <20180112001054.15572-2-shiraz.saleem@intel.com>
References: <20180112001054.15572-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112001054.15572-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove redundant estimate SD function call.
sd_needed should already be updated at the end of
the do while resource reduction loop.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index caa9581..c91dcfd 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -3957,8 +3957,6 @@ enum i40iw_status_code i40iw_config_fpm_values(struct i40iw_sc_dev *dev, u32 qp_
 			pblewanted -= FPM_MULTIPLIER * 1000;
 	} while (sd_needed > hmc_fpm_misc->max_sds && loop_count < 2000);
 
-	sd_needed = i40iw_est_sd(dev, hmc_info);
-
 	i40iw_debug(dev, I40IW_DEBUG_HMC,
 		    "loop_cnt=%d, sd_needed=%lld, qpcnt = %d, cqcnt=%d, mrcnt=%d, pblecnt=%d\n",
 		    loop_count, sd_needed,
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
