From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 3/3] Provide remote XRC SRQ number in kernel post_send.
Date: Thu,  1 Sep 2016 08:59:53 +0200
Message-ID: <1472713193-22397-4-git-send-email-knut.omang@oracle.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472713193-22397-1-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Also proper end align the ibv_kern_send_wr struct.

Requires a corresponding kernel change.

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/infiniband/kern-abi.h | 1 +
 src/cmd.c                     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 8bdeef5..7b1d310 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -800,6 +800,7 @@ struct ibv_kern_send_wr {
 	union {
 		struct {
 			__u32 remote_srqn;
+			__u32 reserved;
 		} xrc;
 	} qp_type;
 };
diff --git a/src/cmd.c b/src/cmd.c
index a418ee1..a4e2f75 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1293,6 +1293,8 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			tmp->wr.ud.remote_qpn  = i->wr.ud.remote_qpn;
 			tmp->wr.ud.remote_qkey = i->wr.ud.remote_qkey;
 		} else {
+			if (ibqp->qp_type == IBV_QPT_XRC_SEND)
+				tmp->qp_type.xrc.remote_srqn = i->qp_type.xrc.remote_srqn;
 			switch (i->opcode) {
 			case IBV_WR_RDMA_WRITE:
 			case IBV_WR_RDMA_WRITE_WITH_IMM:
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
