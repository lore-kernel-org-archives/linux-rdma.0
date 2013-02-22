From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_req.c: Better implementation of req_determine_mkey
Date: Fri, 22 Feb 2013 10:34:45 -0500
Message-ID: <51279015.10105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Eliminate compile warning:
osm_req.c: In function =C3=A2=C2=80=C2=98req_determine_mkey=C3=A2=C2=80=
=C2=99:
osm_req.c:69: warning: =C3=A2=C2=80=C2=98p_node=C3=A2=C2=80=C2=99 may b=
e used uninitialized in this function

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index f9ffc81..e0634e0 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -80,31 +80,27 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * =
sm,
=20
 	/* hop_count =3D=3D 0: destination port guid is SM */
 	if (p_path->hop_count =3D=3D 0) {
-		if (p_sm_port !=3D NULL)
-			dest_port_guid =3D sm->p_subn->sm_port_guid;
-		else
-			dest_port_guid =3D sm->p_subn->opt.guid;
+		dest_port_guid =3D sm->p_subn->sm_port_guid;
 		goto Remote_Guid;
 	}
=20
 	if (p_sm_port) {
-		/* get the node for the SM */
 		p_node =3D p_sm_port->p_node;
-		p_physp =3D p_sm_port->p_physp;
+		if (osm_node_get_type(p_node) =3D=3D IB_NODE_TYPE_SWITCH)
+			p_physp =3D osm_node_get_physp_ptr(p_node, p_path->path[1]);
+		else
+			p_physp =3D p_sm_port->p_physp;
 	}
=20
-	for (hop =3D 1; p_physp && hop < p_path->hop_count; hop++) {
-		p_physp =3D osm_node_get_physp_ptr(p_node, p_path->path[hop]);
+	/* hop_count =3D=3D 1: outgoing physp is SM physp */
+	for (hop =3D 2; p_physp && hop <=3D p_path->hop_count; hop++) {
+		p_physp =3D p_physp->p_remote_physp;
 		if (!p_physp)
 			break;
-		p_physp =3D osm_physp_get_remote(p_physp);
-		if (!p_physp)
-			break;
-		p_node =3D osm_physp_get_node_ptr(p_physp);
+		p_node =3D p_physp->p_node;
+		p_physp =3D osm_node_get_physp_ptr(p_node, p_path->path[hop]);
 	}
=20
-	p_physp =3D osm_node_get_physp_ptr(p_node, p_path->path[hop]);
-
 	/* At this point, p_physp points at the outgoing physp on the
 	   last hop, or NULL if we don't know it.
 	*/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
