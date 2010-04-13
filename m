From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: fix outstanding SMPs countung
Date: Tue, 13 Apr 2010 19:38:36 +0300
Message-ID: <20100413163836.GM10830@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100218124933.c018a23d.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


send_smp() failure blocks whole discovery execution (it never returns).
Fix this by updating all outstanding SMPs related counters only after
successful MAD sending.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/query_smp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index b4322bc..08e3ef7 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -96,10 +96,12 @@ static int process_smp_queue(smp_engine_t * engine)
 		if (!smp)
 			return 0;
 
-		cl_qmap_insert(&engine->smps_on_wire, (uint32_t) smp->rpc.trid,
-			       (cl_map_item_t *) smp);
 		if ((rc = send_smp(smp, engine->ibmad_port)) != 0)
 			return rc;
+		engine->num_smps_outstanding++;
+		cl_qmap_insert(&engine->smps_on_wire, (uint32_t) smp->rpc.trid,
+			       (cl_map_item_t *) smp);
+		engine->total_smps++;
 	}
 	return 0;
 }
@@ -133,8 +135,6 @@ int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
 	portid->sl = 0;
 	portid->qp = 0;
 
-	engine->total_smps++;
-	engine->num_smps_outstanding++;
 	queue_smp(engine, smp);
 	return process_smp_queue(engine);
 }
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
