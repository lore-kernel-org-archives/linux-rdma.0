From: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
Subject: [PATCH] IB/ehca: Use kcalloc instead of kzalloc to allocate array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.303.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
---

diff -u -p a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
--- a/drivers/infiniband/hw/ehca/ehca_qp.c 2011-11-13 11:07:26.513489332 +0100
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c 2011-11-28 19:51:39.771888018 +0100
@@ -853,10 +853,9 @@ static struct ehca_qp *internal_create_q
 			/* alloc array to cache subsequent modify qp parms
 			 * for autodetect mode
 			 */
-			my_qp->mod_qp_parm =
-				kzalloc(EHCA_MOD_QP_PARM_MAX *
-					sizeof(*my_qp->mod_qp_parm),
-					GFP_KERNEL);
+			my_qp->mod_qp_parm = kcalloc(EHCA_MOD_QP_PARM_MAX,
+						     sizeof(*my_qp->mod_qp_parm),
+						     GFP_KERNEL);
 			if (!my_qp->mod_qp_parm) {
 				ehca_err(pd->device,
 					 "Could not alloc mod_qp_parm");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
