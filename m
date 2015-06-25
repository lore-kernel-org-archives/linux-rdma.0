From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V2] IB/mad: Fix 0-day build
Date: Thu, 25 Jun 2015 09:53:46 -0400
Message-ID: <1435240426-18443-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Commit 3d33f9d9fea0 IB/mad: Add final OPA MAD processing

Added a 0-day build error which did not appear until building with the OPA
driver sent to the list.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1
	Update commit message

 drivers/infiniband/core/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a4b1466c1bf6..9c90a729db62 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -794,7 +794,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 			goto out;
 		}
 		opa_drslid = be32_to_cpu(opa_smp->route.dr.dr_slid);
-		if (opa_drslid != OPA_LID_PERMISSIVE &&
+		if (opa_drslid != be32_to_cpu(OPA_LID_PERMISSIVE) &&
 		    opa_drslid & 0xffff0000) {
 			ret = -EINVAL;
 			dev_err(&device->dev, "OPA Invalid dr_slid 0x%x\n",
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
