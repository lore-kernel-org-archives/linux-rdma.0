From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/iser: Handle lack of memory management
 extensions correctly
Date: Fri, 30 Jun 2017 13:14:34 -0700
Message-ID: <20170630201433.5213.30745.stgit@scvm10.sc.intel.com>
References: <20170630201236.5213.72919.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170630201236.5213.72919.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

max_fast_reg_page_list_len is only valid when the
memory management extensions are signaled by the underlying
driver.

Fix by adjusting iser_calc_scsi_params() to use
ISCSI_ISER_MAX_SG_TABLESIZE when the extensions are not indicated.

Fixes: Commit df749cdc45d9 ("IB/iser: Support up to 8MB data transfer in a single command")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index c538a38..26a004e 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -708,8 +708,14 @@ static void iser_connect_error(struct rdma_cm_id *cma_id)
 	unsigned short sg_tablesize, sup_sg_tablesize;
 
 	sg_tablesize = DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
-	sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
-				 device->ib_device->attrs.max_fast_reg_page_list_len);
+	if (device->ib_device->attrs.device_cap_flags &
+			IB_DEVICE_MEM_MGT_EXTENSIONS)
+		sup_sg_tablesize =
+			min_t(
+			 uint, ISCSI_ISER_MAX_SG_TABLESIZE,
+			 device->ib_device->attrs.max_fast_reg_page_list_len);
+	else
+		sup_sg_tablesize = ISCSI_ISER_MAX_SG_TABLESIZE;
 
 	iser_conn->scsi_sg_tablesize = min(sg_tablesize, sup_sg_tablesize);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
