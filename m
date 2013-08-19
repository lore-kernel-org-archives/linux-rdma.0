From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ceph-users] Help needed porting Ceph to RSockets
Date: Mon, 19 Aug 2013 17:10:11 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA6C27@ORSMSX109.amr.corp.intel.com>
References: <CAJA05UmTDGze7S50_j8RgHmPFYonk2Z94Fi6CQtxND9QxgRr3g@mail.gmail.com>
	<CAJA05Umgio7XftGZtQdRzyWq70pXBb3oEx2jrT3BxcBr6MLoVQ@mail.gmail.com>
	<20130812075513.43c338e1@andylap>
	<CAJA05U=i22jHy2xbvCUk+UVN0+hOFDgt-JMSHTWKmr1+DZu0Dg@mail.gmail.com>
	<20130812180644.447ca089@andylap>
	<CAJA05U=KqzYis14sYXusbpk-T-F=uqvNz1XPurutmdeRz6BAdg@mail.gmail.com>
	<20130813075312.7cac0d46@andylap>	<20130813160612.037ea9f2@andylap>
	<1978D1F9-C675-4A37-AA57-C7E1158B2F72@ornl.gov>
	<1828884A29C6694DAF28B7E6B8A8237388CA5A0F@ORSMSX109.amr.corp.intel.com>
 <20130814092124.3f8c3b03@doppio>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130814092124.3f8c3b03@doppio>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>
Cc: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Can you see if the patch below fixes the hang?

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index d544dd0..e45b26d 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -2948,10 +2948,12 @@ static int rs_poll_events(struct pollfd *rfds, struct pollfd *fds, nfds_t nfds)
 
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
@@ -3098,7 +3100,8 @@ int rselect(int nfds, fd_set *readfds, fd_set *writefds,
 
 /*
  * For graceful disconnect, notify the remote side that we're
- * disconnecting and wait until all outstanding sends complete.
+ * disconnecting and wait until all outstanding sends complete, provided
+ * that the remote side has not sent a disconnect message.
  */
 int rshutdown(int socket, int how)
 {
@@ -3138,6 +3141,12 @@ int rshutdown(int socket, int how)
 	if (rs->state & rs_connected)
 		rs_process_cq(rs, 0, rs_conn_all_sends_done);
 
+	if (rs->state & rs_disconnected) {
+		/* Generate event by flushing receives to unblock rpoll */
+		ibv_req_notify_cq(rs->cm_id->recv_cq, 0);
+		rdma_disconnect(rs->cm_id);
+	}
+
 	if ((rs->fd_flags & O_NONBLOCK) && (rs->state & rs_connected))
 		rs_set_nonblocking(rs, rs->fd_flags);
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
