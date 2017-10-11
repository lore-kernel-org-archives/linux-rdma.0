From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 15/45] IB/hfi1: Suppress gcc 7 fall-through complaints
Date: Wed, 11 Oct 2017 10:48:57 -0700
Message-ID: <20171011174927.25113-16-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c  | 1 +
 drivers/infiniband/hw/hfi1/rc.c   | 2 +-
 drivers/infiniband/hw/hfi1/sdma.c | 3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 07b80faf1675..c01335edeabd 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -711,6 +711,7 @@ static int check_mkey(struct hfi1_ibport *ibp, struct ib_mad_hdr *mad,
 			/* Bad mkey not a violation below level 2 */
 			if (ibp->rvp.mkeyprot < 2)
 				break;
+			/* fall through */
 		case IB_MGMT_METHOD_SET:
 		case IB_MGMT_METHOD_TRAP_REPRESS:
 			if (ibp->rvp.mkey_violations != 0xFFFF)
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index e1cf0c08ca6f..8ca26e67a096 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2175,7 +2175,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			goto no_immediate_data;
 		if (opcode == OP(SEND_ONLY_WITH_INVALIDATE))
 			goto send_last_inv;
-		/* FALLTHROUGH for SEND_ONLY_WITH_IMMEDIATE */
+		/* FALLTHROUGH -- for SEND_ONLY_WITH_IMMEDIATE */
 	case OP(SEND_LAST_WITH_IMMEDIATE):
 send_last_imm:
 		wc.ex.imm_data = ohdr->u.imm_data;
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index e7df7794c97e..961507bb0391 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -2593,7 +2593,7 @@ static void __sdma_process_event(struct sdma_engine *sde,
 			 * 7220, e.g.
 			 */
 			ss->go_s99_running = 1;
-			/* fall through and start dma engine */
+			/* fall through -- and start dma engine */
 		case sdma_event_e10_go_hw_start:
 			/* This reference means the state machine is started */
 			sdma_get(&sde->state);
@@ -3016,6 +3016,7 @@ static void __sdma_process_event(struct sdma_engine *sde,
 		case sdma_event_e60_hw_halted:
 			need_progress = 1;
 			sdma_err_progress_check_schedule(sde);
+			/* fall through */
 		case sdma_event_e90_sw_halted:
 			/*
 			* SW initiated halt does not perform engines
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
