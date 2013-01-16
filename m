From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [TRIVIAL][PATCH] opensm: clean up error message, function name is
 printed by logging code
Date: Tue, 15 Jan 2013 17:40:09 -0800
Message-ID: <20130115174009.8d2dd3a6d00c9ad0307a797a@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_req.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 1c3c172..0b48a54 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -104,8 +104,7 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
 	*/
 	if (!p_physp) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
-			"req_determine_mkey: ERR 1107: "
-			"Outgoing physp is null on non-hop_0!\n");
+			"ERR 1107: Outgoing physp is null on non-hop_0!\n");
 		dest_port_guid = 0;
 		goto Remote_Guid;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
