From: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: libibmad : submitting six patches on behalf of Oracle IB development
Date: Wed, 27 Feb 2013 13:23:02 -0800
Message-ID: <512E7936.2080409@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080207060805090907080404"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------080207060805090907080404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ira,

We (Oracle IB development) are submitting six patches against

libibmad-1.3.9 (as attached).

Please review our submission of changes.

Many thanks,
Boris

--------------080207060805090907080404
Content-Type: text/x-patch;
 name="rdma_fix_TID_SRIOV.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdma_fix_TID_SRIOV.patch"

libibmad: To reserve upper 8 bits of tid used by solaris SRIOV driver
Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
diff -uprN ./SOURCES/libibmad-1.3.9/src/mad.c ./SOURCES/libibmad-1.3.9.fix_TID_SRIOV/src/mad.c
--- ./SOURCES/libibmad-1.3.9/src/mad.c	2012-04-30 13:42:44.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_TID_SRIOV/src/mad.c	2013-02-25 10:08:46.395048119 -0800
@@ -62,6 +62,9 @@ uint64_t mad_trid(void)
 		trid = random();
 	}
 	next = ++trid | (base << 32);
+#if defined(__SVR4) && defined(__sun)
+	next &= 0x00ffffffffffffff;
+#endif
 	return next;
 }
 


--------------080207060805090907080404
Content-Type: text/x-patch;
 name="rdma_fix_big_endian.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdma_fix_big_endian.patch"

libibmad: To fix big endian problem for both 32-bit & 64-bit SPARC
Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
diff -uprN ./SOURCES/libibmad-1.3.9/src/dump.c ./SOURCES/libibmad-1.3.9.fix_big_endian/src/dump.c
--- ./SOURCES/libibmad-1.3.9/src/dump.c	2012-05-31 15:12:30.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_big_endian/src/dump.c	2013-02-13 15:19:59.000000000 -0800
@@ -46,12 +46,24 @@
 
 void mad_dump_int(char *buf, int bufsz, void *val, int valsz)
 {
+	/*
+	 * the val pointer passed to the dump routines are always 32 bit
+	 * integers for valsz <= 4 and 64 bit integer for the rest. It is never
+	 * uint8_t or uint16_t. This is because mad_decode_field always returns
+	 * the values as 32 bit integer even if they are 8 bit or 16 bit fields.
+	 */
 	switch (valsz) {
 	case 1:
-		snprintf(buf, bufsz, "%d", *(uint32_t *) val & 0xff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint8_t *)val) + 3;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%d", *(uint8_t *) val & 0xff);
 		break;
 	case 2:
-		snprintf(buf, bufsz, "%d", *(uint32_t *) val & 0xffff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint16_t *)val) + 1;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%d", *(uint16_t *) val & 0xffff);
 		break;
 	case 3:
 	case 4:
@@ -71,12 +83,24 @@ void mad_dump_int(char *buf, int bufsz, 
 
 void mad_dump_uint(char *buf, int bufsz, void *val, int valsz)
 {
+	/*
+	 * the val pointer passed to the dump routines are always 32 bit
+	 * integers for valsz <= 4 and 64 bit integer for the rest. It is never
+	 * uint8_t or uint16_t. This is because mad_decode_field always returns
+	 * the values as 32 bit integer even if they are 8 bit or 16 bit fields.
+	 */
 	switch (valsz) {
 	case 1:
-		snprintf(buf, bufsz, "%u", *(uint32_t *) val & 0xff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint8_t *)val) + 3;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%u", *(uint8_t *) val & 0xff);
 		break;
 	case 2:
-		snprintf(buf, bufsz, "%u", *(uint32_t *) val & 0xffff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint16_t *)val) + 1;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%u", *(uint16_t *) val & 0xffff);
 		break;
 	case 3:
 	case 4:
@@ -96,15 +120,27 @@ void mad_dump_uint(char *buf, int bufsz,
 
 void mad_dump_hex(char *buf, int bufsz, void *val, int valsz)
 {
+	/*
+	 * the val pointer passed to the dump routines are always 32 bit
+	 * integers for valsz <= 4 and 64 bit integer for the rest. It is never
+	 * uint8_t or uint16_t. This is because mad_decode_field always returns
+	 * the values as 32 bit integer even if they are 8 bit or 16 bit fields.
+	 */
 	switch (valsz) {
 	case 1:
-		snprintf(buf, bufsz, "0x%02x", *(uint32_t *) val & 0xff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint8_t *)val) + 3;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "0x%02x", *(uint8_t *) val & 0xff);
 		break;
 	case 2:
-		snprintf(buf, bufsz, "0x%04x", *(uint32_t *) val & 0xffff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint16_t *)val) + 1;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "0x%04x", *(uint16_t *) val & 0xffff);
 		break;
 	case 3:
