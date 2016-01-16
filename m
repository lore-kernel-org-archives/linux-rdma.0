From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs V1 3/5] Add cross-channel work requests primitives
Date: Sat, 16 Jan 2016 17:53:42 +0200
Message-ID: <1452959624-29454-4-git-send-email-leon@leon.nu>
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

The cross-channel feature relies on special primitives to
send and receive work requests.

  * CQE wait - This work request holds execution of subsequent
    requests on that queue until this number of completions of
    a CQ is met.

  =E2=80=A2 WQE enable - This work request specifies value of work
    requests on the controlled send/receive queue. It enables the
    execution of all WQEs up to the work request which is
    marked by IBV_SEND_WAIT_EN_LAST.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 16 ++++++++++++++--
 man/ibv_post_send.3        | 25 +++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 7e85de08bfc9..d91dd8a1376e 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -884,7 +884,10 @@ enum ibv_wr_opcode {
 	IBV_WR_SEND_WITH_IMM,
 	IBV_WR_RDMA_READ,
 	IBV_WR_ATOMIC_CMP_AND_SWP,
-	IBV_WR_ATOMIC_FETCH_AND_ADD
+	IBV_WR_ATOMIC_FETCH_AND_ADD,
+	IBV_WR_SEND_ENABLE,
+	IBV_WR_RECV_ENABLE,
+	IBV_WR_CQE_WAIT
 };
=20
 enum ibv_send_flags {
@@ -892,7 +895,8 @@ enum ibv_send_flags {
 	IBV_SEND_SIGNALED	=3D 1 << 1,
 	IBV_SEND_SOLICITED	=3D 1 << 2,
 	IBV_SEND_INLINE		=3D 1 << 3,
-	IBV_SEND_IP_CSUM	=3D 1 << 4
+	IBV_SEND_IP_CSUM	=3D 1 << 4,
+	IBV_SEND_WAIT_EN_LAST   =3D 1 << 5
 };
=20
 struct ibv_sge {
@@ -925,6 +929,14 @@ struct ibv_send_wr {
 			uint32_t	remote_qpn;
 			uint32_t	remote_qkey;
 		} ud;
+		struct {
+			struct ibv_cq  *cq;
+			int32_t		cq_count;
+		} cqe_wait;
+		struct {
+			struct ibv_qp  *qp;
+			int32_t		wqe_count;
+		} wqe_enable;
 	} wr;
 	union {
 		struct {
diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
index eeea0787fa80..28dd43bfa3d9 100644
--- a/man/ibv_post_send.3
+++ b/man/ibv_post_send.3
@@ -1,6 +1,6 @@
 .\" -*- nroff -*-
 .\"
-.TH IBV_POST_SEND 3 2006-10-31 libibverbs "Libibverbs Programmer's Man=
ual"
+.TH IBV_POST_SEND 3 2015-12-26 libibverbs "Libibverbs Programmer's Man=
ual"
 .SH "NAME"
 ibv_post_send \- post a list of work requests (WRs) to a send queue
 .SH "SYNOPSIS"
@@ -58,6 +58,18 @@ uint32_t        remote_qpn;     /* QP number of the =
destination QP */
 uint32_t        remote_qkey;    /* Q_Key number of the destination QP =
*/
 .in -8
 } ud;
+struct {
+.in +8
+struct ibv_cq  *cq;		/* CQ for the wait on */
+int32_t        cq_count;	/* Count of completions of a CQ to met */
+.in -8
+} cqe_wait;
+struct {
+.in +8
+struct ibv_qp  *qp;		/* QP for the release */
+int32_t        wqe_count;	/* Number of work requests to release */
+.in -8
+} wqe_enable;
 .in -8
 } wr;
 .in -8
@@ -85,6 +97,9 @@ IBV_WR_RDMA_WRITE_WITH_IMM  |            |     X     =
 |     X
 IBV_WR_RDMA_READ            |            |            |     X
 IBV_WR_ATOMIC_CMP_AND_SWP   |            |            |     X
 IBV_WR_ATOMIC_FETCH_AND_ADD |            |            |     X
+IBV_WR_SEND_ENABLE          |            |            |     X
+IBV_WR_RECV_ENABLE          |            |            |     X
+IBV_WR_CQE_WAIT             |            |            |     X
 .fi
 .PP
 The attribute send_flags describes the properties of the \s-1WR\s0. It=
 is either 0 or the bitwise \s-1OR\s0 of one or more of the following f=
lags:
@@ -102,6 +117,8 @@ in a send WQE.  Valid only for Send and RDMA Write.=
  The L_Key will not be check
 .B IBV_SEND_IP_CSUM \fR Offload the IPv4 and TCP/UDP checksum calculat=
ion.
 Valid only when \fBdevice_cap_flags\fR in device_attr indicates curren=
t QP is
 supported by checksum offload.
+.TP
+.B IBV_SEND_WAIT_EN_LAST \fR Mark this work request as a last one in t=
he cross-channel offloaded sequence.
 .SH "RETURN VALUE"
 .B ibv_post_send()
 returns 0 on success, or the value of errno on failure (which indicate=
s the failure reason).
@@ -124,4 +141,8 @@ after the call returns.
 .BR ibv_poll_cq (3)
 .SH "AUTHORS"
 .TP
-Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+Dotan Barak
+.RI < dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
+.TP
+Leon Romanovsky
+.RI < leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
--=20
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
