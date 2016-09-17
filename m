From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 2/3] Add padding to get proper end alignment of ibv_reg_mr_resp
Date: Sat, 17 Sep 2016 05:59:12 +0200
Message-ID: <d189bdc3e8e76a9bf4023efe6b0b5d8e3ddae4c1.1474063039.git-series.knut.omang@oracle.com>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The user/kernel level API requires all parameter blocks to be
64 bit end aligned.

Also clean up some valgrind/memory initialization issues.

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/infiniband/kern-abi.h | 1 +
 src/cmd.c                     | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index f70fa44..8bdeef5 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -367,6 +367,7 @@ struct ibv_reg_mr_resp {
 	__u32 mr_handle;
 	__u32 lkey;
 	__u32 rkey;
+	__u32 reserved;
 };
 
 struct ibv_rereg_mr {
diff --git a/src/cmd.c b/src/cmd.c
index 12d8640..a418ee1 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1470,6 +1470,7 @@ int ibv_cmd_create_ah_ex(struct ibv_pd *pd, struct ibv_ah *ah, struct ibv_ah_att
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_AH, resp, resp_size);
 	cmd->user_handle            = (uintptr_t) ah;
 	cmd->pd_handle              = pd->handle;
+	cmd->reserved               = 0;
 	cmd->attr.dlid              = attr->dlid;
 	cmd->attr.sl                = attr->sl;
 	cmd->attr.src_path_bits     = attr->src_path_bits;
@@ -1480,12 +1481,14 @@ int ibv_cmd_create_ah_ex(struct ibv_pd *pd, struct ibv_ah *ah, struct ibv_ah_att
 	cmd->attr.grh.sgid_index    = attr->grh.sgid_index;
 	cmd->attr.grh.hop_limit     = attr->grh.hop_limit;
 	cmd->attr.grh.traffic_class = attr->grh.traffic_class;
+	cmd->attr.grh.reserved      = 0;
+	cmd->attr.reserved          = 0;
 	memcpy(cmd->attr.grh.dgid, attr->grh.dgid.raw, 16);
 
 	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	(void) VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	ah->handle  = resp->handle;
 	ah->context = pd->context;
-- 
git-series 0.8.10
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
