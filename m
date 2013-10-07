From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] IB/core: extended command: move comp_mask to the extended header
Date: Mon,  7 Oct 2013 22:49:15 +0200
Message-ID: <c359f15888450bc5d614929aee8b902a0132f606.1381177342.git.ydroneaud@opteya.com>
References: <cover.1381177342.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The unused field in the extended header is a perfect candidate
to hold the command "comp_mask" (eg. bit field used to handle
compatibility). This was suggested by Roland Dreier, in:

  Subject: Re: [PATCH V4 for-next 2/4] IB/core: Infra-structure to support verbs extensions through uverbs
  Date: 2013-08-13 19:18:51 GMT
  Message-Id: <CAL1RGDXJtrc849M6_XNZT5xO1+ybKtLWGq6yg6LhoSsKpsmkYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

So this patch move comp_mask from create_flow/destroy_flow commands
to the extended command header. Then comp_mask is passed as part
of function parameters.

Cc: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs.h      |  3 ++-
 drivers/infiniband/core/uverbs_cmd.c  | 15 ++++++++++-----
 drivers/infiniband/core/uverbs_main.c |  6 ++++--
 include/uapi/rdma/ib_user_verbs.h     |  6 +++---
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b5d0874..03f6a0a 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -229,7 +229,8 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 #define IB_UVERBS_DECLARE_EX_CMD(name)				\
 	int ib_uverbs_ex_##name(struct ib_uverbs_file *file,	\
 				struct ib_udata *ucore,		\
-				struct ib_udata *uhw)
+				struct ib_udata *uhw,		\
+				__u32 comp_mask)
 
 IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 57c2b6c..df5b443 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2633,7 +2633,8 @@ static int kern_spec_to_ib_spec(struct ib_kern_spec *kern_spec,
 
 int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 			     struct ib_udata *ucore,
-			     struct ib_udata *uhw)
+			     struct ib_udata *uhw,
+			     __u32 comp_mask)
 {
 	struct ib_uverbs_create_flow	  cmd;
 	struct ib_uverbs_create_flow_resp resp;
@@ -2648,6 +2649,9 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	int i;
 	int kern_attr_size;
 
+	if (comp_mask)
+		return -EINVAL;
+
 	if (ucore->outlen < sizeof(resp))
 		return -ENOSPC;
 
@@ -2658,9 +2662,6 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	ucore->inbuf += sizeof(cmd);
 	ucore->inlen -= sizeof(cmd);
 
-	if (cmd.comp_mask)
-		return -EINVAL;
-
 	if ((cmd.flow_attr.type == IB_FLOW_ATTR_SNIFFER &&
 	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
 		return -EPERM;
@@ -2789,13 +2790,17 @@ err_free_attr:
 
 int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 			      struct ib_udata *ucore,
-			      struct ib_udata *uhw)
+			      struct ib_udata *uhw,
+			      __u32 comp_mask)
 {
 	struct ib_uverbs_destroy_flow	cmd;
 	struct ib_flow			*flow_id;
 	struct ib_uobject		*uobj;
 	int				ret;
 
+	if (comp_mask)
+		return -EINVAL;
+
 	ret = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 4f00654..a9687dd 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -119,7 +119,8 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 
 static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 				    struct ib_udata *ucore,
-				    struct ib_udata *uhw) = {
+				    struct ib_udata *uhw,
+				    __u32 comp_mask) = {
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
 	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow
 };
@@ -689,7 +690,8 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 
 		err = uverbs_ex_cmd_table[command](file,
 						   &ucore,
-						   &uhw);
+						   &uhw,
+						   ex_hdr.comp_mask);
 
 		if (err)
 			return err;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index dab577a..13b3008 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -139,7 +139,7 @@ struct ib_uverbs_ex_cmd_hdr {
 	__u64 response;
 	__u16 provider_in_words;
 	__u16 provider_out_words;
-	__u32 cmd_hdr_reserved;
+	__u32 comp_mask;
 };
 
 struct ib_uverbs_get_context {
@@ -772,8 +772,8 @@ struct ib_kern_flow_attr {
 };
 
 struct ib_uverbs_create_flow  {
-	__u32 comp_mask;
 	__u32 qp_handle;
+	__u32 reserved;
 	struct ib_kern_flow_attr flow_attr;
 };
 
@@ -783,8 +783,8 @@ struct ib_uverbs_create_flow_resp {
 };
 
 struct ib_uverbs_destroy_flow  {
-	__u32 comp_mask;
 	__u32 flow_handle;
+	__u32 reserved;
 };
 
 struct ib_uverbs_create_srq {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
