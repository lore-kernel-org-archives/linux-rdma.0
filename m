From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/13] ibacm: use pthread_mutex_t directly
Date: Mon, 17 Oct 2016 21:11:11 +0200
Message-ID: <1476731482-26491-3-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/libacm_linux.c |   4 +-
 ibacm/linux/osd.h          |   5 --
 ibacm/prov/acmp/src/acmp.c | 132 ++++++++++++++++++++++-----------------------
 ibacm/src/acm.c            |  42 +++++++--------
 ibacm/src/libacm.c         |  22 ++++----
 5 files changed, 100 insertions(+), 105 deletions(-)

diff --git a/ibacm/linux/libacm_linux.c b/ibacm/linux/libacm_linux.c
index a3f6715..2b8a910 100644
--- a/ibacm/linux/libacm_linux.c
+++ b/ibacm/linux/libacm_linux.c
@@ -29,9 +29,9 @@
 
 #include <osd.h>
 
-lock_t lock;
+pthread_mutex_t lock;
 
 static void __attribute__((constructor)) lib_init(void)
 {
-	lock_init(&lock);
+	pthread_mutex_init(&lock, NULL);
 }
diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index c1e7d99..3580cc3 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -115,11 +115,6 @@ static inline int event_wait(event_t *e, int timeout)
 	return ret;
 }
 
