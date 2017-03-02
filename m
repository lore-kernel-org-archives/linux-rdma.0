From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/rxe: Add port protocol stats
Date: Thu,  2 Mar 2017 10:15:54 +0200
Message-ID: <20170302081554.5012-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose new counters using the get_hw_stats callback.
We expose the following counters:

+---------------------+----------------------------------------+
|      Name           |           Description                  |
|---------------------+----------------------------------------|
|sent_pkts            | number of sent pkts                    |
|---------------------+----------------------------------------|
|rcvd_pkts            | number of received packets             |
|---------------------+----------------------------------------|
|out_of_sequence      | number of errors due to packet         |
|                     | transport sequence number              |
|---------------------+----------------------------------------|
|duplicate_request    | number of received duplicated packets. |
|                     | A request that previously executed is  |
|                     | named duplicated.                      |
|---------------------+----------------------------------------|
|rcvd_rnr_err         | number of received RNR by completer    |
|---------------------+----------------------------------------|
|send_rnr_err         | number of sent RNR by responder        |
|---------------------+----------------------------------------|
|rcvd_seq_err         | number of out of sequence packets      |
|                     | received                               |
|---------------------+----------------------------------------|
|ack_deffered         | number of deferred handling of ack     |
|                     | packets.                               |
|---------------------+----------------------------------------|
|retry_exceeded_err   | number of times retry exceeded         |
|---------------------+----------------------------------------|
|completer_retry_err  | number of times completer decided to   |
|                     | retry                                  |
|---------------------+----------------------------------------|
|send_err             | number of failed send packet           |
+---------------------+----------------------------------------+

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

---
Hi Doug,

This patch applies cleanly on latest Linus's master branch.
It was prepared and tested a long time ago, but I delayed it
due to merge conflicts and my vacation. In case, you have plans
to create another pull request to Linus with Danny's code [1],
I would like to consider inclusion of this patch too.

Thanks

[1] http://marc.info/?l=linux-rdma&m=148839266418779&w=2
---
 drivers/infiniband/sw/rxe/Makefile          |  3 +-
 drivers/infiniband/sw/rxe/rxe_comp.c        | 12 +++++
 drivers/infiniband/sw/rxe/rxe_hw_counters.c | 78 +++++++++++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_hw_counters.h | 61 ++++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_loc.h         |  2 +
 drivers/infiniband/sw/rxe/rxe_recv.c        |  2 +
 drivers/infiniband/sw/rxe/rxe_resp.c        |  5 ++
 drivers/infiniband/sw/rxe/rxe_verbs.c       |  3 ++
 drivers/infiniband/sw/rxe/rxe_verbs.h       |  8 +++
 9 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/sw/rxe/rxe_hw_counters.c
 create mode 100644 drivers/infiniband/sw/rxe/rxe_hw_counters.h

diff --git a/drivers/infiniband/sw/rxe/Makefile b/drivers/infiniband/sw/rxe/Makefile
index ec35ff022a42..3f12beb7076f 100644
--- a/drivers/infiniband/sw/rxe/Makefile
+++ b/drivers/infiniband/sw/rxe/Makefile
@@ -20,4 +20,5 @@ rdma_rxe-y := \
 	rxe_mcast.o \
 	rxe_task.o \
 	rxe_net.o \
-	rxe_sysfs.o
+	rxe_sysfs.o \
+	rxe_hw_counters.o
diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 4cd55d5617f7..85343f339624 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -154,6 +154,8 @@ void rxe_comp_queue_pkt(struct rxe_dev *rxe, struct rxe_qp *qp,
 	skb_queue_tail(&qp->resp_pkts, skb);

 	must_sched = skb_queue_len(&qp->resp_pkts) > 1;
+	if (must_sched != 0)
+		rxe_counter_inc(rxe, RXE_CNT_COMPLETER_SCHED);
 	rxe_run_task(&qp->comp.task, must_sched);
 }

