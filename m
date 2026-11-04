Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807833;
	b=Pio7EjxiMfGnIjywNlLgk4VbwAY9P3LL88NMqfDiAQNkABXQ5m2SbBLIYpn3xVFak7Bl
	 DBGdebXWknXSNAIog2b9/01tSyRY+fzb6Cn2Sql3EachhE/tsxAknchGo6GsMSaHecuDF
	 l/0uBRdDEi01+q7BlIVruOrYhAT9ceUZnv9cKfZ0MaqiQb4KnmdcIEbGf3UxOgR/Vu4uZ
	 GyupJEmih0+zk9LkYZzvRSGTFMYSZZoDAeF7Kpy/48iH7vcsBUX8r8OKusj8Z9UgH14z5
	 fe9/1CNmTDZfvxXvolbaQBx45kRJu7ShwV2IcRhQaVz2XG2HrA9YoUSKwScTP50SwLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807833;
	h=DMARC-Filter:DKIM-Signature:To:X-Mailer:X-Lms-Return-Path:References:
	 Content-Transfer-Encoding:Cc:From:Subject:Mime-Version:Received:
	 X-Original-From:Date:In-Reply-To:Content-Type:Message-Id;
	bh=EEFhNYFg3ImMgcYGbJCjz7NY6pwX6FkILehI27uIQFI=;
	b=hKlLDfDlNRYaiyTVs/RD+HfN49QyWQ3IrgApEhvhY63U3vNTKe77gYmJL8DtDnMIL3Tr
	 Fb+YXZDaFOSe3GfOETzodhzNIwMRFWTuHwXV3ult+Ypj3ZFNu6Qafzak9A9F2Vf2PQ4GJ
	 25YaowsFUtgLh7i5giXsWfOpRMZcKUCRsVHmsLnyIMP0wGUgFaruUMKESdWFpSPB1xt6P
	 VYuEVOkHdgCGJH8P8yujm+y1en68HsMJPnyM5SN3eN01AE0POiGri08EGAbGCluHhD+cx
	 y7IVvqSb2kCXya6OIvuB1ccpUwf9mVXRH7i9gqa0mjb9KuadmuDBgPAQeqMA2tVA+DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=SCOjlr2T;
	arc=none smtp.remote-ip=209.127.231.27
Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F013B606A331
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F013B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=SCOjlr2T
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807827; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EEFhNYFg3ImMgcYGbJCjz7NY6pwX6FkILehI27uIQFI=;
 b=SCOjlr2TEG+EKgkI7wOt/VuNHWhQHIFbW/4KEBXoV0j3xADQ92OKGKeNs2TwE0SDltVtTo
 AOrNqXyKKFJTZ05aH7xX7e/rVN+ovz6PSbW/1sQT35VIVY/MiZ7j1eg5WIRa3wyaJttKWl
 yYOxmlxHcG/L2/PMbM9Vb4KKbKyLfqz0snNKqRV/+86it+dKp0PH0r9NmsDmdthzpsTVAu
 E9p9S0h8CMNaFRdm+H7q0Yx7iAl5p6m/uEDdvCkzoWyF9DSNd+nLuZ1R/CvetgSMqJFg1e
 JtfHQQaZh03+k5DiGRsCvfE2mjmpF0SgNGA5arksUy8vOTgcoO+rBPLo+ybfeQ==
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
X-Mailer: git-send-email 2.25.1
X-Lms-Return-Path: <lba+26aeb55d1+9beb98+vger.kernel.org+tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH v1 06/15] net/xsc: add the CQ and QP resource pools
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:57:04 +0800
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Date: Wed, 04 Nov 2026 23:57:04 +0800
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20261104155703.37053-7-tianx@yunsilicon.com>

Add the device-wide registries for completion queues and queue pairs,
and wire completion events from the EQs into them.

CQs and QPs live in radix trees keyed by CQN and QPN and are looked
up from the EQ dispatch under RCU with a reference count taken on
hit; destroy removes the entry, synchronizes RCU and waits for
in-flight users before issuing the firmware destroy command, so a
completion arriving concurrently with teardown cannot touch freed
memory.  QP destroy issues two RST transitions first to drain
pending work.

