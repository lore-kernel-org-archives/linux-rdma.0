Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705056;
	b=UGHiBcXnSUaAZxDgeNJjJUvpHWNV7nBPSKBlGSgEsHLh8j3kXrFTSDY8jis3yxvlkpjL
	 rBipRkI2RlFmhNmDkksSwgurgNx7i9PyBBCukh/W1Ud1b2NNj0PDrgYtcHDIAJP14lc0/
	 ZYBdqDjb2woDtt5DEFquLtXkgv67bJ2Q8Il1UURIOk2P4Yn0IQVJR/2PKautrw9ayIfvU
	 dyfjWBJWvoBep1OOXXxfuxtcqlkkdFceqXarjyDlaMVB7kpVOowWI+nQPwYJdH0itcz4M
	 qx0I5JTMgozYccLpj7ucATtrgQwqH3N9SvMz4Jb46sqorp/aIjwJPaznomzbmIUDGAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705056;
	h=DMARC-Filter:DKIM-Signature:From:Message-Id:X-Lms-Return-Path:
	 In-Reply-To:X-Original-From:References:To:Cc:Subject:Mime-Version:
	 Date:Received:X-Mailer:Content-Type:Content-Transfer-Encoding;
	bh=gbm/7c/c57SRfbHZE/bpH4/NLVfouj7MuTGABTVWCzY=;
	b=xBOCkO2qNEztTjhd4HTBp4Icj7XkoDlm9KOPyQnC+dd7EVZRfl1U5hvcEe8hgitwDrfK
	 acVLHGxOJIeQmZZx9mbUDx6rvsksrPSLttINW0O/McZo10qtFPVb2pdi4h5ZjBd2MaKCm
	 2kF1wVB/jQI4FUe0jWAAqjwG4qkOg3mOc9YXT2D/hAZGphFy6TuWH/WGOmYeyBTynpNfZ
	 3xnKDvxmB+wHnM8VcEl8OVscsagVHE89g6gqc9IjEDDjL+yb1jFEMFTtqSNnZiyPfWnZK
	 6+FOIkcujznqv+HJOM0AIDU2nS7cOBsT/Qexv1xDpBAc0QaJoA/SivPTLn7SP1ju5Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=gEwQjYdg;
	arc=none smtp.remote-ip=209.127.231.42
Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1139C60A2604
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1139C60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=gEwQjYdg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705051; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=gbm/7c/c57SRfbHZE/bpH4/NLVfouj7MuTGABTVWCzY=;
 b=gEwQjYdgP2GF7DV6Iuyy01fA7GWbmPfgMQmFuU6F9mYJlMoRdqm6fIELBK8fzzqYCOmez3
 p8BTfE2dSU7f8jeYHfjZZR9KCOgyqJeqQ5nDf3Zp8cbhclfxgBOI9yezAuY5B2aNlfPwZ/
 qx83AOUKGNSEiROa5TZdDUvrlqdg9prAGfMzjY8rJy/94xUsFxnXYTjQMPEFP2I5KtJ9E7
 BcEE/ObXi9VJOET1hHGLWSxiNCxSfc5biSTKYJf9nKDbV/gk8m7qWI0xgdVJxCUdNzvd77
 naQlk1cDLZpKomQ6WtC4wFHY5dMmOYkU1SJgGtecbJl6WuxQUKdUaR3B4w+uiQ==
From: "Xin Tian" <tianx@yunsilicon.com>
Message-Id: <20261126145727.70868-7-tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26b0848d9+40d8be+vger.kernel.org+tianx@yunsilicon.com>
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
Subject: [PATCH v2 06/11] net/xsc: add CQ and QP helpers
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Date: Thu, 26 Nov 2026 22:57:28 +0800
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:28 +0800
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Provide the CQ/QP tables and the ethernet create/destroy/modify
helpers. Dispatch completion and error events from the event queue.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  69 +++++++
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c  | 130 +++++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h  |  13 ++
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c  |  83 ++++++++
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |   5 +
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c  | 180 ++++++++++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h  |  14 ++
 8 files changed, 495 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index 212cb2f9c..7a74f860c 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -8,10 +8,14 @@
 
 #include <linux/pci.h>
 #include <linux/bitfield.h>
