From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/16] librdmacm/rsockets: Define options specific to rsockets
Date: Wed, 30 May 2012 17:21:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24C05@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow a user to control some of the RDMA related attributes
of an rsocket through setsockopt/getsockopt.  A user specifies
that the rsocket should be modified through SOL_RDMA level.

This patch provides the initial framework.  Subsequent patches
will add the configurable parameters.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This deviates from standard sockets, but it seems to be the best way
to provide the user some control over the RDMA portion of an rsocket.

 include/rdma/rsocket.h |    2 ++
 src/rsocket.c          |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rsocket.h b/include/rdma/rsocket.h
index 5310d33..87ee943 100644
--- a/include/rdma/rsocket.h
+++ b/include/rdma/rsocket.h
@@ -72,6 +72,8 @@ int rselect(int nfds, fd_set *readfds, fd_set *writefds,
 int rgetpeername(int socket, struct sockaddr *addr, socklen_t *addrlen);
 int rgetsockname(int socket, struct sockaddr *addr, socklen_t *addrlen);
 
+#define SOL_RDMA 0x10000
+
 int rsetsockopt(int socket, int level, int optname,
 		const void *optval, socklen_t optlen);
 int rgetsockopt(int socket, int level, int optname,
diff --git a/src/rsocket.c b/src/rsocket.c
index 59cc13c..ee31e0c 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1710,6 +1710,8 @@ int rsetsockopt(int socket, int level, int optname,
 			break;
 		}
 		break;
+	case SOL_RDMA:
+		break;
 	default:
 		break;
 	}
@@ -1775,6 +1777,9 @@ int rgetsockopt(int socket, int level, int optname,
 			break;
 		}
 		break;
+	case SOL_RDMA:
+		ret = ENOTSUP;
+		break;
 	default:
 		ret = ENOTSUP;
 		break;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
