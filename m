From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/8] librdmacm: Do not wait in rdma_accept for UD QPs
Date: Wed, 15 Jun 2011 17:46:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021321@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are no additional connection events to process for UD QPs
after calling rdma_accept().  When using synchronous rdma_cm_id's,
simply return to the user after sending the reply.  Do not wait
for additional events.

This fixes a hang on the server side when setting up UD QP
communication.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index eb339c9..bad1ba3 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -1502,6 +1502,9 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 	}
 
+	if (ucma_is_ud_qp(id->qp_type))
+		return 0;
+
 	return ucma_complete(id_priv);
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