+#include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/radix-tree.h>
 #include <linux/workqueue.h>
 
+#include "common/xsc_cmd.h"
+
 #define XSC_PCI_VENDOR_ID		0x1f67
 
 #define XSC_MC_PF_DEV_ID		0x1011
@@ -84,6 +88,49 @@ struct xsc_irq_info {
 	char			name[XSC_MAX_IRQ_NAME];
 };
 
+enum xsc_event {
+	XSC_EVENT_TYPE_COMP			= 0x0,
+	XSC_EVENT_TYPE_CQ_ERROR			= 0x04,
+	XSC_EVENT_TYPE_WQ_CATAS_ERROR		= 0x05,
+	XSC_EVENT_TYPE_INTERNAL_ERROR		= 0x08,
+	XSC_EVENT_TYPE_WQ_INVAL_REQ_ERROR	= 0x10,
+	XSC_EVENT_TYPE_WQ_ACCESS_ERROR		= 0x11,
+};
+
+/* qp */
+struct xsc_core_qp {
+	void			(*event)(struct xsc_core_qp *qp, int type);
+	u32			qpn;
+	atomic_t		refcount;
+	struct completion	free;
+	u16			eth_queue_type;
+};
+
+struct xsc_qp_table {
+	/* protect radix tree */
+	spinlock_t		lock;
+	struct radix_tree_root	tree;
+};
+
+/* cq */
+struct xsc_core_cq {
+	u32			cqn;
+	struct xsc_core_device	*xdev;
+	atomic_t		refcount;
+	struct completion	free;
+	unsigned int		vector;
+	unsigned int		irqn;
+	void			(*comp)(struct xsc_core_cq *cq);
+	void			(*event)(struct xsc_core_cq *cq,
+					 enum xsc_event);
+};
+
+struct xsc_cq_table {
+	/* protect radix tree */
+	spinlock_t		lock;
+	struct radix_tree_root	tree;
+};
+
 struct xsc_cmd;
 
 struct xsc_core_device {
@@ -107,6 +154,8 @@ struct xsc_core_device {
 	struct xsc_caps		caps;
 	struct xsc_cmd		*cmd;
 	struct xsc_eq_table	eq_table;
+	struct xsc_qp_table	qp_table;
+	struct xsc_cq_table	cq_table;
 	struct xsc_irq_info	*irq_info;
 };
 
@@ -128,6 +177,26 @@ void xsc_clear_cmdq_err_status(struct xsc_core_device *xdev, u32 status);
 int xsc_core_vector2eqn(struct xsc_core_device *xdev, int vector, u32 *eqn,
 			unsigned int *irqn);
 
+/* cq/qp resource */
+int xsc_core_create_resource_common(struct xsc_core_device *xdev,
+				    struct xsc_core_qp *qp);
+void xsc_core_destroy_resource_common(struct xsc_core_device *xdev,
+				      struct xsc_core_qp *qp);
+int xsc_core_eth_create_qp(struct xsc_core_device *xdev,
+			   struct xsc_create_qp_mbox_in *in,
+			   int insize, u32 *p_qpn);
+int xsc_core_eth_modify_qp_status(struct xsc_core_device *xdev,
+				  u32 qpn, u16 status);
+int xsc_core_eth_destroy_qp(struct xsc_core_device *xdev, u32 qpn);
+int xsc_core_eth_modify_raw_qp(struct xsc_core_device *xdev,
+			       struct xsc_modify_raw_qp_mbox_in *in);
+int xsc_core_eth_create_cq(struct xsc_core_device *xdev,
+			   struct xsc_core_cq *xcq,
+			   struct xsc_create_cq_mbox_in *in,
+			   int insize);
+int xsc_core_eth_destroy_cq(struct xsc_core_device *xdev,
+			    struct xsc_core_cq *xcq);
+
 /*
  * Link event callback registration. The events are dispatched from the PCI
  * layer's own workqueue; unregister detaches the callback and waits for one
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 7a32e0320..552cd5f46 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmd.o eq.o pci_irq.o alloc.o doorbell.o
+xsc_pci-y := main.o cmd.o eq.o cq.o qp.o pci_irq.o alloc.o doorbell.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
new file mode 100644
index 000000000..a4f9b488d
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+#include "cq.h"
+
+void xsc_init_cq_table(struct xsc_core_device *xdev)
+{
+	struct xsc_cq_table *table = &xdev->cq_table;
+
+	spin_lock_init(&table->lock);
+	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
+}
+
+static int xsc_create_cq(struct xsc_core_device *xdev, u32 *p_cqn,
+			 struct xsc_create_cq_mbox_in *in, int insize)
+{
+	struct xsc_create_cq_mbox_out out;
+	int ret;
+
+	memset(&out, 0, sizeof(out));
+	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_CQ);
+	ret = xsc_cmd_exec(xdev, in, insize, &out, sizeof(out));
+	if (ret) {
+		pci_err(xdev->pdev, "failed to create cq, err=%d out.status=%u\n",
+			ret, out.hdr.status);
+		return ret;
+	}
+
+	*p_cqn = be32_to_cpu(out.cqn) & 0xffffff;
+	return 0;
+}
+
+static int xsc_destroy_cq(struct xsc_core_device *xdev, u32 cqn)
+{
+	struct xsc_destroy_cq_mbox_out out;
+	struct xsc_destroy_cq_mbox_in in;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DESTROY_CQ);
+	in.cqn = cpu_to_be32(cqn);
+
+	return xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+}
+
+int xsc_core_eth_create_cq(struct xsc_core_device *xdev,
+			   struct xsc_core_cq *xcq,
+			   struct xsc_create_cq_mbox_in *in,
+			   int insize)
+{
+	struct xsc_cq_table *table = &xdev->cq_table;
+	u32 cqn;
+	int ret;
+	int err;
+
+	ret = xsc_create_cq(xdev, &cqn, in, insize);
+	if (ret) {
+		pci_err(xdev->pdev, "xsc_create_cq failed, err=%d\n", ret);
+		return ret;
+	}
+	xcq->cqn = cqn;
+	xcq->xdev = xdev;
+	atomic_set(&xcq->refcount, 1);
+	init_completion(&xcq->free);
+
+	spin_lock_irq(&table->lock);
+	ret = radix_tree_insert(&table->tree, xcq->cqn, xcq);
+	spin_unlock_irq(&table->lock);
+	if (ret)
+		goto err_insert_cq;
+	return 0;
+
+err_insert_cq:
+	err = xsc_destroy_cq(xdev, cqn);
+	if (err)
+		pci_err(xdev->pdev, "failed to destroy cqn=%d, err=%d\n",
+			xcq->cqn, err);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xsc_core_eth_create_cq);
+
+int xsc_core_eth_destroy_cq(struct xsc_core_device *xdev,
+			    struct xsc_core_cq *xcq)
+{
+	struct xsc_cq_table *table = &xdev->cq_table;
+	struct xsc_core_cq *tmp;
+	int err;
+
+	spin_lock_irq(&table->lock);
+	tmp = radix_tree_delete(&table->tree, xcq->cqn);
+	spin_unlock_irq(&table->lock);
+	if (!tmp) {
+		err = -ENOENT;
+		goto err_delete_cq;
+	}
+
+	if (tmp != xcq) {
+		err = -EINVAL;
+		goto err_delete_cq;
+	}
+
+	/* the completion reader looks the cq up under rcu_read_lock and
+	 * takes its reference afterwards; wait for it before dropping
+	 * the tree reference so it never touches a freed cq
+	 */
+	synchronize_rcu();
+
+	err = xsc_destroy_cq(xdev, xcq->cqn);
+	if (err)
+		goto err_destroy_cq;
+
+	if (atomic_dec_and_test(&xcq->refcount))
+		complete(&xcq->free);
+	wait_for_completion(&xcq->free);
+	return 0;
+
+err_destroy_cq:
+	pci_err(xdev->pdev, "failed to destroy cqn=%d, err=%d\n",
+		xcq->cqn, err);
+	return err;
+err_delete_cq:
+	pci_err(xdev->pdev, "cqn=%d not found in tree, err=%d\n",
+		xcq->cqn, err);
+	return err;
+}
+EXPORT_SYMBOL_GPL(xsc_core_eth_destroy_cq);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.h b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.h
new file mode 100644
index 000000000..46ad9cb52
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_CQ_H
+#define __XSC_CQ_H
+
+#include "common/xsc_core.h"
+
+void xsc_init_cq_table(struct xsc_core_device *xdev);
+
+#endif /* __XSC_CQ_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
index 875a277a8..1ebc89410 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
@@ -12,7 +12,9 @@
 #include "common/xsc_cmd.h"
 #include "common/xsc_core.h"
 #include "alloc.h"
