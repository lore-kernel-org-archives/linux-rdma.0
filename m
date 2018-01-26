From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next v2 07/16] IB/hfi1: Show fault stats in both TX and
 RX directions
Date: Fri, 26 Jan 2018 13:29:43 -0800
Message-ID: <20180126212941.12097.34672.stgit@scvm10.sc.intel.com>
References: <20180126211126.12097.47410.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126211126.12097.47410.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The routine which shows the fault stats checks the counters
to determine whether to show any stats based on the number of
transmitted pkts/bytes for a particular opcode.

Unfortunately, it only checked the receive counters. As a result,
if any packet faults have happened for packets egressing the HFI,
those stats would not be shown.

In order to fix this, the routine is amended to also check the
TX counters. With this change the pkt/byte counts are the sum of
both TX and RX counts for the opcode.

Fixes: 1b311f8931cf ("IB/hfi1: Add tx_opcode_stats like the opcode_stats")
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 2e6e0c5..852173b 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015-2017 Intel Corporation.
+ * Copyright(c) 2015-2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -1201,6 +1201,13 @@ static int _fault_stats_seq_show(struct seq_file *s, void *v)
 		}
 		hfi1_rcd_put(rcd);
 	}
+	for_each_possible_cpu(j) {
+		struct hfi1_opcode_stats_perctx *sp =
+			per_cpu_ptr(dd->tx_opstats, j);
+
+		n_packets += sp->stats[i].n_packets;
+		n_bytes += sp->stats[i].n_bytes;
+	}
 	if (!n_packets && !n_bytes)
 		return SEQ_SKIP;
 	if (!ibd->fault_opcode->n_rxfaults[i] &&

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
