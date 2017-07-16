From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] i40iw: Simplify code
Date: Sun, 16 Jul 2017 13:09:23 +0200
Message-ID: <20170716110923.14907-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, shiraz.saleem@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

Axe a few lines of code and re-use existing error handling path to avoid
code duplication.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/infiniband/hw/i40iw/i40iw_pble.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_pble.c b/drivers/infiniband/hw/i40iw/i40iw_pble.c
index c87ba1617087..540aab5e502d 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_pble.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_pble.c
@@ -269,10 +269,8 @@ static enum i40iw_status_code add_bp_pages(struct i40iw_sc_dev *dev,
 	status = i40iw_add_sd_table_entry(dev->hw, hmc_info,
 					  info->idx.sd_idx, I40IW_SD_TYPE_PAGED,
 					  I40IW_HMC_DIRECT_BP_SIZE);
-	if (status) {
-		i40iw_free_vmalloc_mem(dev->hw, chunk);
-		return status;
-	}
+	if (status)
+		goto error;
 	if (!dev->is_pf) {
 		status = i40iw_vchnl_vf_add_hmc_objs(dev, I40IW_HMC_IW_PBLE,
 						     fpm_to_idx(pble_rsrc,
@@ -280,8 +278,7 @@ static enum i40iw_status_code add_bp_pages(struct i40iw_sc_dev *dev,
 						     (info->pages << PBLE_512_SHIFT));
 		if (status) {
 			i40iw_pr_err("allocate PBLEs in the PF.  Error %i\n", status);
-			i40iw_free_vmalloc_mem(dev->hw, chunk);
-			return status;
+			goto error;
 		}
 	}
 	addr = chunk->vaddr;
-- 
2.11.0