-		snprintf(buf, bufsz, "0x%06x", *(uint32_t *) val & 0xffffff);
+		snprintf(buf, bufsz, "0x%x", *(uint32_t *) val & 0xffffff);
 		break;
 	case 4:
 		snprintf(buf, bufsz, "0x%08x", *(uint32_t *) val);
@@ -132,12 +168,24 @@ void mad_dump_hex(char *buf, int bufsz, 
 
 void mad_dump_rhex(char *buf, int bufsz, void *val, int valsz)
 {
+	/*
+	 * the val pointer passed to the dump routines are always 32 bit
+	 * integers for valsz <= 4 and 64 bit integer for the rest. It is never
+	 * uint8_t or uint16_t. This is because mad_decode_field always returns
+	 * the values as 32 bit integer even if they are 8 bit or 16 bit fields.
+	 */
 	switch (valsz) {
 	case 1:
-		snprintf(buf, bufsz, "%02x", *(uint32_t *) val & 0xff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint8_t *)val) + 3;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%02x", *(uint8_t *) val & 0xff);
 		break;
 	case 2:
-		snprintf(buf, bufsz, "%04x", *(uint32_t *) val & 0xffff);
+#if defined(_BIG_ENDIAN)
+		val = ((uint16_t *)val) + 1;
+#endif /* _BIG_ENDIAN */
+		snprintf(buf, bufsz, "%04x", *(uint16_t *) val & 0xffff);
 		break;
 	case 3:
 		snprintf(buf, bufsz, "%06x", *(uint32_t *) val & 0xffffff);


--------------080207060805090907080404
Content-Type: text/x-patch;
 name="rdma_fix_failure_on_HCA_connection.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdma_fix_failure_on_HCA_connection.patch"

libibmad: Fixes for failures when not all ports of HCA are connected
Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
diff -uprN ./SOURCES/libibmad-1.3.9/src/sa.c ./SOURCES/libibmad-1.3.9.fix_failure_on_HCA_connection/src/sa.c
--- ./SOURCES/libibmad-1.3.9/src/sa.c	2011-08-31 16:51:36.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_failure_on_HCA_connection/src/sa.c	2013-02-12 13:06:00.000000000 -0800
@@ -38,6 +38,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <errno.h>
 
 #include <infiniband/mad.h>
 #include "mad_internal.h"
@@ -56,6 +57,7 @@ uint8_t *sa_rpc_call(const struct ibmad_
 
 	if (portid->lid <= 0) {
 		IBWARN("only lid routes are supported");
+		errno = EIO;
 		return NULL;
 	}
 
diff -uprN ./SOURCES/libibmad-1.3.9/src/resolve.c ./SOURCES/libibmad-1.3.9.fix_failure_on_HCA_connection/src/resolve.c
--- ./SOURCES/libibmad-1.3.9/src/resolve.c	2011-08-31 16:51:37.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_failure_on_HCA_connection/src/resolve.c	2013-02-26 09:21:27.650047922 -0800
@@ -40,6 +40,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <arpa/inet.h>
+#include <errno.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -57,10 +58,18 @@ int ib_resolve_smlid_via(ib_portid_t * s
 
 	memset(sm_id, 0, sizeof(*sm_id));
 
-	if (!smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0, srcport))
+	if (!smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0, srcport)) {
+		if (!errno)
+			errno = EIO;
 		return -1;
+	}
 
 	mad_decode_field(portinfo, IB_PORT_SMLID_F, &lid);
+	if (lid == 0) {
+		if (!errno)
+			errno = EIO;
+		return -1;
+	}
 	mad_decode_field(portinfo, IB_PORT_SMSL_F, &sm_id->sl);
 
 	return ib_portid_set(sm_id, lid, 0, 0);
@@ -95,21 +104,26 @@ int ib_resolve_guid_via(ib_portid_t * po
 			ib_portid_t * sm_id, int timeout,
 			const struct ibmad_port *srcport)
 {
-	ib_portid_t sm_portid;
+	ib_portid_t sm_portid = { 0 };
 	uint8_t buf[IB_SA_DATA_SIZE] = { 0 };
 	ib_portid_t self = { 0 };
 	uint64_t selfguid, prefix;
 	ibmad_gid_t selfgid;
 	uint8_t nodeinfo[64];
 
-	if (!sm_id) {
+	if (!sm_id)
 		sm_id = &sm_portid;
+
+	if (!sm_id->lid) {
 		if (ib_resolve_smlid_via(sm_id, timeout, srcport) < 0)
 			return -1;
 	}
 
-	if (!smp_query_via(nodeinfo, &self, IB_ATTR_NODE_INFO, 0, 0, srcport))
+	if (!smp_query_via(nodeinfo, &self, IB_ATTR_NODE_INFO, 0, 0, srcport)) {
+		if (!errno)
+			errno = EIO;
 		return -1;
+	}
 	mad_decode_field(nodeinfo, IB_NODE_PORT_GUID_F, &selfguid);
 	mad_set_field64(selfgid, 0, IB_GID_PREFIX_F, IB_DEFAULT_SUBN_PREFIX);
 	mad_set_field64(selfgid, 0, IB_GID_GUID_F, selfguid);
diff -uprN ./SOURCES/libibmad-1.3.9/src/rpc.c ./SOURCES/libibmad-1.3.9.fix_failure_on_HCA_connection/src/rpc.c
--- ./SOURCES/libibmad-1.3.9/src/rpc.c	2012-04-30 13:42:44.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_failure_on_HCA_connection/src/rpc.c	2013-02-15 09:00:17.802048686 -0800
@@ -178,6 +178,7 @@ _do_madrpc(int port_id, void *sndbuf, vo
 					 IB_MAD_TRID_F) != trid);
 
 		status = umad_status(rcvbuf);
+		errno = status;
 		if (!status)
 			return length;	/* done */
 		if (status == ENOMEM)


--------------080207060805090907080404
Content-Type: text/x-patch;
 name="rdma_fix_m_unsupported_on_solaris.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdma_fix_m_unsupported_on_solaris.patch"

libibmad: Conversion specifier; %m is not supported on Solaris
Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
diff -uprN ./SOURCES/libibmad-1.3.9/src/rpc.c ./SOURCES/libibmad-1.3.9.fix_m_unsupported_on_solaris/src/rpc.c
--- ./SOURCES/libibmad-1.3.9/src/rpc.c	2012-04-30 13:42:44.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_m_unsupported_on_solaris/src/rpc.c	2013-02-15 08:57:12.302048541 -0800
@@ -153,7 +153,7 @@ _do_madrpc(int port_id, void *sndbuf, vo
 
 		length = len;
 		if (umad_send(port_id, agentid, sndbuf, length, timeout, 0) < 0) {
-			IBWARN("send failed; %m");
+			IBWARN("send failed; %s", strerror(errno));
 			return -1;
 		}
 
@@ -162,7 +162,7 @@ _do_madrpc(int port_id, void *sndbuf, vo
 		do {
 			length = len;
 			if (umad_recv(port_id, rcvbuf, &length, timeout) < 0) {
-				IBWARN("recv failed: %m");
+				IBWARN("recv failed: %s", strerror(errno));
 				return -1;
 			}
 
diff -uprN ./SOURCES/libibmad-1.3.9/src/serv.c ./SOURCES/libibmad-1.3.9.fix_m_unsupported_on_solaris/src/serv.c
--- ./SOURCES/libibmad-1.3.9/src/serv.c	2011-08-31 16:51:36.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_m_unsupported_on_solaris/src/serv.c	2013-02-12 13:30:10.000000000 -0800
@@ -38,6 +38,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <errno.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -75,7 +76,7 @@ int mad_send_via(ib_rpc_t * rpc, ib_port
 	if (umad_send(srcport->port_id, srcport->class_agents[rpc->mgtclass & 0xff],
 		      umad, IB_MAD_SIZE, mad_get_timeout(srcport, rpc->timeout),
 		      0) < 0) {
-		IBWARN("send failed; %m");
+		IBWARN("send failed; %s", strerror(errno));
 		return -1;
 	}
 
@@ -157,7 +158,7 @@ int mad_respond_via(void *umad, ib_porti
 	if (umad_send
 	    (srcport->port_id, srcport->class_agents[rpc.mgtclass], umad,
 	     IB_MAD_SIZE, mad_get_timeout(srcport, rpc.timeout), 0) < 0) {
-		DEBUG("send failed; %m");
+		DEBUG("send failed; %s", strerror(errno));
 		return -1;
 	}
 
@@ -179,7 +180,7 @@ void *mad_receive_via(void *umad, int ti
 			       mad_get_timeout(srcport, timeout))) < 0) {
 		if (!umad)
 			umad_free(mad);
-		DEBUG("recv failed: %m");
+		DEBUG("recv failed: %s", strerror(errno));
 		return 0;
 	}
 


--------------080207060805090907080404
Content-Type: text/x-patch;
 name="rdma_fix_null_dev_name_madrpc_init.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdma_fix_null_dev_name_madrpc_init.patch"

libibmad: To handle null dev_name in madrpc_init
Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
diff -uprN ./SOURCES/libibmad-1.3.9/src/rpc.c ./SOURCES/libibmad-1.3.9.fix_null_dev_name_madrpc_init/src/rpc.c
--- ./SOURCES/libibmad-1.3.9/src/rpc.c	2012-04-30 13:42:44.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_null_dev_name_madrpc_init/src/rpc.c	2013-02-22 14:54:14.654048137 -0800
@@ -360,7 +360,8 @@ madrpc_init(char *dev_name, int dev_port
 		IBPANIC("can't init UMAD library");
 
 	if ((fd = umad_open_port(dev_name, dev_port)) < 0)
-		IBPANIC("can't open UMAD port (%s:%d)", dev_name, dev_port);
+		IBPANIC("can't open UMAD port (%s:%d)",
+		dev_name ? dev_name : "(nil)", dev_port);
 
 	if (num_classes >= MAX_CLASS)
 		IBPANIC("too many classes %d requested", num_classes);


--------------080207060805090907080404
Content-Type: text/x-patch;
 name="rdma_fix_typecasts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdma_fix_typecasts.patch"

libibmad: To fix compilation warning: need typecasts
Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
diff -uprN ./SOURCES/libibmad-1.3.9/src/fields.c ./SOURCES/libibmad-1.3.9.fix_typecasts/src/fields.c
--- ./SOURCES/libibmad-1.3.9/src/fields.c	2012-04-30 13:42:47.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_typecasts/src/fields.c	2013-02-13 15:32:03.000000000 -0800
@@ -937,15 +937,15 @@ static void _set_field64(void *buf, int 
 	uint64_t nval;
 
 	nval = htonll(val);
-	memcpy((char *)buf + base_offs + f->bitoffs / 8, &nval,
-	       sizeof(uint64_t));
+	memcpy(((void *)(char *)buf + base_offs + f->bitoffs / 8),
+		(void *)&nval, sizeof(uint64_t));
 }
 
 static uint64_t _get_field64(void *buf, int base_offs, const ib_field_t * f)
 {
 	uint64_t val;
-	memcpy(&val, ((char *)buf + base_offs + f->bitoffs / 8),
-	       sizeof(uint64_t));
+	memcpy((void *)&val, (void *)((char *)buf + base_offs + f->bitoffs / 8),
+		sizeof(uint64_t));
 	return ntohll(val);
 }
 
diff -uprN ./SOURCES/libibmad-1.3.9/include/infiniband/mad.h ./SOURCES/libibmad-1.3.9.fix_typecasts/include/infiniband/mad.h
--- ./SOURCES/libibmad-1.3.9/include/infiniband/mad.h	2012-04-30 13:42:43.000000000 -0700
+++ ./SOURCES/libibmad-1.3.9.fix_typecasts/include/infiniband/mad.h	2013-02-13 15:43:52.000000000 -0800
@@ -1627,14 +1627,18 @@ static inline uint64_t htonll(uint64_t x
 #define ALIGN(l, size) (((l) + ((size) - 1)) / (size) * (size))
 
 /** printf style warning MACRO, includes name of function and pid */
-#define IBWARN(fmt, ...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+#define IBWARN(fmt, ...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", \
+(int)getpid(), __func__, ## __VA_ARGS__)
 
-#define IBDEBUG(fmt, ...) fprintf(stdout, "ibdebug: [%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+#define IBDEBUG(fmt, ...) fprintf(stdout, "ibdebug: [%d] %s: " fmt "\n", \
+(int)getpid(), __func__, ## __VA_ARGS__)
 
-#define IBVERBOSE(fmt, ...) fprintf(stdout, "[%d] %s: " fmt "\n", getpid(), __func__, ## __VA_ARGS__)
+#define IBVERBOSE(fmt, ...) fprintf(stdout, "[%d] %s: " fmt "\n", \
+(int)getpid(), __func__, ## __VA_ARGS__)
 
 #define IBPANIC(fmt, ...) do { \
-	fprintf(stderr, "ibpanic: [%d] %s: " fmt ": %m\n", getpid(), __func__, ## __VA_ARGS__); \
+	fprintf(stderr, "ibpanic: [%d] %s: " fmt ": %m\n", \
+	(int)getpid(), __func__, ## __VA_ARGS__); \
 	exit(-1); \
 } while(0)
 


--------------080207060805090907080404--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
