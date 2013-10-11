From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 8/9] IB/core: extended command: an improved infrastructure for uverbs commands
Date: Fri, 11 Oct 2013 19:18:53 +0200
Message-ID: <0b84e20b204eb0fc67db9ca9106d6bf753a12ae3.1381510045.git.ydroneaud@opteya.com>
References: <cover.1381510045.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 400dbc9 added an infrastructure for extensible uverbs
commands while later commit 436f2ad exported ib_create_flow()/ib_destroy_flow()
functions using this new infrastructure.

According to the commit 400dbc9, the purpose of this infrastructure is
to support passing around provider (eg. hardware) specific buffers
when userspace issue commands to the kernel, so that it would be possible
to extend uverbs (eg. core) buffers independently from the provider buffers.

But the new kernel command function prototypes were not modified
to take advantage of this extension. This issue was exposed by
Roland Dreier in a previous review[1].

So the following patch is an attempt to a revised extensible command
infrastructure.

This improved extensible command infrastructure distinguish between
core (eg. legacy)'s command/response buffers from provider (eg. hardware)'s
command/response buffers: each extended command implementing function
is given a struct ib_udata to hold core (eg. uverbs) input and output buffers,
and another struct ib_udata to hold the hw (eg. provider) input and output
buffers.
Having those buffers identified separately make it easier to increase one
buffer to support extension without having to add some code to guess
the exact size of each command/response parts: This should make the extended
functions more reliable.

Additionally, instead of relying on command identifier being greater
than IB_USER_VERBS_CMD_THRESHOLD, the proposed infrastructure
rely on unused bits in command field: on the 32 bits provided by
command field, only 6 bits are really needed to encode the identifier
of commands currently supported by the kernel. (Even using only 6 bits
leaves room for about 23 new commands).

So this patch makes use of some high order bits in command field
to store flags, leaving enough room for more command identifiers
than one will ever need (eg. 256).

The new flags are used to specify if the command should be processed
as an extended one or a legacy one. While designing the new command format,
care was taken to make usage of flags itself extensible.

Using high order bits of the commands field ensure
that newer libibverbs on older kernel will properly fail
when trying to call extended commands. On the other hand,
older libibverbs on newer kernel will never be able to issue
calls to extended commands.

The extended command header includes the optional response
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
    .              <uverbs input>            .
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
    .          <uverbs output space>         .
    .             (out_words * 8)            .
    |                                        |
    +----------------------------------------+
    |                                        |
    .         <provider output space>        .
    .         (provider_out_words * 8)       .
    |                                        |
    +----------------------------------------+

The overall design is to ensure that the extensible
infrastructure is itself extensible while begin more
reliable with more input and bound checking.

[1]:
http://marc.info/?i=CAL1RGDWxmM17W2o_era24A-TTDeKyoL6u3NRu_=t_dhV_ZA9MA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org

Cc: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs.h      |  18 ++++-
 drivers/infiniband/core/uverbs_cmd.c  |  56 ++++++++--------
 drivers/infiniband/core/uverbs_main.c | 121 ++++++++++++++++++++++++++--------
 drivers/infiniband/hw/mlx4/main.c     |   6 +-
 include/rdma/ib_verbs.h               |   1 +
 include/uapi/rdma/ib_user_verbs.h     |  21 +++---
 6 files changed, 154 insertions(+), 69 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 4ae0307..bdc842e 100644
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
@@ -233,7 +241,13 @@ IB_UVERBS_DECLARE_CMD(destroy_srq);
 IB_UVERBS_DECLARE_CMD(create_xsrq);
 IB_UVERBS_DECLARE_CMD(open_xrcd);
 IB_UVERBS_DECLARE_CMD(close_xrcd);
-IB_UVERBS_DECLARE_CMD(create_flow);
-IB_UVERBS_DECLARE_CMD(destroy_flow);
+
+#define IB_UVERBS_DECLARE_EX_CMD(name)				\
+	int ib_uverbs_ex_##name(struct ib_uverbs_file *file,	\
+				struct ib_udata *ucore,		\
+				struct ib_udata *uhw)
+
+IB_UVERBS_DECLARE_EX_CMD(create_flow);
+IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 052e07c..e35877d 100644
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
@@ -2639,9 +2631,9 @@ static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 	return 0;
 }
 
-ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
-			      const char __user *buf, int in_len,
-			      int out_len)
+int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
+			     struct ib_udata *ucore,
+			     struct ib_udata *uhw)
 {
 	struct ib_uverbs_create_flow	  cmd;
 	struct ib_uverbs_create_flow_resp resp;
@@ -2655,11 +2647,15 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	void *ib_spec;
 	int i;
 
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
@@ -2671,7 +2667,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	if (cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
 		return -EINVAL;
 
-	if (cmd.flow_attr.size > (in_len - sizeof(cmd)) ||
+	if (cmd.flow_attr.size > ucore->inlen ||
 	    cmd.flow_attr.size >
 	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec)))
 		return -EINVAL;
@@ -2683,11 +2679,10 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 			return -ENOMEM;
 
 		memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
-		if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
-				   cmd.flow_attr.size)) {
-			err = -EFAULT;
+		err = ib_copy_from_udata(kern_flow_attr + 1, ucore,
+					 cmd.flow_attr.size);
+		if (err)
 			goto err_free_attr;
-		}
 	} else {
 		kern_flow_attr = &cmd.flow_attr;
 	}
@@ -2755,11 +2750,10 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
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
@@ -2772,7 +2766,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	kfree(flow_attr);
 	if (cmd.flow_attr.num_of_specs)
 		kfree(kern_flow_attr);
-	return in_len;
+	return 0;
 err_copy:
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
 destroy_flow:
@@ -2789,16 +2783,18 @@ err_free_attr:
 	return err;
 }
 
-ssize_t ib_uverbs_destroy_flow(struct ib_uverbs_file *file,
-			       const char __user *buf, int in_len,
-			       int out_len) {
+int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
+			      struct ib_udata *ucore,
+			      struct ib_udata *uhw)
+{
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
@@ -2820,7 +2816,7 @@ ssize_t ib_uverbs_destroy_flow(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	return ret ? ret : in_len;
+	return ret ? ret : 0;
 }
 
 static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 75ad86c..4f00654 100644
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
+static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
+				    struct ib_udata *ucore,
+				    struct ib_udata *uhw) = {
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
+			return -ENOSYS;
+
+		if (!file->ucontext)
+			return -EINVAL;
+
+		if (!(file->device->ib_dev->uverbs_ex_cmd_mask & (1ull << command)))
+			return -ENOSYS;
+
+		if (count < (sizeof(hdr) + sizeof(ex_hdr)))
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
+			   (ex_hdr.provider_in_words) ? buf + ucore.inlen : 0,
+			   (ex_hdr.provider_out_words) ? (unsigned long)ex_hdr.response + ucore.outlen : 0,
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
index 93577fc..cbfdd4c 100644
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
@@ -777,8 +784,6 @@ struct ib_uverbs_flow_attr {
 
 struct ib_uverbs_create_flow  {
 	__u32 comp_mask;
-	__u32 reserved;
-	__u64 response;
 	__u32 qp_handle;
 	struct ib_uverbs_flow_attr flow_attr;
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
