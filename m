From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] An improved infrastructure for uverbs commands (My take at
 designing extensible scheme)
Date: Tue, 24 Sep 2013 18:16:32 +0200
Message-ID: <1380039392-15480-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here's a proposal for a slightly improved way to support
extended/extensible commands.

Commit 400dbc9 added an infrastructure for extensible uverbs
commands which was proposed during the summer (in
most northern hemisphere of Earth, at least).

Later, commit 436f2ad exported ib_create_flow()/ib_destroy_flow()
functions using this new infrastructure.

According to the commit 400dbc9, the purpose of this infrastructure was
to support passing around provider (eg. hardware) specific buffers
when userspace issue commands to the kernel, so that it would be possible
to extend uverbs (eg. core) buffers independently from the provider buffers.

But the new kernel command function prototypes wasn't modified
to take advantage of this extension. This issue was exposed by Roland Dreier

  Subject: Re: [PATCH V2 for-next 2/4] IB/core: Infra-structure to support verbs extensions through uverbs
  Date: 2013-06-26 13:05:16 GMT
  Message-Id: <CAL1RGDWxmM17W2o_era24A-TTDeKyoL6u3NRu_=t_dhV_ZA9MA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

Additionally, the way command identifier is used to expose newer
extended commands could be improved for being more future proof.

So here's an attempt to a revised extensible command infrastructure.

This improved extensible command infrastructure distinguish between
core (eg. legacy)'s command/response buffers from provider (eg. hardware)'s
command/response buffers: each extended command implementing function
is given a struct ib_udata to hold legacy input and output buffers,
and another struct ib_udata to hold the provider input and output buffers.
Having those buffers identified separately make it easier to increase one
buffer to support extension without having to add some code to guess
the exact size of each command/response parts: This should make the extended
functions more reliable.

Additionally, instead of relying on command identifier being greater
than IB_USER_VERBS_CMD_THRESHOLD, the proposed infrastructure
rely on unused bits in command field: on the 32 bits provided by
command field, only 6 bits are needed to encode the command identifier
currently supported by the kernel this leave some room for creativity
(in fact using 6 bits already leave about 23 available commands).

So this patch makes use of some high order bits in command field
to store flags, leaving enough room for more command identifiers
than one will ever need (eg. 256).

The new flags are used to specify if the command should be processed
as an extended one or a legacy one. Care was taken to make usage
of flags itself extensible.

Using high order bits of the commands field ensure
that newer libibverbs on older kernel will properly fail
when trying to call extended commands. On the other hand,
older libibverbs on newer kernel will never be able to issue
calls to extended commands.

The extended header includes the optional response
pointer so that output buffer length and output buffer pointer
are located together in the command, allowing proper parameters
checking. This should make implementing functions easier and safer.

Additionally the extended header ensure 64bits alignment,
while making all sizes multiple of 8 bytes, extending
the maximum buffer size:

                             legacy      extended

   Maximum command buffer:  256KBytes   1024KBytes (512KBytes + 512KBytes)
  Maximum response buffer:  256KBytes   1024KBytes (512KBytes + 512KBytes)

For the purpose of doing proper buffer size accounting, the headers size
are no more taken in account in "in_words".

One of the odds of the current extensible infrastructure, reading twice
the "legacy" command header, is fixed by removing the "legacy" command header
from the extended command header: they are processed as two different parts
of the command: memory is read once and information are not duplicated:
it's making clear that's an extended command scheme and not a different
command scheme.

The proposed scheme will format input (command) and output (response)
buffers this way:

- command:

  legacy header +
  extended header +
  command data (core + hw):

    +----------------------------------------+
    | flags     |   00      00    |  command |
    |        in_words    |   out_words       |
    +----------------------------------------+
    |                 response               |
    |                 response               |
    | provider_in_words | provider_out_words |
    |                 padding                |
    +----------------------------------------+
    |                                        |
    .             <command input>            .
    .              (in_words * 8)            .
    |                                        |
    +----------------------------------------+
    |                                        |
    .             <provider input>           .
    .          (provider_in_words * 8)       .
    |                                        |
    +----------------------------------------+

