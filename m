From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/8] acm: Fix format string usage with acm_log
Date: Fri, 14 Oct 2016 16:14:15 -0600
Message-ID: <1476483257-16308-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enable format string checking for acm_write and clean up everything.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/include/infiniband/acm_prov.h |  3 ++-
 ibacm/prov/acmp/src/acmp.c          | 26 ++++++++++++++------------
 ibacm/src/acm.c                     | 15 ++++++++-------
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/ibacm/include/infiniband/acm_prov.h b/ibacm/include/infiniband/acm_prov.h
index 00baf582b74e..adfcf8162b8c 100644
--- a/ibacm/include/infiniband/acm_prov.h
+++ b/ibacm/include/infiniband/acm_prov.h
@@ -85,7 +85,8 @@ int provider_query(struct acm_provider **info, uint32_t *version);
 /* Functions exported from core */
 #define acm_log(level, format, ...) \
 	acm_write(level, "%s: "format, __func__, ## __VA_ARGS__)
-extern void acm_write(int level, const char *format, ...);
+extern void acm_write(int level, const char *format, ...)
+    __attribute__((format(printf, 2, 3)));
 extern void acm_format_name(int level, char *name, size_t name_size,
 	uint8_t addr_type, const uint8_t *addr, size_t addr_size);
 
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 9ec7db44b0d1..fd579dff9d4e 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -55,6 +55,7 @@
 #include <netinet/in.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
+#include <inttypes.h>
 #include "acm_util.h"
 #include "acm_mad.h"
 
@@ -383,7 +384,7 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
 			acmp_remove_dest(ep, dest);
 			dest = NULL;
 		} else {
-			acm_log(2, "Record valid for the next %ld minute(s)\n",
+			acm_log(2, "Record valid for the next %" PRId64 " minute(s)\n",
 				rec_expr_minutes);
 		}
 	}
@@ -411,7 +412,7 @@ static struct acmp_request *acmp_alloc_req(uint64_t id, struct acm_msg *msg)
 
 	req->id = id;
 	memcpy(&req->msg, msg, sizeof(req->msg));
-	acm_log(2, "id %llu, req %p\n", id, req);
+	acm_log(2, "id %" PRIu64 ", req %p\n", id, req);
 	return req;
 }
 
