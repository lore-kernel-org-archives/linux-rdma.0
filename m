From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix compliance test failure C14-024#06_LocalPortNum
Date: Wed, 12 Sep 2012 09:01:29 -0400
Message-ID: <20120912130129.26588.1125.stgit@phlsvsles11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 3236b2d4 ("IB/qib: MADs with misset M_Keys should return failure")
introduced a return code assignment that unfortunately introduced
an unconditional exit for the routine due to the lack of braces.

This patch adds the braces to correct the original patch.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 19f1e6c..ccb1191 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -471,9 +471,10 @@ static int subn_get_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 		if (port_num != port) {
 			ibp = to_iport(ibdev, port_num);
 			ret = check_mkey(ibp, smp, 0);
-			if (ret)
+			if (ret) {
 				ret = IB_MAD_RESULT_FAILURE;
 				goto bail;
+			}
 		}
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
