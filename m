From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/16] IB/rdmvt: close send engine struct holes
Date: Sun, 14 Feb 2016 12:44:26 -0800
Message-ID: <20160214204422.29247.66945.stgit@scvm10.sc.intel.com>
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

pahole noted the wasted 4 bytes after s_lock and r_lock.

Move s_flags and r_psn to fill the holes.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdmavt_qp.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 933f14f..5c307ed 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -283,12 +283,12 @@ struct rvt_qp {
 	struct rvt_sge_state s_rdma_read_sge;
 
 	spinlock_t r_lock ____cacheline_aligned_in_smp;      /* used for APM */
+	u32 r_psn;              /* expected rcv packet sequence number */
 	unsigned long r_aflags;
 	u64 r_wr_id;            /* ID for current receive WQE */
 	u32 r_ack_psn;          /* PSN for next ACK or atomic ACK */
 	u32 r_len;              /* total length of r_sge */
 	u32 r_rcv_len;          /* receive data len processed */
-	u32 r_psn;              /* expected rcv packet sequence number */
 	u32 r_msn;              /* message sequence number */
 
 	u8 r_state;             /* opcode of last packet received */
@@ -308,8 +308,8 @@ struct rvt_qp {
 	u32 s_ssn;              /* SSN of tail entry */
 
 	spinlock_t s_lock ____cacheline_aligned_in_smp;
-	struct rvt_sge_state *s_cur_sge;
 	u32 s_flags;
+	struct rvt_sge_state *s_cur_sge;
 	struct rvt_swqe *s_wqe;
 	struct rvt_sge_state s_sge;     /* current send request data */
 	struct rvt_mregion *s_rdma_mr;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
