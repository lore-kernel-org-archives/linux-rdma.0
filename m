From: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/4] sim_ctl_get_portinfo:
Date: Sun, 21 Mar 2010 17:20:41 +0200
Message-ID: <4BA63949.90509@voltaire.com>
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

do not decrease port number.
for hca port number can  be 1 or 2 and
for switch its always 0.
node_get_port() already handles by type.

Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 ibsim/ibsim.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/ibsim/ibsim.c b/ibsim/ibsim.c
index e720f0d..9326d37 100644
--- a/ibsim/ibsim.c
+++ b/ibsim/ibsim.c
@@ -318,10 +318,8 @@ static int sim_ctl_get_portinfo(Client * cl, struct sim_ctl * ctl)
 	uint8_t port_num = ctl->data[0];
 	if (port_num == 0 || port_num > cl->port->node->numports)
 		p = cl->port;
-	else if (cl->port->node->type == SWITCH_NODE)
-		p = node_get_port(cl->port->node, port_num);
 	else
-		p = node_get_port(cl->port->node, port_num - 1);
+		p = node_get_port(cl->port->node, port_num);
 	update_portinfo(p);
 	memcpy(ctl->data, p->portinfo, sizeof(ctl->data));
 	return 0;
-- 
1.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
