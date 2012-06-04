From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] ibacm: Automatically select local port if not specified
 by path record
Date: Mon, 4 Jun 2012 19:20:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A25C3E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the user specifies a DLID or DGID as part of a path record lookup,
automatically select a local port.  This allows a user to query an SA
without needing to specify the local SLID or SGID.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index c940df3..b6fa32f 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -956,7 +956,7 @@ acm_record_path_addr(struct acm_ep *ep, struct acm_dest *dest,
 		dest->path.sgid = path->sgid;
 		dest->path.slid = path->slid;
 	} else {
-		dest->path.slid = ep->port->lid;
+		dest->path.slid = htons(ep->port->lid);
 	}
 	dest->path.dlid = path->dlid;
 	dest->state = ACM_ADDR_RESOLVED;
@@ -1762,6 +1762,10 @@ acm_is_path_from_port(struct acm_port *port, struct ibv_path_record *path)
 		return (port->lid == (ntohs(path->slid) & port->lid_mask));
 	}
 
+	if (ib_any_gid(&path->dgid)) {
+		return 1;
+	}
+
 	if (acm_gid_index(port, &path->dgid) < port->gid_cnt) {
 		return 1;
 	}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
