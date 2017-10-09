From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/7] IB/hfi1: Mask out A bit from psn trace
Date: Mon, 09 Oct 2017 12:38:12 -0700
Message-ID: <20171009193809.6965.6733.stgit@scvm10.sc.intel.com>
References: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009161736.6965.75352.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The trace logic prior to the fixes below used to mask the
A bit from the psn. It now mistakenly displays the A bit,
which is already displayed separately.

Fix by adding the appropriate mask to the psn tracing.

Fixes: 228d2af1b723 ("IB/hfi1: Separate input/output header tracing")
Fixes: 863cf89d472f ("IB/hfi1: Add 16B trace support")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index ce5a43f..959a804 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -151,7 +151,7 @@ void hfi1_trace_parse_9b_bth(struct ib_other_headers *ohdr,
 	*opcode = ib_bth_get_opcode(ohdr);
 	*tver = ib_bth_get_tver(ohdr);
 	*pkey = ib_bth_get_pkey(ohdr);
-	*psn = ib_bth_get_psn(ohdr);
+	*psn = mask_psn(ib_bth_get_psn(ohdr));
 	*qpn = ib_bth_get_qpn(ohdr);
 }
 
@@ -166,7 +166,7 @@ void hfi1_trace_parse_16b_bth(struct ib_other_headers *ohdr,
 	*pad = ib_bth_get_pad(ohdr);
 	*se = ib_bth_get_se(ohdr);
 	*tver = ib_bth_get_tver(ohdr);
-	*psn = ib_bth_get_psn(ohdr);
+	*psn = mask_psn(ib_bth_get_psn(ohdr));
 	*qpn = ib_bth_get_qpn(ohdr);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
