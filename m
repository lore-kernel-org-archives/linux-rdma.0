From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Fri, 15 Dec 2017 10:28:00 -0700
Message-ID: <20171215172800.GA12434@ziepe.ca>
References: <20171214110241.4701-1-honli@redhat.com>
 <1513263572.2986.2.camel@wdc.com>
 <20171215013628.GA743@dhcp-13-42.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171215013628.GA743-Y5OA6DF/u0nid9cnFhDO8BcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 15, 2017 at 09:36:28AM +0800, Honggang LI wrote:
> On Thu, Dec 14, 2017 at 02:59:34PM +0000, Bart Van Assche wrote:
> > On Thu, 2017-12-14 at 19:02 +0800, Honggang LI wrote:
> > > fd3005f0cd34 moves the signal handler setup from ibsrpdm path. So,
> > > default signal handler will be used when it receives signal SIGINT.
> > > ibsrpdm will exit with non-zero exit code as default signal handler
> > > killed it.
> > 
> > Can you explain why you think that ibsrpdm needs a signal handler?
> 
> main
>   ibsrpdm
>     alloc_res
>       pthread_create(&res->res.async_ev_thread [1]
>     ....
>     free_res
>       if (res->async_ev_thread) { pthread_kill(res->async_ev_thread, SIGINT); [2]
> 
> 
> The ibsrpdm program create a thread in [1], and send a SIGINT in [2].
> The default behavior of SIGINT is to terminate the process.

Yuk, no, using signals like this is horrifyingly buggy.

Here is a sketch on how to fix it properly. All the users of
pthread_kill should be eliminated.

Though overall, there is really no reason to even cleanup the threads,
just call exit?

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index cec36db2e0f12e..fe307705ad6a51 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -61,6 +61,7 @@
 #include <string.h>
 #include <signal.h>
 #include <sys/syslog.h>
+#include <sys/eventfd.h>
 #include <infiniband/umad.h>
 #include <infiniband/umad_types.h>
 #include <infiniband/umad_sa.h>
@@ -1887,7 +1888,9 @@ static void free_res(struct resources *res)
 		modify_qp_to_err(res->ud_res->qp);
 
 	if (res->reconnect_thread) {
-		pthread_kill(res->reconnect_thread, SIGINT);
+		uint64_t val = 1;
+
+		write(res->sync_res->stop_event_fd, &val, sizeof(val));
 		pthread_join(res->reconnect_thread, &status);
 	}
 	if (res->async_ev_thread) {
@@ -1947,6 +1950,7 @@ static struct resources *alloc_res(void)
 			goto err;
 	}
 
+	res->sync_res.stop_event_fd = eventfd(0, EFD_CLOEXEC);
 	ret = pthread_create(&res->res.async_ev_thread, NULL,
 			     run_thread_listen_to_events, &res->res);
 	if (ret)
diff --git a/srp_daemon/srp_daemon.h b/srp_daemon/srp_daemon.h
index 5d268ed395e17e..8cbee09d7c688b 100644
--- a/srp_daemon/srp_daemon.h
+++ b/srp_daemon/srp_daemon.h
@@ -245,6 +245,7 @@ enum {
 };
 
 struct sync_resources {
+	int stop_event_fd;
 	int stop_threads;
 	int next_task;
 	struct timespec next_recalc_time;
diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
index 6b36b15cc84c16..cedc2b0ab8e5af 100644
--- a/srp_daemon/srp_handle_traps.c
+++ b/srp_daemon/srp_handle_traps.c
@@ -44,6 +44,7 @@
 #include <infiniband/verbs.h>
 #include <infiniband/umad_sa.h>
 #include <infiniband/umad_sm.h>
+#include <poll.h>
 
 #include "srp_ib_types.h"
 
@@ -788,69 +789,94 @@ int register_to_traps(struct resources *res, int subscribe)
 
 }
 
-void *run_thread_listen_to_events(void *res_in)
+static int do_async_event(struct resources *res)
 {
-	struct resources *res = (struct resources *)res_in;
 	struct ibv_async_event event;
 
-	while (!stop_threads(res->sync_res)) {
-		if (ibv_get_async_event(res->ud_res->ib_ctx, &event)) {
-			if (errno != EINTR)
-				pr_err("ibv_get_async_event failed (errno = %d)\n",
-				       errno);
-			break;
+	if (ibv_get_async_event(res->ud_res->ib_ctx, &event)) {
+		if (errno != EINTR)
+			pr_err("ibv_get_async_event failed (errno = %d)\n",
+			       errno);
+		return -1;
+	}
+
+	pr_debug("event_type %d, port %d\n", event.event_type,
+		 event.element.port_num);
+
+	switch (event.event_type) {
+	case IBV_EVENT_PORT_ACTIVE:
+	case IBV_EVENT_SM_CHANGE:
+	case IBV_EVENT_LID_CHANGE:
+	case IBV_EVENT_CLIENT_REREGISTER:
+	case IBV_EVENT_PKEY_CHANGE:
+		if (event.element.port_num == config->port_num) {
+			pthread_mutex_lock(&res->sync_res->mutex);
+			__schedule_rescan(res->sync_res, 0);
+			wake_up_main_loop(0);
+			pthread_mutex_unlock(&res->sync_res->mutex);
 		}
+		break;
 
-		pr_debug("event_type %d, port %d\n",
-			 event.event_type, event.element.port_num);
-
-		switch (event.event_type) {
-		case IBV_EVENT_PORT_ACTIVE:
-		case IBV_EVENT_SM_CHANGE:
-		case IBV_EVENT_LID_CHANGE:
-		case IBV_EVENT_CLIENT_REREGISTER:
-		case IBV_EVENT_PKEY_CHANGE:
-			if (event.element.port_num == config->port_num) {
-				pthread_mutex_lock(&res->sync_res->mutex);
-				__schedule_rescan(res->sync_res, 0);
-				wake_up_main_loop(0);
-				pthread_mutex_unlock(&res->sync_res->mutex);
-			}
-		  	break;
-
-		case IBV_EVENT_DEVICE_FATAL:
-		case IBV_EVENT_CQ_ERR:
-		case IBV_EVENT_QP_FATAL:
-		  /* clean and restart */
-			pr_err("Critical event %d, raising catastrophic "
-			       "error signal\n", event.event_type);
-			raise(SRP_CATAS_ERR);
-			break;
+	case IBV_EVENT_DEVICE_FATAL:
+	case IBV_EVENT_CQ_ERR:
+	case IBV_EVENT_QP_FATAL:
+		/* clean and restart */
+		pr_err("Critical event %d, raising catastrophic "
+		       "error signal\n",
+		       event.event_type);
+		raise(SRP_CATAS_ERR);
+		break;
 
- 	      	 /*
+		/*
 
-		case IBV_EVENT_PORT_ERR:
-		case IBV_EVENT_QP_REQ_ERR:
-		case IBV_EVENT_QP_ACCESS_ERR:
-		case IBV_EVENT_COMM_EST:
-		case IBV_EVENT_SQ_DRAINED:
-		case IBV_EVENT_PATH_MIG:
-		case IBV_EVENT_PATH_MIG_ERR:
-		case IBV_EVENT_SRQ_ERR:
-		case IBV_EVENT_SRQ_LIMIT_REACHED:
-		case IBV_EVENT_QP_LAST_WQE_REACHED:
+	       case IBV_EVENT_PORT_ERR:
+	       case IBV_EVENT_QP_REQ_ERR:
+	       case IBV_EVENT_QP_ACCESS_ERR:
+	       case IBV_EVENT_COMM_EST:
+	       case IBV_EVENT_SQ_DRAINED:
+	       case IBV_EVENT_PATH_MIG:
+	       case IBV_EVENT_PATH_MIG_ERR:
+	       case IBV_EVENT_SRQ_ERR:
+	       case IBV_EVENT_SRQ_LIMIT_REACHED:
+	       case IBV_EVENT_QP_LAST_WQE_REACHED:
 
-		*/
+	       */
 
 
-		default:
+	default:
+		break;
+	}
+
+	ibv_ack_async_event(&event);
+	return 0;
+}
+
+void *run_thread_listen_to_events(void *res_in)
+{
+	struct pollfd fds[2];
+	struct resources *res = (struct resources *)res_in;
+
+	fds[0].fd = res->ud_res->ib_ctx->async_fd;
+	fds[0].events = POLLIN;
+	fds[1].fd = res->sync_res->stop_event_fd;
+	fds[1].events = POLLIN;
+
+	while (1) {
+		if (poll(fds, 2, -1) == -1) {
+			if (errno == EINTR)
+				continue;
+			pr_err("ibv_get_async_event failed (errno = %d)\n",
+			       errno);
 			break;
 		}
 
-		ibv_ack_async_event(&event);
+		if (fds[1].revents & POLLIN)
+			break;
 
+		if (fds[0].revents & POLLIN)
+			if (do_async_event(res))
+				break;
 	}
 
 	return NULL;
 }
-
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
