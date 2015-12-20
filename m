From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libmlx5 1/2] libmlx5: Add cross-channel primitives
Date: Sun, 20 Dec 2015 13:23:09 +0200
Message-ID: <1450610590-17361-2-git-send-email-leon@leon.nu>
References: <1450610590-17361-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450610590-17361-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The cross-channel feature relies on special primitives to
send and receive work requests.

* WAIT on CQ WR - This WR holds execution of subsequent
  requests on that queue until producer index of a CQ is met.

=E2=80=A2 SEND_EN WR - This WR specifies value of producer index on
  the controlled send queue. It enables the execution of all
  WQEs up to this producer index.

=E2=80=A2 RECEIVE_EN WR - Same as SEND_EN but related to a receive
  queue.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/mlx5.h b/src/mlx5.h
index 0c0b0278f66e..49e3374b4439 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -208,6 +208,10 @@ enum {
 	MLX5_OPCODE_LOCAL_INVAL		=3D 0x1b,
 	MLX5_OPCODE_CONFIG_CMD		=3D 0x1f,
=20
+	MLX5_OPCODE_SEND_ENABLE         =3D 0x17,
+	MLX5_OPCODE_RECV_ENABLE         =3D 0x16,
+	MLX5_OPCODE_CQE_WAIT            =3D 0x0f,
+
 	MLX5_RECV_OPCODE_RDMA_WRITE_IMM	=3D 0x00,
 	MLX5_RECV_OPCODE_SEND		=3D 0x01,
 	MLX5_RECV_OPCODE_SEND_IMM	=3D 0x02,
--=20
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
