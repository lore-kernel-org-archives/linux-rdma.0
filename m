From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/16] staging/rdma/hfi1: move txreq header code
Date: Sun, 14 Feb 2016 12:44:34 -0800
Message-ID: <20160214204431.29247.52002.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The patch separates the txreq defines into new files, one for
verbs and one for sdma.

The verbs_txreq implementation handles the setup and teardown
of the txreq cache, so the register routine is changed to call
the new init/exit routines.

This patch allows for followup patches enhance the send engine.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Makefile      |    3 -
 drivers/staging/rdma/hfi1/qp.c          |    2 
 drivers/staging/rdma/hfi1/ruc.c         |    2 
 drivers/staging/rdma/hfi1/sdma.h        |   80 -----------------
 drivers/staging/rdma/hfi1/sdma_txreq.h  |  130 +++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/verbs.c       |  111 +----------------------
 drivers/staging/rdma/hfi1/verbs_txreq.c |  149 +++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/verbs_txreq.h |   95 ++++++++++++++++++++
 8 files changed, 384 insertions(+), 188 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/sdma_txreq.h
 create mode 100644 drivers/staging/rdma/hfi1/verbs_txreq.c
 create mode 100644 drivers/staging/rdma/hfi1/verbs_txreq.h

diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index 6681b74..9b11706 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -11,7 +11,8 @@ hfi1-y := affinity.o chip.o device.o diag.o driver.o efivar.o \
 	eprom.o file_ops.o firmware.o \
 	init.o intr.o mad.o pcie.o pio.o pio_copy.o platform.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o sysfs.o trace.o twsi.o \
-	uc.o ud.o user_exp_rcv.o user_pages.o user_sdma.o verbs.o
+	uc.o ud.o user_exp_rcv.o user_pages.o user_sdma.o verbs.o \
+	verbs_txreq.o
 hfi1-$(CONFIG_DEBUG_FS) += debugfs.o
 
 CFLAGS_trace.o = -I$(src)
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 8f4d90b..129a70d 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -60,7 +60,7 @@
 #include "hfi.h"
 #include "qp.h"
 #include "trace.h"
-#include "sdma.h"
+#include "verbs_txreq.h"
 
 unsigned int hfi1_qp_table_size = 256;
 module_param_named(qp_table_size, hfi1_qp_table_size, uint, S_IRUGO);
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 6114550..7c6feff 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -53,7 +53,7 @@
 #include "hfi.h"
 #include "mad.h"
 #include "qp.h"
-#include "sdma.h"
+#include "verbs_txreq.h"
 
 /*
  * Convert the AETH RNR timeout code into the number of microseconds.
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 1d52d6e..76ed215 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -58,9 +58,8 @@
 
 #include "hfi.h"
 #include "verbs.h"
+#include "sdma_txreq.h"
 
-/* increased for AHG */
-#define NUM_DESC 6
 /* Hardware limit */
 #define MAX_DESC 64
 /* Hardware limit for SDMA packet size */
@@ -311,83 +310,6 @@ struct hw_sdma_desc {
 	__le64 qw[2];
 };
 
