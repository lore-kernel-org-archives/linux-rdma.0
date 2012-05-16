From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] librdmacm/rsocket: Succeed setsockopt REUSEADDR on
 connected sockets
Date: Wed, 16 May 2012 23:07:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A22D03@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The RDMA CM fail calls to set REUSEADDR on an rdma_cm_id if
it is not in the idle state.  As a result, this causes a failure
in NetPipe when run with socket calls intercepted by rsockets.
Fix this by returning success when REUSEADDR is set on an rsocket
that has already been connected.  When running over IB, REUSEADDR
is not necessary, since the TCP/IP addresses are mapped.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 2ffde9b..de0ec3e 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1621,7 +1621,9 @@ int rsetsockopt(int socket, int level, int optname,
 			ret = rdma_set_option(rs->cm_id, RDMA_OPTION_ID,
 					      RDMA_OPTION_ID_REUSEADDR,
 					      (void *) optval, optlen);
-			if (ret && errno == ENOSYS)
+			if (ret && ((errno == ENOSYS) || ((rs->state != rs_init) &&
+			    rs->cm_id->context &&
+			    (rs->cm_id->verbs->device->transport_type == IBV_TRANSPORT_IB))))
 				ret = 0;
 			opt_on = *(int *) optval;
 			break;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