Provide two CQ creation paths: a legacy one used by the ethernet
function, and an extended one used by RDMA that falls back to the
legacy command when firmware rejects it and splits large contexts
into a context command followed by chunked buffer-address commands
when the context exceeds the maximum command payload.  New CQs are
armed after creation.

Add the QP creation, destruction and state transition helpers,
including raw-TSO queues and multi-QP RSS receive queues needed by
the ethernet function, and route asynchronous QP events to the
event callback stored in the core QP.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |   1 -
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c  | 319 ++++++++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c  |  54 ++-
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |   2 +
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c  | 355 ++++++++++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h  |   2 +-
 7 files changed, 731 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/qp.c

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index 9775412d2..bc41e88cc 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -255,7 +255,6 @@ struct xsc_core_cq {
 	void			(*event)(struct xsc_core_cq *cq,
 					 enum xsc_event);
 	u32			cons_index;
-	unsigned int		arm_sn;
 	int			pid;
 	u32			reg_next_cid;
 	u32			reg_done_pid;
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index e264990f9..5c947da2a 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmdq.o hw.o alloc.o eq.o pci_irq.o adev.o hal/andes_impl.o
+xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o alloc.o eq.o pci_irq.o adev.o hal/andes_impl.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
new file mode 100644
index 000000000..e3e13ef53
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
@@ -0,0 +1,319 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd_api.h"
+#include "cq.h"
+
+void xsc_init_cq_table(struct xsc_core_device *xdev)
+{
+	struct xsc_cq_table *table = &xdev->dev_res->cq_table;
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
+	struct xsc_cq_table *table = &xdev->dev_res->cq_table;
+	u32 cqn;
+	int ret;
+	int err;
+
+	ret = xsc_create_cq(xdev, &cqn, in, insize);
+	if (ret) {
+		pci_err(xdev->pdev, "xsc_create_cq failed\n");
+		return -ENOEXEC;
+	}
+	xcq->cqn = cqn;
+	xcq->cons_index = 0;
+	atomic_set(&xcq->refcount, 1);
+	init_completion(&xcq->free);
+
+	spin_lock_irq(&table->lock);
+	ret = radix_tree_insert(&table->tree, xcq->cqn, xcq);
+	spin_unlock_irq(&table->lock);
+	if (ret)
+		goto err_insert_cq;
+	return 0;
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
+	struct xsc_cq_table *table = &xdev->dev_res->cq_table;
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
+
+static int xsc_set_cq_context(struct xsc_core_device *xdev,
+			      struct xsc_cq_context_ex *ctx_ex,
+			      u32 *pa_list_base, u32 *cqn)
+{
+	struct xsc_set_cq_context_mbox_in in;
+	struct xsc_set_cq_context_mbox_out out;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memcpy(&in.ctx_ex, ctx_ex, sizeof(*ctx_ex));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_SET_CQ_CONTEXT);
+	in.hdr.ver = cpu_to_be16(XSC_CMD_SET_CQ_CONTEXT_V1);
+
+	memset(&out, 0, sizeof(out));
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err || out.hdr.status) {
+		pci_err(xdev->pdev, "failed to set cq context\n");
+		return -EIO;
+	}
+
+	*pa_list_base = be32_to_cpu(out.cq_pa_list_base);
+	*cqn = be32_to_cpu(out.cqn);
+	return 0;
+}
+
+static int xsc_set_cq_buf_pa(struct xsc_core_device *xdev,
+			     struct xsc_create_cq_ex_mbox_in *req,
+			     u32 pa_list_base, u32 cqn)
+{
+	struct xsc_set_cq_buf_pa_mbox_in *in;
+	struct xsc_set_cq_buf_pa_mbox_out out;
+	u32 pa_num_total = be32_to_cpu(req->ctx_ex.pa_num_ex);
+	u32 pa_num_max;
+	u32 pa_num_left = pa_num_total;
+	u32 pa_num, copy_len;
+	int in_len, err;
+
+	if (xdev->caps.max_cmd_in_len < sizeof(*in) + sizeof(__be64)) {
+		pci_err(xdev->pdev, "max_cmd_in_len %u too small for CQ PA list\n",
+			xdev->caps.max_cmd_in_len);
+		return -EINVAL;
+	}
+
+	pa_num_max = (xdev->caps.max_cmd_in_len - sizeof(*in)) / sizeof(__be64);
+
+	while (pa_num_left) {
+		pa_num = min(pa_num_max, pa_num_left);
+		copy_len = pa_num * sizeof(__be64);
+		in_len = sizeof(*in) + copy_len;
+
+		in = kvzalloc(in_len, GFP_KERNEL);
+		if (!in)
+			return -ENOMEM;
+
+		in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_SET_CQ_BUF_PA);
+		in->pa_list_start = cpu_to_be32(pa_list_base);
+		in->pa_num = cpu_to_be32(pa_num);
+		memcpy(in->pas, &req->pas[pa_num_total - pa_num_left], copy_len);
+		pa_num_left -= pa_num;
+		pa_list_base += pa_num;
+		memset(&out, 0, sizeof(out));
+
+		err = xsc_cmd_exec(xdev, in, in_len, &out, sizeof(out));
+		kvfree(in);
+
+		if (err || out.hdr.status) {
+			pci_err(xdev->pdev, "failed to set cq buf pa, cqn=%d\n", cqn);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int xsc_create_cq_compat(struct xsc_core_device *xdev,
+				struct xsc_create_cq_ex_mbox_in *in,
+				struct xsc_create_cq_mbox_out *out)
+{
+	struct xsc_create_cq_mbox_in *_in;
+	int _inlen = sizeof(*_in) +
+		be16_to_cpu(in->ctx_ex.ctx.pa_num) * sizeof(__be64);
+	int err;
+
+	_in = kvzalloc(_inlen, GFP_KERNEL);
+	if (!_in)
+		return -ENOMEM;
+
+	_in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_CQ);
+	memcpy(&_in->ctx, &in->ctx_ex.ctx, sizeof(_in->ctx));
+	memcpy(&_in->pas, &in->pas, _inlen - sizeof(*_in));
+	memset(out, 0, sizeof(*out));
+
+	err = xsc_cmd_exec(xdev, _in, _inlen, out, sizeof(*out));
+	kvfree(_in);
+
+	return err;
+}
+
+int xsc_core_create_cq(struct xsc_core_device *xdev, struct xsc_core_cq *cq,
+		       struct xsc_create_cq_ex_mbox_in *in, int inlen)
+{
+	struct xsc_cq_table *table = &xdev->dev_res->cq_table;
+	struct xsc_create_cq_mbox_out out;
+	u32 pa_list_base = 0;
+	u32 cqn = 0;
+	int err;
+
+	if (inlen < xdev->caps.max_cmd_in_len) {
+		in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_CQ_EX);
+		memset(&out, 0, sizeof(out));
+		err = xsc_cmd_exec(xdev, in, inlen, &out, sizeof(out));
+		if (err == -EOPNOTSUPP) {
+			err = xsc_create_cq_compat(xdev, in, &out);
+			if (err)
+				return err;
+		} else if (err) {
+			return err;
+		}
+
+		cqn = be32_to_cpu(out.cqn);
+	} else {
+		err = xsc_set_cq_context(xdev, &in->ctx_ex, &pa_list_base, &cqn);
+		if (err)
+			return err;
+
+		err = xsc_set_cq_buf_pa(xdev, in, pa_list_base, cqn);
+		if (err)
+			goto err_cmd;
+	}
+
+	cq->cqn = cqn;
+	cq->cons_index = 0;
+	cq->xdev = xdev;
+	cq->dev = xdev;
+	atomic_set(&cq->refcount, 1);
+	init_completion(&cq->free);
+
+	spin_lock_irq(&table->lock);
+	err = radix_tree_insert(&table->tree, cq->cqn, cq);
+	spin_unlock_irq(&table->lock);
+	if (err)
+		goto err_cmd;
+
+	xsc_arm_cq(xdev, cq->cqn, 0, 0);
+
+	cq->pid = current->pid;
+	return 0;
+
+err_cmd:
+	xsc_destroy_cq(xdev, cqn);
+	return err;
+}
+EXPORT_SYMBOL_GPL(xsc_core_create_cq);
+
+int xsc_core_destroy_cq(struct xsc_core_device *xdev, struct xsc_core_cq *cq)
+{
+	struct xsc_cq_table *table = &xdev->dev_res->cq_table;
+	struct xsc_destroy_cq_mbox_in in;
+	struct xsc_destroy_cq_mbox_out out;
+	struct xsc_core_cq *tmp;
+	int err;
+
+	spin_lock_irq(&table->lock);
+	tmp = radix_tree_delete(&table->tree, cq->cqn);
+	spin_unlock_irq(&table->lock);
+	if (!tmp || tmp != cq)
+		pci_warn(xdev->pdev, "cq 0x%x not found in tree\n", cq->cqn);
+
+	/* wait for lockless completion readers as in
+	 * xsc_core_eth_destroy_cq()
+	 */
+	synchronize_rcu();
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DESTROY_CQ);
+	in.cqn = cpu_to_be32(cq->cqn);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	if (atomic_dec_and_test(&cq->refcount))
+		complete(&cq->free);
+	wait_for_completion(&cq->free);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_destroy_cq);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
index 63e5bb29f..7c6e46741 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
@@ -53,16 +53,60 @@ static void eq_update_ci(struct xsc_eq *eq, int arm)
 
 static void xsc_cq_completion(struct xsc_core_device *xdev, u32 cqn)
 {
+	struct xsc_cq_table *table = &xdev->dev_res->cq_table;
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
 }
 
 static void xsc_eq_cq_event(struct xsc_core_device *xdev,
 			    u32 cqn, int event_type)
 {
+	struct xsc_cq_table *table = &xdev->dev_res->cq_table;
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
 }
 
 static int xsc_eq_int(struct xsc_core_device *xdev, struct xsc_eq *eq)
 {
-	u32 cqn, queue_id;
+	u32 cqn, qpn, queue_id;
 	struct xsc_eqe *eqe;
 	int eqes_found = 0;
 	int set_ci = 0;
@@ -88,6 +132,14 @@ static int xsc_eq_int(struct xsc_core_device *xdev, struct xsc_eq *eq)
 			cqn = queue_id;
 			xsc_eq_cq_event(xdev, cqn, eqe->type);
 			break;
+		case XSC_EVENT_TYPE_WQ_CATAS_ERROR:
+		case XSC_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+		case XSC_EVENT_TYPE_WQ_ACCESS_ERROR:
+			queue_id = FIELD_GET(XSC_EQE_QUEUE_ID_MASK,
+					     le16_to_cpu(eqe->queue_id_data));
+			qpn = queue_id;
+			xsc_qp_event(xdev, qpn, eqe->type);
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index 9548cb953..cb2f37395 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -195,6 +195,8 @@ static int xsc_hw_setup(struct xsc_core_device *xdev)
 		goto err_cmd_cleanup;
 	}
 
