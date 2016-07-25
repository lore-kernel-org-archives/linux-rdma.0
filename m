From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/28] IB/hfi1: Fix "suspicious rcu_dereference_check()
 usage" warnings
Date: Mon, 25 Jul 2016 13:39:14 -0700
Message-ID: <20160725203913.4800.54265.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This fixes the following warnings with PROVE_LOCKING and PROVE_RCU
enabled in the kernel:

case (1):
[ INFO: suspicious RCU usage. ]
drivers/infiniband/hw/hfi1/init.c:532
suspicious rcu_dereference_check() usage!

case (2):
[ INFO: suspicious RCU usage. ]
drivers/infiniband/hw/hfi1/hfi.h:1624
suspicious rcu_dereference_check() usage!

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h  |   13 +++++++++++--
 drivers/infiniband/hw/hfi1/init.c |   11 ++++++-----
 drivers/infiniband/hw/hfi1/mad.c  |    2 +-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 7df4cb2..d22876d 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1616,8 +1616,7 @@ static inline u16 hfi1_get_pkey(struct hfi1_ibport *ibp, unsigned index)
 }
 
 /*
- * Readers of cc_state must call get_cc_state() under rcu_read_lock().
- * Writers of cc_state must call get_cc_state() under cc_state_lock.
+ * Called by readers of cc_state only, must call under rcu_read_lock().
  */
 static inline struct cc_state *get_cc_state(struct hfi1_pportdata *ppd)
 {
@@ -1625,6 +1624,16 @@ static inline struct cc_state *get_cc_state(struct hfi1_pportdata *ppd)
 }
 
 /*
+ * Called by writers of cc_state only,  must call under cc_state_lock.
+ */
+static inline
+struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
+{
+	return rcu_dereference_protected(ppd->cc_state,
+					 lockdep_is_held(&ppd->cc_state_lock));
+}
+
+/*
  * values for dd->flags (_device_ related flags)
  */
 #define HFI1_INITTED           0x1    /* chip and driver up and initted */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index ec77c7e..44ec3a8 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -475,8 +475,9 @@ static enum hrtimer_restart cca_timer_fn(struct hrtimer *t)
 void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 			 struct hfi1_devdata *dd, u8 hw_pidx, u8 port)
 {
-	int i, size;
+	int i;
 	uint default_pkey_idx;
+	struct cc_state *cc_state;
 
 	ppd->dd = dd;
 	ppd->hw_pidx = hw_pidx;
@@ -527,9 +528,9 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 
 	spin_lock_init(&ppd->cc_state_lock);
 	spin_lock_init(&ppd->cc_log_lock);
-	size = sizeof(struct cc_state);
-	RCU_INIT_POINTER(ppd->cc_state, kzalloc(size, GFP_KERNEL));
-	if (!rcu_dereference(ppd->cc_state))
+	cc_state = kzalloc(sizeof(*cc_state), GFP_KERNEL);
+	RCU_INIT_POINTER(ppd->cc_state, cc_state);
+	if (!cc_state)
 		goto bail;
 	return;
 
@@ -1327,7 +1328,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 			hrtimer_cancel(&ppd->cca_timer[i].hrtimer);
 
 		spin_lock(&ppd->cc_state_lock);
-		cc_state = get_cc_state(ppd);
+		cc_state = get_cc_state_protected(ppd);
 		RCU_INIT_POINTER(ppd->cc_state, NULL);
 		spin_unlock(&ppd->cc_state_lock);
 
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 5590a4c..1263abe 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -3375,7 +3375,7 @@ static void apply_cc_state(struct hfi1_pportdata *ppd)
 	 */
 	spin_lock(&ppd->cc_state_lock);
 
-	old_cc_state = get_cc_state(ppd);
+	old_cc_state = get_cc_state_protected(ppd);
 	if (!old_cc_state) {
 		/* never active, or shutting down */
 		spin_unlock(&ppd->cc_state_lock);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
