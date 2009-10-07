From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [ofa-general] [PATCH -- repost] infiniband-diags: Fix IB
 network discovery from switch node.
Date: Wed, 7 Oct 2009 10:35:25 -0700
Message-ID: <20091007103525.8982fc2f.weiny2@llnl.gov>
References: <4A9548AA.4020900@gmail.com>
	<20090923172451.fb20ab9b.weiny2@llnl.gov>
	<4AC232D5.2060806@gmail.com>
	<20090929164842.c1ab7d06.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090929164842.c1ab7d06.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Julia Volynsky <juliav-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

Perhaps you missed this patch the first time around.  Eli, verified that it worked for him on the switch as well as works for me.  This applies to current master as is.

Eli, I added you as signing off on this.

Thanks guys,
Ira

From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 22 Sep 2009 11:08:28 -0700
Subject: [PATCH] infiniband-diags/libibnetdisc/src/ibnetdisc.c: fix bug in single node processing.

	Eli fixed an issue with running ibnetdiscover from a switch but it
	introduced a bug in processing a single switch:

17:19:42 > ./iblinkinfo -S 0x000b8cffff00490c
Switch 0x000b8cffff00490c MT47396 Infiniscale-III Mellanox Technologies:
...
           8   11[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
           8   12[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>             [  ] "" ( )
           8   13[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
...

	The port we "come in on" when discovering the switch is not reported properly.

	This patch reverses Eli's patch and fixes his original bug in a way
	which does not introduce the above issue.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Signed-off-by: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 97e369c..96f72c5 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -506,7 +506,7 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 	    != IB_PORT_PHYS_STATE_LINKUP)
 		return 1;	/* positive == non-fatal error */
 
-	if (extend_dpath(ibmad_port, fabric, path, portnum) < 0)
+	if (portnum > 0 && extend_dpath(ibmad_port, fabric, path, portnum) < 0)
 		return -1;
 
 	if (query_node(ibmad_port, fabric, &node_buf, &port_buf, path)) {
@@ -600,15 +600,13 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	if (!port)
 		goto error;
 
-	if (node->type != IB_NODE_SWITCH) {
-		rc = get_remote_node(ibmad_port, fabric, node, port, from,
-				     mad_get_field(node->info, 0,
-						   IB_NODE_LOCAL_PORT_F), 0);
-		if (rc < 0)
-			goto error;
-		if (rc > 0)		/* non-fatal error, nothing more to be done */
-			return ((ibnd_fabric_t *) fabric);
-	}
+	rc = get_remote_node(ibmad_port, fabric, node, port, from,
+			     mad_get_field(node->info, 0,
+					   IB_NODE_LOCAL_PORT_F), 0);
+	if (rc < 0)
+		goto error;
+	if (rc > 0)		/* non-fatal error, nothing more to be done */
+		return ((ibnd_fabric_t *) fabric);
 
 	for (dist = 0; dist <= max_hops; dist++) {
 
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
