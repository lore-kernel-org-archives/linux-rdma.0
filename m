From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm: Always set enabled speed and width
Date: Sun, 25 Apr 2010 14:04:07 +0300
Message-ID: <4BD421A7.7040009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Erez Cohen <erezc-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Initialize default link speed and width to "No State Change" and
always set in SubnSet(PortInfo)

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/ibportstate.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/infiniband-diags/src/ibportstate.c b/infiniband-diags/src/ibportstate.c
index 66f069e..b99c0e1 100644
--- a/infiniband-diags/src/ibportstate.c
+++ b/infiniband-diags/src/ibportstate.c
@@ -64,13 +64,13 @@ enum port_ops {
 };
 
 struct ibmad_port *srcport;
-int speed = 15;
-int width = 255;
+int speed = 0; /* no state change */
+int width = 0; /* no state change */
 int lid;
 int smlid;
 int lmc;
 int mtu;
-int vls;
+int vls = 0; /* no state change */
 
 struct {
 	const char *name;
@@ -394,12 +394,11 @@ int main(int argc, char **argv)
 			mad_set_field(data, 0, IB_PORT_STATE_F, 4);
 			break;
 		}
-		if (port_args[SPEED].set)
-			mad_set_field(data, 0, IB_PORT_LINK_SPEED_ENABLED_F,
-				      speed);
-		if (port_args[WIDTH].set)
-			mad_set_field(data, 0, IB_PORT_LINK_WIDTH_ENABLED_F,
-				      width);
+
+		/* always set enabled speed/width - defaults to NOP */
+		mad_set_field(data, 0, IB_PORT_LINK_SPEED_ENABLED_F, speed);
+		mad_set_field(data, 0, IB_PORT_LINK_WIDTH_ENABLED_F, width);
+
 		if (port_args[VLS].set)
 			mad_set_field(data, 0, IB_PORT_OPER_VLS_F, vls);
 		if (port_args[MTU].set)
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
