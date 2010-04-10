From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: keep total number of used SMPs
Date: Sat, 10 Apr 2010 03:57:52 +0300
Message-ID: <20100410005752.GL4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
 <20100410005245.GH4808@me>
 <20100410005536.GI4808@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410005536.GI4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Keep and track total number of used SMPs in smp engine structure
(total_smps field) and for statistic purpose return it with fabric
object (total_mads_used field).

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    3 ++-
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |    2 ++
 infiniband-diags/libibnetdisc/src/internal.h       |    1 +
 infiniband-diags/libibnetdisc/src/query_smp.c      |    1 +
 4 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 556014e..8c38c94 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -143,7 +143,8 @@ typedef struct ibnd_fabric {
 	ibnd_node_t *nodes;
 	/* NULL terminated list of all chassis found in the fabric */
 	ibnd_chassis_t *chassis;
-	int maxhops_discovered;
+	unsigned maxhops_discovered;
+	unsigned total_mads_used;
 
 	/* internal use only */
 	ibnd_node_t *nodestbl[HTSZ];
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 4012eff..65126dd 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -505,6 +505,8 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 		if (process_mads(&engine) != 0)
 			goto error;
 
+	fabric->total_mads_used = engine.total_smps;
+
 	if (group_nodes(fabric))
 		goto error;
 
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 05e254d..d2d4826 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -82,6 +82,7 @@ struct smp_engine {
 	cl_qmap_t smps_on_wire;
 	int num_smps_outstanding;
 	int max_smps_on_wire;
+	unsigned total_smps;
 };
 
 void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index a6878b6..1ec9752 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -133,6 +133,7 @@ int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
 	portid->sl = 0;
 	portid->qp = 0;
 
+	engine->total_smps++;
 	engine->num_smps_outstanding++;
 	queue_smp(engine, smp);
 	return process_smp_queue(engine);
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
