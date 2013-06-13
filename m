From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] ibsim: Add support for fabric VL Cap in network
	definition file
Date: Thu, 13 Jun 2013 14:30:45 -0700
Message-ID: <1371159045.13124.182.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim.h     |    1 +
 ibsim/sim_mad.c |    2 ++
 ibsim/sim_net.c |   28 ++++++++++++++++++++++++++--
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/ibsim/sim.h b/ibsim/sim.h
index daeecec..831b4a5 100644
--- a/ibsim/sim.h
+++ b/ibsim/sim.h
@@ -289,6 +289,7 @@ struct Port {
 	int physstate;
 	int lmc;
 	int hoqlife;
+	int vlcap;
 	uint8_t portinfo[64];
 	uint8_t op_vls;
 
diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
index 0b52c52..a589d13 100644
--- a/ibsim/sim_mad.c
+++ b/ibsim/sim_mad.c
@@ -490,6 +490,8 @@ do_portinfo(Port * port, unsigned op, uint32_t portnum, uint8_t * data)
 		val = mad_get_field(data, 0, IB_PORT_OPER_VLS_F);
 		if (val > mad_get_field(data, 0, IB_PORT_VL_CAP_F))
 			return ERR_BAD_PARAM;
+		if (p->vlcap && val > p->vlcap)
+			return ERR_BAD_PARAM;
 		p->op_vls = val;
 	}
 
diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
index 10820ba..e8c07eb 100644
--- a/ibsim/sim_net.c
+++ b/ibsim/sim_net.c
@@ -413,6 +413,15 @@ static int is_linkspeed_valid(int speed)
 	return 1;
 }
 
+static int is_vlcap_valid(int vlcap)
+{
+	if (vlcap < 1 || vlcap > 5) {
+		IBWARN("bad vlcap %d - should be between 1 to 5", vlcap);
+		return 0;
+	}
+	return 1;
+}
+
 static int parse_switch_esp0(char *line)
 {
 	if (strstr(line, "enhanced port 0"))
@@ -462,6 +471,14 @@ static int parse_port_opt(Port * port, char *opt, char *val)
 		DEBUG("port %p linkspeed enabled set to %d", port,
 		      port->linkspeedena);
 		break;
+	case 'v':
+		v = strtoul(val, 0, 0);
+		if (!is_vlcap_valid(v))
+			return -1;
+
+		port->vlcap = v;
+		DEBUG("port %p vlcap set to %d", port, port->vlcap);
+		break;
 	default:
 		break;
 	}
@@ -1088,13 +1105,20 @@ void update_portinfo(Port * p)
 	mad_set_field(pi, 0, IB_PORT_HOQ_LIFE_F, p->hoqlife);
 	mad_set_field(pi, 0, IB_PORT_PHYS_STATE_F, p->physstate);
 	mad_set_field(pi, 0, IB_PORT_STATE_F, p->state);
+	if (p->vlcap)
+		mad_set_field(pi, 0, IB_PORT_VL_CAP_F, p->vlcap);
 }
 
 static void set_portinfo(Port * p, const uint8_t portinfo[])
 {
 	memcpy(p->portinfo, portinfo, sizeof(p->portinfo));
-	if (!p->op_vls)
-		p->op_vls = mad_get_field(p->portinfo, 0, IB_PORT_VL_CAP_F);
+	if (!p->op_vls) {
+		if (p->vlcap)
+			p->op_vls = p->vlcap;
+		else
+			p->op_vls = mad_get_field(p->portinfo, 0,
+						  IB_PORT_VL_CAP_F);
+	}
 }
 
 int link_ports(Port * lport, Port * rport)
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
