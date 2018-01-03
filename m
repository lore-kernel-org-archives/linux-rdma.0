From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] sunrpc: Format RPC events consistently for display
Date: Wed, 03 Jan 2018 15:38:33 -0500
Message-ID: <20180103203833.29209.32335.stgit@manet.1015granger.net>
References: <20180103203540.29209.4620.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103203540.29209.4620.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: Make it easier to use text search when browsing a trace
report. Other events use "status=%d".

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/trace/events/sunrpc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 7804d85..0594e66 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -32,7 +32,7 @@
 		__entry->status = task->tk_status;
 	),
 
-	TP_printk("task:%u@%u, status %d",
+	TP_printk("task:%u@%u status=%d",
 		__entry->task_id, __entry->client_id,
 		__entry->status)
 );
@@ -66,7 +66,7 @@
 		__entry->status = status;
 	),
 
-	TP_printk("task:%u@%u, status %d",
+	TP_printk("task:%u@%u status=%d",
 		__entry->task_id, __entry->client_id,
 		__entry->status)
 );

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
