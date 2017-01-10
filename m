From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/4] Minimize the places where infiniband/arch.h is included
Date: Tue, 10 Jan 2017 12:02:08 -0700
Message-ID: <1484074931-3847-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1484074931-3847-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484074931-3847-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We never want to use it for htonll as this header can only be
compiled on architectures that define the PCI memory barriers.
Instead use byteswap.h directly.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/linux/osd.h                 | 1 -
 ibacm/src/libacm.c                | 6 +++---
 libibumad/sysfs.c                 | 3 +--
 libibverbs/device.c               | 4 +---
 libibverbs/examples/device_list.c | 3 +--
 libibverbs/examples/devinfo.c     | 3 +--
 librdmacm/addrinfo.c              | 6 +++---
 librdmacm/cma.c                   | 6 +++---
 librdmacm/cma.h                   | 1 -
 librdmacm/examples/rping.c        | 7 +++----
 librdmacm/rsocket.c               | 8 ++++----
 srp_daemon/srp_daemon.h           | 1 -
 12 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 6e408f75ac1937..4169ec54f0f38e 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -46,7 +46,6 @@
 #include <arpa/inet.h>
 #include <sys/time.h>
 #include <netinet/in.h>
-#include <infiniband/arch.h>
 
 #include <ccan/minmax.h>
 
diff --git a/ibacm/src/libacm.c b/ibacm/src/libacm.c
index c121ad7b114e4b..8288bd446fdcf9 100644
--- a/ibacm/src/libacm.c
+++ b/ibacm/src/libacm.c
@@ -338,7 +338,7 @@ int ib_acm_query_perf(int index, uint64_t **counters, int *count)
 
 	*count = msg.hdr.data[0];
 	for (i = 0; i < *count; i++)
-		(*counters)[i] = ntohll(msg.perf_data[i]);
+		(*counters)[i] = be64toh(msg.perf_data[i]);
 	ret = 0;
 out:
 	pthread_mutex_unlock(&acm_lock);
@@ -385,7 +385,7 @@ int ib_acm_enum_ep(int index, struct acm_ep_config_data **data)
 	}
 
 	memcpy(edata, &msg.ep_data[0], len);
-	edata->dev_guid = ntohll(msg.ep_data[0].dev_guid);
+	edata->dev_guid = be64toh(msg.ep_data[0].dev_guid);
 	edata->pkey = ntohs(msg.ep_data[0].pkey);
 	edata->addr_cnt = cnt;
 	*data = edata;
@@ -440,7 +440,7 @@ int ib_acm_query_perf_ep_addr(uint8_t *src, uint8_t type,
 
 	*count = msg.hdr.data[0];
 	for (i = 0; i < *count; i++)
-		(*counters)[i] = ntohll(msg.perf_data[i]);
+		(*counters)[i] = be64toh(msg.perf_data[i]);
 
 	ret = 0;
 out:
diff --git a/libibumad/sysfs.c b/libibumad/sysfs.c
index 730374d0dc4ca6..9ef16fd9fa09f7 100644
--- a/libibumad/sysfs.c
+++ b/libibumad/sysfs.c
@@ -43,7 +43,6 @@
 #include <fcntl.h>
 #include <byteswap.h>
 #include <netinet/in.h>
-#include <infiniband/arch.h>
 #include "sysfs.h"
 
 static int ret_code(void)
@@ -98,7 +97,7 @@ int sys_read_guid(const char *dir_name, const char *file_name, uint64_t * net_gu
 		guid = (guid << 16) | (strtoul(str, NULL, 16) & 0xffff);
 	}
 
-	*net_guid = htonll(guid);
+	*net_guid = htobe64(guid);
 
 	return 0;
 }
diff --git a/libibverbs/device.c b/libibverbs/device.c
index 8950f2a3d711cd..c7f39d57681170 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -43,8 +43,6 @@
 #include <alloca.h>
 #include <errno.h>
 
-#include <infiniband/arch.h>
-
 #include "ibverbs.h"
 
 #pragma GCC diagnostic ignored "-Wmissing-prototypes"
@@ -118,7 +116,7 @@ uint64_t __ibv_get_device_guid(struct ibv_device *device)
 	for (i = 0; i < 4; ++i)
 		guid = (guid << 16) | parts[i];
 
-	return htonll(guid);
+	return htobe64(guid);
 }
 default_symver(__ibv_get_device_guid, ibv_get_device_guid);
 
