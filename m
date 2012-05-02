From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] If a MAD is sent directly to the local HCA rather than placed
	on a QP and the MAD fails mkey checks,
Date: Wed, 2 May 2012 14:48:35 -0400
Message-ID: <20120502184835.2971.14859.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

there is no means to generate a timeout for the client, which may hang.  Instead we report
IB_MAD_RESULT_FAILURE, which operates the same for on-the-wire packets, but will generate a send
failure back to the client.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index ed611e8..4339021 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -433,7 +433,7 @@ static int check_mkey(struct qib_ibport *ibp, struct ib_smp *smp, int mad_flags)
 					ibp->mkey_lease_period * HZ;
 			/* Generate a trap notice. */
 			qib_bad_mkey(ibp, smp);
-			ret = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
+			ret = 1;
 		}
 	}
 
@@ -464,6 +464,7 @@ static int subn_get_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 			ibp = to_iport(ibdev, port_num);
 			ret = check_mkey(ibp, smp, 0);
 			if (ret)
+				ret = IB_MAD_RESULT_FAILURE;
 				goto bail;
 		}
 	}
@@ -1848,6 +1849,7 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 		    port_num && port_num <= ibdev->phys_port_cnt &&
 		    port != port_num)
 			(void) check_mkey(to_iport(ibdev, port_num), smp, 0);
+		ret = IB_MAD_RESULT_FAILURE;
 		goto bail;
 	}
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
