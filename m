From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_slvl_map_rcv.c: fix mutex double release bug
Date: Tue, 29 Dec 2009 17:06:24 +0200
Message-ID: <20091229150624.GW26940@me>
References: <20091201194110.GA26753@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091201194110.GA26753-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In case when response was received for non-existing port (for example
when it was dropped after querying) OpenSM data structures access mutex
will be released twice. Fix this.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_slvl_map_rcv.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_slvl_map_rcv.c b/opensm/opensm/osm_slvl_map_rcv.c
index 3b24a8e..b35d867 100644
--- a/opensm/opensm/osm_slvl_map_rcv.c
+++ b/opensm/opensm/osm_slvl_map_rcv.c
@@ -91,7 +91,6 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
 
 	if (!p_port) {
-		cl_plock_release(sm->p_lock);
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2C06: "
 			"No port object for port with GUID 0x%" PRIx64
 			"\n\t\t\t\tfor parent node GUID 0x%" PRIx64
-- 
1.6.6.rc4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
