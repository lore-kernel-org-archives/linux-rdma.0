From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_mcmember_record.c: print mcast join/create
 failures in VERBOSE instead of DEBUG level
Date: Mon, 07 Dec 2009 12:22:55 +0200
Message-ID: <4B1CD77F.6050905@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

If mcast group join/create fails, the details about
the failure reason are printed in OSM_LOG_DEBUG level.
This is rather important info, and needs to be printed
in OSM_LOG_VERBOSE level. Note that only one message
is printed per failure.

I'm also considering turning all these messages into
OSM_LOG_ERROR messages with more details.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 3839b67..a4d86e3 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -247,7 +247,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 		switch (mtu_sel) {
 		case 0:	/* Greater than MTU specified */
 			if (mtu_mgrp <= mtu_required) {
-				OSM_LOG(p_log, OSM_LOG_DEBUG,
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has MTU %x, "
 					"which is not greater than %x\n",
 					mtu_mgrp, mtu_required);
@@ -256,7 +256,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 			break;
 		case 1:	/* Less than MTU specified */
 			if (mtu_mgrp >= mtu_required) {
-				OSM_LOG(p_log, OSM_LOG_DEBUG,
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has MTU %x, "
 					"which is not less than %x\n",
 					mtu_mgrp, mtu_required);
@@ -265,7 +265,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 			break;
 		case 2:	/* Exactly MTU specified */
 			if (mtu_mgrp != mtu_required) {
-				OSM_LOG(p_log, OSM_LOG_DEBUG,
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has MTU %x, "
 					"which is not equal to %x\n",
 					mtu_mgrp, mtu_required);
@@ -286,7 +286,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 		switch (rate_sel) {
 		case 0:	/* Greater than RATE specified */
 			if (rate_mgrp <= rate_required) {
-				OSM_LOG(p_log, OSM_LOG_DEBUG,
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has RATE %x, "
 					"which is not greater than %x\n",
 					rate_mgrp, rate_required);
@@ -295,7 +295,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 			break;
 		case 1:	/* Less than RATE specified */
 			if (rate_mgrp >= rate_required) {
-				OSM_LOG(p_log, OSM_LOG_DEBUG,
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has RATE %x, "
 					"which is not less than %x\n",
 					rate_mgrp, rate_required);
@@ -304,7 +304,7 @@ static boolean_t validate_more_comp_fields(osm_log_t * p_log,
 			break;
 		case 2:	/* Exactly RATE specified */
 			if (rate_mgrp != rate_required) {
-				OSM_LOG(p_log, OSM_LOG_DEBUG,
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested mcast group has RATE %x, "
 					"which is not equal to %x\n",
 					rate_mgrp, rate_required);
@@ -335,7 +335,7 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 	mtu_required = ib_port_info_get_mtu_cap(&p_physp->port_info);
 	mtu_mgrp = (uint8_t) (p_mgrp->mcmember_rec.mtu & 0x3F);
 	if (mtu_required < mtu_mgrp) {
-		OSM_LOG(p_log, OSM_LOG_DEBUG,
+		OSM_LOG(p_log, OSM_LOG_VERBOSE,
 			"Port's MTU %x is less than %x\n",
 			mtu_required, mtu_mgrp);
 		return FALSE;
@@ -344,7 +344,7 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 	rate_required = ib_port_info_compute_rate(&p_physp->port_info);
 	rate_mgrp = (uint8_t) (p_mgrp->mcmember_rec.rate & 0x3F);
 	if (rate_required < rate_mgrp) {
-		OSM_LOG(p_log, OSM_LOG_DEBUG,
+		OSM_LOG(p_log, OSM_LOG_VERBOSE,
 			"Port's RATE %x is less than %x\n",
 			rate_required, rate_mgrp);
 		return FALSE;
@@ -666,7 +666,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 		switch (mtu_sel) {
 		case 0:	/* Greater than MTU specified */
 			if (port_mtu && mtu_required >= port_mtu) {
-				OSM_LOG(p_log, OSM_LOG_DEBUG,
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested MTU %x >= the port\'s mtu:%x\n",
 					mtu_required, port_mtu);
 				return FALSE;
@@ -694,7 +694,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 		}
 		/* make sure it still be in the range */
 		if (mtu < IB_MIN_MTU || mtu > IB_MAX_MTU) {
-			OSM_LOG(p_log, OSM_LOG_DEBUG,
+			OSM_LOG(p_log, OSM_LOG_VERBOSE,
 				"Calculated MTU %x is out of range\n", mtu);
 			return FALSE;
 		}
@@ -713,7 +713,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 		switch (rate_sel) {
 		case 0:	/* Greater than RATE specified */
 			if (port_rate && rate_required >= port_rate) {
-				OSM_LOG(p_log, OSM_LOG_DEBUG,
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
 					"Requested RATE %x >= the port\'s rate:%x\n",
 					rate_required, port_rate);
 				return FALSE;
@@ -741,7 +741,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 		}
 		/* make sure it still is in the range */
 		if (rate < IB_MIN_RATE || rate > IB_MAX_RATE) {
-			OSM_LOG(p_log, OSM_LOG_DEBUG,
+			OSM_LOG(p_log, OSM_LOG_VERBOSE,
 				"Calculated RATE %x is out of range\n", rate);
 			return FALSE;
 		}
@@ -1015,7 +1015,7 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)

 	if (!osm_physp_share_pkey(sa->p_log, p_physp, p_request_physp)) {
 		CL_PLOCK_RELEASE(sa->p_lock);
-		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
 			"Port and requester don't share pkey\n");
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
 		goto Exit;
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
