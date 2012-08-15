From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] librdmacm/rsockets: Support MSG_WAITALL with rsockets
 recv()
Date: Wed, 15 Aug 2012 16:55:16 -0700
Message-ID: <1345074916.640.19.camel@oc1677441337.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support MSG_WAITALL flag with recv() when using rsockets.

Signed-off-by: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/src/rsocket.c b/src/rsocket.c
index b9105a1..81f2654 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1131,6 +1131,7 @@ ssize_t rrecv(int socket, void *buf, size_t len, int flags)
 		}
 	}
 	fastlock_acquire(&rs->rlock);
+waitall:
 	if (!rs_have_rdata(rs)) {
 		ret = rs_get_comp(rs, rs_nonblocking(rs, flags), rs_conn_have_rdata);
 		if (ret)
@@ -1167,6 +1168,10 @@ ssize_t rrecv(int socket, void *buf, size_t len, int flags)
 		buf += rsize;
 	}
 	rs->rbuf_bytes_avail += len - left;
+
+	if ((flags & MSG_WAITALL) && left)
+		goto waitall;
+
 out:
 	fastlock_release(&rs->rlock);
 	return ret ? ret : len - left;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
