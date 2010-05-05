From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] ib/iser: enhance disconnection logic for multi-pathing
Date: Wed, 5 May 2010 17:31:44 +0300 (IDT)
Message-ID: <Pine.LNX.4.64.1005051730450.29957@zuben.voltaire.com>
References: <Pine.LNX.4.64.1005051726110.29957@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1005051726110.29957-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Alexander Nezhinsky <alexandern-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yaron Haviv <yaronh-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The iser connection teardown flow isn't over till the underlying
Connection Manager (e.g the IB CM) delivers a disconnected or timeout
event through the RDMA-CM. When the remote (target) side isn't reachable,
e.g when some HW e.g port/hca/switch isn't functioning or taken down
administratively, the CM timeout flow is used and the event may be
generated only after relatively long time, in the order of tens of seconds.

The current iser code exposes this possibly long delay to higher layers,
specifically to the iscsid daemon and iscsi kernel stack. As a result,
the iscsi stack doesn't respond well, to the extent of this low-level CM
delay being added to the fail-over time under HA schemes such as the one
provided by DM multipath through the multipathd(8) service.

This patch enhances the reference counting scheme on iser's IB
connections such that the disconnect flow initiated by iscsid from
user space (ep_disconnect) isn't waiting for the CM to deliver the
disconnect/timeout event. On the other hand, the connection teardown
isn't done from iser's view point till the event is delivered.

The iser ib (rdma) connection object is destroyed when its reference
count reaches zero. When this happens on the RDMA-CM callback context,
extra care is taken such that the RDMA-CM does the actual destroying
of the associated ID as doing it in the callback is prohibited.

The reference count of iser ib connection would normally reach
three, where the <ref, deref> relations are
1. conn <init, terminate>
2. conn <bind, stop/destroy>
3. cma id <create, disconnect/error/timeout callbacks>

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---

with this patch, multipath fail-over time is about 30 seconds,
which is seen here, when a DD over the multi-path device is done
before/during/after the fail-over

regulary, before taking a port down
# dd if=/dev/zero of=/dev/dm-0 bs=128k count=128k
17179869184 bytes (17 GB) copied, 16.926 s, 1.0 GB/s

taking a port down, causing fail-over during IO
# dd if=/dev/zero of=/dev/dm-0 bs=128k count=128k
17179869184 bytes (17 GB) copied, 46.6117 s, 369 MB/s

after path-failure, back to speed
# dd if=/dev/zero of=/dev/dm-0 bs=128k count=128k
17179869184 bytes (17 GB) copied, 16.6474 s, 1.0 GB/s

13:00:09 iser: iser_event_handler:async event 10 on device mlx4_0 port 1
13:00:24 connection8:0: ping timeout of 10 secs expired, recv timeout 5, last rx [...]
13:00:24 connection8:0: detected conn error (1011)
13:00:24 iscsid: Kernel reported iSCSI connection 8:0 error (1011) state (3)
13:00:39 cto-1 kernel: device-mapper: multipath: Failing path 8:48.
13:00:39 cto-1 multipathd: 8:48: mark as failed
13:00:39 cto-1 multipathd: mpathd: remaining active paths: 1
--> the disconnected event is delivered after the IB CM timeout expires
--> but fail-over doesn't pend on this
13:01:56 iser: iser_cma_handler:event 10 status 0 conn ffff88022dcb39b0 id ffff88022cf09400

without this patch, multipath fail-over time is about 130 seconds

before taking a port down
# dd if=/dev/zero of=/dev/dm-0 bs=128k count=128k
17179869184 bytes (17 GB) copied, 16.6812 s, 1.0 GB/s

taking a port down during IO
# dd if=/dev/zero of=/dev/dm-0 bs=128k count=128k
17179869184 bytes (17 GB) copied, 145.094 s, 118 MB/s

after fail-over, back to speed
# dd if=/dev/zero of=/dev/dm-0 bs=128k count=128k
17179869184 bytes (17 GB) copied, 16.8935 s, 1.0 GB/s

