From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: fix memory leak in case of send_smps()
 failure
Date: Fri, 16 Apr 2010 15:21:51 +0300
Message-ID: <20100416122151.GC11943@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413163836.GM10830@me>
 <20100413133826.00a8afc5.weiny2@llnl.gov>
 <20100413134446.72eb336a.weiny2@llnl.gov>
 <20100414102335.GT10830@me>
 <0EEE4F40-F1DD-46A6-B756-3C46DA06B403@llnl.gov>
 <20100416120505.GB11943@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100416120505.GB11943@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Free smp object in case of send_smp() failure - it is not on the send
list already and not tracked anymore.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/query_smp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index 08e3ef7..e5a8f06 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -96,8 +96,10 @@ static int process_smp_queue(smp_engine_t * engine)
 		if (!smp)
 			return 0;
 
-		if ((rc = send_smp(smp, engine->ibmad_port)) != 0)
+		if ((rc = send_smp(smp, engine->ibmad_port)) != 0) {
+			free(smp);
 			return rc;
+		}
 		engine->num_smps_outstanding++;
 		cl_qmap_insert(&engine->smps_on_wire, (uint32_t) smp->rpc.trid,
 			       (cl_map_item_t *) smp);
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