@@ -935,7 +936,7 @@ acmp_resolve_response(uint64_t id, struct acm_msg *req_msg,
 {
 	struct acm_msg msg;
 
-	acm_log(2, "client %lld, status 0x%x\n", id, status);
+	acm_log(2, "client %" PRIu64 ", status 0x%x\n", id, status);
 	memset(&msg, 0, sizeof msg);
 
 	if (dest) {
@@ -981,7 +982,7 @@ acmp_complete_queued_req(struct acmp_dest *dest, uint8_t status)
 		req = container_of(entry, struct acmp_request, entry);
 		lock_release(&dest->lock);
 
-		acm_log(2, "completing request, client %d\n", req->id);
+		acm_log(2, "completing request, client %" PRIu64 "\n", req->id);
 		acmp_resolve_response(req->id, &req->msg, dest, status);
 		acmp_free_req(req);
 
@@ -1016,7 +1017,8 @@ acmp_dest_sa_resp(struct acm_sa_mad *mad)
 		acmp_init_path_av(dest->ep->port, dest);
 		dest->addr_timeout = time_stamp_min() + (unsigned) addr_timeout;
 		dest->route_timeout = time_stamp_min() + (unsigned) route_timeout;
-		acm_log(2, "timeout addr %llu route %llu\n", dest->addr_timeout, dest->route_timeout);
+		acm_log(2, "timeout addr %" PRIu64 " route %" PRIu64 "\n",
+			dest->addr_timeout, dest->route_timeout);
 		dest->state = ACMP_READY;
 	} else {
 		dest->state = ACMP_INIT;
@@ -1726,7 +1728,7 @@ static uint8_t acmp_queue_req(struct acmp_dest *dest, uint64_t id, struct acm_ms
 {
 	struct acmp_request *req;
 
-	acm_log(2, "id %llu\n", id);
+	acm_log(2, "id %" PRIu64 "\n", id);
 	req = acmp_alloc_req(id, msg);
 	if (!req) {
 		return ACM_STATUS_ENOMEM;
@@ -2446,8 +2448,8 @@ static struct acmp_port *acmp_get_port(struct acm_endpoint *endpoint)
 	struct acmp_device *dev;
 	DLIST_ENTRY *dev_entry;
 
-	acm_log(1, "dev 0x%llx port %d pkey 0x%x\n",
-		endpoint->port->dev->dev_guid, endpoint->port->port_num, 
+	acm_log(1, "dev 0x%" PRIx64 " port %d pkey 0x%x\n",
+		endpoint->port->dev->dev_guid, endpoint->port->port_num,
 		endpoint->pkey);
 	for (dev_entry = acmp_dev_list.Next; dev_entry != &acmp_dev_list;
 	     dev_entry = dev_entry->Next) {
@@ -2466,7 +2468,7 @@ acmp_get_ep(struct acmp_port *port, struct acm_endpoint *endpoint)
 	struct acmp_ep *ep;
 	DLIST_ENTRY *entry;
 
-	acm_log(1, "dev 0x%llx port %d pkey 0x%x\n",
+	acm_log(1, "dev 0x%" PRIx64 " port %d pkey 0x%x\n",
 		endpoint->port->dev->dev_guid, endpoint->port->port_num, endpoint->pkey);
 	for (entry = port->ep_list.Next; entry != &port->ep_list;
 	     entry = entry->Next) {
@@ -2769,7 +2771,7 @@ static int acmp_open_dev(const struct acm_device *device, void **dev_context)
 	DLIST_ENTRY *dev_entry;
 	struct ibv_context *verbs;
 
-	acm_log(1, "dev_guid 0x%llx %s\n", device->dev_guid, 
+	acm_log(1, "dev_guid 0x%" PRIx64 " %s\n", device->dev_guid,
 		device->verbs->device->name);
 
 	for (dev_entry = acmp_dev_list.Next; dev_entry != &acmp_dev_list;
@@ -2777,7 +2779,7 @@ static int acmp_open_dev(const struct acm_device *device, void **dev_context)
 		dev = container_of(dev_entry, struct acmp_device, entry);
 
 		if (dev->guid == device->dev_guid) {
-			acm_log(2, "dev_guid 0x%llx already exits\n", 
+			acm_log(2, "dev_guid 0x%" PRIx64 " already exits\n",
 				device->dev_guid);
 			*dev_context = dev;
 			dev->device = device;
@@ -2859,7 +2861,7 @@ static void acmp_close_dev(void *dev_context)
 {
 	struct acmp_device *dev = dev_context;
 
-	acm_log(1, "dev_guid 0x%llx\n", dev->device->dev_guid);
+	acm_log(1, "dev_guid 0x%" PRIx64 "\n", dev->device->dev_guid);
 	dev->device = NULL;
 }
 
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 523b78082ff8..befe94203dd3 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -62,6 +62,7 @@
 #include <rdma/ib_user_sa.h>
 #endif
 #include <poll.h>
+#include <inttypes.h>
 #include "acm_mad.h"
 #include "acm_util.h"
 #ifdef HAVE_NETLINK
@@ -1471,7 +1472,7 @@ static int acm_nl_parse_path_attr(struct nlattr *attr,
 	case LS_NLA_TYPE_SERVICE_ID:
 		sid = (uint64_t *) NLA_DATA(attr);
 		if (NLA_LEN(attr) == sizeof(*sid)) {
-			acm_log(2, "service_id 0x%llx\n", *sid);
+			acm_log(2, "service_id 0x%" PRIx64 "\n", *sid);
 			path->service_id = htonll(*sid);
 		} else {
 			ret = -1;
@@ -2207,7 +2208,7 @@ static void acm_port_get_gid_tbl(struct acmc_port *port)
 					    &port->gid_tbl[j]);
 			if (ret || !port->gid_tbl[j].global.interface_id)
 				break;
-			acm_log(2, "guid %d: 0x%llx %llx\n", j,
+			acm_log(2, "guid %d: 0x%" PRIx64 " %" PRIx64 "\n", j,
 				port->gid_tbl[j].global.subnet_prefix, 
 				port->gid_tbl[j].global.interface_id);
 		}
@@ -2577,8 +2578,8 @@ static void acm_load_prov_config(void)
 			continue;
 		}
 		prefix = strtoull(p, NULL, 0);
-		acm_log(2, "provider %s subnet_prefix 0x%llx\n", prov_name, 
-			prefix);
+		acm_log(2, "provider %s subnet_prefix 0x%" PRIx64 "\n",
+			prov_name, prefix);
 		/* Convert it into network byte order */
 		prefix = htonll(prefix);
 
@@ -2667,8 +2668,8 @@ static int acm_open_providers(void)
 
 		if (version != ACM_PROV_VERSION ||
 		    provider->size != sizeof(struct acm_provider)) {
-			acm_log(0, "Error -unmatched provider version 0x%08x (size %d)"
-				" core 0x%08x (size %d)\n", version, provider->size,
+			acm_log(0, "Error -unmatched provider version 0x%08x (size %zd)"
+				" core 0x%08x (size %zd)\n", version, provider->size,
 				ACM_PROV_VERSION, sizeof(struct acm_provider));
 			dlclose(handle);
 			continue;
@@ -2863,7 +2864,7 @@ static void acmc_recv_mad(struct acmc_port *port)
 	}
 
 	hdr = &resp.sa_mad.mad_hdr;
-	acm_log(2, "bv %x cls %x cv %x mtd %x st %d tid %llx at %x atm %x\n",
+	acm_log(2, "bv %x cls %x cv %x mtd %x st %d tid %" PRIx64 "x at %x atm %x\n",
 		hdr->base_version, hdr->mgmt_class, hdr->class_version,
 		hdr->method, hdr->status, hdr->tid, hdr->attr_id, hdr->attr_mod);
 	found = 0;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
