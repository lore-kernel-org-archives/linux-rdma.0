From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH 3/3] Support source-target-port-guid QoS policy
	configuration with ULP 'any'
Date: Mon, 07 Nov 2011 13:26:36 -0800
Message-ID: <1320701196.22519.110.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For ease of configuration, combines the source-port-guid and target-port-guid
options into a single line.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 doc/QoS_management_in_OpenSM.txt |    5 ++++
 opensm/osm_qos_parser_l.l        |    2 +
 opensm/osm_qos_parser_y.y        |   44 ++++++++++++++++++++++++++++++++++++++
 opensm/osm_qos_policy.c          |   36 ++++++++++++++++++++++++++----
 4 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/doc/QoS_management_in_OpenSM.txt b/doc/QoS_management_in_OpenSM.txt
index 25b37f4..c104c1d 100644
--- a/doc/QoS_management_in_OpenSM.txt
+++ b/doc/QoS_management_in_OpenSM.txt
@@ -293,6 +293,8 @@ Match rules include:
  - any ULP/application with a specific PKey in the PR/MPR query
  - any ULP/application with a specific target IB port GUID in the PR/MPR query
  - any ULP/application with a specific source IB port GUID in the PR/MPR query
+ - any ULP/application with a specific source or target IB port GUID in the
+   PR/MPR query
 
 Since any section of the policy file is optional, as long as basic rules of
 the file are kept (such as no referring to nonexisting port group, having
@@ -336,6 +338,9 @@ Below is an example of simplified QoS policy with all the possible keywords:
         any, source-port-guid 0x5678  : 7 # match any PR/MPR query with
                                           # a specific source port
                                           # GUID
+	any, source-target-port-guid 0x9abcd : 8 # match any PR/MPR query with
+					  # a specific source or target port
+					  # GUID
     end-qos-ulps
 
 
diff --git a/opensm/osm_qos_parser_l.l b/opensm/osm_qos_parser_l.l
index abe34c2..32fe85a 100644
--- a/opensm/osm_qos_parser_l.l
+++ b/opensm/osm_qos_parser_l.l
@@ -135,6 +135,7 @@ USE                     use
 PORT_GUID               port\-guid
 TARGET_PORT_GUID        target\-port\-guid
 SOURCE_PORT_GUID        source\-port\-guid
+SOURCE_TARGET_PORT_GUID source\-target\-port\-guid
 PORT_NAME               port\-name
 PARTITION               partition
 NODE_TYPE               node\-type
@@ -276,6 +277,7 @@ QUOTED_TEXT             \"[^\"]*\"
 {ULP_ANY}{WHITE_COMMA_WHITE}{PKEY}             { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_ANY; return TK_ULP_ANY_PKEY; }
 {ULP_ANY}{WHITE_COMMA_WHITE}{TARGET_PORT_GUID} { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_ANY; return TK_ULP_ANY_TARGET_PORT_GUID; }
 {ULP_ANY}{WHITE_COMMA_WHITE}{SOURCE_PORT_GUID} { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_ANY; return TK_ULP_ANY_SOURCE_PORT_GUID; }
+{ULP_ANY}{WHITE_COMMA_WHITE}{SOURCE_TARGET_PORT_GUID} { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_ANY; return TK_ULP_ANY_SOURCE_TARGET_PORT_GUID; }
 
 {ULP_SDP}{WHITE_DOTDOT_WHITE}                  { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_SDP_DEFAULT; return TK_ULP_SDP_DEFAULT; }
 {ULP_SDP}{WHITE_COMMA_WHITE}{PORT_NUM}         { SAVE_POS; HANDLE_IF_IN_DESCRIPTION; START_ULP_SDP_PORT; return TK_ULP_SDP_PORT; }
diff --git a/opensm/osm_qos_parser_y.y b/opensm/osm_qos_parser_y.y
index 452ab1b..5dda34c 100644
--- a/opensm/osm_qos_parser_y.y
+++ b/opensm/osm_qos_parser_y.y
@@ -261,6 +261,7 @@ static cl_list_t __ulp_match_rules;
 %token TK_ULP_ANY_PKEY
 %token TK_ULP_ANY_TARGET_PORT_GUID
 %token TK_ULP_ANY_SOURCE_PORT_GUID
+%token TK_ULP_ANY_SOURCE_TARGET_PORT_GUID
 %token TK_ULP_SDP_DEFAULT
 %token TK_ULP_SDP_PORT
 %token TK_ULP_RDS_DEFAULT
@@ -308,6 +309,7 @@ qos_policy_entry:     qos_ulps_section
      *      any, pkey 0x0ABC              : 3
      *      any, target-port-guid 0x0ABC-0xFFFFF : 6
      *      any, source-port-guid 0x1234  : 7
+     *      any, source-target-port-guid 0x5678 : 8
      *  end-qos-ulps
      */
 
@@ -635,6 +637,7 @@ qos_match_rule_entry: qos_match_rule_use
      *   any with pkey
      *   any with target-port-guid
      *   any with source-port-guid
+     *   any with source-target-port-guid
      */
 
 qos_ulp:            TK_ULP_DEFAULT single_number {
@@ -767,6 +770,44 @@ qos_ulp:            TK_ULP_DEFAULT single_number {
 
 		    } qos_ulp_sl
 
+		    | qos_ulp_type_any_source_target_port_guid list_of_ranges TK_DOTDOT {
+			/* any, source-target-port-guid ... : sl */
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
+                        p_current_port_group->name = strdup("_ULP_Sources_Targets_");
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
+                        /* add this port group to the source and destination
+                           groups of the current match rule */
+                        cl_list_insert_tail(&p_current_qos_match_rule->source_group_list,
+                                            p_current_port_group);
+
+                        cl_list_insert_tail(&p_current_qos_match_rule->destination_group_list,
+                                            p_current_port_group);
+
+                        __parser_port_group_end();
+
+		    } qos_ulp_sl
+
                     | qos_ulp_type_sdp_default {
                         /* "sdp : sl" - default SL for SDP */
                         uint64_t ** range_arr =
@@ -1009,6 +1050,9 @@ qos_ulp_type_any_target_port_guid: TK_ULP_ANY_TARGET_PORT_GUID
 qos_ulp_type_any_source_port_guid: TK_ULP_ANY_SOURCE_PORT_GUID
                     { __parser_ulp_match_rule_start(); };
 
+qos_ulp_type_any_source_target_port_guid: TK_ULP_ANY_SOURCE_TARGET_PORT_GUID
+                    { __parser_ulp_match_rule_start(); };
+
 qos_ulp_type_sdp_default: TK_ULP_SDP_DEFAULT
                     { __parser_ulp_match_rule_start(); };
 
diff --git a/opensm/osm_qos_policy.c b/opensm/osm_qos_policy.c
index 3780968..4908d1c 100644
--- a/opensm/osm_qos_policy.c
+++ b/opensm/osm_qos_policy.c
@@ -578,6 +578,7 @@ static osm_qos_match_rule_t *__qos_policy_get_match_rule_by_params(
 
 	boolean_t matched_by_sguid = FALSE,
 		  matched_by_dguid = FALSE,
+		  matched_by_sordguid = FALSE,
 		  matched_by_class = FALSE,
 		  matched_by_sid = FALSE,
 		  matched_by_pkey = FALSE;
@@ -598,9 +599,11 @@ static osm_qos_match_rule_t *__qos_policy_get_match_rule_by_params(
 			continue;
 		}
 
-		/* If a match rule has Source groups, PR request source has to be in this list */
+		/* If a match rule has Source groups and no Destination groups,
+ 		 * PR request source has to be in this list */
 
-		if (cl_list_count(&p_qos_match_rule->source_group_list)) {
+		if (cl_list_count(&p_qos_match_rule->source_group_list)
+		    && !cl_list_count(&p_qos_match_rule->destination_group_list)) {
 			if (!__qos_policy_is_port_in_group_list(p_qos_policy,
 								p_src_physp,
 								&p_qos_match_rule->
@@ -612,9 +615,11 @@ static osm_qos_match_rule_t *__qos_policy_get_match_rule_by_params(
 			matched_by_sguid = TRUE;
 		}
 
-		/* If a match rule has Destination groups, PR request dest. has to be in this list */
+		/* If a match rule has Destination groups and no Source groups,
+ 		 * PR request dest. has to be in this list */
 
-		if (cl_list_count(&p_qos_match_rule->destination_group_list)) {
+		if (cl_list_count(&p_qos_match_rule->destination_group_list)
+		    && !cl_list_count(&p_qos_match_rule->source_group_list)) {
 			if (!__qos_policy_is_port_in_group_list(p_qos_policy,
 								p_dest_physp,
 								&p_qos_match_rule->
@@ -626,6 +631,26 @@ static osm_qos_match_rule_t *__qos_policy_get_match_rule_by_params(
 			matched_by_dguid = TRUE;
 		}
 
+		/* If a match rule has both Source and Destination groups,
+ 		 * PR request source or dest. must be in respective list
+ 		 */
+		if (cl_list_count(&p_qos_match_rule->source_group_list)
+		    && cl_list_count(&p_qos_match_rule->destination_group_list)) {
+			if (!__qos_policy_is_port_in_group_list(p_qos_policy,
+								p_src_physp,
+								&p_qos_match_rule->
+								source_group_list)
+			    && !__qos_policy_is_port_in_group_list(p_qos_policy,
+								   p_dest_physp,
+								   &p_qos_match_rule->
+								   destination_group_list))
+			{
+				list_iterator = cl_list_next(list_iterator);
+				continue;
+			}
+			matched_by_sordguid = TRUE;
+		}
+
 		/* If a match rule has QoS classes, PR request HAS
 		   to have a matching QoS class to match the rule */
 
@@ -693,11 +718,12 @@ static osm_qos_match_rule_t *__qos_policy_get_match_rule_by_params(
 
 	if (p_qos_match_rule)
 		OSM_LOG(p_log, OSM_LOG_DEBUG,
-			"request matched rule (%s) by:%s%s%s%s%s\n",
+			"request matched rule (%s) by:%s%s%s%s%s%s\n",
 			(p_qos_match_rule->use) ?
 				p_qos_match_rule->use : "no description",
 			(matched_by_sguid) ? " SGUID" : "",
 			(matched_by_dguid) ? " DGUID" : "",
+			(matched_by_sordguid) ? "SorDGUID" : "",
 			(matched_by_class) ? " QoS_Class" : "",
 			(matched_by_sid)   ? " ServiceID" : "",
 			(matched_by_pkey)  ? " PKey" : "");
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
