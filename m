From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 09/10] iw_cxgb4: Add event management functions.
Date: Fri, 02 Apr 2010 14:24:35 -0500
Message-ID: <20100402192435.14117.51289.stgit@build.ogc.int>
References: <20100402192346.14117.92767.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100402192346.14117.92767.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/ev.c |  223 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb4/ev.c

diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
new file mode 100644
index 0000000..13a1ef4
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -0,0 +1,223 @@
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
+#include <linux/slab.h>
+#include <linux/mman.h>
+#include <net/sock.h>
+
+#include "iw_cxgb4.h"
+
+static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
+			  struct c4iw_qp *qhp,
+			  struct t4_cqe *err_cqe,
+			  enum ib_event_type ib_event,
+			  int send_term)
+{
+	struct ib_event event;
+	struct c4iw_qp_attributes attrs;
+
+	if ((qhp->attr.state == C4IW_QP_STATE_ERROR) ||
+	    (qhp->attr.state == C4IW_QP_STATE_TERMINATE)) {
+		PDBG("%s AE received after RTS - "
+		     "qp state %d qpid 0x%x status 0x%x\n", __func__,
+		     qhp->attr.state, qhp->wq.sq.qid, CQE_STATUS(err_cqe));
+		return;
+	}
+
+	printk(KERN_ERR "%s - AE qpid 0x%x opcode %d status 0x%x "
+	       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __func__,
+	       CQE_QPID(err_cqe), CQE_OPCODE(err_cqe),
+	       CQE_STATUS(err_cqe), CQE_TYPE(err_cqe),
+	       CQE_WRID_HI(err_cqe), CQE_WRID_LOW(err_cqe));
+
+	if (qhp->attr.state == C4IW_QP_STATE_RTS) {
+		attrs.next_state = C4IW_QP_STATE_TERMINATE;
+		c4iw_modify_qp(qhp->rhp, qhp, C4IW_QP_ATTR_NEXT_STATE,
+			       &attrs, 1);
+		if (send_term)
+			c4iw_post_terminate(qhp, err_cqe);
+	}
+
+	event.event = ib_event;
+	event.device = chp->ibcq.device;
+	if (ib_event == IB_EVENT_CQ_ERR)
+		event.element.cq = &chp->ibcq;
+	else
+		event.element.qp = &qhp->ibqp;
+	if (qhp->ibqp.event_handler)
+		(*qhp->ibqp.event_handler)(&event, qhp->ibqp.qp_context);
+
+	(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
+}
+
+void c4iw_ev_dispatch(struct c4iw_dev *dev, struct t4_cqe *err_cqe)
+{
+	struct c4iw_cq *chp;
+	struct c4iw_qp *qhp;
+	u32 cqid;
+
+	spin_lock(&dev->lock);
+	qhp = get_qhp(dev, CQE_QPID(err_cqe));
+	if (!qhp) {
+		printk(KERN_ERR MOD "BAD AE qpid 0x%x opcode %d "
+		       "status 0x%x type %d wrid.hi 0x%x wrid.lo 0x%x \n",
+		       CQE_QPID(err_cqe),
+		       CQE_OPCODE(err_cqe), CQE_STATUS(err_cqe),
+		       CQE_TYPE(err_cqe), CQE_WRID_HI(err_cqe),
+		       CQE_WRID_LOW(err_cqe));
+		spin_unlock(&dev->lock);
+		goto out;
+	}
+
+	if (SQ_TYPE(err_cqe))
+		cqid = qhp->attr.scq;
+	else
+		cqid = qhp->attr.rcq;
+	chp = get_chp(dev, cqid);
+	if (!chp) {
+		printk(KERN_ERR MOD "BAD AE cqid 0x%x qpid 0x%x opcode %d "
+		       "status 0x%x type %d wrid.hi 0x%x wrid.lo 0x%x \n",
+		       cqid, CQE_QPID(err_cqe),
+		       CQE_OPCODE(err_cqe), CQE_STATUS(err_cqe),
+		       CQE_TYPE(err_cqe), CQE_WRID_HI(err_cqe),
+		       CQE_WRID_LOW(err_cqe));
+		spin_unlock(&dev->lock);
+		goto out;
+	}
+
+	c4iw_qp_add_ref(&qhp->ibqp);
+	atomic_inc(&chp->refcnt);
+	spin_unlock(&dev->lock);
+
+	/*
+	 * 1) completion of our sending a TERMINATE.
+	 * 2) incoming TERMINATE message.
+	 */
+	if ((CQE_OPCODE(err_cqe) == FW_RI_TERMINATE) &&
+	    (CQE_STATUS(err_cqe) == 0)) {
+		if (SQ_TYPE(err_cqe)) {
+			PDBG("%s QPID 0x%x ep %p disconnecting\n",
+			     __func__, qhp->wq.sq.qid, qhp->ep);
+			c4iw_ep_disconnect(qhp->ep, 0, GFP_ATOMIC);
+		} else {
+			PDBG("%s post REQ_ERR AE QPID 0x%x\n", __func__,
+			     qhp->wq.sq.qid);
+			post_qp_event(dev, chp, qhp, err_cqe,
+				      IB_EVENT_QP_REQ_ERR, 0);
+			c4iw_ep_disconnect(qhp->ep, 0, GFP_ATOMIC);
+		}
+		goto done;
+	}
+
+	/* Bad incoming Read request */
+	if (SQ_TYPE(err_cqe) &&
+	    (CQE_OPCODE(err_cqe) == FW_RI_READ_RESP)) {
+		post_qp_event(dev, chp, qhp, err_cqe, IB_EVENT_QP_REQ_ERR, 1);
+		goto done;
+	}
+
+	/* Bad incoming write */
+	if (RQ_TYPE(err_cqe) &&
+	    (CQE_OPCODE(err_cqe) == FW_RI_RDMA_WRITE)) {
+		post_qp_event(dev, chp, qhp, err_cqe, IB_EVENT_QP_REQ_ERR, 1);
+		goto done;
+	}
+
+	switch (CQE_STATUS(err_cqe)) {
+
+	/* Completion Events */
+	case T4_ERR_SUCCESS:
+		printk(KERN_ERR MOD "AE with status 0!\n");
+		break;
+
+	case T4_ERR_STAG:
+	case T4_ERR_PDID:
+	case T4_ERR_QPID:
+	case T4_ERR_ACCESS:
+	case T4_ERR_WRAP:
+	case T4_ERR_BOUND:
+	case T4_ERR_INVALIDATE_SHARED_MR:
+	case T4_ERR_INVALIDATE_MR_WITH_MW_BOUND:
+		post_qp_event(dev, chp, qhp, err_cqe, IB_EVENT_QP_ACCESS_ERR,1);
+		break;
+
+	/* Device Fatal Errors */
+	case T4_ERR_ECC:
+	case T4_ERR_ECC_PSTAG:
+	case T4_ERR_INTERNAL_ERR:
+		post_qp_event(dev, chp, qhp, err_cqe, IB_EVENT_DEVICE_FATAL, 1);
+		break;
+
+	/* QP Fatal Errors */
+	case T4_ERR_OUT_OF_RQE:
+	case T4_ERR_PBL_ADDR_BOUND:
+	case T4_ERR_CRC:
+	case T4_ERR_MARKER:
+	case T4_ERR_PDU_LEN_ERR:
+	case T4_ERR_DDP_VERSION:
+	case T4_ERR_RDMA_VERSION:
+	case T4_ERR_OPCODE:
+	case T4_ERR_DDP_QUEUE_NUM:
+	case T4_ERR_MSN:
+	case T4_ERR_TBIT:
+	case T4_ERR_MO:
+	case T4_ERR_MSN_GAP:
+	case T4_ERR_MSN_RANGE:
+	case T4_ERR_RQE_ADDR_BOUND:
+	case T4_ERR_IRD_OVERFLOW:
+		post_qp_event(dev, chp, qhp, err_cqe, IB_EVENT_QP_FATAL, 1);
+		break;
+
+	default:
+		printk(KERN_ERR MOD "Unknown T4 status 0x%x QPID 0x%x\n",
+		       CQE_STATUS(err_cqe), qhp->wq.sq.qid);
+		post_qp_event(dev, chp, qhp, err_cqe, IB_EVENT_QP_FATAL, 1);
+		break;
+	}
+done:
+	if (atomic_dec_and_test(&chp->refcnt))
+	        wake_up(&chp->wait);
+	c4iw_qp_rem_ref(&qhp->ibqp);
+out:
+	return;
+}
+
+int c4iw_ev_handler(struct c4iw_dev *dev, u32 qid)
+{
+	struct c4iw_cq *chp;
+
+	chp = get_chp(dev, qid);
+	if (chp)
+		(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
+	else
+		PDBG("%s unknown cqid 0x%x\n", __func__, qid);
+	return 0;
+}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
