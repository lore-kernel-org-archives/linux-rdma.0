From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mthca: Fix the attribute sq_sig_type value in query qp
Date: Tue, 18 Oct 2011 17:44:00 +0200
Message-ID: <201110181744.00322.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland: did you have a change to review this patch?

Thanks
Dotan

----------  Forwarded Message  ----------

Subject: [PATCH] mthca: Fix the attribute sq_sig_type value in query qp
Date: Monday 05 September 2011 16:44
From: Dotan Barak <dotanb-g2bIKuvJtcQanlnWow0HJg@public.gmane.org>
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Fix the attribute sq_sig_type value in query qp.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---

diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 9601049..57b4325 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -501,6 +501,7 @@ done:
 	qp_attr->cap.max_inline_data = qp->max_inline_data;
 
 	qp_init_attr->cap	     = qp_attr->cap;
+	qp_init_attr->sq_sig_type    = qp->sq_policy;
 
 out_mailbox:
 	mthca_free_mailbox(dev, mailbox);


-------------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
