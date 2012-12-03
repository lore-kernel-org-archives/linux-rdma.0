From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_req.c: In req_determine_mkey, add more info when
 ERR 1107 occurs
Date: Mon, 03 Dec 2012 10:25:04 -0500
Message-ID: <50BCC450.4080506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also dump DR path of SM class query

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_req.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 1c3c172..1f5db3f 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -106,6 +106,7 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 			"req_determine_mkey: ERR 1107: "
 			"Outgoing physp is null on non-hop_0!\n");
+		osm_dump_dr_path_v2(sm->p_log, p_path, FILE_ID, OSM_LOG_ERROR);
 		dest_port_guid = 0;
 		goto Remote_Guid;
 	}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
