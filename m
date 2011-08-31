From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags: Fix cap_mask extended link speed supported
 endian checks
Date: Wed, 31 Aug 2011 12:00:06 -0400
Message-ID: <4E5E5A86.3010404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Similar to previous patch for ibnetdiscover.c

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index e9dbaf9..701de42 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -182,7 +182,7 @@ static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
 	else
 		info = (uint8_t *)&port->info;
 	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 		espeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 	else
 		espeed = 0;
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 74960e1..fb2b594 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -620,8 +620,8 @@ void get_max_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * p
 	else
 		info = (uint8_t *)&port->remoteport->info;
 	rem_cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
-	    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS) &&
+	    rem_cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 		goto check_ext_speed;
 check_speed_supp:
 	max_speed = get_max(mad_get_field(port->info, 0,
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index bbdb51d..a17c7cf 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -127,7 +127,7 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	else
 		info = (uint8_t *)&port->info;
 	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 		espeed = mad_get_field(port->info, 0,
 				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 	else
diff --git a/src/ibportstate.c b/src/ibportstate.c
index f7ad37f..9c7d738 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -135,7 +135,7 @@ static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
 		IBERROR("smp query portinfo failed");
 	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	return (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+	return (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS));
 }
 
 static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 142214d..79625d4 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -183,7 +183,7 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 	else
 		info = (uint8_t *)&port->info;
 	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 		espeed = mad_get_field(port->info, 0,
 				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 	else
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