+#include "cq.h"
 #include "eq.h"
+#include "qp.h"
 
 enum {
 	XSC_EQE_SIZE		= sizeof(struct xsc_eqe),
@@ -52,8 +54,63 @@ static void eq_update_ci(struct xsc_eq *eq, int arm)
 	xsc_update_eq_ci(eq->dev, eq->eqn, eq->cons_index, arm);
 }
 
+static void xsc_cq_completion(struct xsc_core_device *xdev, u32 cqn)
+{
+	struct xsc_cq_table *table = &xdev->cq_table;
+	struct xsc_core_cq *cq;
+
+	rcu_read_lock();
+	cq = radix_tree_lookup(&table->tree, cqn);
+	if (likely(cq))
+		atomic_inc(&cq->refcount);
+	rcu_read_unlock();
+
+	if (!cq) {
+		pci_err(xdev->pdev, "Completion event for bogus CQ, cqn=%d\n",
+			cqn);
+		return;
+	}
+
+	if (!cq->comp)
+		pci_err(xdev->pdev, "cq->comp is NULL\n");
+	else
+		cq->comp(cq);
+
+	if (atomic_dec_and_test(&cq->refcount))
+		complete(&cq->free);
+}
+
+static void xsc_eq_cq_event(struct xsc_core_device *xdev,
+			    u32 cqn, int event_type)
+{
+	struct xsc_cq_table *table = &xdev->cq_table;
+	struct xsc_core_cq *cq;
+
+	spin_lock(&table->lock);
+	cq = radix_tree_lookup(&table->tree, cqn);
+	if (likely(cq))
+		atomic_inc(&cq->refcount);
+	spin_unlock(&table->lock);
+
+	if (unlikely(!cq)) {
+		pci_err(xdev->pdev, "Async event for bogus CQ, cqn=%d\n",
+			cqn);
+		return;
+	}
+
+	if (cq->event)
+		cq->event(cq, event_type);
+	else
+		pci_err(xdev->pdev, "cq->event is NULL, cqn=%d\n", cq->cqn);
+
+	if (atomic_dec_and_test(&cq->refcount))
+		complete(&cq->free);
+}
+
 static int xsc_eq_int(struct xsc_eq *eq)
 {
+	struct xsc_core_device *xdev = eq->dev;
+	u32 cqn, qpn, queue_id;
 	struct xsc_eqe *eqe;
 	int eqes_found = 0;
 	int set_ci = 0;
@@ -63,6 +120,32 @@ static int xsc_eq_int(struct xsc_eq *eq)
 		 * checked the ownership bit.
 		 */
 		rmb();
+		switch (eqe->type) {
+		case XSC_EVENT_TYPE_COMP:
+		case XSC_EVENT_TYPE_INTERNAL_ERROR:
+			queue_id = FIELD_GET(XSC_EQE_QUEUE_ID_MASK,
+					     le16_to_cpu(eqe->queue_id_data));
+			cqn = queue_id;
+			xsc_cq_completion(xdev, cqn);
+			break;
+
+		case XSC_EVENT_TYPE_CQ_ERROR:
+			queue_id = FIELD_GET(XSC_EQE_QUEUE_ID_MASK,
+					     le16_to_cpu(eqe->queue_id_data));
+			cqn = queue_id;
+			xsc_eq_cq_event(xdev, cqn, eqe->type);
+			break;
+		case XSC_EVENT_TYPE_WQ_CATAS_ERROR:
+		case XSC_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+		case XSC_EVENT_TYPE_WQ_ACCESS_ERROR:
+			queue_id = FIELD_GET(XSC_EQE_QUEUE_ID_MASK,
+					     le16_to_cpu(eqe->queue_id_data));
+			qpn = queue_id;
+			xsc_qp_event(xdev, qpn, eqe->type);
+			break;
+		default:
+			break;
+		}
 
 		++eq->cons_index;
 		eqes_found = 1;
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index 315f212c1..e158dd2e9 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -7,8 +7,10 @@
 
 #include "common/xsc_cmd.h"
 #include "common/xsc_core.h"
+#include "cq.h"
 #include "eq.h"
 #include "pci_irq.h"
+#include "qp.h"
 
 static const struct pci_device_id xsc_pci_id_table[] = {
 	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MC_PF_DEV_ID) },
