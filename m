From: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/4] sim_ctl_get_pkeys
Date: Sun, 21 Mar 2010 17:21:11 +0200
Message-ID: <4BA63967.2000004@voltaire.com>
References: <4BA6391A.7020608@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BA6391A.7020608-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

similar to sim_ctl_get_portinfo, return the correct
port's pkey tables according to the port number.

Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 ibsim/ibsim.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/ibsim/ibsim.c b/ibsim/ibsim.c
index 9326d37..3cb97e4 100644
--- a/ibsim/ibsim.c
+++ b/ibsim/ibsim.c
@@ -354,11 +354,18 @@ static int sim_ctl_set_issm(Client * cl, struct sim_ctl * ctl)
 
 static int sim_ctl_get_pkeys(Client * cl, struct sim_ctl * ctl)
 {
-	Port *port = cl->port;
-	unsigned size = (port->node->sw && port->portnum) ?
-	    mad_get_field(port->node->sw->switchinfo, 0,
-			  IB_SW_PARTITION_ENFORCE_CAP_F) :
-	    mad_get_field(port->node->nodeinfo, 0, IB_NODE_PARTITION_CAP_F);
+	Port *port;
+	uint8_t port_num = ctl->data[0];
+	unsigned size;
+
+	if (port_num == 0 || port_num > cl->port->node->numports)
+		port = cl->port;
+	else
+		port = node_get_port(cl->port->node, port_num);
+	size = (port->node->sw && port->portnum) ?
+			mad_get_field(port->node->sw->switchinfo, 0,
+					IB_SW_PARTITION_ENFORCE_CAP_F) :
+			mad_get_field(port->node->nodeinfo, 0, IB_NODE_PARTITION_CAP_F);
 
 	size *= sizeof(port->pkey_tbl[0]);
 	if (size > sizeof(ctl->data))
-- 
1.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
