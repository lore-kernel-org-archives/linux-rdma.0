From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs V1 2/5] Add cross-channel QP flags
Date: Sat, 16 Jan 2016 17:53:41 +0200
Message-ID: <1452959624-29454-3-git-send-email-leon@leon.nu>
References: <1452959624-29454-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452959624-29454-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
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

QP property flags to indicate if queues are slave or master:
  * IB_QP_CREATE_MANAGED_SEND indicates that posted send work requests
    will not be executed immediately and requires enabling.

  * IB_QP_CREATE_MANAGED_RECV indicates that posted receive work
    requests will not be executed immediately and requires enabling.

  * IB_QP_CREATE_CROSS_CHANNEL declares the QP to work in cross-channel
    mode. If IB_QP_CREATE_MANAGED_SEND and IB_QP_CREATE_MANAGED_RECV ar=
e
    not provided, this QP will be sync master queue, else it will be sy=
nc
    slave.

  * IBV_QP_CREATE_IGNORE_SQ_OVERFLOW configures QP to discard overflow
    indications on send queue.

  * IBV_QP_CREATE_IGNORE_RQ_OVERFLOW instructs QP to discard overflow
    indications on receive queue.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |  5 +++++
 man/ibv_create_qp_ex.3     | 18 ++++++++++++++++--
 src/cmd.c                  |  5 ++++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 466d779592bf..7e85de08bfc9 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -769,6 +769,11 @@ enum ibv_qp_init_attr_mask {
=20
 enum ibv_qp_create_flags {
 	IBV_QP_CREATE_BLOCK_SELF_MCAST_LB       =3D 1 << 1,
+	IBV_QP_CREATE_CROSS_CHANNEL		=3D 1 << 2,
+	IBV_QP_CREATE_MANAGED_SEND		=3D 1 << 3,
+	IBV_QP_CREATE_MANAGED_RECV		=3D 1 << 4,
+	IBV_QP_CREATE_IGNORE_SQ_OVERFLOW	=3D 1 << 5,
+	IBV_QP_CREATE_IGNORE_RQ_OVERFLOW	=3D 1 << 6
 };
=20
 struct ibv_qp_init_attr_ex {
diff --git a/man/ibv_create_qp_ex.3 b/man/ibv_create_qp_ex.3
index f772a57b4c55..b80a586306c7 100644
--- a/man/ibv_create_qp_ex.3
+++ b/man/ibv_create_qp_ex.3
@@ -1,6 +1,6 @@
 .\" -*- nroff -*-
 .\"
-.TH IBV_CREATE_QP_EX 3 2013-06-26 libibverbs "Libibverbs Programmer's =
Manual"
+.TH IBV_CREATE_QP_EX 3 2015-12-27 libibverbs "Libibverbs Programmer's =
Manual"
 .SH "NAME"
 ibv_create_qp_ex, ibv_destroy_qp \- create or destroy a queue pair (QP=
)
 .SH "SYNOPSIS"
@@ -47,6 +47,16 @@ uint32_t                max_recv_sge;   /* Requested=
 max number of s/g elements
 uint32_t                max_inline_data;/* Requested max number of dat=
a (bytes) that can be posted inline to the SQ, otherwise 0 */
 .in -8
 };
+.sp
+.mf
+enum ibv_qp_create_flags {
+	IBV_QP_CREATE_BLOCK_SELF_MCAST_LB	=3D 1 << 1,
+	IBV_QP_CREATE_CROSS_CHANNEL             =3D 1 << 2, /* Set QP to work=
 in cross-channel mode */
+	IBV_QP_CREATE_MANAGED_SEND              =3D 1 << 3, /* Send work requ=
est posted to this QP won't be executed immediately and requires enabli=
ng /*
+	IBV_QP_CREATE_MANAGED_RECV              =3D 1 << 4, /* Receive work r=
equest posted to this QP won't be executed immediately and requires ena=
bling */
+	IBV_QP_CREATE_IGNORE_SQ_OVERFLOW        =3D 1 << 5, /* Configure QP t=
o discard overflow indications on send queue */
+	IBV_QP_CREATE_IGNORE_RQ_OVERFLOW        =3D 1 << 6  /* Configure QP t=
o discard overflow indications on receive queue */
+};
 .fi
 .PP
 The function
@@ -80,4 +90,8 @@ fails if the QP is attached to a multicast group.
 .BR ibv_query_qp (3)
 .SH "AUTHORS"
 .TP
-Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+Yishai Hadas
+.RI < yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
+.TP
+Leon Romanovsky
+.RI < leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
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
