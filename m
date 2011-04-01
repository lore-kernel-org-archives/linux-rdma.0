From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] ibacm: Join only the base multicast group if using SA
 path resolution
Date: Fri, 1 Apr 2011 16:56:06 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC95015D@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC95015A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC95015A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the ACM service is configured to use the SA to resolve path
record data, then only join the base multicast group.  We only
need to join other groups if we're creating path records based
on multicast data, using the acm route protocol.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 3df996b..fe42498 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1556,7 +1556,8 @@ static void acm_port_join(struct acm_port *port)
 		if ((ep->state = ep->mc_dest[0].state) != ACM_READY)
 			continue;
 
-		if (port->rate != min_rate || port->mtu != min_mtu)
+		if ((route_prot == ACM_ROUTE_PROT_ACM) &&
+		    (port->rate != min_rate || port->mtu != min_mtu))
 			acm_join_group(ep, &port_gid, 0, 0, 0, port->rate, port->mtu);
 	}
 	acm_log(1, "joins for device %s port %d complete\n", dev->verbs->device->name,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
