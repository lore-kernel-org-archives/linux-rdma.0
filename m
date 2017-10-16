From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/5] IB/mlx5: Use ARRAY_SIZE
Date: Mon, 16 Oct 2017 08:28:12 +0300
Message-ID: <20171016052812.28802-6-leon@kernel.org>
References: <20171016052812.28802-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016052812.28802-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?= <jeremy.lefaure-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jérémy Lefaure <jeremy.lefaure-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>

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

Signed-off-by: Jérémy Lefaure <jeremy.lefaure-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
