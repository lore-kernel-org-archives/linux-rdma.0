From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] IB/lmx4: silence GCC warning
Date: Fri, 28 Sep 2012 14:48:58 +0200
Message-ID: <1348836538.3626.21.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Building qp.o (part of the "Mellanox ConnectX HCA support" driver)
triggers this GCC warning:
    drivers/infiniband/hw/mlx4/qp.c: In function =E2=80=98mlx4_ib_post_=
send=E2=80=99:
    drivers/infiniband/hw/mlx4/qp.c:1828:30: warning: =E2=80=98vlan=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/infiniband/hw/mlx4/qp.c:1718:6: note: =E2=80=98vlan=E2=80=99=
 was declared here

Looking at the code it is clear 'vlan' is only set and used if 'is_eth'
is non-zero. But there's no harm in initializing 'vlan' to 0 (which
matches ib_get_cached_gid()'s default return) to silence GCC.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed this warning while building v3.6-rc7 on current Fedora 17,
using Fedora's default config.

1) Compile tested only. I tested against v3.6-rc7, with commit
a41262bb5721f2b708ee8b23f67be2f2e16a2fab ("IB/mlx4: SR-IOV IB context
objects and proxy/tunnel SQP") from linux-next cherry-picked, to take
into account a trivial context change in linux-next.

 drivers/infiniband/hw/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
index a862251..71fdda6 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1715,7 +1715,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *s=
qp, struct ib_send_wr *wr,
 	int is_eth;
 	int is_vlan =3D 0;
 	int is_grh;
-	u16 vlan;
+	u16 vlan =3D 0;
 	int err =3D 0;
=20
 	send_size =3D 0;
--=20
1.7.11.4
