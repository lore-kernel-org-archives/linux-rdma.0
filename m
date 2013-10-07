From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH OpenSM] osmtest: Handle other than default subnet prefix
Date: Mon, 07 Oct 2013 16:35:46 -0400
Message-ID: <52531B22.5070001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 24bad76..86fa07b 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -213,6 +213,7 @@ BEGIN_C_DECLS
 * SOURCE
 */
 #define IB_DEFAULT_SUBNET_PREFIX			(CL_HTON64(0xFE80000000000000ULL))
+#define IB_DEFAULT_SUBNET_PREFIX_HO			(0xFE80000000000000ULL)
 /**********/
 /****d* IBA Base: Constants/IB_NODE_NUM_PORTS_MAX
 * NAME
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index ee14f5b..5f8d207 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -656,6 +656,11 @@ osm_vendor_get_all_port_attr(IN osm_vendor_t * const p_vend,
 							cl_hton16(ca.ports[j]->pkeys[k]);
 				}
 				attr->num_pkeys = ca.ports[j]->pkeys_size;
+				if (attr->num_gids && attr->p_gid_table) {
+					attr->p_gid_table[0].unicast.prefix = cl_hton64(ca.ports[j]->gid_prefix);
+					attr->p_gid_table[0].unicast.interface_id = cl_hton64(ca.ports[j]->port_guid);
+					attr->num_gids = 1;
+				}
 				attr++;
 				if (attr - p_attr_array > *p_num_ports) {
 					done = 1;
diff --git a/opensm/main.c b/opensm/main.c
index 3f10e4f..d3a3730 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -435,6 +435,8 @@ static ib_net64_t get_port_guid(IN osm_opensm_t * p_osm, uint64_t port_guid)
 	for (i = 0; i < num_ports; i++) {
 		attr_array[i].num_pkeys = 0;
 		attr_array[i].p_pkey_table = NULL;
+		attr_array[i].num_gids = 0;
+		attr_array[i].p_gid_table = NULL;
 	}
 
 	/* Call the transport layer for a list of local port GUID values */
diff --git a/osmtest/include/osmtest.h b/osmtest/include/osmtest.h
index 4a7f0a3..f63ea74 100644
--- a/osmtest/include/osmtest.h
+++ b/osmtest/include/osmtest.h
@@ -128,6 +128,7 @@ typedef struct _osmtest {
 
 	osmtest_opt_t opt;
 	ib_port_attr_t local_port;
+	ib_gid_t local_port_gid;
 	subnet_t exp_subn;
 	cl_qpool_t node_pool;
 	cl_qpool_t port_pool;
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index ac8d1b2..93b04a2 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -378,7 +378,7 @@ void osmt_init_mc_query_rec(IN osmtest_t * const p_osmt,
 	       sizeof(p_osmt->local_port.port_guid));
 
 	/*  use our own subnet prefix: */
-	p_mc_req->port_gid.unicast.prefix = CL_HTON64(0xFE80000000000000ULL);
+	p_mc_req->port_gid.unicast.prefix = cl_hton64(p_osmt->local_port_gid.unicast.prefix);
 
 	/*  ib_net32_t  qkey; */
 	/*  ib_net16_t  mlid; - we keep it zero for upper level to decide. */
diff --git a/osmtest/osmt_service.c b/osmtest/osmt_service.c
index a37c946..961c904 100644
--- a/osmtest/osmt_service.c
+++ b/osmtest/osmt_service.c
@@ -85,7 +85,7 @@ osmt_register_service(IN osmtest_t * const p_osmt,
 	/* set the new service record fields */
 	svc_rec.service_id = service_id;
 	svc_rec.service_pkey = service_pkey;
-	svc_rec.service_gid.unicast.prefix = 0;
+	svc_rec.service_gid.unicast.prefix = p_osmt->local_port_gid.unicast.prefix;
 	svc_rec.service_gid.unicast.interface_id = p_osmt->local_port.port_guid;
 	svc_rec.service_lease = service_lease;
 	memset(&svc_rec.service_key, 0, 16 * sizeof(uint8_t));
@@ -188,7 +188,7 @@ osmt_register_service_with_full_key(IN osmtest_t * const p_osmt,
 	/* set the new service record fields */
 	svc_rec.service_id = service_id;
 	svc_rec.service_pkey = service_pkey;
-	svc_rec.service_gid.unicast.prefix = 0;
+	svc_rec.service_gid.unicast.prefix = p_osmt->local_port_gid.unicast.prefix;
 	svc_rec.service_gid.unicast.interface_id = p_osmt->local_port.port_guid;
 	svc_rec.service_lease = service_lease;
 	memset(&svc_rec.service_key, 0, 16 * sizeof(uint8_t));
@@ -312,7 +312,7 @@ osmt_register_service_with_data(IN osmtest_t * const p_osmt,
 	/* set the new service record fields */
 	svc_rec.service_id = service_id;
 	svc_rec.service_pkey = service_pkey;
-	svc_rec.service_gid.unicast.prefix = 0;
+	svc_rec.service_gid.unicast.prefix = p_osmt->local_port_gid.unicast.prefix;
 	svc_rec.service_gid.unicast.interface_id = p_osmt->local_port.port_guid;
 	svc_rec.service_lease = service_lease;
 	memset(&svc_rec.service_key, 0, 16 * sizeof(uint8_t));
diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index c3d4a4f..11baa98 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -7206,9 +7206,16 @@ osmtest_bind(IN osmtest_t * p_osmt,
 	ib_api_status_t status;
 	uint32_t num_ports = MAX_LOCAL_IBPORTS;
 	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS] = { {0} };
+	ib_gid_t gid[MAX_LOCAL_IBPORTS];
+	int i;
 
 	OSM_LOG_ENTER(&p_osmt->log);
 
+	for (i = 0; i < MAX_LOCAL_IBPORTS; i++) {
+		attr_array[i].num_gids = 1;
+		attr_array[i].p_gid_table = &gid[i];
+	}
+
 	/*
 	 * Call the transport layer for a list of local port
 	 * GUID values.
@@ -7255,7 +7262,17 @@ osmtest_bind(IN osmtest_t * p_osmt,
 	 * Copy the port info for the selected port.
 	 */
 	memcpy(&p_osmt->local_port, &attr_array[port_index],
-	       sizeof(p_osmt->local_port));
+	       sizeof(p_osmt->local_port) - sizeof(p_osmt->local_port.p_gid_table));
+	if (p_osmt->local_port.num_gids) {
+		p_osmt->local_port_gid.unicast.prefix = p_osmt->local_port.p_gid_table[0].unicast.prefix;
+		p_osmt->local_port_gid.unicast.interface_id = p_osmt->local_port.p_gid_table[0].unicast.interface_id;
+	} else {
+		p_osmt->local_port_gid.unicast.prefix = IB_DEFAULT_SUBNET_PREFIX_HO;
+		p_osmt->local_port_gid.unicast.interface_id = attr_array[port_index].port_guid;
+		p_osmt->local_port.p_gid_table = NULL;
+	}
+	p_osmt->local_port.num_gids = 1;
+	p_osmt->local_port.p_gid_table = &p_osmt->local_port_gid;
 
 	/* bind to the SA */
 	OSM_LOG(&p_osmt->log, OSM_LOG_DEBUG,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