diff --git a/libibverbs/examples/device_list.c b/libibverbs/examples/device_list.c
index 13f40ad630070d..084ede597af026 100644
--- a/libibverbs/examples/device_list.c
+++ b/libibverbs/examples/device_list.c
@@ -38,7 +38,6 @@
 #include <byteswap.h>
 
 #include <infiniband/verbs.h>
-#include <infiniband/arch.h>
 
 int main(int argc, char *argv[])
 {
@@ -57,7 +56,7 @@ int main(int argc, char *argv[])
 	for (i = 0; i < num_devices; ++i) {
 		printf("    %-16s\t%016llx\n",
 		       ibv_get_device_name(dev_list[i]),
-		       (unsigned long long) ntohll(ibv_get_device_guid(dev_list[i])));
+		       (unsigned long long) be64toh(ibv_get_device_guid(dev_list[i])));
 	}
 
 	ibv_free_device_list(dev_list);
diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index 78e92b95c3cae8..2303ce3936c8e1 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -45,7 +45,6 @@
 
 #include <infiniband/verbs.h>
 #include <infiniband/driver.h>
-#include <infiniband/arch.h>
 
 static int verbose;
 
@@ -57,7 +56,7 @@ static int null_gid(union ibv_gid *gid)
 
 static const char *guid_str(uint64_t node_guid, char *str)
 {
-	node_guid = ntohll(node_guid);
+	node_guid = be64toh(node_guid);
 	sprintf(str, "%04x:%04x:%04x:%04x",
 		(unsigned) (node_guid >> 48) & 0xffff,
 		(unsigned) (node_guid >> 32) & 0xffff,
diff --git a/librdmacm/addrinfo.c b/librdmacm/addrinfo.c
index ac346438a6d07c..c7c19b1d019f65 100644
--- a/librdmacm/addrinfo.c
+++ b/librdmacm/addrinfo.c
@@ -113,12 +113,12 @@ void ucma_set_sid(enum rdma_port_space ps, struct sockaddr *addr,
 	uint16_t port;
 
 	port = addr ? ucma_get_port(addr) : 0;
-	sib->sib_sid = htonll(((uint64_t) ps << 16) + ntohs(port));
+	sib->sib_sid = htobe64(((uint64_t) ps << 16) + ntohs(port));
 
 	if (ps)
-		sib->sib_sid_mask = htonll(RDMA_IB_IP_PS_MASK);
+		sib->sib_sid_mask = htobe64(RDMA_IB_IP_PS_MASK);
 	if (port)
-		sib->sib_sid_mask |= htonll(RDMA_IB_IP_PORT_MASK);
+		sib->sib_sid_mask |= htobe64(RDMA_IB_IP_PORT_MASK);
 }
 
 static int ucma_convert_in6(int ps, struct sockaddr_ib **dst, socklen_t *dst_len,
diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 7f79ee942186bb..0c742845dde8d6 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -177,8 +177,8 @@ static void ucma_set_af_ib_support(void)
 
 	memset(&sib, 0, sizeof sib);
 	sib.sib_family = AF_IB;
-	sib.sib_sid = htonll(RDMA_IB_IP_PS_TCP);
-	sib.sib_sid_mask = htonll(RDMA_IB_IP_PS_MASK);
+	sib.sib_sid = htobe64(RDMA_IB_IP_PS_TCP);
+	sib.sib_sid_mask = htobe64(RDMA_IB_IP_PS_MASK);
 	af_ib_support = 1;
 	ret = rdma_bind_addr(id, (struct sockaddr *) &sib);
 	af_ib_support = !ret;
@@ -2443,7 +2443,7 @@ uint16_t ucma_get_port(struct sockaddr *addr)
 	case AF_INET6:
 		return ((struct sockaddr_in6 *) addr)->sin6_port;
 	case AF_IB:
-		return htons((uint16_t) ntohll(((struct sockaddr_ib *) addr)->sib_sid));
+		return htons((uint16_t) be64toh(((struct sockaddr_ib *) addr)->sib_sid));
 	default:
 		return 0;
 	}
diff --git a/librdmacm/cma.h b/librdmacm/cma.h
index 6fe786052dfff5..2e7c4182e7d98e 100644
--- a/librdmacm/cma.h
+++ b/librdmacm/cma.h
@@ -44,7 +44,6 @@
 
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
-#include <infiniband/arch.h>
 
 #include <ccan/minmax.h>
 
diff --git a/librdmacm/examples/rping.c b/librdmacm/examples/rping.c
index 53c152538c67ff..c56b6ef3010f53 100644
--- a/librdmacm/examples/rping.c
+++ b/librdmacm/examples/rping.c
@@ -47,7 +47,6 @@
 #include <inttypes.h>
 
 #include <rdma/rdma_cma.h>
-#include <infiniband/arch.h>
 
 static int debug = 0;
 #define DEBUG_LOG if (debug) printf
@@ -246,7 +245,7 @@ static int server_recv(struct rping_cb *cb, struct ibv_wc *wc)
 	}
 
 	cb->remote_rkey = ntohl(cb->recv_buf.rkey);
-	cb->remote_addr = ntohll(cb->recv_buf.buf);
+	cb->remote_addr = be64toh(cb->recv_buf.buf);
 	cb->remote_len  = ntohl(cb->recv_buf.size);
 	DEBUG_LOG("Received rkey %x addr %" PRIx64 " len %d from peer\n",
 		  cb->remote_rkey, cb->remote_addr, cb->remote_len);
@@ -622,12 +621,12 @@ static void rping_format_send(struct rping_cb *cb, char *buf, struct ibv_mr *mr)
 {
 	struct rping_rdma_info *info = &cb->send_buf;
 
-	info->buf = htonll((uint64_t) (unsigned long) buf);
+	info->buf = htobe64((uint64_t) (unsigned long) buf);
 	info->rkey = htonl(mr->rkey);
 	info->size = htonl(cb->size);
 
 	DEBUG_LOG("RDMA addr %" PRIx64" rkey %x len %d\n",
-		  ntohll(info->buf), ntohl(info->rkey), ntohl(info->size));
+		  be64toh(info->buf), ntohl(info->rkey), ntohl(info->size));
 }
 
 static int rping_test_server(struct rping_cb *cb)
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index e0755dd0ab056a..e2e29a30eb59ed 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -1045,18 +1045,18 @@ static void rs_format_conn_data(struct rsocket *rs, struct rs_conn_data *conn)
 	memset(conn->reserved, 0, sizeof conn->reserved);
 	conn->target_iomap_size = (uint8_t) rs_value_to_scale(rs->target_iomap_size, 8);
 
