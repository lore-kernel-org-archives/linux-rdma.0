From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibsendtrap.c: Add support for
	SysImageGuid changed trap (145)
Date: Fri, 6 Nov 2009 10:59:00 -0500
Message-ID: <20091106155900.GA19950@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/src/ibsendtrap.c b/infiniband-diags/src/ibsendtrap.c
index 2bbc0f9..1b91595 100644
--- a/infiniband-diags/src/ibsendtrap.c
+++ b/infiniband-diags/src/ibsendtrap.c
@@ -73,6 +73,15 @@ static uint32_t get_cap_mask(ib_portid_t * port)
 	return cap_mask;
 }
 
+static void build_trap145(ib_mad_notice_attr_t * n, ib_portid_t * port)
+{
+	n->generic_type = 0x80 | IB_NOTICE_TYPE_INFO;
+	n->g_or_v.generic.prod_type_lsb = cl_hton16(get_node_type(port));
+	n->g_or_v.generic.trap_num = cl_hton16(145);
+	n->issuer_lid = cl_hton16((uint16_t) port->lid);
+	n->data_details.ntc_145.new_sys_guid = cl_hton64(0x1234567812345678);
+}
+
 static void build_trap144_local(ib_mad_notice_attr_t * n, ib_portid_t * port)
 {
 	n->generic_type = 0x80 | IB_NOTICE_TYPE_INFO;
@@ -149,6 +158,7 @@ static const trap_def_t traps[] = {
 	{"node_desc_change", build_trap144_nodedesc},
 	{"link_speed_enabled_change", build_trap144_linkspeed},
 	{"local_link_integrity", build_trap129},
+	{"sys_image_guid_change", build_trap145},
 	{NULL, NULL}
 };
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
