From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_qos_parser_y.y: fixing bunch of memory leaks on
	invalid values
Date: Tue, 7 Sep 2010 18:17:54 +0300
Message-ID: <4C8657A2.8020106@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_qos_parser_y.y |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_qos_parser_y.y b/opensm/opensm/osm_qos_parser_y.y
index 7118b79..d9830dc 100644
--- a/opensm/opensm/osm_qos_parser_y.y
+++ b/opensm/opensm/osm_qos_parser_y.y
@@ -763,6 +763,7 @@ qos_ulp:            TK_ULP_DEFAULT single_number {
                             if (range_arr[i][0] > 0xFFFF || range_arr[i][1] > 0xFFFF)
                             {
                                 yyerror("SDP port number out of range");
+                                free(range_arr);
                                 return 1;
                             }
                             range_arr[i][0] += OSM_QOS_POLICY_ULP_SDP_SERVICE_ID;
@@ -809,6 +810,7 @@ qos_ulp:            TK_ULP_DEFAULT single_number {
                             if (range_arr[i][0] > 0xFFFF || range_arr[i][1] > 0xFFFF)
                             {
                                 yyerror("SDP port number out of range");
+                                free(range_arr);
                                 return 1;
                             }
                             range_arr[i][0] += OSM_QOS_POLICY_ULP_RDS_SERVICE_ID;
@@ -855,6 +857,7 @@ qos_ulp:            TK_ULP_DEFAULT single_number {
                             if (range_arr[i][0] > 0xFFFF || range_arr[i][1] > 0xFFFF)
                             {
                                 yyerror("SDP port number out of range");
+                                free(range_arr);
                                 return 1;
                             }
                             range_arr[i][0] += OSM_QOS_POLICY_ULP_ISER_SERVICE_ID;
@@ -944,8 +947,10 @@ qos_ulp:            TK_ULP_DEFAULT single_number {
                          * If some problem would be found, parsing will
                          * be aborted with a proper error messages.
                          */
-                        if (__validate_pkeys(range_arr, range_len, TRUE))
+                        if (__validate_pkeys(range_arr, range_len, TRUE)) {
+                            free(range_arr);
                             return 1;
+                        }

                         p_current_qos_match_rule->pkey_range_arr = range_arr;
                         p_current_qos_match_rule->pkey_range_len = range_len;
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
