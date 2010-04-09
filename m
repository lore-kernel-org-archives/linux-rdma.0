From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2 02/10] iw_cxgb4: Add driver, fw, and hw headers.
Date: Fri, 09 Apr 2010 15:53:47 -0500
Message-ID: <20100409205347.9813.86359.stgit@build.ogc.int>
References: <20100409205336.9813.84868.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100409205336.9813.84868.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |  742 +++++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/t4.h          |  536 +++++++++++++++++++
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |  798 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/user.h        |   66 ++
 4 files changed, 2142 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb4/iw_cxgb4.h
 create mode 100644 drivers/infiniband/hw/cxgb4/t4.h
 create mode 100644 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
 create mode 100644 drivers/infiniband/hw/cxgb4/user.h

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
new file mode 100644
index 0000000..f1d3c33
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -0,0 +1,742 @@
+/*
+ * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *      - Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef __IW_CXGB4_H__
+#define __IW_CXGB4_H__
+
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#include <linux/workqueue.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/inet.h>
+#include <linux/wait.h>
+#include <linux/kref.h>
+#include <linux/timer.h>
+#include <linux/io.h>
+#include <linux/kfifo.h>
+
+#include <asm/byteorder.h>
+
+#include <net/net_namespace.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/iw_cm.h>
+
+#include "cxgb4.h"
+#include "cxgb4_uld.h"
+#include "l2t.h"
+#include "user.h"
+
+#define DRV_NAME "iw_cxgb4"
+#define MOD DRV_NAME ":"
+
+extern int c4iw_debug;
+#define PDBG(fmt, args...) \
+do { \
+	if (c4iw_debug) \
+		printk(MOD fmt, ## args); \
+} while (0)
+
+#include "t4.h"
+
+#define PBL_OFF(rdev_p, a) ((a) - (rdev_p)->lldi.vr->pbl.start)
+#define RQT_OFF(rdev_p, a) ((a) - (rdev_p)->lldi.vr->rq.start)
+
+static inline void *cplhdr(struct sk_buff *skb)
+{
+	return skb->data;
+}
+
+#define C4IW_WR_TO (10*HZ)
+
+struct c4iw_wr_wait {
+	wait_queue_head_t wait;
+	int done;
+	int ret;
+};
+
+static inline void c4iw_init_wr_wait(struct c4iw_wr_wait *wr_waitp)
+{
+	wr_waitp->ret = 0;
+	wr_waitp->done = 0;
+	init_waitqueue_head(&wr_waitp->wait);
+}
+
+struct c4iw_resource {
+	struct kfifo tpt_fifo;
+	spinlock_t tpt_fifo_lock;
+	struct kfifo qid_fifo;
+	spinlock_t qid_fifo_lock;
+	struct kfifo pdid_fifo;
+	spinlock_t pdid_fifo_lock;
+};
+
+struct c4iw_qid_list {
+	struct list_head entry;
+	u32 qid;
+};
+
+struct c4iw_dev_ucontext {
+	struct list_head qpids;
+	struct list_head cqids;
+	struct mutex lock;
+};
+
+enum c4iw_rdev_flags {
+	T4_FATAL_ERROR = (1<<0),
+};
+
+struct c4iw_rdev {
+	struct c4iw_resource resource;
+	unsigned long qpshift;
+	u32 qpmask;
+	unsigned long cqshift;
+	u32 cqmask;
+	struct c4iw_dev_ucontext uctx;
+	struct gen_pool *pbl_pool;
+	struct gen_pool *rqt_pool;
+	u32 flags;
+	struct cxgb4_lld_info lldi;
+};
+
+static inline int c4iw_fatal_error(struct c4iw_rdev *rdev)
+{
+	return rdev->flags & T4_FATAL_ERROR;
+}
+
+static inline int c4iw_num_stags(struct c4iw_rdev *rdev)
+{
+	return min((int)T4_MAX_NUM_STAG, (int)(rdev->lldi.vr->stag.size >> 5));
+}
+
+struct c4iw_dev {
+	struct ib_device ibdev;
+	struct c4iw_rdev rdev;
+	u32 device_cap_flags;
+	struct idr cqidr;
+	struct idr qpidr;
+	struct idr mmidr;
+	spinlock_t lock;
+	struct list_head entry;
+	struct delayed_work db_drop_task;
+	struct dentry *debugfs_root;
+};
+
+static inline struct c4iw_dev *to_c4iw_dev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct c4iw_dev, ibdev);
+}
+
+static inline struct c4iw_dev *rdev_to_c4iw_dev(struct c4iw_rdev *rdev)
+{
+	return container_of(rdev, struct c4iw_dev, rdev);
+}
+
+static inline struct c4iw_cq *get_chp(struct c4iw_dev *rhp, u32 cqid)
+{
+	return idr_find(&rhp->cqidr, cqid);
+}
+
+static inline struct c4iw_qp *get_qhp(struct c4iw_dev *rhp, u32 qpid)
+{
+	return idr_find(&rhp->qpidr, qpid);
+}
+
+static inline struct c4iw_mr *get_mhp(struct c4iw_dev *rhp, u32 mmid)
+{
+	return idr_find(&rhp->mmidr, mmid);
+}
+
+static inline int insert_handle(struct c4iw_dev *rhp, struct idr *idr,
+				void *handle, u32 id)
+{
+	int ret;
+	int newid;
+
+	do {
+		if (!idr_pre_get(idr, GFP_KERNEL))
+			return -ENOMEM;
+		spin_lock_irq(&rhp->lock);
+		ret = idr_get_new_above(idr, handle, id, &newid);
+		BUG_ON(newid != id);
+		spin_unlock_irq(&rhp->lock);
+	} while (ret == -EAGAIN);
+
+	return ret;
+}
+
+static inline void remove_handle(struct c4iw_dev *rhp, struct idr *idr, u32 id)
+{
+	spin_lock_irq(&rhp->lock);
+	idr_remove(idr, id);
+	spin_unlock_irq(&rhp->lock);
+}
+
+struct c4iw_pd {
+	struct ib_pd ibpd;
+	u32 pdid;
+	struct c4iw_dev *rhp;
+};
+
+static inline struct c4iw_pd *to_c4iw_pd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct c4iw_pd, ibpd);
+}
+
+struct tpt_attributes {
+	u64 len;
+	u64 va_fbo;
+	enum fw_ri_mem_perms perms;
+	u32 stag;
+	u32 pdid;
+	u32 qpid;
+	u32 pbl_addr;
+	u32 pbl_size;
+	u32 state:1;
+	u32 type:2;
+	u32 rsvd:1;
+	u32 remote_invaliate_disable:1;
+	u32 zbva:1;
+	u32 mw_bind_enable:1;
+	u32 page_size:5;
+};
+
+struct c4iw_mr {
+	struct ib_mr ibmr;
+	struct ib_umem *umem;
+	struct c4iw_dev *rhp;
+	u64 kva;
+	struct tpt_attributes attr;
+};
+
+static inline struct c4iw_mr *to_c4iw_mr(struct ib_mr *ibmr)
+{
+	return container_of(ibmr, struct c4iw_mr, ibmr);
+}
+
+struct c4iw_mw {
+	struct ib_mw ibmw;
+	struct c4iw_dev *rhp;
+	u64 kva;
+	struct tpt_attributes attr;
+};
+
+static inline struct c4iw_mw *to_c4iw_mw(struct ib_mw *ibmw)
+{
+	return container_of(ibmw, struct c4iw_mw, ibmw);
+}
+
+struct c4iw_fr_page_list {
+	struct ib_fast_reg_page_list ibpl;
+	DECLARE_PCI_UNMAP_ADDR(mapping);
+	dma_addr_t dma_addr;
+	struct c4iw_dev *dev;
+	int size;
+};
+
+static inline struct c4iw_fr_page_list *to_c4iw_fr_page_list(
+					struct ib_fast_reg_page_list *ibpl)
+{
+	return container_of(ibpl, struct c4iw_fr_page_list, ibpl);
+}
+
+struct c4iw_cq {
+	struct ib_cq ibcq;
+	struct c4iw_dev *rhp;
+	struct t4_cq cq;
+	spinlock_t lock;
+	atomic_t refcnt;
+	wait_queue_head_t wait;
+};
+
+static inline struct c4iw_cq *to_c4iw_cq(struct ib_cq *ibcq)
+{
+	return container_of(ibcq, struct c4iw_cq, ibcq);
+}
+
+struct c4iw_mpa_attributes {
+	u8 initiator;
+	u8 recv_marker_enabled;
+	u8 xmit_marker_enabled;
+	u8 crc_enabled;
+	u8 version;
+};
+
+struct c4iw_qp_attributes {
+	u32 scq;
+	u32 rcq;
+	u32 sq_num_entries;
+	u32 rq_num_entries;
+	u32 sq_max_sges;
+	u32 sq_max_sges_rdma_write;
+	u32 rq_max_sges;
+	u32 state;
+	u8 enable_rdma_read;
+	u8 enable_rdma_write;
+	u8 enable_bind;
+	u8 enable_mmid0_fastreg;
+	u32 max_ord;
+	u32 max_ird;
+	u32 pd;
+	u32 next_state;
+	char terminate_buffer[52];
+	u32 terminate_msg_len;
+	u8 is_terminate_local;
+	struct c4iw_mpa_attributes mpa_attr;
+	struct c4iw_ep *llp_stream_handle;
+};
+
+struct c4iw_qp {
+	struct ib_qp ibqp;
+	struct c4iw_dev *rhp;
+	struct c4iw_ep *ep;
+	struct c4iw_qp_attributes attr;
+	struct t4_wq wq;
+	spinlock_t lock;
+	atomic_t refcnt;
+	wait_queue_head_t wait;
+	struct timer_list timer;
+};
+
+static inline struct c4iw_qp *to_c4iw_qp(struct ib_qp *ibqp)
+{
+	return container_of(ibqp, struct c4iw_qp, ibqp);
+}
+
+struct c4iw_ucontext {
+	struct ib_ucontext ibucontext;
+	struct c4iw_dev_ucontext uctx;
+	u32 key;
+	spinlock_t mmap_lock;
+	struct list_head mmaps;
+};
+
+static inline struct c4iw_ucontext *to_c4iw_ucontext(struct ib_ucontext *c)
+{
+	return container_of(c, struct c4iw_ucontext, ibucontext);
+}
+
+struct c4iw_mm_entry {
+	struct list_head entry;
+	u64 addr;
+	u32 key;
+	unsigned len;
+};
+
+static inline struct c4iw_mm_entry *remove_mmap(struct c4iw_ucontext *ucontext,
+						u32 key, unsigned len)
+{
+	struct list_head *pos, *nxt;
+	struct c4iw_mm_entry *mm;
+
+	spin_lock(&ucontext->mmap_lock);
+	list_for_each_safe(pos, nxt, &ucontext->mmaps) {
+
+		mm = list_entry(pos, struct c4iw_mm_entry, entry);
+		if (mm->key == key && mm->len == len) {
+			list_del_init(&mm->entry);
+			spin_unlock(&ucontext->mmap_lock);
+			PDBG("%s key 0x%x addr 0x%llx len %d\n", __func__,
+			     key, (unsigned long long) mm->addr, mm->len);
+			return mm;
+		}
+	}
+	spin_unlock(&ucontext->mmap_lock);
+	return NULL;
+}
+
+static inline void insert_mmap(struct c4iw_ucontext *ucontext,
+			       struct c4iw_mm_entry *mm)
+{
+	spin_lock(&ucontext->mmap_lock);
+	PDBG("%s key 0x%x addr 0x%llx len %d\n", __func__,
+	     mm->key, (unsigned long long) mm->addr, mm->len);
+	list_add_tail(&mm->entry, &ucontext->mmaps);
+	spin_unlock(&ucontext->mmap_lock);
+}
+
+enum c4iw_qp_attr_mask {
+	C4IW_QP_ATTR_NEXT_STATE = 1 << 0,
+	C4IW_QP_ATTR_ENABLE_RDMA_READ = 1 << 7,
+	C4IW_QP_ATTR_ENABLE_RDMA_WRITE = 1 << 8,
+	C4IW_QP_ATTR_ENABLE_RDMA_BIND = 1 << 9,
+	C4IW_QP_ATTR_MAX_ORD = 1 << 11,
+	C4IW_QP_ATTR_MAX_IRD = 1 << 12,
+	C4IW_QP_ATTR_LLP_STREAM_HANDLE = 1 << 22,
+	C4IW_QP_ATTR_STREAM_MSG_BUFFER = 1 << 23,
+	C4IW_QP_ATTR_MPA_ATTR = 1 << 24,
+	C4IW_QP_ATTR_QP_CONTEXT_ACTIVATE = 1 << 25,
+	C4IW_QP_ATTR_VALID_MODIFY = (C4IW_QP_ATTR_ENABLE_RDMA_READ |
+				     C4IW_QP_ATTR_ENABLE_RDMA_WRITE |
+				     C4IW_QP_ATTR_MAX_ORD |
+				     C4IW_QP_ATTR_MAX_IRD |
+				     C4IW_QP_ATTR_LLP_STREAM_HANDLE |
+				     C4IW_QP_ATTR_STREAM_MSG_BUFFER |
+				     C4IW_QP_ATTR_MPA_ATTR |
+				     C4IW_QP_ATTR_QP_CONTEXT_ACTIVATE)
+};
+
+int c4iw_modify_qp(struct c4iw_dev *rhp,
+				struct c4iw_qp *qhp,
+				enum c4iw_qp_attr_mask mask,
+				struct c4iw_qp_attributes *attrs,
+				int internal);
+
+enum c4iw_qp_state {
+	C4IW_QP_STATE_IDLE,
+	C4IW_QP_STATE_RTS,
+	C4IW_QP_STATE_ERROR,
+	C4IW_QP_STATE_TERMINATE,
+	C4IW_QP_STATE_CLOSING,
+	C4IW_QP_STATE_TOT
+};
+
+static inline int c4iw_convert_state(enum ib_qp_state ib_state)
+{
+	switch (ib_state) {
+	case IB_QPS_RESET:
+	case IB_QPS_INIT:
+		return C4IW_QP_STATE_IDLE;
+	case IB_QPS_RTS:
+		return C4IW_QP_STATE_RTS;
+	case IB_QPS_SQD:
+		return C4IW_QP_STATE_CLOSING;
+	case IB_QPS_SQE:
+		return C4IW_QP_STATE_TERMINATE;
+	case IB_QPS_ERR:
+		return C4IW_QP_STATE_ERROR;
+	default:
+		return -1;
+	}
+}
+
+static inline u32 c4iw_ib_to_tpt_access(int a)
+{
+	return (a & IB_ACCESS_REMOTE_WRITE ? FW_RI_MEM_ACCESS_REM_WRITE : 0) |
+	       (a & IB_ACCESS_REMOTE_READ ? FW_RI_MEM_ACCESS_REM_READ : 0) |
+	       (a & IB_ACCESS_LOCAL_WRITE ? FW_RI_MEM_ACCESS_LOCAL_WRITE : 0) |
+	       FW_RI_MEM_ACCESS_LOCAL_READ;
+}
+
+static inline u32 c4iw_ib_to_tpt_bind_access(int acc)
+{
+	return (acc & IB_ACCESS_REMOTE_WRITE ? FW_RI_MEM_ACCESS_REM_WRITE : 0) |
+	       (acc & IB_ACCESS_REMOTE_READ ? FW_RI_MEM_ACCESS_REM_READ : 0);
+}
+
+enum c4iw_mmid_state {
+	C4IW_STAG_STATE_VALID,
+	C4IW_STAG_STATE_INVALID
+};
+
+#define C4IW_NODE_DESC "cxgb4 Chelsio Communications"
+
+#define MPA_KEY_REQ "MPA ID Req Frame"
+#define MPA_KEY_REP "MPA ID Rep Frame"
+
+#define MPA_MAX_PRIVATE_DATA	256
+#define MPA_REJECT		0x20
+#define MPA_CRC			0x40
+#define MPA_MARKERS		0x80
+#define MPA_FLAGS_MASK		0xE0
+
+#define c4iw_put_ep(ep) { \
+	PDBG("put_ep (via %s:%u) ep %p refcnt %d\n", __func__, __LINE__,  \
+	     ep, atomic_read(&((ep)->kref.refcount))); \
+	WARN_ON(atomic_read(&((ep)->kref.refcount)) < 1); \
+	kref_put(&((ep)->kref), _c4iw_free_ep); \
+}
+
+#define c4iw_get_ep(ep) { \
+	PDBG("get_ep (via %s:%u) ep %p, refcnt %d\n", __func__, __LINE__, \
+	     ep, atomic_read(&((ep)->kref.refcount))); \
+	kref_get(&((ep)->kref));  \
+}
+void _c4iw_free_ep(struct kref *kref);
+
+struct mpa_message {
+	u8 key[16];
+	u8 flags;
+	u8 revision;
+	__be16 private_data_size;
+	u8 private_data[0];
+};
+
+struct terminate_message {
+	u8 layer_etype;
+	u8 ecode;
+	__be16 hdrct_rsvd;
+	u8 len_hdrs[0];
+};
+
+#define TERM_MAX_LENGTH (sizeof(struct terminate_message) + 2 + 18 + 28)
+
+enum c4iw_layers_types {
+	LAYER_RDMAP		= 0x00,
+	LAYER_DDP		= 0x10,
+	LAYER_MPA		= 0x20,
+	RDMAP_LOCAL_CATA	= 0x00,
+	RDMAP_REMOTE_PROT	= 0x01,
+	RDMAP_REMOTE_OP		= 0x02,
+	DDP_LOCAL_CATA		= 0x00,
+	DDP_TAGGED_ERR		= 0x01,
+	DDP_UNTAGGED_ERR	= 0x02,
+	DDP_LLP			= 0x03
+};
+
+enum c4iw_rdma_ecodes {
+	RDMAP_INV_STAG		= 0x00,
+	RDMAP_BASE_BOUNDS	= 0x01,
+	RDMAP_ACC_VIOL		= 0x02,
+	RDMAP_STAG_NOT_ASSOC	= 0x03,
+	RDMAP_TO_WRAP		= 0x04,
+	RDMAP_INV_VERS		= 0x05,
+	RDMAP_INV_OPCODE	= 0x06,
+	RDMAP_STREAM_CATA	= 0x07,
+	RDMAP_GLOBAL_CATA	= 0x08,
+	RDMAP_CANT_INV_STAG	= 0x09,
+	RDMAP_UNSPECIFIED	= 0xff
+};
+
+enum c4iw_ddp_ecodes {
+	DDPT_INV_STAG		= 0x00,
+	DDPT_BASE_BOUNDS	= 0x01,
+	DDPT_STAG_NOT_ASSOC	= 0x02,
+	DDPT_TO_WRAP		= 0x03,
+	DDPT_INV_VERS		= 0x04,
+	DDPU_INV_QN		= 0x01,
+	DDPU_INV_MSN_NOBUF	= 0x02,
+	DDPU_INV_MSN_RANGE	= 0x03,
+	DDPU_INV_MO		= 0x04,
+	DDPU_MSG_TOOBIG		= 0x05,
+	DDPU_INV_VERS		= 0x06
+};
+
+enum c4iw_mpa_ecodes {
+	MPA_CRC_ERR		= 0x02,
+	MPA_MARKER_ERR		= 0x03
+};
+
+enum c4iw_ep_state {
+	IDLE = 0,
+	LISTEN,
+	CONNECTING,
+	MPA_REQ_WAIT,
+	MPA_REQ_SENT,
+	MPA_REQ_RCVD,
+	MPA_REP_SENT,
+	FPDU_MODE,
+	ABORTING,
+	CLOSING,
+	MORIBUND,
+	DEAD,
+};
+
+enum c4iw_ep_flags {
+	PEER_ABORT_IN_PROGRESS	= 0,
+	ABORT_REQ_IN_PROGRESS	= 1,
+	RELEASE_RESOURCES	= 2,
+	CLOSE_SENT		= 3,
+};
+
+struct c4iw_ep_common {
+	struct iw_cm_id *cm_id;
+	struct c4iw_qp *qp;
+	struct c4iw_dev *dev;
+	enum c4iw_ep_state state;
+	struct kref kref;
+	spinlock_t lock;
+	struct sockaddr_in local_addr;
+	struct sockaddr_in remote_addr;
+	wait_queue_head_t waitq;
+	int rpl_done;
+	int rpl_err;
+	unsigned long flags;
+};
+
+struct c4iw_listen_ep {
+	struct c4iw_ep_common com;
+	unsigned int stid;
+	int backlog;
+};
+
+struct c4iw_ep {
+	struct c4iw_ep_common com;
+	struct c4iw_ep *parent_ep;
+	struct timer_list timer;
+	unsigned int atid;
+	u32 hwtid;
+	u32 snd_seq;
+	u32 rcv_seq;
+	struct l2t_entry *l2t;
+	struct dst_entry *dst;
+	struct sk_buff *mpa_skb;
+	struct c4iw_mpa_attributes mpa_attr;
+	u8 mpa_pkt[sizeof(struct mpa_message) + MPA_MAX_PRIVATE_DATA];
+	unsigned int mpa_pkt_len;
+	u32 ird;
+	u32 ord;
+	u32 smac_idx;
+	u32 tx_chan;
+	u32 mtu;
+	u16 mss;
+	u16 emss;
+	u16 plen;
+	u16 rss_qid;
+	u16 txq_idx;
+	u8 tos;
+};
+
+static inline struct c4iw_ep *to_ep(struct iw_cm_id *cm_id)
+{
+	return cm_id->provider_data;
+}
+
+static inline struct c4iw_listen_ep *to_listen_ep(struct iw_cm_id *cm_id)
+{
+	return cm_id->provider_data;
+}
+
+static inline int compute_wscale(int win)
+{
+	int wscale = 0;
+
+	while (wscale < 14 && (65535<<wscale) < win)
+		wscale++;
+	return wscale;
+}
+
+typedef int (*c4iw_handler_func)(struct c4iw_dev *dev, struct sk_buff *skb);
+
+int c4iw_ep_redirect(void *ctx, struct dst_entry *old, struct dst_entry *new,
+		     struct l2t_entry *l2t);
+void c4iw_put_qpid(struct c4iw_rdev *rdev, u32 qpid,
+		   struct c4iw_dev_ucontext *uctx);
+u32 c4iw_get_resource(struct kfifo *fifo, spinlock_t *lock);
+void c4iw_put_resource(struct kfifo *fifo, u32 entry, spinlock_t *lock);
+int c4iw_init_resource(struct c4iw_rdev *rdev, u32 nr_tpt, u32 nr_pdid);
+int c4iw_init_ctrl_qp(struct c4iw_rdev *rdev);
+int c4iw_pblpool_create(struct c4iw_rdev *rdev);
+int c4iw_rqtpool_create(struct c4iw_rdev *rdev);
+void c4iw_pblpool_destroy(struct c4iw_rdev *rdev);
+void c4iw_rqtpool_destroy(struct c4iw_rdev *rdev);
+void c4iw_destroy_resource(struct c4iw_resource *rscp);
+int c4iw_destroy_ctrl_qp(struct c4iw_rdev *rdev);
+int c4iw_register_device(struct c4iw_dev *dev);
+void c4iw_unregister_device(struct c4iw_dev *dev);
+int __init c4iw_cm_init(void);
+void __exit c4iw_cm_term(void);
+void c4iw_release_dev_ucontext(struct c4iw_rdev *rdev,
+			       struct c4iw_dev_ucontext *uctx);
+void c4iw_init_dev_ucontext(struct c4iw_rdev *rdev,
+			    struct c4iw_dev_ucontext *uctx);
+int c4iw_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
+int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+		      struct ib_send_wr **bad_wr);
+int c4iw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+		      struct ib_recv_wr **bad_wr);
+int c4iw_bind_mw(struct ib_qp *qp, struct ib_mw *mw,
+		 struct ib_mw_bind *mw_bind);
+int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param);
+int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog);
+int c4iw_destroy_listen(struct iw_cm_id *cm_id);
+int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param);
+int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len);
+void c4iw_qp_add_ref(struct ib_qp *qp);
+void c4iw_qp_rem_ref(struct ib_qp *qp);
+void c4iw_free_fastreg_pbl(struct ib_fast_reg_page_list *page_list);
+struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(
+					struct ib_device *device,
+					int page_list_len);
+struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth);
+int c4iw_dealloc_mw(struct ib_mw *mw);
+struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd);
+struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
+					   u64 length, u64 virt, int acc,
+					   struct ib_udata *udata);
+struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc);
+struct ib_mr *c4iw_register_phys_mem(struct ib_pd *pd,
+					struct ib_phys_buf *buffer_list,
+					int num_phys_buf,
+					int acc,
+					u64 *iova_start);
+int c4iw_reregister_phys_mem(struct ib_mr *mr,
+				     int mr_rereg_mask,
+				     struct ib_pd *pd,
+				     struct ib_phys_buf *buffer_list,
+				     int num_phys_buf,
+				     int acc, u64 *iova_start);
+int c4iw_dereg_mr(struct ib_mr *ib_mr);
+int c4iw_destroy_cq(struct ib_cq *ib_cq);
+struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
+					int vector,
+					struct ib_ucontext *ib_context,
+					struct ib_udata *udata);
+int c4iw_resize_cq(struct ib_cq *cq, int cqe, struct ib_udata *udata);
+int c4iw_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
+int c4iw_destroy_qp(struct ib_qp *ib_qp);
+struct ib_qp *c4iw_create_qp(struct ib_pd *pd,
+			     struct ib_qp_init_attr *attrs,
+			     struct ib_udata *udata);
+int c4iw_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+				 int attr_mask, struct ib_udata *udata);
+struct ib_qp *c4iw_get_qp(struct ib_device *dev, int qpn);
+u32 c4iw_rqtpool_alloc(struct c4iw_rdev *rdev, int size);
+void c4iw_rqtpool_free(struct c4iw_rdev *rdev, u32 addr, int size);
+u32 c4iw_pblpool_alloc(struct c4iw_rdev *rdev, int size);
+void c4iw_pblpool_free(struct c4iw_rdev *rdev, u32 addr, int size);
+int c4iw_ofld_send(struct c4iw_rdev *rdev, struct sk_buff *skb);
+void c4iw_flush_hw_cq(struct t4_cq *cq);
+void c4iw_count_rcqes(struct t4_cq *cq, struct t4_wq *wq, int *count);
+void c4iw_count_scqes(struct t4_cq *cq, struct t4_wq *wq, int *count);
+int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp);
+int c4iw_flush_rq(struct t4_wq *wq, struct t4_cq *cq, int count);
+int c4iw_flush_sq(struct t4_wq *wq, struct t4_cq *cq, int count);
+int c4iw_ev_handler(struct c4iw_dev *rnicp, u32 qid);
+u16 c4iw_rqes_posted(struct c4iw_qp *qhp);
+int c4iw_post_zb_read(struct c4iw_qp *qhp);
+int c4iw_post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe);
+u32 c4iw_get_cqid(struct c4iw_rdev *rdev, struct c4iw_dev_ucontext *uctx);
+void c4iw_put_cqid(struct c4iw_rdev *rdev, u32 qid,
+		struct c4iw_dev_ucontext *uctx);
+u32 c4iw_get_qpid(struct c4iw_rdev *rdev, struct c4iw_dev_ucontext *uctx);
+void c4iw_put_qpid(struct c4iw_rdev *rdev, u32 qid,
+		struct c4iw_dev_ucontext *uctx);
+void c4iw_ev_dispatch(struct c4iw_dev *dev, struct t4_cqe *err_cqe);
+
+extern struct cxgb4_client t4c_client;
+extern c4iw_handler_func c4iw_handlers[NUM_CPL_CMDS];
+
+#endif
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
new file mode 100644
index 0000000..3f0d217
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -0,0 +1,536 @@
+/*
+ * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
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
+#ifndef __T4_H__
+#define __T4_H__
+
+#include "t4_hw.h"
+#include "t4_regs.h"
+#include "t4_msg.h"
+#include "t4fw_ri_api.h"
+
+#define T4_MAX_READ_DEPTH 16
+#define T4_QID_BASE 1024
+#define T4_MAX_QIDS 256
+#define T4_MAX_NUM_QP (1<<16)
+#define T4_MAX_NUM_CQ (1<<15)
+#define T4_MAX_NUM_PD (1<<15)
+#define T4_MAX_PBL_SIZE 256
+#define T4_MAX_RQ_SIZE 1024
+#define T4_MAX_SQ_SIZE 1024
+#define T4_MAX_QP_DEPTH (T4_MAX_RQ_SIZE-1)
+#define T4_MAX_CQ_DEPTH 8192
+#define T4_MAX_NUM_STAG (1<<15)
+#define T4_MAX_MR_SIZE (~0ULL - 1)
+#define T4_PAGESIZE_MASK 0xffff000  /* 4KB-128MB */
+#define T4_STAG_UNSET 0xffffffff
+#define T4_FW_MAJ 0
+#define T4_EQ_STATUS_ENTRIES (L1_CACHE_BYTES > 64 ? 2 : 1)
+
+struct t4_status_page {
+	__be32 rsvd1;	/* flit 0 - hw owns */
+	__be16 rsvd2;
+	__be16 qid;
+	__be16 cidx;
+	__be16 pidx;
+	u8 qp_err;	/* flit 1 - sw owns */
+	u8 db_off;
+};
+
+#define T4_EQ_SIZE 64
+
+#define T4_SQ_NUM_SLOTS 4
+#define T4_SQ_NUM_BYTES (T4_EQ_SIZE * T4_SQ_NUM_SLOTS)
+#define T4_MAX_SEND_SGE ((T4_SQ_NUM_BYTES - sizeof(struct fw_ri_send_wr) - \
+			sizeof(struct fw_ri_isgl)) / sizeof(struct fw_ri_sge))
+#define T4_MAX_SEND_INLINE ((T4_SQ_NUM_BYTES - sizeof(struct fw_ri_send_wr) - \
+			sizeof(struct fw_ri_immd)))
+#define T4_MAX_WRITE_INLINE ((T4_SQ_NUM_BYTES - \
+			sizeof(struct fw_ri_rdma_write_wr) - \
+			sizeof(struct fw_ri_immd)))
+#define T4_MAX_WRITE_SGE ((T4_SQ_NUM_BYTES - \
+			sizeof(struct fw_ri_rdma_write_wr) - \
+			sizeof(struct fw_ri_isgl)) / sizeof(struct fw_ri_sge))
+#define T4_MAX_FR_IMMD ((T4_SQ_NUM_BYTES - sizeof(struct fw_ri_fr_nsmr_wr) - \
+			sizeof(struct fw_ri_immd)))
+#define T4_MAX_FR_DEPTH 255
+
+#define T4_RQ_NUM_SLOTS 2
+#define T4_RQ_NUM_BYTES (T4_EQ_SIZE * T4_RQ_NUM_SLOTS)
+#define T4_MAX_RECV_SGE ((T4_RQ_NUM_BYTES - sizeof(struct fw_ri_recv_wr) - \
+			sizeof(struct fw_ri_isgl)) / sizeof(struct fw_ri_sge))
+
+union t4_wr {
+	struct fw_ri_res_wr res;
+	struct fw_ri_wr ri;
+	struct fw_ri_rdma_write_wr write;
+	struct fw_ri_send_wr send;
+	struct fw_ri_rdma_read_wr read;
+	struct fw_ri_bind_mw_wr bind;
+	struct fw_ri_fr_nsmr_wr fr;
+	struct fw_ri_inv_lstag_wr inv;
+	struct t4_status_page status;
+	__be64 flits[T4_EQ_SIZE / sizeof(__be64) * T4_SQ_NUM_SLOTS];
+};
+
+union t4_recv_wr {
+	struct fw_ri_recv_wr recv;
+	struct t4_status_page status;
+	__be64 flits[T4_EQ_SIZE / sizeof(__be64) * T4_RQ_NUM_SLOTS];
+};
+
+static inline void init_wr_hdr(union t4_wr *wqe, u16 wrid,
+			       enum fw_wr_opcodes opcode, u8 flags, u8 len16)
+{
+	int slots_used;
+
+	wqe->send.opcode = (u8)opcode;
+	wqe->send.flags = flags;
+	wqe->send.wrid = wrid;
+	wqe->send.r1[0] = 0;
+	wqe->send.r1[1] = 0;
+	wqe->send.r1[2] = 0;
+	wqe->send.len16 = len16;
+
+	slots_used = DIV_ROUND_UP(len16*16, T4_EQ_SIZE);
+	while (slots_used < T4_SQ_NUM_SLOTS) {
+		wqe->flits[slots_used * T4_EQ_SIZE / sizeof(__be64)] = 0;
+		slots_used++;
+	}
+}
+
+/* CQE/AE status codes */
+#define T4_ERR_SUCCESS                     0x0
+#define T4_ERR_STAG                        0x1	/* STAG invalid: either the */
+						/* STAG is offlimt, being 0, */
+						/* or STAG_key mismatch */
+#define T4_ERR_PDID                        0x2	/* PDID mismatch */
+#define T4_ERR_QPID                        0x3	/* QPID mismatch */
+#define T4_ERR_ACCESS                      0x4	/* Invalid access right */
+#define T4_ERR_WRAP                        0x5	/* Wrap error */
+#define T4_ERR_BOUND                       0x6	/* base and bounds voilation */
+#define T4_ERR_INVALIDATE_SHARED_MR        0x7	/* attempt to invalidate a  */
+						/* shared memory region */
+#define T4_ERR_INVALIDATE_MR_WITH_MW_BOUND 0x8	/* attempt to invalidate a  */
+						/* shared memory region */
+#define T4_ERR_ECC                         0x9	/* ECC error detected */
+#define T4_ERR_ECC_PSTAG                   0xA	/* ECC error detected when  */
+						/* reading PSTAG for a MW  */
+						/* Invalidate */
+#define T4_ERR_PBL_ADDR_BOUND              0xB	/* pbl addr out of bounds:  */
+						/* software error */
+#define T4_ERR_SWFLUSH			   0xC	/* SW FLUSHED */
+#define T4_ERR_CRC                         0x10 /* CRC error */
+#define T4_ERR_MARKER                      0x11 /* Marker error */
+#define T4_ERR_PDU_LEN_ERR                 0x12 /* invalid PDU length */
+#define T4_ERR_OUT_OF_RQE                  0x13 /* out of RQE */
+#define T4_ERR_DDP_VERSION                 0x14 /* wrong DDP version */
+#define T4_ERR_RDMA_VERSION                0x15 /* wrong RDMA version */
+#define T4_ERR_OPCODE                      0x16 /* invalid rdma opcode */
+#define T4_ERR_DDP_QUEUE_NUM               0x17 /* invalid ddp queue number */
+#define T4_ERR_MSN                         0x18 /* MSN error */
+#define T4_ERR_TBIT                        0x19 /* tag bit not set correctly */
+#define T4_ERR_MO                          0x1A /* MO not 0 for TERMINATE  */
+						/* or READ_REQ */
+#define T4_ERR_MSN_GAP                     0x1B
+#define T4_ERR_MSN_RANGE                   0x1C
+#define T4_ERR_IRD_OVERFLOW                0x1D
+#define T4_ERR_RQE_ADDR_BOUND              0x1E /* RQE addr out of bounds:  */
+						/* software error */
+#define T4_ERR_INTERNAL_ERR                0x1F /* internal error (opcode  */
+						/* mismatch) */
+/*
+ * CQE defs
+ */
+struct t4_cqe {
+	__be32 header;
+	__be32 len;
+	union {
+		struct {
+			__be32 stag;
+			__be32 msn;
+		} rcqe;
+		struct {
+			u32 nada1;
+			u16 nada2;
+			u16 cidx;
+		} scqe;
+		struct {
+			__be32 wrid_hi;
+			__be32 wrid_low;
+		} gen;
+	} u;
+	__be64 reserved;
+	__be64 bits_type_ts;
+};
+
+/* macros for flit 0 of the cqe */
+
+#define S_CQE_QPID        12
+#define M_CQE_QPID        0xFFFFF
+#define G_CQE_QPID(x)     ((((x) >> S_CQE_QPID)) & M_CQE_QPID)
+#define V_CQE_QPID(x)	  ((x)<<S_CQE_QPID)
+
+#define S_CQE_SWCQE       11
+#define M_CQE_SWCQE       0x1
+#define G_CQE_SWCQE(x)    ((((x) >> S_CQE_SWCQE)) & M_CQE_SWCQE)
+#define V_CQE_SWCQE(x)	  ((x)<<S_CQE_SWCQE)
+
+#define S_CQE_STATUS      5
+#define M_CQE_STATUS      0x1F
+#define G_CQE_STATUS(x)   ((((x) >> S_CQE_STATUS)) & M_CQE_STATUS)
+#define V_CQE_STATUS(x)   ((x)<<S_CQE_STATUS)
+
+#define S_CQE_TYPE        4
+#define M_CQE_TYPE        0x1
+#define G_CQE_TYPE(x)     ((((x) >> S_CQE_TYPE)) & M_CQE_TYPE)
+#define V_CQE_TYPE(x)     ((x)<<S_CQE_TYPE)
+
+#define S_CQE_OPCODE      0
+#define M_CQE_OPCODE      0xF
+#define G_CQE_OPCODE(x)   ((((x) >> S_CQE_OPCODE)) & M_CQE_OPCODE)
+#define V_CQE_OPCODE(x)   ((x)<<S_CQE_OPCODE)
+
+#define SW_CQE(x)         (G_CQE_SWCQE(be32_to_cpu((x)->header)))
+#define CQE_QPID(x)       (G_CQE_QPID(be32_to_cpu((x)->header)))
+#define CQE_TYPE(x)       (G_CQE_TYPE(be32_to_cpu((x)->header)))
+#define SQ_TYPE(x)	  (CQE_TYPE((x)))
+#define RQ_TYPE(x)	  (!CQE_TYPE((x)))
+#define CQE_STATUS(x)     (G_CQE_STATUS(be32_to_cpu((x)->header)))
+#define CQE_OPCODE(x)     (G_CQE_OPCODE(be32_to_cpu((x)->header)))
+
+#define CQE_SEND_OPCODE(x)( \
+	(G_CQE_OPCODE(be32_to_cpu((x)->header)) == FW_RI_SEND) || \
+	(G_CQE_OPCODE(be32_to_cpu((x)->header)) == FW_RI_SEND_WITH_SE) || \
+	(G_CQE_OPCODE(be32_to_cpu((x)->header)) == FW_RI_SEND_WITH_INV) || \
+	(G_CQE_OPCODE(be32_to_cpu((x)->header)) == FW_RI_SEND_WITH_SE_INV))
+
+#define CQE_LEN(x)        (be32_to_cpu((x)->len))
+
+/* used for RQ completion processing */
+#define CQE_WRID_STAG(x)  (be32_to_cpu((x)->u.rcqe.stag))
+#define CQE_WRID_MSN(x)   (be32_to_cpu((x)->u.rcqe.msn))
+
+/* used for SQ completion processing */
+#define CQE_WRID_SQ_IDX(x)	((x)->u.scqe.cidx)
+
+/* generic accessor macros */
+#define CQE_WRID_HI(x)		((x)->u.gen.wrid_hi)
+#define CQE_WRID_LOW(x)		((x)->u.gen.wrid_low)
+
+/* macros for flit 3 of the cqe */
+#define S_CQE_GENBIT	63
+#define M_CQE_GENBIT	0x1
+#define G_CQE_GENBIT(x)	(((x) >> S_CQE_GENBIT) & M_CQE_GENBIT)
+#define V_CQE_GENBIT(x) ((x)<<S_CQE_GENBIT)
+
+#define S_CQE_OVFBIT	62
+#define M_CQE_OVFBIT	0x1
+#define G_CQE_OVFBIT(x)	((((x) >> S_CQE_OVFBIT)) & M_CQE_OVFBIT)
+
+#define S_CQE_IQTYPE	60
+#define M_CQE_IQTYPE	0x3
+#define G_CQE_IQTYPE(x)	((((x) >> S_CQE_IQTYPE)) & M_CQE_IQTYPE)
+
+#define M_CQE_TS	0x0fffffffffffffffULL
+#define G_CQE_TS(x)	((x) & M_CQE_TS)
+
+#define CQE_OVFBIT(x)	((unsigned)G_CQE_OVFBIT(be64_to_cpu((x)->bits_type_ts)))
+#define CQE_GENBIT(x)	((unsigned)G_CQE_GENBIT(be64_to_cpu((x)->bits_type_ts)))
+#define CQE_TS(x)	(G_CQE_TS(be64_to_cpu((x)->bits_type_ts)))
+
+struct t4_swsqe {
+	u64			wr_id;
+	struct t4_cqe		cqe;
+	int			read_len;
+	int			opcode;
+	int			complete;
+	int			signaled;
+	u16			idx;
+};
+
+struct t4_sq {
+	union t4_wr *queue;
+	dma_addr_t dma_addr;
+	DECLARE_PCI_UNMAP_ADDR(mapping);
+	struct t4_swsqe *sw_sq;
+	struct t4_swsqe *oldest_read;
+	u64 udb;
+	size_t memsize;
+	u32 qid;
+	u16 in_use;
+	u16 size;
+	u16 cidx;
+	u16 pidx;
+};
+
+struct t4_swrqe {
+	u64 wr_id;
+};
+
+struct t4_rq {
+	union  t4_recv_wr *queue;
+	dma_addr_t dma_addr;
+	DECLARE_PCI_UNMAP_ADDR(mapping);
+	struct t4_swrqe *sw_rq;
+	u64 udb;
+	size_t memsize;
+	u32 qid;
+	u32 msn;
+	u32 rqt_hwaddr;
+	u16 rqt_size;
+	u16 in_use;
+	u16 size;
+	u16 cidx;
+	u16 pidx;
+};
+
+struct t4_wq {
+	struct t4_sq sq;
+	struct t4_rq rq;
+	void __iomem *db;
+	void __iomem *gts;
+	struct c4iw_rdev *rdev;
+};
+
+static inline int t4_rqes_posted(struct t4_wq *wq)
+{
+	return wq->rq.in_use;
+}
+
+static inline int t4_rq_empty(struct t4_wq *wq)
+{
+	return wq->rq.in_use == 0;
+}
+
+static inline int t4_rq_full(struct t4_wq *wq)
+{
+	return wq->rq.in_use == (wq->rq.size - 1);
+}
+
+static inline u32 t4_rq_avail(struct t4_wq *wq)
+{
+	return wq->rq.size - 1 - wq->rq.in_use;
+}
+
+static inline void t4_rq_produce(struct t4_wq *wq)
+{
+	wq->rq.in_use++;
+	if (++wq->rq.pidx == wq->rq.size)
+		wq->rq.pidx = 0;
+}
+
+static inline void t4_rq_consume(struct t4_wq *wq)
+{
+	wq->rq.in_use--;
+	wq->rq.msn++;
+	if (++wq->rq.cidx == wq->rq.size)
+		wq->rq.cidx = 0;
+}
+
+static inline int t4_sq_empty(struct t4_wq *wq)
+{
+	return wq->sq.in_use == 0;
+}
+
+static inline int t4_sq_full(struct t4_wq *wq)
+{
+	return wq->sq.in_use == (wq->sq.size - 1);
+}
+
+static inline u32 t4_sq_avail(struct t4_wq *wq)
+{
+	return wq->sq.size - 1 - wq->sq.in_use;
+}
+
+static inline void t4_sq_produce(struct t4_wq *wq)
+{
+	wq->sq.in_use++;
+	if (++wq->sq.pidx == wq->sq.size)
+		wq->sq.pidx = 0;
+}
+
+static inline void t4_sq_consume(struct t4_wq *wq)
+{
+	wq->sq.in_use--;
+	if (++wq->sq.cidx == wq->sq.size)
+		wq->sq.cidx = 0;
+}
+
+static inline void t4_ring_sq_db(struct t4_wq *wq, u16 inc)
+{
+	inc *= T4_SQ_NUM_SLOTS;
+	wmb();
+	writel(QID(wq->sq.qid) | PIDX(inc), wq->db);
+}
+
+static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc)
+{
+	inc *= T4_RQ_NUM_SLOTS;
+	wmb();
+	writel(QID(wq->rq.qid) | PIDX(inc), wq->db);
+}
+
+static inline int t4_wq_in_error(struct t4_wq *wq)
+{
+	return wq->sq.queue[wq->sq.size].status.qp_err;
+}
+
+static inline void t4_set_wq_in_error(struct t4_wq *wq)
+{
+	wq->sq.queue[wq->sq.size].status.qp_err = 1;
+	wq->rq.queue[wq->rq.size].status.qp_err = 1;
+}
+
+static inline void t4_disable_wq_db(struct t4_wq *wq)
+{
+	wq->sq.queue[wq->sq.size].status.db_off = 1;
+	wq->rq.queue[wq->rq.size].status.db_off = 1;
+}
+
+static inline void t4_enable_wq_db(struct t4_wq *wq)
+{
+	wq->sq.queue[wq->sq.size].status.db_off = 0;
+	wq->rq.queue[wq->rq.size].status.db_off = 0;
+}
+
+static inline int t4_wq_db_enabled(struct t4_wq *wq)
+{
+	return !wq->sq.queue[wq->sq.size].status.db_off;
+}
+
+struct t4_cq {
+	struct t4_cqe *queue;
+	dma_addr_t dma_addr;
+	DECLARE_PCI_UNMAP_ADDR(mapping);
+	struct t4_cqe *sw_queue;
+	void __iomem *gts;
+	struct c4iw_rdev *rdev;
+	u64 ugts;
+	size_t memsize;
+	u64 timestamp;
+	u32 cqid;
+	u16 size; /* including status page */
+	u16 cidx;
+	u16 sw_pidx;
+	u16 sw_cidx;
+	u16 sw_in_use;
+	u16 cidx_inc;
+	u8 gen;
+	u8 error;
+};
+
+static inline int t4_arm_cq(struct t4_cq *cq, int se)
+{
+	u32 val;
+
+	val = SEINTARM(se) | CIDXINC(cq->cidx_inc) | TIMERREG(6) |
+	      INGRESSQID(cq->cqid);
+	cq->cidx_inc = 0;
+	writel(val, cq->gts);
+	return 0;
+}
+
+static inline void t4_swcq_produce(struct t4_cq *cq)
+{
+	cq->sw_in_use++;
+	if (++cq->sw_pidx == cq->size)
+		cq->sw_pidx = 0;
+}
+
+static inline void t4_swcq_consume(struct t4_cq *cq)
+{
+	cq->sw_in_use--;
+	if (++cq->sw_cidx == cq->size)
+		cq->sw_cidx = 0;
+}
+
+static inline void t4_hwcq_consume(struct t4_cq *cq)
+{
+	cq->cidx_inc++;
+	if (++cq->cidx == cq->size) {
+		cq->cidx = 0;
+		cq->gen ^= 1;
+	}
+}
+
+static inline int t4_valid_cqe(struct t4_cq *cq, struct t4_cqe *cqe)
+{
+	return (CQE_GENBIT(cqe) == cq->gen);
+}
+
+static inline int t4_next_hw_cqe(struct t4_cq *cq, struct t4_cqe **cqe)
+{
+	int ret = 0;
+
+	if (t4_valid_cqe(cq, &cq->queue[cq->cidx])) {
+		*cqe = &cq->queue[cq->cidx];
+		cq->timestamp = CQE_TS(*cqe);
+	} else if (CQE_TS(&cq->queue[cq->cidx]) > cq->timestamp)
+		ret = -EOVERFLOW;
+	else
+		ret = -ENODATA;
+	if (ret == -EOVERFLOW) {
+		printk(KERN_ERR MOD "cq overflow cqid %u\n", cq->cqid);
+		cq->error = 1;
+	}
+	return ret;
+}
+
+static inline struct t4_cqe *t4_next_sw_cqe(struct t4_cq *cq)
+{
+	if (cq->sw_in_use)
+		return &cq->sw_queue[cq->sw_cidx];
+	return NULL;
+}
+
+static inline int t4_next_cqe(struct t4_cq *cq, struct t4_cqe **cqe)
+{
+	int ret = 0;
+
+	if (cq->error)
+		ret = -ENODATA;
+	else if (cq->sw_in_use)
+		*cqe = &cq->sw_queue[cq->sw_cidx];
+	else
+		ret = t4_next_hw_cqe(cq, cqe);
+	return ret;
+}
+
+static inline int t4_cq_in_error(struct t4_cq *cq)
+{
+	return ((struct t4_status_page *)&cq->queue[cq->size])->qp_err;
+}
+
+static inline void t4_set_cq_in_error(struct t4_cq *cq)
+{
+	((struct t4_status_page *)&cq->queue[cq->size])->qp_err = 1;
+}
+#endif
diff --git a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
new file mode 100644
index 0000000..0ac153a
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
@@ -0,0 +1,798 @@
+/*
+ * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
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
+#ifndef _T4FW_RI_API_H_
+#define _T4FW_RI_API_H_
+
+#include "t4fw_api.h"
+
+enum fw_ri_wr_opcode {
+	FW_RI_RDMA_WRITE,               /* IETF RDMAP v1.0 ... */
+	FW_RI_READ_REQ,
+	FW_RI_READ_RESP,
+	FW_RI_SEND,
+	FW_RI_SEND_WITH_INV,
+	FW_RI_SEND_WITH_SE,
+	FW_RI_SEND_WITH_SE_INV,
+	FW_RI_TERMINATE,
+	FW_RI_RDMA_INIT,                /* CHELSIO RI specific ... */
+	FW_RI_BIND_MW,
+	FW_RI_FAST_REGISTER,
+	FW_RI_LOCAL_INV,
+	FW_RI_QP_MODIFY,
+	FW_RI_BYPASS,
+	FW_RI_RECEIVE,
+
+	FW_RI_SGE_EC_CR_RETURN = 0xf
+};
+
+enum fw_ri_wr_flags {
+	FW_RI_COMPLETION_FLAG		= 0x01,
+	FW_RI_NOTIFICATION_FLAG		= 0x02,
+	FW_RI_SOLICITED_EVENT_FLAG	= 0x04,
+	FW_RI_READ_FENCE_FLAG		= 0x08,
+	FW_RI_LOCAL_FENCE_FLAG		= 0x10,
+	FW_RI_RDMA_READ_INVALIDATE	= 0x20
+};
+
+enum fw_ri_mpa_attrs {
+	FW_RI_MPA_RX_MARKER_ENABLE	= 0x01,
+	FW_RI_MPA_TX_MARKER_ENABLE	= 0x02,
+	FW_RI_MPA_CRC_ENABLE		= 0x04,
+	FW_RI_MPA_IETF_ENABLE		= 0x08
+};
+
+enum fw_ri_qp_caps {
+	FW_RI_QP_RDMA_READ_ENABLE	= 0x01,
+	FW_RI_QP_RDMA_WRITE_ENABLE	= 0x02,
+	FW_RI_QP_BIND_ENABLE		= 0x04,
+	FW_RI_QP_FAST_REGISTER_ENABLE	= 0x08,
+	FW_RI_QP_STAG0_ENABLE		= 0x10
+};
+
+enum fw_ri_addr_type {
+	FW_RI_ZERO_BASED_TO		= 0x00,
+	FW_RI_VA_BASED_TO		= 0x01
+};
+
+enum fw_ri_mem_perms {
+	FW_RI_MEM_ACCESS_REM_WRITE	= 0x01,
+	FW_RI_MEM_ACCESS_REM_READ	= 0x02,
+	FW_RI_MEM_ACCESS_REM		= 0x03,
+	FW_RI_MEM_ACCESS_LOCAL_WRITE	= 0x04,
+	FW_RI_MEM_ACCESS_LOCAL_READ	= 0x08,
+	FW_RI_MEM_ACCESS_LOCAL		= 0x0C
+};
+
+enum fw_ri_stag_type {
+	FW_RI_STAG_NSMR			= 0x00,
+	FW_RI_STAG_SMR			= 0x01,
+	FW_RI_STAG_MW			= 0x02,
+	FW_RI_STAG_MW_RELAXED		= 0x03
+};
+
+enum fw_ri_data_op {
+	FW_RI_DATA_IMMD			= 0x81,
+	FW_RI_DATA_DSGL			= 0x82,
+	FW_RI_DATA_ISGL			= 0x83
+};
+
+enum fw_ri_sgl_depth {
+	FW_RI_SGL_DEPTH_MAX_SQ		= 16,
+	FW_RI_SGL_DEPTH_MAX_RQ		= 4
+};
+
+struct fw_ri_dsge_pair {
+	__be32	len[2];
+	__be64	addr[2];
+};
+
+struct fw_ri_dsgl {
+	__u8	op;
+	__u8	r1;
+	__be16	nsge;
+	__be32	len0;
+	__be64	addr0;
+	struct fw_ri_dsge_pair sge[0];
+};
+
+struct fw_ri_sge {
+	__be32 stag;
+	__be32 len;
+	__be64 to;
+};
+
+struct fw_ri_isgl {
+	__u8	op;
+	__u8	r1;
+	__be16	nsge;
+	__be32	r2;
+	struct fw_ri_sge sge[0];
+};
+
+struct fw_ri_immd {
+	__u8	op;
+	__u8	r1;
+	__be16	r2;
+	__be32	immdlen;
+	__u8	data[0];
+};
+
+struct fw_ri_tpte {
+	__be32 valid_to_pdid;
+	__be32 locread_to_qpid;
+	__be32 nosnoop_pbladdr;
+	__be32 len_lo;
+	__be32 va_hi;
+	__be32 va_lo_fbo;
+	__be32 dca_mwbcnt_pstag;
+	__be32 len_hi;
+};
+
+#define S_FW_RI_TPTE_VALID		31
+#define M_FW_RI_TPTE_VALID		0x1
+#define V_FW_RI_TPTE_VALID(x)		((x) << S_FW_RI_TPTE_VALID)
+#define G_FW_RI_TPTE_VALID(x)		\
+    (((x) >> S_FW_RI_TPTE_VALID) & M_FW_RI_TPTE_VALID)
+#define F_FW_RI_TPTE_VALID		V_FW_RI_TPTE_VALID(1U)
+
+#define S_FW_RI_TPTE_STAGKEY		23
+#define M_FW_RI_TPTE_STAGKEY		0xff
+#define V_FW_RI_TPTE_STAGKEY(x)		((x) << S_FW_RI_TPTE_STAGKEY)
+#define G_FW_RI_TPTE_STAGKEY(x)		\
+    (((x) >> S_FW_RI_TPTE_STAGKEY) & M_FW_RI_TPTE_STAGKEY)
+
+#define S_FW_RI_TPTE_STAGSTATE		22
+#define M_FW_RI_TPTE_STAGSTATE		0x1
+#define V_FW_RI_TPTE_STAGSTATE(x)	((x) << S_FW_RI_TPTE_STAGSTATE)
+#define G_FW_RI_TPTE_STAGSTATE(x)	\
+    (((x) >> S_FW_RI_TPTE_STAGSTATE) & M_FW_RI_TPTE_STAGSTATE)
+#define F_FW_RI_TPTE_STAGSTATE		V_FW_RI_TPTE_STAGSTATE(1U)
+
+#define S_FW_RI_TPTE_STAGTYPE		20
+#define M_FW_RI_TPTE_STAGTYPE		0x3
+#define V_FW_RI_TPTE_STAGTYPE(x)	((x) << S_FW_RI_TPTE_STAGTYPE)
+#define G_FW_RI_TPTE_STAGTYPE(x)	\
+    (((x) >> S_FW_RI_TPTE_STAGTYPE) & M_FW_RI_TPTE_STAGTYPE)
+
+#define S_FW_RI_TPTE_PDID		0
+#define M_FW_RI_TPTE_PDID		0xfffff
+#define V_FW_RI_TPTE_PDID(x)		((x) << S_FW_RI_TPTE_PDID)
+#define G_FW_RI_TPTE_PDID(x)		\
+    (((x) >> S_FW_RI_TPTE_PDID) & M_FW_RI_TPTE_PDID)
+
+#define S_FW_RI_TPTE_PERM		28
+#define M_FW_RI_TPTE_PERM		0xf
+#define V_FW_RI_TPTE_PERM(x)		((x) << S_FW_RI_TPTE_PERM)
+#define G_FW_RI_TPTE_PERM(x)		\
+    (((x) >> S_FW_RI_TPTE_PERM) & M_FW_RI_TPTE_PERM)
+
+#define S_FW_RI_TPTE_REMINVDIS		27
+#define M_FW_RI_TPTE_REMINVDIS		0x1
+#define V_FW_RI_TPTE_REMINVDIS(x)	((x) << S_FW_RI_TPTE_REMINVDIS)
+#define G_FW_RI_TPTE_REMINVDIS(x)	\
+    (((x) >> S_FW_RI_TPTE_REMINVDIS) & M_FW_RI_TPTE_REMINVDIS)
+#define F_FW_RI_TPTE_REMINVDIS		V_FW_RI_TPTE_REMINVDIS(1U)
+
+#define S_FW_RI_TPTE_ADDRTYPE		26
+#define M_FW_RI_TPTE_ADDRTYPE		1
+#define V_FW_RI_TPTE_ADDRTYPE(x)	((x) << S_FW_RI_TPTE_ADDRTYPE)
+#define G_FW_RI_TPTE_ADDRTYPE(x)	\
+    (((x) >> S_FW_RI_TPTE_ADDRTYPE) & M_FW_RI_TPTE_ADDRTYPE)
+#define F_FW_RI_TPTE_ADDRTYPE		V_FW_RI_TPTE_ADDRTYPE(1U)
+
+#define S_FW_RI_TPTE_MWBINDEN		25
+#define M_FW_RI_TPTE_MWBINDEN		0x1
+#define V_FW_RI_TPTE_MWBINDEN(x)	((x) << S_FW_RI_TPTE_MWBINDEN)
+#define G_FW_RI_TPTE_MWBINDEN(x)	\
+    (((x) >> S_FW_RI_TPTE_MWBINDEN) & M_FW_RI_TPTE_MWBINDEN)
+#define F_FW_RI_TPTE_MWBINDEN		V_FW_RI_TPTE_MWBINDEN(1U)
+
+#define S_FW_RI_TPTE_PS			20
+#define M_FW_RI_TPTE_PS			0x1f
+#define V_FW_RI_TPTE_PS(x)		((x) << S_FW_RI_TPTE_PS)
+#define G_FW_RI_TPTE_PS(x)		\
+    (((x) >> S_FW_RI_TPTE_PS) & M_FW_RI_TPTE_PS)
+
+#define S_FW_RI_TPTE_QPID		0
+#define M_FW_RI_TPTE_QPID		0xfffff
+#define V_FW_RI_TPTE_QPID(x)		((x) << S_FW_RI_TPTE_QPID)
+#define G_FW_RI_TPTE_QPID(x)		\
+    (((x) >> S_FW_RI_TPTE_QPID) & M_FW_RI_TPTE_QPID)
+
+#define S_FW_RI_TPTE_NOSNOOP		30
+#define M_FW_RI_TPTE_NOSNOOP		0x1
+#define V_FW_RI_TPTE_NOSNOOP(x)		((x) << S_FW_RI_TPTE_NOSNOOP)
+#define G_FW_RI_TPTE_NOSNOOP(x)		\
+    (((x) >> S_FW_RI_TPTE_NOSNOOP) & M_FW_RI_TPTE_NOSNOOP)
+#define F_FW_RI_TPTE_NOSNOOP		V_FW_RI_TPTE_NOSNOOP(1U)
+
+#define S_FW_RI_TPTE_PBLADDR		0
+#define M_FW_RI_TPTE_PBLADDR		0x1fffffff
+#define V_FW_RI_TPTE_PBLADDR(x)		((x) << S_FW_RI_TPTE_PBLADDR)
+#define G_FW_RI_TPTE_PBLADDR(x)		\
+    (((x) >> S_FW_RI_TPTE_PBLADDR) & M_FW_RI_TPTE_PBLADDR)
+
+#define S_FW_RI_TPTE_DCA		24
+#define M_FW_RI_TPTE_DCA		0x1f
+#define V_FW_RI_TPTE_DCA(x)		((x) << S_FW_RI_TPTE_DCA)
+#define G_FW_RI_TPTE_DCA(x)		\
+    (((x) >> S_FW_RI_TPTE_DCA) & M_FW_RI_TPTE_DCA)
+
+#define S_FW_RI_TPTE_MWBCNT_PSTAG	0
+#define M_FW_RI_TPTE_MWBCNT_PSTAG	0xffffff
+#define V_FW_RI_TPTE_MWBCNT_PSTAT(x)	\
+    ((x) << S_FW_RI_TPTE_MWBCNT_PSTAG)
+#define G_FW_RI_TPTE_MWBCNT_PSTAG(x)	\
+    (((x) >> S_FW_RI_TPTE_MWBCNT_PSTAG) & M_FW_RI_TPTE_MWBCNT_PSTAG)
+
+enum fw_ri_res_type {
+	FW_RI_RES_TYPE_SQ,
+	FW_RI_RES_TYPE_RQ,
+	FW_RI_RES_TYPE_CQ,
+};
+
+enum fw_ri_res_op {
+	FW_RI_RES_OP_WRITE,
+	FW_RI_RES_OP_RESET,
+};
+
+struct fw_ri_res {
+	union fw_ri_restype {
+		struct fw_ri_res_sqrq {
+			__u8   restype;
+			__u8   op;
+			__be16 r3;
+			__be32 eqid;
+			__be32 r4[2];
+			__be32 fetchszm_to_iqid;
+			__be32 dcaen_to_eqsize;
+			__be64 eqaddr;
+		} sqrq;
+		struct fw_ri_res_cq {
+			__u8   restype;
+			__u8   op;
+			__be16 r3;
+			__be32 iqid;
+			__be32 r4[2];
+			__be32 iqandst_to_iqandstindex;
+			__be16 iqdroprss_to_iqesize;
+			__be16 iqsize;
+			__be64 iqaddr;
+			__be32 iqns_iqro;
+			__be32 r6_lo;
+			__be64 r7;
+		} cq;
+	} u;
+};
+
+struct fw_ri_res_wr {
+	__be32 op_nres;
+	__be32 len16_pkd;
+	__u64  cookie;
+	struct fw_ri_res res[0];
+};
+
+#define S_FW_RI_RES_WR_NRES	0
+#define M_FW_RI_RES_WR_NRES	0xff
+#define V_FW_RI_RES_WR_NRES(x)	((x) << S_FW_RI_RES_WR_NRES)
+#define G_FW_RI_RES_WR_NRES(x)	\
+    (((x) >> S_FW_RI_RES_WR_NRES) & M_FW_RI_RES_WR_NRES)
+
+#define S_FW_RI_RES_WR_FETCHSZM		26
+#define M_FW_RI_RES_WR_FETCHSZM		0x1
+#define V_FW_RI_RES_WR_FETCHSZM(x)	((x) << S_FW_RI_RES_WR_FETCHSZM)
+#define G_FW_RI_RES_WR_FETCHSZM(x)	\
+    (((x) >> S_FW_RI_RES_WR_FETCHSZM) & M_FW_RI_RES_WR_FETCHSZM)
+#define F_FW_RI_RES_WR_FETCHSZM	V_FW_RI_RES_WR_FETCHSZM(1U)
+
+#define S_FW_RI_RES_WR_STATUSPGNS	25
+#define M_FW_RI_RES_WR_STATUSPGNS	0x1
+#define V_FW_RI_RES_WR_STATUSPGNS(x)	((x) << S_FW_RI_RES_WR_STATUSPGNS)
+#define G_FW_RI_RES_WR_STATUSPGNS(x)	\
+    (((x) >> S_FW_RI_RES_WR_STATUSPGNS) & M_FW_RI_RES_WR_STATUSPGNS)
+#define F_FW_RI_RES_WR_STATUSPGNS	V_FW_RI_RES_WR_STATUSPGNS(1U)
+
+#define S_FW_RI_RES_WR_STATUSPGRO	24
+#define M_FW_RI_RES_WR_STATUSPGRO	0x1
+#define V_FW_RI_RES_WR_STATUSPGRO(x)	((x) << S_FW_RI_RES_WR_STATUSPGRO)
+#define G_FW_RI_RES_WR_STATUSPGRO(x)	\
+    (((x) >> S_FW_RI_RES_WR_STATUSPGRO) & M_FW_RI_RES_WR_STATUSPGRO)
+#define F_FW_RI_RES_WR_STATUSPGRO	V_FW_RI_RES_WR_STATUSPGRO(1U)
+
+#define S_FW_RI_RES_WR_FETCHNS		23
+#define M_FW_RI_RES_WR_FETCHNS		0x1
+#define V_FW_RI_RES_WR_FETCHNS(x)	((x) << S_FW_RI_RES_WR_FETCHNS)
+#define G_FW_RI_RES_WR_FETCHNS(x)	\
+    (((x) >> S_FW_RI_RES_WR_FETCHNS) & M_FW_RI_RES_WR_FETCHNS)
+#define F_FW_RI_RES_WR_FETCHNS	V_FW_RI_RES_WR_FETCHNS(1U)
+
+#define S_FW_RI_RES_WR_FETCHRO		22
+#define M_FW_RI_RES_WR_FETCHRO		0x1
+#define V_FW_RI_RES_WR_FETCHRO(x)	((x) << S_FW_RI_RES_WR_FETCHRO)
+#define G_FW_RI_RES_WR_FETCHRO(x)	\
+    (((x) >> S_FW_RI_RES_WR_FETCHRO) & M_FW_RI_RES_WR_FETCHRO)
+#define F_FW_RI_RES_WR_FETCHRO	V_FW_RI_RES_WR_FETCHRO(1U)
+
+#define S_FW_RI_RES_WR_HOSTFCMODE	20
+#define M_FW_RI_RES_WR_HOSTFCMODE	0x3
+#define V_FW_RI_RES_WR_HOSTFCMODE(x)	((x) << S_FW_RI_RES_WR_HOSTFCMODE)
+#define G_FW_RI_RES_WR_HOSTFCMODE(x)	\
+    (((x) >> S_FW_RI_RES_WR_HOSTFCMODE) & M_FW_RI_RES_WR_HOSTFCMODE)
+
+#define S_FW_RI_RES_WR_CPRIO	19
+#define M_FW_RI_RES_WR_CPRIO	0x1
+#define V_FW_RI_RES_WR_CPRIO(x)	((x) << S_FW_RI_RES_WR_CPRIO)
+#define G_FW_RI_RES_WR_CPRIO(x)	\
+    (((x) >> S_FW_RI_RES_WR_CPRIO) & M_FW_RI_RES_WR_CPRIO)
+#define F_FW_RI_RES_WR_CPRIO	V_FW_RI_RES_WR_CPRIO(1U)
+
+#define S_FW_RI_RES_WR_ONCHIP		18
+#define M_FW_RI_RES_WR_ONCHIP		0x1
+#define V_FW_RI_RES_WR_ONCHIP(x)	((x) << S_FW_RI_RES_WR_ONCHIP)
+#define G_FW_RI_RES_WR_ONCHIP(x)	\
+    (((x) >> S_FW_RI_RES_WR_ONCHIP) & M_FW_RI_RES_WR_ONCHIP)
+#define F_FW_RI_RES_WR_ONCHIP	V_FW_RI_RES_WR_ONCHIP(1U)
+
+#define S_FW_RI_RES_WR_PCIECHN		16
+#define M_FW_RI_RES_WR_PCIECHN		0x3
+#define V_FW_RI_RES_WR_PCIECHN(x)	((x) << S_FW_RI_RES_WR_PCIECHN)
+#define G_FW_RI_RES_WR_PCIECHN(x)	\
+    (((x) >> S_FW_RI_RES_WR_PCIECHN) & M_FW_RI_RES_WR_PCIECHN)
+
+#define S_FW_RI_RES_WR_IQID	0
+#define M_FW_RI_RES_WR_IQID	0xffff
+#define V_FW_RI_RES_WR_IQID(x)	((x) << S_FW_RI_RES_WR_IQID)
+#define G_FW_RI_RES_WR_IQID(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQID) & M_FW_RI_RES_WR_IQID)
+
+#define S_FW_RI_RES_WR_DCAEN	31
+#define M_FW_RI_RES_WR_DCAEN	0x1
+#define V_FW_RI_RES_WR_DCAEN(x)	((x) << S_FW_RI_RES_WR_DCAEN)
+#define G_FW_RI_RES_WR_DCAEN(x)	\
+    (((x) >> S_FW_RI_RES_WR_DCAEN) & M_FW_RI_RES_WR_DCAEN)
+#define F_FW_RI_RES_WR_DCAEN	V_FW_RI_RES_WR_DCAEN(1U)
+
+#define S_FW_RI_RES_WR_DCACPU		26
+#define M_FW_RI_RES_WR_DCACPU		0x1f
+#define V_FW_RI_RES_WR_DCACPU(x)	((x) << S_FW_RI_RES_WR_DCACPU)
+#define G_FW_RI_RES_WR_DCACPU(x)	\
+    (((x) >> S_FW_RI_RES_WR_DCACPU) & M_FW_RI_RES_WR_DCACPU)
+
+#define S_FW_RI_RES_WR_FBMIN	23
+#define M_FW_RI_RES_WR_FBMIN	0x7
+#define V_FW_RI_RES_WR_FBMIN(x)	((x) << S_FW_RI_RES_WR_FBMIN)
+#define G_FW_RI_RES_WR_FBMIN(x)	\
+    (((x) >> S_FW_RI_RES_WR_FBMIN) & M_FW_RI_RES_WR_FBMIN)
+
+#define S_FW_RI_RES_WR_FBMAX	20
+#define M_FW_RI_RES_WR_FBMAX	0x7
+#define V_FW_RI_RES_WR_FBMAX(x)	((x) << S_FW_RI_RES_WR_FBMAX)
+#define G_FW_RI_RES_WR_FBMAX(x)	\
+    (((x) >> S_FW_RI_RES_WR_FBMAX) & M_FW_RI_RES_WR_FBMAX)
+
+#define S_FW_RI_RES_WR_CIDXFTHRESHO	19
+#define M_FW_RI_RES_WR_CIDXFTHRESHO	0x1
+#define V_FW_RI_RES_WR_CIDXFTHRESHO(x)	((x) << S_FW_RI_RES_WR_CIDXFTHRESHO)
+#define G_FW_RI_RES_WR_CIDXFTHRESHO(x)	\
+    (((x) >> S_FW_RI_RES_WR_CIDXFTHRESHO) & M_FW_RI_RES_WR_CIDXFTHRESHO)
+#define F_FW_RI_RES_WR_CIDXFTHRESHO	V_FW_RI_RES_WR_CIDXFTHRESHO(1U)
+
+#define S_FW_RI_RES_WR_CIDXFTHRESH	16
+#define M_FW_RI_RES_WR_CIDXFTHRESH	0x7
+#define V_FW_RI_RES_WR_CIDXFTHRESH(x)	((x) << S_FW_RI_RES_WR_CIDXFTHRESH)
+#define G_FW_RI_RES_WR_CIDXFTHRESH(x)	\
+    (((x) >> S_FW_RI_RES_WR_CIDXFTHRESH) & M_FW_RI_RES_WR_CIDXFTHRESH)
+
+#define S_FW_RI_RES_WR_EQSIZE		0
+#define M_FW_RI_RES_WR_EQSIZE		0xffff
+#define V_FW_RI_RES_WR_EQSIZE(x)	((x) << S_FW_RI_RES_WR_EQSIZE)
+#define G_FW_RI_RES_WR_EQSIZE(x)	\
+    (((x) >> S_FW_RI_RES_WR_EQSIZE) & M_FW_RI_RES_WR_EQSIZE)
+
+#define S_FW_RI_RES_WR_IQANDST		15
+#define M_FW_RI_RES_WR_IQANDST		0x1
+#define V_FW_RI_RES_WR_IQANDST(x)	((x) << S_FW_RI_RES_WR_IQANDST)
+#define G_FW_RI_RES_WR_IQANDST(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQANDST) & M_FW_RI_RES_WR_IQANDST)
+#define F_FW_RI_RES_WR_IQANDST	V_FW_RI_RES_WR_IQANDST(1U)
+
+#define S_FW_RI_RES_WR_IQANUS		14
+#define M_FW_RI_RES_WR_IQANUS		0x1
+#define V_FW_RI_RES_WR_IQANUS(x)	((x) << S_FW_RI_RES_WR_IQANUS)
+#define G_FW_RI_RES_WR_IQANUS(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQANUS) & M_FW_RI_RES_WR_IQANUS)
+#define F_FW_RI_RES_WR_IQANUS	V_FW_RI_RES_WR_IQANUS(1U)
+
+#define S_FW_RI_RES_WR_IQANUD		12
+#define M_FW_RI_RES_WR_IQANUD		0x3
+#define V_FW_RI_RES_WR_IQANUD(x)	((x) << S_FW_RI_RES_WR_IQANUD)
+#define G_FW_RI_RES_WR_IQANUD(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQANUD) & M_FW_RI_RES_WR_IQANUD)
+
+#define S_FW_RI_RES_WR_IQANDSTINDEX	0
+#define M_FW_RI_RES_WR_IQANDSTINDEX	0xfff
+#define V_FW_RI_RES_WR_IQANDSTINDEX(x)	((x) << S_FW_RI_RES_WR_IQANDSTINDEX)
+#define G_FW_RI_RES_WR_IQANDSTINDEX(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQANDSTINDEX) & M_FW_RI_RES_WR_IQANDSTINDEX)
+
+#define S_FW_RI_RES_WR_IQDROPRSS	15
+#define M_FW_RI_RES_WR_IQDROPRSS	0x1
+#define V_FW_RI_RES_WR_IQDROPRSS(x)	((x) << S_FW_RI_RES_WR_IQDROPRSS)
+#define G_FW_RI_RES_WR_IQDROPRSS(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQDROPRSS) & M_FW_RI_RES_WR_IQDROPRSS)
+#define F_FW_RI_RES_WR_IQDROPRSS	V_FW_RI_RES_WR_IQDROPRSS(1U)
+
+#define S_FW_RI_RES_WR_IQGTSMODE	14
+#define M_FW_RI_RES_WR_IQGTSMODE	0x1
+#define V_FW_RI_RES_WR_IQGTSMODE(x)	((x) << S_FW_RI_RES_WR_IQGTSMODE)
+#define G_FW_RI_RES_WR_IQGTSMODE(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQGTSMODE) & M_FW_RI_RES_WR_IQGTSMODE)
+#define F_FW_RI_RES_WR_IQGTSMODE	V_FW_RI_RES_WR_IQGTSMODE(1U)
+
+#define S_FW_RI_RES_WR_IQPCIECH		12
+#define M_FW_RI_RES_WR_IQPCIECH		0x3
+#define V_FW_RI_RES_WR_IQPCIECH(x)	((x) << S_FW_RI_RES_WR_IQPCIECH)
+#define G_FW_RI_RES_WR_IQPCIECH(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQPCIECH) & M_FW_RI_RES_WR_IQPCIECH)
+
+#define S_FW_RI_RES_WR_IQDCAEN		11
+#define M_FW_RI_RES_WR_IQDCAEN		0x1
+#define V_FW_RI_RES_WR_IQDCAEN(x)	((x) << S_FW_RI_RES_WR_IQDCAEN)
+#define G_FW_RI_RES_WR_IQDCAEN(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQDCAEN) & M_FW_RI_RES_WR_IQDCAEN)
+#define F_FW_RI_RES_WR_IQDCAEN	V_FW_RI_RES_WR_IQDCAEN(1U)
+
+#define S_FW_RI_RES_WR_IQDCACPU		6
+#define M_FW_RI_RES_WR_IQDCACPU		0x1f
+#define V_FW_RI_RES_WR_IQDCACPU(x)	((x) << S_FW_RI_RES_WR_IQDCACPU)
+#define G_FW_RI_RES_WR_IQDCACPU(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQDCACPU) & M_FW_RI_RES_WR_IQDCACPU)
+
+#define S_FW_RI_RES_WR_IQINTCNTTHRESH		4
+#define M_FW_RI_RES_WR_IQINTCNTTHRESH		0x3
+#define V_FW_RI_RES_WR_IQINTCNTTHRESH(x)	\
+    ((x) << S_FW_RI_RES_WR_IQINTCNTTHRESH)
+#define G_FW_RI_RES_WR_IQINTCNTTHRESH(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQINTCNTTHRESH) & M_FW_RI_RES_WR_IQINTCNTTHRESH)
+
+#define S_FW_RI_RES_WR_IQO	3
+#define M_FW_RI_RES_WR_IQO	0x1
+#define V_FW_RI_RES_WR_IQO(x)	((x) << S_FW_RI_RES_WR_IQO)
+#define G_FW_RI_RES_WR_IQO(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQO) & M_FW_RI_RES_WR_IQO)
+#define F_FW_RI_RES_WR_IQO	V_FW_RI_RES_WR_IQO(1U)
+
+#define S_FW_RI_RES_WR_IQCPRIO		2
+#define M_FW_RI_RES_WR_IQCPRIO		0x1
+#define V_FW_RI_RES_WR_IQCPRIO(x)	((x) << S_FW_RI_RES_WR_IQCPRIO)
+#define G_FW_RI_RES_WR_IQCPRIO(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQCPRIO) & M_FW_RI_RES_WR_IQCPRIO)
+#define F_FW_RI_RES_WR_IQCPRIO	V_FW_RI_RES_WR_IQCPRIO(1U)
+
+#define S_FW_RI_RES_WR_IQESIZE		0
+#define M_FW_RI_RES_WR_IQESIZE		0x3
+#define V_FW_RI_RES_WR_IQESIZE(x)	((x) << S_FW_RI_RES_WR_IQESIZE)
+#define G_FW_RI_RES_WR_IQESIZE(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQESIZE) & M_FW_RI_RES_WR_IQESIZE)
+
+#define S_FW_RI_RES_WR_IQNS	31
+#define M_FW_RI_RES_WR_IQNS	0x1
+#define V_FW_RI_RES_WR_IQNS(x)	((x) << S_FW_RI_RES_WR_IQNS)
+#define G_FW_RI_RES_WR_IQNS(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQNS) & M_FW_RI_RES_WR_IQNS)
+#define F_FW_RI_RES_WR_IQNS	V_FW_RI_RES_WR_IQNS(1U)
+
+#define S_FW_RI_RES_WR_IQRO	30
+#define M_FW_RI_RES_WR_IQRO	0x1
+#define V_FW_RI_RES_WR_IQRO(x)	((x) << S_FW_RI_RES_WR_IQRO)
+#define G_FW_RI_RES_WR_IQRO(x)	\
+    (((x) >> S_FW_RI_RES_WR_IQRO) & M_FW_RI_RES_WR_IQRO)
+#define F_FW_RI_RES_WR_IQRO	V_FW_RI_RES_WR_IQRO(1U)
+
+enum fw_ri_type {
+	FW_RI_TYPE_INIT,
+	FW_RI_TYPE_FINI,
+	FW_RI_TYPE_TERMINATE
+};
+
+struct fw_ri_wr {
+	__be32 op_compl;
+	__be32 flowid_len16;
+	__u64  cookie;
+	union fw_ri {
+		struct fw_ri_init {
+			__u8   type;
+			__u8   mpareqbit_p2ptype;
+			__u8   r4[2];
+			__u8   mpa_attrs;
+			__u8   qp_caps;
+			__be16 nrqe;
+			__be32 pdid;
+			__be32 qpid;
+			__be32 sq_eqid;
+			__be32 rq_eqid;
+			__be32 scqid;
+			__be32 rcqid;
+			__be32 ord_max;
+			__be32 ird_max;
+			__be32 iss;
+			__be32 irs;
+			__be32 hwrqsize;
+			__be32 hwrqaddr;
+			__be64 r5;
+		} init;
+		struct fw_ri_fini {
+			__u8   type;
+			__u8   r3[7];
+			__be64 r4;
+		} fini;
+		struct fw_ri_terminate {
+			__u8   type;
+			__u8   r3[3];
+			__be32 immdlen;
+			__u8   termmsg[40];
+		} terminate;
+	} u;
+};
+
+#define S_FW_RI_WR_MPAREQBIT	7
+#define M_FW_RI_WR_MPAREQBIT	0x1
+#define V_FW_RI_WR_MPAREQBIT(x)	((x) << S_FW_RI_WR_MPAREQBIT)
+#define G_FW_RI_WR_MPAREQBIT(x)	\
+    (((x) >> S_FW_RI_WR_MPAREQBIT) & M_FW_RI_WR_MPAREQBIT)
+#define F_FW_RI_WR_MPAREQBIT	V_FW_RI_WR_MPAREQBIT(1U)
+
+#define S_FW_RI_WR_P2PTYPE	0
+#define M_FW_RI_WR_P2PTYPE	0xf
+#define V_FW_RI_WR_P2PTYPE(x)	((x) << S_FW_RI_WR_P2PTYPE)
+#define G_FW_RI_WR_P2PTYPE(x)	\
+    (((x) >> S_FW_RI_WR_P2PTYPE) & M_FW_RI_WR_P2PTYPE)
+
+struct fw_ri_rdma_write_wr {
+	__u8   opcode;
+	__u8   flags;
+	__u16  wrid;
+	__u8   r1[3];
+	__u8   len16;
+	__be64 r2;
+	__be32 plen;
+	__be32 stag_sink;
+	__be64 to_sink;
+	struct fw_ri_immd immd_src[0];
+	struct fw_ri_isgl isgl_src[0];
+};
+
+struct fw_ri_send_wr {
+	__u8   opcode;
+	__u8   flags;
+	__u16  wrid;
+	__u8   r1[3];
+	__u8   len16;
+	__be32 sendop_pkd;
+	__be32 stag_inv;
+	__be32 plen;
+	__be32 r3;
+	__be64 r4;
+	struct fw_ri_immd immd_src[0];
+	struct fw_ri_isgl isgl_src[0];
+};
+
+#define S_FW_RI_SEND_WR_SENDOP		0
+#define M_FW_RI_SEND_WR_SENDOP		0xf
+#define V_FW_RI_SEND_WR_SENDOP(x)	((x) << S_FW_RI_SEND_WR_SENDOP)
+#define G_FW_RI_SEND_WR_SENDOP(x)	\
+    (((x) >> S_FW_RI_SEND_WR_SENDOP) & M_FW_RI_SEND_WR_SENDOP)
+
+struct fw_ri_rdma_read_wr {
+	__u8   opcode;
+	__u8   flags;
+	__u16  wrid;
+	__u8   r1[3];
+	__u8   len16;
+	__be64 r2;
+	__be32 stag_sink;
+	__be32 to_sink_hi;
+	__be32 to_sink_lo;
+	__be32 plen;
+	__be32 stag_src;
+	__be32 to_src_hi;
+	__be32 to_src_lo;
+	__be32 r5;
+};
+
+struct fw_ri_recv_wr {
+	__u8   opcode;
+	__u8   r1;
+	__u16  wrid;
+	__u8   r2[3];
+	__u8   len16;
+	struct fw_ri_isgl isgl;
+};
+
+struct fw_ri_bind_mw_wr {
+	__u8   opcode;
+	__u8   flags;
+	__u16  wrid;
+	__u8   r1[3];
+	__u8   len16;
+	__u8   qpbinde_to_dcacpu;
+	__u8   pgsz_shift;
+	__u8   addr_type;
+	__u8   mem_perms;
+	__be32 stag_mr;
+	__be32 stag_mw;
+	__be32 r3;
+	__be64 len_mw;
+	__be64 va_fbo;
+	__be64 r4;
+};
+
+#define S_FW_RI_BIND_MW_WR_QPBINDE	6
+#define M_FW_RI_BIND_MW_WR_QPBINDE	0x1
+#define V_FW_RI_BIND_MW_WR_QPBINDE(x)	((x) << S_FW_RI_BIND_MW_WR_QPBINDE)
+#define G_FW_RI_BIND_MW_WR_QPBINDE(x)	\
+    (((x) >> S_FW_RI_BIND_MW_WR_QPBINDE) & M_FW_RI_BIND_MW_WR_QPBINDE)
+#define F_FW_RI_BIND_MW_WR_QPBINDE	V_FW_RI_BIND_MW_WR_QPBINDE(1U)
+
+#define S_FW_RI_BIND_MW_WR_NS		5
+#define M_FW_RI_BIND_MW_WR_NS		0x1
+#define V_FW_RI_BIND_MW_WR_NS(x)	((x) << S_FW_RI_BIND_MW_WR_NS)
+#define G_FW_RI_BIND_MW_WR_NS(x)	\
+    (((x) >> S_FW_RI_BIND_MW_WR_NS) & M_FW_RI_BIND_MW_WR_NS)
+#define F_FW_RI_BIND_MW_WR_NS	V_FW_RI_BIND_MW_WR_NS(1U)
+
+#define S_FW_RI_BIND_MW_WR_DCACPU	0
+#define M_FW_RI_BIND_MW_WR_DCACPU	0x1f
+#define V_FW_RI_BIND_MW_WR_DCACPU(x)	((x) << S_FW_RI_BIND_MW_WR_DCACPU)
+#define G_FW_RI_BIND_MW_WR_DCACPU(x)	\
+    (((x) >> S_FW_RI_BIND_MW_WR_DCACPU) & M_FW_RI_BIND_MW_WR_DCACPU)
+
+struct fw_ri_fr_nsmr_wr {
+	__u8   opcode;
+	__u8   flags;
+	__u16  wrid;
+	__u8   r1[3];
+	__u8   len16;
+	__u8   qpbinde_to_dcacpu;
+	__u8   pgsz_shift;
+	__u8   addr_type;
+	__u8   mem_perms;
+	__be32 stag;
+	__be32 len_hi;
+	__be32 len_lo;
+	__be32 va_hi;
+	__be32 va_lo_fbo;
+};
+
+#define S_FW_RI_FR_NSMR_WR_QPBINDE	6
+#define M_FW_RI_FR_NSMR_WR_QPBINDE	0x1
+#define V_FW_RI_FR_NSMR_WR_QPBINDE(x)	((x) << S_FW_RI_FR_NSMR_WR_QPBINDE)
+#define G_FW_RI_FR_NSMR_WR_QPBINDE(x)	\
+    (((x) >> S_FW_RI_FR_NSMR_WR_QPBINDE) & M_FW_RI_FR_NSMR_WR_QPBINDE)
+#define F_FW_RI_FR_NSMR_WR_QPBINDE	V_FW_RI_FR_NSMR_WR_QPBINDE(1U)
+
+#define S_FW_RI_FR_NSMR_WR_NS		5
+#define M_FW_RI_FR_NSMR_WR_NS		0x1
+#define V_FW_RI_FR_NSMR_WR_NS(x)	((x) << S_FW_RI_FR_NSMR_WR_NS)
+#define G_FW_RI_FR_NSMR_WR_NS(x)	\
+    (((x) >> S_FW_RI_FR_NSMR_WR_NS) & M_FW_RI_FR_NSMR_WR_NS)
+#define F_FW_RI_FR_NSMR_WR_NS	V_FW_RI_FR_NSMR_WR_NS(1U)
+
+#define S_FW_RI_FR_NSMR_WR_DCACPU	0
+#define M_FW_RI_FR_NSMR_WR_DCACPU	0x1f
+#define V_FW_RI_FR_NSMR_WR_DCACPU(x)	((x) << S_FW_RI_FR_NSMR_WR_DCACPU)
+#define G_FW_RI_FR_NSMR_WR_DCACPU(x)	\
+    (((x) >> S_FW_RI_FR_NSMR_WR_DCACPU) & M_FW_RI_FR_NSMR_WR_DCACPU)
+
+struct fw_ri_inv_lstag_wr {
+	__u8   opcode;
+	__u8   flags;
+	__u16  wrid;
+	__u8   r1[3];
+	__u8   len16;
+	__be32 r2;
+	__be32 stag_inv;
+};
+
+struct tcp_options {
+	__be16 mss;
+	__u8 wsf;
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8:4;
+	__u8 unknown:1;
+	__u8:1;
+	__u8 sack:1;
+	__u8 tstamp:1;
+#else
+	__u8 tstamp:1;
+	__u8 sack:1;
+	__u8:1;
+	__u8 unknown:1;
+	__u8:4;
+#endif
+};
+
+struct cpl_pass_accept_req {
+	union opcode_tid ot;
+	__be16 rsvd;
+	__be16 len;
+	__be32 hdr_len;
+	__be16 vlan;
+	__be16 l2info;
+	__be32 tos_stid;
+	struct tcp_options tcpopt;
+};
+
+/* cpl_pass_accept_req.hdr_len fields */
+#define S_SYN_RX_CHAN    0
+#define M_SYN_RX_CHAN    0xF
+#define V_SYN_RX_CHAN(x) ((x) << S_SYN_RX_CHAN)
+#define G_SYN_RX_CHAN(x) (((x) >> S_SYN_RX_CHAN) & M_SYN_RX_CHAN)
+
+#define S_TCP_HDR_LEN    10
+#define M_TCP_HDR_LEN    0x3F
+#define V_TCP_HDR_LEN(x) ((x) << S_TCP_HDR_LEN)
+#define G_TCP_HDR_LEN(x) (((x) >> S_TCP_HDR_LEN) & M_TCP_HDR_LEN)
+
+#define S_IP_HDR_LEN    16
+#define M_IP_HDR_LEN    0x3FF
+#define V_IP_HDR_LEN(x) ((x) << S_IP_HDR_LEN)
+#define G_IP_HDR_LEN(x) (((x) >> S_IP_HDR_LEN) & M_IP_HDR_LEN)
+
+#define S_ETH_HDR_LEN    26
+#define M_ETH_HDR_LEN    0x1F
+#define V_ETH_HDR_LEN(x) ((x) << S_ETH_HDR_LEN)
+#define G_ETH_HDR_LEN(x) (((x) >> S_ETH_HDR_LEN) & M_ETH_HDR_LEN)
+
+/* cpl_pass_accept_req.l2info fields */
+#define S_SYN_MAC_IDX    0
+#define M_SYN_MAC_IDX    0x1FF
+#define V_SYN_MAC_IDX(x) ((x) << S_SYN_MAC_IDX)
+#define G_SYN_MAC_IDX(x) (((x) >> S_SYN_MAC_IDX) & M_SYN_MAC_IDX)
+
+#define S_SYN_XACT_MATCH    9
+#define V_SYN_XACT_MATCH(x) ((x) << S_SYN_XACT_MATCH)
+#define F_SYN_XACT_MATCH    V_SYN_XACT_MATCH(1U)
+
+#define S_SYN_INTF    12
+#define M_SYN_INTF    0xF
+#define V_SYN_INTF(x) ((x) << S_SYN_INTF)
+#define G_SYN_INTF(x) (((x) >> S_SYN_INTF) & M_SYN_INTF)
+
+struct ulptx_idata {
+	__be32 cmd_more;
+	__be32 len;
+};
+
+#define S_ULPTX_NSGE    0
+#define M_ULPTX_NSGE    0xFFFF
+#define V_ULPTX_NSGE(x) ((x) << S_ULPTX_NSGE)
+#endif /* _T4FW_RI_API_H_ */
diff --git a/drivers/infiniband/hw/cxgb4/user.h b/drivers/infiniband/hw/cxgb4/user.h
new file mode 100644
index 0000000..ed6414a
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/user.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
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
+#ifndef __C4IW_USER_H__
+#define __C4IW_USER_H__
+
+#define C4IW_UVERBS_ABI_VERSION	1
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+struct c4iw_create_cq_resp {
+	__u64 key;
+	__u64 gts_key;
+	__u64 memsize;
+	__u32 cqid;
+	__u32 size;
+	__u32 qid_mask;
+};
+
+struct c4iw_create_qp_resp {
+	__u64 sq_key;
+	__u64 rq_key;
+	__u64 sq_db_gts_key;
+	__u64 rq_db_gts_key;
+	__u64 sq_memsize;
+	__u64 rq_memsize;
+	__u32 sqid;
+	__u32 rqid;
+	__u32 sq_size;
+	__u32 rq_size;
+	__u32 qid_mask;
+};
+#endif

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