@@ -236,6 +238,7 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
 {
 	unsigned int mask = pkt->mask;
 	u8 syn;
+	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);

 	/* Check the sequence only */
 	switch (qp->comp.opcode) {
@@ -298,6 +301,7 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
 			return COMPST_WRITE_SEND;

 		case AETH_RNR_NAK:
+			rxe_counter_inc(rxe, RXE_CNT_RCV_RNR);
 			return COMPST_RNR_RETRY;

 		case AETH_NAK:
@@ -307,6 +311,8 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
 				 * before
 				 */
 				if (psn_compare(pkt->psn, qp->comp.psn) > 0) {
+					rxe_counter_inc(rxe,
+							RXE_CNT_RCV_SEQ_ERR);
 					qp->comp.psn = pkt->psn;
 					if (qp->req.wait_psn) {
 						qp->req.wait_psn = 0;
@@ -534,6 +540,7 @@ static void rxe_drain_resp_pkts(struct rxe_qp *qp, bool notify)
 int rxe_completer(void *arg)
 {
 	struct rxe_qp *qp = (struct rxe_qp *)arg;
+	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	struct rxe_send_wqe *wqe = wqe;
 	struct sk_buff *skb = NULL;
 	struct rxe_pkt_info *pkt = NULL;
@@ -685,6 +692,8 @@ int rxe_completer(void *arg)
 					/* tell the requester to retry the
 					 * send send queue next time around
 					 */
+					rxe_counter_inc(rxe,
+							RXE_CNT_COMP_RETRY);
 					qp->req.need_retry = 1;
 					rxe_run_task(&qp->req.task, 1);
 				}
@@ -699,6 +708,7 @@ int rxe_completer(void *arg)
 				goto exit;

 			} else {
+				rxe_counter_inc(rxe, RXE_CNT_RETRY_EXCEEDED);
 				wqe->status = IB_WC_RETRY_EXC_ERR;
 				state = COMPST_ERROR;
 			}
@@ -720,6 +730,8 @@ int rxe_completer(void *arg)
 				skb = NULL;
 				goto exit;
 			} else {
+				rxe_counter_inc(rxe,
+						RXE_CNT_RNR_RETRY_EXCEEDED);
 				wqe->status = IB_WC_RNR_RETRY_EXC_ERR;
 				state = COMPST_ERROR;
 			}
diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.c b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
new file mode 100644
index 000000000000..7ef90aad7dfd
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
@@ -0,0 +1,78 @@
+/*
+ * Copyright (c) 2017 Mellanox Technologies Ltd. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
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
+
+#include "rxe.h"
+#include "rxe_hw_counters.h"
+
+const char * const rxe_counter_name[] = {
+	[RXE_CNT_SENT_PKTS]           =  "sent_pkts",
+	[RXE_CNT_RCVD_PKTS]           =  "rcvd_pkts",
+	[RXE_CNT_DUP_REQ]             =  "duplicate_request",
+	[RXE_CNT_OUT_OF_SEQ_REQ]      =  "out_of_sequence",
+	[RXE_CNT_RCV_RNR]             =  "rcvd_rnr_err",
+	[RXE_CNT_SND_RNR]             =  "send_rnr_err",
+	[RXE_CNT_RCV_SEQ_ERR]         =  "rcvd_seq_err",
+	[RXE_CNT_COMPLETER_SCHED]     =  "ack_deffered",
+	[RXE_CNT_RETRY_EXCEEDED]      =  "retry_exceeded_err",
+	[RXE_CNT_RNR_RETRY_EXCEEDED]  =  "retry_rnr_exceeded_err",
+	[RXE_CNT_COMP_RETRY]          =  "completer_retry_err",
+	[RXE_CNT_SEND_ERR]            =  "send_err",
+};
+
+int rxe_ib_get_hw_stats(struct ib_device *ibdev,
+			struct rdma_hw_stats *stats,
+			u8 port, int index)
+{
+	struct rxe_dev *dev = to_rdev(ibdev);
+	unsigned int cnt;
+
+	if (!port || !stats)
+		return -EINVAL;
+
+	for (cnt = 0; cnt  < ARRAY_SIZE(rxe_counter_name); cnt++)
+		stats->value[cnt] = dev->stats_counters[cnt];
+
+	return ARRAY_SIZE(rxe_counter_name);
+}
+
+struct rdma_hw_stats *rxe_ib_alloc_hw_stats(struct ib_device *ibdev,
+					    u8 port_num)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(rxe_counter_name) != RXE_NUM_OF_COUNTERS);
+	/* We support only per port stats */
+	if (!port_num)
+		return NULL;
+
+	return rdma_alloc_hw_stats_struct(rxe_counter_name,
+					  ARRAY_SIZE(rxe_counter_name),
+					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+}
diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.h b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
new file mode 100644
index 000000000000..f44df1b76742
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (c) 2017 Mellanox Technologies Ltd. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
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
+
+#ifndef RXE_HW_COUNTERS_H
+#define RXE_HW_COUNTERS_H
+
+/*
+ * when adding counters to enum also add
+ * them to rxe_counter_name[] vector.
+ */
+enum rxe_counters {
+	RXE_CNT_SENT_PKTS,
+	RXE_CNT_RCVD_PKTS,
+	RXE_CNT_DUP_REQ,
+	RXE_CNT_OUT_OF_SEQ_REQ,
+	RXE_CNT_RCV_RNR,
+	RXE_CNT_SND_RNR,
+	RXE_CNT_RCV_SEQ_ERR,
+	RXE_CNT_COMPLETER_SCHED,
+	RXE_CNT_RETRY_EXCEEDED,
+	RXE_CNT_RNR_RETRY_EXCEEDED,
+	RXE_CNT_COMP_RETRY,
+	RXE_CNT_SEND_ERR,
+	RXE_NUM_OF_COUNTERS
+};
+
+struct rdma_hw_stats *rxe_ib_alloc_hw_stats(struct ib_device *ibdev,
+					    u8 port_num);
+int rxe_ib_get_hw_stats(struct ib_device *ibdev,
+			struct rdma_hw_stats *stats,
+			u8 port, int index);
+#endif /* RXE_HW_COUNTERS_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 183a9d379b41..651784358f2b 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -278,6 +278,7 @@ static inline int rxe_xmit_packet(struct rxe_dev *rxe, struct rxe_qp *qp,

 	if (err) {
 		rxe->xmit_errors++;
+		rxe_counter_inc(rxe, RXE_CNT_SEND_ERR);
 		return err;
 	}

@@ -287,6 +288,7 @@ static inline int rxe_xmit_packet(struct rxe_dev *rxe, struct rxe_qp *qp,
 		rxe_run_task(&qp->comp.task, 1);
 	}

+	rxe_counter_inc(rxe, RXE_CNT_SENT_PKTS);
 	goto done;

 drop:
diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 50886031096f..dadd4a0e3cf7 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -403,6 +403,8 @@ int rxe_rcv(struct sk_buff *skb)
 		goto drop;
 	}

