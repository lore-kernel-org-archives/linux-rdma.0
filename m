From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] RDMA/i40iw: Convert timers to use timer_setup()
Date: Wed, 4 Oct 2017 17:45:41 -0700
Message-ID: <20171005004541.GA22645@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  1 +
 drivers/infiniband/hw/i40iw/i40iw_type.h  |  1 +
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 10 +++++-----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index d1f5345f04f0..2d076cf946e0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -4873,6 +4873,7 @@ enum i40iw_status_code i40iw_vsi_stats_init(struct i40iw_sc_vsi *vsi, struct i40
 
 	vsi->pestat = info->pestat;
 	vsi->pestat->hw = vsi->dev->hw;
+	vsi->pestat->vsi = vsi;
 
 	if (info->stats_initialize) {
 		i40iw_hw_stats_init(vsi->pestat, fcn_id, true);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index 63118f6d5ab4..7798e8e2f9bd 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -250,6 +250,7 @@ struct i40iw_vsi_pestat {
 	struct i40iw_dev_hw_stats last_read_hw_stats;
 	struct i40iw_dev_hw_stats_offsets hw_stats_offsets;
 	struct timer_list stats_timer;
+	struct i40iw_sc_vsi *vsi;
 	spinlock_t lock; /* rdma stats lock */
 };
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index e52dbbb4165e..f6c76595e834 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -1445,11 +1445,12 @@ enum i40iw_status_code i40iw_puda_get_tcpip_info(struct i40iw_puda_completion_in
  * i40iw_hw_stats_timeout - Stats timer-handler which updates all HW stats
  * @vsi: pointer to the vsi structure
  */
-static void i40iw_hw_stats_timeout(unsigned long vsi)
+static void i40iw_hw_stats_timeout(struct timer_list *t)
 {
-	struct i40iw_sc_vsi *sc_vsi =  (struct i40iw_sc_vsi *)vsi;
+	struct i40iw_vsi_pestat *pf_devstat = from_timer(pf_devstat, t,
+						       stats_timer);
+	struct i40iw_sc_vsi *sc_vsi = pf_devstat->vsi;
 	struct i40iw_sc_dev *pf_dev = sc_vsi->dev;
-	struct i40iw_vsi_pestat *pf_devstat = sc_vsi->pestat;
 	struct i40iw_vsi_pestat *vf_devstat = NULL;
 	u16 iw_vf_idx;
 	unsigned long flags;
@@ -1480,8 +1481,7 @@ void i40iw_hw_stats_start_timer(struct i40iw_sc_vsi *vsi)
 {
 	struct i40iw_vsi_pestat *devstat = vsi->pestat;
 
-	setup_timer(&devstat->stats_timer, i40iw_hw_stats_timeout,
-		    (unsigned long)vsi);
+	timer_setup(&devstat->stats_timer, i40iw_hw_stats_timeout, 0);
 	mod_timer(&devstat->stats_timer,
 		  jiffies + msecs_to_jiffies(STATS_TIMER_DELAY));
 }
-- 
2.7.4


-- 
Kees Cook
Pixel Security
