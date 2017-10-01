From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>
Subject: [PATCH 04/18] IB/mlx5: Use ARRAY_SIZE
Date: Sun,  1 Oct 2017 15:30:42 -0400
Message-ID: <20171001193101.8898-5-jeremy.lefaure@lse.epita.fr>
References: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?= <jeremy.lefaure@lse.epita.fr>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Using the ARRAY_SIZE macro improves the readability of the code.

Found with Coccinelle with the following semantic patch:
@r depends on (org || report)@
type T;
T[] E;
position p;
@@
(
 (sizeof(E)@p /sizeof(*E))
|
 (sizeof(E)@p /sizeof(E[...]))
|
 (sizeof(E)@p /sizeof(T))
)

Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
---
 drivers/infiniband/hw/mlx5/odp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 3d701c7a4c91..e2197bdda89c 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -32,6 +32,7 @@
 
 #include <rdma/ib_umem.h>
 #include <rdma/ib_umem_odp.h>
+#include <linux/kernel.h>
 
 #include "mlx5_ib.h"
 #include "cmd.h"
@@ -929,9 +930,8 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 		return -EFAULT;
 	}
 
-	if (unlikely(opcode >= sizeof(mlx5_ib_odp_opcode_cap) /
-	    sizeof(mlx5_ib_odp_opcode_cap[0]) ||
-	    !(transport_caps & mlx5_ib_odp_opcode_cap[opcode]))) {
+	if (unlikely(opcode >= ARRAY_SIZE(mlx5_ib_odp_opcode_cap) ||
+		     !(transport_caps & mlx5_ib_odp_opcode_cap[opcode]))) {
 		mlx5_ib_err(dev, "ODP fault on QP of an unsupported opcode 0x%x\n",
 			    opcode);
 		return -EFAULT;
-- 
2.14.1
