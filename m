From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH 2/3] opensm/qos_policy: Add a new service ID and keyword for
 Lustre QoS
Date: Wed, 13 Jan 2010 15:54:42 +0100
Message-ID: <20100113155442.28930e5c@frecb007965>
References: <20100113154952.0f01aa1d@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100113154952.0f01aa1d@frecb007965>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  This patch adds a new service ID for the Lustre ULP as well as the
lexer and parser bits for the policy definition simplified syntax.

  The QoS policy parser now supports the following 'qos-ulps' keywords:

   lustre                          : 0 #default SL for Lustre
   lustre, target-port-guid 0x1234 : 1 #SL for Lustre with target port guid
   lustre, port-num 10000-20000    : 2 #SL for Lustre port range

  This, along with patches to the kernel rdma cma and Lustre, allow to define a
specific QoS for lustre.

Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
---
 opensm/include/opensm/osm_qos_policy.h |   11 ++--
 opensm/opensm/osm_qos_parser_l.l       |    8 +++
 opensm/opensm/osm_qos_parser_y.y       |  108 ++++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/opensm/include/opensm/osm_qos_policy.h b/opensm/include/opensm/osm_qos_policy.h
index 03ee891..ea3998a 100644
--- a/opensm/include/opensm/osm_qos_policy.h
+++ b/opensm/include/opensm/osm_qos_policy.h
@@ -54,11 +54,12 @@
 #define OSM_QOS_POLICY_MAX_PORTS_ON_SWITCH  128
 #define OSM_QOS_POLICY_DEFAULT_LEVEL_NAME   "default"
 
-#define OSM_QOS_POLICY_ULP_SDP_SERVICE_ID   0x0000000000010000ULL
-#define OSM_QOS_POLICY_ULP_RDS_SERVICE_ID   0x0000000001060000ULL
-#define OSM_QOS_POLICY_ULP_RDS_PORT         0x48CA
-#define OSM_QOS_POLICY_ULP_ISER_SERVICE_ID  0x0000000001060000ULL
-#define OSM_QOS_POLICY_ULP_ISER_PORT        0x0CBC
+#define OSM_QOS_POLICY_ULP_SDP_SERVICE_ID     0x0000000000010000ULL
+#define OSM_QOS_POLICY_ULP_RDS_SERVICE_ID     0x0000000001060000ULL
+#define OSM_QOS_POLICY_ULP_RDS_PORT           0x48CA
+#define OSM_QOS_POLICY_ULP_ISER_SERVICE_ID    0x0000000001060000ULL
+#define OSM_QOS_POLICY_ULP_ISER_PORT          0x0CBC
+#define OSM_QOS_POLICY_ULP_LUSTRE_SERVICE_ID  0x0000000001530000ULL
 
 #define OSM_QOS_POLICY_NODE_TYPE_CA        (((uint8_t)1)<<IB_NODE_TYPE_CA)
 #define OSM_QOS_POLICY_NODE_TYPE_SWITCH    (((uint8_t)1)<<IB_NODE_TYPE_SWITCH)
diff --git a/opensm/opensm/osm_qos_parser_l.l b/opensm/opensm/osm_qos_parser_l.l
index 4633e0e..8f5d147 100644
--- a/opensm/opensm/osm_qos_parser_l.l
+++ b/opensm/opensm/osm_qos_parser_l.l
@@ -117,6 +117,9 @@ static void reset_new_line_flags();
 #define START_ULP_SRP_GUID      {in_list_of_num_ranges = TRUE;} /* comma-separated list of hex or dec num ranges */
 #define START_ULP_IPOIB_DEFAULT {in_single_number = TRUE;}      /* single number */
 #define START_ULP_IPOIB_PKEY    {in_list_of_num_ranges = TRUE;} /* comma-separated list of hex or dec num ranges */
+#define START_ULP_LUSTRE_DEFAULT {in_single_number = TRUE;}      /* single number */
+#define START_ULP_LUSTRE_PORT    {in_list_of_num_ranges = TRUE;} /* comma-separated list of hex or dec num ranges */
+#define START_ULP_LUSTRE_PORT_GUID {in_list_of_num_ranges = TRUE;} /* comma-separated list of hex or dec num ranges */
 
 
 %}
