From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] infiniband-diags/saquery: Add GUIDInfoRecord support
Date: Fri, 25 Mar 2011 21:23:31 +0200
Message-ID: <4D8CEBB3.805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
  infiniband-diags/man/saquery.8 |    3 +-
  infiniband-diags/src/saquery.c |   48 
+++++++++++++++++++++++++++++++++++++++-
  2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/infiniband-diags/man/saquery.8 b/infiniband-diags/man/saquery.8
index b2b9d91..4a3102d 100644
--- a/infiniband-diags/man/saquery.8
+++ b/infiniband-diags/man/saquery.8
@@ -1,4 +1,4 @@
-.TH SAQUERY 8 "October 19, 2008" "OpenIB" "OpenIB Diagnostics"
+.TH SAQUERY 8 "March 28, 2010" "OpenIB" "OpenIB Diagnostics"

  .SH NAME
  saquery \- query InfiniBand subnet administration attributes
@@ -117,6 +117,7 @@ Supported query names (and aliases):
   MCMemberRecord (MCMR)
   LFTRecord (LFTR) [[lid]/[block]]
   MFTRecord (MFTR) [[mlid]/[position]/[block]]
+ GUIDInfoRecord (GIR) [[lid]/[block]]
  .TP
  \fB\-d\fR
  enable debugging
diff --git a/infiniband-diags/src/saquery.c b/infiniband-diags/src/saquery.c
index cb4fc18..490f6d2 100644
--- a/infiniband-diags/src/saquery.c
+++ b/infiniband-diags/src/saquery.c
@@ -781,6 +781,31 @@ static void dump_one_lft_record(void *data)
      printf("\n");
  }

+static void dump_one_guidinfo_record(void *data)
+{
+    ib_guidinfo_record_t *gir = data;
+    printf("GUIDInfo Record dump:\n"
+           "\t\tLID........................%u\n"
+           "\t\tBlock......................%u\n"
+           "\t\tGUID 0.....................0x%016" PRIx64 "\n"
+           "\t\tGUID 1.....................0x%016" PRIx64 "\n"
+           "\t\tGUID 2.....................0x%016" PRIx64 "\n"
+           "\t\tGUID 3.....................0x%016" PRIx64 "\n"
+           "\t\tGUID 4.....................0x%016" PRIx64 "\n"
+           "\t\tGUID 5.....................0x%016" PRIx64 "\n"
+           "\t\tGUID 6.....................0x%016" PRIx64 "\n"
+           "\t\tGUID 7.....................0x%016" PRIx64 "\n",
+           cl_ntoh16(gir->lid), gir->block_num,
+           cl_ntoh64(gir->guid_info.guid[0]),
+           cl_ntoh64(gir->guid_info.guid[1]),
+           cl_ntoh64(gir->guid_info.guid[2]),
+           cl_ntoh64(gir->guid_info.guid[3]),
+           cl_ntoh64(gir->guid_info.guid[4]),
+           cl_ntoh64(gir->guid_info.guid[5]),
+           cl_ntoh64(gir->guid_info.guid[6]),
+           cl_ntoh64(gir->guid_info.guid[7]));
+}
+
  static void dump_one_mft_record(void *data)
  {
      ib_mft_record_t *mftr = data;
@@ -1339,6 +1364,25 @@ static int query_lft_records(const struct 
query_cmd *q, bind_handle_t h,
&lftr, 0, dump_one_lft_record);
  }

+static int query_guidinfo_records(const struct query_cmd *q, 
bind_handle_t h,
+                  struct query_params *p, int argc, char *argv[])
+{
+    ib_guidinfo_record_t gir;
+    ib_net64_t comp_mask = 0;
+    int lid = 0, block = -1;
+
+    if (argc > 0)
+        parse_lid_and_ports(h, argv[0], &lid, &block, NULL);
+
+    memset(&gir, 0, sizeof(gir));
+    CHECK_AND_SET_VAL(lid, 16, 0, gir.lid, GIR, LID);
+    CHECK_AND_SET_VAL(block, 8, -1, gir.block_num, GIR, BLOCKNUM);
+
+    return get_and_dump_any_records(h, IB_SA_ATTR_GUIDINFORECORD, 0,
+                    comp_mask, &gir, 0,
+                    dump_one_guidinfo_record);
+}
+
  static int query_mft_records(const struct query_cmd *q, bind_handle_t h,
                   struct query_params *p, int argc, char *argv[])
  {
@@ -1419,6 +1463,8 @@ static const struct query_cmd query_cmds[] = {
       "[[lid]/[block]]", query_lft_records},
      {"MFTRecord", "MFTR", IB_SA_ATTR_MFTRECORD,
       "[[mlid]/[position]/[block]]", query_mft_records},
+    {"GUIDInfoRecord", "GIR", IB_SA_ATTR_GUIDINFORECORD,
+     "[[lid]/[block]]", query_guidinfo_records},
      {0}
  };

-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