+	rxe_counter_inc(rxe, RXE_CNT_RCVD_PKTS);
+
 	if (unlikely(bth_qpn(pkt) == IB_MULTICAST_QPN))
 		rxe_rcv_mcast_pkt(rxe, skb);
 	else
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index d404a8aba7af..d42f4847e928 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -149,6 +149,7 @@ static enum resp_states check_psn(struct rxe_qp *qp,
 				  struct rxe_pkt_info *pkt)
 {
 	int diff = psn_compare(pkt->psn, qp->resp.psn);
+	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);

 	switch (qp_type(qp)) {
 	case IB_QPT_RC:
@@ -157,9 +158,11 @@ static enum resp_states check_psn(struct rxe_qp *qp,
 				return RESPST_CLEANUP;

 			qp->resp.sent_psn_nak = 1;
+			rxe_counter_inc(rxe, RXE_CNT_OUT_OF_SEQ_REQ);
 			return RESPST_ERR_PSN_OUT_OF_SEQ;

 		} else if (diff < 0) {
+			rxe_counter_inc(rxe, RXE_CNT_DUP_REQ);
 			return RESPST_DUPLICATE_REQUEST;
 		}

@@ -1224,6 +1227,7 @@ void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
 int rxe_responder(void *arg)
 {
 	struct rxe_qp *qp = (struct rxe_qp *)arg;
+	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	enum resp_states state;
 	struct rxe_pkt_info *pkt = NULL;
 	int ret = 0;
@@ -1312,6 +1316,7 @@ int rxe_responder(void *arg)
 			break;
 		case RESPST_ERR_RNR:
 			if (qp_type(qp) == IB_QPT_RC) {
+				rxe_counter_inc(rxe, RXE_CNT_SND_RNR);
 				/* RC - class B */
 				send_ack(qp, pkt, AETH_RNR_NAK |
 					 (~AETH_TYPE_MASK &
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 5113e502f6f9..f75210e47802 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -35,6 +35,7 @@
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_queue.h"
+#include "rxe_hw_counters.h"

 static int rxe_query_device(struct ib_device *dev,
 			    struct ib_device_attr *attr,
@@ -1318,6 +1319,8 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->map_mr_sg = rxe_map_mr_sg;
 	dev->attach_mcast = rxe_attach_mcast;
 	dev->detach_mcast = rxe_detach_mcast;
+	dev->get_hw_stats = rxe_ib_get_hw_stats;
+	dev->alloc_hw_stats = rxe_ib_alloc_hw_stats;

 	err = ib_register_device(dev, NULL);
 	if (err) {
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index e100c500ae85..3abe9ca97599 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -38,6 +38,7 @@
 #include <rdma/rdma_user_rxe.h>
 #include "rxe_pool.h"
 #include "rxe_task.h"
+#include "rxe_hw_counters.h"

 static inline int pkey_match(u16 key1, u16 key2)
 {
@@ -401,10 +402,17 @@ struct rxe_dev {
 	spinlock_t		mmap_offset_lock; /* guard mmap_offset */
 	int			mmap_offset;

+	u64 stats_counters[RXE_NUM_OF_COUNTERS];
+
 	struct rxe_port		port;
 	struct list_head	list;
 };

+static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters cnt)
+{
+	rxe->stats_counters[cnt]++;
+}
+
 static inline struct rxe_dev *to_rdev(struct ib_device *dev)
 {
 	return dev ? container_of(dev, struct rxe_dev, ib_dev) : NULL;
--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
