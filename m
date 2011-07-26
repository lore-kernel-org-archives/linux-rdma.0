From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] opensm/osm_sa_mcmember_record.c: Proper rate comparison
 and selection
Date: Tue, 26 Jul 2011 11:23:51 -0400
Message-ID: <4E2EDC07.3050408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 61d3e34..16e6dbd 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -285,7 +285,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 		rate_mgrp = (uint8_t) (p_mgrp->mcmember_rec.rate & 0x3F);
 		switch (rate_sel) {
 		case 0:	/* Greater than RATE specified */
-			if (rate_mgrp <= rate_required) {
+			if (ib_path_compare_rates(rate_mgrp, rate_required) <= 0) {
 				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has RATE %x, "
 					"which is not greater than %x\n",
@@ -294,7 +294,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 			}
 			break;
 		case 1:	/* Less than RATE specified */
-			if (rate_mgrp >= rate_required) {
+			if (ib_path_compare_rates(rate_mgrp, rate_required) >= 0) {
 				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has RATE %x, "
 					"which is not less than %x\n",
@@ -303,7 +303,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 			}
 			break;
 		case 2:	/* Exactly RATE specified */
-			if (rate_mgrp != rate_required) {
+			if (ib_path_compare_rates(rate_mgrp, rate_required)) {
 				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has RATE %x, "
 					"which is not equal to %x\n",
@@ -343,7 +343,7 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 
 	rate_required = ib_port_info_compute_rate(&p_physp->port_info, 0);
 	rate_mgrp = (uint8_t) (p_mgrp->mcmember_rec.rate & 0x3F);
-	if (rate_required < rate_mgrp) {
+	if (ib_path_compare_rates(rate_required, rate_mgrp) < 0) {
 		OSM_LOG(p_log, OSM_LOG_VERBOSE,
 			"Port's RATE %x is less than %x\n",
 			rate_required, rate_mgrp);
@@ -689,7 +689,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 		default:
 			break;
 		}
-		/* make sure it still be in the range */
+		/* make sure it still is in the range */
 		if (mtu < IB_MIN_MTU || mtu > IB_MAX_MTU) {
 			OSM_LOG(p_log, OSM_LOG_VERBOSE,
 				"Calculated MTU %x is out of range\n", mtu);
@@ -709,7 +709,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 		rate = rate_required;
 		switch (rate_sel) {
 		case 0:	/* Greater than RATE specified */
-			if (port_rate && rate_required >= port_rate) {
+			if (ib_path_compare_rates(rate_required, port_rate) >= 0) {
 				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested RATE %x >= the port\'s rate:%x\n",
 					rate_required, port_rate);
@@ -718,19 +718,20 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 			/* we provide the largest RATE possible if we can */
 			if (port_rate)
 				rate = port_rate;
-			else if (rate_required < sa->p_subn->min_ca_rate)
+			else if (ib_path_compare_rates(rate_required,
+						       sa->p_subn->min_ca_rate) < 0)
 				rate = sa->p_subn->min_ca_rate;
 			else
-				rate++;
+				rate = ib_path_rate_get_next(rate);
 			break;
 		case 1:	/* Less than RATE specified */
 			/* use the smaller of the two:
 			   a. one lower then the required
 			   b. the rate of the requesting port (if exists) */
-			if (port_rate && rate_required > port_rate)
+			if (ib_path_compare_rates(rate_required, port_rate) > 0)
 				rate = port_rate;
 			else
-				rate--;
+				rate = ib_path_rate_get_prev(rate);
 			break;
 		case 2:	/* Exactly RATE specified */
 		default:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
