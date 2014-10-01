From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 6/9] ibv_cmd_open_qp(): initialize reserved field in struct ibv_open_qp
Date: Wed,  1 Oct 2014 13:49:36 +0200
Message-ID: <560f1909a3d7db2fffd57c5da4954ebde7f4223c.1412163687.git.ydroneaud@opteya.com>
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
Fixes: 5f5292bbc51fb ('Add ibv_open_qp() for XRC receive QPs')
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/cmd.c b/src/cmd.c
index f80ce4d30832..f9e4a03fd84d 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -785,6 +785,7 @@ int ibv_cmd_open_qp(struct ibv_context *context, struct verbs_qp *qp,
 	cmd->pd_handle   = xrcd->handle;
 	cmd->qpn         = attr->qp_num;
 	cmd->qp_type     = attr->qp_type;
+	memset(cmd->reserved, 0, sizeof(cmd->reserved));
 
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
