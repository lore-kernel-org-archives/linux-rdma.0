From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] infiniband, ocrdma, Fix compiler warning [v2]
Date: Wed, 19 Feb 2014 15:05:16 -0500
Message-ID: <1392840316-15946-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: In function =E2=80=98_ocrd=
ma_modify_qp=E2=80=99:
drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1299:31: error: =E2=80=98ol=
d_qps=E2=80=99 may be used uninitialized in this function [-Werror=3Dma=
ybe-uninitialized]
  status =3D ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask, old_qps);

ocrdma_mbx_modify_qp() (and subsequent calls) doesn't appear to use old=
_qps
so it doesn't need to be passed on.  Removing the variable results in t=
he
warning going away.

[v2]: updated email addresses

Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    8 +++-----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |    3 +--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infinib=
and/hw/ocrdma/ocrdma_hw.c
index 1664d64..ac3fbf2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2127,8 +2127,7 @@ static int ocrdma_set_av_params(struct ocrdma_qp =
*qp,
=20
 static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 				struct ocrdma_modify_qp *cmd,
-				struct ib_qp_attr *attrs, int attr_mask,
-				enum ib_qp_state old_qps)
+				struct ib_qp_attr *attrs, int attr_mask)
 {
 	int status =3D 0;
=20
@@ -2233,8 +2232,7 @@ pmtu_err:
 }
=20
 int ocrdma_mbx_modify_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
-			 struct ib_qp_attr *attrs, int attr_mask,
-			 enum ib_qp_state old_qps)
+			 struct ib_qp_attr *attrs, int attr_mask)
 {
 	int status =3D -ENOMEM;
 	struct ocrdma_modify_qp *cmd;
@@ -2257,7 +2255,7 @@ int ocrdma_mbx_modify_qp(struct ocrdma_dev *dev, =
struct ocrdma_qp *qp,
 		    OCRDMA_QP_PARAMS_STATE_MASK;
 	}
=20
-	status =3D ocrdma_set_qp_params(qp, cmd, attrs, attr_mask, old_qps);
+	status =3D ocrdma_set_qp_params(qp, cmd, attrs, attr_mask);
 	if (status)
 		goto mbx_err;
 	status =3D ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infinib=
and/hw/ocrdma/ocrdma_hw.h
index 82fe332..db3d55f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -112,8 +112,7 @@ int ocrdma_mbx_create_qp(struct ocrdma_qp *, struct=
 ib_qp_init_attr *attrs,
 			 u8 enable_dpp_cq, u16 dpp_cq_id, u16 *dpp_offset,
 			 u16 *dpp_credit_lmt);
 int ocrdma_mbx_modify_qp(struct ocrdma_dev *, struct ocrdma_qp *,
-			 struct ib_qp_attr *attrs, int attr_mask,
-			 enum ib_qp_state old_qps);
+			 struct ib_qp_attr *attrs, int attr_mask);
 int ocrdma_mbx_query_qp(struct ocrdma_dev *, struct ocrdma_qp *,
 			struct ocrdma_qp_params *param);
 int ocrdma_mbx_destroy_qp(struct ocrdma_dev *, struct ocrdma_qp *);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infi=
niband/hw/ocrdma/ocrdma_verbs.c
index e0cc201..f1108eb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1296,7 +1296,7 @@ int _ocrdma_modify_qp(struct ib_qp *ibqp, struct =
ib_qp_attr *attr,
 	 */
 	if (status < 0)
 		return status;
-	status =3D ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask, old_qps);
+	status =3D ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask);
 	if (!status && attr_mask & IB_QP_STATE && attr->qp_state =3D=3D IB_QP=
S_RTR)
 		ocrdma_flush_rq_db(qp);
=20
--=20
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
