From: Husam Kahalah <hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband_diags/src/saquery.c: Add SMInfoRecord support
Date: Tue, 28 May 2013 15:03:54 +0300
Message-ID: <51A49D2A.1090602@asaltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch is the combination of 2 patches
     infiniband_diags/src/saquery.c: Add SMInfoRecord support
     infiniband_diags/doc/rst/saquery.8.in.rst: Add support to the manual

Signed-off-by: Husam Kahalah <hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>

---
  doc/rst/saquery.8.in.rst |    1 +
  src/saquery.c            |   45 
+++++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 46 insertions(+)

diff --git a/doc/rst/saquery.8.in.rst b/doc/rst/saquery.8.in.rst
index 8d87096..0551917 100644
--- a/doc/rst/saquery.8.in.rst
+++ b/doc/rst/saquery.8.in.rst
@@ -156,6 +156,7 @@ Supported query names (and aliases):
          MFTRecord (MFTR) [[mlid]/[position]/[block]]
          GUIDInfoRecord (GIR) [[lid]/[block]]
          SwitchInfoRecord (SWIR) [lid]
+        SMInfoRecord (SMIR) [lid]



diff --git a/src/saquery.c b/src/saquery.c
index a5f9171..d60ac19 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -487,6 +487,30 @@ static void dump_service_record(void *data)
             cl_ntoh64(p_sr->service_data64[1]));
  }

+static void dump_sm_info_record(void *data)
+{
+    ib_sminfo_record_t *p_smr = data;
+    const ib_sm_info_t *const p_smi = &p_smr->sm_info;
+    uint8_t priority, state;
+    priority = ib_sminfo_get_priority(p_smi);
+    state = ib_sminfo_get_state(p_smi);
+
+    printf("SMInfoRecord dump:\n"
+           "\t\tRID\n"
+           "\t\tLID...................%u\n"
+           "\t\tSMInfo dump:\n"
+           "\t\tGUID..................0x%016" PRIx64 "\n"
+           "\t\tSM_Key................0x%016" PRIx64 "\n"
+           "\t\tActCount..............0x%X\n"
+           "\t\tPriority..............%u\n"
+           "\t\tSMState...............%u\n",
+           cl_ntoh16(p_smr->lid),
+           cl_ntoh64(p_smr->sm_info.guid),
+           cl_ntoh64(p_smr->sm_info.sm_key),
+           cl_ntoh32(p_smr->sm_info.act_count),
+           priority, state);
+}
+
  static void dump_switch_info_record(void *data)
  {
      ib_switch_info_record_t *p_sir = data;
@@ -1192,6 +1216,25 @@ static int query_service_records(const struct 
query_cmd *q, struct sa_handle * h
                      dump_service_record);
  }

+static int query_sm_info_records(const struct query_cmd *q,
+                 struct sa_handle * h, struct query_params *p,
+                 int argc, char *argv[])
+{
+    ib_sminfo_record_t smir;
+    ib_net64_t comp_mask = 0;
+    int lid = 0;
+
+    if (argc > 0)
+        parse_lid_and_ports(h, argv[0], &lid, NULL, NULL);
+
+    memset(&smir, 0, sizeof(smir));
+    CHECK_AND_SET_VAL(lid, 16, 0, smir.lid, SMIR, LID);
+
+    return get_and_dump_any_records(h, IB_SA_ATTR_SMINFORECORD, 0,
+                    comp_mask, &smir, sizeof(smir),
+                    dump_sm_info_record);
+}
+
  static int query_switchinfo_records(const struct query_cmd *q,
                  struct sa_handle * h, struct query_params *p,
                  int argc, char *argv[])
@@ -1404,6 +1447,8 @@ static const struct query_cmd query_cmds[] = {
       "[[lid]/[block]]", query_guidinfo_records},
      {"SwitchInfoRecord", "SWIR", IB_SA_ATTR_SWITCHINFORECORD,
       "[lid]", query_switchinfo_records},
+    {"SMInfoRecord", "SMIR", IB_SA_ATTR_SMINFORECORD,
+    "[lid]", query_sm_info_records},
      {0}
  };

-- 
1.7.9.6



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
