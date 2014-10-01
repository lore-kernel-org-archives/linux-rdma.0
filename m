From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 4/9] ibv_cmd_create_srq_ex(): set reserved field in struct ibv_create_xsrq
Date: Wed,  1 Oct 2014 13:49:34 +0200
Message-ID: <14bdb44b784ae631de9a9f35a7cf28799fd39473.1412163687.git.ydroneaud@opteya.com>
References: <cover.1412163687.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Properly initialize data structure exchanged with kernel uverbs
layer:
- may remove valgrind spurious warnings;
- may allow to use the field later for future expansion.

Link: http://marc.info/?i=cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Fixes: 40c1365b2198 ('Add support for XRC SRQs')
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/cmd.c b/src/cmd.c
index 8d8f7e8294e5..f80ce4d30832 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -463,6 +463,7 @@ int ibv_cmd_create_srq_ex(struct ibv_context *context,
 	cmd->max_wr      = attr_ex->attr.max_wr;
 	cmd->max_sge     = attr_ex->attr.max_sge;
 	cmd->srq_limit   = attr_ex->attr.srq_limit;
+	cmd->reserved    = 0;
 
 	cmd->srq_type = (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_TYPE) ?
 			attr_ex->srq_type : IBV_SRQT_BASIC;
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
