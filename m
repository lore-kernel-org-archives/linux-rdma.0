From: Antonio Alecrim Jr <antonio.alecrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] =?UTF-8?q?infiniband:=20hw:=20fix=20uninitialized=20?= =?UTF-8?q?=E2=80=98old=5Fqps=E2=80=99?=
Date: Fri, 13 Sep 2013 14:38:25 -0300
Message-ID: <1379093905-5968-1-git-send-email-antonio.alecrim@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Antonio Alecrim Jr <antonio.alecrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added missing old_qps initialization in order to fix the following
    warnings:
drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: In function
=E2=80=98_ocrdma_modify_qp=E2=80=99:
drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1299:31: warning: =E2=80=98=
old_qps=E2=80=99
may be used uninitialized in this function [-Wmaybe-uninitialized]
  status =3D ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask, old_qps);

Signed-off-by: Antonio Alecrim Jr <antonio.alecrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infi=
niband/hw/ocrdma/ocrdma_verbs.c
index 6e982bb..da6c23f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1289,6 +1289,7 @@ int _ocrdma_modify_qp(struct ib_qp *ibqp, struct =
ib_qp_attr *attr,
=20
 	qp =3D get_ocrdma_qp(ibqp);
 	dev =3D qp->dev;
+	old_qps =3D get_ibqp_state(qp->state);
 	if (attr_mask & IB_QP_STATE)
 		status =3D ocrdma_qp_state_change(qp, attr->qp_state, &old_qps);
 	/* if new and previous states are same hw doesn't need to
--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
