From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] RDMA/nes: Print ip address for critcal errors
Date: Sun, 25 Sep 2011 20:33:44 -0500
Message-ID: <20110926013344.GA5260@FLATIF-MOBL4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Prints the IP address of the remote host when critical asynchronous event is
received.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index da2548d..cae26f4 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -110,6 +110,15 @@ static unsigned char *nes_tcp_state_str[] = {
 };
 #endif
 
+static inline void print_ip(struct nes_cm_node *cm_node)
+{
+	unsigned char *rem_addr;
+	if (cm_node) {
+		rem_addr = (unsigned char *)&cm_node->rem_addr;
+		printk(KERN_ERR PFX "Remote ip addr = %u.%u.%u.%u\n",
+			rem_addr[3], rem_addr[2], rem_addr[1], rem_addr[0]);
+	}
+}
 
 /**
  * nes_nic_init_timer_defaults
@@ -3700,6 +3709,7 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 		case NES_AEQE_AEID_ROE_INVALID_RDMA_WRITE_OR_READ_RESP:
 			printk(KERN_ERR PFX "QP[%u] async_event_id=0x%04X IB_EVENT_QP_FATAL\n",
 					nesqp->hwqp.qp_id, async_event_id);
+			print_ip(nesqp->cm_node);
 			if (!atomic_read(&nesqp->close_timer_started)) {
 				nes_terminate_connection(nesdev, nesqp, aeqe, IB_EVENT_QP_FATAL);
 			}
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
