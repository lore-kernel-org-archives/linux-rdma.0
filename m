From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 5/7] Track asynchronous events on a work queue
Date: Tue, 30 Aug 2016 18:09:54 +0300
Message-ID: <1472569796-26162-6-git-send-email-yishaih@mellanox.com>
References: <1472569796-26162-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472569796-26162-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add support to track asynchronous events on a work queue object.
For now only IBV_EVENT_WQ_FATAL is applicable.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |  2 ++
 src/device.c               | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 88ac4bb..eab5d1b 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -341,6 +341,7 @@ enum ibv_event_type {
 	IBV_EVENT_QP_LAST_WQE_REACHED,
 	IBV_EVENT_CLIENT_REREGISTER,
 	IBV_EVENT_GID_CHANGE,
+	IBV_EVENT_WQ_FATAL,
 };
 
 struct ibv_async_event {
@@ -348,6 +349,7 @@ struct ibv_async_event {
 		struct ibv_cq  *cq;
 		struct ibv_qp  *qp;
 		struct ibv_srq *srq;
+		struct ibv_wq  *wq;
 		int		port_num;
 	} element;
 	enum ibv_event_type	event_type;
diff --git a/src/device.c b/src/device.c
index e520295..82d928a 100644
--- a/src/device.c
+++ b/src/device.c
@@ -298,6 +298,9 @@ int __ibv_get_async_event(struct ibv_context *context,
 		event->element.srq = (void *) (uintptr_t) ev.element;
 		break;
 
+	case IBV_EVENT_WQ_FATAL:
+		event->element.wq = (void *) (uintptr_t) ev.element;
+		break;
 	default:
 		event->element.port_num = ev.element;
 		break;
@@ -357,6 +360,18 @@ void __ibv_ack_async_event(struct ibv_async_event *event)
 		return;
 	}
 
+	case IBV_EVENT_WQ_FATAL:
+	{
+		struct ibv_wq *wq = event->element.wq;
+
+		pthread_mutex_lock(&wq->mutex);
+		++wq->events_completed;
+		pthread_cond_signal(&wq->cond);
+		pthread_mutex_unlock(&wq->mutex);
+
+		return;
+	}
+
 	default:
 		return;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
