From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 33/36] IB/rdmavt: Break rdma_vt main include header file
 up
Date: Wed, 06 Jan 2016 10:04:31 -0800
Message-ID: <20160106180428.8747.33857.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Until all functionality is moved over to rdmavt drivers still need to
access a number of fields in data structures that are predominantly
meant to be used by rdmavt. Once these rdmavt_<ibta_object>.h header
files are no longer being touched by drivers their content should be
moved to rdmavt/<ibta_object>.h. While here move a couple #defines
over to more general IB verbs header files because they fit better.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/ah.c |    4 
 include/rdma/ib_verbs.h           |    1 
 include/rdma/rdma_vt.h            |  309 -------------------------------------
 include/rdma/rdmavt_mr.h          |  130 ++++++++++++++++
 include/rdma/rdmavt_qp.h          |  262 +++++++++++++++++++++++++++++++
 5 files changed, 398 insertions(+), 308 deletions(-)
 create mode 100644 include/rdma/rdmavt_mr.h
 create mode 100644 include/rdma/rdmavt_qp.h

diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
index 621afc3..c194d9d 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -78,8 +78,8 @@ int rvt_check_ah(struct ib_device *ibdev,
 	if (link != IB_LINK_LAYER_ETHERNET) {
 		if (ah_attr->dlid == 0)
 			return -EINVAL;
-		if (ah_attr->dlid >= RVT_MULTICAST_LID_BASE &&
-		    ah_attr->dlid != RVT_PERMISSIVE_LID &&
+		if (ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) &&
+		    ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE) &&
 		    !(ah_attr->ah_flags & IB_AH_GRH))
 			return -EINVAL;
 	}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 75fcc97..e90b64d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -612,6 +612,7 @@ enum {
 };
 
 #define IB_LID_PERMISSIVE	cpu_to_be16(0xFFFF)
