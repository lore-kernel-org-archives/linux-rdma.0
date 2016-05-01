From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] i40iw: constify i40iw_vf_cqp_ops structure
Date: Sun,  1 May 2016 14:22:21 +0200
Message-ID: <1462105341-6299-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: kernel-janitors@vger.kernel.org, Chien Tin Tung <chien.tin.tung@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The i40iw_vf_cqp_ops structure is never modified, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/hw/i40iw/i40iw_type.h |    2 +-
 drivers/infiniband/hw/i40iw/i40iw_vf.c   |    2 +-
 drivers/infiniband/hw/i40iw/i40iw_vf.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index edb3a8c..7f935ec 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -479,7 +479,7 @@ struct i40iw_sc_dev {
 	struct i40iw_virt_mem ieq_mem;
 	struct i40iw_puda_rsrc *ieq;
 
-	struct i40iw_vf_cqp_ops *iw_vf_cqp_ops;
+	const struct i40iw_vf_cqp_ops *iw_vf_cqp_ops;
 
 	struct i40iw_hmc_fpm_misc hmc_fpm_misc;
 	u16 qs_handle;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_vf.c b/drivers/infiniband/hw/i40iw/i40iw_vf.c
index cb0f183..e33d481 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_vf.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_vf.c
@@ -80,6 +80,6 @@ enum i40iw_status_code i40iw_manage_vf_pble_bp(struct i40iw_sc_cqp *cqp,
 	return 0;
 }
 
-struct i40iw_vf_cqp_ops iw_vf_cqp_ops = {
+const struct i40iw_vf_cqp_ops iw_vf_cqp_ops = {
 	i40iw_manage_vf_pble_bp
 };
diff --git a/drivers/infiniband/hw/i40iw/i40iw_vf.h b/drivers/infiniband/hw/i40iw/i40iw_vf.h
index f649f3a..4359559 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_vf.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_vf.h
@@ -57,6 +57,6 @@ enum i40iw_status_code i40iw_manage_vf_pble_bp(struct i40iw_sc_cqp *cqp,
 					       u64 scratch,
 					       bool post_sq);
 
-extern struct i40iw_vf_cqp_ops iw_vf_cqp_ops;
+extern const struct i40iw_vf_cqp_ops iw_vf_cqp_ops;
 
 #endif
