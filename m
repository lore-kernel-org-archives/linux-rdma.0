From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 for-next 1/3] IB: Return error when QP creation are provided for driver not supporting that
Date: Sun, 11 May 2014 15:15:10 +0300
Message-ID: <1399810512-30774-2-git-send-email-ogerlitz@mellanox.com>
References: <1399810512-30774-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399810512-30774-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the usnic and thw qib driver to err when QP creation flags are provided.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c           |    3 ++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 0cad0c4..7fcc150 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -985,7 +985,8 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 	struct ib_qp *ret;
 
 	if (init_attr->cap.max_send_sge > ib_qib_max_sges ||
-	    init_attr->cap.max_send_wr > ib_qib_max_qp_wrs) {
+	    init_attr->cap.max_send_wr > ib_qib_max_qp_wrs ||
+	    init_attr->create_flags) {
 		ret = ERR_PTR(-EINVAL);
 		goto bail;
 	}
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index d48d2c0..53bd6a2 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -466,6 +466,9 @@ struct ib_qp *usnic_ib_create_qp(struct ib_pd *pd,
 	ucontext = to_uucontext(pd->uobject->context);
 	us_ibdev = to_usdev(pd->device);
 
+	if (init_attr->create_flags)
+		return ERR_PTR(-EINVAL);
+
 	err = ib_copy_from_udata(&cmd, udata, sizeof(cmd));
 	if (err) {
 		usnic_err("%s: cannot copy udata for create_qp\n",
-- 
1.7.1

Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
