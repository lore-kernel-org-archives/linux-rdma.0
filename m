From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 for-next 3/7] IB/hfi1: Validate PKEY for incoming GSI MAD
 packets
Date: Wed, 25 Oct 2017 08:15:18 -0700
Message-ID: <20171025151515.667.5270.stgit@scvm10.sc.intel.com>
References: <20171023130558.21191.30808.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023130558.21191.30808.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These are the use-cases where the pkey needs to be tested to see
if a packet needs to be dropped.

a) Check if pkey is not FULL_MGMT_P_KEY or LIM_MGMT_P_KEY,
   drop the packet as it's not part of the management partition.
   Self-originated packets are an exception.

b) If pkey index points to FULL_MGMT_P_KEY and LIM_MGMT_P_KEY is
   in the table, the packet is coming from a management node,
   and the receiving node is also a management node, so it is safe
   for the packet to go through.

c) If pkey index points to FULL_MGMT_P_KEY and LIM_MGMT_P_KEY is
   NOT in the table, drop the packet as LIM_MGMT_P_KEY should
   always be in the pkey table. It could be a misconfiguration.

d) If pkey index points to LIM_MGMT_P_KEY and FULL_MGMT_P_KEY is
   NOT in the table, it is safe for the packet to go through
   since a non-management node is talking to another non-managment
   node.

e) If pkey index points to LIM_MGMT_P_KEY and FULL_MGMT_P_KEY is in
   the table, drop the packet because a non-management node is
   talking to a management node, and it could be an attack.

For the implementation, these rules can be simplied to only checking
for (a) and (e). There's no need to check for rule (b) as
the packet doesn't need to be dropped. Rule (c) is not possible in
the driver as LIM_MGMT_P_KEY is always in the pkey table.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |   86 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 07b80fa..da42e68 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -98,6 +98,16 @@ static inline void clear_opa_smp_data(struct opa_smp *smp)
 	memset(data, 0, size);
 }
 
+static u16 hfi1_lookup_pkey_value(struct hfi1_ibport *ibp, int pkey_idx)
+{
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+
+	if (pkey_idx < ARRAY_SIZE(ppd->pkeys))
+		return ppd->pkeys[pkey_idx];
+
+	return 0;
+}
+
 void hfi1_event_pkey_change(struct hfi1_devdata *dd, u8 port)
 {
 	struct ib_event event;
@@ -4260,6 +4270,18 @@ void clear_linkup_counters(struct hfi1_devdata *dd)
 	dd->err_info_xmit_constraint.status &= ~OPA_EI_STATUS_SMASK;
 }
 
+static int is_full_mgmt_pkey_in_table(struct hfi1_ibport *ibp)
+{
+	unsigned int i;
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+
+	for (i = 0; i < ARRAY_SIZE(ppd->pkeys); ++i)
+		if (ppd->pkeys[i] == FULL_MGMT_P_KEY)
+			return 1;
+
+	return 0;
+}
+
 /*
  * is_local_mad() returns 1 if 'mad' is sent from, and destined to the
  * local node, 0 otherwise.
@@ -4327,6 +4349,63 @@ static int opa_local_smp_check(struct hfi1_ibport *ibp,
 	return 1;
 }
 
+/**
+ * hfi1_pkey_validation_pma - It validates PKEYs for incoming PMA MAD packets.
+ * @ibp: IB port data
+ * @in_mad: MAD packet with header and data
+ * @in_wc: Work completion data such as source LID, port number, etc.
+ *
+ * These are all the possible logic rules for validating a pkey:
+ *
+ * a) If pkey neither FULL_MGMT_P_KEY nor LIM_MGMT_P_KEY,
+ *    and NOT self-originated packet:
+ *     Drop MAD packet as it should always be part of the
+ *     management partition unless it's a self-originated packet.
+ *
+ * b) If pkey_index -> FULL_MGMT_P_KEY, and LIM_MGMT_P_KEY in pkey table:
+ *     The packet is coming from a management node and the receiving node
+ *     is also a management node, so it is safe for the packet to go through.
+ *
+ * c) If pkey_index -> FULL_MGMT_P_KEY, and LIM_MGMT_P_KEY is NOT in pkey table:
+ *     Drop the packet as LIM_MGMT_P_KEY should always be in the pkey table.
+ *     It could be an FM misconfiguration.
+ *
+ * d) If pkey_index -> LIM_MGMT_P_KEY and FULL_MGMT_P_KEY is NOT in pkey table:
+ *     It is safe for the packet to go through since a non-management node is
+ *     talking to another non-management node.
+ *
+ * e) If pkey_index -> LIM_MGMT_P_KEY and FULL_MGMT_P_KEY in pkey table:
+ *     Drop the packet because a non-management node is talking to a
+ *     management node, and it could be an attack.
+ *
+ * For the implementation, these rules can be simplied to only checking
+ * for (a) and (e). There's no need to check for rule (b) as
+ * the packet doesn't need to be dropped. Rule (c) is not possible in
+ * the driver as LIM_MGMT_P_KEY is always in the pkey table.
+ *
+ * Return:
+ * 0 - pkey is okay, -EINVAL it's a bad pkey
+ */
+static int hfi1_pkey_validation_pma(struct hfi1_ibport *ibp,
+				    const struct opa_mad *in_mad,
+				    const struct ib_wc *in_wc)
+{
+	u16 pkey_value = hfi1_lookup_pkey_value(ibp, in_wc->pkey_index);
+
+	/* Rule (a) from above */
+	if (!is_local_mad(ibp, in_mad, in_wc) &&
+	    pkey_value != LIM_MGMT_P_KEY &&
+	    pkey_value != FULL_MGMT_P_KEY)
+		return -EINVAL;
+
+	/* Rule (e) from above */
+	if (pkey_value == LIM_MGMT_P_KEY &&
+	    is_full_mgmt_pkey_in_table(ibp))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
 			    u8 port, const struct opa_mad *in_mad,
 			    struct opa_mad *out_mad,
@@ -4666,8 +4745,11 @@ static int hfi1_process_opa_mad(struct ib_device *ibdev, int mad_flags,
 				       out_mad, &resp_len);
 		goto bail;
 	case IB_MGMT_CLASS_PERF_MGMT:
-		ret = process_perf_opa(ibdev, port, in_mad, out_mad,
-				       &resp_len);
+		ret = hfi1_pkey_validation_pma(ibp, in_mad, in_wc);
+		if (ret)
+			return IB_MAD_RESULT_FAILURE;
+
+		ret = process_perf_opa(ibdev, port, in_mad, out_mad, &resp_len);
 		goto bail;
 
 	default:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
