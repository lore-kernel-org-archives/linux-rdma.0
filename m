From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm 3/8] acm.c: Invalid pkey has low order 15 bits 0
Date: Tue, 06 Aug 2013 07:45:22 -0400
Message-ID: <5200E1D2.2030407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


so add in handling for pkey 0x8000 as well as 0 for invalid

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index a15f094..7de5873 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -3211,7 +3211,7 @@ static void acm_port_up(struct acm_port *port)
 	atomic_set(&port->sa_dest.refcnt, 1);
 	for (i = 0; i < attr.pkey_tbl_len; i++) {
 		ret = ibv_query_pkey(port->dev->verbs, port->port_num, i, &pkey);
-		if (ret || !pkey)
+		if (ret || !(ntohs(pkey) & 0x7fff))
 			continue;
 		port->pkey_cnt++;
 		acm_ep_up(port, (uint16_t) i);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
