From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: remove not needed process_smp_queue() call
Date: Sun, 18 Apr 2010 19:03:57 +0300
Message-ID: <20100418160357.GK11943@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413163836.GM10830@me>
 <20100413133826.00a8afc5.weiny2@llnl.gov>
 <20100413134446.72eb336a.weiny2@llnl.gov>
 <20100414102335.GT10830@me>
 <0EEE4F40-F1DD-46A6-B756-3C46DA06B403@llnl.gov>
 <20100416120505.GB11943@me>
 <20100418154950.GI11943@me>
 <20100418155636.GJ11943@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100418155636.GJ11943@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


process_smp_queue() is called initially in issue_smp() and post called
in each process_one_recv() invocation. So no need in yet another call.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/query_smp.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index 0f33130..d38c2ef 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -231,12 +231,9 @@ void smp_engine_destroy(smp_engine_t * engine)
 int process_mads(smp_engine_t * engine)
 {
 	int rc = 0;
-	while (engine->num_smps_outstanding > 0) {
-		if ((rc = process_smp_queue(engine)) != 0)
-			return rc;
+	while (engine->num_smps_outstanding > 0)
 		while (!cl_is_qmap_empty(&engine->smps_on_wire))
 			if ((rc = process_one_recv(engine)) != 0)
 				return rc;
-	}
 	return 0;
 }
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