- response, if present:

    +----------------------------------------+
    |                                        |
    .             <command output>           .
    .             (out_words * 8)            .
    |                                        |
    +----------------------------------------+
    |                                        |
    .            <provider output>           .
    .         (provider_out_words * 8)       .
    |                                        |
    +----------------------------------------+

The overall design is to ensure that the extensible
infrastructure is itself extensible while begin more
reliable with more input and bound checking.

This new extended header / command format
does not address the "compatibility" problem,
this particular issue is left to the "comp_mask"
field on each command. But moving "comp_mask" to
the extended header might benefit each future
extended command providing a common compatibility
scheme. This was suggested by Roland Dreier, see:

  Subject: Re: [PATCH V4 for-next 2/4] IB/core: Infra-structure to support verbs extensions through uverbs
  Date: 2013-08-13 19:18:51 GMT
  Message-Id: <CAL1RGDXJtrc849M6_XNZT5xO1+ybKtLWGq6yg6LhoSsKpsmkYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

The current infrastructure for extensible uverbs commands was brought by
patch which was proposed for reviews multiple times:

- as part of "IP based RoCE GID Addressing" patchset:

  1) Subject: [PATCH for-next 3/4] IB/core: Infra-structure to support verbs extensions through uverbs
     Date: 2013-06-13 15:01:40 GMT
     Message-Id: <1371135704-5712-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

  2) Subject: [PATCH V2 5/8] IB/core: Infra-structure to support verbs extensions through uverbs
     Date: 2013-07-11 15:40:46 GMT
     Message-Id: <1373557249-20374-6-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

  3) Subject: [PATCH V3 for-next 6/9] IB/core: Infra-structure to support verbs extensions through uverbs
     Date: 2013-08-07 15:34:59 GMT
     Message-Id: <1375889702-14818-7-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

- as part of "Add receive Flow Steering support" patchset:

  0) Subject: [PATCH for-next 7/9] IB/core: Infra-structure to support verbs extensions through uverbs
     Date: 2013-04-24 13:58:50 GMT
     Message-Id: <1366811932-28199-8-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

  1) Subject: [PATCH V1 for-next 2/4] IB/core: Infra-structure to support verbs extensions through uverbs
     Date: 2013-06-11 11:42:51 GMT
     Message-Id: <1370950973-11716-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

  2) Subject: [PATCH V2 for-next 2/4] IB/core: Infra-structure to support verbs extensions through uverbs
     Date: 2013-06-26 12:57:42 GMT
     Message-Id: <1372251464-13394-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

  3) Subject: [PATCH V3 for-next 2/4] IB/core: Infra-structure to support verbs extensions through uverbs
     Date: 2013-07-03 17:42:14 GMT
     Message-Id: <1372873336-13694-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

  4) Subject: [PATCH V4 for-next 2/4] IB/core: Infra-structure to support verbs extensions through uverbs
     Date: 2013-08-07 11:02:00 GMT
     Message-Id: <1375873322-19384-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

  5) Subject: [PATCH V5 for-next 2/4] IB/core: Infrastructure to support verbs extensions through uverbs
     Date: 2013-08-14 10:58:29 GMT
     Message-Id: <1376477911-13828-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

  6) Subject: [PATCH V4 for-next 2/4] IB/core: Infrastructure to support verbs extensions through uverbs
     Date: 2013-08-28 12:47:53 GMT
     Message-Id: <1377694075-29287-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

     (Yes the last revision was incorrectly tagged V4 while its changelog is describing V6).

It's now integrated in Linux v3.12-rc1 and need to be improved so that it could be kept
for final Linux v3.12.

PS: I haven't tested the create_flow() commands, (hopefully)
there's no libibverbs support yet for the new commands for the moment.
I will try to provide patches to improve create_flow()/destroy_flow()
and the way its data structures are expressed.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  18 ++++-
 drivers/infiniband/core/uverbs_cmd.c  |  55 ++++++++--------
 drivers/infiniband/core/uverbs_main.c | 121 ++++++++++++++++++++++++++--------
 drivers/infiniband/hw/mlx4/main.c     |   6 +-
 include/rdma/ib_verbs.h               |   1 +
 include/uapi/rdma/ib_user_verbs.h     |  19 ++++--
 6 files changed, 154 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d040b87..4cc0734 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -47,6 +47,14 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
 