-/*
- * struct sdma_desc - canonical fragment descriptor
- *
- * This is the descriptor carried in the tx request
- * corresponding to each fragment.
- *
- */
-struct sdma_desc {
-	/* private:  don't use directly */
-	u64 qw[2];
-};
-
-struct sdma_txreq;
-typedef void (*callback_t)(struct sdma_txreq *, int, int);
-
-/**
- * struct sdma_txreq - the sdma_txreq structure (one per packet)
- * @list: for use by user and by queuing for wait
- *
- * This is the representation of a packet which consists of some
- * number of fragments.   Storage is provided to within the structure.
- * for all fragments.
- *
- * The storage for the descriptors are automatically extended as needed
- * when the currently allocation is exceeded.
- *
- * The user (Verbs or PSM) may overload this structure with fields
- * specific to their use by putting this struct first in their struct.
- * The method of allocation of the overloaded structure is user dependent
- *
- * The list is the only public field in the structure.
- *
- */
-
-struct sdma_txreq {
-	struct list_head list;
-	/* private: */
-	struct sdma_desc *descp;
-	/* private: */
-	void *coalesce_buf;
-	/* private: */
-	u16 coalesce_idx;
-	/* private: */
-	struct iowait *wait;
-	/* private: */
-	callback_t                  complete;
-#ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
-	u64 sn;
-#endif
-	/* private: - used in coalesce/pad processing */
-	u16                         packet_len;
-	/* private: - down-counted to trigger last */
-	u16                         tlen;
-	/* private: flags */
-	u16                         flags;
-	/* private: */
-	u16                         num_desc;
-	/* private: */
-	u16                         desc_limit;
-	/* private: */
-	u16                         next_descq_idx;
-	/* private: */
-	struct sdma_desc descs[NUM_DESC];
-};
-
-struct verbs_txreq {
-	struct hfi1_pio_header	phdr;
-	struct sdma_txreq       txreq;
-	struct rvt_qp           *qp;
-	struct rvt_swqe         *wqe;
-	struct rvt_mregion	*mr;
-	struct rvt_sge_state    *ss;
-	struct sdma_engine     *sde;
-	u16                     hdr_dwords;
-	u16                     hdr_inx;
-};
-
 /**
  * struct sdma_engine - Data pertaining to each SDMA engine.
  * @dd: a back-pointer to the device data
diff --git a/drivers/staging/rdma/hfi1/sdma_txreq.h b/drivers/staging/rdma/hfi1/sdma_txreq.h
new file mode 100644
index 0000000..d0f77a8
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/sdma_txreq.h
@@ -0,0 +1,130 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#ifndef HFI1_SDMA_TXREQ_H
+#define HFI1_SDMA_TXREQ_H
+
+/* increased for AHG */
+#define NUM_DESC 6
+
+/*
+ * struct sdma_desc - canonical fragment descriptor
+ *
+ * This is the descriptor carried in the tx request
+ * corresponding to each fragment.
+ *
+ */
+struct sdma_desc {
+	/* private:  don't use directly */
+	u64 qw[2];
+};
+
+/**
+ * struct sdma_txreq - the sdma_txreq structure (one per packet)
+ * @list: for use by user and by queuing for wait
+ *
+ * This is the representation of a packet which consists of some
+ * number of fragments.   Storage is provided to within the structure.
+ * for all fragments.
+ *
+ * The storage for the descriptors are automatically extended as needed
+ * when the currently allocation is exceeded.
+ *
+ * The user (Verbs or PSM) may overload this structure with fields
+ * specific to their use by putting this struct first in their struct.
+ * The method of allocation of the overloaded structure is user dependent
+ *
+ * The list is the only public field in the structure.
+ *
+ */
+
+#define SDMA_TXREQ_S_OK        0
+#define SDMA_TXREQ_S_SENDERROR 1
+#define SDMA_TXREQ_S_ABORTED   2
+#define SDMA_TXREQ_S_SHUTDOWN  3
+
+/* flags bits */
+#define SDMA_TXREQ_F_URGENT       0x0001
+#define SDMA_TXREQ_F_AHG_COPY     0x0002
+#define SDMA_TXREQ_F_USE_AHG      0x0004
+
+struct sdma_txreq;
+typedef void (*callback_t)(struct sdma_txreq *, int, int);
+
+struct iowait;
+struct sdma_txreq {
+	struct list_head list;
+	/* private: */
+	struct sdma_desc *descp;
+	/* private: */
+	void *coalesce_buf;
+	/* private: */
+	struct iowait *wait;
+	/* private: */
+	callback_t                  complete;
+#ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
+	u64 sn;
+#endif
+	/* private: - used in coalesce/pad processing */
+	u16                         packet_len;
+	/* private: - down-counted to trigger last */
+	u16                         tlen;
+	/* private: */
+	u16                         num_desc;
+	/* private: */
+	u16                         desc_limit;
+	/* private: */
+	u16                         next_descq_idx;
+	/* private: */
+	u16 coalesce_idx;
+	/* private: flags */
+	u16                         flags;
+	/* private: */
+	struct sdma_desc descs[NUM_DESC];
+};
+
+#endif                          /* HFI1_SDMA_TXREQ_H */
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 1df4648..7838b21 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -63,7 +63,7 @@
 #include "device.h"
 #include "trace.h"
 #include "qp.h"