-#define lock_t       pthread_mutex_t
-#define lock_init(x) pthread_mutex_init(x, NULL)
-#define lock_acquire pthread_mutex_lock
-#define lock_release pthread_mutex_unlock
-
 #define osd_init()  0
 #define osd_close()
 
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 806320f..24d2b70 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -115,7 +115,7 @@ struct acmp_dest {
 	uint64_t               req_id;
 	DLIST_ENTRY            req_queue;
 	uint32_t               remote_qpn;
-	lock_t                 lock;
+	pthread_mutex_t        lock;
 	enum acmp_state        state;
 	atomic_t               refcnt;
 	uint64_t	       addr_timeout;
@@ -130,7 +130,7 @@ struct acmp_port {
 	struct acmp_device  *dev;
 	const struct acm_port *port;
 	DLIST_ENTRY         ep_list;
-	lock_t              lock;
+	pthread_mutex_t     lock;
 	struct acmp_dest    sa_dest;
 	enum ibv_port_state state;
 	enum ibv_mtu        mtu;
@@ -181,7 +181,7 @@ struct acmp_ep {
 	uint16_t              pkey_index;
 	uint16_t	      pkey;
 	const struct acm_endpoint *endpoint;
-	lock_t                lock;
+	pthread_mutex_t       lock;
 	struct acmp_send_queue resolve_queue;
 	struct acmp_send_queue resp_queue;
 	DLIST_ENTRY           active_queue;
@@ -250,7 +250,7 @@ static struct acm_provider def_prov = {
 };
 
 static DLIST_ENTRY acmp_dev_list;
-static lock_t acmp_dev_lock;
+static pthread_mutex_t acmp_dev_lock;
 
 static atomic_t g_tid;
 static DLIST_ENTRY timeout_list;
@@ -304,7 +304,7 @@ acmp_init_dest(struct acmp_dest *dest, uint8_t addr_type,
 	DListInit(&dest->req_queue);
 	atomic_init(&dest->refcnt);
 	atomic_set(&dest->refcnt, 1);
-	lock_init(&dest->lock);
+	pthread_mutex_init(&dest->lock, NULL);
 	if (size)
 		acmp_set_dest_addr(dest, addr_type, addr, size);
 	dest->state = ACMP_INIT;
@@ -374,7 +374,7 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
 	acm_format_name(2, log_data, sizeof log_data,
 			addr_type, addr, ACM_MAX_ADDRESS);
 	acm_log(2, "%s\n", log_data);
-	lock_acquire(&ep->lock);
+	pthread_mutex_lock(&ep->lock);
 	dest = acmp_get_dest(ep, addr_type, addr);
 	if (dest && dest->state == ACMP_READY &&
 	    dest->addr_timeout != (uint64_t)~0ULL) {
@@ -396,7 +396,7 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
 			(void) atomic_inc(&dest->refcnt);
 		}
 	}
-	lock_release(&ep->lock);
+	pthread_mutex_unlock(&ep->lock);
 	return dest;
 }
 
@@ -504,7 +504,7 @@ static void acmp_post_send(struct acmp_send_queue *queue, struct acmp_send_msg *
 	struct ibv_send_wr *bad_wr;
 
 	msg->req_queue = queue;
-	lock_acquire(&ep->lock);
+	pthread_mutex_lock(&ep->lock);
 	if (queue->credits) {
 		acm_log(2, "posting send to QP\n");
 		queue->credits--;
@@ -514,7 +514,7 @@ static void acmp_post_send(struct acmp_send_queue *queue, struct acmp_send_msg *
 		acm_log(2, "no sends available, queuing message\n");
 		DListInsertTail(&msg->entry, &queue->pending);
 	}
-	lock_release(&ep->lock);
+	pthread_mutex_unlock(&ep->lock);
 }
 
 static void acmp_post_recv(struct acmp_ep *ep, uint64_t address)
@@ -557,7 +557,7 @@ static void acmp_complete_send(struct acmp_send_msg *msg)
 {
 	struct acmp_ep *ep = msg->ep;
 
-	lock_acquire(&ep->lock);
+	pthread_mutex_lock(&ep->lock);
 	DListRemove(&msg->entry);
 	if (msg->tries) {
 		acm_log(2, "waiting for response\n");
@@ -570,7 +570,7 @@ static void acmp_complete_send(struct acmp_send_msg *msg)
 		acmp_send_available(ep, msg->req_queue);
 		acmp_free_send(msg);
 	}
-	lock_release(&ep->lock);
+	pthread_mutex_unlock(&ep->lock);
 }
 
 static struct acmp_send_msg *acmp_get_request(struct acmp_ep *ep, uint64_t tid, int *free)
@@ -580,7 +580,7 @@ static struct acmp_send_msg *acmp_get_request(struct acmp_ep *ep, uint64_t tid,
 	DLIST_ENTRY *entry, *next;
 
 	acm_log(2, "\n");
-	lock_acquire(&ep->lock);
+	pthread_mutex_lock(&ep->lock);
 	for (entry = ep->wait_queue.Next; entry != &ep->wait_queue; entry = next) {
 		next = entry->Next;
 		msg = container_of(entry, struct acmp_send_msg, entry);
@@ -608,7 +608,7 @@ static struct acmp_send_msg *acmp_get_request(struct acmp_ep *ep, uint64_t tid,
 		}
 	}
 unlock:
-	lock_release(&ep->lock);
+	pthread_mutex_unlock(&ep->lock);
 	return req;
 }
 
@@ -688,13 +688,13 @@ acmp_init_path_av(struct acmp_port *port, struct acmp_dest *dest)
 	flow_hop = ntohl(dest->path.flowlabel_hoplimit);
 	dest->av.is_global = 1;
 	dest->av.grh.flow_label = (flow_hop >> 8) & 0xFFFFF;
-	lock_acquire(&port->lock);
+	pthread_mutex_lock(&port->lock);
 	if (port->port) 
 		dest->av.grh.sgid_index = acm_gid_index(
 		   (struct acm_port *) port->port, &dest->path.sgid);
 	else
 		dest->av.grh.sgid_index = 0;
-	lock_release(&port->lock);
+	pthread_mutex_unlock(&port->lock);
 	dest->av.grh.hop_limit = (uint8_t) flow_hop;
 	dest->av.grh.traffic_class = dest->path.tclass;
 }
@@ -710,7 +710,7 @@ static void acmp_process_join_resp(struct acm_sa_mad *sa_mad)
 	mad = (struct ib_sa_mad *) &sa_mad->sa_mad;
 	acm_log(1, "response status: 0x%x, mad status: 0x%x\n",
 		sa_mad->umad.status, mad->status);
-	lock_acquire(&ep->lock);
+	pthread_mutex_lock(&ep->lock);
 	if (sa_mad->umad.status) {
 		acm_log(0, "ERROR - send join failed 0x%x\n", sa_mad->umad.status);
 		goto out;
@@ -753,7 +753,7 @@ static void acmp_process_join_resp(struct acm_sa_mad *sa_mad)
 	acm_log(1, "join successful\n");
 out:
 	acm_free_sa_mad(sa_mad);
-	lock_release(&ep->lock);
+	pthread_mutex_unlock(&ep->lock);
 }
 
 static uint8_t
@@ -975,20 +975,20 @@ acmp_complete_queued_req(struct acmp_dest *dest, uint8_t status)
 	DLIST_ENTRY *entry;
 
 	acm_log(2, "status %d\n", status);
-	lock_acquire(&dest->lock);
+	pthread_mutex_lock(&dest->lock);
 	while (!DListEmpty(&dest->req_queue)) {
 		entry = dest->req_queue.Next;
 		DListRemove(entry);
 		req = container_of(entry, struct acmp_request, entry);
-		lock_release(&dest->lock);
+		pthread_mutex_unlock(&dest->lock);
 
 		acm_log(2, "completing request, client %" PRIu64 "\n", req->id);
 		acmp_resolve_response(req->id, &req->msg, dest, status);
 		acmp_free_req(req);
 
-		lock_acquire(&dest->lock);
+		pthread_mutex_lock(&dest->lock);
 	}
-	lock_release(&dest->lock);
+	pthread_mutex_unlock(&dest->lock);
 }
 
 static void
@@ -1005,10 +1005,10 @@ acmp_dest_sa_resp(struct acm_sa_mad *mad)
 	}
 	acm_log(2, "%s status=0x%x\n", dest->name, status);
 
