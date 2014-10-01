From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 2/9] ibv_cmd_post_recv(): initialize reserved field in struct ibv_kern_recv_wr
Date: Wed,  1 Oct 2014 13:49:32 +0200
Message-ID: <82324f6f32d600f6635d3419a3f821771933ef5c.1412163687.git.ydroneaud@opteya.com>
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
 src/cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/cmd.c b/src/cmd.c
index b281082f2f4d..d057494260ee 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1082,6 +1082,7 @@ int ibv_cmd_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 	for (i = wr; i; i = i->next) {
 		tmp->wr_id   = i->wr_id;
 		tmp->num_sge = i->num_sge;
+		tmp->reserved = 0;
 
 		if (tmp->num_sge) {
 			memcpy(s, i->sg_list, tmp->num_sge * sizeof *s);
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
