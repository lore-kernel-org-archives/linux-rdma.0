From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/21] staging/rdma/hfi1: Split multiple assignments
Date: Sun, 14 Feb 2016 20:20:50 -0800
Message-ID: <20160215042047.351.22021.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Split multiple assignments into individual assignments to fix
checkpatch check:
CHECK: multiple assignments should be avoided

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    6 ++++--
 drivers/staging/rdma/hfi1/mad.c  |    8 ++++----
 drivers/staging/rdma/hfi1/sdma.h |    3 ++-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index bdc5610..233958d 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -12459,8 +12459,10 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 
 	/* calculate the ranges we are going to use */
 	first_general = 0;
-	first_sdma = last_general = first_general + 1;
-	first_rx = last_sdma = first_sdma + dd->num_sdma;
+	last_general = first_general + 1;
+	first_sdma = last_general;
+	last_sdma = first_sdma + dd->num_sdma;
+	first_rx = last_sdma;
 	last_rx = first_rx + dd->n_krcv_queues;
 
 	/*
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 36bd6fa..118a09e 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -896,8 +896,8 @@ static int port_states_transition_allowed(struct hfi1_pportdata *ppd,
 	u32 logical_old = driver_logical_state(ppd);
 	int ret, logical_allowed, physical_allowed;
 
-	logical_allowed = ret =
-		logical_transition_allowed(logical_old, logical_new);
+	ret = logical_transition_allowed(logical_old, logical_new);
+	logical_allowed = ret;
 
 	if (ret == HFI_TRANSITION_DISALLOWED ||
 	    ret == HFI_TRANSITION_UNDEFINED) {
@@ -907,8 +907,8 @@ static int port_states_transition_allowed(struct hfi1_pportdata *ppd,
 		return ret;
 	}
 
-	physical_allowed = ret =
-		physical_transition_allowed(physical_old, physical_new);
+	ret = physical_transition_allowed(physical_old, physical_new);
+	physical_allowed = ret;
 
 	if (ret == HFI_TRANSITION_DISALLOWED ||
 	    ret == HFI_TRANSITION_UNDEFINED) {
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 0ee22c4..0c5f501 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -565,7 +565,8 @@ static inline int sdma_txinit_ahg(
 	tx->complete = cb;
 	tx->coalesce_buf = NULL;
 	tx->wait = NULL;
-	tx->tlen = tx->packet_len = tlen;
+	tx->packet_len = tlen;
+	tx->tlen = tx->packet_len;
 	tx->descs[0].qw[0] = SDMA_DESC0_FIRST_DESC_FLAG;
 	tx->descs[0].qw[1] = 0;
 	if (flags & SDMA_TXREQ_F_AHG_COPY)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
