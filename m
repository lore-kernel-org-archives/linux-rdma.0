From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed indentation and decreased verbosity of RMPP
 length message
Date: Mon, 28 Feb 2011 18:42:37 +0200
Message-ID: <20110228164237.GE8537@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="0001-opensm-fixed-indentation-and-decreased-verbosity-of-.patch"

>From e4525b15f7b8c721a2e8bde57db2891c004a18b7 Mon Sep 17 00:00:00 2001
From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date: Mon, 28 Feb 2011 18:27:08 +0200
Subject: [PATCH] opensm: fixed indentation and decreased verbosity of RMPP length message

Decreased log verbosity of RMPP X length X message to DEBUG.
This message is printed for all RMPP GS classes messages, so the indentation
was needed.

Signed-off-by: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index eac686a..2373803 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -1041,10 +1041,10 @@ osm_vendor_send(IN osm_bind_handle_t h_bind,
 #ifdef VENDOR_RMPP_SUPPORT
 		} else
 			is_rmpp = 1;
-			OSM_LOG(p_vend->p_log, OSM_LOG_VERBOSE, "RMPP %d length %d\n",
-				ib_rmpp_is_flag_set((ib_rmpp_mad_t *) p_sa,
-						    IB_RMPP_FLAG_ACTIVE),
-				p_madw->mad_size);
+		OSM_LOG(p_vend->p_log, OSM_LOG_DEBUG, "RMPP %d length %d\n",
+			ib_rmpp_is_flag_set((ib_rmpp_mad_t *) p_sa,
+					    IB_RMPP_FLAG_ACTIVE),
+			p_madw->mad_size);
 #else
 		} else {
 			p_sa->rmpp_version = 1;
-- 
1.7.3.4


--VS++wcV0S1rZb1Fb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
