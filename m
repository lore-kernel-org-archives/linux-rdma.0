From: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm - remove useless goto
Date: Mon, 9 Nov 2009 15:07:29 -0800
Message-ID: <ADC0EAA392394ECAA20D606EF6BDEB04@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/opensm/osm_perfmgr.c b/opensm/opensm/osm_perfmgr.c
index 0999c48..accf9d3 100644
--- a/opensm/opensm/osm_perfmgr.c
+++ b/opensm/opensm/osm_perfmgr.c
@@ -279,7 +279,6 @@ ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * pm, ib_net64_t port_guid)
 		OSM_LOG(pm->log, OSM_LOG_ERROR,
 			"ERR 4C04: Vendor specific bind failed (%s)\n",
 			ib_get_err_str(status));
-		goto Exit;
 	}
 
 Exit:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
