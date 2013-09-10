From: Andreas Bluemle <andreas.bluemle@itxperts.de>
Subject: Re: [ceph-users] Help needed porting Ceph to RSockets
Date: Tue, 10 Sep 2013 15:48:47 +0200
Message-ID: <20130910154847.3fb7dd02@doppio>
References: <1828884A29C6694DAF28B7E6B8A8237388CA7C88@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/pu3qin9zJqsoehz9dlwqXgW"
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA7C88@ORSMSX109.amr.corp.intel.com>
Sender: ceph-devel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Matthew Anderson <manderson8787@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--MP_/pu3qin9zJqsoehz9dlwqXgW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

after some more analysis and debugging, I found
workarounds for my problems; I have added these workarounds
to the last version of the patch for the poll problem by Sean;
see the attachment to this posting.

The shutdown() operations below are all SHUT_RDWR.

1. shutdown() on side A of a connection waits for close() on side B

   With rsockets, when a shutdown is done on side A of a socket
   connection, then the shutdown will only return after side B
   has done a close() on its end of the connection.

   This is different from TCP/IP sockets: there a shutdown will cause
   the other end to terminate the connection at the TCP level
   instantly. The socket changes state into CLOSE_WAIT, which indicates
   that the application level close is outstanding.

   In the attached patch, the workaround is in rs_poll_cq(),
   case RS_OP_CTRL, where for a RS_CTRL_DISCONNECT the rshutdown()
   is called on side B; this will cause the termination of the
   socket connection to acknowledged to side A and the shutdown()
   there can now terminate.

2. double (multiple) shutdown on side A: delay on 2nd shutdown

   When an application does a shutdown() of side A and does a 2nd
   shutdown() shortly after (for whatever reason) then the
   return of the 2nd shutdown() is delayed by 2 seconds.

   The delay happens in rdma_disconnect(), when this is called
   from rshutdown() in the case that the rsocket state is
   rs_disconnected.

   Even if it could be considered as a bug if an application
   calls shutdown() twice on the same socket, it still
   does not make sense to delay that 2nd call to shutdown().

   To workaround this, I have
   - introduced an additional rsocket state: rs_shutdown
   - switch to that new state in rshutdown() at the very end
     of the function.

   The first call to shutdown() will therefore switch to the new
   rsocket state rs_shutdown - and any further call to rshutdown()
   will not do anything any more, because every effect of rshutdown()
   will only happen if the rsocket state is either rs_connnected or
   rs_disconnected. Hence it would be better to explicitely check
   the rsocket state at the beginning of the function and return
   immediately if the state is rs_shutdown.

Since I have added these workarounds to my version of the librdmacm
library, I can at least start up ceph using LD_PRELOAD and end up in
a healthy ceph cluster state.

I would not call these workarounds a real fix, but they should point
out the problems which I am trying to solve.


Regards

Andreas Bluemle




On Fri, 23 Aug 2013 00:35:22 +0000
"Hefty, Sean" <sean.hefty@intel.com> wrote:

