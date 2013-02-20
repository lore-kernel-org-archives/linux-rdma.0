From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_qos_policy.c: Fix source & destination GUID policy
 check
Date: Wed, 20 Feb 2013 14:02:11 -0500
Message-ID: <51251DB3.4090906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


in __qos_policy_get_match_rule_by_params

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_qos_policy.c b/opensm/osm_qos_policy.c
index 796fb89..1afc289 100644
--- a/opensm/osm_qos_policy.c
+++ b/opensm/osm_qos_policy.c
@@ -640,19 +640,19 @@ static osm_qos_match_rule_t *__qos_policy_get_match_rule_by_params(
 		 */
 		if (cl_list_count(&p_qos_match_rule->source_group_list)
 		    && cl_list_count(&p_qos_match_rule->destination_group_list)) {
-			if (!__qos_policy_is_port_in_group_list(p_qos_policy,
-								p_src_physp,
-								&p_qos_match_rule->
-								source_group_list)
-			    && !__qos_policy_is_port_in_group_list(p_qos_policy,
-								   p_dest_physp,
-								   &p_qos_match_rule->
-								   destination_group_list))
-			{
+			if (__qos_policy_is_port_in_group_list(p_qos_policy,
+							       p_src_physp,
+							       &p_qos_match_rule->
+							       source_group_list)
+			    && __qos_policy_is_port_in_group_list(p_qos_policy,
+								  p_dest_physp,
+								  &p_qos_match_rule->
+								  destination_group_list))
+				matched_by_sordguid = TRUE;
+			else {
 				list_iterator = cl_list_next(list_iterator);
 				continue;
 			}
-			matched_by_sordguid = TRUE;
 		}
 
 		/* If a match rule has QoS classes, PR request HAS
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