@@ -162,6 +164,9 @@ static int xsc_pci_init(struct xsc_core_device *xdev,
 		goto err_cmd_cleanup;
 	}
 
+	xsc_init_cq_table(xdev);
+	xsc_init_qp_table(xdev);
+
 	err = xsc_irq_eq_create(xdev);
 	if (err) {
 		pci_err(pdev, "failed to create irq/eq: err=%d\n", err);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
new file mode 100644
index 000000000..ca2ad4ab0
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/gfp.h>
+#include <linux/export.h>
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+#include "qp.h"
+
+int xsc_core_create_resource_common(struct xsc_core_device *xdev,
+				    struct xsc_core_qp *qp)
+{
+	struct xsc_qp_table *table = &xdev->qp_table;
+	int err;
+
+	/* initialize before the insert: once in the tree, the qp can be
+	 * found and referenced by the async event handler
+	 */
+	atomic_set(&qp->refcount, 1);
+	init_completion(&qp->free);
+
+	spin_lock_irq(&table->lock);
+	err = radix_tree_insert(&table->tree, qp->qpn, qp);
+	spin_unlock_irq(&table->lock);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_create_resource_common);
+
+void xsc_core_destroy_resource_common(struct xsc_core_device *xdev,
+				      struct xsc_core_qp *qp)
+{
+	struct xsc_qp_table *table = &xdev->qp_table;
+	struct xsc_core_qp *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&table->lock, flags);
+	tmp = radix_tree_delete(&table->tree, qp->qpn);
+	spin_unlock_irqrestore(&table->lock, flags);
+	if (!tmp) {
+		pci_warn(xdev->pdev, "qp 0x%x not found in tree\n", qp->qpn);
+		return;
+	}
+
+	if (atomic_dec_and_test(&qp->refcount))
+		complete(&qp->free);
+	wait_for_completion(&qp->free);
+}
+EXPORT_SYMBOL_GPL(xsc_core_destroy_resource_common);
+
+void xsc_qp_event(struct xsc_core_device *xdev, u32 qpn, int event_type)
+{
+	struct xsc_qp_table *table = &xdev->qp_table;
+	struct xsc_core_qp *qp;
+
+	spin_lock(&table->lock);
+
+	qp = radix_tree_lookup(&table->tree, qpn);
+	if (qp)
+		atomic_inc(&qp->refcount);
+
+	spin_unlock(&table->lock);
+
+	if (!qp) {
+		pci_err(xdev->pdev, "Async event for bogus QP 0x%x\n", qpn);
+		return;
+	}
+
+	if (qp->event)
+		qp->event(qp, event_type);
+	else
+		pci_err(xdev->pdev, "qp->event is NULL, qpn=0x%x\n", qp->qpn);
+
+	if (atomic_dec_and_test(&qp->refcount))
+		complete(&qp->free);
+}
+
+void xsc_init_qp_table(struct xsc_core_device *xdev)
+{
+	struct xsc_qp_table *table = &xdev->qp_table;
+
+	spin_lock_init(&table->lock);
+	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
+}
+
+int xsc_core_eth_create_qp(struct xsc_core_device *xdev,
+			   struct xsc_create_qp_mbox_in *in,
+			   int insize, u32 *p_qpn)
+{
+	struct xsc_create_qp_mbox_out out = {};
+	int ret;
+
+	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_QP);
+	ret = xsc_cmd_exec(xdev, in, insize, &out, sizeof(out));
+	if (ret) {
+		pci_err(xdev->pdev, "failed to create sq, err=%d out.status=%u\n",
+			ret, out.hdr.status);
+		return ret;
+	}
+
+	*p_qpn = be32_to_cpu(out.qpn) & 0xffffff;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_eth_create_qp);
+
+int xsc_core_eth_modify_qp_status(struct xsc_core_device *xdev,
+				  u32 qpn, u16 status)
+{
+	struct xsc_modify_qp_mbox_out out = {};
+	struct xsc_modify_qp_mbox_in in = {};
+	int ret;
+
+	in.hdr.opcode = cpu_to_be16(status);
+	in.qpn = cpu_to_be32(qpn);
+	in.no_need_wait = 1;
+
+	ret = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (ret) {
+		pci_err(xdev->pdev, "failed to modify qp %u status=%u, err=%d out.status %u\n",
+			qpn, status, ret, out.hdr.status);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_eth_modify_qp_status);
+
+int xsc_core_eth_destroy_qp(struct xsc_core_device *xdev, u32 qpn)
+{
+	struct xsc_destroy_qp_mbox_out out;
+	struct xsc_destroy_qp_mbox_in in;
+	int err;
+
+	err = xsc_core_eth_modify_qp_status(xdev, qpn, XSC_CMD_OP_2RST_QP);
+	if (err) {
+		pci_err(xdev->pdev, "failed to set sq%d status=rst, err=%d\n",
+			qpn, err);
+		return err;
+	}
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DESTROY_QP);
+	in.qpn = cpu_to_be32(qpn);
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		pci_err(xdev->pdev, "failed to destroy sq%d, err=%d out.status=%u\n",
+			qpn, err, out.hdr.status);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_eth_destroy_qp);
+
+int xsc_core_eth_modify_raw_qp(struct xsc_core_device *xdev,
+			       struct xsc_modify_raw_qp_mbox_in *in)
+{
+	struct xsc_modify_raw_qp_mbox_out out = {};
+	int err;
+
+	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_MODIFY_RAW_QP);
+
+	err = xsc_cmd_exec(xdev, in, sizeof(struct xsc_modify_raw_qp_mbox_in),
+			   &out, sizeof(struct xsc_modify_raw_qp_mbox_out));
+	if (err) {
+		pci_err(xdev->pdev, "failed to modify sq, err=%d out.status=%u\n",
+			err, out.hdr.status);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_eth_modify_raw_qp);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
new file mode 100644
index 000000000..068bfe801
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_QP_H
+#define __XSC_QP_H
+
+#include "common/xsc_core.h"
+
+void xsc_init_qp_table(struct xsc_core_device *xdev);
+void xsc_qp_event(struct xsc_core_device *xdev, u32 qpn, int event_type);
+
+#endif /* __XSC_QP_H */
-- 
2.43.0