14:24:05 iser: iser_event_handler:async event 10 on device mlx4_0 port 1
14:24:20 connection4:0: ping timeout of 10 secs expired, recv timeout 5, last rx [...]
14:24:20 kernel: connection4:0: detected conn error (1011)
14:24:21 iscsid: Kernel reported iSCSI connection 4:0 error (1011) state (3)
--> the disconnected event is delivered after the IB CM timeout expires
--> fail-over pending on this
14:25:59 iser: iser_cma_handler:event 10 conn ffff88022625a1b0 id ffff880222537c00
14:26:14 session4: session recovery timed out after 15 secs
14:26:14 device-mapper: multipath: Failing path 8:64.
14:26:14 multipathd: mpathd: remaining active paths: 1

 drivers/infiniband/ulp/iser/iscsi_iser.c |    9 ++-
 drivers/infiniband/ulp/iser/iscsi_iser.h |    3 -
 drivers/infiniband/ulp/iser/iser_verbs.c |   72 +++++++++++++++++--------------
 3 files changed, 46 insertions(+), 38 deletions(-)

Index: linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.34-rc6.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -238,7 +238,7 @@ alloc_err:
  * releases the FMR pool, QP and CMA ID objects, returns 0 on success,
  * -1 on failure
  */
-static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
+static int iser_free_ib_conn_res(struct iser_conn *ib_conn, int can_destroy_id)
 {
 	BUG_ON(ib_conn == NULL);

@@ -253,7 +253,8 @@ static int iser_free_ib_conn_res(struct
 	if (ib_conn->qp != NULL)
 		rdma_destroy_qp(ib_conn->cma_id);

-	if (ib_conn->cma_id != NULL)
+	/* if cma handler context, the caller acts s.t the cma destroy the id */
+	if (ib_conn->cma_id != NULL && can_destroy_id)
 		rdma_destroy_id(ib_conn->cma_id);

 	ib_conn->fmr_pool = NULL;
@@ -331,7 +332,7 @@ static int iser_conn_state_comp_exch(str
 /**
  * Frees all conn objects and deallocs conn descriptor
  */
-static void iser_conn_release(struct iser_conn *ib_conn)
+static void iser_conn_release(struct iser_conn *ib_conn, int can_destroy_id)
 {
 	struct iser_device  *device = ib_conn->device;

@@ -341,7 +342,7 @@ static void iser_conn_release(struct ise
 	list_del(&ib_conn->conn_list);
 	mutex_unlock(&ig.connlist_mutex);
 	iser_free_rx_descriptors(ib_conn);
-	iser_free_ib_conn_res(ib_conn);
+	iser_free_ib_conn_res(ib_conn, can_destroy_id);
 	ib_conn->device = NULL;
 	/* on EVENT_ADDR_ERROR there's no device yet for this conn */
 	if (device != NULL)
@@ -354,10 +355,13 @@ void iser_conn_get(struct iser_conn *ib_
 	atomic_inc(&ib_conn->refcount);
 }

-void iser_conn_put(struct iser_conn *ib_conn)
+int iser_conn_put(struct iser_conn *ib_conn, int can_destroy_id)
 {
-	if (atomic_dec_and_test(&ib_conn->refcount))
-		iser_conn_release(ib_conn);
+	if (atomic_dec_and_test(&ib_conn->refcount)) {
+		iser_conn_release(ib_conn, can_destroy_id);
+		return 1;
+	}
+	return 0;
 }

 /**
@@ -381,19 +385,20 @@ void iser_conn_terminate(struct iser_con
 	wait_event_interruptible(ib_conn->wait,
 				 ib_conn->state == ISER_CONN_DOWN);

-	iser_conn_put(ib_conn);
+	iser_conn_put(ib_conn, 1); /* deref ib conn deallocate */
 }

-static void iser_connect_error(struct rdma_cm_id *cma_id)
+static int iser_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct iser_conn *ib_conn;
 	ib_conn = (struct iser_conn *)cma_id->context;

 	ib_conn->state = ISER_CONN_DOWN;
 	wake_up_interruptible(&ib_conn->wait);
+	return iser_conn_put(ib_conn, 0); /* deref ib conn's cma id */
 }

-static void iser_addr_handler(struct rdma_cm_id *cma_id)
+static int iser_addr_handler(struct rdma_cm_id *cma_id)
 {
 	struct iser_device *device;
 	struct iser_conn   *ib_conn;
@@ -402,8 +407,7 @@ static void iser_addr_handler(struct rdm
 	device = iser_device_find_by_ib_device(cma_id);
 	if (!device) {
 		iser_err("device lookup/creation failed\n");
-		iser_connect_error(cma_id);
-		return;
+		return iser_connect_error(cma_id);
 	}

 	ib_conn = (struct iser_conn *)cma_id->context;
@@ -412,11 +416,13 @@ static void iser_addr_handler(struct rdm
 	ret = rdma_resolve_route(cma_id, 1000);
 	if (ret) {
 		iser_err("resolve route failed: %d\n", ret);
-		iser_connect_error(cma_id);
+		return iser_connect_error(cma_id);
 	}
+
+	return 0;
 }

-static void iser_route_handler(struct rdma_cm_id *cma_id)
+static int iser_route_handler(struct rdma_cm_id *cma_id)
 {
 	struct rdma_conn_param conn_param;
 	int    ret;
@@ -437,9 +443,9 @@ static void iser_route_handler(struct rd
 		goto failure;
 	}

-	return;
+	return 0;
 failure:
-	iser_connect_error(cma_id);
+	return iser_connect_error(cma_id);
 }

 static void iser_connected_handler(struct rdma_cm_id *cma_id)
@@ -451,12 +457,12 @@ static void iser_connected_handler(struc
 	wake_up_interruptible(&ib_conn->wait);
 }

-static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
+static int iser_disconnected_handler(struct rdma_cm_id *cma_id)
 {
 	struct iser_conn *ib_conn;
+	int ret;

 	ib_conn = (struct iser_conn *)cma_id->context;
-	ib_conn->disc_evt_flag = 1;

 	/* getting here when the state is UP means that the conn is being *
 	 * terminated asynchronously from the iSCSI layer's perspective.  */
@@ -471,20 +477,24 @@ static void iser_disconnected_handler(st
 		ib_conn->state = ISER_CONN_DOWN;
 		wake_up_interruptible(&ib_conn->wait);
 	}
+
+	ret = iser_conn_put(ib_conn, 0); /* deref ib conn's cma id */
+	return ret;
 }

 static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	int ret = 0;

-	iser_err("event %d conn %p id %p\n",event->event,cma_id->context,cma_id);
+	iser_err("event %d status %d conn %p id %p\n",
+		event->event, event->status, cma_id->context, cma_id);

 	switch (event->event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
-		iser_addr_handler(cma_id);
+		ret = iser_addr_handler(cma_id);
 		break;
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
-		iser_route_handler(cma_id);
+		ret = iser_route_handler(cma_id);
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
 		iser_connected_handler(cma_id);
@@ -494,13 +504,12 @@ static int iser_cma_handler(struct rdma_
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 	case RDMA_CM_EVENT_UNREACHABLE:
 	case RDMA_CM_EVENT_REJECTED:
-		iser_err("event: %d, error: %d\n", event->event, event->status);
-		iser_connect_error(cma_id);
+		ret = iser_connect_error(cma_id);
 		break;
 	case RDMA_CM_EVENT_DISCONNECTED:
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_ADDR_CHANGE:
-		iser_disconnected_handler(cma_id);
+		ret = iser_disconnected_handler(cma_id);
 		break;
 	default:
 		iser_err("Unexpected RDMA CM event (%d)\n", event->event);
@@ -515,7 +524,7 @@ void iser_conn_init(struct iser_conn *ib
 	init_waitqueue_head(&ib_conn->wait);
 	ib_conn->post_recv_buf_count = 0;
 	atomic_set(&ib_conn->post_send_buf_count, 0);
-	atomic_set(&ib_conn->refcount, 1);
+	atomic_set(&ib_conn->refcount, 1); /* ref ib conn allocation */
 	INIT_LIST_HEAD(&ib_conn->conn_list);
 	spin_lock_init(&ib_conn->lock);
 }
@@ -543,6 +552,7 @@ int iser_connect(struct iser_conn   *ib_

 	ib_conn->state = ISER_CONN_PENDING;

+	iser_conn_get(ib_conn); /* ref ib conn's cma id */
 	ib_conn->cma_id = rdma_create_id(iser_cma_handler,
 					     (void *)ib_conn,
 					     RDMA_PS_TCP);
@@ -580,7 +590,7 @@ id_failure:
 addr_failure:
 	ib_conn->state = ISER_CONN_DOWN;
 connect_failure:
-	iser_conn_release(ib_conn);
+	iser_conn_release(ib_conn, 1);
 	return err;
 }

@@ -749,12 +759,10 @@ static void iser_handle_comp_error(struc
 			iscsi_conn_failure(ib_conn->iser_conn->iscsi_conn,
 					   ISCSI_ERR_CONN_FAILED);

-		/* complete the termination process if disconnect event was delivered *
-		 * note there are no more non completed posts to the QP               */
-		if (ib_conn->disc_evt_flag) {
-			ib_conn->state = ISER_CONN_DOWN;
-			wake_up_interruptible(&ib_conn->wait);
-		}
+		/* no more non completed posts to the QP, complete the
+		 * termination process w.o worrying on disconnect event */
+		ib_conn->state = ISER_CONN_DOWN;
+		wake_up_interruptible(&ib_conn->wait);
 	}
 }

Index: linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iscsi_iser.c
===================================================================
--- linux-2.6.34-rc6.orig/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -325,7 +325,7 @@ iscsi_iser_conn_destroy(struct iscsi_cls
 	 */
 	if (ib_conn) {
 		ib_conn->iser_conn = NULL;
-		iser_conn_put(ib_conn);
+		iser_conn_put(ib_conn, 1); /* deref iscsi/ib conn unbinding */
 	}
 }

@@ -357,11 +357,12 @@ iscsi_iser_conn_bind(struct iscsi_cls_se
 	/* binds the iSER connection retrieved from the previously
 	 * connected ep_handle to the iSCSI layer connection. exchanges
 	 * connection pointers */
-	iser_err("binding iscsi conn %p to iser_conn %p\n",conn,ib_conn);
+	iser_err("binding iscsi/iser conn %p %p to ib_conn %p\n",
+					conn, conn->dd_data, ib_conn);
 	iser_conn = conn->dd_data;
 	ib_conn->iser_conn = iser_conn;
 	iser_conn->ib_conn  = ib_conn;
-	iser_conn_get(ib_conn);
+	iser_conn_get(ib_conn); /* ref iscsi/ib conn binding */
 	return 0;
 }

@@ -382,7 +383,7 @@ iscsi_iser_conn_stop(struct iscsi_cls_co
 		 * There is no unbind event so the stop callback
 		 * must release the ref from the bind.
 		 */
-		iser_conn_put(ib_conn);
+		iser_conn_put(ib_conn, 1); /* deref iscsi/ib conn unbinding */
 	}
 	iser_conn->ib_conn = NULL;
 }
Index: linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iscsi_iser.h
===================================================================
--- linux-2.6.34-rc6.orig/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -247,7 +247,6 @@ struct iser_conn {
 	struct rdma_cm_id            *cma_id;       /* CMA ID		       */
 	struct ib_qp	             *qp;           /* QP 		       */
 	struct ib_fmr_pool           *fmr_pool;     /* pool of IB FMRs         */
-	int                          disc_evt_flag; /* disconn event delivered */
 	wait_queue_head_t	     wait;          /* waitq for conn/disconn  */
 	int                          post_recv_buf_count; /* posted rx count  */
 	atomic_t                     post_send_buf_count; /* posted tx count   */
@@ -321,7 +320,7 @@ void iser_conn_init(struct iser_conn *ib

 void iser_conn_get(struct iser_conn *ib_conn);

-void iser_conn_put(struct iser_conn *ib_conn);
+int iser_conn_put(struct iser_conn *ib_conn, int destroy_cma_id_allowed);

 void iser_conn_terminate(struct iser_conn *ib_conn);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
