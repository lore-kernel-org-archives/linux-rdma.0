From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH 2/2] staging/rdma/hfi1: HFI now sends OPA Traps instead of
 IBTA
Date: Thu, 10 Dec 2015 09:59:40 -0500
Message-ID: <20151210145940.22192.42768.stgit@phlsvslse11.ph.intel.com>
References: <20151210145904.22192.40996.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20151210145904.22192.40996.stgit@phlsvslse11.ph.intel.com>
Sender: linux-next-owner@vger.kernel.org
To: devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, linux-next@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Erik E. Kahn <erik.kahn@intel.com>

send_trap() was still using old ib_smp instead of opa_smp
for formatting and sending traps.

Reviewed-by: Arthur Kepner <arthur.kepner@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
Signed-off-by: Erik E. Kahn <erik.kahn@intel.com>
---
 drivers/staging/rdma/hfi1/mad.c   |  121 +++++++++++++++++++------------------
 drivers/staging/rdma/hfi1/ruc.c   |   10 ++-
 drivers/staging/rdma/hfi1/ud.c    |   21 +++---
 drivers/staging/rdma/hfi1/verbs.h |    2 -
 4 files changed, 79 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index a122565..28c3ad2 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -84,7 +84,7 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 {
 	struct ib_mad_send_buf *send_buf;
 	struct ib_mad_agent *agent;
-	struct ib_smp *smp;
+	struct opa_smp *smp;
 	int ret;
 	unsigned long flags;
 	unsigned long timeout;
@@ -117,15 +117,15 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 		return;
 
 	smp = send_buf->mad;
-	smp->base_version = IB_MGMT_BASE_VERSION;
+	smp->base_version = OPA_MGMT_BASE_VERSION;
 	smp->mgmt_class = IB_MGMT_CLASS_SUBN_LID_ROUTED;
-	smp->class_version = 1;
+	smp->class_version = OPA_SMI_CLASS_VERSION;
 	smp->method = IB_MGMT_METHOD_TRAP;
 	ibp->tid++;
 	smp->tid = cpu_to_be64(ibp->tid);
 	smp->attr_id = IB_SMP_ATTR_NOTICE;
 	/* o14-1: smp->mkey = 0; */
-	memcpy(smp->data, data, len);
+	memcpy(smp->route.lid.data, data, len);
 
 	spin_lock_irqsave(&ibp->lock, flags);
 	if (!ibp->sm_ah) {
@@ -164,11 +164,16 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
  * Send a bad [PQ]_Key trap (ch. 14.3.8).
  */
 void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
-		    u32 qp1, u32 qp2, __be16 lid1, __be16 lid2)
+		    u32 qp1, u32 qp2, u16 lid1, u16 lid2)
 {
-	struct ib_mad_notice_attr data;
+	struct opa_mad_notice_attr data;
+	u32 lid = ppd_from_ibp(ibp)->lid;
+	u32 _lid1 = lid1;
+	u32 _lid2 = lid2;
 
-	if (trap_num == IB_NOTICE_TRAP_BAD_PKEY)
+	memset(&data, 0, sizeof(data));
+
+	if (trap_num == OPA_TRAP_BAD_P_KEY)
 		ibp->pkey_violations++;
 	else
 		ibp->qkey_violations++;
@@ -176,17 +181,15 @@ void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 
 	/* Send violation trap */
 	data.generic_type = IB_NOTICE_TYPE_SECURITY;
-	data.prod_type_msb = 0;
 	data.prod_type_lsb = IB_NOTICE_PROD_CA;
 	data.trap_num = trap_num;
-	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
-	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof(data.details));
-	data.details.ntc_257_258.lid1 = lid1;
-	data.details.ntc_257_258.lid2 = lid2;
-	data.details.ntc_257_258.key = cpu_to_be32(key);
-	data.details.ntc_257_258.sl_qp1 = cpu_to_be32((sl << 28) | qp1);
-	data.details.ntc_257_258.qp2 = cpu_to_be32(qp2);
+	data.issuer_lid = cpu_to_be32(lid);
+	data.ntc_257_258.lid1 = cpu_to_be32(_lid1);
+	data.ntc_257_258.lid2 = cpu_to_be32(_lid2);
+	data.ntc_257_258.key = cpu_to_be32(key);
+	data.ntc_257_258.sl = sl << 3;
+	data.ntc_257_258.qp1 = cpu_to_be32(qp1);
+	data.ntc_257_258.qp2 = cpu_to_be32(qp2);
 
 	send_trap(ibp, &data, sizeof(data));
 }
