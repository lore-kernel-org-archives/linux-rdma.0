From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Add request for reset on CQP timeout
Date: Wed, 30 Nov 2016 15:14:15 -0600
Message-ID: <20161130211415.15948-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When CQP times out, send a request to LAN driver for reset.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h       |  1 +
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index c795c61..ef188e6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -304,6 +304,7 @@ struct i40iw_device {
 	u32 mpa_version;
 	bool dcb;
 	bool closing;
+	bool reset;
 	u32 used_pds;
 	u32 used_cqs;
 	u32 used_mrs;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 641f00f..4a08ffb 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -396,7 +396,10 @@ static int i40iw_wait_event(struct i40iw_device *iwdev,
 		i40iw_pr_err("error cqp command 0x%x timed out ret = %d\n",
 			     info->cqp_cmd, timeout_ret);
 		err_code = -ETIME;
-		i40iw_request_reset(iwdev);
+		if (!iwdev->reset) {
+			iwdev->reset = true;
+			i40iw_request_reset(iwdev);
+		}
 		goto done;
 	}
 	cqp_error = cqp_request->compl_info.error;
@@ -426,6 +429,11 @@ enum i40iw_status_code i40iw_handle_cqp_op(struct i40iw_device *iwdev,
 	struct cqp_commands_info *info = &cqp_request->info;
 	int err_code = 0;
 
+	if (iwdev->reset) {
+		i40iw_free_cqp_request(&iwdev->cqp, cqp_request);
+		return I40IW_ERR_CQP_COMPL_ERROR;
+	}
+
 	status = i40iw_process_cqp_cmd(dev, info);
 	if (status) {
 		i40iw_pr_err("error cqp command 0x%x failed\n", info->cqp_cmd);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
