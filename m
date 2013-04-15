From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags: saquery; add SwitchInfoRecord
Date: Sun, 14 Apr 2013 23:15:54 -0700
Message-ID: <20130414231554.5e2ac986ab2a1a81c52d8656@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


This patch is the combination of the 2 patches supplied by Husam kahalah
	[v2] infiniband-diags/saquery.c: switchinfo support added
	switchinfo support added manual

In addition this version changes the field names to match those in Vol1 v1.2.1
and Errata.

Signed-off-by: Husam kahalah < hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 doc/man/saquery.8.in     |    1 +
 doc/rst/saquery.8.in.rst |    1 +
 src/saquery.c            |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/doc/man/saquery.8.in b/doc/man/saquery.8.in
index e9a05cd..84eedd6 100644
--- a/doc/man/saquery.8.in
+++ b/doc/man/saquery.8.in
@@ -183,6 +183,7 @@ MCMemberRecord (MCMR)
 LFTRecord (LFTR) [[lid]/[block]]
 MFTRecord (MFTR) [[mlid]/[position]/[block]]
 GUIDInfoRecord (GIR) [[lid]/[block]]
+SwitchInfoRecord (SWIR) [[lid]/[block]]
 .ft P
 .fi
 .UNINDENT
diff --git a/doc/rst/saquery.8.in.rst b/doc/rst/saquery.8.in.rst
index 98f7d1f..7d6ed6f 100644
--- a/doc/rst/saquery.8.in.rst
+++ b/doc/rst/saquery.8.in.rst
@@ -155,6 +155,7 @@ Supported query names (and aliases):
         LFTRecord (LFTR) [[lid]/[block]]
         MFTRecord (MFTR) [[mlid]/[position]/[block]]
         GUIDInfoRecord (GIR) [[lid]/[block]]
+        SwitchInfoRecord (SWIR) [[lid]/[block]]
 
 
 
diff --git a/src/saquery.c b/src/saquery.c
index 72a0fe9..34f3524 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -487,6 +487,41 @@ static void dump_service_record(void *data)
 	       cl_ntoh64(p_sr->service_data64[1]));
 }
 
+static void dump_switch_info_record(void *data)
+{
+	ib_switch_info_record_t *p_sir = data;
+
+	printf("SwitchInfoRecord dump:\n"
+		"\t\tRID\n"
+		"\t\tLID.....................................%u\n"
+		"\t\tSwitchInfo dump:\n"
+		"\t\tLinearFDBCap............................0x%X\n"
+		"\t\tRandomFDBCap............................0x%X\n"
+		"\t\tMulticastFDBCap.........................0x%X\n"
+		"\t\tLinearFDBTop............................0x%X\n"
+		"\t\tDefaultPort.............................%u\n"
+		"\t\tDefaultMulticastPrimaryPort.............%u\n"
+		"\t\tDefaultMulticastNotPrimaryPort..........%u\n"
+		"\t\tLifeTimeValue/PortStateChange/OpSL2VL...%u\n"
+		"\t\tLIDsPerPort.............................0x%X\n"
+		"\t\tPartitionEnforcementCap.................0x%X\n"
+		"\t\tflags...................................0x%X\n"
+		"\t\tMulticastFDBTop.........................0x%X\n",
+		cl_ntoh16(p_sir->lid),
+		cl_ntoh16(p_sir->switch_info.lin_cap),
+		cl_ntoh16(p_sir->switch_info.rand_cap),
+		cl_ntoh16(p_sir->switch_info.mcast_cap),
+		cl_ntoh16(p_sir->switch_info.lin_top),
+		p_sir->switch_info.def_port,
+		p_sir->switch_info.def_mcast_pri_port,
+		p_sir->switch_info.def_mcast_not_port,
+		p_sir->switch_info.life_state,
+		cl_ntoh16(p_sir->switch_info.lids_per_port),
+		cl_ntoh16(p_sir->switch_info.enforce_cap),
+		p_sir->switch_info.flags,
+		cl_ntoh16(p_sir->switch_info.mcast_top));
+}
+
 static void dump_inform_info_record(void *data)
 {
 	char gid_str[INET6_ADDRSTRLEN];
@@ -1157,6 +1192,24 @@ static int query_service_records(const struct query_cmd *q, struct sa_handle * h
 					dump_service_record);
 }
 
+static int query_switchinfo_records(const struct query_cmd *q,
+				struct sa_handle * h, struct query_params *p,
+				int argc, char *argv[])
+{
+	ib_switch_info_record_t swir;
+	ib_net64_t comp_mask = 0;
+	int lid = 0;
+
+	if (argc > 0)
+		parse_lid_and_ports(h, argv[0], &lid, NULL, NULL);
+
+	memset(&swir, 0, sizeof(swir));
+	CHECK_AND_SET_VAL(lid, 16, 0, swir.lid, SWIR, LID);
+
+	return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0, comp_mask,
+					&swir, sizeof(swir), dump_switch_info_record);
+}
+
 static int query_inform_info_records(const struct query_cmd *q,
 				    struct sa_handle * h, struct query_params *p,
 				    int argc, char *argv[])
@@ -1349,6 +1402,8 @@ static const struct query_cmd query_cmds[] = {
 	 "[[mlid]/[position]/[block]]", query_mft_records},
 	{"GUIDInfoRecord", "GIR", IB_SA_ATTR_GUIDINFORECORD,
 	 "[[lid]/[block]]", query_guidinfo_records},
+	{"SwitchInfoRecord", "SWIR", IB_SA_ATTR_SWITCHINFORECORD,
+	 "[lid]", query_switchinfo_records},
 	{0}
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
