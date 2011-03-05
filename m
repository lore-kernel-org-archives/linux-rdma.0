From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/7] ibacm: Set SM LID address in network byte order
Date: Fri, 4 Mar 2011 16:02:35 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC92EAC2@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

acm_set_dest_addr expects LIDs to be in network order.
Convert the sm_lid retrieved from the port attributes into
network order.  This formats the LID value correctly
when entered into the ibacm log.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 10680f8..d52e83a 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2637,13 +2637,14 @@ static void acm_port_up(struct acm_port *port)
 	port->lid = attr.lid;
 	port->lid_mask = 0xffff - ((1 << attr.lmc) - 1);
 
-	acm_set_dest_addr(&port->sa_dest, ACM_ADDRESS_LID,
-		(uint8_t *) &attr.sm_lid, sizeof(attr.sm_lid));
 	port->sa_dest.av.src_path_bits = 0;
 	port->sa_dest.av.dlid = attr.sm_lid;
 	port->sa_dest.av.sl = attr.sm_sl;
 	port->sa_dest.av.port_num = port->port_num;
 	port->sa_dest.remote_qpn = 1;
+	attr.sm_lid = htons(attr.sm_lid);
+	acm_set_dest_addr(&port->sa_dest, ACM_ADDRESS_LID,
+		(uint8_t *) &attr.sm_lid, sizeof(attr.sm_lid));
 
 	port->sa_dest.ah = ibv_create_ah(port->dev->pd, &port->sa_dest.av);
 	if (!port->sa_dest.ah)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
