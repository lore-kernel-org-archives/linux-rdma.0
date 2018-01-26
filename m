From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/16] IB/hfi1: Optimize packet type comparison
 using 9B and bypass code paths
Date: Fri, 26 Jan 2018 06:32:38 -0800
Message-ID: <20180126143235.6868.32732.stgit@scvm10.sc.intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126142640.6868.12402.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The packet type comparison used to find out if a packet is a bypass
packet in the hot path is an expensive operation as seen in a profile.

Determine packet's pkey and migration bit through the bypass and 9B
code paths instead.

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |    4 ++++
 drivers/infiniband/hw/hfi1/hfi.h    |    2 ++
 drivers/infiniband/hw/hfi1/ruc.c    |   15 ++-------------
 drivers/infiniband/hw/hfi1/verbs.h  |    5 +++++
 include/rdma/ib_hdrs.h              |    5 +++++
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index e6a318c..7ef8634 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1440,6 +1440,8 @@ static int hfi1_setup_9B_packet(struct hfi1_packet *packet)
 	packet->extra_byte = 0;
 	packet->fecn = ib_bth_get_fecn(packet->ohdr);
 	packet->becn = ib_bth_get_becn(packet->ohdr);
+	packet->pkey = ib_bth_get_pkey(packet->ohdr);
+	packet->migrated = ib_bth_is_migration(packet->ohdr);
 
 	return 0;
 drop:
@@ -1508,6 +1510,8 @@ static int hfi1_setup_bypass_packet(struct hfi1_packet *packet)
 	packet->extra_byte = SIZE_OF_LT;
 	packet->fecn = hfi1_16B_get_fecn(packet->hdr);
 	packet->becn = hfi1_16B_get_becn(packet->hdr);
+	packet->pkey = hfi1_16B_get_pkey(packet->hdr);
+	packet->migrated = opa_bth_is_migration(packet->ohdr);
 
 	if (hfi1_bypass_ingress_pkt_check(packet))
 		goto drop;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 8aea811..e0ed2b4 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -341,6 +341,7 @@ struct hfi1_packet {
 	u32 slid;
 	u16 tlen;
 	s16 etail;
+	u16 pkey;
 	u8 hlen;
 	u8 numpkt;
 	u8 rsize;
@@ -353,6 +354,7 @@ struct hfi1_packet {
 	u8 opcode;
 	bool becn;
 	bool fecn;
+	bool migrated;
 };
 
 /* Packet types */
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 1033068..e7d4e04 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -225,19 +225,8 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_packet *packet)
 	u32 dlid = packet->dlid;
 	u32 slid = packet->slid;
 	u32 sl = packet->sl;
-	int migrated;
-	u32 bth0, bth1;
-	u16 pkey;
-
-	bth0 = be32_to_cpu(packet->ohdr->bth[0]);
-	bth1 = be32_to_cpu(packet->ohdr->bth[1]);
-	if (packet->etype == RHF_RCV_TYPE_BYPASS) {
-		pkey = hfi1_16B_get_pkey(packet->hdr);
-		migrated = bth1 & OPA_BTH_MIG_REQ;
-	} else {
-		pkey = ib_bth_get_pkey(packet->ohdr);
-		migrated = bth0 & IB_BTH_MIG_REQ;
-	}
+	bool migrated = packet->migrated;
+	u16 pkey = packet->pkey;
 
 	if (qp->s_mig_state == IB_MIG_ARMED && migrated) {
 		if (!packet->grh) {
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 26c1ed6..90a170e 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -410,6 +410,11 @@ static inline void cacheless_memcpy(void *dst, void *src, size_t n)
 	__copy_user_nocache(dst, (void __user *)src, n, 0);
 }
 
+static inline bool opa_bth_is_migration(struct ib_other_headers *ohdr)
+{
+	return !!(ohdr->bth[1] & cpu_to_be32(OPA_BTH_MIG_REQ));
+}
+
 extern const enum ib_wc_opcode ib_hfi1_wc_opcode[];
 
 extern const u8 hdr_len_by_opcode[];
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index 6a86d14..2aa19ec 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -335,4 +335,9 @@ static inline bool ib_bth_is_solicited(struct ib_other_headers *ohdr)
 {
 	return !!(ohdr->bth[0] & cpu_to_be32(IB_BTH_SOLICITED));
 }
+
+static inline bool ib_bth_is_migration(struct ib_other_headers *ohdr)
+{
+	return !!(ohdr->bth[0] & cpu_to_be32(IB_BTH_MIG_REQ));
+}
 #endif                          /* IB_HDRS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
