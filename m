From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.h: remove redundant function definition
Date: Mon, 01 Feb 2010 14:46:47 +0200
Message-ID: <4B66CD37.1040300@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

osm_get_physp_by_mad_addr() function is defined twice in
the same header file. Removing one of the definitions
and fixing compilation warning.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |   35 -----------------------------------
 1 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 65f687a..5312df1 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -1028,41 +1028,6 @@ static inline struct osm_mgrp_box *osm_get_mbox_by_mlid(osm_subn_t const *p_subn
 *	The multicast group structure pointer if found. NULL otherwise.
 *********/

-/****f* OpenSM: Helper/osm_get_physp_by_mad_addr
-* NAME
-*	osm_get_physp_by_mad_addr
-*
-* DESCRIPTION
-*	Looks for the requester physical port in the mad address.
-*
-* Note: This code is not thread safe. Need to grab the lock before
-* calling it.
-*
-* SYNOPSIS
-*/
-struct osm_physp *osm_get_physp_by_mad_addr(IN struct osm_log *p_log,
-					     IN const osm_subn_t * p_subn,
-					     IN struct osm_mad_addr
-					     *p_mad_addr);
-/*
-* PARAMETERS
-*	p_log
-*		[in] Pointer to a log object.
-*
-*	p_subn
-*		[in] Pointer to subnet object.
-*
-*	p_mad_addr
-*		[in] Pointer to mad address object.
-*
-* RETURN VALUES
-*	Pointer to requester physical port object if found. Null otherwise.
-*
-* NOTES
-*
-* SEE ALSO
-*********/
-
 /****f* OpenSM: Subnet/osm_subn_set_default_opt
 * NAME
 *	osm_subn_set_default_opt
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