-#include "sdma.h"
+#include "verbs_txreq.h"
 
 static unsigned int hfi1_lkey_table_size = 16;
 module_param_named(lkey_table_size, hfi1_lkey_table_size, uint,
@@ -508,89 +508,6 @@ void update_sge(struct rvt_sge_state *ss, u32 length)
 	}
 }
 
-static noinline struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
-						struct rvt_qp *qp)
-{
-	struct hfi1_qp_priv *priv = qp->priv;
-	struct verbs_txreq *tx;
-	unsigned long flags;
-
-	tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
-	if (!tx) {
-		spin_lock_irqsave(&qp->s_lock, flags);
-		write_seqlock(&dev->iowait_lock);
-		if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK &&
-		    list_empty(&priv->s_iowait.list)) {
-			dev->n_txwait++;
-			qp->s_flags |= RVT_S_WAIT_TX;
-			list_add_tail(&priv->s_iowait.list, &dev->txwait);
-			trace_hfi1_qpsleep(qp, RVT_S_WAIT_TX);
-			atomic_inc(&qp->refcount);
-		}
-		qp->s_flags &= ~RVT_S_BUSY;
-		write_sequnlock(&dev->iowait_lock);
-		spin_unlock_irqrestore(&qp->s_lock, flags);
-		tx = ERR_PTR(-EBUSY);
-	}
-	return tx;
-}
-
-static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
-					    struct rvt_qp *qp)
-{
-	struct verbs_txreq *tx;
-
-	tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
-	if (!tx) {
-		/* call slow path to get the lock */
-		tx =  __get_txreq(dev, qp);
-		if (IS_ERR(tx))
-			return tx;
-	}
-	tx->qp = qp;
-	return tx;
-}
-
-void hfi1_put_txreq(struct verbs_txreq *tx)
-{
-	struct hfi1_ibdev *dev;
-	struct rvt_qp *qp;
-	unsigned long flags;
-	unsigned int seq;
-	struct hfi1_qp_priv *priv;
-
-	qp = tx->qp;
-	dev = to_idev(qp->ibqp.device);
-
-	if (tx->mr) {
-		rvt_put_mr(tx->mr);
-		tx->mr = NULL;
-	}
-	sdma_txclean(dd_from_dev(dev), &tx->txreq);
-
-	/* Free verbs_txreq and return to slab cache */
-	kmem_cache_free(dev->verbs_txreq_cache, tx);
-
-	do {
-		seq = read_seqbegin(&dev->iowait_lock);
-		if (!list_empty(&dev->txwait)) {
-			struct iowait *wait;
-
-			write_seqlock_irqsave(&dev->iowait_lock, flags);
-			/* Wake up first QP wanting a free struct */
-			wait = list_first_entry(&dev->txwait, struct iowait,
-						list);
-			qp = iowait_to_qp(wait);
-			priv = qp->priv;
-			list_del_init(&priv->s_iowait.list);
-			/* refcount held until actual wake up */
-			write_sequnlock_irqrestore(&dev->iowait_lock, flags);
-			hfi1_qp_wakeup(qp, RVT_S_WAIT_TX);
-			break;
-		}
-	} while (read_seqretry(&dev->iowait_lock, seq));
-}
-
 /*
  * This is called with progress side lock held.
  */