@@ -197,32 +200,30 @@ void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 static void bad_mkey(struct hfi1_ibport *ibp, struct ib_mad_hdr *mad,
 		     __be64 mkey, __be32 dr_slid, u8 return_path[], u8 hop_cnt)
 {
-	struct ib_mad_notice_attr data;
+	struct opa_mad_notice_attr data;
+	u32 lid = ppd_from_ibp(ibp)->lid;
 
+	memset(&data, 0, sizeof(data));
 	/* Send violation trap */
 	data.generic_type = IB_NOTICE_TYPE_SECURITY;
-	data.prod_type_msb = 0;
 	data.prod_type_lsb = IB_NOTICE_PROD_CA;
-	data.trap_num = IB_NOTICE_TRAP_BAD_MKEY;
-	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
-	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof(data.details));
-	data.details.ntc_256.lid = data.issuer_lid;
-	data.details.ntc_256.method = mad->method;
-	data.details.ntc_256.attr_id = mad->attr_id;
-	data.details.ntc_256.attr_mod = mad->attr_mod;
-	data.details.ntc_256.mkey = mkey;
+	data.trap_num = OPA_TRAP_BAD_M_KEY;
+	data.issuer_lid = cpu_to_be32(lid);
+	data.ntc_256.lid = data.issuer_lid;
+	data.ntc_256.method = mad->method;
+	data.ntc_256.attr_id = mad->attr_id;
+	data.ntc_256.attr_mod = mad->attr_mod;
+	data.ntc_256.mkey = mkey;
 	if (mad->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
-
-		data.details.ntc_256.dr_slid = (__force __be16)dr_slid;
-		data.details.ntc_256.dr_trunc_hop = IB_NOTICE_TRAP_DR_NOTICE;
-		if (hop_cnt > ARRAY_SIZE(data.details.ntc_256.dr_rtn_path)) {
-			data.details.ntc_256.dr_trunc_hop |=
+		data.ntc_256.dr_slid = dr_slid;
+		data.ntc_256.dr_trunc_hop = IB_NOTICE_TRAP_DR_NOTICE;
+		if (hop_cnt > ARRAY_SIZE(data.ntc_256.dr_rtn_path)) {
+			data.ntc_256.dr_trunc_hop |=
 				IB_NOTICE_TRAP_DR_TRUNC;
-			hop_cnt = ARRAY_SIZE(data.details.ntc_256.dr_rtn_path);
+			hop_cnt = ARRAY_SIZE(data.ntc_256.dr_rtn_path);
 		}
-		data.details.ntc_256.dr_trunc_hop |= hop_cnt;
-		memcpy(data.details.ntc_256.dr_rtn_path, return_path,
+		data.ntc_256.dr_trunc_hop |= hop_cnt;
+		memcpy(data.ntc_256.dr_rtn_path, return_path,
 		       hop_cnt);
 	}
 
@@ -234,17 +235,17 @@ static void bad_mkey(struct hfi1_ibport *ibp, struct ib_mad_hdr *mad,
  */
 void hfi1_cap_mask_chg(struct hfi1_ibport *ibp)
 {
-	struct ib_mad_notice_attr data;
+	struct opa_mad_notice_attr data;
+	u32 lid = ppd_from_ibp(ibp)->lid;
+
+	memset(&data, 0, sizeof(data));
 
 	data.generic_type = IB_NOTICE_TYPE_INFO;
-	data.prod_type_msb = 0;
 	data.prod_type_lsb = IB_NOTICE_PROD_CA;
-	data.trap_num = IB_NOTICE_TRAP_CAP_MASK_CHG;
-	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
-	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof(data.details));
-	data.details.ntc_144.lid = data.issuer_lid;
-	data.details.ntc_144.new_cap_mask = cpu_to_be32(ibp->port_cap_flags);
+	data.trap_num = OPA_TRAP_CHANGE_CAPABILITY;
+	data.issuer_lid = cpu_to_be32(lid);
+	data.ntc_144.lid = data.issuer_lid;
+	data.ntc_144.new_cap_mask = cpu_to_be32(ibp->port_cap_flags);
 
 	send_trap(ibp, &data, sizeof(data));
 }
@@ -254,17 +255,17 @@ void hfi1_cap_mask_chg(struct hfi1_ibport *ibp)
  */
 void hfi1_sys_guid_chg(struct hfi1_ibport *ibp)
 {
-	struct ib_mad_notice_attr data;
+	struct opa_mad_notice_attr data;
+	u32 lid = ppd_from_ibp(ibp)->lid;
+
+	memset(&data, 0, sizeof(data));
 
 	data.generic_type = IB_NOTICE_TYPE_INFO;
-	data.prod_type_msb = 0;
 	data.prod_type_lsb = IB_NOTICE_PROD_CA;
-	data.trap_num = IB_NOTICE_TRAP_SYS_GUID_CHG;
-	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
-	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof(data.details));
-	data.details.ntc_145.lid = data.issuer_lid;
-	data.details.ntc_145.new_sys_guid = ib_hfi1_sys_image_guid;
+	data.trap_num = OPA_TRAP_CHANGE_SYSGUID;
+	data.issuer_lid = cpu_to_be32(lid);
+	data.ntc_145.new_sys_guid = ib_hfi1_sys_image_guid;
+	data.ntc_145.lid = data.issuer_lid;
 
 	send_trap(ibp, &data, sizeof(data));
 }
@@ -274,18 +275,18 @@ void hfi1_sys_guid_chg(struct hfi1_ibport *ibp)
  */
 void hfi1_node_desc_chg(struct hfi1_ibport *ibp)
 {
-	struct ib_mad_notice_attr data;
+	struct opa_mad_notice_attr data;
+	u32 lid = ppd_from_ibp(ibp)->lid;
+
+	memset(&data, 0, sizeof(data));
 
 	data.generic_type = IB_NOTICE_TYPE_INFO;
-	data.prod_type_msb = 0;
 	data.prod_type_lsb = IB_NOTICE_PROD_CA;
-	data.trap_num = IB_NOTICE_TRAP_CAP_MASK_CHG;
-	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
-	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof(data.details));
-	data.details.ntc_144.lid = data.issuer_lid;
-	data.details.ntc_144.local_changes = 1;
-	data.details.ntc_144.change_flags = IB_NOTICE_TRAP_NODE_DESC_CHG;
+	data.trap_num = OPA_TRAP_CHANGE_CAPABILITY;
+	data.issuer_lid = cpu_to_be32(lid);
+	data.ntc_144.lid = data.issuer_lid;
+	data.ntc_144.change_flags =
+		cpu_to_be16(OPA_NOTICE_TRAP_NODE_DESC_CHG);
 
 	send_trap(ibp, &data, sizeof(data));
 }
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 317bf6f..4a91975 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -288,11 +288,12 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 		}
 		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
 					    sc5, be16_to_cpu(hdr->lrh[3])))) {
-			hfi1_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_PKEY,
+			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY,
 				       (u16)bth0,
 				       (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
 				       0, qp->ibqp.qp_num,
-				       hdr->lrh[3], hdr->lrh[1]);
+				       be16_to_cpu(hdr->lrh[3]),
+				       be16_to_cpu(hdr->lrh[1]));
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 and 17.2.8 */
@@ -320,11 +321,12 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 		}
 		if (unlikely(rcv_pkey_check(ppd_from_ibp(ibp), (u16)bth0,
 					    sc5, be16_to_cpu(hdr->lrh[3])))) {
-			hfi1_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_PKEY,
+			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY,
 				       (u16)bth0,
 				       (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
 				       0, qp->ibqp.qp_num,
-				       hdr->lrh[3], hdr->lrh[1]);
+				       be16_to_cpu(hdr->lrh[3]),
+				       be16_to_cpu(hdr->lrh[1]));
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 */
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 54ff1f5..bd1b402 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -111,11 +111,10 @@ static void ud_loopback(struct hfi1_qp *sqp, struct hfi1_swqe *swqe)
 				   ((1 << ppd->lmc) - 1));
 		if (unlikely(ingress_pkey_check(ppd, pkey, sc5,
 						qp->s_pkey_index, slid))) {
-			hfi1_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_PKEY, pkey,
+			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY, pkey,
 				       ah_attr->sl,
 				       sqp->ibqp.qp_num, qp->ibqp.qp_num,
-				       cpu_to_be16(slid),
-				       cpu_to_be16(ah_attr->dlid));
+				       slid, ah_attr->dlid);
 			goto drop;
 		}
 	}
