From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_qos_parser_y.y: Added range check for rate limit
 parsing
Date: Mon, 24 Mar 2014 07:33:34 -0400
Message-ID: <5330180E.5030802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
---
 opensm/osm_qos_parser_y.y |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_qos_parser_y.y b/opensm/osm_qos_parser_y.y
index a1dbd37..1176a4b 100644
--- a/opensm/osm_qos_parser_y.y
+++ b/opensm/osm_qos_parser_y.y
@@ -61,6 +61,8 @@
 #define OSM_QOS_POLICY_MAX_LINE_LEN         1024*10
 #define OSM_QOS_POLICY_SL2VL_TABLE_LEN      IB_MAX_NUM_VLS
 #define OSM_QOS_POLICY_MAX_VL_NUM           IB_MAX_NUM_VLS
+#define OSM_QOS_POLICY_MAX_RATE             IB_MAX_RATE
+#define OSM_QOS_POLICY_MIN_RATE             IB_MIN_RATE
 
 typedef struct tmp_parser_struct_t_ {
     char       str[OSM_QOS_POLICY_MAX_LINE_LEN];
@@ -1879,6 +1881,13 @@ qos_level_rate_limit:    qos_level_rate_limit_start single_number {
                             }
                             list_iterator = cl_list_head(&tmp_parser_struct.num_list);
                             p_num = (uint64_t*)cl_list_obj(list_iterator);
+                            if (*p_num > OSM_QOS_POLICY_MAX_RATE || *p_num < OSM_QOS_POLICY_MIN_RATE)
+                            {
+                                yyerror("rate limit is out of range, value: %d", *p_num);
+                                free(p_num);
+                                cl_list_remove_all(&tmp_parser_struct.num_list);
+                                return 1;
+                            }
                             p_current_qos_level->rate_limit = (uint8_t)(*p_num);
                             free(p_num);
                             p_current_qos_level->rate_limit_set = TRUE;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
