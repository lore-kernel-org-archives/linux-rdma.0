From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 11/13] ibacm: use ccan/list.h
Date: Mon, 17 Oct 2016 21:11:20 +0200
Message-ID: <1476731482-26491-12-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Trivial conversion, aided by the additional type safety and helpers.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/dlist.h        |  80 ------------------
 ibacm/prov/acmp/src/acmp.c | 141 +++++++++++--------------------
 ibacm/src/acm.c            | 206 ++++++++++++++-------------------------------
 3 files changed, 112 insertions(+), 315 deletions(-)
 delete mode 100644 ibacm/linux/dlist.h

diff --git a/ibacm/linux/dlist.h b/ibacm/linux/dlist.h
deleted file mode 100644
index 89f5af3..0000000
--- a/ibacm/linux/dlist.h
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * Copyright (c) 2009 Intel Corporation. All rights reserved.
- *
- * This software is available to you under the OpenIB.org BSD license
- * below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef _DLIST_H_
-#define _DLIST_H_
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-typedef struct _DLIST_ENTRY {
-	struct _DLIST_ENTRY	*Next;
-	struct _DLIST_ENTRY	*Prev;
-
-}	DLIST_ENTRY;
-
-static void DListInit(DLIST_ENTRY *pHead)
-{
-	pHead->Next = pHead;
-	pHead->Prev = pHead;
-}
-
-static int DListEmpty(DLIST_ENTRY *pHead)
-{
-	return pHead->Next == pHead;
-}
-
-static void DListInsertAfter(DLIST_ENTRY *pNew, DLIST_ENTRY *pHead)
-{
-	pNew->Next = pHead->Next;
-	pNew->Prev = pHead;
-	pHead->Next->Prev = pNew;
-	pHead->Next = pNew;
-}
-
-static void DListInsertBefore(DLIST_ENTRY *pNew, DLIST_ENTRY *pHead)
-{
-	DListInsertAfter(pNew, pHead->Prev);
-}
-
-#define DListInsertHead DListInsertAfter
-#define DListInsertTail DListInsertBefore
-
-static void DListRemove(DLIST_ENTRY *pEntry)
-{
-	pEntry->Prev->Next = pEntry->Next;
-	pEntry->Next->Prev = pEntry->Prev;
-}
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif // _DLIST_H_
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 1cb14e1..1e37ee4 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -45,7 +45,6 @@
 #include <infiniband/umad.h>
 #include <infiniband/verbs.h>
 #include <ifaddrs.h>
-#include <dlist.h>
 #include <dlfcn.h> 
 #include <search.h>
 #include <netdb.h>
@@ -56,6 +55,7 @@
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
 #include <inttypes.h>
+#include <ccan/list.h>
 #include "acm_util.h"
 #include "acm_mad.h"
 
