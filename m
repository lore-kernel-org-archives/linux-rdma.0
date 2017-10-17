From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] RDMA/i40iw: Convert timers to use timer_setup() (part 2)
Date: Tue, 17 Oct 2017 11:37:54 -0700
Message-ID: <20171017183754.GA108519@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

This includes the remaining timers missed in the earlier i40iw patch.

Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 7 +++----
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 50c43766defd..789d925df227 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1188,7 +1188,7 @@ static void i40iw_handle_close_entry(struct i40iw_cm_node *cm_node, u32 rem_node
  * i40iw_cm_timer_tick - system's timer expired callback
  * @pass: Pointing to cm_core
  */
-static void i40iw_cm_timer_tick(unsigned long pass)
+static void i40iw_cm_timer_tick(struct timer_list *t)
 {
 	unsigned long nexttimeout = jiffies + I40IW_LONG_TIME;
 	struct i40iw_cm_node *cm_node;
@@ -1196,7 +1196,7 @@ static void i40iw_cm_timer_tick(unsigned long pass)
 	struct list_head *list_core_temp;
 	struct i40iw_sc_vsi *vsi;
 	struct list_head *list_node;
-	struct i40iw_cm_core *cm_core = (struct i40iw_cm_core *)pass;
+	struct i40iw_cm_core *cm_core = from_timer(cm_core, t, tcp_timer);
 	u32 settimer = 0;
 	unsigned long timetosend;
 	struct i40iw_sc_dev *dev;
@@ -3202,8 +3202,7 @@ void i40iw_setup_cm_core(struct i40iw_device *iwdev)
 	INIT_LIST_HEAD(&cm_core->connected_nodes);
 	INIT_LIST_HEAD(&cm_core->listen_nodes);
 
-	setup_timer(&cm_core->tcp_timer, i40iw_cm_timer_tick,
-		    (unsigned long)cm_core);
+	timer_setup(&cm_core->tcp_timer, i40iw_cm_timer_tick, 0);
 
 	spin_lock_init(&cm_core->ht_lock);
 	spin_lock_init(&cm_core->listen_list_lock);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index f6c76595e834..2ed31004b19c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -870,9 +870,9 @@ void i40iw_terminate_done(struct i40iw_sc_qp *qp, int timeout_occurred)
  * i40iw_terminate_imeout - timeout happened
  * @context: points to iwarp qp
  */
-static void i40iw_terminate_timeout(unsigned long context)
+static void i40iw_terminate_timeout(struct timer_list *t)
 {
-	struct i40iw_qp *iwqp = (struct i40iw_qp *)context;
+	struct i40iw_qp *iwqp = from_timer(iwqp, t, terminate_timer);
 	struct i40iw_sc_qp *qp = (struct i40iw_sc_qp *)&iwqp->sc_qp;
 
 	i40iw_terminate_done(qp, 1);
@@ -889,8 +889,7 @@ void i40iw_terminate_start_timer(struct i40iw_sc_qp *qp)
 
 	iwqp = (struct i40iw_qp *)qp->back_qp;
 	i40iw_add_ref(&iwqp->ibqp);
-	setup_timer(&iwqp->terminate_timer, i40iw_terminate_timeout,
-		    (unsigned long)iwqp);
+	timer_setup(&iwqp->terminate_timer, i40iw_terminate_timeout, 0);
 	iwqp->terminate_timer.expires = jiffies + HZ;
 	add_timer(&iwqp->terminate_timer);
 }
-- 
2.7.4


-- 
Kees Cook
Pixel Security
