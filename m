From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_trap_rcv.c: fix crash in babbling port feature
Date: Mon, 24 Jun 2013 09:58:31 -0400
Message-ID: <51C85087.6020307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Port number should be less than number of ports (and never equal to).

Found-by: Moawya Wahdan <mwahdan-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 5682679..df222de 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -91,7 +91,7 @@ static osm_physp_t *get_physp_by_lid_and_num(IN osm_sm_t * sm,
 	if (!p_port)
 		return NULL;
 
-	if (osm_node_get_num_physp(p_port->p_node) < num)
+	if (osm_node_get_num_physp(p_port->p_node) <= num)
 		return NULL;
 
 	return osm_node_get_physp_ptr(p_port->p_node, num);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