@@ -135,11 +134,11 @@ static void ud_loopback(struct hfi1_qp *sqp, struct hfi1_swqe *swqe)
 
 			lid = ppd->lid | (ah_attr->src_path_bits &
 					  ((1 << ppd->lmc) - 1));
-			hfi1_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_QKEY, qkey,
+			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_Q_KEY, qkey,
 				       ah_attr->sl,
 				       sqp->ibqp.qp_num, qp->ibqp.qp_num,
-				       cpu_to_be16(lid),
-				       cpu_to_be16(ah_attr->dlid));
+				       lid,
+				       ah_attr->dlid);
 			goto drop;
 		}
 	}
@@ -737,12 +736,13 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 				 * for invalid pkeys is optional according to
 				 * IB spec (release 1.3, section 10.9.4)
 				 */
-				hfi1_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_PKEY,
+				hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY,
 					       pkey,
 					       (be16_to_cpu(hdr->lrh[0]) >> 4) &
 						0xF,
 					       src_qp, qp->ibqp.qp_num,
-					       hdr->lrh[3], hdr->lrh[1]);
+					       be16_to_cpu(hdr->lrh[3]),
+					       be16_to_cpu(hdr->lrh[1]));
 				return;
 			}
 		} else {
@@ -753,10 +753,11 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 
 		}
 		if (unlikely(qkey != qp->qkey)) {
-			hfi1_bad_pqkey(ibp, IB_NOTICE_TRAP_BAD_QKEY, qkey,
+			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_Q_KEY, qkey,
 				       (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
 				       src_qp, qp->ibqp.qp_num,
-				       hdr->lrh[3], hdr->lrh[1]);
+				       be16_to_cpu(hdr->lrh[3]),
+				       be16_to_cpu(hdr->lrh[1]));
 			return;
 		}
 		/* Drop invalid MAD packets (see 13.5.3.1). */
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 7e27531..72106e5 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -861,7 +861,7 @@ static inline int hfi1_send_ok(struct hfi1_qp *qp)
  * This must be called with s_lock held.
  */
 void hfi1_bad_pqkey(struct hfi1_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
-		    u32 qp1, u32 qp2, __be16 lid1, __be16 lid2);
+		    u32 qp1, u32 qp2, u16 lid1, u16 lid2);
 void hfi1_cap_mask_chg(struct hfi1_ibport *ibp);
 void hfi1_sys_guid_chg(struct hfi1_ibport *ibp);
 void hfi1_node_desc_chg(struct hfi1_ibport *ibp);