@@ -187,6 +190,7 @@ ULP_SDP                 [Ss][Dd][Pp]
 ULP_SRP                 [Ss][Rr][Pp]
 ULP_RDS                 [Rr][Dd][Ss]
 ULP_IPOIB               [Ii][Pp][Oo][Ii][Bb]
+ULP_LUSTRE              [Ll][Uu][Ss][Tt][Rr][Ee]
 ULP_ISER                [Ii][Ss][Ee][Rr]
 ULP_ANY                 [Aa][Nn][Yy]
 ULP_DEFAULT             [Dd][Ee][Ff][Aa][Uu][Ll][Tt]
@@ -289,6 +293,10 @@ QUOTED_TEXT             \"[^\"]*\"
 {ULP_IPOIB}{WHITE_DOTDOT_WHITE}                { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_IPOIB_DEFAULT; return TK_ULP_IPOIB_DEFAULT; }
 {ULP_IPOIB}{WHITE_COMMA_WHITE}{PKEY}           { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_IPOIB_PKEY; return TK_ULP_IPOIB_PKEY; }
 
+{ULP_LUSTRE}{WHITE_DOTDOT_WHITE}               { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_LUSTRE_DEFAULT; return TK_ULP_LUSTRE_DEFAULT; }
+{ULP_LUSTRE}{WHITE_COMMA_WHITE}{PORT_NUM}      { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_LUSTRE_PORT; return TK_ULP_LUSTRE_PORT; }
+{ULP_LUSTRE}{WHITE_COMMA_WHITE}{TARGET_PORT_GUID}      { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_LUSTRE_PORT_GUID; return TK_ULP_LUSTRE_PORT_GUID; }
+
 0[xX][0-9a-fA-F]+  {
                         SAVE_POS;
                         yylval = strdup(yytext);
diff --git a/opensm/opensm/osm_qos_parser_y.y b/opensm/opensm/osm_qos_parser_y.y
index 7118b79..ccaac91 100644
--- a/opensm/opensm/osm_qos_parser_y.y
+++ b/opensm/opensm/osm_qos_parser_y.y
@@ -268,6 +268,9 @@ static cl_list_t __ulp_match_rules;
 %token TK_ULP_SRP_GUID
 %token TK_ULP_IPOIB_DEFAULT
 %token TK_ULP_IPOIB_PKEY
+%token TK_ULP_LUSTRE_DEFAULT
+%token TK_ULP_LUSTRE_PORT
+%token TK_ULP_LUSTRE_PORT_GUID
 
 %start head
 
@@ -302,6 +305,9 @@ qos_policy_entry:     qos_ulps_section
      *      iser                          : 4 #default SL for iSER
      *      ipoib, pkey 0x0001            : 5 #SL for IPoIB on partition with pkey 0x0001
      *      ipoib                         : 6 #default IPoIB partition - pkey=0x7FFF
+     *      lustre                        : 0 #default SL for Lustre
+     *      lustre, port-num 10000-20000  : 2 #SL for Lustre port range
+     *      lustre, target-port-guid 0x1234 : 3 #SL for Lustre with target port guid
      *      any, service-id 0x6234        : 2
      *      any, pkey 0x0ABC              : 3
      *      any, target-port-guid 0x0ABC-0xFFFFF : 6
@@ -628,6 +634,9 @@ qos_match_rule_entry: qos_match_rule_use
      *   iser with port-num
      *   ipoib
      *   ipoib with pkey
+     *   lustre
+     *   lustre with port-num
+     *   lustre with port-guid
      *   any with service-id
      *   any with pkey
      *   any with target-port-guid
@@ -951,6 +960,96 @@ qos_ulp:            TK_ULP_DEFAULT single_number {
                         p_current_qos_match_rule->pkey_range_len = range_len;
 
                     } qos_ulp_sl
+
+		    | qos_ulp_type_lustre_default {
+			/* "lustre : sl" - default SL for Lustre */
+			uint64_t ** range_arr =
+                               (uint64_t **)malloc(sizeof(uint64_t *));
+                        range_arr[0] = (uint64_t *)malloc(2*sizeof(uint64_t));
+                        range_arr[0][0] = OSM_QOS_POLICY_ULP_LUSTRE_SERVICE_ID;
+                        range_arr[0][1] = OSM_QOS_POLICY_ULP_LUSTRE_SERVICE_ID + 0xFFFF;
+
+                        p_current_qos_match_rule->service_id_range_arr = range_arr;
+                        p_current_qos_match_rule->service_id_range_len = 1;
+
+		    } qos_ulp_sl
+
+                    | qos_ulp_type_lustre_port list_of_ranges TK_DOTDOT {
+                        /* Lustre with port numbers */
+                        uint64_t ** range_arr;
+                        unsigned    range_len;
+                        unsigned    i;
+
+                        if (!cl_list_count(&tmp_parser_struct.num_pair_list))
+                        {
+                            yyerror("Lustre ULP rule doesn't have port numbers");
+                            return 1;
+                        }
+
+                        /* get all the port ranges */
+                        __rangelist2rangearr( &tmp_parser_struct.num_pair_list,
+                                              &range_arr,
+                                              &range_len );
+                        /* now translate these port numbers into service ids */
+                        for (i = 0; i < range_len; i++)
+                        {
+                            if (range_arr[i][0] > 0xFFFF || range_arr[i][1] > 0xFFFF)
+                            {
+                                yyerror("Lustre port number out of range");
+                                return 1;
+                            }
+                            range_arr[i][0] += OSM_QOS_POLICY_ULP_LUSTRE_SERVICE_ID;
+                            range_arr[i][1] += OSM_QOS_POLICY_ULP_LUSTRE_SERVICE_ID;
+                        }
+
+                        p_current_qos_match_rule->service_id_range_arr = range_arr;
+                        p_current_qos_match_rule->service_id_range_len = range_len;
+
+                    } qos_ulp_sl
+
+		    | qos_ulp_type_lustre_port_guid list_of_ranges TK_DOTDOT {
+			/* lustre, port-guid ... : sl */
+                        uint64_t ** range_arr;
+                        unsigned    range_len;
+
+                        if (!cl_list_count(&tmp_parser_struct.num_pair_list))
+                        {
+                            yyerror("Lustre ULP rule doesn't have port guids");
+                            return 1;
+                        }
+
+                        /* create a new port group with these ports */
+                        __parser_port_group_start();
+
+                        p_current_port_group->name = strdup("_Lustre_Targets_");
+                        p_current_port_group->use = strdup("Generated from ULP rules");
+
+                        __rangelist2rangearr( &tmp_parser_struct.num_pair_list,
+                                              &range_arr,
+                                              &range_len );
+
+                        __parser_add_guid_range_to_port_map(
+                                              &p_current_port_group->port_map,
+                                              range_arr,
+                                              range_len);
+
+                        /* add this port group to the destination
+                           groups of the current match rule */
+                        cl_list_insert_tail(&p_current_qos_match_rule->destination_group_list,
+                                            p_current_port_group);
+
+                        __parser_port_group_end();
+
+			/* setup ranges as in qos_ulp_type_lustre_default */
+			range_arr = (uint64_t **)malloc(sizeof(uint64_t *));
+                        range_arr[0] = (uint64_t *)malloc(2*sizeof(uint64_t));
+                        range_arr[0][0] = OSM_QOS_POLICY_ULP_LUSTRE_SERVICE_ID;
+                        range_arr[0][1] = OSM_QOS_POLICY_ULP_LUSTRE_SERVICE_ID + 0xFFFF;
+
+                        p_current_qos_match_rule->service_id_range_arr = range_arr;
+                        p_current_qos_match_rule->service_id_range_len = 1;
+
+		    } qos_ulp_sl
                     ;
 
 qos_ulp_type_any_service: TK_ULP_ANY_SERVICE_ID
@@ -989,6 +1088,15 @@ qos_ulp_type_ipoib_default: TK_ULP_IPOIB_DEFAULT
 qos_ulp_type_ipoib_pkey: TK_ULP_IPOIB_PKEY
                     { __parser_ulp_match_rule_start(); };
 
+qos_ulp_type_lustre_default: TK_ULP_LUSTRE_DEFAULT
+                    { __parser_ulp_match_rule_start(); };
+
+qos_ulp_type_lustre_port: TK_ULP_LUSTRE_PORT
+                    { __parser_ulp_match_rule_start(); };
+
+qos_ulp_type_lustre_port_guid: TK_ULP_LUSTRE_PORT_GUID
+                    { __parser_ulp_match_rule_start(); };
+
 
 qos_ulp_sl:   single_number {
                         /* get the SL for ULP rules */
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
