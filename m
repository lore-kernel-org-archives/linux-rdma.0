From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] i40iw: Fail open if there are no available MSI-X vectors
Date: Tue, 19 Sep 2017 09:19:09 -0500
Message-ID: <20170919141913.10172-2-shiraz.saleem@intel.com>
References: <20170919141913.10172-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170919141913.10172-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Check number of available MSI-X vectors for i40iw.
If there are no available vectors, fail the open.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index cc742c3..5965b59 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1400,6 +1400,11 @@ static enum i40iw_status_code i40iw_save_msix_info(struct i40iw_device *iwdev,
 	u32 i;
 	u32 size;
 
+	if (!ldev->msix_count) {
+		i40iw_pr_err("No MSI-X vectors\n");
+		return I40IW_ERR_CONFIG;
+	}
+
 	iwdev->msix_count = ldev->msix_count;
 
 	size = sizeof(struct i40iw_msix_vector) * iwdev->msix_count;
@@ -1550,7 +1555,7 @@ static enum i40iw_status_code i40iw_setup_init_state(struct i40iw_handler *hdl,
 
 	status = i40iw_save_msix_info(iwdev, ldev);
 	if (status)
-		goto exit;
+		return status;
 	iwdev->hw.dev_context = (void *)ldev->pcidev;
 	iwdev->hw.hw_addr = ldev->hw_addr;
 	status = i40iw_allocate_dma_mem(&iwdev->hw,
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