-	lock_acquire(&dest->lock);
+	pthread_mutex_lock(&dest->lock);
 	if (dest->state != ACMP_QUERY_ROUTE) {
 		acm_log(1, "notice - discarding SA response\n");
-		lock_release(&dest->lock);
+		pthread_mutex_unlock(&dest->lock);
 		goto out;
 	}
 
@@ -1023,7 +1023,7 @@ acmp_dest_sa_resp(struct acm_sa_mad *mad)
 	} else {
 		dest->state = ACMP_INIT;
 	}
-	lock_release(&dest->lock);
+	pthread_mutex_unlock(&dest->lock);
 
 	acmp_complete_queued_req(dest, status);
 out:
@@ -1039,9 +1039,9 @@ acmp_resolve_sa_resp(struct acm_sa_mad *mad)
 	acm_log(2, "\n");
 	acmp_dest_sa_resp(mad);
 
-	lock_acquire(&dest->lock);
+	pthread_mutex_lock(&dest->lock);
 	send_resp = (dest->state == ACMP_READY);
-	lock_release(&dest->lock);
+	pthread_mutex_unlock(&dest->lock);
 
 	if (send_resp)
 		acmp_send_addr_resp(dest->ep, dest);
@@ -1093,7 +1093,7 @@ acmp_process_addr_req(struct acmp_ep *ep, struct ibv_wc *wc, struct acm_mad *mad
 	if (addr)
 		dest->req_id = mad->tid;
 
-	lock_acquire(&dest->lock);
+	pthread_mutex_lock(&dest->lock);
 	acm_log(2, "dest state %d\n", dest->state);
 	switch (dest->state) {
 	case ACMP_READY:
@@ -1120,11 +1120,11 @@ acmp_process_addr_req(struct acmp_ep *ep, struct ibv_wc *wc, struct acm_mad *mad
 		}
 		/* fall through */
 	default:
-		lock_release(&dest->lock);
+		pthread_mutex_unlock(&dest->lock);
 		acmp_put_dest(dest);
 		return;
 	}
-	lock_release(&dest->lock);
+	pthread_mutex_unlock(&dest->lock);
 	acmp_complete_queued_req(dest, status);
 
 	if (addr && !status) {
@@ -1149,9 +1149,9 @@ acmp_process_addr_resp(struct acmp_send_msg *msg, struct ibv_wc *wc, struct acm_
 	}
 	acm_log(2, "resp status 0x%x\n", status);
 
-	lock_acquire(&dest->lock);
+	pthread_mutex_lock(&dest->lock);
 	if (dest->state != ACMP_QUERY_ADDR) {
-		lock_release(&dest->lock);
+		pthread_mutex_unlock(&dest->lock);
 		goto put;
 	}
 
@@ -1163,7 +1163,7 @@ acmp_process_addr_resp(struct acmp_send_msg *msg, struct ibv_wc *wc, struct acm_
 			} else {
 				status = acmp_resolve_path_sa(msg->ep, dest, acmp_dest_sa_resp);
 				if (!status) {
-					lock_release(&dest->lock);
+					pthread_mutex_unlock(&dest->lock);
 					goto put;
 				}
 			}
@@ -1171,7 +1171,7 @@ acmp_process_addr_resp(struct acmp_send_msg *msg, struct ibv_wc *wc, struct acm_
 	} else {
 		dest->state = ACMP_INIT;
 	}
-	lock_release(&dest->lock);
+	pthread_mutex_unlock(&dest->lock);
 
 	acmp_complete_queued_req(dest, status);
 put:
@@ -1578,34 +1578,34 @@ static void *acmp_retry_handler(void *context)
 		}
 
 		next_expire = -1;
-		lock_acquire(&acmp_dev_lock);
+		pthread_mutex_lock(&acmp_dev_lock);
 		for (dev_entry = acmp_dev_list.Next; dev_entry != &acmp_dev_list;
 		     dev_entry = dev_entry->Next) {
 
 			dev = container_of(dev_entry, struct acmp_device, entry);
-			lock_release(&acmp_dev_lock);
+			pthread_mutex_unlock(&acmp_dev_lock);
 
 			for (i = 0; i < dev->port_cnt; i++) {
 				port = &dev->port[i];
 
-				lock_acquire(&port->lock);
+				pthread_mutex_lock(&port->lock);
 				for (ep_entry = port->ep_list.Next;
 				     ep_entry != &port->ep_list;
 				     ep_entry = ep_entry->Next) {
 
 					ep = container_of(ep_entry, struct acmp_ep, entry);
-					lock_release(&port->lock);
-					lock_acquire(&ep->lock);
+					pthread_mutex_unlock(&port->lock);
+					pthread_mutex_lock(&ep->lock);
 					if (!DListEmpty(&ep->wait_queue))
 						acmp_process_wait_queue(ep, &next_expire);
-					lock_release(&ep->lock);
-					lock_acquire(&port->lock);
+					pthread_mutex_unlock(&ep->lock);
+					pthread_mutex_lock(&port->lock);
 				}
-				lock_release(&port->lock);
+				pthread_mutex_unlock(&port->lock);
 			}
-			lock_acquire(&acmp_dev_lock);
+			pthread_mutex_lock(&acmp_dev_lock);
 		}
-		lock_release(&acmp_dev_lock);
+		pthread_mutex_unlock(&acmp_dev_lock);
 
 		acmp_process_timeouts();
 		wait = (int) (next_expire - time_stamp_ms());
@@ -1844,7 +1844,7 @@ acmp_resolve_dest(struct acmp_ep *ep, struct acm_msg *msg, uint64_t id)
 		return acmp_resolve_response(id, msg, NULL, ACM_STATUS_ENOMEM);
 	}
 
