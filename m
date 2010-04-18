From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdiscover: more outstanding MADs counting fix
Date: Sun, 18 Apr 2010 18:56:36 +0300
Message-ID: <20100418155636.GJ11943@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413163836.GM10830@me>
 <20100413133826.00a8afc5.weiny2@llnl.gov>
 <20100413134446.72eb336a.weiny2@llnl.gov>
 <20100414102335.GT10830@me>
 <0EEE4F40-F1DD-46A6-B756-3C46DA06B403@llnl.gov>
 <20100416120505.GB11943@me>
 <20100418154950.GI11943@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100418154950.GI11943@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Decrease outstanding MADs counter before calling process_smp_queue()
and smp receive callback, so that there will be room available for
sending more MADs. This fixes 'ibnetdiscover -o 1' (max outstanding
SMPs on a wire = 1) bug.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/query_smp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index 08e3ef7..3d10977 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -160,8 +160,6 @@ static int process_one_recv(smp_engine_t * engine)
 		return -1;
 	}
 
-	rc = process_smp_queue(engine);
-
 	mad = umad_get_mad(umad);
 	trid = (uint32_t) mad_get_field64(mad, 0, IB_MAD_TRID_F);
 
@@ -171,6 +169,8 @@ static int process_one_recv(smp_engine_t * engine)
 		return -1;
 	}
 
+	engine->num_smps_outstanding--;
+	rc = process_smp_queue(engine);
 	if (rc)
 		goto error;
 
@@ -187,7 +187,6 @@ static int process_one_recv(smp_engine_t * engine)
 
 error:
 	free(smp);
-	engine->num_smps_outstanding--;
 	return rc;
 }
 
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
