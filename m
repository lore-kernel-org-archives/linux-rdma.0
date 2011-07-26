From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3] opensm/osm_sa_path_record.c: Proper rate comparison and
 selection
Date: Tue, 26 Jul 2011 11:23:46 -0400
Message-ID: <4E2EDC02.10305@dev.mellanox.co.il>
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
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 20818ee..f3b25f6 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -349,7 +349,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
-		if (rate > ib_port_info_compute_rate(p_pi, 0))
+		if (ib_path_compare_rates(rate,
+					  ib_port_info_compute_rate(p_pi, 0)) > 0)
 			rate = ib_port_info_compute_rate(p_pi, 0);
 
 		/*
@@ -372,7 +373,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
-		if (rate > ib_port_info_compute_rate(p_pi, 0))
+		if (ib_path_compare_rates(rate,
+					  ib_port_info_compute_rate(p_pi, 0)) > 0)
 			rate = ib_port_info_compute_rate(p_pi, 0);
 
 		if (sa->p_subn->opt.qos) {
@@ -425,7 +427,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	if (mtu > ib_port_info_get_mtu_cap(p_pi))
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
-	if (rate > ib_port_info_compute_rate(p_pi, 0))
+	if (ib_path_compare_rates(rate,
+				  ib_port_info_compute_rate(p_pi, 0)) > 0)
 		rate = ib_port_info_compute_rate(p_pi, 0);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
@@ -451,7 +454,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 			mtu = p_qos_level->mtu_limit;
 
 		if (p_qos_level->rate_limit_set
-		    && (rate > p_qos_level->rate_limit))
+		    && (ib_path_compare_rates(rate, p_qos_level->rate_limit) > 0))
 			rate = p_qos_level->rate_limit;
 
 		if (p_qos_level->sl_set) {
@@ -529,23 +532,22 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		required_rate = ib_path_rec_rate(p_pr);
 		switch (ib_path_rec_rate_sel(p_pr)) {
 		case 0:	/* must be greater than */
-			if (rate <= required_rate)
+			if (ib_path_compare_rates(rate, required_rate) <= 0)
 				status = IB_NOT_FOUND;
 			break;
 
 		case 1:	/* must be less than */
-			if (rate >= required_rate) {
+			if (ib_path_compare_rates(rate, required_rate) >= 0) {
 				/* adjust the rate to use the highest rate
 				   lower then the required one */
-				if (required_rate > 2)
-					rate = required_rate - 1;
-				else
+				rate = ib_path_rate_get_prev(required_rate);
+				if (!rate)
 					status = IB_NOT_FOUND;
 			}
 			break;
 
 		case 2:	/* exact match */
-			if (rate < required_rate)
+			if (ib_path_compare_rates(rate, required_rate))
 				status = IB_NOT_FOUND;
 			else
 				rate = required_rate;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