-	lock_acquire(&dest->lock);
+	pthread_mutex_lock(&dest->lock);
 test:
 	switch (dest->state) {
 	case ACMP_READY:
@@ -1885,10 +1885,10 @@ queue:
 			break;
 		}
 		ret = 0;
-		lock_release(&dest->lock);
+		pthread_mutex_unlock(&dest->lock);
 		goto put;
 	}
-	lock_release(&dest->lock);
+	pthread_mutex_unlock(&dest->lock);
 	ret = acmp_resolve_response(id, msg, dest, status);
 put:
 	acmp_put_dest(dest);
@@ -1920,7 +1920,7 @@ acmp_resolve_path(struct acmp_ep *ep, struct acm_msg *msg, uint64_t id)
 		return acmp_resolve_response(id, msg, NULL, ACM_STATUS_ENOMEM);
 	}
 
-	lock_acquire(&dest->lock);
+	pthread_mutex_lock(&dest->lock);
 test:
 	switch (dest->state) {
 	case ACMP_READY:
@@ -1953,10 +1953,10 @@ test:
 			break;
 		}
 		ret = 0;
-		lock_release(&dest->lock);
+		pthread_mutex_unlock(&dest->lock);
 		goto put;
 	}
-	lock_release(&dest->lock);
+	pthread_mutex_unlock(&dest->lock);
 	ret = acmp_resolve_response(id, msg, dest, status);
 put:
 	acmp_put_dest(dest);