+	xsc_init_cq_table(xdev);
+	xsc_init_qp_table(xdev);
 	xsc_eq_init(xdev);
 
 	return 0;
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
new file mode 100644
index 000000000..bbcdb18e1
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.c
@@ -0,0 +1,355 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/gfp.h>
+#include <linux/time.h>
+#include <linux/export.h>
+#include <linux/kthread.h>
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd_api.h"
+#include "qp.h"
+
+int xsc_core_create_resource_common(struct xsc_core_device *xdev,
+				    struct xsc_core_qp *qp)
+{
+	struct xsc_qp_table *table = &xdev->dev_res->qp_table;
+	int err;
+
+	/* initialize before the insert: once in the tree, the qp can be
+	 * found and referenced by the async event handler
+	 */
+	atomic_set(&qp->refcount, 1);
+	init_completion(&qp->free);
+	qp->pid = current->pid;
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
+	struct xsc_qp_table *table = &xdev->dev_res->qp_table;
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
+	struct xsc_qp_table *table = &xdev->dev_res->qp_table;
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
+	struct xsc_qp_table *table = &xdev->dev_res->qp_table;
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
+	int ret = 0;
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
+
+int xsc_core_eth_create_rss_qp_rqs(struct xsc_core_device *xdev,
+				   struct xsc_create_multiqp_mbox_in *in,
+				   int insize,
+				   u32 *p_qpn_base)
+{
+	struct xsc_create_multiqp_mbox_out out = {};
+	int err;
+
+	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_MULTI_QP);
+	err = xsc_cmd_exec(xdev, in, insize, &out, sizeof(out));
+	if (err) {
+		pci_err(xdev->pdev,
+			"failed to create rss rq, qp_num=%d, type=%d, err=%d out.status=%u\n",
+			be16_to_cpu(in->qp_num), in->qp_type, err, out.hdr.status);
+		return err;
+	}
+
+	*p_qpn_base = be32_to_cpu(out.qpn_base) & 0xffffff;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_eth_create_rss_qp_rqs);
+
+int xsc_core_create_qp(struct xsc_core_device *xdev,
+		       struct xsc_core_qp *qp,
+		       struct xsc_create_qp_mbox_in *in,
+		       int inlen)
+{
+	struct xsc_create_qp_mbox_out out;
+	struct xsc_destroy_qp_mbox_in din;
+	struct xsc_destroy_qp_mbox_out dout;
+	int err;
+
+	memset(&out, 0, sizeof(out));
+	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_QP);
+
+	err = xsc_cmd_exec(xdev, in, inlen, &out, sizeof(out));
+	if (err)
+		return err;
+
+	qp->qpn = be32_to_cpu(out.qpn) & 0xffffff;
+
+	err = xsc_core_create_resource_common(xdev, qp);
+	if (err)
+		goto err_cmd;
+
+	atomic_inc(&xdev->num_qps);
+	return 0;
+
+err_cmd:
+	memset(&din, 0, sizeof(din));
+	memset(&dout, 0, sizeof(dout));
+	din.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DESTROY_QP);
+	din.qpn = cpu_to_be32(qp->qpn);
+	xsc_cmd_exec(xdev, &din, sizeof(din), &dout, sizeof(dout));
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(xsc_core_create_qp);
+
+int xsc_core_destroy_qp(struct xsc_core_device *xdev,
+			struct xsc_core_qp *qp)
+{
+	struct xsc_destroy_qp_mbox_in in;
+	struct xsc_destroy_qp_mbox_out out;
+	int err;
+
+	xsc_core_destroy_resource_common(xdev, qp);
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DESTROY_QP);
+	in.qpn = cpu_to_be32(qp->qpn);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	atomic_dec(&xdev->num_qps);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_destroy_qp);
+
+int xsc_core_qp_modify(struct xsc_core_device *xdev, enum xsc_qp_state cur_state,
+		       enum xsc_qp_state new_state,
+		       struct xsc_modify_qp_mbox_in *in,
+		       struct xsc_core_qp *qp)
+{
+	static const u16 optab[XSC_QP_NUM_STATE][XSC_QP_NUM_STATE] = {
+		[XSC_QP_STATE_RST] = {
+			[XSC_QP_STATE_RST]	= XSC_CMD_OP_2RST_QP,
+			[XSC_QP_STATE_ERR]	= XSC_CMD_OP_2ERR_QP,
+			[XSC_QP_STATE_INIT]	= XSC_CMD_OP_RST2INIT_QP,
+		},
+		[XSC_QP_STATE_INIT] = {
+			[XSC_QP_STATE_RST]	= XSC_CMD_OP_2RST_QP,
+			[XSC_QP_STATE_ERR]	= XSC_CMD_OP_2ERR_QP,
+			[XSC_QP_STATE_INIT]	= XSC_CMD_OP_INIT2INIT_QP,
+			[XSC_QP_STATE_RTR]	= XSC_CMD_OP_INIT2RTR_QP,
+		},
+		[XSC_QP_STATE_RTR] = {
+			[XSC_QP_STATE_RST]	= XSC_CMD_OP_2RST_QP,
+			[XSC_QP_STATE_ERR]	= XSC_CMD_OP_2ERR_QP,
+			[XSC_QP_STATE_RTS]	= XSC_CMD_OP_RTR2RTS_QP,
+		},
+		[XSC_QP_STATE_RTS] = {
+			[XSC_QP_STATE_RST]	= XSC_CMD_OP_2RST_QP,
+			[XSC_QP_STATE_ERR]	= XSC_CMD_OP_2ERR_QP,
+			[XSC_QP_STATE_RTS]	= XSC_CMD_OP_RTS2RTS_QP,
+			[XSC_QP_STATE_SQD]	= XSC_CMD_OP_RTS2SQD_QP,
+		},
+		[XSC_QP_STATE_SQD] = {
+			[XSC_QP_STATE_RST]	= XSC_CMD_OP_2RST_QP,
+			[XSC_QP_STATE_ERR]	= XSC_CMD_OP_2ERR_QP,
+			[XSC_QP_STATE_RTS]	= XSC_CMD_OP_SQD2RTS_QP,
+			[XSC_QP_STATE_SQD]	= XSC_CMD_OP_SQD2SQD_QP,
+		},
+		[XSC_QP_STATE_SQER] = {
+			[XSC_QP_STATE_RST]	= XSC_CMD_OP_2RST_QP,
+			[XSC_QP_STATE_ERR]	= XSC_CMD_OP_2ERR_QP,
+			[XSC_QP_STATE_RTS]	= XSC_CMD_OP_SQERR2RTS_QP,
+		},
+		[XSC_QP_STATE_ERR] = {
+			[XSC_QP_STATE_RST]	= XSC_CMD_OP_2RST_QP,
+			[XSC_QP_STATE_ERR]	= XSC_CMD_OP_2ERR_QP,
+		}
+	};
+
+	struct xsc_modify_qp_mbox_out out;
+	u16 op;
+
+	if (cur_state >= XSC_QP_NUM_STATE || new_state >= XSC_QP_NUM_STATE ||
+	    !optab[cur_state][new_state])
+		return -EINVAL;
+
+	memset(&out, 0, sizeof(out));
+	op = optab[cur_state][new_state];
+
+	if (new_state == XSC_QP_STATE_RTR) {
+		in->ctx.pcie_no = xdev->pcie_no;
+		in->ctx.func_id = cpu_to_be16(xdev->glb_func_id);
+	}
+
+	in->hdr.opcode = cpu_to_be16(op);
+	in->qpn = cpu_to_be32(qp->qpn);
+	in->no_need_wait = 1;
+
+	if (xsc_cmd_exec(xdev, in, sizeof(*in), &out, sizeof(out)))
+		return -ENOEXEC;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_qp_modify);
+
+int xsc_core_qp_query(struct xsc_core_device *xdev, struct xsc_core_qp *qp,
+		      struct xsc_query_qp_mbox_out *out, int outlen)
+{
+	struct xsc_query_qp_mbox_in in;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(out, 0, outlen);
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_QP);
+	in.qpn = cpu_to_be32(qp->qpn);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), out, outlen);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_qp_query);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
index 08af2008a..487e8b0c9 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
@@ -20,7 +20,7 @@ int xsc_core_destroy_qp(struct xsc_core_device *xdev,
 			struct xsc_core_qp *qp);
 int xsc_core_qp_modify(struct xsc_core_device *xdev, enum xsc_qp_state cur_state,
 		       enum xsc_qp_state new_state,
-		       struct xsc_modify_qp_mbox_in *in, int sqd_event,
+		       struct xsc_modify_qp_mbox_in *in,
 		       struct xsc_core_qp *qp);
 int xsc_core_qp_query(struct xsc_core_device *xdev, struct xsc_core_qp *qp,
 		      struct xsc_query_qp_mbox_out *out, int outlen);
-- 
2.18.4
