From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 3/9] ibv_cmd_post_send(): initialize reserved field in struct ibv_kern_send_wr
Date: Wed,  1 Oct 2014 13:49:33 +0200
Message-ID: <8034db9803f8383339322394a7e52404aed83f96.1412163687.git.ydroneaud@opteya.com>
References: <cover.1412163687.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Properly initialize data structure exchanged with kernel uverbs
layer:
- may remove valgrind spurious warnings;
- may allow to use the field later for future expansion.

Link: http://marc.info/?i=cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Fixes: eb0663777c24 ('Add support for new datapath kernel commands')
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cmd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/cmd.c b/src/cmd.c
index d057494260ee..8d8f7e8294e5 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -999,6 +999,9 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			tmp->wr.ud.ah 	       = i->wr.ud.ah->handle;
 			tmp->wr.ud.remote_qpn  = i->wr.ud.remote_qpn;
 			tmp->wr.ud.remote_qkey = i->wr.ud.remote_qkey;
+			memset(&tmp->wr.ud.reserved, 0,
+			       sizeof(tmp->wr.ud.reserved)
+			       + (sizeof(tmp->wr) - sizeof(tmp->wr.ud)));
 		} else {
 			switch (i->opcode) {
 			case IBV_WR_RDMA_WRITE:
@@ -1007,6 +1010,9 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				tmp->wr.rdma.remote_addr =
 					i->wr.rdma.remote_addr;
 				tmp->wr.rdma.rkey = i->wr.rdma.rkey;
+				memset(&tmp->wr.rdma.reserved, 0,
+				       sizeof(tmp->wr.rdma.reserved)
+				       + (sizeof(tmp->wr) - sizeof(tmp->wr.rdma)));
 				break;
 			case IBV_WR_ATOMIC_CMP_AND_SWP:
 			case IBV_WR_ATOMIC_FETCH_AND_ADD:
@@ -1016,8 +1022,12 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 					i->wr.atomic.compare_add;
 				tmp->wr.atomic.swap = i->wr.atomic.swap;
 				tmp->wr.atomic.rkey = i->wr.atomic.rkey;
+				memset(&tmp->wr.atomic.reserved, 0,
+				       sizeof(tmp->wr.atomic.reserved)
+				       + (sizeof(tmp->wr) - sizeof(tmp->wr.atomic)));
 				break;
 			default:
+				memset(&tmp->wr, 0, sizeof(tmp->wr));
 				break;
 			}
 		}
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
