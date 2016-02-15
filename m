From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/21] staging/rdma/hfi1: Fix comparison to NULL
Date: Sun, 14 Feb 2016 20:19:49 -0800
Message-ID: <20160215041946.351.63234.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Convert pointer comparisons to NULL to !pointer
to fix checkpatch check:
CHECK: Comparison to NULL could be written "!pointer"

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c    |    6 +++---
 drivers/staging/rdma/hfi1/debugfs.c |    2 +-
 drivers/staging/rdma/hfi1/driver.c  |    6 +++---
 drivers/staging/rdma/hfi1/init.c    |    4 ++--
 drivers/staging/rdma/hfi1/mad.c     |    8 ++++----
 drivers/staging/rdma/hfi1/pio.c     |    2 +-
 drivers/staging/rdma/hfi1/rc.c      |    2 +-
 drivers/staging/rdma/hfi1/sysfs.c   |    4 ++--
 drivers/staging/rdma/hfi1/verbs.c   |    4 ++--
 9 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index cf57865..ea0ffd4 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -12260,7 +12260,7 @@ u64 hfi1_gpio_mod(struct hfi1_devdata *dd, u32 target, u32 data, u32 dir,
 
 int hfi1_init_ctxt(struct send_context *sc)
 {
-	if (sc != NULL) {
+	if (sc) {
 		struct hfi1_devdata *dd = sc->dd;
 		u64 reg;
 		u8 set = (sc->type == SC_USER ?
@@ -12371,7 +12371,7 @@ static void clean_up_interrupts(struct hfi1_devdata *dd)
 		struct hfi1_msix_entry *me = dd->msix_entries;
 
 		for (i = 0; i < dd->num_msix_entries; i++, me++) {
-			if (me->arg == NULL) /* => no irq, no affinity */
+			if (!me->arg) /* => no irq, no affinity */
 				continue;
 			hfi1_put_irq_affinity(dd, &dd->msix_entries[i]);
 			free_irq(me->msix.vector, me->arg);
@@ -12534,7 +12534,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			continue;
 		}
 		/* no argument, no interrupt */
-		if (arg == NULL)
+		if (!arg)
 			continue;
 		/* make sure the name is terminated */
 		me->name[sizeof(me->name) - 1] = 0;
diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index f309c5f..fa3df1f 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -746,7 +746,7 @@ void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 					    ibd->hfi1_ibdev_dbg,
 					    ppd,
 					    &port_cntr_ops[i].ops,
-					    port_cntr_ops[i].ops.write == NULL ?
+					    !port_cntr_ops[i].ops.write ?
 					    S_IRUGO : S_IRUGO | S_IWUSR);
 		}
 }
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 6082935..0c8bd91 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -371,7 +371,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 		if (rhf_use_egr_bfr(packet->rhf))
 			ebuf = packet->ebuf;
 
-		if (ebuf == NULL)
+		if (!ebuf)
 			goto drop; /* this should never happen */
 
 		if (lnh == HFI1_LRH_BTH)
@@ -402,7 +402,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			lqpn = be32_to_cpu(bth[1]) & RVT_QPN_MASK;
 			rcu_read_lock();
 			qp = rvt_lookup_qpn(rdi, &ibp->rvp, lqpn);
-			if (qp == NULL) {
+			if (!qp) {
 				rcu_read_unlock();
 				goto drop;
 			}
@@ -637,7 +637,7 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 		rcu_read_lock();
 		qp = rvt_lookup_qpn(rdi, &ibp->rvp, qpn);
 
-		if (qp == NULL) {
+		if (!qp) {
 			rcu_read_unlock();
 			goto next;
 		}
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 3071fbc..aabdc3d 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -386,7 +386,7 @@ void set_link_ipg(struct hfi1_pportdata *ppd)
 
 	cc_state = get_cc_state(ppd);
 
-	if (cc_state == NULL)
+	if (!cc_state)
 		/*
 		 * This should _never_ happen - rcu_read_lock() is held,
 		 * and set_link_ipg() should not be called if cc_state
@@ -438,7 +438,7 @@ static enum hrtimer_restart cca_timer_fn(struct hrtimer *t)
 
 	cc_state = get_cc_state(ppd);
 
-	if (cc_state == NULL) {
+	if (!cc_state) {
 		rcu_read_unlock();
 		return HRTIMER_NORESTART;
 	}
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index a56d7dc..44e7fbd 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -3297,7 +3297,7 @@ static int __subn_get_opa_cong_setting(struct opa_smp *smp, u32 am,
 
 	cc_state = get_cc_state(ppd);
 
-	if (cc_state == NULL) {
+	if (!cc_state) {
 		rcu_read_unlock();
 		return reply((struct ib_mad_hdr *)smp);
 	}
@@ -3439,7 +3439,7 @@ static int __subn_get_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 
 	cc_state = get_cc_state(ppd);
 
-	if (cc_state == NULL) {
+	if (!cc_state) {
 		rcu_read_unlock();
 		return reply((struct ib_mad_hdr *)smp);
 	}
@@ -3505,14 +3505,14 @@ static int __subn_set_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 	}
 
 	new_cc_state = kzalloc(sizeof(*new_cc_state), GFP_KERNEL);
-	if (new_cc_state == NULL)
+	if (!new_cc_state)
 		goto getit;
 
 	spin_lock(&ppd->cc_state_lock);
 
 	old_cc_state = get_cc_state(ppd);
 
-	if (old_cc_state == NULL) {
+	if (!old_cc_state) {
 		spin_unlock(&ppd->cc_state_lock);
 		kfree(new_cc_state);
 		return reply((struct ib_mad_hdr *)smp);
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index 3817731..7907e4c 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -2002,7 +2002,7 @@ int init_credit_return(struct hfi1_devdata *dd)
 					bytes,
 					&dd->cr_base[i].pa,
 					GFP_KERNEL);
-		if (dd->cr_base[i].va == NULL) {
+		if (!dd->cr_base[i].va) {
 			set_dev_node(&dd->pcidev->dev, dd->node);
 			dd_dev_err(dd,
 				"Unable to allocate credit return DMA range for NUMA %d\n",
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 24f2b65..99584f7 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -2025,7 +2025,7 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 
 	cc_state = get_cc_state(ppd);
 
-	if (cc_state == NULL)
+	if (!cc_state)
 		return;
 
 	/*
diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/staging/rdma/hfi1/sysfs.c
index 1f3a747..3c34f77 100644
--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -83,7 +83,7 @@ static ssize_t read_cc_table_bin(struct file *filp, struct kobject *kobj,
 
 	rcu_read_lock();
 	cc_state = get_cc_state(ppd);
-	if (cc_state == NULL) {
+	if (!cc_state) {
 		rcu_read_unlock();
 		return -EINVAL;
 	}
@@ -130,7 +130,7 @@ static ssize_t read_cc_setting_bin(struct file *filp, struct kobject *kobj,
 
 	rcu_read_lock();
 	cc_state = get_cc_state(ppd);
-	if (cc_state == NULL) {
+	if (!cc_state) {
 		rcu_read_unlock();
 		return -EINVAL;
 	}
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 466055b..c412f1c 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -431,7 +431,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 		if (lnh != HFI1_LRH_GRH)
 			goto drop;
 		mcast = rvt_mcast_find(&ibp->rvp, &hdr->u.l.grh.dgid);
-		if (mcast == NULL)
+		if (!mcast)
 			goto drop;
 		list_for_each_entry_rcu(p, &mcast->qp_list, list) {
 			packet->qp = p->qp;
@@ -838,7 +838,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	if (cb)
 		iowait_pio_inc(&priv->s_iowait);
 	pbuf = sc_buffer_alloc(sc, plen, cb, qp);
-	if (unlikely(pbuf == NULL)) {
+	if (unlikely(!pbuf)) {
 		if (cb)
 			verbs_pio_complete(qp, 0);
 		if (ppd->host_link_state != HLS_UP_ACTIVE) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
