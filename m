From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_pkey.[h c]: Remove dead function osm_pkey_tbl_clear_accum_pkeys
Date: Wed, 11 Dec 2013 13:50:46 -0500
Message-ID: <52A8B406.1000805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_pkey.h |   23 -----------------------
 opensm/osm_pkey.c         |   15 ---------------
 2 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index 9459b5b..090a8be 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -340,29 +340,6 @@ osm_pkey_tbl_set_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
 *
 *********/
 
-/****f* OpenSM: osm_pkey_tbl_clear_accum_pkeys
-* NAME
-*  osm_pkey_tbl_clear_accum_pkeys
-*
-* DESCRIPTION
-*   Clears the given pkey in the "accum_pkeys" array
-*
-* SYNOPSIS
-*/
-void
-osm_pkey_tbl_clear_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
-			       IN uint16_t pkey);
-/*
-* p_pkey_tbl
-*   [in] Pointer to the PKey table
-*
-* pkey
-*   [in] PKey to clear
-*
-* NOTES
-*
-*********/
-
 /****f* OpenSM: osm_pkey_tbl_set_new_entry
 * NAME
 *  osm_pkey_tbl_set_new_entry
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index fe0a946..9e7e96f 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -235,21 +235,6 @@ void osm_pkey_find_last_accum_pkey_index(IN osm_pkey_tbl_t * p_pkey_tbl)
 }
 
 /*
-  Clears the given pkey (along with it's overall index) in the accum_pkeys array.
-*/
-void osm_pkey_tbl_clear_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
-				    IN uint16_t pkey)
-{
-	void *ptr;
-
-	ptr = cl_map_remove(&p_pkey_tbl->accum_pkeys, pkey);
-	if (ptr == NULL)
-		return;
-
-	osm_pkey_find_last_accum_pkey_index(p_pkey_tbl);
-}
-
-/*
   Store the given pkey in the "new" blocks array.
   Also, make sure the regular block exists.
 */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
