From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 2/2] IB/mlx4: Fix build warnings
Date: Sun,  3 Nov 2013 10:20:44 +0200
Message-ID: <1383466844-8805-3-git-send-email-ogerlitz@mellanox.com>
References: <1383466844-8805-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383466844-8805-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46ix the below "make W=3D1" build warning we have on the mlx4_ib

drivers/infiniband/hw/mlx4/qp.c: In function =E2=80=98mlx4_ib_post_send=
=E2=80=99:
drivers/infiniband/hw/mlx4/qp.c:2463: warning: comparison of unsigned e=
xpression < 0 is always false

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
index 4f10af2..da25e4d 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2460,7 +2460,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct =
ib_send_wr *wr,
 		 */
 		wmb();
=20
-		if (wr->opcode < 0 || wr->opcode >=3D ARRAY_SIZE(mlx4_ib_opcode)) {
+		if (wr->opcode >=3D ARRAY_SIZE(mlx4_ib_opcode)) {
 			*bad_wr =3D wr;
 			err =3D -EINVAL;
 			goto out;
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
