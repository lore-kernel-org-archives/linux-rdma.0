From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 41/47] IB/qib: Suppress gcc 7 fall-through complaints
Date: Fri,  6 Oct 2017 14:33:27 -0700
Message-ID: <20171006213333.6721-42-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c  | 1 +
 drivers/infiniband/hw/qib/qib_rc.c   | 2 +-
 drivers/infiniband/hw/qib/qib_sdma.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 1237952c144e..04367e0f6f9b 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -434,6 +434,7 @@ static int check_mkey(struct qib_ibport *ibp, struct ib_smp *smp, int mad_flags)
 			/* Bad mkey not a violation below level 2 */
 			if (ibp->rvp.mkeyprot < 2)
 				break;
+			/* fall through */
 		case IB_MGMT_METHOD_SET:
 		case IB_MGMT_METHOD_TRAP_REPRESS:
 			if (ibp->rvp.mkey_violations != 0xFFFF)
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index e9a91736b12d..8f5754fb8579 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1869,7 +1869,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 		qp->r_rcv_len = 0;
 		if (opcode == OP(SEND_ONLY))
 			goto no_immediate_data;
-		/* FALLTHROUGH for SEND_ONLY_WITH_IMMEDIATE */
+		/* fall through -- for SEND_ONLY_WITH_IMMEDIATE */
 	case OP(SEND_LAST_WITH_IMMEDIATE):
 send_last_imm:
 		wc.ex.imm_data = ohdr->u.imm_data;
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index 891873b38a1e..c3690bd51582 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -808,7 +808,7 @@ void __qib_sdma_process_event(struct qib_pportdata *ppd,
 			 * bringing the link up with traffic active on
 			 * 7220, e.g. */
 			ss->go_s99_running = 1;
-			/* fall through and start dma engine */
+			/* fall through -- and start dma engine */
 		case qib_sdma_event_e10_go_hw_start:
 			/* This reference means the state machine is started */
 			sdma_get(&ppd->sdma_state);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