@@ -2530,7 +2530,7 @@ acmp_alloc_ep(struct acmp_port *port, struct acm_endpoint *endpoint)
 	DListInit(&ep->resp_queue.pending);
 	DListInit(&ep->active_queue);
 	DListInit(&ep->wait_queue);
-	lock_init(&ep->lock);
+	pthread_mutex_init(&ep->lock, NULL);
 	sprintf(ep->id_string, "%s-%d-0x%x", port->dev->verbs->device->name,
 		port->port_num, endpoint->pkey);
 	for (i = 0; i < ACM_MAX_COUNTER; i++) 
@@ -2551,9 +2551,9 @@ static int acmp_open_endpoint(const struct acm_endpoint *endpoint,
 	ep = acmp_get_ep(port,  (struct acm_endpoint *) endpoint);
 	if (ep) {
 		acm_log(2, "endpoint for pkey 0x%x already exists\n", endpoint->pkey);
-		lock_acquire(&ep->lock);
+		pthread_mutex_lock(&ep->lock);
 		ep->endpoint =  (struct acm_endpoint *) endpoint;
-		lock_release(&ep->lock);
+		pthread_mutex_unlock(&ep->lock);
 		*ep_context = (void *) ep;
 		return 0;
 	}
@@ -2627,9 +2627,9 @@ static int acmp_open_endpoint(const struct acm_endpoint *endpoint,
 	if (ret)
 		goto err2;
 
-	lock_acquire(&port->lock);
+	pthread_mutex_lock(&port->lock);
 	DListInsertHead(&ep->entry, &port->ep_list);
-	lock_release(&port->lock);
+	pthread_mutex_unlock(&port->lock);
 	acmp_ep_preload(ep);
 	acmp_ep_join(ep);
 	*ep_context = (void *) ep;
@@ -2700,9 +2700,9 @@ static void acmp_port_up(struct acmp_port *port)
 static void acmp_port_down(struct acmp_port *port)
 {
 	acm_log(1, "%s %d\n", port->dev->verbs->device->name, port->port_num);
-	lock_acquire(&port->lock);
+	pthread_mutex_lock(&port->lock);
 	port->state = IBV_PORT_DOWN;
-	lock_release(&port->lock);
+	pthread_mutex_unlock(&port->lock);
 
 	/*
 	 * We wait for the SA destination to be released.  We could use an
@@ -2712,9 +2712,9 @@ static void acmp_port_down(struct acmp_port *port)
 	atomic_dec(&port->sa_dest.refcnt);
 	while (atomic_get(&port->sa_dest.refcnt))
 		sleep(0);
-	lock_acquire(&port->sa_dest.lock);
+	pthread_mutex_lock(&port->sa_dest.lock);
 	port->sa_dest.state = ACMP_INIT;
-	lock_release(&port->sa_dest.lock);
+	pthread_mutex_unlock(&port->sa_dest.lock);
 	acm_log(1, "%s %d is down\n", port->dev->verbs->device->name, port->port_num);
 }
 
@@ -2731,10 +2731,10 @@ static int acmp_open_port(const struct acm_port *cport, void *dev_context,
 	}
 
 	port = &dev->port[cport->port_num - 1];
-	lock_acquire(&port->lock);
+	pthread_mutex_lock(&port->lock);
 	port->port = cport;
 	port->state = IBV_PORT_DOWN;
-	lock_release(&port->lock);
+	pthread_mutex_unlock(&port->lock);
 	acmp_port_up(port);
 	*port_context = port;
 	return 0;
@@ -2745,9 +2745,9 @@ static void acmp_close_port(void *port_context)
 	struct acmp_port *port = port_context;
 
 	acmp_port_down(port);
-	lock_acquire(&port->lock);
+	pthread_mutex_lock(&port->lock);
 	port->port = NULL;
-	lock_release(&port->lock);
+	pthread_mutex_unlock(&port->lock);
 }
 
 static void acmp_init_port(struct acmp_port *port, struct acmp_device *dev, 
@@ -2756,7 +2756,7 @@ static void acmp_init_port(struct acmp_port *port, struct acmp_device *dev,
 	acm_log(1, "%s %d\n", dev->verbs->device->name, port_num);
 	port->dev = dev;
 	port->port_num = port_num;
-	lock_init(&port->lock);
+	pthread_mutex_init(&port->lock, NULL);
 	DListInit(&port->ep_list);
 	acmp_init_dest(&port->sa_dest, ACM_ADDRESS_LID, NULL, 0);
 	port->state = IBV_PORT_DOWN;
@@ -2838,9 +2838,9 @@ static int acmp_open_dev(const struct acm_device *device, void **dev_context)
 		goto err3;
 	}
 
-	lock_acquire(&acmp_dev_lock);
+	pthread_mutex_lock(&acmp_dev_lock);
 	DListInsertHead(&dev->entry, &acmp_dev_list);
-	lock_release(&acmp_dev_lock);
+	pthread_mutex_unlock(&acmp_dev_lock);
 	dev->guid = device->dev_guid;
 	*dev_context = dev;
 
@@ -2951,7 +2951,7 @@ static void __attribute__((constructor)) acmp_init(void)
 	atomic_init(&g_tid);
 	atomic_init(&wait_cnt);
 	DListInit(&acmp_dev_list);
-	lock_init(&acmp_dev_lock);
+	pthread_mutex_init(&acmp_dev_lock, NULL);
 	DListInit(&timeout_list);
 	event_init(&timeout_event);
 
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 01ba4e1..d40aa71 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -106,7 +106,7 @@ struct acmc_port {
 	DLIST_ENTRY         sa_pending;
 	DLIST_ENTRY	    sa_wait;
 	int		    sa_credits;
-	lock_t              lock;
+	pthread_mutex_t     lock;
 	DLIST_ENTRY         ep_list;
 	enum ibv_port_state state;
 	int                 gid_cnt;
@@ -140,7 +140,7 @@ struct acmc_ep {
 };
 
 struct acmc_client {
-	lock_t   lock;   /* acquire ep lock first */
+	pthread_mutex_t lock;   /* acquire ep lock first */
 	SOCKET   sock;
 	int      index;
 	atomic_t refcnt;
@@ -185,7 +185,7 @@ static SOCKET ip_mon_socket;
 static struct acmc_client client_array[FD_SETSIZE - 1];
 
 static FILE *flog;
-static lock_t log_lock;
+static pthread_mutex_t log_lock;
 PER_THREAD char log_data[ACM_MAX_ADDRESS];
 static atomic_t counter[ACM_MAX_COUNTER];
 
@@ -230,11 +230,11 @@ void acm_write(int level, const char *format, ...)
 
 	gettimeofday(&tv, NULL);
 	va_start(args, format);
-	lock_acquire(&log_lock);
+	pthread_mutex_lock(&log_lock);
 	fprintf(flog, "%u.%03u: ", (unsigned) tv.tv_sec, (unsigned) (tv.tv_usec / 1000));
 	vfprintf(flog, format, args);
 	fflush(flog);
-	lock_release(&log_lock);
+	pthread_mutex_unlock(&log_lock);
 	va_end(args);
 }
 
@@ -483,7 +483,7 @@ int acm_resolve_response(uint64_t id, struct acm_msg *msg)
 	else if (msg->hdr.status)
 		atomic_inc(&counter[ACM_CNTR_ERROR]);
 
-	lock_acquire(&client->lock);
+	pthread_mutex_lock(&client->lock);
 	if (client->sock == INVALID_SOCKET) {
 		acm_log(0, "ERROR - connection lost\n");
 		ret = ACM_STATUS_ENOTCONN;
@@ -501,7 +501,7 @@ int acm_resolve_response(uint64_t id, struct acm_msg *msg)
 		ret = 0;
 
 release:
-	lock_release(&client->lock);
+	pthread_mutex_unlock(&client->lock);
 	(void) atomic_dec(&client->refcnt);
 	return ret;
 }
@@ -524,7 +524,7 @@ int acm_query_response(uint64_t id, struct acm_msg *msg)
 	int ret;
 
 	acm_log(2, "status 0x%x\n", msg->hdr.status);
-	lock_acquire(&client->lock);
+	pthread_mutex_lock(&client->lock);
 	if (client->sock == INVALID_SOCKET) {
 		acm_log(0, "ERROR - connection lost\n");
 		ret = ACM_STATUS_ENOTCONN;
@@ -538,7 +538,7 @@ int acm_query_response(uint64_t id, struct acm_msg *msg)
 		ret = 0;
 
 release:
-	lock_release(&client->lock);
+	pthread_mutex_unlock(&client->lock);
 	(void) atomic_dec(&client->refcnt);
 	return ret;
 }
@@ -557,7 +557,7 @@ static void acm_init_server(void)
 	int i;
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
-		lock_init(&client_array[i].lock);
+		pthread_mutex_init(&client_array[i].lock, NULL);
 		client_array[i].index = i;
 		client_array[i].sock = INVALID_SOCKET;
 		atomic_init(&client_array[i].refcnt);
@@ -604,11 +604,11 @@ static int acm_listen(void)
 
 static void acm_disconnect_client(struct acmc_client *client)
 {
-	lock_acquire(&client->lock);
+	pthread_mutex_lock(&client->lock);
 	shutdown(client->sock, SHUT_RDWR);
 	closesocket(client->sock);
 	client->sock = INVALID_SOCKET;
-	lock_release(&client->lock);
+	pthread_mutex_unlock(&client->lock);
 	(void) atomic_dec(&client->refcnt);
 }
 
@@ -2425,7 +2425,7 @@ acm_open_port(struct acmc_port *port, struct acmc_device *dev, uint8_t port_num)
 	port->dev = dev;
 	port->port.dev = &dev->device;
 	port->port.port_num = port_num;
-	lock_init(&port->lock);
+	pthread_mutex_init(&port->lock, NULL);
 	DListInit(&port->ep_list);
 	DListInit(&port->sa_pending);
 	DListInit(&port->sa_wait);
@@ -2783,7 +2783,7 @@ int acm_send_sa_mad(struct acm_sa_mad *mad)
 	mad->umad.addr.sl = port->sa_addr.sl;
 	mad->umad.addr.pkey_index = req->ep->port->sa_pkey_index;
 
-	lock_acquire(&port->lock);
+	pthread_mutex_lock(&port->lock);
 	if (port->sa_credits && DListEmpty(&port->sa_wait)) {
 		ret = umad_send(port->mad_portid, port->mad_agentid, &mad->umad,
 				sizeof mad->sa_mad, sa.timeout, sa.retries);
@@ -2795,7 +2795,7 @@ int acm_send_sa_mad(struct acm_sa_mad *mad)
 		ret = 0;
 		DListInsertTail(&req->entry, &port->sa_wait);
 	}
-	lock_release(&port->lock);
+	pthread_mutex_unlock(&port->lock);
 	return ret;
 }
 
@@ -2804,9 +2804,9 @@ static void acmc_send_queued_req(struct acmc_port *port)
 	struct acmc_sa_req *req;
 	int ret;
 
-	lock_acquire(&port->lock);
+	pthread_mutex_lock(&port->lock);
 	if (DListEmpty(&port->sa_wait) || !port->sa_credits) {
-		lock_release(&port->lock);
+		pthread_mutex_unlock(&port->lock);
 		return;
 	}
 
@@ -2818,7 +2818,7 @@ static void acmc_send_queued_req(struct acmc_port *port)
 		port->sa_credits--;
 		DListInsertTail(&req->entry, &port->sa_pending);
 	}