@@ -1427,13 +1344,6 @@ static void init_ibport(struct hfi1_pportdata *ppd)
 	RCU_INIT_POINTER(ibp->rvp.qp[1], NULL);
 }
 
-static void verbs_txreq_kmem_cache_ctor(void *obj)
-{
-	struct verbs_txreq *tx = obj;
-
-	memset(tx, 0, sizeof(*tx));
-}
-
 /**
  * hfi1_register_ib_device - register our device with the infiniband core
  * @dd: the device data structure
@@ -1447,8 +1357,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	unsigned i;
 	int ret;
 	size_t lcpysz = IB_DEVICE_NAME_MAX;
-	u16 descq_cnt;
-	char buf[TXREQ_NAME_LEN];
 
 	for (i = 0; i < dd->num_pports; i++)
 		init_ibport(ppd + i);
@@ -1461,18 +1369,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	INIT_LIST_HEAD(&dev->txwait);
 	INIT_LIST_HEAD(&dev->memwait);
 
-	descq_cnt = sdma_get_descq_cnt();
-
-	snprintf(buf, sizeof(buf), "hfi1_%u_vtxreq_cache", dd->unit);
-	/* SLAB_HWCACHE_ALIGN for AHG */
-	dev->verbs_txreq_cache = kmem_cache_create(buf,
-						   sizeof(struct verbs_txreq),
-						   0, SLAB_HWCACHE_ALIGN,
-						   verbs_txreq_kmem_cache_ctor);
-	if (!dev->verbs_txreq_cache) {
-		ret = -ENOMEM;
+	ret = verbs_txreq_init(dev);
+	if (ret)
 		goto err_verbs_txreq;
-	}
 
 	/*
 	 * The system image GUID is supposed to be the same for all
@@ -1578,7 +1477,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 err_class:
 	rvt_unregister_device(&dd->verbs_dev.rdi);
 err_verbs_txreq:
-	kmem_cache_destroy(dev->verbs_txreq_cache);
+	verbs_txreq_exit(dev);
 	dd_dev_err(dd, "cannot register verbs: %d!\n", -ret);
 	return ret;
 }
@@ -1597,7 +1496,7 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 		dd_dev_err(dd, "memwait list not empty!\n");
 
 	del_timer_sync(&dev->mem_timer);
-	kmem_cache_destroy(dev->verbs_txreq_cache);
+	verbs_txreq_exit(dev);
 }
 
 void hfi1_cnp_rcv(struct hfi1_packet *packet)
diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.c b/drivers/staging/rdma/hfi1/verbs_txreq.c
new file mode 100644
index 0000000..bc95c41
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/verbs_txreq.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#include "hfi.h"
+#include "verbs_txreq.h"
+#include "qp.h"
+#include "trace.h"
+
+#define TXREQ_LEN 24
+
+void hfi1_put_txreq(struct verbs_txreq *tx)
+{
+	struct hfi1_ibdev *dev;
+	struct rvt_qp *qp;
+	unsigned long flags;
+	unsigned int seq;
+	struct hfi1_qp_priv *priv;
+
+	qp = tx->qp;
+	dev = to_idev(qp->ibqp.device);
+
+	if (tx->mr)
+		rvt_put_mr(tx->mr);
+
+	sdma_txclean(dd_from_dev(dev), &tx->txreq);
+
+	/* Free verbs_txreq and return to slab cache */
+	kmem_cache_free(dev->verbs_txreq_cache, tx);
+
+	do {
+		seq = read_seqbegin(&dev->iowait_lock);
+		if (!list_empty(&dev->txwait)) {
+			struct iowait *wait;
+
+			write_seqlock_irqsave(&dev->iowait_lock, flags);
+			wait = list_first_entry(&dev->txwait, struct iowait,
+						list);
+			qp = iowait_to_qp(wait);
+			priv = qp->priv;
+			list_del_init(&priv->s_iowait.list);
+			/* refcount held until actual wake up */
+			write_sequnlock_irqrestore(&dev->iowait_lock, flags);
+			hfi1_qp_wakeup(qp, RVT_S_WAIT_TX);
+			break;
+		}
+	} while (read_seqretry(&dev->iowait_lock, seq));
+}
+
+struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
+				struct rvt_qp *qp)
+{
+	struct verbs_txreq *tx = ERR_PTR(-EBUSY);
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->s_lock, flags);
+	write_seqlock(&dev->iowait_lock);
+	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
+		struct hfi1_qp_priv *priv;
+
+		tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
+		if (tx)
+			goto out;
+		priv = qp->priv;
+		if (list_empty(&priv->s_iowait.list)) {
+			dev->n_txwait++;
+			qp->s_flags |= RVT_S_WAIT_TX;
+			list_add_tail(&priv->s_iowait.list, &dev->txwait);
+			trace_hfi1_qpsleep(qp, RVT_S_WAIT_TX);
+			atomic_inc(&qp->refcount);
+		}
+		qp->s_flags &= ~RVT_S_BUSY;
+	}
+out:
+	write_sequnlock(&dev->iowait_lock);
+	spin_unlock_irqrestore(&qp->s_lock, flags);
+	return tx;
+}
+
+static void verbs_txreq_kmem_cache_ctor(void *obj)
+{
+	struct verbs_txreq *tx = (struct verbs_txreq *)obj;
+
+	memset(tx, 0, sizeof(*tx));
+}
+
+int verbs_txreq_init(struct hfi1_ibdev *dev)
+{
+	char buf[TXREQ_LEN];
+	struct hfi1_devdata *dd = dd_from_dev(dev);
+
+	snprintf(buf, sizeof(buf), "hfi1_%u_vtxreq_cache", dd->unit);
+	dev->verbs_txreq_cache = kmem_cache_create(buf,
+						   sizeof(struct verbs_txreq),
+						   0, SLAB_HWCACHE_ALIGN,
+						   verbs_txreq_kmem_cache_ctor);
+	if (!dev->verbs_txreq_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void verbs_txreq_exit(struct hfi1_ibdev *dev)
+{
+	kmem_cache_destroy(dev->verbs_txreq_cache);
+	dev->verbs_txreq_cache = NULL;
+}
diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.h b/drivers/staging/rdma/hfi1/verbs_txreq.h
new file mode 100644
index 0000000..387882a
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/verbs_txreq.h
@@ -0,0 +1,95 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#ifndef HFI1_VERBS_TXREQ_H
+#define HFI1_VERBS_TXREQ_H
+
+#include <linux/types.h>
+#include <linux/slab.h>
+
+#include "verbs.h"
+#include "sdma_txreq.h"
+#include "iowait.h"
+
+struct verbs_txreq {
+	struct hfi1_pio_header	phdr;
+	struct sdma_txreq       txreq;
+	struct rvt_qp           *qp;
+	struct rvt_swqe         *wqe;
+	struct rvt_mregion	*mr;
+	struct rvt_sge_state    *ss;
+	struct sdma_engine     *sde;
+	struct send_context     *psc;
+	u16                     hdr_dwords;
+};
+
+struct hfi1_ibdev;
+struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
+				struct rvt_qp *qp);
+
+static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
+					    struct rvt_qp *qp)
+{
+	struct verbs_txreq *tx;
+
+	tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
+	if (unlikely(!tx)) {
+		/* call slow path to get the lock */
+		tx = __get_txreq(dev, qp);
+		if (IS_ERR(tx))
+			return tx;
+	}
+	tx->qp = qp;
+	tx->mr = NULL;
+	return tx;
+}
+
+void hfi1_put_txreq(struct verbs_txreq *tx);
+int verbs_txreq_init(struct hfi1_ibdev *dev);
+void verbs_txreq_exit(struct hfi1_ibdev *dev);
+
+#endif                         /* HFI1_VERBS_TXREQ_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
