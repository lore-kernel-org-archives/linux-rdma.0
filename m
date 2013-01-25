From: Stratos Karafotis <stratosk@semaphore.gr>
Subject: [PATCH] drivers: infiniband: Fix compiler warning
Date: Fri, 25 Jan 2013 23:52:23 +0200
Message-ID: <5102FE97.20508@semaphore.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch fixes the following compiler warning of uninitialized variab=
le

drivers/infiniband/hw/mlx4/qp.c: In function =91mlx4_ib_post_send=92:
drivers/infiniband/hw/mlx4/qp.c:1862:62: warning: =91vlan=92 may be use=
d uninitialized
in this function [-Wmaybe-uninitialized]
drivers/infiniband/hw/mlx4/qp.c:1752:6: note: =91vlan=92 was declared h=
ere

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/infiniband/hw/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
index 19e0637..37829b6 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1749,7 +1749,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *s=
qp, struct ib_send_wr *wr,
        int is_eth;
        int is_vlan =3D 0;
        int is_grh;
-       u16 vlan;
+       u16 vlan =3D 0;
        int err =3D 0;

        send_size =3D 0;
--=20
1.8.1
