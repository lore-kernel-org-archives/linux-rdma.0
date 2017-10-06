From: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: [PATCH v2 12/13] SoftiWarp debugging code
Date: Fri,  6 Oct 2017 08:28:52 -0400
Message-ID: <20171006122853.16310-13-bmt@zurich.ibm.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
---
 drivers/infiniband/sw/siw/siw_debug.c | 442 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_debug.h | 178 ++++++++++++++
 2 files changed, 620 insertions(+)
 create mode 100644 drivers/infiniband/sw/siw/siw_debug.c
 create mode 100644 drivers/infiniband/sw/siw/siw_debug.h

diff --git a/drivers/infiniband/sw/siw/siw_debug.c b/drivers/infiniband/sw/siw/siw_debug.c
new file mode 100644
index 000000000000..d3df394b4828
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_debug.c
@@ -0,0 +1,442 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses. You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <net/tcp.h>
+#include <linux/list.h>
+#include <linux/debugfs.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_cm.h"
+#include "siw_obj.h"
+
+#define FDENTRY(f) (f->f_path.dentry)
+
+
+static struct dentry *siw_debugfs;
+
+static ssize_t siw_show_qps(struct file *f, char __user *buf, size_t space,
+			    loff_t *ppos)
+{
+	struct siw_dev	*sdev = FDENTRY(f)->d_inode->i_private;
+	struct list_head *pos, *tmp;
+	char *kbuf = NULL;
+	int len = 0, n, num_qp;
+
+	if (*ppos)
+		goto out;
+
+	kbuf = kmalloc(space, GFP_KERNEL);
+	if (!kbuf)
+		goto out;
+
+	num_qp = atomic_read(&sdev->num_qp);
+	if (!num_qp)
+		goto out;
+
+	len = snprintf(kbuf, space, "%s: %d QPs\n", sdev->ofa_dev.name, num_qp);
+	if (len > space) {
+		len = space;
+		goto out;
+	}
+	space -= len;
+	n = snprintf(kbuf + len, space,
+		     "%-15s%-6s%-6s%-5s%-5s%-5s%-5s%-5s%-20s%s\n",
+		     "QP-ID", "State", "Ref's", "SQ", "RQ", "IRQ", "ORQ",
+		     "s/r", "Sock", "CEP");
+
+	if (n > space) {
+		len += space;
+		goto out;
+	}
+	len += n;
+	space -= n;
+
+	list_for_each_safe(pos, tmp, &sdev->qp_list) {
+		struct siw_qp *qp = list_entry(pos, struct siw_qp, devq);
+
+		n = snprintf(kbuf + len, space,
+			"%-15d%-6d%-6d%-5d%-5d%-5d%-5d%d/%-3d0x%-18p0x%-18p\n",
+			     QP_ID(qp),
+			     qp->attrs.state,
+			     refcount_read(&qp->hdr.ref),
+			     qp->attrs.sq_size,
+			     qp->attrs.rq_size,
+			     qp->attrs.irq_size,
+			     qp->attrs.orq_size,
+			     tx_wqe(qp) ? 1 : 0,
+			     rx_wqe(qp) ? 1 : 0,
+			     qp->attrs.llp_stream_handle,
+			     qp->cep);
+		if (n < space) {
+			len += n;
+			space -= n;
+		} else {
+			len += space;
+			break;
+		}
+	}
+out:
+	if (len)
+		len = simple_read_from_buffer(buf, len, ppos, kbuf, len);
+
+	kfree(kbuf);
+
+	return len;
+};
+
+static ssize_t siw_show_ceps(struct file *f, char __user *buf, size_t space,
+			     loff_t *ppos)
+{
+	struct siw_dev	*sdev = FDENTRY(f)->d_inode->i_private;
+	struct list_head *pos, *tmp;
+	char *kbuf = NULL;
+	int len = 0, n, num_cep;
+
+	if (*ppos)
+		goto out;
+
+	kbuf = kmalloc(space, GFP_KERNEL);
+	if (!kbuf)
+		goto out;
+
+	num_cep = atomic_read(&sdev->num_cep);
+	if (!num_cep)
+		goto out;
+
+	len = snprintf(kbuf, space, "%s: %d CEPs\n", sdev->ofa_dev.name,
+		       num_cep);
+	if (len > space) {
+		len = space;
+		goto out;
+	}
+	space -= len;
+
+	n = snprintf(kbuf + len, space,
+		     "%-20s%-6s%-6s%-9s%-5s%-3s%-4s%-21s%-9s\n",
+		     "CEP", "State", "Ref's", "QP-ID", "LQ", "LC", "U", "Sock",
+		     "CM-ID");
+
+	if (n > space) {
+		len += space;
+		goto out;
+	}
+	len += n;
+	space -= n;
+
+	list_for_each_safe(pos, tmp, &sdev->cep_list) {
+		struct siw_cep *cep = list_entry(pos, struct siw_cep, devq);
+
+		n = snprintf(kbuf + len, space,
+			     "0x%-18p%-6d%-6d%-9d%-5s%-3s%-4d0x%-18p 0x%-16p\n",
+			     cep, cep->state,
+			     refcount_read(&cep->ref),
+			     cep->qp ? QP_ID(cep->qp) : -1,
+			     list_empty(&cep->listenq) ? "n" : "y",
+			     cep->listen_cep ? "y" : "n",
+			     cep->in_use,
+			     cep->llp.sock,
+			     cep->cm_id);
+		if (n < space) {
+			len += n;
+			space -= n;
+		} else {
+			len += space;
+			break;
+		}
+	}
+out:
+	if (len)
+		len = simple_read_from_buffer(buf, len, ppos, kbuf, len);
+
+	kfree(kbuf);
+
+	return len;
+};
+
+static ssize_t siw_show_stats(struct file *f, char __user *buf, size_t space,
+			      loff_t *ppos)
+{
+	struct siw_dev	*sdev = FDENTRY(f)->d_inode->i_private;
+	char *kbuf = NULL;
+	int len = 0;
+
+	if (*ppos)
+		goto out;
+
+	kbuf = kmalloc(space, GFP_KERNEL);
+	if (!kbuf)
+		goto out;
+
+	len =  snprintf(kbuf, space, "Allocated SIW Objects:\n"
+		"Device %s (%s):\t"
+		"%s: %d, %s %d, %s: %d, %s: %d, %s: %d, %s: %d, %s: %d\n",
+		sdev->ofa_dev.name,
+		sdev->netdev->flags & IFF_UP ? "IFF_UP" : "IFF_DOWN",
+		"CXs", atomic_read(&sdev->num_ctx),
+		"PDs", atomic_read(&sdev->num_pd),
+		"QPs", atomic_read(&sdev->num_qp),
+		"CQs", atomic_read(&sdev->num_cq),
+		"SRQs", atomic_read(&sdev->num_srq),
+		"MRs", atomic_read(&sdev->num_mem),
+		"CEPs", atomic_read(&sdev->num_cep));
+	if (len > space)
+		len = space;
+out:
+	if (len)
+		len = simple_read_from_buffer(buf, len, ppos, kbuf, len);
+
+	kfree(kbuf);
+	return len;
+}
+
+static const struct file_operations siw_qp_debug_fops = {
+	.owner	= THIS_MODULE,
+	.read	= siw_show_qps
+};
+
+static const struct file_operations siw_cep_debug_fops = {
+	.owner	= THIS_MODULE,
+	.read	= siw_show_ceps
+};
+
+static const struct file_operations siw_stats_debug_fops = {
+	.owner	= THIS_MODULE,
+	.read	= siw_show_stats
+};
+
+void siw_debugfs_add_device(struct siw_dev *sdev)
+{
+	struct dentry	*entry;
+
+	if (!siw_debugfs)
+		return;
+
+	sdev->debugfs = debugfs_create_dir(sdev->ofa_dev.name, siw_debugfs);
+	if (sdev->debugfs) {
+		entry = debugfs_create_file("qp", 0400, sdev->debugfs,
+					    (void *)sdev, &siw_qp_debug_fops);
+		if (!entry)
+			dprint(DBG_DM, ": could not create 'qp' entry\n");
+
+		entry = debugfs_create_file("cep", 0400, sdev->debugfs,
+					    (void *)sdev, &siw_cep_debug_fops);
+		if (!entry)
+			dprint(DBG_DM, ": could not create 'cep' entry\n");
+
+		entry = debugfs_create_file("stats", 0400, sdev->debugfs,
+					    (void *)sdev,
+					    &siw_stats_debug_fops);
+		if (!entry)
+			dprint(DBG_DM, ": could not create 'stats' entry\n");
+	}
+}
+
+void siw_debugfs_del_device(struct siw_dev *sdev)
+{
+	debugfs_remove_recursive(sdev->debugfs);
+	sdev->debugfs = NULL;
+}
+
+void siw_debug_init(void)
+{
+	siw_debugfs = debugfs_create_dir("siw", NULL);
+
+	if (!siw_debugfs || siw_debugfs == ERR_PTR(-ENODEV)) {
+		dprint(DBG_DM, ": could not init debugfs\n");
+		siw_debugfs = NULL;
+	}
+}
+
+void siw_debugfs_delete(void)
+{
+	debugfs_remove_recursive(siw_debugfs);
+	siw_debugfs = NULL;
+}
+
+void siw_print_qp_attr_mask(enum ib_qp_attr_mask attr_mask, char *msg)
+{
+	pr_info("-------- %s -------\n", msg);
+	if (IB_QP_STATE & attr_mask)
+		pr_info("IB_QP_STATE\n");
+	if (IB_QP_CUR_STATE & attr_mask)
+		pr_info("IB_QP_CUR_STATE\n");
+	if (IB_QP_EN_SQD_ASYNC_NOTIFY & attr_mask)
+		pr_info("IB_QP_EN_SQD_ASYNC_NOTIFY\n");
+	if (IB_QP_ACCESS_FLAGS & attr_mask)
+		pr_info("IB_QP_ACCESS_FLAGS\n");
+	if (IB_QP_PKEY_INDEX & attr_mask)
+		pr_info("IB_QP_PKEY_INDEX\n");
+	if (IB_QP_PORT & attr_mask)
+		pr_info("IB_QP_PORT\n");
+	if (IB_QP_QKEY & attr_mask)
+		pr_info("IB_QP_QKEY\n");
+	if (IB_QP_AV & attr_mask)
+		pr_info("IB_QP_AV\n");
+	if (IB_QP_PATH_MTU & attr_mask)
+		pr_info("IB_QP_PATH_MTU\n");
+	if (IB_QP_TIMEOUT & attr_mask)
+		pr_info("IB_QP_TIMEOUT\n");
+	if (IB_QP_RETRY_CNT & attr_mask)
+		pr_info("IB_QP_RETRY_CNT\n");
+	if (IB_QP_RNR_RETRY & attr_mask)
+		pr_info("IB_QP_RNR_RETRY\n");
+	if (IB_QP_RQ_PSN & attr_mask)
+		pr_info("IB_QP_RQ_PSN\n");
+	if (IB_QP_MAX_QP_RD_ATOMIC & attr_mask)
+		pr_info("IB_QP_MAX_QP_RD_ATOMIC\n");
+	if (IB_QP_ALT_PATH & attr_mask)
+		pr_info("IB_QP_ALT_PATH\n");
+	if (IB_QP_MIN_RNR_TIMER & attr_mask)
+		pr_info("IB_QP_MIN_RNR_TIMER\n");
+	if (IB_QP_SQ_PSN & attr_mask)
+		pr_info("IB_QP_SQ_PSN\n");
+	if (IB_QP_MAX_DEST_RD_ATOMIC & attr_mask)
+		pr_info("IB_QP_MAX_DEST_RD_ATOMIC\n");
+	if (IB_QP_PATH_MIG_STATE & attr_mask)
+		pr_info("IB_QP_PATH_MIG_STATE\n");
+	if (IB_QP_CAP & attr_mask)
+		pr_info("IB_QP_CAP\n");
+	if (IB_QP_DEST_QPN & attr_mask)
+		pr_info("IB_QP_DEST_QPN\n");
+	pr_info("-------- %s -(end)-\n", msg);
+}
+
+void siw_print_hdr(union iwarp_hdrs *hdr, int qp_id, char *msg)
+{
+	switch (__rdmap_opcode(&hdr->ctrl)) {
+
+	case RDMAP_RDMA_WRITE:
+		pr_info("QP%04d %s(WRITE, MPA len %d): %08x %016llx\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->rwrite.sink_stag, hdr->rwrite.sink_to);
+		break;
+
+	case RDMAP_RDMA_READ_REQ:
+		pr_info("QP%04d %s(RREQ, MPA len %d): %08x %08x %08x %08x %016llx %08x %08x %016llx\n",
+			qp_id, msg,
+			ntohs(hdr->ctrl.mpa_len),
+			hdr->rreq.ddp_qn, hdr->rreq.ddp_msn,
+			hdr->rreq.ddp_mo, hdr->rreq.sink_stag,
+			hdr->rreq.sink_to, hdr->rreq.read_size,
+			hdr->rreq.source_stag, hdr->rreq.source_to);
+
+		break;
+
+	case RDMAP_RDMA_READ_RESP:
+		pr_info("QP%04d %s(RRESP, MPA len %d): %08x %016llx\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->rresp.sink_stag, hdr->rresp.sink_to);
+		break;
+
+	case RDMAP_SEND:
+		pr_info("QP%04d %s(SEND, MPA len %d): %08x %08x %08x\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->send.ddp_qn, hdr->send.ddp_msn, hdr->send.ddp_mo);
+		break;
+
+	case RDMAP_SEND_INVAL:
+		pr_info("QP%04d %s(S_INV, MPA len %d): %08x %08x %08x\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->send.ddp_qn, hdr->send.ddp_msn,
+			hdr->send.ddp_mo);
+		break;
+
+	case RDMAP_SEND_SE:
+		pr_info("QP%04d %s(S_SE, MPA len %d): %08x %08x %08x\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->send.ddp_qn, hdr->send.ddp_msn,
+			hdr->send.ddp_mo);
+		break;
+
+	case RDMAP_SEND_SE_INVAL:
+		pr_info("QP%04d %s(S_SE_INV, MPA len %d): %08x %08x %08x\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->send.ddp_qn, hdr->send.ddp_msn,
+			hdr->send.ddp_mo);
+		break;
+
+	case RDMAP_TERMINATE:
+		pr_info("QP%04d %s(TERM, MPA len %d):\n", qp_id, msg,
+			ntohs(hdr->ctrl.mpa_len));
+		break;
+
+	default:
+		pr_info("QP%04d %s ?????\n", qp_id, msg);
+		break;
+	}
+}
+
+void siw_print_rctx(struct siw_iwarp_rx *rctx)
+{
+	pr_info("---RX Context---\n");
+	siw_print_hdr(&rctx->hdr, RX_QPID(rctx), "\nCurrent Pkt:\t");
+	pr_info("Skbuf State:\tp:0x%p, new:%d, off:%d, copied:%d\n",
+		rctx->skb, rctx->skb_new, rctx->skb_offset, rctx->skb_copied);
+	pr_info("FPDU State:\trx_state:%d,\n\t\trcvd:%d, rem:%d, pad:%d\n",
+		rctx->state, rctx->fpdu_part_rcvd,
+		rctx->fpdu_part_rem, rctx->pad);
+	pr_info("Rx Mem:\t\tp:0x%p, stag:0x%08x, mem_id:%d\n",
+		&rctx->wqe_active, rctx->ddp_stag, rctx->ddp_stag >> 8);
+	pr_info("DDP State:\tprev_op:%d, first_seg:%d, more_segs:%d\n",
+		rctx->prev_rdmap_opcode, rctx->first_ddp_seg,
+		rctx->more_ddp_segs);
+	pr_info("MPA State:\tlen:%d, crc_enabled:%d, crc:0x%x\n",
+		ntohs(rctx->hdr.ctrl.mpa_len), rctx->mpa_crc_hd ? 1 : 0,
+		rctx->trailer.crc);
+	pr_info("----------------\n");
+}
+
+#if DPRINT_MASK > 0
+char ib_qp_state_to_string[IB_QPS_ERR+1][sizeof "RESET"] = {
+	[IB_QPS_RESET]	= "RESET",
+	[IB_QPS_INIT]	= "INIT",
+	[IB_QPS_RTR]	= "RTR",
+	[IB_QPS_RTS]	= "RTS",
+	[IB_QPS_SQD]	= "SQD",
+	[IB_QPS_SQE]	= "SQE",
+	[IB_QPS_ERR]	= "ERR"
+};
+#endif
diff --git a/drivers/infiniband/sw/siw/siw_debug.h b/drivers/infiniband/sw/siw/siw_debug.h
new file mode 100644
index 000000000000..0adc8f3467f7
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_debug.h
@@ -0,0 +1,178 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses. You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _SIW_DEBUG_H
+#define _SIW_DEBUG_H
+
+#include <linux/uaccess.h>
+#include <linux/hardirq.h>	/* in_interrupt() */
+
+/*
+ * dprint: Selective debug printing
+ *
+ * Use an OR combination of DBG_* as dbgcat in dprint*(dbgcat,...)
+ * to assign debug messages to categories:
+ *
+ * dbgcat	Debug message belongs to category
+ * ----------------------------------------------------------------------------
+ * DBG_ON	Always on, for really important events or error conditions
+ * DBG_TMP	Temporarily on for fine-grained debugging
+ * DBQ_OBJ	Object management (object construction/destruction/refcounting)
+ * DBG_MM	Memory management
+ * DBG_EH	Event handling (completion events and asynchronous events)
+ * DBG_CM	Connection management, QP states
+ * DBG_WR	Work requests
+ * DBG_TX	iWARP TX path
+ * DBG_RX	iWARP RX path
+ * DBG_SK	Socket operations
+ * DBG_IRQ	Interrupt context (SoftIRQ or HardIRQ)
+ * DBG_DM	Device management
+ * DBG_HDR	Packet HDRs
+ * DBG_ALL	All categories above
+ */
+#define DBG_OFF		0
+#define DBG_ON		0x00000001
+#define DBG_TMP		0x00000002
+#define DBG_OBJ		0x00000004
+#define DBG_MM		0x00000008
+#define DBG_EH		0x00000010
+#define DBG_CM		0x00000020
+#define DBG_WR		0x00000040
+#define DBG_TX		0x00000080
+#define DBG_RX		0x00000100
+#define DBG_SK		0x00000200
+#define DBG_IRQ		0x00000800
+#define DBG_DM		0x00001000
+#define DBG_HDR		0x00002000
+#define DBG_CQ		0x00004000
+#define DBG_ALL		(DBG_IRQ|DBG_SK|DBG_RX|DBG_TX|DBG_WR|\
+			DBG_CM|DBG_EH|DBG_MM|DBG_OBJ|DBG_TMP|\
+			DBG_DM|DBG_ON|DBG_HDR|DBG_CQ)
+#define DBG_ALL_NOHDR	(DBG_IRQ|DBG_SK|DBG_RX|DBG_TX|DBG_WR|\
+			DBG_CM|DBG_EH|DBG_MM|DBG_OBJ|DBG_TMP|\
+			DBG_DM|DBG_ON)
+#define DBG_CTRL	(DBG_ON|DBG_CM|DBG_DM)
+
+/*
+ * Set DPRINT_MASK to tailor your debugging needs:
+ *
+ * DPRINT_MASK value		Enables debug messages for
+ * ---------------------------------------------------------------------
+ * DBG_ON			Important events / error conditions only
+ *				(minimum number of debug messages)
+ * OR-ed combination of DBG_*	Selective debugging
+ * DBG_TX|DBG_ON		+ transmit path
+ * DBG_ALL			All categories
+ */
+#define DPRINT_MASK	(DBG_ON)
+
+struct siw_dev;
+struct siw_iwarp_rx;
+union iwarp_hdrs;
+
+extern void siw_debug_init(void);
+extern void siw_debugfs_add_device(struct siw_dev *dev);
+extern void siw_debugfs_del_device(struct siw_dev *dev);
+extern void siw_debugfs_delete(void);
+
+extern void siw_print_hdr(union iwarp_hdrs *hdr, int id, char *msg);
+extern void siw_print_rctx(struct siw_iwarp_rx *rctx);
+extern void siw_print_qp_attr_mask(enum ib_qp_attr_mask mask, char *msg);
+
+#ifndef refcount_read
+#define refcount_read(x)	atomic_read(x.refcount.refs)
+#endif
+
+#if DPRINT_MASK > 0
+
+/**
+ * dprint - Selective debug print for process, SoftIRQ or HardIRQ context
+ *
+ * Debug print with selectable debug categories,
+ * starting with header
+ * - "( pid /cpu) __func__" for process context
+ * - "( irq /cpu) __func__" for IRQ context
+ *
+ * @dbgcat	: Set of debug categories (OR-ed combination of DBG_* above),
+ *		  to which this debug message is assigned.
+ * @fmt		: printf compliant format string
+ * @args	: printf compliant argument list
+ */
+#define dprint(dbgcat, fmt, args...)				\
+	do {							\
+		if ((dbgcat) & DPRINT_MASK) {			\
+			if (!in_interrupt())			\
+				pr_info("(%5d/%1d) %s" fmt,	\
+					current->pid,		\
+					current->on_cpu,	\
+					__func__, ## args);	\
+			else					\
+				pr_info("( irq /%1d) %s" fmt,	\
+					current->on_cpu,	\
+					__func__, ## args);	\
+		}						\
+	} while (0)
+
+
+#define siw_dprint_rctx(r)	siw_print_rctx(r)
+
+extern char ib_qp_state_to_string[IB_QPS_ERR+1][sizeof "RESET"];
+
+#else
+
+#define dprint(dbgcat, fmt, args...)	do { } while (0)
+#define siw_dprint_rctx(r)	do { } while (0)
+
+#endif
+
+
+#if DPRINT_MASK & DBG_HDR
+#define siw_dprint_hdr(h, i, m)	siw_print_hdr(h, i, m)
+#else
+#define siw_dprint_hdr(h, i, m)	do { } while (0)
+#endif
+
+#if DPRINT_MASK & DBG_CM
+#define siw_dprint_qp_attr_mask(mask)\
+		siw_print_qp_attr_mask(mask, (char *)__func__)
+#else
+#define siw_dprint_qp_attr_mask(mask)	do { } while (0)
+#endif
+
+#endif
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
