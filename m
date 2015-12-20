From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs 2/3] libibverbs: Add cross-channel QP initialization flags
Date: Sun, 20 Dec 2015 13:22:43 +0200
Message-ID: <1450610564-17279-3-git-send-email-leon@leon.nu>
References: <1450610564-17279-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450610564-17279-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The cross-channel feature allows to execute WQEs that involve
synchronization of I/O operations' on different QPs.

These QPs should be configured to work as a "sync master queue" or
=E2=80=9Csync slave queues=E2=80=9D.

The QP property flags to indicate if queues are slave or master:
   * IB_QP_CREATE_MANAGED_SEND indicates that posted send work requests
     will not be executed immediately and requires enabling.
   * IB_QP_CREATE_MANAGED_RECV indicates that posted receive work
     requests will not be executed immediately and requires enabling.
   * IB_QP_CREATE_CROSS_CHANNEL declares the QP to work in cross-channe=
l
     mode. If IB_QP_CREATE_MANAGED_SEND and IB_QP_CREATE_MANAGED_RECV a=
re
     not provided, this QP will be sync master queue, else it will be s=
ync
     slave.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 3 +++
 src/cmd.c                  | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index d8069d52ae13..2b9b50c87f45 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -769,6 +769,9 @@ enum ibv_qp_init_attr_mask {
=20
 enum ibv_qp_create_flags {
 	IBV_QP_CREATE_BLOCK_SELF_MCAST_LB       =3D 1 << 1,
+	IBV_QP_CREATE_CROSS_CHANNEL		=3D 1 << 2,
+	IBV_QP_CREATE_MANAGED_SEND		=3D 1 << 3,
+	IBV_QP_CREATE_MANAGED_RECV		=3D 1 << 4
 };
=20
 struct ibv_qp_init_attr_ex {
diff --git a/src/cmd.c b/src/cmd.c
index 675777a8ee5a..ae33491befb4 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -815,7 +815,10 @@ static void create_qp_handle_resp_common(struct ib=
v_context *context,
 }
=20
 enum {
-	CREATE_QP_EX2_SUP_CREATE_FLAGS =3D IBV_QP_CREATE_BLOCK_SELF_MCAST_LB,
+	CREATE_QP_EX2_SUP_CREATE_FLAGS =3D IBV_QP_CREATE_BLOCK_SELF_MCAST_LB =
|
+		IBV_QP_CREATE_CROSS_CHANNEL |
+		IBV_QP_CREATE_MANAGED_SEND |
+		IBV_QP_CREATE_MANAGED_RECV
 };
=20
 int ibv_cmd_create_qp_ex2(struct ibv_context *context,
--=20
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
