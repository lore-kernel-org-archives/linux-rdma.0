From: Husam Kahalah <hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1]  infiniband-diags/saquery.c: switchinfo support added
Date: Sun, 31 Mar 2013 16:29:17 +0300
Message-ID: <51583A2D.7040708@asaltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Added support to filter SwitchInfoRecords by switch LID

Signed-off-by: Husam kahalah < hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>

---
  src/saquery.c |   55 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
  1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index d31d77d..6390bcd 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -481,6 +481,41 @@ static void dump_service_record(void *data)
             cl_ntoh64(p_sr->service_data64[1]));
  }

+static void dump_switch_info_record(void *data)
+{
+    ib_switch_info_record_t *p_sir = data;
+
+    printf("SwitchInfoRecord dump:\n"
+           "\t\tRID\n"
+           "\t\tlid.....................%u\n"
+           "\t\tSwitchInfo dump:\n"
+           "\t\tlin_cap.................0x%X\n"
+           "\t\trand_cap................0x%X\n"
+           "\t\tmcast_cap...............0x%X\n"
+           "\t\tlin_top.................0x%X\n"
+           "\t\tdef_port................%u\n"
+           "\t\tdef_mcast_pri_port......%u\n"
+           "\t\tdef_mcast_not_port......%u\n"
+           "\t\tlife_state..............%u\n"
+           "\t\tlids_per_port...........0x%X\n"
+           "\t\tenforce_cap.............0x%X\n"
+           "\t\tflags...................%u\n"
+           "\t\tmcast_top...............0x%X\n",
+           cl_ntoh16(p_sir->lid),
+           cl_ntoh16(p_sir->switch_info.lin_cap),
+           cl_ntoh16(p_sir->switch_info.rand_cap),
+           cl_ntoh16(p_sir->switch_info.mcast_cap),
+           cl_ntoh16(p_sir->switch_info.lin_top),
+           p_sir->switch_info.def_port,
+           p_sir->switch_info.def_mcast_pri_port,
+           p_sir->switch_info.def_mcast_not_port,
+           p_sir->switch_info.life_state,
+           cl_ntoh16(p_sir->switch_info.lids_per_port),
+           cl_ntoh16(p_sir->switch_info.enforce_cap),
+           p_sir->switch_info.flags,
+           cl_ntoh16(p_sir->switch_info.mcast_top));
+}
+
  static void dump_inform_info_record(void *data)
  {
      char gid_str[INET6_ADDRSTRLEN];
@@ -1150,6 +1185,24 @@ static int query_service_records(const struct 
query_cmd *q, struct sa_handle * h
                      dump_service_record);
  }

+static int query_switchinfo_records(const struct query_cmd *q,
+                struct sa_handle * h, struct query_params *p,
+                int argc, char *argv[])
+{
+    ib_switch_info_record_t swir;
+    ib_net64_t comp_mask = 0;
+    int lid = 0;
+
+    if (argc > 0)
+        parse_lid_and_ports(h, argv[0], &lid, NULL, NULL);
+
+    memset(&swir, 0, sizeof(swir));
+    CHECK_AND_SET_VAL(lid, 16, 0, swir.lid, SWIR, LID);
+
+    return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0, 
comp_mask,
+                    &swir, sizeof(swir), dump_switch_info_record);
+}
+
  static int query_inform_info_records(const struct query_cmd *q,
                      struct sa_handle * h, struct query_params *p,
                      int argc, char *argv[])
@@ -1342,6 +1395,8 @@ static const struct query_cmd query_cmds[] = {
       "[[mlid]/[position]/[block]]", query_mft_records},
      {"GUIDInfoRecord", "GIR", IB_SA_ATTR_GUIDINFORECORD,
       "[[lid]/[block]]", query_guidinfo_records},
+    {"SwitchInfoRecord", "SWIR", IB_SA_ATTR_SWITCHINFORECORD,
+     "[lid]", query_switchinfo_records},
      {0}
  };

-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
