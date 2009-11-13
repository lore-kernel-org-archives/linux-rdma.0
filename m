From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC] opensm: compress IPV6 SNM groups to use a single MLID
Date: Fri, 13 Nov 2009 22:40:41 +0200
Message-ID: <20091113204041.GU7192@me>
References: <20091113061948.GJ7192@me>
 <20091113062104.GK7192@me>
 <20091113201144.GS7192@me>
 <20091113203856.GT7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091113203856.GT7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This is rework of previously used IPv6 SNM groups compression workaround
using newly proposed "many MGID to single MLID" mapping infrastructure.

Unlike previous solution where all IPv6 Solicited node multicast (SNM)
requests were collapsed into a single multicast group in OpenSM, now
each IPv6 SNM group is represented as a separate multicast group and
all groups sharing same P_Key and scope values use a same MLID value.

The compression method itself should be faster now because MLID sharing
criteria (matching IPv6 SNM MGID signature) is performed only once when
multicast group is created (and not each time when get MC group by MGID
lookup was performed).

This solution should be fully IBA complaint.

As before this feature is switched on by using 'consolidate_ipv6_snm_req'
command line or/and configuration option.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |   68 ++++++++++++++++++-------------
 1 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 27675b6..58c5736 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -114,6 +114,35 @@ static void free_mlid(IN osm_sa_t * sa, IN uint16_t mlid)
 /*********************************************************************
  Get a new unused mlid by scanning all the used ones in the subnet.
 **********************************************************************/
+/* Special Case IPv6 Solicited Node Multicast (SNM) addresses */
+/* 0xff1Z601bXXXX0000 : 0x00000001ffYYYYYY */
+/* Where Z is the scope, XXXX is the P_Key, and
+ * YYYYYY is the last 24 bits of the port guid */
+#define PREFIX_MASK CL_HTON64(0xff10ffff0000ffffULL)
+#define PREFIX_SIGNATURE CL_HTON64(0xff10601b00000000ULL)
+#define INT_ID_MASK CL_HTON64(0xfffffff1ff000000ULL)
+#define INT_ID_SIGNATURE CL_HTON64(0x00000001ff000000ULL)
+
+static int compare_ipv6_snm_mgids(const void *m1, const void *m2)
+{
+	return memcmp(m1, m2, sizeof(ib_gid_t) - 6);
+}
+
+static ib_net16_t find_ipv6_snm_mlid(osm_subn_t *subn, ib_gid_t *mgid)
+{
+	osm_mgrp_t *m = (osm_mgrp_t *)cl_fmap_match(&subn->mgrp_mgid_tbl, mgid,
+						    compare_ipv6_snm_mgids);
+	if (m != (osm_mgrp_t *)cl_fmap_end(&subn->mgrp_mgid_tbl))
+		return m->mlid;
+	return 0;
+}
+
+static unsigned match_ipv6_snm_mgid(ib_gid_t * mgid)
+{
+	return ((mgid->unicast.prefix & PREFIX_MASK) == PREFIX_SIGNATURE &&
+		(mgid->unicast.interface_id & INT_ID_MASK) == INT_ID_SIGNATURE);
+}
+
 static ib_net16_t get_new_mlid(osm_sa_t * sa, ib_member_rec_t * mcmr)
 {
 	osm_subn_t *p_subn = sa->p_subn;
@@ -125,6 +154,16 @@ static ib_net16_t get_new_mlid(osm_sa_t * sa, ib_member_rec_t * mcmr)
 	    && !osm_get_mbox_by_mlid(p_subn, requested_mlid))
 		return requested_mlid;
 
+	if (sa->p_subn->opt.consolidate_ipv6_snm_req
+	    && match_ipv6_snm_mgid(&mcmr->mgid)
+	    && (requested_mlid = find_ipv6_snm_mlid(sa->p_subn, &mcmr->mgid))) {
+		char str[INET6_ADDRSTRLEN];
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Special Case Solicited Node Mcast Join for MGID %s\n",
+			inet_ntop(AF_INET6, mcmr->mgid.raw, str, sizeof(str)));
+		return requested_mlid;
+	}
+
 	max = p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO + 1;
 	for (i = 0; i < max; i++)
 		if (!sa->p_subn->mboxes[i])
@@ -829,39 +868,10 @@ Exit:
 	return status;
 }
 
-#define PREFIX_MASK CL_HTON64(0xff10ffff0000ffffULL)
-#define PREFIX_SIGNATURE CL_HTON64(0xff10601b00000000ULL)
-#define INT_ID_MASK CL_HTON64(0xfffffff1ff000000ULL)
-#define INT_ID_SIGNATURE CL_HTON64(0x00000001ff000000ULL)
-
-/* Special Case IPv6 Solicited Node Multicast (SNM) addresses */
-/* 0xff1Z601bXXXX0000 : 0x00000001ffYYYYYY */
-/* Where Z is the scope, XXXX is the P_Key, and
- * YYYYYY is the last 24 bits of the port guid */
-static unsigned match_and_update_ipv6_snm_mgid(ib_gid_t * mgid)
-{
-	if ((mgid->unicast.prefix & PREFIX_MASK) == PREFIX_SIGNATURE &&
-	    (mgid->unicast.interface_id & INT_ID_MASK) == INT_ID_SIGNATURE) {
-		mgid->unicast.prefix &= PREFIX_MASK;
-		mgid->unicast.interface_id &= INT_ID_MASK;
-		return 1;
-	}
-	return 0;
-}
-
 osm_mgrp_t *osm_get_mgrp_by_mgid(IN osm_sa_t * sa, IN ib_gid_t * p_mgid)
 {
 	osm_mgrp_t *mg;
 
-	if (sa->p_subn->opt.consolidate_ipv6_snm_req &&
-	    match_and_update_ipv6_snm_mgid(p_mgid)) {
-		char gid_str[INET6_ADDRSTRLEN];
-		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-			"Special Case Solicited Node Mcast Join for MGID %s\n",
-			inet_ntop(AF_INET6, p_mgid->raw, gid_str,
-				  sizeof gid_str));
-	}
-
 	mg = (osm_mgrp_t *)cl_fmap_get(&sa->p_subn->mgrp_mgid_tbl, p_mgid);
 	if (mg != (osm_mgrp_t *)cl_fmap_end(&sa->p_subn->mgrp_mgid_tbl))
 		return mg;
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
