From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/7] opensm/osm_helper: Add ib_rate_is_valid
Date: Sat, 01 Oct 2011 09:15:32 -0400
Message-ID: <4E871274.2070103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


for use in rate validation by SA

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_helper.h |   24 ++++++++++++++++++++++++
 opensm/libopensm.map        |    1 +
 opensm/osm_helper.c         |    7 +++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/opensm/osm_helper.h b/include/opensm/osm_helper.h
index f48af89..7eb4e2a 100644
--- a/include/opensm/osm_helper.h
+++ b/include/opensm/osm_helper.h
@@ -588,6 +588,30 @@ const char *osm_get_sm_mgr_state_str(IN uint16_t state);
 * SEE ALSO
 *********/
 
+/****f* IBA Base: Types/ib_rate_is_valid
+* NAME
+*	ib_rate_is_valid
+*
+* DESCRIPTION
+*	Validates encoded rate
+*
+* SYNOPSIS
+*/
+int ib_rate_is_valid(IN const int rate);
+/*
+* PARAMETERS
+*	rate
+*		[in] Encoded path rate.
+*
+* RETURN VALUES
+*	Returns an int indicating rate is valid (1)
+*	or invalid (0).
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* IBA Base: Types/ib_path_compare_rates
 * NAME
 *	ib_path_compare_rates
diff --git a/opensm/libopensm.map b/opensm/libopensm.map
index f88dd8f..5e8dae8 100644
--- a/opensm/libopensm.map
+++ b/opensm/libopensm.map
@@ -57,6 +57,7 @@ OPENSM_1.5 {
 		osm_get_lsa_str;
 		osm_get_sm_mgr_signal_str;
 		osm_get_sm_mgr_state_str;
+		ib_rate_is_valid;
 		ib_path_compare_rates;
 		ib_path_rate_get_prev;
 		ib_path_rate_get_next;
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index d9bab65..05becb5 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2362,6 +2362,13 @@ const char *osm_get_sm_mgr_state_str(IN uint16_t state)
 	    sm_mgr_state_str[ARR_SIZE(sm_mgr_state_str) - 1];
 }
 
+int ib_rate_is_valid(IN const int rate)
+{
+	if (rate < IB_MIN_RATE || rate > IB_MAX_RATE)
+		return 0;
+	return 1;
+}
+
 int ib_path_compare_rates(IN const int rate1, IN const int rate2)
 {
 	int orate1 = 0, orate2 = 0;
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