+#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
+	do {								\
+		(udata)->inbuf  = (void __user *) (ibuf);		\
+		(udata)->outbuf = (void __user *) (obuf);		\
+		(udata)->inlen  = (ilen);				\
+		(udata)->outlen = (olen);				\
+	} while (0)
+
 /*
  * Our lifetime rules for these structs are the following:
  *
@@ -217,7 +225,13 @@ IB_UVERBS_DECLARE_CMD(destroy_srq);
 IB_UVERBS_DECLARE_CMD(create_xsrq);
 IB_UVERBS_DECLARE_CMD(open_xrcd);
 IB_UVERBS_DECLARE_CMD(close_xrcd);
-IB_UVERBS_DECLARE_CMD(create_flow);
-IB_UVERBS_DECLARE_CMD(destroy_flow);
+
+#define IB_UVERBS_DECLARE_EX_CMD(name)					\
+	ssize_t ib_uverbs_ex_##name(struct ib_uverbs_file *file,	\
+				    struct ib_udata *ucore,		\
+				    struct ib_udata *uhw)
+
+IB_UVERBS_DECLARE_EX_CMD(create_flow);
+IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f2b81b9..2442d15 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -56,14 +56,6 @@ static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
 
-#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
-	do {								\
-		(udata)->inbuf  = (void __user *) (ibuf);		\
-		(udata)->outbuf = (void __user *) (obuf);		\
-		(udata)->inlen  = (ilen);				\
-		(udata)->outlen = (olen);				\
-	} while (0)
-
 /*
  * The ib_uobject locking scheme is as follows:
  *
@@ -2639,9 +2631,9 @@ static int kern_spec_to_ib_spec(struct ib_kern_spec *kern_spec,
 	return 0;
 }
 
-ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
-			      const char __user *buf, int in_len,
-			      int out_len)
+ssize_t ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
+				 struct ib_udata *ucore,
+				 struct ib_udata *uhw)
 {
 	struct ib_uverbs_create_flow	  cmd;
 	struct ib_uverbs_create_flow_resp resp;
@@ -2656,11 +2648,15 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	int i;
 	int kern_attr_size;
 
-	if (out_len < sizeof(resp))
+	if (ucore->outlen < sizeof(resp))
 		return -ENOSPC;
 
-	if (copy_from_user(&cmd, buf, sizeof(cmd)))
-		return -EFAULT;
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	ucore->inbuf += sizeof(cmd);
+	ucore->inlen -= sizeof(cmd);
 
 	if (cmd.comp_mask)
 		return -EINVAL;
@@ -2674,9 +2670,10 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 		return -EINVAL;
 
 	kern_attr_size = cmd.flow_attr.size - sizeof(cmd) -
-			 sizeof(struct ib_uverbs_cmd_hdr_ex);
+			 (sizeof(struct ib_uverbs_cmd_hdr) +
+			  sizeof(struct ib_uverbs_ex_cmd_hdr));
 
-	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
+	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > ucore->inlen ||
 	    kern_attr_size < 0 || kern_attr_size >
 	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
 		return -EINVAL;
@@ -2687,8 +2684,8 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 			return -ENOMEM;
 
 		memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
-		if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
-				   kern_attr_size)) {
+		if (ib_copy_from_udata(kern_flow_attr + 1, ucore,
+				       kern_attr_size)) {
 			err = -EFAULT;
 			goto err_free_attr;
 		}
@@ -2757,11 +2754,10 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	memset(&resp, 0, sizeof(resp));
 	resp.flow_handle = uobj->id;
 
-	if (copy_to_user((void __user *)(unsigned long) cmd.response,
-			 &resp, sizeof(resp))) {
-		err = -EFAULT;
+	err = ib_copy_to_udata(ucore,
+			       &resp, sizeof(resp));
+	if (err)
 		goto err_copy;
-	}
 
 	put_qp_read(qp);
 	mutex_lock(&file->mutex);
@@ -2774,7 +2770,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	kfree(flow_attr);
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
-	return in_len;
+	return 0;
 err_copy:
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
@@ -2791,16 +2787,17 @@ err_free_attr:
 	return err;
 }
 
-ssize_t ib_uverbs_destroy_flow(struct ib_uverbs_file *file,
-			       const char __user *buf, int in_len,
-			       int out_len) {
+ssize_t ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
+				  struct ib_udata *ucore,
+				  struct ib_udata *uhw) {
 	struct ib_uverbs_destroy_flow	cmd;
 	struct ib_flow			*flow_id;
 	struct ib_uobject		*uobj;
 	int				ret;
 
-	if (copy_from_user(&cmd, buf, sizeof(cmd)))
-		return -EFAULT;
+	ret = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (ret)
+		return ret;
 
 	uobj = idr_write_uobj(&ib_uverbs_rule_idr, cmd.flow_handle,
 			      file->ucontext);
@@ -2822,7 +2819,7 @@ ssize_t ib_uverbs_destroy_flow(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	return ret ? ret : in_len;
+	return ret ? ret : 0;
 }
 
 static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 75ad86c..a3cd310 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -115,8 +115,13 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
 	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq,
 	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
-	[IB_USER_VERBS_CMD_CREATE_FLOW]		= ib_uverbs_create_flow,
-	[IB_USER_VERBS_CMD_DESTROY_FLOW]	= ib_uverbs_destroy_flow
+};
+
+static ssize_t (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
+					struct ib_udata *ucore,
+					struct ib_udata *uhw) = {
+	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
+	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
@@ -587,6 +592,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 {
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_uverbs_cmd_hdr hdr;
+	__u32 flags;
 
 	if (count < sizeof hdr)
 		return -EINVAL;
@@ -594,41 +600,104 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof hdr))
 		return -EFAULT;
 
-	if (hdr.command >= ARRAY_SIZE(uverbs_cmd_table) ||
-	    !uverbs_cmd_table[hdr.command])
-		return -EINVAL;
+	flags = (hdr.command &
+		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
 
-	if (!file->ucontext &&
-	    hdr.command != IB_USER_VERBS_CMD_GET_CONTEXT)
-		return -EINVAL;
+	if (!flags) {
+		__u32 command;
 
-	if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << hdr.command)))
-		return -ENOSYS;
+		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
+					   IB_USER_VERBS_CMD_COMMAND_MASK))
+			return -EINVAL;
 
-	if (hdr.command >= IB_USER_VERBS_CMD_THRESHOLD) {
-		struct ib_uverbs_cmd_hdr_ex hdr_ex;
+		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
 
-		if (copy_from_user(&hdr_ex, buf, sizeof(hdr_ex)))
-			return -EFAULT;
+		if (command >= ARRAY_SIZE(uverbs_cmd_table) ||
+		    !uverbs_cmd_table[command])
+			return -EINVAL;
 
-		if (((hdr_ex.in_words + hdr_ex.provider_in_words) * 4) != count)
+		if (!file->ucontext &&
+		    command != IB_USER_VERBS_CMD_GET_CONTEXT)
 			return -EINVAL;
 
-		return uverbs_cmd_table[hdr.command](file,
-						     buf + sizeof(hdr_ex),
-						     (hdr_ex.in_words +
-						      hdr_ex.provider_in_words) * 4,
-						     (hdr_ex.out_words +
-						      hdr_ex.provider_out_words) * 4);
-	} else {
+		if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << command)))
+			return -ENOSYS;
+
 		if (hdr.in_words * 4 != count)
 			return -EINVAL;
 
-		return uverbs_cmd_table[hdr.command](file,
-						     buf + sizeof(hdr),
-						     hdr.in_words * 4,
-						     hdr.out_words * 4);
+		return uverbs_cmd_table[command](file,
+						 buf + sizeof(hdr),
+						 hdr.in_words * 4,
+						 hdr.out_words * 4);
+
+	} else if (flags == IB_USER_VERBS_CMD_FLAG_EXTENDED) {
+		__u32 command;
+
+		struct ib_uverbs_ex_cmd_hdr ex_hdr;
+		struct ib_udata ucore;
+		struct ib_udata uhw;
+		int err;
+
+		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
+					   IB_USER_VERBS_CMD_COMMAND_MASK))
+			return -EINVAL;
+
+		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
+
+		if (command >= ARRAY_SIZE(uverbs_ex_cmd_table) ||
+		    !uverbs_ex_cmd_table[command])
+			return -EINVAL;
+
+		if (!file->ucontext)
+			return -EINVAL;
+
+		if (!(file->device->ib_dev->uverbs_ex_cmd_mask & (1ull << command)))
+			return -ENOSYS;
+
+		if (count < sizeof(hdr) + sizeof(ex_hdr))
+			return -EINVAL;
+
+		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr)))
+			return -EFAULT;
+
+		count -= sizeof(hdr) + sizeof(ex_hdr);
+		buf += sizeof(hdr) + sizeof(ex_hdr);
+
+		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 != count)
+			return -EINVAL;
+
+		if (ex_hdr.response) {
+			if (!hdr.out_words && !ex_hdr.provider_out_words)
+				return -EINVAL;
+		} else {
+			if (hdr.out_words || ex_hdr.provider_out_words)
+				return -EINVAL;
+		}
+
+		INIT_UDATA(&ucore,
+			   (hdr.in_words) ? buf : 0,
+			   (unsigned long)ex_hdr.response,
+			   hdr.in_words * 8,
+			   hdr.out_words * 8);
+
+		INIT_UDATA(&uhw,
+			   (ex_hdr.provider_in_words) ? buf + (hdr.in_words * 8) : 0,
+			   (ex_hdr.provider_out_words) ? (unsigned long)ex_hdr.response + (hdr.out_words * 8) : 0,
+			   ex_hdr.provider_in_words * 8,
+			   ex_hdr.provider_out_words * 8);
+
+		err = uverbs_ex_cmd_table[command](file,
+						   &ucore,
+						   &uhw);
+
+		if (err)
+			return err;
+
+		return count;
 	}
+
+	return -ENOSYS;
 }
 
 static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index d6c5a73..1aad9b3 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1691,9 +1691,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->ib_dev.create_flow	= mlx4_ib_create_flow;
 		ibdev->ib_dev.destroy_flow	= mlx4_ib_destroy_flow;
 
-		ibdev->ib_dev.uverbs_cmd_mask	|=
-			(1ull << IB_USER_VERBS_CMD_CREATE_FLOW) |
-			(1ull << IB_USER_VERBS_CMD_DESTROY_FLOW);
+		ibdev->ib_dev.uverbs_ex_cmd_mask	|=
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW);
 	}
 
 	mlx4_ib_alloc_eqs(dev, ibdev);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e393171..a06fc12 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1436,6 +1436,7 @@ struct ib_device {
 
 	int			     uverbs_abi_ver;
 	u64			     uverbs_cmd_mask;
+	u64			     uverbs_ex_cmd_mask;
 
 	char			     node_desc[64];
 	__be64			     node_guid;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 0b233c5..3872539 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -87,8 +87,11 @@ enum {
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
 	IB_USER_VERBS_CMD_CREATE_XSRQ,
 	IB_USER_VERBS_CMD_OPEN_QP,
-	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
-	IB_USER_VERBS_CMD_DESTROY_FLOW
+};
+
+enum {
+	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
+	IB_USER_VERBS_EX_CMD_DESTROY_FLOW
 };
 
 /*
@@ -120,16 +123,20 @@ struct ib_uverbs_comp_event_desc {
  * the rest of the command struct based on these value.
  */
 
+#define IB_USER_VERBS_CMD_COMMAND_MASK 0xff
+#define IB_USER_VERBS_CMD_FLAGS_MASK 0xff000000u
+#define IB_USER_VERBS_CMD_FLAGS_SHIFT 24
+
+#define IB_USER_VERBS_CMD_FLAG_EXTENDED 0x80
+
 struct ib_uverbs_cmd_hdr {
 	__u32 command;
 	__u16 in_words;
 	__u16 out_words;
 };
 
-struct ib_uverbs_cmd_hdr_ex {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+struct ib_uverbs_ex_cmd_hdr {
+	__u64 response;
 	__u16 provider_in_words;
 	__u16 provider_out_words;
 	__u32 cmd_hdr_reserved;
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
