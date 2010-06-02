From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ib/mgmt: fix build under windows stack
Date: Wed, 2 Jun 2010 13:15:31 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F462DED@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix warnings in windows build.

These are typecasts in several places, with a couple additional changes
needed to libibnetdisc.  Windows uses ISO definitions instead of
POSIX definitions, so calls like _read, _write, etc. are used on
Windows instead of read, write.  The result is that internal functions
are renamed with an ibnd prefix.

In order to handle ibdebug exported from libibmad, Windows need to mark
the variable as a 'dllexport' from libibmad, but as 'dllimport' for users.
Since libibnetdisc wants to 'dllimport' ibdebug from libibmad, while
'dllexporting its own functions, it requires a separate 'MAD_EXPORT' like
definition to allow this.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Note the change to query_smp.c.  It's the one area that may need more
thought about how things get handled.

 .../libibnetdisc/include/infiniband/ibnetdisc.h    |   28 +++++-----
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |    6 +-
 .../libibnetdisc/src/ibnetdisc_cache.c             |   58 ++++++++++----------
 infiniband-diags/libibnetdisc/src/query_smp.c      |    6 ++
 infiniband-diags/src/ibping.c                      |    2 -
 infiniband-diags/src/saquery.c                     |    2 -
 libibmad/include/infiniband/mad.h                  |    2 -
 libibmad/include/infiniband/mad_osd.h              |    1 
 8 files changed, 55 insertions(+), 50 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 83d0ba7..49ff743 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -168,7 +168,7 @@ typedef struct ibnd_fabric {
  * Initialization (fabric operations)
  */
 
-MAD_EXPORT ibnd_fabric_t *ibnd_discover_fabric(char * ca_name,
+IBND_EXPORT ibnd_fabric_t *ibnd_discover_fabric(char * ca_name,
 					       int ca_port,
 					       ib_portid_t * from,
 					       struct ibnd_config *config);
@@ -179,39 +179,39 @@ MAD_EXPORT ibnd_fabric_t *ibnd_discover_fabric(char * ca_name,
 	 *       If NULL start from the CA/CA port specified
 	 * config: (optional) additional config options for the scan
 	 */
-MAD_EXPORT void ibnd_destroy_fabric(ibnd_fabric_t * fabric);
+IBND_EXPORT void ibnd_destroy_fabric(ibnd_fabric_t * fabric);
 
-MAD_EXPORT ibnd_fabric_t *ibnd_load_fabric(const char *file,
+IBND_EXPORT ibnd_fabric_t *ibnd_load_fabric(const char *file,
 					   unsigned int flags);
 
-MAD_EXPORT int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
+IBND_EXPORT int ibnd_cache_fabric(ibnd_fabric_t * fabric, const char *file,
 				 unsigned int flags);
 
 /** =========================================================================
  * Node operations
  */
-MAD_EXPORT ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric,
+IBND_EXPORT ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric,
 					    uint64_t guid);
-MAD_EXPORT ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str);
+IBND_EXPORT ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str);
 
 typedef void (*ibnd_iter_node_func_t) (ibnd_node_t * node, void *user_data);
-MAD_EXPORT void ibnd_iter_nodes(ibnd_fabric_t * fabric,
+IBND_EXPORT void ibnd_iter_nodes(ibnd_fabric_t * fabric,
 				ibnd_iter_node_func_t func, void *user_data);
-MAD_EXPORT void ibnd_iter_nodes_type(ibnd_fabric_t * fabric,
+IBND_EXPORT void ibnd_iter_nodes_type(ibnd_fabric_t * fabric,
 				     ibnd_iter_node_func_t func,
 				     int node_type, void *user_data);
 
 /** =========================================================================
  * Chassis queries
  */
-MAD_EXPORT uint64_t ibnd_get_chassis_guid(ibnd_fabric_t * fabric,
+IBND_EXPORT uint64_t ibnd_get_chassis_guid(ibnd_fabric_t * fabric,
 					  unsigned char chassisnum);
-MAD_EXPORT char *ibnd_get_chassis_type(ibnd_node_t * node);
-MAD_EXPORT char *ibnd_get_chassis_slot_str(ibnd_node_t * node,
+IBND_EXPORT char *ibnd_get_chassis_type(ibnd_node_t * node);
+IBND_EXPORT char *ibnd_get_chassis_slot_str(ibnd_node_t * node,
 					   char *str, size_t size);
 
-MAD_EXPORT int ibnd_is_xsigo_guid(uint64_t guid);
-MAD_EXPORT int ibnd_is_xsigo_tca(uint64_t guid);
-MAD_EXPORT int ibnd_is_xsigo_hca(uint64_t guid);
+IBND_EXPORT int ibnd_is_xsigo_guid(uint64_t guid);
+IBND_EXPORT int ibnd_is_xsigo_tca(uint64_t guid);
+IBND_EXPORT int ibnd_is_xsigo_hca(uint64_t guid);
 
 #endif				/* _IBNETDISC_H_ */
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 0c4009a..f525d71 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -114,7 +114,7 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 		return -1;
 	}
 
-	if (portid->drpath.cnt > fabric->maxhops_discovered)
+	if ((unsigned) portid->drpath.cnt > fabric->maxhops_discovered)
 		fabric->maxhops_discovered = portid->drpath.cnt;
 
 	return 1;
@@ -162,8 +162,8 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	uint8_t *port_info = mad + IB_SMP_DATA_OFFS;
 	uint8_t port_num, local_port;
 
-	port_num = mad_get_field(mad, 0, IB_MAD_ATTRMOD_F);
-	local_port = mad_get_field(port_info, 0, IB_PORT_LOCAL_PORT_F);
+	port_num = (uint8_t) mad_get_field(mad, 0, IB_MAD_ATTRMOD_F);
+	local_port = (uint8_t) mad_get_field(port_info, 0, IB_PORT_LOCAL_PORT_F);
 
 	/* this may have been created before */
 	port = node->ports[port_num];
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index 5acb8f6..10b2a37 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -146,13 +146,13 @@ typedef struct ibnd_fabric_cache {
 #define IBND_PORT_CACHE_KEY_LEN        (8 + 1)
 #define IBND_PORT_CACHE_LEN            (31 + IB_SMP_DATA_SIZE)
 
-static ssize_t _read(int fd, void *buf, size_t count)
+static ssize_t ibnd_read(int fd, void *buf, size_t count)
 {
 	size_t count_done = 0;
 	ssize_t ret;
 
 	while ((count - count_done) > 0) {
-		ret = read(fd, buf + count_done, count - count_done);
+		ret = read(fd, ((char *) buf) + count_done, count - count_done);
 		if (ret < 0) {
 			if (errno == EINTR)
 				continue;
@@ -229,7 +229,7 @@ static int _load_header_info(int fd, ibnd_fabric_cache_t * fabric_cache,
 	size_t offset = 0;
 	uint32_t tmp32;
 
-	if (_read(fd, buf, IBND_FABRIC_CACHE_HEADER_LEN) < 0)
+	if (ibnd_read(fd, buf, IBND_FABRIC_CACHE_HEADER_LEN) < 0)
 		return -1;
 
 	offset += _unmarshall32(buf + offset, &magic);
@@ -333,7 +333,7 @@ static int _load_node(int fd, ibnd_fabric_cache_t * fabric_cache)
 
 	node_cache->node = node;
 
-	if (_read(fd, buf, IBND_NODE_CACHE_HEADER_LEN) < 0)
+	if (ibnd_read(fd, buf, IBND_NODE_CACHE_HEADER_LEN) < 0)
 		goto cleanup;
 
 	offset += _unmarshall16(buf + offset, &node->smalid);
@@ -372,7 +372,7 @@ static int _load_node(int fd, ibnd_fabric_cache_t * fabric_cache)
 			goto cleanup;
 		}
 
-		if (_read(fd, buf, toread) < 0)
+		if (ibnd_read(fd, buf, toread) < 0)
 			goto cleanup;
 
 		offset = 0;
@@ -433,7 +433,7 @@ static int _load_port(int fd, ibnd_fabric_cache_t * fabric_cache)
 
 	port_cache->port = port;
 
-	if (_read(fd, buf, IBND_PORT_CACHE_LEN) < 0)
+	if (ibnd_read(fd, buf, IBND_PORT_CACHE_LEN) < 0)
 		goto cleanup;
 
 	offset += _unmarshall64(buf + offset, &port->guid);
@@ -684,13 +684,13 @@ cleanup:
 	return NULL;
 }
 
-static ssize_t _write(int fd, const void *buf, size_t count)
+static ssize_t ibnd_write(int fd, const void *buf, size_t count)
 {
 	size_t count_done = 0;
 	ssize_t ret;
 
 	while ((count - count_done) > 0) {
-		ret = write(fd, buf + count_done, count - count_done);
+		ret = write(fd, ((char *) buf) + count_done, count - count_done);
 		if (ret < 0) {
 			if (errno == EINTR)
 				continue;
@@ -731,14 +731,14 @@ static size_t _marshall32(uint8_t * outbuf, uint32_t num)
 
 static size_t _marshall64(uint8_t * outbuf, uint64_t num)
 {
-	outbuf[0] = num & 0x00000000000000FFULL;
-	outbuf[1] = (num & 0x000000000000FF00ULL) >> 8;
-	outbuf[2] = (num & 0x0000000000FF0000ULL) >> 16;
-	outbuf[3] = (num & 0x00000000FF000000ULL) >> 24;
-	outbuf[4] = (num & 0x000000FF00000000ULL) >> 32;
-	outbuf[5] = (num & 0x0000FF0000000000ULL) >> 40;
-	outbuf[6] = (num & 0x00FF000000000000ULL) >> 48;
-	outbuf[7] = (num & 0xFF00000000000000ULL) >> 56;
+	outbuf[0] = (uint8_t) num;
+	outbuf[1] = (uint8_t) (num >> 8);
+	outbuf[2] = (uint8_t) (num >> 16);
+	outbuf[3] = (uint8_t) (num >> 24);
+	outbuf[4] = (uint8_t) (num >> 32);
+	outbuf[5] = (uint8_t) (num >> 40);
+	outbuf[6] = (uint8_t) (num >> 48);
+	outbuf[7] = (uint8_t) (num >> 56);
 
 	return (sizeof(num));
 }
@@ -767,7 +767,7 @@ static int _cache_header_info(int fd, ibnd_fabric_t * fabric)
 	offset += _marshall64(buf + offset, fabric->from_node->guid);
 	offset += _marshall32(buf + offset, fabric->maxhops_discovered);
 
-	if (_write(fd, buf, offset) < 0)
+	if (ibnd_write(fd, buf, offset) < 0)
 		return -1;
 
 	return 0;
@@ -787,7 +787,7 @@ static int _cache_header_counts(int fd, unsigned int node_count,
 		return -1;
 	}
 
-	if (_write(fd, buf, offset) < 0)
+	if (ibnd_write(fd, buf, offset) < 0)
 		return -1;
 
 	return 0;
@@ -798,17 +798,17 @@ static int _cache_node(int fd, ibnd_node_t * node)
 	uint8_t buf[IBND_FABRIC_CACHE_BUFLEN];
 	size_t offset = 0;
 	size_t ports_stored_offset = 0;
-	unsigned int ports_stored_count = 0;
-	unsigned int i;
+	uint8_t ports_stored_count = 0;
+	int i;
 
 	offset += _marshall16(buf + offset, node->smalid);
 	offset += _marshall8(buf + offset, node->smalmc);
-	offset += _marshall8(buf + offset, node->smaenhsp0);
+	offset += _marshall8(buf + offset, (uint8_t) node->smaenhsp0);
 	offset += _marshall_buf(buf + offset, node->switchinfo,
 				IB_SMP_DATA_SIZE);
 	offset += _marshall64(buf + offset, node->guid);
-	offset += _marshall8(buf + offset, node->type);
-	offset += _marshall8(buf + offset, node->numports);
+	offset += _marshall8(buf + offset, (uint8_t) node->type);
+	offset += _marshall8(buf + offset, (uint8_t) node->numports);
 	offset += _marshall_buf(buf + offset, node->info, IB_SMP_DATA_SIZE);
 	offset += _marshall_buf(buf + offset, node->nodedesc, IB_SMP_DATA_SIZE);
 	/* need to come back later and store number of stored ports
@@ -823,7 +823,7 @@ static int _cache_node(int fd, ibnd_node_t * node)
 			offset += _marshall64(buf + offset,
 					      node->ports[i]->guid);
 			offset += _marshall8(buf + offset,
-					     node->ports[i]->portnum);
+					     (uint8_t) node->ports[i]->portnum);
 			ports_stored_count++;
 		}
 	}
@@ -831,7 +831,7 @@ static int _cache_node(int fd, ibnd_node_t * node)
 	/* go back and store number of port keys stored */
 	_marshall8(buf + ports_stored_offset, ports_stored_count);
 
-	if (_write(fd, buf, offset) < 0)
+	if (ibnd_write(fd, buf, offset) < 0)
 		return -1;
 
 	return 0;
@@ -843,8 +843,8 @@ static int _cache_port(int fd, ibnd_port_t * port)
 	size_t offset = 0;
 
 	offset += _marshall64(buf + offset, port->guid);
-	offset += _marshall8(buf + offset, port->portnum);
-	offset += _marshall8(buf + offset, port->ext_portnum);
+	offset += _marshall8(buf + offset, (uint8_t) port->portnum);
+	offset += _marshall8(buf + offset, (uint8_t) port->ext_portnum);
 	offset += _marshall16(buf + offset, port->base_lid);
 	offset += _marshall8(buf + offset, port->lmc);
 	offset += _marshall_buf(buf + offset, port->info, IB_SMP_DATA_SIZE);
@@ -852,14 +852,14 @@ static int _cache_port(int fd, ibnd_port_t * port)
 	if (port->remoteport) {
 		offset += _marshall8(buf + offset, 1);
 		offset += _marshall64(buf + offset, port->remoteport->guid);
-		offset += _marshall8(buf + offset, port->remoteport->portnum);
+		offset += _marshall8(buf + offset, (uint8_t) port->remoteport->portnum);
 	} else {
 		offset += _marshall8(buf + offset, 0);
 		offset += _marshall64(buf + offset, 0);
 		offset += _marshall8(buf + offset, 0);
 	}
 
-	if (_write(fd, buf, offset) < 0)
+	if (ibnd_write(fd, buf, offset) < 0)
 		return -1;
 
 	return 0;
diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index b68e08a..5fb3e18 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -31,6 +31,10 @@
  *
  */
 
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif				/* HAVE_CONFIG_H */
+
 #include <errno.h>
 #include <infiniband/ibnetdisc.h>
 #include <infiniband/umad.h>
@@ -155,7 +159,7 @@ static int process_one_recv(smp_engine_t * engine)
 	ibnd_smp_t *smp;
 	uint8_t *mad;
 	uint32_t trid;
-	uint8_t umad[umad_size() + IB_MAD_SIZE];
+	uint8_t umad[sizeof(struct ib_user_mad) + IB_MAD_SIZE];
 	int length = umad_size() + IB_MAD_SIZE;
 
 	memset(umad, 0, sizeof(umad));
diff --git a/infiniband-diags/src/saquery.c b/infiniband-diags/src/saquery.c
index 34f665e..5e9a5ad 100644
--- a/infiniband-diags/src/saquery.c
+++ b/infiniband-diags/src/saquery.c
@@ -157,7 +157,7 @@ static inline void report_err(int status)
 
 	st = status >> 8;
 	if (st)
-		sprintf(sa_err_str, " SA(%s)", ib_sa_err_str(st));
+		sprintf(sa_err_str, " SA(%s)", ib_sa_err_str((uint8_t) st));
 
 	fprintf(stderr, "ERROR: Query result returned 0x%04x, %s%s\n",
 		status, sm_err_str, sa_err_str);
diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index 7ae2a7d..7571a61 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1034,7 +1034,7 @@ MAD_EXPORT ib_mad_dump_fn
 MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
 				int start, int end);
 
-MAD_EXPORT extern int ibdebug;
+extern MAD_EXPORT int ibdebug;
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #ifndef ntohll
diff --git a/libibmad/include/infiniband/mad_osd.h b/libibmad/include/infiniband/mad_osd.h
index 923be55..ee73561 100644
--- a/libibmad/include/infiniband/mad_osd.h
+++ b/libibmad/include/infiniband/mad_osd.h
@@ -44,6 +44,7 @@
 #include <arpa/inet.h>
 
 #define MAD_EXPORT
+#define IBND_EXPORT
 #define DEPRECATED __attribute__ ((deprecated))
 
 #endif				/* _MAD_OSD_H_ */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
