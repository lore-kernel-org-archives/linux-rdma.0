From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_member_record.c: mlid independent MGID
 generator
Date: Fri, 13 Nov 2009 08:21:04 +0200
Message-ID: <20091113062104.GK7192@me>
References: <20091113061948.GJ7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091113061948.GJ7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


If we are going to do many MGID to single MLID compression we cannot use
MLID value for unique MGID generation.

Instead use static counter and also add querying for potentially existing
multicast group with same MGID value (with 1000 attempts limit).

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index f6a9ead..c6856fc 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -715,8 +715,10 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 static unsigned build_new_mgid(osm_sa_t * sa, ib_net64_t comp_mask,
 			       ib_member_rec_t * mcmr)
 {
+	static uint32_t uniq_count;
 	ib_gid_t *mgid = &mcmr->mgid;
 	uint8_t scope;
+	unsigned i;
 
 	/* use the given scope state only if requested! */
 	if (comp_mask & IB_MCR_COMPMASK_SCOPE)
@@ -733,11 +735,14 @@ static unsigned build_new_mgid(osm_sa_t * sa, ib_net64_t comp_mask,
 	/* HACK: use the SA port gid to make it globally unique */
 	memcpy(&mgid->raw[4], &sa->p_subn->opt.subnet_prefix, sizeof(uint64_t));
 
-	/* HACK: how do we get a unique number - use the mlid twice */
-	memcpy(&mgid->raw[10], &mcmr->mlid, sizeof(uint16_t));
-	memcpy(&mgid->raw[12], &mcmr->mlid, sizeof(uint16_t));
+	for (i = 0; i < 1000; i++) {
+		memcpy(&mgid->raw[10], &uniq_count, 4);
+		uniq_count++;
+		if (!osm_get_mgrp_by_mgid(sa, mgid))
+			return 1;
+	}
 
-	return 1;
+	return 0;
 }
 
 /**********************************************************************
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
