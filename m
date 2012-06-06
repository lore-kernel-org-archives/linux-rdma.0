From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] librdamcm/rsocket: Handle SHUT_RD/WR shutdown flags
Date: Wed, 6 Jun 2012 18:42:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A2F1ED@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> reported an error (EOPNOTSUPP)
after calling select().

The issue is that rshutdown(SHUT_WR) was called before select().
As part of shutdown, rsockets switches the underlying fd from
nonblocking to blocking to ensure that previously sent data has
completed.  shutdown(SHUT_WR) indicates that the socket should be
kept open for receiving data.

Delay handling the actual shutdown unless SHUT_RDWR is specified,
or the socket is closed.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index c111797..8f20b4a 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1592,6 +1592,9 @@ int rshutdown(int socket, int how)
 	struct rsocket *rs;
 	int ret = 0;
 
+	if (how != SHUT_RDWR)
+		return 0;
+
 	rs = idm_at(&idm, socket);
 	if (rs->fd_flags & O_NONBLOCK)
 		rs_set_nonblocking(rs, 0);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
