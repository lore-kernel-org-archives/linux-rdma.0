From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 1/9] ibv_cmd_create_ah(): initialize reserved fields in various structures
Date: Wed,  1 Oct 2014 13:49:31 +0200
Message-ID: <7989836f5db0c7e8199c80ce7f6851daf7a0a6dc.1412163687.git.ydroneaud@opteya.com>
References: <cover.1412163687.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reserved fields in struct ibv_kern_global_route,
struct ibv_kern_ah_attr and struct ibv_create_ah must be
properly initialized when exchanged with kernel uverbs layer,
as:
- it may remove valgrind spurious warnings;
- it may allow to use the field later for future expansion.

Link: http://marc.info/?i=cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Fixes: eb0663777c24 ('Add support for new datapath kernel commands')
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/cmd.c b/src/cmd.c
index 45ea06ff4705..b281082f2f4d 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1179,16 +1179,19 @@ int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, CREATE_AH, &resp, sizeof resp);
 	cmd.user_handle            = (uintptr_t) ah;
 	cmd.pd_handle              = pd->handle;
+	cmd.reserved               = 0;
 	cmd.attr.dlid              = attr->dlid;
 	cmd.attr.sl                = attr->sl;
 	cmd.attr.src_path_bits     = attr->src_path_bits;
 	cmd.attr.static_rate       = attr->static_rate;
 	cmd.attr.is_global         = attr->is_global;
 	cmd.attr.port_num          = attr->port_num;
+	cmd.attr.reserved          = 0;
 	cmd.attr.grh.flow_label    = attr->grh.flow_label;
 	cmd.attr.grh.sgid_index    = attr->grh.sgid_index;
 	cmd.attr.grh.hop_limit     = attr->grh.hop_limit;
 	cmd.attr.grh.traffic_class = attr->grh.traffic_class;
+	cmd.attr.grh.reserved      = 0;
 	memcpy(cmd.attr.grh.dgid, attr->grh.dgid.raw, 16);
 
 	if (write(pd->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
