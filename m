From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH] IB/hfi1: Fix incorrect mixing of ERR_PTR and NULL return
 values
Date: Fri, 03 Aug 2018 09:23:57 -0700
Message-ID: <20180803162354.21477.41513.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

commit b697d7d8c741f27b728a878fc55852b06d0f6f5e upstream.

The __get_txreq() function can return a pointer, ERR_PTR(-EBUSY),
or NULL.  All of the relevant call sites look for IS_ERR, so the
NULL return would lead to a NULL pointer exception.

Do not use the ERR_PTR mechanism for this function.

Update all call sites to handle the return value correctly.

Clean up error paths to reflect return value.

Adjusted patch for the 4.9.x branch.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Kamenee Arumugam <kamenee.arumugam@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/rc.c          |    2 +-
 drivers/infiniband/hw/hfi1/uc.c          |    4 ++--
 drivers/infiniband/hw/hfi1/ud.c          |    4 ++--
 drivers/infiniband/hw/hfi1/verbs_txreq.c |    4 ++--
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 613074e..e8e0fa5 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -397,7 +397,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 
 	lockdep_assert_held(&qp->s_lock);
 	ps->s_txreq = get_txreq(ps->dev, qp);
-	if (IS_ERR(ps->s_txreq))
+	if (!ps->s_txreq)
 		goto bail_no_tx;
 
 	ohdr = &ps->s_txreq->phdr.hdr.u.oth;
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 5e6d1ba..de21128 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -72,7 +72,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	int middle = 0;
 
 	ps->s_txreq = get_txreq(ps->dev, qp);
-	if (IS_ERR(ps->s_txreq))
+	if (!ps->s_txreq)
 		goto bail_no_tx;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 97ae24b..1a7ce1d 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -285,7 +285,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	u8 sc5;
 
 	ps->s_txreq = get_txreq(ps->dev, qp);
-	if (IS_ERR(ps->s_txreq))
+	if (!ps->s_txreq)
 		goto bail_no_tx;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_NEXT_SEND_OK)) {
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.c b/drivers/infiniband/hw/hfi1/verbs_txreq.c
index 094ab82..d8a5bad 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.c
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2016 Intel Corporation.
+ * Copyright(c) 2016 - 2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -94,7 +94,7 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 				struct rvt_qp *qp)
 	__must_hold(&qp->s_lock)
 {
-	struct verbs_txreq *tx = ERR_PTR(-EBUSY);
+	struct verbs_txreq *tx = NULL;
 
 	write_seqlock(&dev->iowait_lock);
 	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.h b/drivers/infiniband/hw/hfi1/verbs_txreq.h
index 5660897..31ded57 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.h
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2016 Intel Corporation.
+ * Copyright(c) 2016 - 2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -82,7 +82,7 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 	if (unlikely(!tx)) {
 		/* call slow path to get the lock */
 		tx = __get_txreq(dev, qp);
-		if (IS_ERR(tx))
+		if (!tx)
 			return tx;
 	}
 	tx->qp = qp;
