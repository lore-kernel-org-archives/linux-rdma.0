From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] libibmad: remove deprecated functions
Date: Thu, 21 Mar 2013 19:28:25 -0400
Message-ID: <514b9799.+OBz8chN88GduFxO%ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/mad.h |   46 ---------------------------------------
 libibmad.ver             |    2 +-
 src/libibmad.map         |   19 ----------------
 src/register.c           |   19 ----------------
 src/resolve.c            |   16 -------------
 src/rpc.c                |   54 ----------------------------------------------
 src/sa.c                 |   12 ----------
 src/serv.c               |   16 -------------
 src/smp.c                |   12 ----------
 src/vendor.c             |    6 -----
 10 files changed, 1 insertions(+), 201 deletions(-)

diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index cefcc54..9806582 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -1433,10 +1433,6 @@ MAD_EXPORT int mad_get_retries(const struct ibmad_port *srcport);
 /* register.c */
 MAD_EXPORT int mad_register_port_client(int port_id, int mgmt,
 					uint8_t rmpp_version);
-MAD_EXPORT int mad_register_client(int mgmt, uint8_t rmpp_version) DEPRECATED;
-MAD_EXPORT int mad_register_server(int mgmt, uint8_t rmpp_version,
-				   long method_mask[16 / sizeof(long)],
-				   uint32_t class_oui) DEPRECATED;
 /* register.c new interface */
 MAD_EXPORT int mad_register_client_via(int mgmt, uint8_t rmpp_version,
 				       struct ibmad_port *srcport);
@@ -1444,14 +1440,6 @@ MAD_EXPORT int mad_register_server_via(int mgmt, uint8_t rmpp_version,
 				       long method_mask[16 / sizeof(long)],
 				       uint32_t class_oui,
 				       struct ibmad_port *srcport);
