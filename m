From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] librdamcm/rsocket: Handle TCP_MAXSEG socket option
Date: Wed, 6 Jun 2012 18:42:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A2F1C1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

netperf uses the TCP_MAXSEG socket option.  Add support for it.
Problem reported by Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

getsockopt returns the path MTU as the TCP_MAXSEG.  setsockopt
currently ignores the value.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 8f20b4a..2fd106a 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1716,6 +1716,9 @@ int rsetsockopt(int socket, int level, int optname,
 			opt_on = *(int *) optval;
 			ret = 0;
 			break;
+		case TCP_MAXSEG:
+			ret = 0;
+			break;
 		default:
 			break;
 		}
@@ -1802,6 +1805,12 @@ int rgetsockopt(int socket, int level, int optname,
 			*((int *) optval) = !!(rs->tcp_opts & (1 << optname));
 			*optlen = sizeof(int);
 			break;
+		case TCP_MAXSEG:
+			*((int *) optval) = (rs->cm_id && rs->cm_id->route.num_paths) ?
+					    1 << (7 + rs->cm_id->route.path_rec->mtu) :
+					    2048;
+			*optlen = sizeof(int);
+			break;
 		default:
 			ret = ENOTSUP;
 			break;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
