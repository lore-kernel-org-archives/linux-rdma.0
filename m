From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 V1 2/6] Add timestmap support for ibv_poll_cq_ex
Date: Thu,  3 Dec 2015 18:02:47 +0200
Message-ID: <1449158571-26228-3-git-send-email-matanb@mellanox.com>
References: <1449158571-26228-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449158571-26228-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for filling the timestamp field in ibv_poll_cq_ex
(if it's required by the user).

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/cq.c b/src/cq.c
index 0185696..5e06990 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -913,6 +913,11 @@ inline int mlx5_poll_one_ex(struct mlx5_cq *cq,
 	wc_ex->wc_flags = 0;
 	wc_ex->reserved = 0;
 
+	if (wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP) {
+		*wc_buffer.b64++ = ntohll(cqe64->timestamp);
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_COMPLETION_TIMESTAMP;
+	}
+
 	switch (opcode) {
 	case MLX5_CQE_REQ:
 		err = mlx5_poll_one_cqe_req(cq, cur_rsc, cqe, qpn, cqe_ver,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
