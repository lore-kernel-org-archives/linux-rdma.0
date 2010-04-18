From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: remove not needed num_smps_outstanding
 counter
Date: Sun, 18 Apr 2010 19:10:28 +0300
Message-ID: <20100418161028.GL11943@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413163836.GM10830@me>
 <20100413133826.00a8afc5.weiny2@llnl.gov>
 <20100413134446.72eb336a.weiny2@llnl.gov>
 <20100414102335.GT10830@me>
 <0EEE4F40-F1DD-46A6-B756-3C46DA06B403@llnl.gov>
 <20100416120505.GB11943@me>
 <20100418154950.GI11943@me>
 <20100418155636.GJ11943@me>
 <20100418160357.GK11943@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100418160357.GK11943@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Now 'num_smps_outstanding' represents number of MADs on a wire, which is
duplicates by using its qmap's cl_qmap_count() function.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/internal.h  |    1 -
 infiniband-diags/libibnetdisc/src/query_smp.c |   14 ++++----------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 57034f9..571b2f4 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -80,7 +80,6 @@ struct smp_engine {
 	ibnd_smp_t *smp_queue_tail;
 	void *user_data;
 	cl_qmap_t smps_on_wire;
-	int num_smps_outstanding;
 	int max_smps_on_wire;
 	unsigned total_smps;
 };
diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index d38c2ef..7234844 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -100,7 +100,6 @@ static int process_smp_queue(smp_engine_t * engine)
 			free(smp);
 			return rc;
 		}
-		engine->num_smps_outstanding++;
 		cl_qmap_insert(&engine->smps_on_wire, (uint32_t) smp->rpc.trid,
 			       (cl_map_item_t *) smp);
 		engine->total_smps++;
@@ -171,7 +170,6 @@ static int process_one_recv(smp_engine_t * engine)
 		return -1;
 	}
 
-	engine->num_smps_outstanding--;
 	rc = process_smp_queue(engine);
 	if (rc)
 		goto error;
@@ -199,7 +197,6 @@ void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
 	engine->ibmad_port = ibmad_port;
 	engine->user_data = user_data;
 	cl_qmap_init(&engine->smps_on_wire);
-	engine->num_smps_outstanding = 0;
 	engine->max_smps_on_wire = max_smps_on_wire;
 }
 
@@ -224,16 +221,13 @@ void smp_engine_destroy(smp_engine_t * engine)
 		cl_qmap_remove_item(&engine->smps_on_wire, item);
 		free(item);
 	}
-
-	engine->num_smps_outstanding = 0;
 }
 
 int process_mads(smp_engine_t * engine)
 {
-	int rc = 0;
-	while (engine->num_smps_outstanding > 0)
-		while (!cl_is_qmap_empty(&engine->smps_on_wire))
-			if ((rc = process_one_recv(engine)) != 0)
-				return rc;
+	int rc;
+	while (!cl_is_qmap_empty(&engine->smps_on_wire))
+		if ((rc = process_one_recv(engine)) != 0)
+			return rc;
 	return 0;
 }
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
