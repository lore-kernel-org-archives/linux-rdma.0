From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: add \n at end of error messages
Date: Tue, 13 Apr 2010 17:56:35 +0300
Message-ID: <20100413145635.GL10830@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
 <20100410005245.GH4808@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410005245.GH4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add '\n' new line character at end of error messages printouts.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c   |    6 +++---
 infiniband-diags/libibnetdisc/src/query_smp.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index 1a839d9..80e034b 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -378,7 +378,7 @@ static int get_sfb_slot(ibnd_node_t * n, ibnd_port_t * lineport)
 		n->ch_slotnum = spine4_slot_2_slb[lineport->portnum];
 		n->ch_anafanum = anafa_spine4_slot_2_slb[lineport->portnum];
 	} else {
-		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64,
+		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   n->guid);
 		return -1;
 	}
@@ -419,7 +419,7 @@ static int get_router_slot(ibnd_node_t * n, ibnd_port_t * spineport)
 		n->ch_slotnum = line_slot_2_sfb4[spineport->portnum];
 		n->ch_anafanum = ipr_slot_2_sfb4_port[spineport->portnum];
 	} else {
-		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64,
+		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   spineport->node->guid);
 		return -1;
 	}
@@ -446,7 +446,7 @@ static int get_slb_slot(ibnd_node_t * n, ibnd_port_t * spineport)
 		n->ch_slotnum = line_slot_2_sfb4[spineport->portnum];
 		n->ch_anafanum = anafa_line_slot_2_sfb4[spineport->portnum];
 	} else {
-		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64,
+		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   spineport->node->guid);
 		return -1;
 	}
diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index 1ec9752..b4322bc 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -71,7 +71,7 @@ static int send_smp(ibnd_smp_t * smp, struct ibmad_port *srcport)
 
 	if ((rc = mad_build_pkt(umad, &smp->rpc, &smp->path, NULL, NULL))
 	    < 0) {
-		IBND_ERROR("mad_build_pkt failed; %d", rc);
+		IBND_ERROR("mad_build_pkt failed; %d\n", rc);
 		return rc;
 	}
 
@@ -80,7 +80,7 @@ static int send_smp(ibnd_smp_t * smp, struct ibmad_port *srcport)
 			    umad, IB_MAD_SIZE,
 			    mad_get_timeout(srcport, rpc->timeout),
 			    mad_get_retries(srcport))) < 0) {
-		IBND_ERROR("send failed; %d", rc);
+		IBND_ERROR("send failed; %d\n", rc);
 		return rc;
 	}
 
@@ -109,7 +109,7 @@ int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
 {
 	ibnd_smp_t *smp = calloc(1, sizeof *smp);
 	if (!smp) {
-		IBND_ERROR("OOM");
+		IBND_ERROR("OOM\n");
 		return -ENOMEM;
 	}
 
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