-MAD_EXPORT int mad_class_agent(int mgmt) DEPRECATED;
-
-/* serv.c */
-MAD_EXPORT int mad_send(ib_rpc_t * rpc, ib_portid_t * dport,
-			ib_rmpp_hdr_t * rmpp, void *data) DEPRECATED;
-MAD_EXPORT void *mad_receive(void *umad, int timeout) DEPRECATED;
-MAD_EXPORT int mad_respond(void *umad, ib_portid_t * portid, uint32_t rstatus)
-    DEPRECATED;
 
 /* serv.c new interface */
 MAD_EXPORT int mad_send_via(ib_rpc_t * rpc, ib_portid_t * dport,
@@ -1464,10 +1452,6 @@ MAD_EXPORT int mad_respond_via(void *umad, ib_portid_t * portid,
 MAD_EXPORT void *mad_alloc(void);
 MAD_EXPORT void mad_free(void *umad);
 
-/* vendor.c */
-MAD_EXPORT uint8_t *ib_vendor_call(void *data, ib_portid_t * portid,
-				   ib_vendor_call_t * call) DEPRECATED;
-
 /* vendor.c new interface */
 MAD_EXPORT uint8_t *ib_vendor_call_via(void *data, ib_portid_t * portid,
 				       ib_vendor_call_t * call,
@@ -1483,22 +1467,6 @@ static inline int mad_is_vendor_range2(int mgmt)
 	return mgmt >= 0x30 && mgmt <= 0x4f;
 }
 
-/* rpc.c */
-MAD_EXPORT int madrpc_portid(void) DEPRECATED;
-void *madrpc(ib_rpc_t * rpc, ib_portid_t * dport, void *payload, void *rcvdata)
-    DEPRECATED;
-void *madrpc_rmpp(ib_rpc_t * rpc, ib_portid_t * dport, ib_rmpp_hdr_t * rmpp,
-		  void *data) DEPRECATED;
-MAD_EXPORT void madrpc_init(char *dev_name, int dev_port, int *mgmt_classes,
-			    int num_classes) DEPRECATED;
-void madrpc_save_mad(void *madbuf, int len) DEPRECATED;
-
-/* smp.c */
-MAD_EXPORT uint8_t *smp_query(void *buf, ib_portid_t * id, unsigned attrid,
-			      unsigned mod, unsigned timeout) DEPRECATED;
-MAD_EXPORT uint8_t *smp_set(void *buf, ib_portid_t * id, unsigned attrid,
-			    unsigned mod, unsigned timeout) DEPRECATED;
-
 /* smp.c new interface */
 MAD_EXPORT uint8_t *smp_query_via(void *buf, ib_portid_t * id, unsigned attrid,
 				  unsigned mod, unsigned timeout,
@@ -1528,12 +1496,6 @@ MAD_EXPORT void *cc_config_status_via(void *payload, void *rcvbuf, ib_portid_t *
 				      int *rstatus, const struct ibmad_port * srcport,
 				      uint64_t cckey);
 
-/* sa.c */
-uint8_t *sa_call(void *rcvbuf, ib_portid_t * portid, ib_sa_call_t * sa,
-		 unsigned timeout) DEPRECATED;
-MAD_EXPORT int ib_path_query(ibmad_gid_t srcgid, ibmad_gid_t destgid,
-			     ib_portid_t * sm_id, void *buf) DEPRECATED;
-
 /* sa.c new interface */
 MAD_EXPORT uint8_t *sa_rpc_call(const struct ibmad_port *srcport, void *rcvbuf,
 				ib_portid_t * portid, ib_sa_call_t * sa,
@@ -1546,14 +1508,6 @@ MAD_EXPORT int ib_node_query_via(const struct ibmad_port *srcport,
 				 uint64_t guid, ib_portid_t * sm_id,
 				 void *buf);
 
-/* resolve.c */
-MAD_EXPORT int ib_resolve_smlid(ib_portid_t * sm_id, int timeout) DEPRECATED;
-MAD_EXPORT int ib_resolve_portid_str(ib_portid_t * portid, char *addr_str,
-				     enum MAD_DEST dest, ib_portid_t * sm_id)
-    DEPRECATED;
-MAD_EXPORT int ib_resolve_self(ib_portid_t * portid, int *portnum,
-			       ibmad_gid_t * gid) DEPRECATED;
-
 /* resolve.c new interface */
 MAD_EXPORT int ib_resolve_smlid_via(ib_portid_t * sm_id, int timeout,
 				    const struct ibmad_port *srcport);
diff --git a/libibmad.ver b/libibmad.ver
index 11698ff..e560787 100644
--- a/libibmad.ver
+++ b/libibmad.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=9:0:4
+LIBVERSION=9:0:0
diff --git a/src/libibmad.map b/src/libibmad.map
index 3f3aeef..75f689c 100644
--- a/src/libibmad.map
+++ b/src/libibmad.map
@@ -89,14 +89,8 @@ IBMAD_1.3 {
 		portid2str;
 		str2drpath;
 		drpath2str;
-		mad_class_agent;
-		mad_register_client;
-		mad_register_server;
 		mad_register_client_via;
 		mad_register_server_via;
-		ib_resolve_portid_str;
-		ib_resolve_self;
-		ib_resolve_smlid;
 		ibdebug;
 		mad_rpc_open_port;
 		mad_rpc_close_port;
@@ -108,29 +102,16 @@ IBMAD_1.3 {
 		mad_rpc_set_timeout;
 		mad_get_timeout;
 		mad_get_retries;
-		madrpc;
 		madrpc_def_timeout;
-		madrpc_init;
-		madrpc_portid;
-		madrpc_rmpp;
-		madrpc_save_mad;
 		madrpc_set_retries;
 		madrpc_set_timeout;
 		madrpc_show_errors;
-		ib_path_query;
-		sa_call;
 		sa_rpc_call;
 		mad_alloc;
 		mad_free;
-		mad_receive;
-		mad_respond;
 		mad_receive_via;
 		mad_respond_via;
-		mad_send;
 		mad_send_via;
-		smp_query;
-		smp_set;
-		ib_vendor_call;
 		ib_vendor_call_via;
 		smp_query_via;
 		smp_query_status_via;
diff --git a/src/register.c b/src/register.c
index 1fdb64a..8bb59db 100644
--- a/src/register.c
+++ b/src/register.c
@@ -75,13 +75,6 @@ static int mgmt_class_vers(int mgmt_class)
 	return 0;
 }
 
-int mad_class_agent(int mgmt)
-{
-	if (mgmt < 1 || mgmt >= MAX_CLASS)
-		return -1;
-	return ibmp->class_agents[mgmt];
-}
-
 int mad_register_port_client(int port_id, int mgmt, uint8_t rmpp_version)
 {
 	int vers, agent;
@@ -98,11 +91,6 @@ int mad_register_port_client(int port_id, int mgmt, uint8_t rmpp_version)
 	return agent;
 }
 
-int mad_register_client(int mgmt, uint8_t rmpp_version)
-{
-	return mad_register_client_via(mgmt, rmpp_version, ibmp);
-}
-
 int mad_register_client_via(int mgmt, uint8_t rmpp_version,
 			    struct ibmad_port *srcport)
 {
@@ -120,13 +108,6 @@ int mad_register_client_via(int mgmt, uint8_t rmpp_version,
 	return 0;
 }
 
-int mad_register_server(int mgmt, uint8_t rmpp_version,
-			long method_mask[], uint32_t class_oui)
-{
-	return mad_register_server_via(mgmt, rmpp_version, method_mask,
-				       class_oui, ibmp);
-}
-
 int mad_register_server_via(int mgmt, uint8_t rmpp_version,
 			    long method_mask[], uint32_t class_oui,
 			    struct ibmad_port *srcport)
diff --git a/src/resolve.c b/src/resolve.c
index f866bf4..9cb96fe 100644
--- a/src/resolve.c
+++ b/src/resolve.c
@@ -66,11 +66,6 @@ int ib_resolve_smlid_via(ib_portid_t * sm_id, int timeout,
 	return ib_portid_set(sm_id, lid, 0, 0);
 }
 
-int ib_resolve_smlid(ib_portid_t * sm_id, int timeout)
-{
-	return ib_resolve_smlid_via(sm_id, timeout, ibmp);
-}
-
 int ib_resolve_gid_via(ib_portid_t * portid, ibmad_gid_t gid,
 		       ib_portid_t * sm_id, int timeout,
 		       const struct ibmad_port *srcport)
@@ -187,13 +182,6 @@ int ib_resolve_portid_str_via(ib_portid_t * portid, char *addr_str,
 	return -1;
 }
 
-int ib_resolve_portid_str(ib_portid_t * portid, char *addr_str,
-			  enum MAD_DEST dest_type, ib_portid_t * sm_id)
-{
-	return ib_resolve_portid_str_via(portid, addr_str, dest_type,
-					 sm_id, ibmp);
-}
-
 int ib_resolve_self_via(ib_portid_t * portid, int *portnum, ibmad_gid_t * gid,
 			const struct ibmad_port *srcport)
 {
@@ -222,7 +210,3 @@ int ib_resolve_self_via(ib_portid_t * portid, int *portnum, ibmad_gid_t * gid,
 	return 0;
 }
 
-int ib_resolve_self(ib_portid_t * portid, int *portnum, ibmad_gid_t * gid)
-{
-	return ib_resolve_self_via(portid, portnum, gid, ibmp);
-}
diff --git a/src/rpc.c b/src/rpc.c
index 5cb13f1..9deaaf9 100644
--- a/src/rpc.c
+++ b/src/rpc.c
@@ -49,9 +49,6 @@
 
 int ibdebug;
 
-static struct ibmad_port mad_port;
-struct ibmad_port *ibmp = &mad_port;
-
 static int iberrs;
 
 int madrpc_retries = MAD_DEF_RETRIES;
@@ -74,12 +71,6 @@ void madrpc_show_errors(int set)
 	iberrs = set;
 }
 
-void madrpc_save_mad(void *madbuf, int len)
-{
-	save_mad = madbuf;
-	save_mad_len = len;
-}
-
 int madrpc_set_retries(int retries)
 {
 	if (retries > 0)
@@ -108,11 +99,6 @@ int madrpc_def_timeout(void)
 	return madrpc_timeout;
 }
 
-int madrpc_portid(void)
-{
-	return ibmp->port_id;
-}
-
 int mad_rpc_portid(struct ibmad_port *srcport)
 {
 	return srcport->port_id;
@@ -340,46 +326,6 @@ void *mad_rpc_rmpp(const struct ibmad_port *port, ib_rpc_t * rpc,
 	return data;
 }
 
-void *madrpc(ib_rpc_t * rpc, ib_portid_t * dport, void *payload, void *rcvdata)
-{
-	return mad_rpc(ibmp, rpc, dport, payload, rcvdata);
-}
-
-void *madrpc_rmpp(ib_rpc_t * rpc, ib_portid_t * dport, ib_rmpp_hdr_t * rmpp,
-		  void *data)
-{
-	return mad_rpc_rmpp(ibmp, rpc, dport, rmpp, data);
-}
-
-void
-madrpc_init(char *dev_name, int dev_port, int *mgmt_classes, int num_classes)
-{
-	int fd;
-
-	if (umad_init() < 0)
-		IBPANIC("can't init UMAD library");
-
-	if ((fd = umad_open_port(dev_name, dev_port)) < 0)
-		IBPANIC("can't open UMAD port (%s:%d)",
-		dev_name ? dev_name : "(nil)", dev_port);
-
-	if (num_classes >= MAX_CLASS)
-		IBPANIC("too many classes %d requested", num_classes);
-
-	ibmp->port_id = fd;
-	memset(ibmp->class_agents, 0xff, sizeof ibmp->class_agents);
-	while (num_classes--) {
-		uint8_t rmpp_version = 0;
-		int mgmt = *mgmt_classes++;
-
-		if (mgmt == IB_SA_CLASS)
-			rmpp_version = 1;
-		if (mad_register_client_via(mgmt, rmpp_version, ibmp) < 0)
-			IBPANIC("client_register for mgmt class %d failed",
-				mgmt);
-	}
-}
-
 struct ibmad_port *mad_rpc_open_port(char *dev_name, int dev_port,
 				     int *mgmt_classes, int num_classes)
 {
diff --git a/src/sa.c b/src/sa.c
index 352ed9f..c7b79dd 100644
--- a/src/sa.c
+++ b/src/sa.c
@@ -80,12 +80,6 @@ uint8_t *sa_rpc_call(const struct ibmad_port *ibmad_port, void *rcvbuf,
 	return p;
 }
 
-uint8_t *sa_call(void *rcvbuf, ib_portid_t * portid, ib_sa_call_t * sa,
-		 unsigned timeout)
-{
-	return sa_rpc_call(ibmp, rcvbuf, portid, sa, timeout);
-}
-
 /* PathRecord */
 #define IB_PR_COMPMASK_DGID				(1ull<<2)
 #define IB_PR_COMPMASK_SGID				(1ull<<3)
@@ -140,12 +134,6 @@ int ib_path_query_via(const struct ibmad_port *srcport, ibmad_gid_t srcgid,
 	return dlid;
 }
 
-int ib_path_query(ibmad_gid_t srcgid, ibmad_gid_t destgid, ib_portid_t * sm_id,
-		  void *buf)
-{
-	return ib_path_query_via(ibmp, srcgid, destgid, sm_id, buf);
-}
-
 /* NodeRecord */
 #define IB_NR_COMPMASK_LID				(1ull<<0)
 #define IB_NR_COMPMASK_RESERVED1			(1ull<<1)
diff --git a/src/serv.c b/src/serv.c
index ae5fd6c..741cb93 100644
--- a/src/serv.c
+++ b/src/serv.c
@@ -48,12 +48,6 @@
 #undef DEBUG
 #define DEBUG	if (ibdebug)	IBWARN
 
-int mad_send(ib_rpc_t * rpc, ib_portid_t * dport, ib_rmpp_hdr_t * rmpp,
-	     void *data)
-{
-	return mad_send_via(rpc, dport, rmpp, data, ibmp);
-}
-
 int mad_send_via(ib_rpc_t * rpc, ib_portid_t * dport, ib_rmpp_hdr_t * rmpp,
 		 void *data, struct ibmad_port *srcport)
 {
@@ -83,11 +77,6 @@ int mad_send_via(ib_rpc_t * rpc, ib_portid_t * dport, ib_rmpp_hdr_t * rmpp,
 	return 0;
 }
 
-int mad_respond(void *umad, ib_portid_t * portid, uint32_t rstatus)
-{
-	return mad_respond_via(umad, portid, rstatus, ibmp);
-}
-
 int mad_respond_via(void *umad, ib_portid_t * portid, uint32_t rstatus,
 		    struct ibmad_port *srcport)
 {
@@ -165,11 +154,6 @@ int mad_respond_via(void *umad, ib_portid_t * portid, uint32_t rstatus,
 	return 0;
 }
 
-void *mad_receive(void *umad, int timeout)
-{
-	return mad_receive_via(umad, timeout, ibmp);
-}
-
 void *mad_receive_via(void *umad, int timeout, struct ibmad_port *srcport)
 {
 	void *mad = umad ? umad : umad_alloc(1, umad_size() + IB_MAD_SIZE);
diff --git a/src/smp.c b/src/smp.c
index 14c74ed..bb91dd1 100644
--- a/src/smp.c
+++ b/src/smp.c
@@ -96,12 +96,6 @@ uint8_t *smp_set_via(void *data, ib_portid_t * portid, unsigned attrid,
 				  srcport);
 }
 
-uint8_t *smp_set(void *data, ib_portid_t * portid, unsigned attrid,
-		 unsigned mod, unsigned timeout)
-{
-	return smp_set_via(data, portid, attrid, mod, timeout, ibmp);
-}
-
 uint8_t *smp_query_status_via(void *rcvbuf, ib_portid_t * portid,
 			      unsigned attrid, unsigned mod, unsigned timeout,
 			      int *rstatus, const struct ibmad_port * srcport)
@@ -141,9 +135,3 @@ uint8_t *smp_query_via(void *rcvbuf, ib_portid_t * portid, unsigned attrid,
 	return smp_query_status_via(rcvbuf, portid, attrid, mod, timeout, NULL,
 				    srcport);
 }
-
-uint8_t *smp_query(void *rcvbuf, ib_portid_t * portid, unsigned attrid,
-		   unsigned mod, unsigned timeout)
-{
-	return smp_query_via(rcvbuf, portid, attrid, mod, timeout, ibmp);
-}
diff --git a/src/vendor.c b/src/vendor.c
index 22d6843..f43980c 100644
--- a/src/vendor.c
+++ b/src/vendor.c
@@ -53,12 +53,6 @@ static inline int response_expected(int method)
 	    method == IB_MAD_METHOD_SET || method == IB_MAD_METHOD_TRAP;
 }
 
-uint8_t *ib_vendor_call(void *data, ib_portid_t * portid,
-			ib_vendor_call_t * call)
-{
-	return ib_vendor_call_via(data, portid, call, ibmp);
-}
-
 uint8_t *ib_vendor_call_via(void *data, ib_portid_t * portid,
 			    ib_vendor_call_t * call,
 			    struct ibmad_port * srcport)
-- 
1.7.0.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
