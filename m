From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH 2/3] Support source-port-guid QoS policy
	configuration with ULP 'any'
Date: Mon, 07 Nov 2011 13:26:33 -0800
Message-ID: <1320701193.22519.109.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Similar to the target-port-guid option, source-port-guid supports
the ability to configure a SL based on a specific source port in a path
record lookup.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 doc/QoS_management_in_OpenSM.txt |    4 +++
 opensm/osm_qos_parser_l.l        |    2 +
 opensm/osm_qos_parser_y.y        |   41 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/doc/QoS_management_in_OpenSM.txt b/doc/QoS_management_in_OpenSM.txt
index 8c9915f..25b37f4 100644
--- a/doc/QoS_management_in_OpenSM.txt
+++ b/doc/QoS_management_in_OpenSM.txt
@@ -292,6 +292,7 @@ Match rules include:
  - any ULP/application with a specific Service ID in the PR/MPR query
  - any ULP/application with a specific PKey in the PR/MPR query
  - any ULP/application with a specific target IB port GUID in the PR/MPR query
+ - any ULP/application with a specific source IB port GUID in the PR/MPR query
 
 Since any section of the policy file is optional, as long as basic rules of
 the file are kept (such as no referring to nonexisting port group, having
@@ -332,6 +333,9 @@ Below is an example of simplified QoS policy with all the possible keywords:
                                           # a specified IB port GUID
         any, target-port-guid 0x0ABC-0xFFFFF : 6 # match any PR/MPR query with
                                           # a specific target port GUID
+        any, source-port-guid 0x5678  : 7 # match any PR/MPR query with
+                                          # a specific source port
+                                          # GUID
     end-qos-ulps
 
 
diff --git a/opensm/osm_qos_parser_l.l b/opensm/osm_qos_parser_l.l
index 559974b..abe34c2 100644
--- a/opensm/osm_qos_parser_l.l
+++ b/opensm/osm_qos_parser_l.l
@@ -134,6 +134,7 @@ NAME                    name
 USE                     use
 PORT_GUID               port\-guid
 TARGET_PORT_GUID        target\-port\-guid
+SOURCE_PORT_GUID        source\-port\-guid
 PORT_NAME               port\-name
 PARTITION               partition
 NODE_TYPE               node\-type
@@ -274,6 +275,7 @@ QUOTED_TEXT             \"[^\"]*\"
 {ULP_ANY}{WHITE_COMMA_WHITE}{SERVICE_ID}       { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_ANY; return TK_ULP_ANY_SERVICE_ID; }
 {ULP_ANY}{WHITE_COMMA_WHITE}{PKEY}             { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_ANY; return TK_ULP_ANY_PKEY; }
 {ULP_ANY}{WHITE_COMMA_WHITE}{TARGET_PORT_GUID} { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_ANY; return TK_ULP_ANY_TARGET_PORT_GUID; }
+{ULP_ANY}{WHITE_COMMA_WHITE}{SOURCE_PORT_GUID} { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_ANY; return TK_ULP_ANY_SOURCE_PORT_GUID; }
 
 {ULP_SDP}{WHITE_DOTDOT_WHITE}                  { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_SDP_DEFAULT; return TK_ULP_SDP_DEFAULT; }
 {ULP_SDP}{WHITE_COMMA_WHITE}{PORT_NUM}         { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_SDP_PORT; return TK_ULP_SDP_PORT; }
diff --git a/opensm/osm_qos_parser_y.y b/opensm/osm_qos_parser_y.y
index 348750d..452ab1b 100644
--- a/opensm/osm_qos_parser_y.y
+++ b/opensm/osm_qos_parser_y.y
@@ -260,6 +260,7 @@ static cl_list_t __ulp_match_rules;
 %token TK_ULP_ANY_SERVICE_ID
 %token TK_ULP_ANY_PKEY
 %token TK_ULP_ANY_TARGET_PORT_GUID
+%token TK_ULP_ANY_SOURCE_PORT_GUID
 %token TK_ULP_SDP_DEFAULT
 %token TK_ULP_SDP_PORT
 %token TK_ULP_RDS_DEFAULT
@@ -306,6 +307,7 @@ qos_policy_entry:     qos_ulps_section
      *      any, service-id 0x6234        : 2
      *      any, pkey 0x0ABC              : 3
      *      any, target-port-guid 0x0ABC-0xFFFFF : 6
+     *      any, source-port-guid 0x1234  : 7
      *  end-qos-ulps
      */
 
@@ -632,6 +634,7 @@ qos_match_rule_entry: qos_match_rule_use
      *   any with service-id
      *   any with pkey
      *   any with target-port-guid
+     *   any with source-port-guid
      */
 
 qos_ulp:            TK_ULP_DEFAULT single_number {
@@ -729,6 +732,41 @@ qos_ulp:            TK_ULP_DEFAULT single_number {
 
                     } qos_ulp_sl
 
+		    | qos_ulp_type_any_source_port_guid list_of_ranges TK_DOTDOT {
+			/* any, source-port-guid ... : sl */
+			uint64_t ** range_arr;
+			unsigned    range_len;
+
+			if (!cl_list_count(&tmp_parser_struct.num_pair_list))
+			{
+				yyerror("ULP rule doesn't have port guids");
+				return 1;
+			}
+
+                        /* create a new port group with these ports */
+                        __parser_port_group_start();
+
+                        p_current_port_group->name = strdup("_ULP_Sources_");
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
+                        /* add this port group to the source
+                           groups of the current match rule */
+                        cl_list_insert_tail(&p_current_qos_match_rule->source_group_list,
+                                            p_current_port_group);
+
+                        __parser_port_group_end();
+
+		    } qos_ulp_sl
+
                     | qos_ulp_type_sdp_default {
                         /* "sdp : sl" - default SL for SDP */
                         uint64_t ** range_arr =
@@ -968,6 +1006,9 @@ qos_ulp_type_any_pkey: TK_ULP_ANY_PKEY
 qos_ulp_type_any_target_port_guid: TK_ULP_ANY_TARGET_PORT_GUID
                     { __parser_ulp_match_rule_start(); };
 
+qos_ulp_type_any_source_port_guid: TK_ULP_ANY_SOURCE_PORT_GUID
+                    { __parser_ulp_match_rule_start(); };
+
 qos_ulp_type_sdp_default: TK_ULP_SDP_DEFAULT
                     { __parser_ulp_match_rule_start(); };
 
-- 
1.7.1




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
