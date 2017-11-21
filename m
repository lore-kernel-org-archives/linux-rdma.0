From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 5/7] i40iw: Reinitialize add_sd_cnt
Date: Tue, 21 Nov 2017 12:45:00 -0600
Message-ID: <20171121184502.14056-6-henry.orosco@intel.com>
References: <20171121184502.14056-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121184502.14056-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

add_sd_cnt in info structure passed to i40iw_create_hmc_obj_type
must be 0 and since it is modified during the call, it must be
reset in the loop.

Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 1f9d9c7..3aecf4c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -483,6 +483,7 @@ static enum i40iw_status_code i40iw_create_hmc_objs(struct i40iw_device *iwdev,
 	for (i = 0; i < IW_HMC_OBJ_TYPE_NUM; i++) {
 		info.rsrc_type = iw_hmc_obj_types[i];
 		info.count = dev->hmc_info->hmc_obj[info.rsrc_type].cnt;
+		info.add_sd_cnt = 0;
 		status = i40iw_create_hmc_obj_type(dev, &info);
 		if (status) {
 			i40iw_pr_err("create obj type %d status = %d\n",
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
