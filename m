From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH V2 1/2] IB/core: Add cross-channel support
Date: Thu, 24 Dec 2015 10:51:11 +0200
Message-ID: <1450947072-9295-2-git-send-email-leon@leon.nu>
References: <1450947072-9295-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450947072-9295-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The cross-channel feature allows to execute WQEs that involve
synchronization of IO operations=E2=80=99 on different QPs.

This capability enables to program complex flows with a single
function call, hereby significantly reducing overhead associated
with IO processing.

The queue pairs can be configured to work as a =E2=80=9Csync master que=
ue=E2=80=9D
or =E2=80=9Csync slave queues=E2=80=9D.

The added flags are:

1. Device capability flag IB_DEVICE_CROSS_CHANNEL for the
   devices that can perform cross-channel operations.

2. CQ property flag IB_CQ_FLAGS_IGNORE_OVERRUN to disable CQ overrun
   check. In cross-channel mode, the send/receive queues will forward
   their completions to managing QP.

3. QP property flags to indicate if queues are slave or master:
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
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |  5 ++++-
 include/rdma/ib_verbs.h              | 11 +++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/=
core/uverbs_cmd.c
index 1add53653825..63ddd6a122b0 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1829,7 +1829,10 @@ static int create_qp(struct ib_uverbs_file *file=
,
 		      sizeof(cmd->create_flags))
 		attr.create_flags =3D cmd->create_flags;
=20
-	if (attr.create_flags & ~IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
+	if (attr.create_flags & ~(IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK |
+				IB_QP_CREATE_CROSS_CHANNEL |
+				IB_QP_CREATE_MANAGED_SEND |
+				IB_QP_CREATE_MANAGED_RECV)) {
 		ret =3D -EINVAL;
 		goto err_put;
 	}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a7dbbfc9d202..d00f3e2e39ac 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -141,6 +141,13 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MEM_WINDOW_TYPE_2B	=3D (1<<24),
 	IB_DEVICE_RC_IP_CSUM		=3D (1<<25),
 	IB_DEVICE_RAW_IP_CSUM		=3D (1<<26),
+	/*
+	 * Devices should set IB_DEVICE_CROSS_CHANNEL if they
+	 * support execution of WQEs that involve synchronization
+	 * of I/O operations with single completion queue managed
+	 * by hardware.
+	 */
+	IB_DEVICE_CROSS_CHANNEL		=3D (1<<27),
 	IB_DEVICE_MANAGED_FLOW_STEERING =3D (1<<29),
 	IB_DEVICE_SIGNATURE_HANDOVER	=3D (1<<30),
 	IB_DEVICE_ON_DEMAND_PAGING	=3D (1<<31),
@@ -186,6 +193,7 @@ struct ib_odp_caps {
=20
 enum ib_cq_creation_flags {
 	IB_CQ_FLAGS_TIMESTAMP_COMPLETION   =3D 1 << 0,
+	IB_CQ_FLAGS_IGNORE_OVERRUN	   =3D 1 << 1,
 };
=20
 struct ib_cq_init_attr {
@@ -823,6 +831,9 @@ enum ib_qp_type {
 enum ib_qp_create_flags {
 	IB_QP_CREATE_IPOIB_UD_LSO		=3D 1 << 0,
 	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	=3D 1 << 1,
+	IB_QP_CREATE_CROSS_CHANNEL              =3D 1 << 2,
+	IB_QP_CREATE_MANAGED_SEND               =3D 1 << 3,
+	IB_QP_CREATE_MANAGED_RECV               =3D 1 << 4,
 	IB_QP_CREATE_NETIF_QP			=3D 1 << 5,
 	IB_QP_CREATE_SIGNATURE_EN		=3D 1 << 6,
 	IB_QP_CREATE_USE_GFP_NOIO		=3D 1 << 7,
--=20
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
