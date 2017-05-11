From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Fix device initialization error path
Date: Wed, 10 May 2017 23:32:14 -0500
Message-ID: <20170511043214.51096-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some error paths in i40iw_initialize_dev are doing
additional and unnecessary work before exiting.
Correctly free resources allocated prior to error
and return with correct status code.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intelcom>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 2728af3..a3f18a2 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1319,13 +1319,13 @@ static enum i40iw_status_code i40iw_initialize_dev(struct i40iw_device *iwdev,
 	status = i40iw_obj_aligned_mem(iwdev, &mem, I40IW_QUERY_FPM_BUF_SIZE,
 				       I40IW_FPM_QUERY_BUF_ALIGNMENT_MASK);
 	if (status)
-		goto exit;
+		goto error;
 	info.fpm_query_buf_pa = mem.pa;
 	info.fpm_query_buf = mem.va;
 	status = i40iw_obj_aligned_mem(iwdev, &mem, I40IW_COMMIT_FPM_BUF_SIZE,
 				       I40IW_FPM_COMMIT_BUF_ALIGNMENT_MASK);
 	if (status)
-		goto exit;
+		goto error;
 	info.fpm_commit_buf_pa = mem.pa;
 	info.fpm_commit_buf = mem.va;
 	info.hmc_fn_id = ldev->fid;
@@ -1347,11 +1347,9 @@ static enum i40iw_status_code i40iw_initialize_dev(struct i40iw_device *iwdev,
 	info.exception_lan_queue = 1;
 	info.vchnl_send = i40iw_virtchnl_send;
 	status = i40iw_device_init(&iwdev->sc_dev, &info);
-exit:
-	if (status) {
-		kfree(iwdev->hmc_info_mem);
-		iwdev->hmc_info_mem = NULL;
-	}
+
+	if (status)
+		goto error;
 	memset(&vsi_info, 0, sizeof(vsi_info));
 	vsi_info.dev = &iwdev->sc_dev;
 	vsi_info.back_vsi = (void *)iwdev;
@@ -1362,11 +1360,19 @@ static enum i40iw_status_code i40iw_initialize_dev(struct i40iw_device *iwdev,
 		memset(&stats_info, 0, sizeof(stats_info));
 		stats_info.fcn_id = ldev->fid;
 		stats_info.pestat = kzalloc(sizeof(*stats_info.pestat), GFP_KERNEL);
+		if (!stats_info.pestat) {
+			status = I40IW_ERR_NO_MEMORY;
+			goto error;
+		}
 		stats_info.stats_initialize = true;
 		if (stats_info.pestat)
 			i40iw_vsi_stats_init(&iwdev->vsi, &stats_info);
 	}
 	return status;
+error:
+	kfree(iwdev->hmc_info_mem);
+	iwdev->hmc_info_mem = NULL;
+	return status;
 }
 
 /**
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