> > I tested out the patch and unfortunately had the same results as
> > Andreas. About 50% of the time the rpoll() thread in Ceph still
> > hangs when rshutdown() is called. I saw a similar behaviour when
> > increasing the poll time on the pre-patched version if that's of
> > any relevance.
> 
> I'm not optimistic, but here's an updated patch.  I attempted to
> handle more shutdown conditions, but I can't say that any of those
> would prevent the hang that you see.
> 
> I have a couple of questions: 
> 
> Is there any chance that the code would call rclose while rpoll
> is still running?  Also, can you verify that the thread is in the
> real poll() call when the hang occurs?
> 
> Signed-off-by: Sean Hefty <sean.hefty@intel.com>
> ---
>  src/rsocket.c |   35 +++++++++++++++++++++++++----------
>  1 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/src/rsocket.c b/src/rsocket.c
> index d544dd0..f94ddf3 100644
> --- a/src/rsocket.c
> +++ b/src/rsocket.c
> @@ -1822,7 +1822,12 @@ static int rs_poll_cq(struct rsocket *rs)
>  					rs->state = rs_disconnected;
>  					return 0;
>  				} else if (rs_msg_data(msg) ==
> RS_CTRL_SHUTDOWN) {
> -					rs->state &= ~rs_readable;
> +					if (rs->state & rs_writable)
> {
> +						rs->state &=
> ~rs_readable;
> +					} else {
> +						rs->state =
> rs_disconnected;
> +						return 0;
> +					}
>  				}
>  				break;
>  			case RS_OP_WRITE:
> @@ -2948,10 +2953,12 @@ static int rs_poll_events(struct pollfd
> *rfds, struct pollfd *fds, nfds_t nfds) 
>  		rs = idm_lookup(&idm, fds[i].fd);
>  		if (rs) {
> +			fastlock_acquire(&rs->cq_wait_lock);
>  			if (rs->type == SOCK_STREAM)
>  				rs_get_cq_event(rs);
>  			else
>  				ds_get_cq_event(rs);
> +			fastlock_release(&rs->cq_wait_lock);
>  			fds[i].revents = rs_poll_rs(rs,
> fds[i].events, 1, rs_poll_all); } else {
>  			fds[i].revents = rfds[i].revents;
> @@ -3098,7 +3105,8 @@ int rselect(int nfds, fd_set *readfds, fd_set
> *writefds, 
>  /*
>   * For graceful disconnect, notify the remote side that we're
> - * disconnecting and wait until all outstanding sends complete.
> + * disconnecting and wait until all outstanding sends complete,
> provided
> + * that the remote side has not sent a disconnect message.
>   */
>  int rshutdown(int socket, int how)
>  {
> @@ -3106,11 +3114,6 @@ int rshutdown(int socket, int how)
>  	int ctrl, ret = 0;
>  
>  	rs = idm_at(&idm, socket);
> -	if (how == SHUT_RD) {
> -		rs->state &= ~rs_readable;
> -		return 0;
> -	}
> -
>  	if (rs->fd_flags & O_NONBLOCK)
>  		rs_set_nonblocking(rs, 0);
>  
> @@ -3118,15 +3121,20 @@ int rshutdown(int socket, int how)
>  		if (how == SHUT_RDWR) {
>  			ctrl = RS_CTRL_DISCONNECT;
>  			rs->state &= ~(rs_readable | rs_writable);
> -		} else {
> +		} else if (how == SHUT_WR) {
>  			rs->state &= ~rs_writable;
>  			ctrl = (rs->state & rs_readable) ?
>  				RS_CTRL_SHUTDOWN :
> RS_CTRL_DISCONNECT;
> +		} else {
> +			rs->state &= ~rs_readable;
> +			if (rs->state & rs_writable)
> +				goto out;
> +			ctrl = RS_CTRL_DISCONNECT;
>  		}
>  		if (!rs->ctrl_avail) {
>  			ret = rs_process_cq(rs, 0,
> rs_conn_can_send_ctrl); if (ret)
> -				return ret;
> +				goto out;
>  		}
>  
>  		if ((rs->state & rs_connected) && rs->ctrl_avail) {
> @@ -3138,10 +3146,17 @@ int rshutdown(int socket, int how)
>  	if (rs->state & rs_connected)
>  		rs_process_cq(rs, 0, rs_conn_all_sends_done);
>  
> +out:
>  	if ((rs->fd_flags & O_NONBLOCK) && (rs->state &
> rs_connected)) rs_set_nonblocking(rs, rs->fd_flags);
>  
> -	return 0;
> +	if (rs->state & rs_disconnected) {
> +		/* Generate event by flushing receives to unblock
> rpoll */
> +		ibv_req_notify_cq(rs->cm_id->recv_cq, 0);
> +		rdma_disconnect(rs->cm_id);
> +	}
> +
> +	return ret;
>  }
>  
>  static void ds_shutdown(struct rsocket *rs)
> 
> 
> 



-- 
Andreas Bluemle                     mailto:Andreas.Bluemle@itxperts.de
ITXperts GmbH                       http://www.itxperts.de
Balanstrasse 73, Geb. 08            Phone: (+49) 89 89044917
D-81541 Muenchen (Germany)          Fax:   (+49) 89 89044910

Company details: http://www.itxperts.de/imprint.htm

--MP_/pu3qin9zJqsoehz9dlwqXgW
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=rsocket-poll-hefty2+shutdown-andy.patch

diff --git a/src/rsocket.c b/src/rsocket.c
index abdd392..76fbb85 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -206,6 +206,7 @@ enum rs_state {
 	rs_connect_error   =		    0x0800,
 	rs_disconnected	   =		    0x1000,
 	rs_error	   =		    0x2000,
+	rs_shutdown	   =		    0x4000,
 };
 
 #define RS_OPT_SWAP_SGL	(1 << 0)
@@ -1786,9 +1787,15 @@ static int rs_poll_cq(struct rsocket *rs)
 			case RS_OP_CTRL:
 				if (rs_msg_data(msg) == RS_CTRL_DISCONNECT) {
 					rs->state = rs_disconnected;
+					rshutdown(rs->index, SHUT_RDWR);
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
@@ -2914,10 +2921,12 @@ static int rs_poll_events(struct pollfd *rfds, struct pollfd *fds, nfds_t nfds)
 
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
@@ -3064,7 +3073,8 @@ int rselect(int nfds, fd_set *readfds, fd_set *writefds,
 
 /*
  * For graceful disconnect, notify the remote side that we're
- * disconnecting and wait until all outstanding sends complete.
+ * disconnecting and wait until all outstanding sends complete, provided
+ * that the remote side has not sent a disconnect message.
  */
 int rshutdown(int socket, int how)
 {
@@ -3072,11 +3082,6 @@ int rshutdown(int socket, int how)
 	int ctrl, ret = 0;
 
 	rs = idm_at(&idm, socket);
-	if (how == SHUT_RD) {
-		rs->state &= ~rs_readable;
-		return 0;
-	}
-
 	if (rs->fd_flags & O_NONBLOCK)
 		rs_set_nonblocking(rs, 0);
 
@@ -3084,15 +3089,20 @@ int rshutdown(int socket, int how)
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
@@ -3104,10 +3114,19 @@ int rshutdown(int socket, int how)
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
+	rs->state = rs_shutdown;
+
+	return ret;
 }
 
 static void ds_shutdown(struct rsocket *rs)

--MP_/pu3qin9zJqsoehz9dlwqXgW--
