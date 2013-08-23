From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ceph-users] Help needed porting Ceph to RSockets
Date: Fri, 23 Aug 2013 00:35:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA7C88@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I tested out the patch and unfortunately had the same results as
> Andreas. About 50% of the time the rpoll() thread in Ceph still hangs
> when rshutdown() is called. I saw a similar behaviour when increasing
> the poll time on the pre-patched version if that's of any relevance.

I'm not optimistic, but here's an updated patch.  I attempted to handle more
shutdown conditions, but I can't say that any of those would prevent the
hang that you see.

I have a couple of questions: 

Is there any chance that the code would call rclose while rpoll
is still running?  Also, can you verify that the thread is in the
real poll() call when the hang occurs?

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index d544dd0..f94ddf3 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1822,7 +1822,12 @@ static int rs_poll_cq(struct rsocket *rs)
 					rs->state = rs_disconnected;
 					return 0;
 				} else if (rs_msg_data(msg) == RS_CTRL_SHUTDOWN) {
-					rs->state &= ~rs_readable;
+					if (rs->state & rs_writable) {
+						rs->state &= ~rs_readable;
+					} else {
+						rs->state = rs_disconnected;
+						return 0;
+					}
 				}
 				break;
 			case RS_OP_WRITE:
@@ -2948,10 +2953,12 @@ static int rs_poll_events(struct pollfd *rfds, struct pollfd *fds, nfds_t nfds)
 
 		rs = idm_lookup(&idm, fds[i].fd);
 		if (rs) {
+			fastlock_acquire(&rs->cq_wait_lock);
 			if (rs->type == SOCK_STREAM)
 				rs_get_cq_event(rs);
 			else
 				ds_get_cq_event(rs);
+			fastlock_release(&rs->cq_wait_lock);
 			fds[i].revents = rs_poll_rs(rs, fds[i].events, 1, rs_poll_all);
 		} else {
 			fds[i].revents = rfds[i].revents;
@@ -3098,7 +3105,8 @@ int rselect(int nfds, fd_set *readfds, fd_set *writefds,
 
 /*
  * For graceful disconnect, notify the remote side that we're
- * disconnecting and wait until all outstanding sends complete.
+ * disconnecting and wait until all outstanding sends complete, provided
+ * that the remote side has not sent a disconnect message.
  */
 int rshutdown(int socket, int how)
 {
@@ -3106,11 +3114,6 @@ int rshutdown(int socket, int how)
 	int ctrl, ret = 0;
 
 	rs = idm_at(&idm, socket);
-	if (how == SHUT_RD) {
-		rs->state &= ~rs_readable;
-		return 0;
-	}
-
 	if (rs->fd_flags & O_NONBLOCK)
 		rs_set_nonblocking(rs, 0);
 
@@ -3118,15 +3121,20 @@ int rshutdown(int socket, int how)
 		if (how == SHUT_RDWR) {
 			ctrl = RS_CTRL_DISCONNECT;
 			rs->state &= ~(rs_readable | rs_writable);
-		} else {
+		} else if (how == SHUT_WR) {
 			rs->state &= ~rs_writable;
 			ctrl = (rs->state & rs_readable) ?
 				RS_CTRL_SHUTDOWN : RS_CTRL_DISCONNECT;
+		} else {
+			rs->state &= ~rs_readable;
+			if (rs->state & rs_writable)
+				goto out;
+			ctrl = RS_CTRL_DISCONNECT;
 		}
 		if (!rs->ctrl_avail) {
 			ret = rs_process_cq(rs, 0, rs_conn_can_send_ctrl);
 			if (ret)
-				return ret;
+				goto out;
 		}
 
 		if ((rs->state & rs_connected) && rs->ctrl_avail) {
@@ -3138,10 +3146,17 @@ int rshutdown(int socket, int how)
 	if (rs->state & rs_connected)
 		rs_process_cq(rs, 0, rs_conn_all_sends_done);
 
+out:
 	if ((rs->fd_flags & O_NONBLOCK) && (rs->state & rs_connected))
 		rs_set_nonblocking(rs, rs->fd_flags);
 
-	return 0;
+	if (rs->state & rs_disconnected) {
+		/* Generate event by flushing receives to unblock rpoll */
+		ibv_req_notify_cq(rs->cm_id->recv_cq, 0);
+		rdma_disconnect(rs->cm_id);
+	}
+
+	return ret;
 }
 
 static void ds_shutdown(struct rsocket *rs)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
