From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 infiniband-diags] Add support for QP1Dropped counter in
 PortCounters attribute
Date: Wed, 25 Oct 2017 08:10:26 -0400
Message-ID: <0324cefc-efc8-3e83-c7d0-d206cb3407fe@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add support for missing QP1Dropped counter in PortCounters attribute
in libibmad and perfquery.c.

Support for this counter is indicated by IsQP1DroppedSupported bit 15
in PerfMgt ClassPortInfo:CapabilityMask.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Restored PortXmitWait handling for PortCounters based on PortCountersXmitWaitSupported in ClassPortInfo:CapabilityMask

 libibmad/include/infiniband/mad.h |  5 +++++
 libibmad/src/dump.c               | 15 ++++++++++++++-
 libibmad/src/fields.c             |  5 +++++
 src/perfquery.c                   | 30 +++++++++++++++++++++++++-----
 4 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index 50c5bc5..7f6b886 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1310,6 +1310,11 @@ enum MAD_FIELDS {
 	IB_PC_EXT_QP1_DROP_F,
 	IB_PC_EXT_ERR_LAST_F,
 
+	/*
+	 * Another PortCounters field
+	 */
+	IB_PC_QP1_DROP_F,
+
 	IB_FIELD_LAST_		/* must be last */
 };
 
diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index 24878a6..2244f38 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -818,7 +818,20 @@ void mad_dump_switchinfo(char *buf, int bufsz, void *val, int valsz)
 
 void mad_dump_perfcounters(char *buf, int bufsz, void *val, int valsz)
 {
-	_dump_fields(buf, bufsz, val, IB_PC_FIRST_F, IB_PC_LAST_F);
+	int cnt, cnt2;
+
+	cnt = _dump_fields(buf, bufsz, val,
+			   IB_PC_FIRST_F, IB_PC_VL15_DROPPED_F);
+	if (cnt < 0)
+		return;
+
+	cnt2 = _dump_fields(buf + cnt, bufsz - cnt, val,
+			    IB_PC_QP1_DROP_F, IB_PC_QP1_DROP_F + 1);
+	if (cnt2 < 0)
+		return;
+
+	_dump_fields(buf + cnt + cnt2, bufsz - cnt - cnt2, val,
+		     IB_PC_VL15_DROPPED_F, IB_PC_LAST_F);
 }
 
 void mad_dump_perfcounters_ext(char *buf, int bufsz, void *val, int valsz)
diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index 520287d..bf48689 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -1004,6 +1004,11 @@ static const ib_field_t ib_mad_f[] = {
 	{1408, 64, "QP1Dropped", mad_dump_uint},
 	{0, 0},			/* IB_PC_EXT_ERR_LAST_F */
 
+	/*
+	 * Another PortCounters field
+	 */
+	{160, 16, "QP1Dropped", mad_dump_uint},
+
 	{0, 0}			/* IB_FIELD_LAST_ */
 };
 
diff --git a/src/perfquery.c b/src/perfquery.c
index f5d23f2..39d628e 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -66,6 +66,7 @@ struct perf_count {
 	uint32_t rcvconstrainterrors;
 	uint32_t linkintegrityerrors;
 	uint32_t excbufoverrunerrors;
+	uint32_t qp1dropped;
 	uint32_t vl15dropped;
 	uint32_t xmtdata;
 	uint32_t rcvdata;
@@ -190,6 +191,8 @@ static void aggregate_perfcounters(void)
 	aggregate_4bit(&perf_count.linkintegrityerrors, val);
 	mad_decode_field(pc, IB_PC_ERR_EXCESS_OVR_F, &val);
 	aggregate_4bit(&perf_count.excbufoverrunerrors, val);
+	mad_decode_field(pc, IB_PC_QP1_DROP_F, &val);
+	aggregate_16bit(&perf_count.qp1dropped, val);
 	mad_decode_field(pc, IB_PC_VL15_DROPPED_F, &val);
 	aggregate_16bit(&perf_count.vl15dropped, val);
 	mad_decode_field(pc, IB_PC_XMT_BYTES_F, &val);
@@ -230,6 +233,7 @@ static void output_aggregate_perfcounters(ib_portid_t * portid,
 			 &perf_count.linkintegrityerrors);
 	mad_encode_field(pc, IB_PC_ERR_EXCESS_OVR_F,
 			 &perf_count.excbufoverrunerrors);
+	mad_encode_field(pc, IB_PC_QP1_DROP_F, &perf_count.qp1dropped);
 	mad_encode_field(pc, IB_PC_VL15_DROPPED_F, &perf_count.vl15dropped);
 	mad_encode_field(pc, IB_PC_XMT_BYTES_F, &perf_count.xmtdata);
 	mad_encode_field(pc, IB_PC_RCV_BYTES_F, &perf_count.rcvdata);
@@ -380,6 +384,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 			      uint32_t cap_mask2, ib_portid_t * portid,
 			      int port, int aggregate)
 {
+	int cnt;
 	char buf[1536];
 
 	if (extended != 1) {
@@ -397,10 +402,21 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 		}
 		if (aggregate)
 			aggregate_perfcounters();
-		else
+		else {
 			mad_dump_fields(buf, sizeof buf, pc, sizeof pc,
-							IB_PC_FIRST_F,
-							(cap_mask & IB_PM_PC_XMIT_WAIT_SUP)?IB_PC_LAST_F:(IB_PC_RCV_PKTS_F+1));
+					IB_PC_FIRST_F, IB_PC_VL15_DROPPED_F);
+			if (cap_mask & IB_PM_IS_QP1_DROP_SUP) {
+				cnt = strlen(buf);
+				mad_dump_fields(buf + cnt, sizeof buf - cnt, pc, sizeof pc,
+						IB_PC_QP1_DROP_F,
+						IB_PC_QP1_DROP_F + 1);
+			}
+			cnt = strlen(buf);
+			mad_dump_fields(buf + cnt, sizeof buf - cnt, pc, sizeof
+pc,
+					IB_PC_VL15_DROPPED_F,
+					(cap_mask & IB_PM_PC_XMIT_WAIT_SUP) ? IB_PC_LAST_F: (IB_PC_RCV_PKTS_F + 1));
+		}
 
 	} else {
 		/* 1.2 errata: bit 9 is extended counter support
@@ -1062,8 +1078,12 @@ int main(int argc, char **argv)
 		goto done;
 
 do_reset:
-	if (argc <= 2 && !extended && (cap_mask & IB_PM_PC_XMIT_WAIT_SUP))
-		mask |= (1 << 16);	/* reset portxmitwait */
+	if (argc <= 2 && !extended) {
+		if (cap_mask & IB_PM_PC_XMIT_WAIT_SUP)
+			mask |= (1 << 16);	/* reset portxmitwait */
+		if (cap_mask & IB_PM_IS_QP1_DROP_SUP)
+			mask |= (1 << 17);	/* reset qp1dropped */
+	}
 
 	if (extended) {
 		mask |= 0xfff0000;
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