@@ -113,7 +113,7 @@ struct acmp_dest {
 	struct ibv_path_record path;
 	union ibv_gid          mgid;
 	uint64_t               req_id;
-	DLIST_ENTRY            req_queue;
+	struct list_head       req_queue;
 	uint32_t               remote_qpn;
 	pthread_mutex_t        lock;
 	enum acmp_state        state;
@@ -129,7 +129,7 @@ struct acmp_device;
 struct acmp_port {
 	struct acmp_device  *dev;
 	const struct acm_port *port;
-	DLIST_ENTRY         ep_list;
+	struct list_head    ep_list;
 	pthread_mutex_t     lock;
 	struct acmp_dest    sa_dest;
 	enum ibv_port_state state;
@@ -148,7 +148,7 @@ struct acmp_device {
 	struct ibv_comp_channel *channel;
 	struct ibv_pd           *pd;
 	uint64_t                guid;
-	DLIST_ENTRY             entry;
+	struct list_node        entry;
 	pthread_t               comp_thread_id;
 	int                     port_cnt;
 	struct acmp_port        port[0];
@@ -157,7 +157,7 @@ struct acmp_device {
 /* Maintain separate virtual send queues to avoid deadlock */
 struct acmp_send_queue {
 	int                   credits;
-	DLIST_ENTRY           pending;
+	struct list_head      pending;
 };
 
 struct acmp_addr {
@@ -173,7 +173,7 @@ struct acmp_ep {
 	struct ibv_qp         *qp;
 	struct ibv_mr         *mr;
 	uint8_t               *recv_bufs;
-	DLIST_ENTRY           entry;
+	struct list_node      entry;
 	char		      id_string[ACM_MAX_ADDRESS];
 	void                  *dest_map[ACM_ADDRESS_RESERVED - 1];
 	struct acmp_dest      mc_dest[MAX_EP_MC];
@@ -184,15 +184,15 @@ struct acmp_ep {
 	pthread_mutex_t       lock;
 	struct acmp_send_queue resolve_queue;
 	struct acmp_send_queue resp_queue;
-	DLIST_ENTRY           active_queue;
-	DLIST_ENTRY           wait_queue;
+	struct list_head      active_queue;
+	struct list_head      wait_queue;
 	enum acmp_state       state;
 	struct acmp_addr      addr_info[MAX_EP_ADDR];
 	atomic_t              counters[ACM_MAX_COUNTER];
 };
 
 struct acmp_send_msg {
-	DLIST_ENTRY          entry;
+	struct list_node     entry;
 	struct acmp_ep       *ep;
 	struct acmp_dest     *dest;
 	struct ibv_ah        *ah;
@@ -210,7 +210,7 @@ struct acmp_send_msg {
 
 struct acmp_request {
 	uint64_t	id;
-	DLIST_ENTRY	entry;
+	struct list_node entry;
 	struct acm_msg	msg;
 	struct acmp_ep	*ep;
 };
@@ -249,11 +249,11 @@ static struct acm_provider def_prov = {
 	.query_perf = acmp_query_perf,
 };
 
-static DLIST_ENTRY acmp_dev_list;
+static LIST_HEAD(acmp_dev_list);
 static pthread_mutex_t acmp_dev_lock;
 
 static atomic_t g_tid;
-static DLIST_ENTRY timeout_list;
+static LIST_HEAD(timeout_list);
 static event_t timeout_event;
 static atomic_t wait_cnt;
 static pthread_t retry_thread_id;
@@ -301,7 +301,7 @@ static void
 acmp_init_dest(struct acmp_dest *dest, uint8_t addr_type,
 	       const uint8_t *addr, size_t size)
 {
-	DListInit(&dest->req_queue);
+	list_head_init(&dest->req_queue);
 	atomic_init(&dest->refcnt);
 	atomic_set(&dest->refcnt, 1);
 	pthread_mutex_init(&dest->lock, NULL);
@@ -508,11 +508,11 @@ static void acmp_post_send(struct acmp_send_queue *queue, struct acmp_send_msg *
 	if (queue->credits) {
 		acm_log(2, "posting send to QP\n");
 		queue->credits--;
-		DListInsertTail(&msg->entry, &ep->active_queue);
+		list_add_tail(&ep->active_queue, &msg->entry);
 		ibv_post_send(ep->qp, &msg->wr, &bad_wr);
 	} else {
 		acm_log(2, "no sends available, queuing message\n");
-		DListInsertTail(&msg->entry, &queue->pending);
+		list_add_tail(&queue->pending, &msg->entry);
 	}
 	pthread_mutex_unlock(&ep->lock);
 }
@@ -539,17 +539,14 @@ static void acmp_send_available(struct acmp_ep *ep, struct acmp_send_queue *queu
 {
 	struct acmp_send_msg *msg;
 	struct ibv_send_wr *bad_wr;
-	DLIST_ENTRY *entry;
 
-	if (DListEmpty(&queue->pending)) {
-		queue->credits++;
-	} else {
+	msg = list_pop(&queue->pending, struct acmp_send_msg, entry);
+	if (msg) {
 		acm_log(2, "posting queued send message\n");
-		entry = queue->pending.Next;
-		DListRemove(entry);
-		msg = container_of(entry, struct acmp_send_msg, entry);
-		DListInsertTail(&msg->entry, &ep->active_queue);
+		list_add_tail(&ep->active_queue, &msg->entry);
 		ibv_post_send(ep->qp, &msg->wr, &bad_wr);
+	} else {
+		queue->credits++;
 	}
 }
 
@@ -558,11 +555,11 @@ static void acmp_complete_send(struct acmp_send_msg *msg)
 	struct acmp_ep *ep = msg->ep;
 
 	pthread_mutex_lock(&ep->lock);
-	DListRemove(&msg->entry);
+	list_del(&msg->entry);
 	if (msg->tries) {
 		acm_log(2, "waiting for response\n");
 		msg->expires = time_stamp_ms() + ep->port->subnet_timeout + timeout;
-		DListInsertTail(&msg->entry, &ep->wait_queue);
+		list_add_tail(&ep->wait_queue, &msg->entry);
 		if (atomic_inc(&wait_cnt) == 1)
 			event_signal(&timeout_event);
 	} else {
@@ -575,20 +572,17 @@ static void acmp_complete_send(struct acmp_send_msg *msg)
 
 static struct acmp_send_msg *acmp_get_request(struct acmp_ep *ep, uint64_t tid, int *free)
 {
-	struct acmp_send_msg *msg, *req = NULL;
+	struct acmp_send_msg *msg, *next, *req = NULL;
 	struct acm_mad *mad;
-	DLIST_ENTRY *entry, *next;
 
 	acm_log(2, "\n");
 	pthread_mutex_lock(&ep->lock);
-	for (entry = ep->wait_queue.Next; entry != &ep->wait_queue; entry = next) {
-		next = entry->Next;
-		msg = container_of(entry, struct acmp_send_msg, entry);
+	list_for_each_safe(&ep->wait_queue, msg, next, entry) {
 		mad = (struct acm_mad *) msg->data;
 		if (mad->tid == tid) {
 			acm_log(2, "match found in wait queue\n");
 			req = msg;
-			DListRemove(entry);
+			list_del(&msg->entry);
 			(void) atomic_dec(&wait_cnt);
 			acmp_send_available(ep, msg->req_queue);
 			*free = 1;
@@ -596,8 +590,7 @@ static struct acmp_send_msg *acmp_get_request(struct acmp_ep *ep, uint64_t tid,
 		}
 	}
 
-	for (entry = ep->active_queue.Next; entry != &ep->active_queue; entry = entry->Next) {
-		msg = container_of(entry, struct acmp_send_msg, entry);
+	list_for_each(&ep->active_queue, msg, entry) {
 		mad = (struct acm_mad *) msg->data;
 		if (mad->tid == tid && msg->tries) {
 			acm_log(2, "match found in active queue\n");
@@ -972,14 +965,10 @@ static void
 acmp_complete_queued_req(struct acmp_dest *dest, uint8_t status)
 {
 	struct acmp_request *req;
-	DLIST_ENTRY *entry;
 
 	acm_log(2, "status %d\n", status);
 	pthread_mutex_lock(&dest->lock);
-	while (!DListEmpty(&dest->req_queue)) {
-		entry = dest->req_queue.Next;
-		DListRemove(entry);
-		req = container_of(entry, struct acmp_request, entry);
+	while ((req = list_pop(&dest->req_queue, struct acmp_request, entry))) {
 		pthread_mutex_unlock(&dest->lock);
 
 		acm_log(2, "completing request, client %" PRIu64 "\n", req->id);
@@ -1113,7 +1102,7 @@ acmp_process_addr_req(struct acmp_ep *ep, struct ibv_wc *wc, struct acm_mad *mad
 			status = acmp_record_acm_route(ep, dest);
 			break;
 		}
-		if (addr || !DListEmpty(&dest->req_queue)) {
+		if (addr || !list_empty(&dest->req_queue)) {
 			status = acmp_resolve_path_sa(ep, dest, acmp_resolve_sa_resp);
 			if (status)
 				break;
@@ -1458,15 +1447,12 @@ static void acmp_ep_join(struct acmp_ep *ep)
 static int acmp_port_join(void *port_context)
 {
 	struct acmp_ep *ep;
-	DLIST_ENTRY *ep_entry;
 	struct acmp_port *port = port_context;
 
 	acm_log(1, "device %s port %d\n", port->dev->verbs->device->name,
 		port->port_num);
 
-	for (ep_entry = port->ep_list.Next; ep_entry != &port->ep_list;
-		 ep_entry = ep_entry->Next) {
-		ep = container_of(ep_entry, struct acmp_ep, entry);
+	list_for_each(&port->ep_list, ep, entry) {
 		if (!ep->endpoint) {
 			/* Stale endpoint */
 			continue;
@@ -1497,16 +1483,11 @@ static int acmp_handle_event(void *port_context, enum ibv_event_type type)
 
 static void acmp_process_timeouts(void)
 {
-	DLIST_ENTRY *entry;
 	struct acmp_send_msg *msg;
 	struct acm_resolve_rec *rec;
 	struct acm_mad *mad;
-	
-	while (!DListEmpty(&timeout_list)) {
-		entry = timeout_list.Next;
-		DListRemove(entry);
 
-		msg = container_of(entry, struct acmp_send_msg, entry);
+	while ((msg = list_pop(&timeout_list, struct acmp_send_msg, entry))) {
 		mad = (struct acm_mad *) &msg->data[0];
 		rec = (struct acm_resolve_rec *) mad->data;
 
@@ -1521,24 +1502,21 @@ static void acmp_process_timeouts(void)
 
 static void acmp_process_wait_queue(struct acmp_ep *ep, uint64_t *next_expire)
 {
-	struct acmp_send_msg *msg;
-	DLIST_ENTRY *entry, *next;
+	struct acmp_send_msg *msg, *next;
 	struct ibv_send_wr *bad_wr;
 
-	for (entry = ep->wait_queue.Next; entry != &ep->wait_queue; entry = next) {
-		next = entry->Next;
-		msg = container_of(entry, struct acmp_send_msg, entry);
+	list_for_each_safe(&ep->wait_queue, msg, next, entry) {
 		if (msg->expires < time_stamp_ms()) {
-			DListRemove(entry);
+			list_del(&msg->entry);
 			(void) atomic_dec(&wait_cnt);
 			if (--msg->tries) {
 				acm_log(1, "notice - retrying request\n");
-				DListInsertTail(&msg->entry, &ep->active_queue);
+				list_add_tail(&ep->active_queue, &msg->entry);
 				ibv_post_send(ep->qp, &msg->wr, &bad_wr);
 			} else {
 				acm_log(0, "notice - failing request\n");
 				acmp_send_available(ep, msg->req_queue);
-				DListInsertTail(&msg->entry, &timeout_list);
+				list_add_tail(&timeout_list, &msg->entry);
 			}
 		} else {
 			*next_expire = min(*next_expire, msg->expires);
@@ -1556,7 +1534,6 @@ static void *acmp_retry_handler(void *context)
 	struct acmp_device *dev;
 	struct acmp_port *port;
 	struct acmp_ep *ep;
-	DLIST_ENTRY *dev_entry, *ep_entry;
 	uint64_t next_expire;
 	int i, wait;
 
@@ -1579,24 +1556,17 @@ static void *acmp_retry_handler(void *context)
 
 		next_expire = -1;
 		pthread_mutex_lock(&acmp_dev_lock);
-		for (dev_entry = acmp_dev_list.Next; dev_entry != &acmp_dev_list;
-		     dev_entry = dev_entry->Next) {
-
-			dev = container_of(dev_entry, struct acmp_device, entry);
+		list_for_each(&acmp_dev_list, dev, entry) {
 			pthread_mutex_unlock(&acmp_dev_lock);
 
 			for (i = 0; i < dev->port_cnt; i++) {
 				port = &dev->port[i];
 
 				pthread_mutex_lock(&port->lock);
-				for (ep_entry = port->ep_list.Next;
-				     ep_entry != &port->ep_list;
-				     ep_entry = ep_entry->Next) {
-
-					ep = container_of(ep_entry, struct acmp_ep, entry);
+				list_for_each(&port->ep_list, ep, entry) {
 					pthread_mutex_unlock(&port->lock);
 					pthread_mutex_lock(&ep->lock);
-					if (!DListEmpty(&ep->wait_queue))
+					if (!list_empty(&ep->wait_queue))
 						acmp_process_wait_queue(ep, &next_expire);
 					pthread_mutex_unlock(&ep->lock);
 					pthread_mutex_lock(&port->lock);
@@ -1735,7 +1705,7 @@ static uint8_t acmp_queue_req(struct acmp_dest *dest, uint64_t id, struct acm_ms
 	}
 	req->ep = dest->ep;
 
-	DListInsertTail(&req->entry, &dest->req_queue);
+	list_add_tail(&dest->req_queue, &req->entry);
 	return ACM_STATUS_SUCCESS;
 }
 
@@ -2446,15 +2416,12 @@ static void acmp_remove_addr(void *addr_context)
 static struct acmp_port *acmp_get_port(struct acm_endpoint *endpoint)
 {
 	struct acmp_device *dev;
-	DLIST_ENTRY *dev_entry;
 
 	acm_log(1, "dev 0x%" PRIx64 " port %d pkey 0x%x\n",
 		endpoint->port->dev->dev_guid, endpoint->port->port_num,
 		endpoint->pkey);
-	for (dev_entry = acmp_dev_list.Next; dev_entry != &acmp_dev_list;
-	     dev_entry = dev_entry->Next) {
 
-		dev = container_of(dev_entry, struct acmp_device, entry);
+	list_for_each(&acmp_dev_list, dev, entry) {
 		if (dev->guid == endpoint->port->dev->dev_guid)
 			return &dev->port[endpoint->port->port_num - 1];
 	}
@@ -2466,13 +2433,11 @@ static struct acmp_ep *
 acmp_get_ep(struct acmp_port *port, struct acm_endpoint *endpoint)
 {
 	struct acmp_ep *ep;
-	DLIST_ENTRY *entry;
 
 	acm_log(1, "dev 0x%" PRIx64 " port %d pkey 0x%x\n",
 		endpoint->port->dev->dev_guid, endpoint->port->port_num, endpoint->pkey);
-	for (entry = port->ep_list.Next; entry != &port->ep_list;
-	     entry = entry->Next) {
-		ep = container_of(entry, struct acmp_ep, entry);
+
+	list_for_each(&port->ep_list, ep, entry) {
 		if (ep->pkey == endpoint->pkey)
 			return ep;
 	}
@@ -2526,10 +2491,10 @@ acmp_alloc_ep(struct acmp_port *port, struct acm_endpoint *endpoint)
 	ep->pkey = endpoint->pkey;
 	ep->resolve_queue.credits = resolve_depth;
 	ep->resp_queue.credits = send_depth;
-	DListInit(&ep->resolve_queue.pending);
-	DListInit(&ep->resp_queue.pending);
-	DListInit(&ep->active_queue);
-	DListInit(&ep->wait_queue);
+	list_head_init(&ep->resolve_queue.pending);
+	list_head_init(&ep->resp_queue.pending);
+	list_head_init(&ep->active_queue);
+	list_head_init(&ep->wait_queue);
 	pthread_mutex_init(&ep->lock, NULL);
 	sprintf(ep->id_string, "%s-%d-0x%x", port->dev->verbs->device->name,
 		port->port_num, endpoint->pkey);
@@ -2628,7 +2593,7 @@ static int acmp_open_endpoint(const struct acm_endpoint *endpoint,
 		goto err2;
 
 	pthread_mutex_lock(&port->lock);
-	DListInsertHead(&ep->entry, &port->ep_list);
+	list_add(&port->ep_list, &ep->entry);
 	pthread_mutex_unlock(&port->lock);
 	acmp_ep_preload(ep);
 	acmp_ep_join(ep);
@@ -2757,7 +2722,7 @@ static void acmp_init_port(struct acmp_port *port, struct acmp_device *dev,
 	port->dev = dev;
 	port->port_num = port_num;
 	pthread_mutex_init(&port->lock, NULL);
-	DListInit(&port->ep_list);
+	list_head_init(&port->ep_list);
 	acmp_init_dest(&port->sa_dest, ACM_ADDRESS_LID, NULL, 0);
 	port->state = IBV_PORT_DOWN;
 }
@@ -2768,16 +2733,12 @@ static int acmp_open_dev(const struct acm_device *device, void **dev_context)
 	size_t size;
 	struct ibv_device_attr attr;
 	int i, ret;
-	DLIST_ENTRY *dev_entry;
 	struct ibv_context *verbs;
 
 	acm_log(1, "dev_guid 0x%" PRIx64 " %s\n", device->dev_guid,
 		device->verbs->device->name);
 
-	for (dev_entry = acmp_dev_list.Next; dev_entry != &acmp_dev_list;
-	     dev_entry = dev_entry->Next) {
-		dev = container_of(dev_entry, struct acmp_device, entry);
-
+	list_for_each(&acmp_dev_list, dev, entry) {
 		if (dev->guid == device->dev_guid) {
 			acm_log(2, "dev_guid 0x%" PRIx64 " already exits\n",
 				device->dev_guid);
@@ -2839,7 +2800,7 @@ static int acmp_open_dev(const struct acm_device *device, void **dev_context)
 	}
 
 	pthread_mutex_lock(&acmp_dev_lock);
-	DListInsertHead(&dev->entry, &acmp_dev_list);
+	list_add(&acmp_dev_list, &dev->entry);
 	pthread_mutex_unlock(&acmp_dev_lock);
 	dev->guid = device->dev_guid;
 	*dev_context = dev;
@@ -2947,9 +2908,7 @@ static void __attribute__((constructor)) acmp_init(void)
 
 	atomic_init(&g_tid);
 	atomic_init(&wait_cnt);
-	DListInit(&acmp_dev_list);
 	pthread_mutex_init(&acmp_dev_lock, NULL);
-	DListInit(&timeout_list);
 	event_init(&timeout_event);
 
 	umad_init();
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 37bbbe7..0571363 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -46,7 +46,6 @@
 #include <infiniband/verbs.h>
 #include <infiniband/umad_types.h>
 #include <infiniband/umad_sa.h>
-#include <dlist.h>
 #include <dlfcn.h> 
 #include <search.h>
 #include <net/if.h>
@@ -59,6 +58,7 @@
 #include <rdma/ib_user_sa.h>
 #include <poll.h>
 #include <inttypes.h>
+#include <ccan/list.h>
 #include "acm_mad.h"
 #include "acm_util.h"
 #if !defined(RDMA_NL_LS_F_ERR)
@@ -75,19 +75,19 @@
 #define NL_CLIENT_INDEX 0
 
 struct acmc_subnet {
-	DLIST_ENTRY            entry;
+	struct list_node       entry;
 	uint64_t               subnet_prefix;
 };
 
 struct acmc_prov {
 	struct acm_provider    *prov;
 	void                   *handle; 
-	DLIST_ENTRY            entry;   
-	DLIST_ENTRY            subnet_list;
+	struct list_node       entry;   
+	struct list_head       subnet_list;
 };
 
 struct acmc_prov_context {
-	DLIST_ENTRY             entry;
+	struct list_node        entry;
 	atomic_t                refcnt;
 	struct acm_provider     *prov;
 	void                    *context;
@@ -103,11 +103,11 @@ struct acmc_port {
 	int		    mad_portid;
 	int		    mad_agentid;
 	struct ib_mad_addr  sa_addr;
-	DLIST_ENTRY         sa_pending;
-	DLIST_ENTRY	    sa_wait;
+	struct list_head    sa_pending;
+	struct list_head    sa_wait;
 	int		    sa_credits;
 	pthread_mutex_t     lock;
-	DLIST_ENTRY         ep_list;
+	struct list_head    ep_list;
 	enum ibv_port_state state;
 	int                 gid_cnt;
 	union ibv_gid       *gid_tbl;
@@ -119,8 +119,8 @@ struct acmc_port {
 
 struct acmc_device {
 	struct acm_device       device;
-	DLIST_ENTRY             entry;
-	DLIST_ENTRY             prov_dev_context_list;
+	struct list_node        entry;
+	struct list_head        prov_dev_context_list;
 	int                     port_cnt;
 	struct acmc_port        port[0];
 };
@@ -136,7 +136,7 @@ struct acmc_ep {
 	struct acm_endpoint   endpoint;
 	void                  *prov_ep_context;
 	struct acmc_addr      addr_info[MAX_EP_ADDR];
-	DLIST_ENTRY	      entry;
+	struct list_node      entry;
 };
 
 struct acmc_client {
@@ -153,7 +153,7 @@ union socket_addr {
 };
 
 struct acmc_sa_req {
-	DLIST_ENTRY		entry;
+	struct list_node	entry;
 	struct acmc_ep		*ep;
 	void			(*resp_handler)(struct acm_sa_mad *);
 	struct acm_sa_mad	mad;
@@ -175,10 +175,10 @@ struct acm_nl_msg {
 };
 
 static char def_prov_name[ACM_PROV_NAME_SIZE] = "ibacmp";
-static DLIST_ENTRY provider_list;
+static LIST_HEAD(provider_list);
 static struct acmc_prov *def_provider = NULL;
 
-static DLIST_ENTRY dev_list;
+static LIST_HEAD(dev_list);
 
 static int listen_socket;
 static int ip_mon_socket;
@@ -308,13 +308,11 @@ acm_alloc_prov_context(struct acm_provider *prov)
 }
 
 static struct acmc_prov_context * 
-acm_get_prov_context(DLIST_ENTRY *list, struct acm_provider *prov)
+acm_get_prov_context(struct list_head *list, struct acm_provider *prov)
 {
-	DLIST_ENTRY *entry;
 	struct acmc_prov_context *ctx;
 
-	for (entry = list->Next; entry != list; entry = entry->Next) {
-		ctx = container_of(entry, struct acmc_prov_context, entry);
+	list_for_each(list, ctx, entry) {
 		if (ctx->prov == prov) {
 			return ctx;
 		}
@@ -324,7 +322,7 @@ acm_get_prov_context(DLIST_ENTRY *list, struct acm_provider *prov)
 }
 
 static struct acmc_prov_context *
-acm_acquire_prov_context(DLIST_ENTRY *list, struct acm_provider *prov)
+acm_acquire_prov_context(struct list_head *list, struct acm_provider *prov)
 {
 	struct acmc_prov_context *ctx;
 
@@ -335,7 +333,7 @@ acm_acquire_prov_context(DLIST_ENTRY *list, struct acm_provider *prov)
 			acm_log(0, "Error -- failed to allocate provider context\n");
 			return NULL;
 		}
-		DListInsertTail(&ctx->entry, list);
+		list_add_tail(list, &ctx->entry);
 	} else {
 		atomic_inc(&ctx->refcnt);
 	}
@@ -347,7 +345,7 @@ static void
 acm_release_prov_context(struct acmc_prov_context *ctx)
 {
 	if (atomic_dec(&ctx->refcnt) <= 0) {
-		DListRemove(&ctx->entry);
+		list_del(&ctx->entry);
 		free(ctx);
 	}
 }
@@ -679,7 +677,6 @@ acm_get_port_ep_address(struct acmc_port *port, struct acm_ep_addr_data *data)
 {
 	struct acmc_ep *ep;
 	struct acm_address *addr;
-	DLIST_ENTRY *ep_entry;
 	int i;
 
 	if (port->state != IBV_PORT_ACTIVE)
@@ -689,10 +686,7 @@ acm_get_port_ep_address(struct acmc_port *port, struct acm_ep_addr_data *data)
 	    !acm_is_path_from_port(port, &data->info.path))
 		return NULL;
 
-	for (ep_entry = port->ep_list.Next; ep_entry != &port->ep_list;
-	     ep_entry = ep_entry->Next) {
-
-		ep = container_of(ep_entry, struct acmc_ep, entry);
+	list_for_each(&port->ep_list, ep, entry) {
 		if ((data->type == ACM_EP_INFO_PATH) &&
 		    (!data->info.path.pkey ||
 		     (ntohs(data->info.path.pkey) == ep->endpoint.pkey))) {
@@ -715,16 +709,12 @@ static struct acmc_addr *acm_get_ep_address(struct acm_ep_addr_data *data)
 {
 	struct acmc_device *dev;
 	struct acmc_addr *addr;
-	DLIST_ENTRY *dev_entry;
 	int i;
 
 	acm_format_name(2, log_data, sizeof log_data,
 			data->type, data->info.addr, sizeof data->info.addr);
 	acm_log(2, "%s\n", log_data);
-	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-		 dev_entry = dev_entry->Next) {
-
-		dev = container_of(dev_entry, struct acmc_device, entry);
+	list_for_each(&dev_list, dev, entry) {
 		for (i = 0; i < dev->port_cnt; i++) {
 			addr = acm_get_port_ep_address(&dev->port[i], data);
 			if (addr)
@@ -741,27 +731,17 @@ static struct acmc_addr *acm_get_ep_address(struct acm_ep_addr_data *data)
 static struct acmc_ep *acm_get_ep(int index)
 {
 	struct acmc_device *dev;
-	DLIST_ENTRY *dev_entry;
 	struct acmc_ep *ep;
-	DLIST_ENTRY *ep_entry;
 	int i, inx = 0;
 
 	acm_log(2, "ep index %d\n", index);
-	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-	     dev_entry = dev_entry->Next) {
-		dev = container_of(dev_entry, struct acmc_device, entry);
+	list_for_each(&dev_list, dev, entry) {
 		for (i = 0; i < dev->port_cnt; i++) {
 			if (dev->port[i].state != IBV_PORT_ACTIVE)
 				continue;
-			for (ep_entry = dev->port[i].ep_list.Next; 
-			     ep_entry != &dev->port[i].ep_list;
-			     ep_entry = ep_entry->Next, inx++) {
-				if (index == inx) {
-					ep = container_of(ep_entry, 
-							  struct acmc_ep, 
-							  entry);
+			list_for_each(&dev->port[i].ep_list, ep, entry) {
+				if (index == inx)
 					return ep;
-				}
 			}
 		}
 	}
@@ -1271,27 +1251,19 @@ static void acm_ip_iter_cb(char *ifname, union ibv_gid *gid, uint16_t pkey,
  */
 static int resync_system_ips(void)
 {
-	DLIST_ENTRY *dev_entry;
 	struct acmc_device *dev;
 	struct acmc_port *port;
 	struct acmc_ep *ep;
-	DLIST_ENTRY *entry;
 	int i, cnt;
 
 	acm_log(0, "Resyncing all IP's\n");
 
 	/* mark all IP's invalid */
-	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-	     dev_entry = dev_entry->Next) {
-		dev = container_of(dev_entry, struct acmc_device, entry);
-
+	list_for_each(&dev_list, dev, entry) {
 		for (cnt = 0; cnt < dev->port_cnt; cnt++) {
 			port = &dev->port[cnt];
 
-			for (entry = port->ep_list.Next; entry != &port->ep_list;
-			     entry = entry->Next) {
-				ep = container_of(entry, struct acmc_ep, entry);
-
+			list_for_each(&port->ep_list, ep, entry) {
 				for (i = 0; i < MAX_EP_ADDR; i++) {
 					if (ep->addr_info[i].addr.type == ACM_ADDRESS_IP ||
 					    ep->addr_info[i].addr.type == ACM_ADDRESS_IP6)
@@ -1703,7 +1675,6 @@ static void acm_server(void)
 	fd_set readfds;
 	int i, n, ret;
 	struct acmc_device *dev;
-	DLIST_ENTRY *dev_entry;
 
 	acm_log(0, "started\n");
 	acm_init_server();
@@ -1731,9 +1702,7 @@ static void acm_server(void)
 			}
 		}
 
-		for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-		     dev_entry = dev_entry->Next) {
-			dev = container_of(dev_entry, struct acmc_device, entry);
+		list_for_each(&dev_list, dev, entry) {
 			FD_SET(dev->device.verbs->async_fd, &readfds);
 			n = max(n, (int) dev->device.verbs->async_fd);
 		}
@@ -1761,9 +1730,7 @@ static void acm_server(void)
 			}
 		}
 
-		for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-		     dev_entry = dev_entry->Next) {
-			dev = container_of(dev_entry, struct acmc_device, entry);
+		list_for_each(&dev_list, dev, entry) {
 			if (FD_ISSET(dev->device.verbs->async_fd, &readfds)) {
 				acm_log(2, "handling event from %s\n", 
 					dev->device.verbs->device->name);
@@ -1907,15 +1874,10 @@ out:
 static struct acmc_device *
 acm_get_device_from_gid(union ibv_gid *sgid, uint8_t *port)
 {
-	DLIST_ENTRY *dev_entry;
 	struct acmc_device *dev;
 	int i;
 
-	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-		 dev_entry = dev_entry->Next) {
-
-		dev = container_of(dev_entry, struct acmc_device, entry);
-
+	list_for_each(&dev_list, dev, entry) {
 		for (*port = 1; *port <= dev->port_cnt; (*port)++) {
 
 			for (i = 0; i < dev->port[*port - 1].gid_cnt; i++) {
@@ -2032,12 +1994,10 @@ out:
 static struct acmc_ep *acm_find_ep(struct acmc_port *port, uint16_t pkey)
 {
 	struct acmc_ep *ep, *res = NULL;
-	DLIST_ENTRY *entry;
 
 	acm_log(2, "pkey 0x%x\n", pkey);
 
-	for (entry = port->ep_list.Next; entry != &port->ep_list; entry = entry->Next) {
-		ep = container_of(entry, struct acmc_ep, entry);
+	list_for_each(&port->ep_list, ep, entry) {
 		if (ep->endpoint.pkey == pkey) {
 			res = ep;
 			break;
@@ -2111,7 +2071,7 @@ static void acm_ep_up(struct acmc_port *port, uint16_t pkey)
 		goto ep_close;
 	}
 
-	DListInsertHead(&ep->entry, &port->ep_list);
+	list_add(&port->ep_list, &ep->entry);
 	return;
 
 ep_close:
@@ -2123,22 +2083,13 @@ ep_close:
 
 static void acm_assign_provider(struct acmc_port *port)
 {
-	DLIST_ENTRY *entry;
 	struct acmc_prov *prov;
-	DLIST_ENTRY *sub_entry;
 	struct acmc_subnet *subnet;
 
 	acm_log(2, "port %s/%d\n", port->port.dev->verbs->device->name, 
 		port->port.port_num);
-	for (entry = provider_list.Next; entry != &provider_list; 
-	     entry = entry->Next) {
-		prov = container_of(entry, struct acmc_prov, entry);
-
-		for (sub_entry = prov->subnet_list.Next; 
-		     sub_entry != &prov->subnet_list; 
-		     sub_entry = sub_entry->Next) {
-			subnet = container_of(sub_entry, struct acmc_subnet,
-					      entry);
+	list_for_each(&provider_list, prov, entry) {
+		list_for_each(&prov->subnet_list, subnet, entry) {
 			if (subnet->subnet_prefix == 
 			    port->gid_tbl[0].global.subnet_prefix) {
 				acm_log(2, "Found provider %s for port %s/%d\n",
@@ -2291,16 +2242,11 @@ err1:
 
 static void acm_shutdown_port(struct acmc_port *port)
 {
-	DLIST_ENTRY *entry;
 	struct acmc_ep *ep;
 	struct acmc_prov_context *dev_ctx;
 
-	while (!DListEmpty(&port->ep_list)) {
-		entry = port->ep_list.Next;
-		DListRemove(entry);
-		ep = container_of(entry, struct acmc_ep, entry);
+	while ((ep = list_pop(&port->ep_list, struct acmc_ep, entry)))
 		acm_ep_down(ep);
-	}
 
 	if (port->prov_port_context) {
 		port->prov->close_port(port->prov_port_context);
@@ -2404,14 +2350,10 @@ static void acm_event_handler(struct acmc_device *dev)
 static void acm_activate_devices(void)
 {
 	struct acmc_device *dev;
-	DLIST_ENTRY *dev_entry;
 	int i;
 
 	acm_log(1, "\n");
-	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-		dev_entry = dev_entry->Next) {
-
-		dev = container_of(dev_entry, struct acmc_device, entry);
+	list_for_each(&dev_list, dev, entry) {
 		for (i = 0; i < dev->port_cnt; i++) {
 			acm_port_up(&dev->port[i]);
 		}
@@ -2426,9 +2368,9 @@ acm_open_port(struct acmc_port *port, struct acmc_device *dev, uint8_t port_num)
 	port->port.dev = &dev->device;
 	port->port.port_num = port_num;
 	pthread_mutex_init(&port->lock, NULL);
-	DListInit(&port->ep_list);
-	DListInit(&port->sa_pending);
-	DListInit(&port->sa_wait);
+	list_head_init(&port->ep_list);
+	list_head_init(&port->sa_pending);
+	list_head_init(&port->sa_wait);
 	port->sa_credits = sa.depth;
 	port->sa_addr.qpn = htonl(1);
 	port->sa_addr.qkey = htonl(ACM_QKEY);
@@ -2475,13 +2417,13 @@ static void acm_open_dev(struct ibv_device *ibdev)
 	dev->device.verbs = verbs;
 	dev->device.dev_guid = ibv_get_device_guid(ibdev);
 	dev->port_cnt = attr.phys_port_cnt;
-	DListInit(&dev->prov_dev_context_list);
+	list_head_init(&dev->prov_dev_context_list);
 
 	for (i = 0; i < dev->port_cnt; i++) {
 		acm_open_port(&dev->port[i], dev, i + 1);
 	}
 
-	DListInsertHead(&dev->entry, &dev_list);
+	list_add(&dev_list, &dev->entry);
 
 	acm_log(1, "%s opened\n", ibdev->name);
 	return;
@@ -2507,7 +2449,7 @@ static int acm_open_devices(void)
 		acm_open_dev(ibdev[i]);
 
 	ibv_free_device_list(ibdev);
-	if (DListEmpty(&dev_list)) {
+	if (list_empty(&dev_list)) {
 		acm_log(0, "ERROR - no devices\n");
 		return -1;
 	}
@@ -2523,7 +2465,6 @@ static void acm_load_prov_config(void)
 	char prov_name[ACM_PROV_NAME_SIZE];
 	uint64_t prefix;
 	struct acmc_prov *prov;
-	DLIST_ENTRY *entry;
 	struct acmc_subnet *subnet;
 
 	if (!(fd = fopen(opts_file, "r")))
@@ -2562,9 +2503,7 @@ static void acm_load_prov_config(void)
 		/* Convert it into network byte order */
 		prefix = htonll(prefix);
 
-		for (entry = provider_list.Next; entry != &provider_list; 
-		     entry = entry->Next) {
-			prov = container_of(entry, struct acmc_prov, entry);
+		list_for_each(&provider_list, prov, entry) {
 			if (!strcasecmp(prov->prov->name, prov_name)) {
 				subnet = calloc(1, sizeof (*subnet));
 				if (!subnet) {
@@ -2572,17 +2511,15 @@ static void acm_load_prov_config(void)
 					return;
 				}
 				subnet->subnet_prefix = prefix;
-				DListInsertTail(&subnet->entry, 
-						&prov->subnet_list);
+				list_add_after(&provider_list, &prov->entry,
+						&subnet->entry);
 			}
 		}
 	}
 
 	fclose(fd);
 
-	for (entry = provider_list.Next; entry != &provider_list; 
-	     entry = entry->Next) {
-		prov = container_of(entry, struct acmc_prov, entry);
+	list_for_each(&provider_list, prov, entry) {
 		if (!strcasecmp(prov->prov->name, def_prov_name)) {
 			def_provider = prov;
 			break;
@@ -2665,8 +2602,8 @@ static int acm_open_providers(void)
 
 		prov->prov = provider;
 		prov->handle = handle;
-		DListInit(&prov->subnet_list);
-		DListInsertTail(&prov->entry, &provider_list);
+		list_head_init(&prov->subnet_list);
+		list_add_tail(&provider_list, &prov->entry);
 		if (!strcasecmp(provider->name, def_prov_name)) 
 			def_provider = prov;
 	}
@@ -2679,23 +2616,15 @@ static int acm_open_providers(void)
 static void acm_close_providers(void)
 {
 	struct acmc_prov *prov;
-	DLIST_ENTRY *entry;
-	DLIST_ENTRY *sub_entry;
 	struct acmc_subnet *subnet;
 
 	acm_log(1, "\n");
 	def_provider = NULL;
-	while (!DListEmpty(&provider_list)) {
-		entry = provider_list.Next;
-		DListRemove(entry);
-		prov = container_of(entry, struct acmc_prov, entry);
-		while (!DListEmpty(&prov->subnet_list)) {
-			sub_entry = prov->subnet_list.Next;
-			DListRemove(sub_entry);
-			subnet = container_of(sub_entry, struct acmc_subnet,
-					      entry);
+
+	while ((prov = list_pop(&provider_list, struct acmc_prov, entry))) {
+		while ((subnet = list_pop(&prov->subnet_list,
+				struct acmc_subnet, entry)))
 			free(subnet);
-		}
 		dlclose(prov->handle);
 		free(prov);
 	}
@@ -2704,23 +2633,17 @@ static void acm_close_providers(void)
 static int acmc_init_sa_fds(void)
 {
 	struct acmc_device *dev;
-	DLIST_ENTRY *dev_entry;
 	int ret, p, i = 0;
 
-	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-	     dev_entry = dev_entry->Next) {
-		dev = container_of(dev_entry, struct acmc_device, entry);
+	list_for_each(&dev_list, dev, entry)
 		sa.nfds += dev->port_cnt;
-	}
 
 	sa.fds = calloc(sa.nfds, sizeof(*sa.fds));
 	sa.ports = calloc(sa.nfds, sizeof(*sa.ports));
 	if (!sa.fds || !sa.ports)
 		return -ENOMEM;
 
-	for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-	     dev_entry = dev_entry->Next) {
-		dev = container_of(dev_entry, struct acmc_device, entry);
+	list_for_each(&dev_list, dev, entry) {
 		for (p = 0; p < dev->port_cnt; p++) {
 			sa.fds[i].fd = umad_get_fd(dev->port[p].mad_portid);
 			sa.fds[i].events = POLLIN;
@@ -2784,16 +2707,16 @@ int acm_send_sa_mad(struct acm_sa_mad *mad)
 	mad->umad.addr.pkey_index = req->ep->port->sa_pkey_index;
 
 	pthread_mutex_lock(&port->lock);
-	if (port->sa_credits && DListEmpty(&port->sa_wait)) {
+	if (port->sa_credits && list_empty(&port->sa_wait)) {
 		ret = umad_send(port->mad_portid, port->mad_agentid, &mad->umad,
 				sizeof mad->sa_mad, sa.timeout, sa.retries);
 		if (!ret) {
 			port->sa_credits--;
-			DListInsertTail(&req->entry, &port->sa_pending);
+			list_add_tail(&port->sa_pending, &req->entry);
 		}
 	} else {
 		ret = 0;
-		DListInsertTail(&req->entry, &port->sa_wait);
+		list_add_tail(&port->sa_wait, &req->entry);
 	}
 	pthread_mutex_unlock(&port->lock);
 	return ret;
@@ -2805,18 +2728,18 @@ static void acmc_send_queued_req(struct acmc_port *port)
 	int ret;
 
 	pthread_mutex_lock(&port->lock);
-	if (DListEmpty(&port->sa_wait) || !port->sa_credits) {
+	if (list_empty(&port->sa_wait) || !port->sa_credits) {
 		pthread_mutex_unlock(&port->lock);
 		return;
 	}
 
-	req = container_of(port->sa_wait.Next, struct acmc_sa_req, entry);
-	DListRemove(&req->entry);
+	req = list_pop(&port->sa_wait, struct acmc_sa_req, entry);
+
 	ret = umad_send(port->mad_portid, port->mad_agentid, &req->mad.umad,
 			sizeof req->mad.sa_mad, sa.timeout, sa.retries);
 	if (!ret) {
 		port->sa_credits--;
-		DListInsertTail(&req->entry, &port->sa_pending);
+		list_add_tail(&port->sa_pending, &req->entry);
 	}
 	pthread_mutex_unlock(&port->lock);
 
@@ -2830,7 +2753,6 @@ static void acmc_recv_mad(struct acmc_port *port)
 {
 	struct acmc_sa_req *req;
 	struct acm_sa_mad resp;
-	DLIST_ENTRY *entry;
 	int ret, len, found;
 	struct umad_hdr *hdr;
 
@@ -2848,13 +2770,11 @@ static void acmc_recv_mad(struct acmc_port *port)
 		hdr->method, hdr->status, hdr->tid, hdr->attr_id, hdr->attr_mod);
 	found = 0;
 	pthread_mutex_lock(&port->lock);
-	for (entry = port->sa_pending.Next; entry != &port->sa_pending;
-	     entry = entry->Next) {
-		req = container_of(entry, struct acmc_sa_req, entry);
+	list_for_each(&port->sa_pending, req, entry) {
 		/* The lower 32-bit of the tid is used for agentid in umad */
 		if (req->mad.sa_mad.mad_hdr.tid == (hdr->tid & 0xFFFFFFFF00000000)) {
 			found = 1;
-			DListRemove(entry);
+			list_del(&req->entry);
 			port->sa_credits++;
 			break;
 		}
@@ -3086,8 +3006,6 @@ int main(int argc, char **argv)
 	acm_log(0, "Assistant to the InfiniBand Communication Manager\n");
 	acm_log_options();
 
-	DListInit(&provider_list);
-	DListInit(&dev_list);
 	for (i = 0; i < ACM_MAX_COUNTER; i++)
 		atomic_init(&counter[i]);
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
