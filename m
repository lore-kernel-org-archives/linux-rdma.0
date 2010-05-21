From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: AE for closed QP causes crash
Date: Fri, 21 May 2010 16:55:03 -0500
Message-ID: <20100521215503.GA4256@flatif-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Under abnormal termination, modify_qp() closes qp and AE handling also
attempts to close qp causing system to crash.
Now we check the state of QP before processing the AE.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index c36a3f5..bfc9969 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3424,6 +3424,7 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	u32 aeq_info;
 	u32 next_iwarp_state = 0;
+	u32 aeqe_cq_id;
 	u16 async_event_id;
 	u8 tcp_state;
 	u8 iwarp_state;
@@ -3451,6 +3452,14 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 			le32_to_cpu(aeqe->aeqe_words[NES_AEQE_COMP_QP_CQ_ID_IDX]), aeqe,
 			nes_tcp_state_str[tcp_state], nes_iwarp_state_str[iwarp_state]);
 
+	aeqe_cq_id = le32_to_cpu(aeqe->aeqe_words[NES_AEQE_COMP_QP_CQ_ID_IDX]);
+	if (aeq_info & NES_AEQE_QP) {
+		if ((!nes_is_resource_allocated(nesadapter, nesadapter->allocated_qps,
+				aeqe_cq_id)) ||
+				(atomic_read(&nesqp->close_timer_started)))
+			return;
+	}
+
 	switch (async_event_id) {
 		case NES_AEQE_AEID_LLP_FIN_RECEIVED:
 			if (nesqp->term_flags)
--
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
