From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/4] opensm/osm_helper: Add ib_mtu_is_valid
Date: Tue, 04 Oct 2011 09:53:10 -0400
Message-ID: <4E8B0FC6.8010504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


for use in mtu validation by SA

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_helper.h |   24 ++++++++++++++++++++++++
 opensm/libopensm.map        |    1 +
 opensm/osm_helper.c         |    7 +++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/opensm/osm_helper.h b/include/opensm/osm_helper.h
index 7eb4e2a..57d1b00 100644
--- a/include/opensm/osm_helper.h
+++ b/include/opensm/osm_helper.h
@@ -588,6 +588,30 @@ const char *osm_get_sm_mgr_state_str(IN uint16_t state);
 * SEE ALSO
 *********/
 
+/****f* IBA Base: Types/ib_mtu_is_valid
+* NAME
+*	ib_mtu_is_valid
+*
+* DESCRIPTION
+*	Validates encoded MTU 
+*
+* SYNOPSIS
+*/
+int ib_mtu_is_valid(IN const int mtu);
+/*
+* PARAMETERS
+*	mtu
+*		[in] Encoded path mtu.
+*
+* RETURN VALUES
+*	Returns an int indicating mtu is valid (1)
+*	or invalid (0).
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* IBA Base: Types/ib_rate_is_valid
 * NAME
 *	ib_rate_is_valid
diff --git a/opensm/libopensm.map b/opensm/libopensm.map
index 5e8dae8..90c2857 100644
--- a/opensm/libopensm.map
+++ b/opensm/libopensm.map
@@ -57,6 +57,7 @@ OPENSM_1.5 {
 		osm_get_lsa_str;
 		osm_get_sm_mgr_signal_str;
 		osm_get_sm_mgr_state_str;
+		ib_mtu_is_valid;
 		ib_rate_is_valid;
 		ib_path_compare_rates;
 		ib_path_rate_get_prev;
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 05becb5..f9f3d9d 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2362,6 +2362,13 @@ const char *osm_get_sm_mgr_state_str(IN uint16_t state)
 	    sm_mgr_state_str[ARR_SIZE(sm_mgr_state_str) - 1];
 }
 
+int ib_mtu_is_valid(IN const int mtu)
+{
+	if (mtu < IB_MIN_MTU || mtu > IB_MAX_MTU)
+		return 0;
+	return 1;
+}
+
 int ib_rate_is_valid(IN const int rate)
 {
 	if (rate < IB_MIN_RATE || rate > IB_MAX_RATE)
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