-	lock_release(&port->lock);
+	pthread_mutex_unlock(&port->lock);
 
 	if (ret) {
 		req->mad.umad.status = -ret;
@@ -2847,7 +2847,7 @@ static void acmc_recv_mad(struct acmc_port *port)
 		hdr->base_version, hdr->mgmt_class, hdr->class_version,
 		hdr->method, hdr->status, hdr->tid, hdr->attr_id, hdr->attr_mod);
 	found = 0;
-	lock_acquire(&port->lock);
+	pthread_mutex_lock(&port->lock);
 	for (entry = port->sa_pending.Next; entry != &port->sa_pending;
 	     entry = entry->Next) {
 		req = container_of(entry, struct acmc_sa_req, entry);
@@ -2859,7 +2859,7 @@ static void acmc_recv_mad(struct acmc_port *port)
 			break;
 		}
 	}
-	lock_release(&port->lock);
+	pthread_mutex_unlock(&port->lock);
 
 	if (found) {
 		memcpy(&req->mad.umad, &resp.umad, sizeof(resp.umad) + len);
@@ -3083,7 +3083,7 @@ int CDECL_FUNC main(int argc, char **argv)
 	if (acm_open_lock_file())
 		return -1;
 
-	lock_init(&log_lock);
+	pthread_mutex_init(&log_lock, NULL);
 	flog = acm_open_log();
 
 	acm_log(0, "Assistant to the InfiniBand Communication Manager\n");
diff --git a/ibacm/src/libacm.c b/ibacm/src/libacm.c
index def5b2c..0f45469 100644
--- a/ibacm/src/libacm.c
+++ b/ibacm/src/libacm.c
@@ -38,7 +38,7 @@
 #include <netdb.h>
 #include <arpa/inet.h>
 
-extern lock_t lock;
+extern pthread_mutex_t lock;
 static SOCKET sock = INVALID_SOCKET;
 static short server_port = 6125;
 
@@ -212,7 +212,7 @@ static int acm_resolve(uint8_t *src, uint8_t *dest, uint8_t type,
 	struct acm_msg msg;
 	int ret, cnt = 0;
 
-	lock_acquire(&lock);
+	pthread_mutex_lock(&lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_RESOLVE;
@@ -246,7 +246,7 @@ static int acm_resolve(uint8_t *src, uint8_t *dest, uint8_t type,
 
 	ret = acm_format_resp(&msg, paths, count, print);
 out:
-	lock_release(&lock);
+	pthread_mutex_unlock(&lock);
 	return ret;
 }
 
@@ -275,7 +275,7 @@ int ib_acm_resolve_path(struct ibv_path_record *path, uint32_t flags)
 	struct acm_ep_addr_data *data;
 	int ret;
 
-	lock_acquire(&lock);
+	pthread_mutex_lock(&lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_RESOLVE;
@@ -299,7 +299,7 @@ int ib_acm_resolve_path(struct ibv_path_record *path, uint32_t flags)
 		*path = data->info.path;
 
 out:
-	lock_release(&lock);
+	pthread_mutex_unlock(&lock);
 	return ret;
 }
 
@@ -308,7 +308,7 @@ int ib_acm_query_perf(int index, uint64_t **counters, int *count)
 	struct acm_msg msg;
 	int ret, i;
 
-	lock_acquire(&lock);
+	pthread_mutex_lock(&lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_PERF_QUERY;
@@ -341,7 +341,7 @@ int ib_acm_query_perf(int index, uint64_t **counters, int *count)
 		(*counters)[i] = ntohll(msg.perf_data[i]);
 	ret = 0;
 out:
-	lock_release(&lock);
+	pthread_mutex_unlock(&lock);
 	return ret;
 }
 
@@ -353,7 +353,7 @@ int ib_acm_enum_ep(int index, struct acm_ep_config_data **data)
 	int cnt;
 	struct acm_ep_config_data *edata;
 
-	lock_acquire(&lock);
+	pthread_mutex_lock(&lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_EP_QUERY;
@@ -391,7 +391,7 @@ int ib_acm_enum_ep(int index, struct acm_ep_config_data **data)
 	*data = edata;
 	ret = 0;
 out:
-	lock_release(&lock);
+	pthread_mutex_unlock(&lock);
 	return ret;
 }
 
@@ -404,7 +404,7 @@ int ib_acm_query_perf_ep_addr(uint8_t *src, uint8_t type,
 	if (!src) 
 		return -1;
 
-	lock_acquire(&lock);
+	pthread_mutex_lock(&lock);
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_PERF_QUERY;
@@ -444,7 +444,7 @@ int ib_acm_query_perf_ep_addr(uint8_t *src, uint8_t type,
 
 	ret = 0;
 out:
-	lock_release(&lock);
+	pthread_mutex_unlock(&lock);
 	return ret;
 }
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
