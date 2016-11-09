From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 05/14] SUNRPC: Proper metric accounting when RPC is not
 transmitted
Date: Wed, 09 Nov 2016 14:05:29 -0500
Message-ID: <20161109190529.15007.84163.stgit@manet.1015granger.net>
References: <20161109184735.15007.96507.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109184735.15007.96507.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I noticed recently that during an xfstests on a krb5i mount, the
retransmit count for certain operations had gone negative, and the
backlog value became unreasonably large. I recall that Andy has
pointed this out to me in the past.

When call_refresh fails to find a valid credential for an RPC, the
RPC exits immediately without sending anything on the wire. This
leaves rq_ntrans, rq_xtime, and rq_rtt set to zero.

The solution for om_queue is to not add the to RPC's running backlog
queue total whenever rq_xtime is zero.

For om_ntrans, it's a bit more difficult. A zero rq_ntrans causes
om_ops to become larger than om_ntrans. The design of the RPC
metrics API assumes that ntrans will always be equal to or larger
than the ops count. The result is that when an RPC fails to find
credentials, the RPC operation's reported retransmit count, which is
computed in user space as the difference between ops and ntrans,
goes negative.

Ideally the kernel API should report a separate retransmit and
"exited before initial transmission" metric, so that user space can
sort out the difference properly.

To avoid kernel API changes and changes to the way rq_ntrans is used
when performing transport locking, account for untransmitted RPCs
so that om_ntrans keeps up with om_ops: always add one or more to
om_ntrans.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/stats.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/stats.c b/net/sunrpc/stats.c
index 2ecb994..caeb01a 100644
--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -157,15 +157,17 @@ void rpc_count_iostats_metrics(const struct rpc_task *task,
 	spin_lock(&op_metrics->om_lock);
 
 	op_metrics->om_ops++;
-	op_metrics->om_ntrans += req->rq_ntrans;
+	/* kernel API: om_ops must never become larger than om_ntrans */
+	op_metrics->om_ntrans += max(req->rq_ntrans, 1);
 	op_metrics->om_timeouts += task->tk_timeouts;
 
 	op_metrics->om_bytes_sent += req->rq_xmit_bytes_sent;
 	op_metrics->om_bytes_recv += req->rq_reply_bytes_recvd;
 
-	delta = ktime_sub(req->rq_xtime, task->tk_start);
-	op_metrics->om_queue = ktime_add(op_metrics->om_queue, delta);
-
+	if (ktime_to_ns(req->rq_xtime)) {
+		delta = ktime_sub(req->rq_xtime, task->tk_start);
+		op_metrics->om_queue = ktime_add(op_metrics->om_queue, delta);
+	}
 	op_metrics->om_rtt = ktime_add(op_metrics->om_rtt, req->rq_rtt);
 
 	delta = ktime_sub(now, task->tk_start);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
