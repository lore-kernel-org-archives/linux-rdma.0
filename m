From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibsendtrap.c: Add support for security traps
Date: Wed, 23 Nov 2016 13:56:36 -0500
Message-ID: <f4eccf68-b9a6-ac29-1b88-5e040a774a77@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eitan Zahavi <eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eitan Zahavi <eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support for trap numbers 256, 257, and 258

Signed-off-by: Eitan Zahavi <eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
index 659f2d2..7044deb 100644
--- a/src/ibsendtrap.c
+++ b/src/ibsendtrap.c
@@ -121,6 +121,64 @@ static void build_trap129(ib_mad_notice_attr_t * n, ib_portid_t * port)
 	n->data_details.ntc_129_131.port_num = (uint8_t) error_port;
 }
 
+static void build_trap256_local(ib_mad_notice_attr_t * n, ib_portid_t * port)
+{
+	n->generic_type = 0x80 | IB_NOTICE_TYPE_SECURITY;
+	n->g_or_v.generic.prod_type_lsb = cl_hton16(get_node_type(port));
+	n->g_or_v.generic.trap_num = cl_hton16(256);
+	n->issuer_lid = cl_hton16((uint16_t) port->lid);
+	n->data_details.ntc_256.lid = n->issuer_lid;
+	n->data_details.ntc_256.dr_slid = 0xffff;
+	n->data_details.ntc_256.method = 1;
+	n->data_details.ntc_256.attr_id = cl_ntoh16(0x15);
+	n->data_details.ntc_256.attr_mod = cl_ntoh32(0x12);
+	n->data_details.ntc_256.mkey = cl_ntoh64(0x1234567812345678);
+}
+
+static void build_trap256_lid(ib_mad_notice_attr_t * n, ib_portid_t * port)
+{
+	build_trap256_local(n, port);
+	n->data_details.ntc_256.dr_trunc_hop = 0;
+}
+
+static void build_trap256_dr(ib_mad_notice_attr_t * n, ib_portid_t * port)
+{
+	build_trap256_local(n, port);
+	n->data_details.ntc_256.dr_trunc_hop = 0x80 | 0x4;
+	n->data_details.ntc_256.dr_rtn_path[0] = 5;
+	n->data_details.ntc_256.dr_rtn_path[1] = 6;
+	n->data_details.ntc_256.dr_rtn_path[2] = 7;
+	n->data_details.ntc_256.dr_rtn_path[3] = 8;
+}
+
+static void build_trap257_258(ib_mad_notice_attr_t * n, ib_portid_t * port,
+			      uint16_t trap_num)
+{
+	n->generic_type = 0x80 | IB_NOTICE_TYPE_SECURITY;
+	n->g_or_v.generic.prod_type_lsb = cl_hton16(get_node_type(port));
+	n->g_or_v.generic.trap_num = cl_hton16(trap_num);
+	n->issuer_lid = cl_hton16((uint16_t) port->lid);
+	n->data_details.ntc_257_258.lid1 = cl_hton16(1);
+	n->data_details.ntc_257_258.lid2 = cl_hton16(2);
+	n->data_details.ntc_257_258.key = cl_hton32(0x12345678);
+	n->data_details.ntc_257_258.qp1 = cl_hton32(0x010101);
+	n->data_details.ntc_257_258.qp2 = cl_hton32(0x020202);
+	n->data_details.ntc_257_258.gid1.unicast.prefix = cl_ntoh64(0xf8c0000000000001);
+	n->data_details.ntc_257_258.gid1.unicast.interface_id = cl_ntoh64(0x1111222233334444);
+	n->data_details.ntc_257_258.gid2.unicast.prefix = cl_ntoh64(0xf8c0000000000001);
+	n->data_details.ntc_257_258.gid2.unicast.interface_id = cl_ntoh64(0x5678567812341234);
+}
+
+static void build_trap257(ib_mad_notice_attr_t * n, ib_portid_t * port)
+{
+	build_trap257_258(n, port, 257);
+}
+
+static void build_trap258(ib_mad_notice_attr_t * n, ib_portid_t * port)
+{
+	build_trap257_258(n, port, 258);
+}
+
 static int send_trap(void (*build) (ib_mad_notice_attr_t *, ib_portid_t *))
 {
 	ib_portid_t sm_port;
@@ -159,6 +217,10 @@ static const trap_def_t traps[] = {
 	{"link_speed_enabled_change", build_trap144_linkspeed},
 	{"local_link_integrity", build_trap129},
 	{"sys_image_guid_change", build_trap145},
+	{"mkey_lid", build_trap256_lid},
+	{"mkey_dr", build_trap256_dr},
+	{"pkey", build_trap257},
+	{"qkey", build_trap258},
 	{NULL, NULL}
 };
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
