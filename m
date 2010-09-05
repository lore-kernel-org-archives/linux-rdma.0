From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags: Do not exit when unexpected node found
Date: Sun, 05 Sep 2010 11:28:57 +0300
Message-ID: <4C8354C9.5070502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Show error message but do not exit when unexpected node is found.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index 25d7473..7762d22 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -457,7 +457,6 @@ static int get_sfb_slot(ibnd_node_t * n, ibnd_port_t * lineport)
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   n->guid);
-		return -1;
 	}
 	return 0;
 }
@@ -498,7 +497,6 @@ static int get_router_slot(ibnd_node_t * n, ibnd_port_t * spineport)
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   spineport->node->guid);
-		return -1;
 	}
 	return 0;
 }
@@ -533,7 +531,6 @@ static int get_slb_slot(ibnd_node_t * n, ibnd_port_t * spineport)
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   spineport->node->guid);
-		return -1;
 	}
 	return 0;
 }
@@ -588,8 +585,7 @@ static int fill_voltaire_chassis_record(ibnd_node_t * node)
 			}
 			if (!node->ch_type)
 				/* we assume here that remoteport belongs to line */
-				if (get_sfb_slot(node, port->remoteport))
-					return -1;
+				get_sfb_slot(node, port->remoteport);
 
 			/* we could break here, but need to find if more routers connected */
 		}
@@ -607,8 +603,7 @@ static int fill_voltaire_chassis_record(ibnd_node_t * node)
 				continue;
 
 			/* we assume here that remoteport belongs to spine */
-			if (get_slb_slot(node, port->remoteport))
-				return -1;
+			get_slb_slot(node, port->remoteport);
 			break;
 		}
 	}
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
