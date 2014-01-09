From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 06/15] IB/usnic: Initialize all of the data returned to userspace
Date: Thu,  9 Jan 2014 14:47:34 -0800
Message-ID: <1389307663-11296-7-git-send-email-umalhi@cisco.com>
References: <1389307663-11296-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307663-11296-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The reserved fields in usnic_ib_create_qp_resp are returned
to userspace uninitialized.  Set these to 0.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index e19ca90..9f0945a 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -49,6 +49,8 @@ static int usnic_ib_fill_create_qp_resp(struct usnic_ib_qp_grp *qp_grp,
 	struct usnic_vnic_res_chunk *chunk;
 	int i, err;
 
+	memset(&resp, 0, sizeof(resp));
+
 	us_ibdev = qp_grp->vf->pf;
 	pdev = usnic_vnic_get_pdev(qp_grp->vf->vnic);
 	if (!pdev) {
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
