From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Change mem_resources pointer to a u8
Date: Mon, 22 Aug 2016 18:09:14 -0500
Message-ID: <1471907354-82408-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

iwdev->mem_resources is incorrectly defined as an unsigned
long instead of u8. As a result, the offset into the dynamic
allocated structures in i40iw_initialize_hw_resources() is
incorrectly calculated and would lead to writing of memory
regions outside of the allocated buffer.

Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")

Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index b738acd..882f3ef 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -232,7 +232,7 @@ struct i40iw_device {
 	struct i40e_client *client;
 	struct i40iw_hw hw;
 	struct i40iw_cm_core cm_core;
-	unsigned long *mem_resources;
+	u8 *mem_resources;
 	unsigned long *allocated_qps;
 	unsigned long *allocated_cqs;
 	unsigned long *allocated_mrs;
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
