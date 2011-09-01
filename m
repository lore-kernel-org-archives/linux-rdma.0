From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2] infiniband-diags: Fix cap_mask extended link speed supported
 endian checks
Date: Wed, 31 Aug 2011 21:47:39 -0400
Message-ID: <4E5EE43B.9030805@dev.mellanox.co.il>
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
Changes since v1:
Rebased to latest master
Also, found one additional place in libibnetdisc/src/ibnetdisc.c

diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 60bd28d..86210eb 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -184,7 +184,7 @@ static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
 	else
 		info = (uint8_t *)&port->info;
 	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 		espeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 	else
 		espeed = 0;
@@ -368,7 +368,7 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		else
 			info = (uint8_t *)&port->info;
 		cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-		if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+		if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 			espeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 		else
 			espeed = 0;
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index e6587af..049b72b 100644
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
 check_fdr10_supp:
 	fdr10 = (mad_get_field(port->ext_info, 0,
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 673ed95..04e2376 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -128,7 +128,7 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	else
 		info = (uint8_t *)&port->info;
 	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
 		espeed = mad_get_field(port->info, 0,
 				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 	else
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 9077413..81d5b58 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -147,7 +147,7 @@ static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
 		IBERROR("smp query portinfo failed");
 	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
-	return (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+	return (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS));
 }
 
 static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index f225d3b..8e0b336 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -186,7 +186,7 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
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
