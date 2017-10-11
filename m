From: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] IB/hfil: Delete unused bypass flags
Date: Wed, 11 Oct 2017 21:56:49 +0100
Message-ID: <1507755409-12280-1-git-send-email-chris.gekas@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Clean up unused bypass variables in verbs.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/infiniband/hw/hfi1/verbs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index e232f3c..62c3f4e 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -891,14 +891,12 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	u8 sc5 = priv->s_sc;
 	int ret;
 	u32 dwords;
-	bool bypass = false;
 
 	if (ps->s_txreq->phdr.hdr.hdr_type) {
 		u8 extra_bytes = hfi1_get_16b_padding((hdrwords << 2), len);
 
 		dwords = (len + extra_bytes + (SIZE_OF_CRC << 2) +
 			  SIZE_OF_LT) >> 2;
-		bypass = true;
 	} else {
 		dwords = (len + 3) >> 2;
 	}
@@ -1034,7 +1032,6 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	int ret = 0;
 	pio_release_cb cb = NULL;
 	u32 lrh0_16b;
-	bool bypass = false;
 	u8 extra_bytes = 0;
 
 	if (ps->s_txreq->phdr.hdr.hdr_type) {
@@ -1044,7 +1041,6 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		dwords = (len + extra_bytes) >> 2;
 		hdr = (u32 *)&ps->s_txreq->phdr.hdr.opah;
 		lrh0_16b = ps->s_txreq->phdr.hdr.opah.lrh[0];
-		bypass = true;
 	} else {
 		dwords = (len + 3) >> 2;
 		hdr = (u32 *)&ps->s_txreq->phdr.hdr.ibh;
-- 
2.7.4