+#define IB_MULTICAST_LID_BASE	cpu_to_be16(0xC000)
 
 enum ib_ah_flags {
 	IB_AH_GRH	= 1
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index ef66d2b..79da8ee 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -55,10 +55,9 @@
 
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include "ib_verbs.h"
-
-#define RVT_MULTICAST_LID_BASE 0xC000
-#define RVT_PERMISSIVE_LID 0xFFFF
+#include <rdma/ib_verbs.h>
+#include <rdma/rdmavt_mr.h>
+#include <rdma/rdmavt_qp.h>
 
 /*
  * For some of the IBTA objects there will likely be some
@@ -70,297 +69,6 @@
 #define RVT_FLAG_QP_INIT_DRIVER BIT(2)
 #define RVT_FLAG_CQ_INIT_DRIVER BIT(3)
 
-/*
- * For Memory Regions. This stuff should probably be moved into rdmavt/mr.h once
- * drivers no longer need access to the MR directly.
- */
-
-/*
- * A segment is a linear region of low physical memory.
- * Used by the verbs layer.
- */
-struct rvt_seg {
-	void *vaddr;
-	size_t length;
-};
-
-/* The number of rvt_segs that fit in a page. */
-#define RVT_SEGSZ     (PAGE_SIZE / sizeof(struct rvt_seg))
-
-struct rvt_segarray {
-	struct rvt_seg segs[RVT_SEGSZ];
-};
-
-struct rvt_mregion {
-	struct ib_pd *pd;       /* shares refcnt of ibmr.pd */
-	u64 user_base;          /* User's address for this region */
-	u64 iova;               /* IB start address of this region */
-	size_t length;
-	u32 lkey;
-	u32 offset;             /* offset (bytes) to start of region */
-	int access_flags;
-	u32 max_segs;           /* number of rvt_segs in all the arrays */
-	u32 mapsz;              /* size of the map array */
-	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
-	u8  lkey_published;     /* in global table */
-	struct completion comp; /* complete when refcount goes to zero */
-	atomic_t refcount;
-	struct rvt_segarray *map[0];    /* the segments */
-};
-
-#define RVT_MAX_LKEY_TABLE_BITS 23
-
-struct rvt_lkey_table {
-	spinlock_t lock; /* protect changes in this struct */
-	u32 next;               /* next unused index (speeds search) */
-	u32 gen;                /* generation count */
-	u32 max;                /* size of the table */
-	struct rvt_mregion __rcu **table;
-};
-
-/* End Memmory Region */
-
-/*
- * Things needed for the Queue Pair definition. Like the MR stuff above the
- * following should probably get moved to qp.h once drivers stop trying to make
- * and manipulate thier own QPs. For the few instnaces where a driver may need
- * to look into a queue pair there should be a pointer to a driver priavte data
- * structure that they can look at.
- */
-
-/*
- * These keep track of the copy progress within a memory region.
- * Used by the verbs layer.
- */
-struct rvt_sge {
-	struct rvt_mregion *mr;
-	void *vaddr;            /* kernel virtual address of segment */
-	u32 sge_length;         /* length of the SGE */
-	u32 length;             /* remaining length of the segment */
-	u16 m;                  /* current index: mr->map[m] */
-	u16 n;                  /* current index: mr->map[m]->segs[n] */
-};
-
-/*
- * Send work request queue entry.
- * The size of the sg_list is determined when the QP is created and stored
- * in qp->s_max_sge.
- */
-struct rvt_swqe {
-	union {
-		struct ib_send_wr wr;   /* don't use wr.sg_list */
-		struct ib_ud_wr ud_wr;
-		struct ib_reg_wr reg_wr;
-		struct ib_rdma_wr rdma_wr;
-		struct ib_atomic_wr atomic_wr;
-	};
-	u32 psn;                /* first packet sequence number */
-	u32 lpsn;               /* last packet sequence number */
-	u32 ssn;                /* send sequence number */
-	u32 length;             /* total length of data in sg_list */
-	struct rvt_sge sg_list[0];
-};
-
-/*
- * Receive work request queue entry.
- * The size of the sg_list is determined when the QP (or SRQ) is created
- * and stored in qp->r_rq.max_sge (or srq->rq.max_sge).
- */
-struct rvt_rwqe {
-	u64 wr_id;
-	u8 num_sge;
-	struct ib_sge sg_list[0];
-};
-
-/*
- * This structure is used to contain the head pointer, tail pointer,
- * and receive work queue entries as a single memory allocation so
- * it can be mmap'ed into user space.
- * Note that the wq array elements are variable size so you can't
- * just index into the array to get the N'th element;
- * use get_rwqe_ptr() instead.
- */
-struct rvt_rwq {
-	u32 head;               /* new work requests posted to the head */
-	u32 tail;               /* receives pull requests from here. */
-	struct rvt_rwqe wq[0];
-};
-
-struct rvt_rq {
-	struct rvt_rwq *wq;
-	u32 size;               /* size of RWQE array */
-	u8 max_sge;
-	/* protect changes in this struct */
-	spinlock_t lock ____cacheline_aligned_in_smp;
-};
-
-/*
- * This structure is used by rvt_mmap() to validate an offset
- * when an mmap() request is made.  The vm_area_struct then uses
- * this as its vm_private_data.
- */
-struct rvt_mmap_info {
-	struct list_head pending_mmaps;
-	struct ib_ucontext *context;
-	void *obj;
-	__u64 offset;
-	struct kref ref;
-	unsigned size;
-};
-
-#define RVT_MAX_RDMA_ATOMIC	16
-
-/*
- * This structure holds the information that the send tasklet needs
- * to send a RDMA read response or atomic operation.
- */
-struct rvt_ack_entry {
-	u8 opcode;
-	u8 sent;
-	u32 psn;
-	u32 lpsn;
-	union {
-		struct rvt_sge rdma_sge;
-		u64 atomic_data;
-	};
-};
-
-struct rvt_sge_state {
-	struct rvt_sge *sg_list;      /* next SGE to be used if any */
-	struct rvt_sge sge;   /* progress state for the current SGE */
-	u32 total_len;
-	u8 num_sge;
-};
-
-/*
- * Variables prefixed with s_ are for the requester (sender).
- * Variables prefixed with r_ are for the responder (receiver).
- * Variables prefixed with ack_ are for responder replies.
- *
- * Common variables are protected by both r_rq.lock and s_lock in that order
- * which only happens in modify_qp() or changing the QP 'state'.
- */
-struct rvt_qp {
-	struct ib_qp ibqp;
-	void *priv; /* Driver private data */
-	/* read mostly fields above and below */
-	struct ib_ah_attr remote_ah_attr;
-	struct ib_ah_attr alt_ah_attr;
-	struct rvt_qp __rcu *next;           /* link list for QPN hash table */
-	struct rvt_swqe *s_wq;  /* send work queue */
-	struct rvt_mmap_info *ip;
-
-	unsigned long timeout_jiffies;  /* computed from timeout */
-
-	enum ib_mtu path_mtu;
-	int srate_mbps;		/* s_srate (below) converted to Mbit/s */
-	u32 remote_qpn;
-	u32 pmtu;		/* decoded from path_mtu */
-	u32 qkey;               /* QKEY for this QP (for UD or RD) */
-	u32 s_size;             /* send work queue size */
-	u32 s_rnr_timeout;      /* number of milliseconds for RNR timeout */
-	u32 s_ahgpsn;           /* set to the psn in the copy of the header */
-
-	u8 state;               /* QP state */
-	u8 allowed_ops;		/* high order bits of allowed opcodes */
-	u8 qp_access_flags;
-	u8 alt_timeout;         /* Alternate path timeout for this QP */
-	u8 timeout;             /* Timeout for this QP */
-	u8 s_srate;
-	u8 s_mig_state;
-	u8 port_num;
-	u8 s_pkey_index;        /* PKEY index to use */
-	u8 s_alt_pkey_index;    /* Alternate path PKEY index to use */
-	u8 r_max_rd_atomic;     /* max number of RDMA read/atomic to receive */
-	u8 s_max_rd_atomic;     /* max number of RDMA read/atomic to send */
-	u8 s_retry_cnt;         /* number of times to retry */
-	u8 s_rnr_retry_cnt;
-	u8 r_min_rnr_timer;     /* retry timeout value for RNR NAKs */
-	u8 s_max_sge;           /* size of s_wq->sg_list */
-	u8 s_draining;
-
-	/* start of read/write fields */
-	atomic_t refcount ____cacheline_aligned_in_smp;
-	wait_queue_head_t wait;
-
-	struct rvt_ack_entry s_ack_queue[RVT_MAX_RDMA_ATOMIC + 1]
-		____cacheline_aligned_in_smp;
-	struct rvt_sge_state s_rdma_read_sge;
-
-	spinlock_t r_lock ____cacheline_aligned_in_smp;      /* used for APM */
-	unsigned long r_aflags;
-	u64 r_wr_id;            /* ID for current receive WQE */
-	u32 r_ack_psn;          /* PSN for next ACK or atomic ACK */
-	u32 r_len;              /* total length of r_sge */
-	u32 r_rcv_len;          /* receive data len processed */
-	u32 r_psn;              /* expected rcv packet sequence number */
-	u32 r_msn;              /* message sequence number */
-
-	u8 r_state;             /* opcode of last packet received */
-	u8 r_flags;
-	u8 r_head_ack_queue;    /* index into s_ack_queue[] */
-
-	struct list_head rspwait;       /* link for waiting to respond */
-
-	struct rvt_sge_state r_sge;     /* current receive data */
-	struct rvt_rq r_rq;             /* receive work queue */
-
-	spinlock_t s_lock ____cacheline_aligned_in_smp;
-	struct rvt_sge_state *s_cur_sge;
-	u32 s_flags;
-	struct rvt_swqe *s_wqe;
-	struct rvt_sge_state s_sge;     /* current send request data */
-	struct rvt_mregion *s_rdma_mr;
-	struct sdma_engine *s_sde; /* current sde */
-	u32 s_cur_size;         /* size of send packet in bytes */
-	u32 s_len;              /* total length of s_sge */
-	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */
-	u32 s_next_psn;         /* PSN for next request */
-	u32 s_last_psn;         /* last response PSN processed */
-	u32 s_sending_psn;      /* lowest PSN that is being sent */
-	u32 s_sending_hpsn;     /* highest PSN that is being sent */
-	u32 s_psn;              /* current packet sequence number */
-	u32 s_ack_rdma_psn;     /* PSN for sending RDMA read responses */
-	u32 s_ack_psn;          /* PSN for acking sends and RDMA writes */
-	u32 s_head;             /* new entries added here */
-	u32 s_tail;             /* next entry to process */
-	u32 s_cur;              /* current work queue entry */
-	u32 s_acked;            /* last un-ACK'ed entry */
-	u32 s_last;             /* last completed entry */
-	u32 s_ssn;              /* SSN of tail entry */
-	u32 s_lsn;              /* limit sequence number (credit) */
-	u16 s_hdrwords;         /* size of s_hdr in 32 bit words */
-	u16 s_rdma_ack_cnt;
-	s8 s_ahgidx;
-	u8 s_state;             /* opcode of last packet sent */
-	u8 s_ack_state;         /* opcode of packet to ACK */
-	u8 s_nak_state;         /* non-zero if NAK is pending */
-	u8 r_nak_state;         /* non-zero if NAK is pending */
-	u8 s_retry;             /* requester retry counter */
-	u8 s_rnr_retry;         /* requester RNR retry counter */
-	u8 s_num_rd_atomic;     /* number of RDMA read/atomic pending */
-	u8 s_tail_ack_queue;    /* index into s_ack_queue[] */
-
-	struct rvt_sge_state s_ack_rdma_sge;
-	struct timer_list s_timer;
-
-	/*
-	 * This sge list MUST be last. Do not add anything below here.
-	 */
-	struct rvt_sge r_sg_list[0] /* verified SGEs */
-		____cacheline_aligned_in_smp;
-};
-
-struct rvt_srq {
-	struct ib_srq ibsrq;
-	struct rvt_rq rq;
-	struct rvt_mmap_info *ip;
-	/* send signal when number of RWQEs < limit */
-	u32 limit;
-};
-
-/* End QP section */
-
 struct rvt_ibport {
 	struct rvt_qp __rcu *qp[2];
 	struct ib_mad_agent *send_agent;	/* agent for SMI (traps) */
@@ -554,17 +262,6 @@ static inline struct rvt_dev_info *ib_to_rvt(struct ib_device *ibdev)
 	return  container_of(ibdev, struct rvt_dev_info, ibdev);
 }
 
-static inline void rvt_put_mr(struct rvt_mregion *mr)
-{
-	if (unlikely(atomic_dec_and_test(&mr->refcount)))
-		complete(&mr->comp);
-}
-
-static inline void rvt_get_mr(struct rvt_mregion *mr)
-{
-	atomic_inc(&mr->refcount);
-}
-
 static inline struct rvt_srq *ibsrq_to_rvtsrq(struct ib_srq *ibsrq)
 {
 	return container_of(ibsrq, struct rvt_srq, ibsrq);
diff --git a/include/rdma/rdmavt_mr.h b/include/rdma/rdmavt_mr.h
new file mode 100644
index 0000000..ea60476
--- /dev/null
+++ b/include/rdma/rdmavt_mr.h
@@ -0,0 +1,130 @@
+#ifndef DEF_RDMAVT_INCMR_H
+#define DEF_RDMAVT_INCMR_H
+
+/*
+ * Copyright(c) 2015 Intel Corporation.
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
+/*
+ * For Memory Regions. This stuff should probably be moved into rdmavt/mr.h once
+ * drivers no longer need access to the MR directly.
+ */
+
+/*
+ * A segment is a linear region of low physical memory.
+ * Used by the verbs layer.
+ */
+struct rvt_seg {
+	void *vaddr;
+	size_t length;
+};
+
+/* The number of rvt_segs that fit in a page. */
+#define RVT_SEGSZ     (PAGE_SIZE / sizeof(struct rvt_seg))
+
+struct rvt_segarray {
+	struct rvt_seg segs[RVT_SEGSZ];
+};
+
+struct rvt_mregion {
+	struct ib_pd *pd;       /* shares refcnt of ibmr.pd */
+	u64 user_base;          /* User's address for this region */
+	u64 iova;               /* IB start address of this region */
+	size_t length;
+	u32 lkey;
+	u32 offset;             /* offset (bytes) to start of region */
+	int access_flags;
+	u32 max_segs;           /* number of rvt_segs in all the arrays */
+	u32 mapsz;              /* size of the map array */
+	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
+	u8  lkey_published;     /* in global table */
+	struct completion comp; /* complete when refcount goes to zero */
+	atomic_t refcount;
+	struct rvt_segarray *map[0];    /* the segments */
+};
+
+#define RVT_MAX_LKEY_TABLE_BITS 23
+
+struct rvt_lkey_table {
+	spinlock_t lock; /* protect changes in this struct */
+	u32 next;               /* next unused index (speeds search) */
+	u32 gen;                /* generation count */
+	u32 max;                /* size of the table */
+	struct rvt_mregion __rcu **table;
+};
+
+/*
+ * These keep track of the copy progress within a memory region.
+ * Used by the verbs layer.
+ */
+struct rvt_sge {
+	struct rvt_mregion *mr;
+	void *vaddr;            /* kernel virtual address of segment */
+	u32 sge_length;         /* length of the SGE */
+	u32 length;             /* remaining length of the segment */
+	u16 m;                  /* current index: mr->map[m] */
+	u16 n;                  /* current index: mr->map[m]->segs[n] */
+};
+
+struct rvt_sge_state {
+	struct rvt_sge *sg_list;      /* next SGE to be used if any */
+	struct rvt_sge sge;   /* progress state for the current SGE */
+	u32 total_len;
+	u8 num_sge;
+};
+
+static inline void rvt_put_mr(struct rvt_mregion *mr)
+{
+	if (unlikely(atomic_dec_and_test(&mr->refcount)))
+		complete(&mr->comp);
+}
+
+static inline void rvt_get_mr(struct rvt_mregion *mr)
+{
+	atomic_inc(&mr->refcount);
+}
+
+#endif          /* DEF_RDMAVT_INCMRH */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
new file mode 100644
index 0000000..f33fbb0
--- /dev/null
+++ b/include/rdma/rdmavt_qp.h
@@ -0,0 +1,262 @@
+#ifndef DEF_RDMAVT_INCQP_H
+#define DEF_RDMAVT_INCQP_H
+
+/*
+ * Copyright(c) 2015 Intel Corporation.
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
+/*
+ * Send work request queue entry.
+ * The size of the sg_list is determined when the QP is created and stored
+ * in qp->s_max_sge.
+ */
+struct rvt_swqe {
+	union {
+		struct ib_send_wr wr;   /* don't use wr.sg_list */
+		struct ib_ud_wr ud_wr;
+		struct ib_reg_wr reg_wr;
+		struct ib_rdma_wr rdma_wr;
+		struct ib_atomic_wr atomic_wr;
+	};
+	u32 psn;                /* first packet sequence number */
+	u32 lpsn;               /* last packet sequence number */
+	u32 ssn;                /* send sequence number */
+	u32 length;             /* total length of data in sg_list */
+	struct rvt_sge sg_list[0];
+};
+
+/*
+ * Receive work request queue entry.
+ * The size of the sg_list is determined when the QP (or SRQ) is created
+ * and stored in qp->r_rq.max_sge (or srq->rq.max_sge).
+ */
+struct rvt_rwqe {
+	u64 wr_id;
+	u8 num_sge;
+	struct ib_sge sg_list[0];
+};
+
+/*
+ * This structure is used to contain the head pointer, tail pointer,
+ * and receive work queue entries as a single memory allocation so
+ * it can be mmap'ed into user space.
+ * Note that the wq array elements are variable size so you can't
+ * just index into the array to get the N'th element;
+ * use get_rwqe_ptr() instead.
+ */
+struct rvt_rwq {
+	u32 head;               /* new work requests posted to the head */
+	u32 tail;               /* receives pull requests from here. */
+	struct rvt_rwqe wq[0];
+};
+
+struct rvt_rq {
+	struct rvt_rwq *wq;
+	u32 size;               /* size of RWQE array */
+	u8 max_sge;
+	/* protect changes in this struct */
+	spinlock_t lock ____cacheline_aligned_in_smp;
+};
+
+/*
+ * This structure is used by rvt_mmap() to validate an offset
+ * when an mmap() request is made.  The vm_area_struct then uses
+ * this as its vm_private_data.
+ */
+struct rvt_mmap_info {
+	struct list_head pending_mmaps;
+	struct ib_ucontext *context;
+	void *obj;
+	__u64 offset;
+	struct kref ref;
+	unsigned size;
+};
+
+#define RVT_MAX_RDMA_ATOMIC	16
+
+/*
+ * This structure holds the information that the send tasklet needs
+ * to send a RDMA read response or atomic operation.
+ */
+struct rvt_ack_entry {
+	u8 opcode;
+	u8 sent;
+	u32 psn;
+	u32 lpsn;
+	union {
+		struct rvt_sge rdma_sge;
+		u64 atomic_data;
+	};
+};
+
+/*
+ * Variables prefixed with s_ are for the requester (sender).
+ * Variables prefixed with r_ are for the responder (receiver).
+ * Variables prefixed with ack_ are for responder replies.
+ *
+ * Common variables are protected by both r_rq.lock and s_lock in that order
+ * which only happens in modify_qp() or changing the QP 'state'.
+ */
+struct rvt_qp {
+	struct ib_qp ibqp;
+	void *priv; /* Driver private data */
+	/* read mostly fields above and below */
+	struct ib_ah_attr remote_ah_attr;
+	struct ib_ah_attr alt_ah_attr;
+	struct rvt_qp __rcu *next;           /* link list for QPN hash table */
+	struct rvt_swqe *s_wq;  /* send work queue */
+	struct rvt_mmap_info *ip;
+
+	unsigned long timeout_jiffies;  /* computed from timeout */
+
+	enum ib_mtu path_mtu;
+	int srate_mbps;		/* s_srate (below) converted to Mbit/s */
+	u32 remote_qpn;
+	u32 pmtu;		/* decoded from path_mtu */
+	u32 qkey;               /* QKEY for this QP (for UD or RD) */
+	u32 s_size;             /* send work queue size */
+	u32 s_rnr_timeout;      /* number of milliseconds for RNR timeout */
+	u32 s_ahgpsn;           /* set to the psn in the copy of the header */
+
+	u8 state;               /* QP state */
+	u8 allowed_ops;		/* high order bits of allowed opcodes */
+	u8 qp_access_flags;
+	u8 alt_timeout;         /* Alternate path timeout for this QP */
+	u8 timeout;             /* Timeout for this QP */
+	u8 s_srate;
+	u8 s_mig_state;
+	u8 port_num;
+	u8 s_pkey_index;        /* PKEY index to use */
+	u8 s_alt_pkey_index;    /* Alternate path PKEY index to use */
+	u8 r_max_rd_atomic;     /* max number of RDMA read/atomic to receive */
+	u8 s_max_rd_atomic;     /* max number of RDMA read/atomic to send */
+	u8 s_retry_cnt;         /* number of times to retry */
+	u8 s_rnr_retry_cnt;
+	u8 r_min_rnr_timer;     /* retry timeout value for RNR NAKs */
+	u8 s_max_sge;           /* size of s_wq->sg_list */
+	u8 s_draining;
+
+	/* start of read/write fields */
+	atomic_t refcount ____cacheline_aligned_in_smp;
+	wait_queue_head_t wait;
+
+	struct rvt_ack_entry s_ack_queue[RVT_MAX_RDMA_ATOMIC + 1]
+		____cacheline_aligned_in_smp;
+	struct rvt_sge_state s_rdma_read_sge;
+
+	spinlock_t r_lock ____cacheline_aligned_in_smp;      /* used for APM */
+	unsigned long r_aflags;
+	u64 r_wr_id;            /* ID for current receive WQE */
+	u32 r_ack_psn;          /* PSN for next ACK or atomic ACK */
+	u32 r_len;              /* total length of r_sge */
+	u32 r_rcv_len;          /* receive data len processed */
+	u32 r_psn;              /* expected rcv packet sequence number */
+	u32 r_msn;              /* message sequence number */
+
+	u8 r_state;             /* opcode of last packet received */
+	u8 r_flags;
+	u8 r_head_ack_queue;    /* index into s_ack_queue[] */
+
+	struct list_head rspwait;       /* link for waiting to respond */
+
+	struct rvt_sge_state r_sge;     /* current receive data */
+	struct rvt_rq r_rq;             /* receive work queue */
+
+	spinlock_t s_lock ____cacheline_aligned_in_smp;
+	struct rvt_sge_state *s_cur_sge;
+	u32 s_flags;
+	struct rvt_swqe *s_wqe;
+	struct rvt_sge_state s_sge;     /* current send request data */
+	struct rvt_mregion *s_rdma_mr;
+	struct sdma_engine *s_sde; /* current sde */
+	u32 s_cur_size;         /* size of send packet in bytes */
+	u32 s_len;              /* total length of s_sge */
+	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */
+	u32 s_next_psn;         /* PSN for next request */
+	u32 s_last_psn;         /* last response PSN processed */
+	u32 s_sending_psn;      /* lowest PSN that is being sent */
+	u32 s_sending_hpsn;     /* highest PSN that is being sent */
+	u32 s_psn;              /* current packet sequence number */
+	u32 s_ack_rdma_psn;     /* PSN for sending RDMA read responses */
+	u32 s_ack_psn;          /* PSN for acking sends and RDMA writes */
+	u32 s_head;             /* new entries added here */
+	u32 s_tail;             /* next entry to process */
+	u32 s_cur;              /* current work queue entry */
+	u32 s_acked;            /* last un-ACK'ed entry */
+	u32 s_last;             /* last completed entry */
+	u32 s_ssn;              /* SSN of tail entry */
+	u32 s_lsn;              /* limit sequence number (credit) */
+	u16 s_hdrwords;         /* size of s_hdr in 32 bit words */
+	u16 s_rdma_ack_cnt;
+	s8 s_ahgidx;
+	u8 s_state;             /* opcode of last packet sent */
+	u8 s_ack_state;         /* opcode of packet to ACK */
+	u8 s_nak_state;         /* non-zero if NAK is pending */
+	u8 r_nak_state;         /* non-zero if NAK is pending */
+	u8 s_retry;             /* requester retry counter */
+	u8 s_rnr_retry;         /* requester RNR retry counter */
+	u8 s_num_rd_atomic;     /* number of RDMA read/atomic pending */
+	u8 s_tail_ack_queue;    /* index into s_ack_queue[] */
+
+	struct rvt_sge_state s_ack_rdma_sge;
+	struct timer_list s_timer;
+
+	/*
+	 * This sge list MUST be last. Do not add anything below here.
+	 */
+	struct rvt_sge r_sg_list[0] /* verified SGEs */
+		____cacheline_aligned_in_smp;
+};
+
+struct rvt_srq {
+	struct ib_srq ibsrq;
+	struct rvt_rq rq;
+	struct rvt_mmap_info *ip;
+	/* send signal when number of RWQEs < limit */
+	u32 limit;
+};
+
+#endif          /* DEF_RDMAVT_INCQP_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
