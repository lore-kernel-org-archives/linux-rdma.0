From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/8] IB/rdmavt: Correct issues with read-mostly and
 send size cache lines
Date: Mon, 02 Oct 2017 11:04:41 -0700
Message-ID: <20171002180438.31117.35604.stgit@scvm10.sc.intel.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002180204.31117.12254.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The s_ahgpsn was incorrectly placed in the read-mostly section of the QP
and the s_curr_size and s_hdrwords are oversized. The misplaced
s_ahgpsn will cause the read-mostly cachelines to thrash.

Place s_ahgpsn in the send side cache lines and correctly size and
s_hdrwords and s_cur_size to keep the send side cachelines at the same
size.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 ++--
 include/rdma/rdmavt_qp.h          |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 56bba8d..d2d72e0 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8743,8 +8743,8 @@ static int set_physical_link_state(struct hfi1_devdata *dd, u64 state)
 	return do_8051_command(dd, HCMD_CHANGE_PHY_STATE, state, NULL);
 }
 
-int _load_8051_config(struct hfi1_devdata *dd, u8 field_id,
-		      u8 lane_id, u32 config_data)
+static int _load_8051_config(struct hfi1_devdata *dd, u8 field_id,
+			     u8 lane_id, u32 config_data)
 {
 	u64 data;
 	int ret;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 0eed3d8..89ab88c 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -282,7 +282,6 @@ struct rvt_qp {
 	u32 remote_qpn;
 	u32 qkey;               /* QKEY for this QP (for UD or RD) */
 	u32 s_size;             /* send work queue size */
-	u32 s_ahgpsn;           /* set to the psn in the copy of the header */
 
 	u16 pmtu;		/* decoded from path_mtu */
 	u8 log_pmtu;		/* shift for pmtu */
@@ -344,7 +343,6 @@ struct rvt_qp {
 	struct rvt_swqe *s_wqe;
 	struct rvt_sge_state s_sge;     /* current send request data */
 	struct rvt_mregion *s_rdma_mr;
-	u32 s_cur_size;         /* size of send packet in bytes */
 	u32 s_len;              /* total length of s_sge */
 	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */
 	u32 s_last_psn;         /* last response PSN processed */
@@ -358,8 +356,10 @@ struct rvt_qp {
 	u32 s_acked;            /* last un-ACK'ed entry */
 	u32 s_last;             /* last completed entry */
 	u32 s_lsn;              /* limit sequence number (credit) */
-	u16 s_hdrwords;         /* size of s_hdr in 32 bit words */
+	u32 s_ahgpsn;           /* set to the psn in the copy of the header */
+	u16 s_cur_size;         /* size of send packet in bytes */
 	u16 s_rdma_ack_cnt;
+	u8 s_hdrwords;         /* size of s_hdr in 32 bit words */
 	s8 s_ahgidx;
 	u8 s_state;             /* opcode of last packet sent */
 	u8 s_ack_state;         /* opcode of packet to ACK */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
