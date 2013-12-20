From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/15] IB/usnic: Fix accounting of qp_grp_ref_cnt
Date: Fri, 20 Dec 2013 12:26:41 -0800
Message-ID: <1387571206-8043-11-git-send-email-umalhi@cisco.com>
References: <1387571206-8043-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571206-8043-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

vf->qp_grp_ref_cnt is incorrectly incremented if
usnic_uiom_attach_dev_to_pd fails; vf->pd is also
erroneously populated in this same failure path.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 788f47a..0daf7e9 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -395,15 +395,16 @@ static int qp_grp_and_vf_bind(struct usnic_ib_vf *vf,
 	WARN_ON(!spin_is_locked(&vf->lock));

 	pdev = usnic_vnic_get_pdev(vf->vnic);
-	if (vf->qp_grp_ref_cnt++ == 0) {
-		vf->pd = pd;
+	if (vf->qp_grp_ref_cnt == 0) {
 		err = usnic_uiom_attach_dev_to_pd(pd->umem_pd, &pdev->dev);
 		if (err) {
 			usnic_err("Failed to attach %s to domain\n",
 					pci_name(pdev));
 			return err;
 		}
+		vf->pd = pd;
 	}
+	vf->qp_grp_ref_cnt++;

 	WARN_ON(vf->pd != pd);
 	qp_grp->vf = vf;
--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