-	conn->target_sgl.addr = htonll((uintptr_t) rs->target_sgl);
+	conn->target_sgl.addr = htobe64((uintptr_t) rs->target_sgl);
 	conn->target_sgl.length = htonl(RS_SGL_SIZE);
 	conn->target_sgl.key = htonl(rs->target_mr->rkey);
 
-	conn->data_buf.addr = htonll((uintptr_t) rs->rbuf);
+	conn->data_buf.addr = htobe64((uintptr_t) rs->rbuf);
 	conn->data_buf.length = htonl(rs->rbuf_size >> 1);
 	conn->data_buf.key = htonl(rs->rmr->rkey);
 }
 
 static void rs_save_conn_data(struct rsocket *rs, struct rs_conn_data *conn)
 {
-	rs->remote_sgl.addr = ntohll(conn->target_sgl.addr);
+	rs->remote_sgl.addr = be64toh(conn->target_sgl.addr);
 	rs->remote_sgl.length = ntohl(conn->target_sgl.length);
 	rs->remote_sgl.key = ntohl(conn->target_sgl.key);
 	rs->remote_sge = 1;
@@ -1071,7 +1071,7 @@ static void rs_save_conn_data(struct rsocket *rs, struct rs_conn_data *conn)
 		rs->remote_iomap.key = rs->remote_sgl.key;
 	}
 
-	rs->target_sgl[0].addr = ntohll(conn->data_buf.addr);
+	rs->target_sgl[0].addr = be64toh(conn->data_buf.addr);
 	rs->target_sgl[0].length = ntohl(conn->data_buf.length);
 	rs->target_sgl[0].key = ntohl(conn->data_buf.key);
 
diff --git a/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon.h
index d9d92f10f84c25..3de8ee0e9827cb 100644
--- a/srp_daemon/srp_daemon.h
+++ b/srp_daemon/srp_daemon.h
@@ -42,7 +42,6 @@
 #include <byteswap.h>
 #include <infiniband/verbs.h>
 #include <infiniband/umad.h>
-#include <infiniband/arch.h>
 
 #include "config.h"
 #include "srp_ib_types.h"
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
