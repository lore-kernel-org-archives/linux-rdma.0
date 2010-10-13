From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch v4] infiniband: uverbs: handle large number of entries
Date: Wed, 13 Oct 2010 11:13:12 +0200
Message-ID: <20101013091312.GB6060@bicker>
References: <20101007071610.GC11681@bicker> <20101007161649.GD21206@obsidianresearch.com> <20101007165947.GD11681@bicker> <20101009231607.GA24649@obsidianresearch.com> <20101012113117.GB6742@bicker> <20101012210118.GR24268@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101012210118.GR24268-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the original code there was a potential integer overflow if you
passed in a large cmd.ne.  The calls to kmalloc() would allocate smaller
buffers than intended, leading to memory corruption. There was also an 
information leak if resp wasn't all used.

Documentation/infiniband/user_verbs.txt suggests this function is meant
for unprivileged access.

Special thanks to Jason Gunthorpe for his help and advice.

CC: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
v4:  Fixed a bug where count wasn't sent to the user.
     Removed the calls to memset() and used C99 initializers instead.

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6fcfbeb..5fc1e29 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -891,68 +891,88 @@ out:
 	return ret ? ret : in_len;
 }
 
+static int copy_header_to_user(void __user *dest, u32 count)
+{
+	u32 header[2] = {count, 0};  /* the second u32 is reserved */
+
+	if (copy_to_user(dest, header, sizeof(header)))
+		return -EFAULT;
+	return 0;
+}
+
+static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
+{
+	struct ib_uverbs_wc tmp = {
+	.wr_id		= wc->wr_id,
+	.status		= wc->status,
+	.opcode		= wc->opcode,
+	.vendor_err	= wc->vendor_err,
+	.byte_len	= wc->byte_len,
+	.ex = {
+		.imm_data = (__u32 __force) wc->ex.imm_data,
+	},
+	.qp_num		= wc->qp->qp_num,
+	.src_qp		= wc->src_qp,
+	.wc_flags	= wc->wc_flags,
+	.pkey_index	= wc->pkey_index,
+	.slid		= wc->slid,
+	.sl		= wc->sl,
+	.dlid_path_bits = wc->dlid_path_bits,
+	.port_num	= wc->port_num,
+	};
+
+	if (copy_to_user(dest, &tmp, sizeof(tmp)))
+		return -EFAULT;
+	return 0;
+}
+
 ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 			  const char __user *buf, int in_len,
 			  int out_len)
 {
 	struct ib_uverbs_poll_cq       cmd;
-	struct ib_uverbs_poll_cq_resp *resp;
+	u8 __user                     *header_ptr;
+	u8 __user                     *data_ptr;
 	struct ib_cq                  *cq;
-	struct ib_wc                  *wc;
-	int                            ret = 0;
+	struct ib_wc                   wc;
+	u32                            count = 0;
+	int                            ret;
 	int                            i;
-	int                            rsize;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	wc = kmalloc(cmd.ne * sizeof *wc, GFP_KERNEL);
-	if (!wc)
-		return -ENOMEM;
-
-	rsize = sizeof *resp + cmd.ne * sizeof(struct ib_uverbs_wc);
-	resp = kmalloc(rsize, GFP_KERNEL);
-	if (!resp) {
-		ret = -ENOMEM;
-		goto out_wc;
-	}
-
 	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
-	if (!cq) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!cq)
+		return -EINVAL;
 
-	resp->count = ib_poll_cq(cq, cmd.ne, wc);
+	/* we copy a struct ib_uverbs_poll_cq_resp to user space */
+	header_ptr = (void __user *)(unsigned long)cmd.response;
+	data_ptr = header_ptr + sizeof(u32) * 2;
 
-	put_cq_read(cq);
+	for (i = 0; i < cmd.ne; i++) {
+		ret = ib_poll_cq(cq, 1, &wc);
+		if (ret < 0)
+			goto out_put;
+		if (!ret)
+			break;
 
-	for (i = 0; i < resp->count; i++) {
-		resp->wc[i].wr_id 	   = wc[i].wr_id;
-		resp->wc[i].status 	   = wc[i].status;
-		resp->wc[i].opcode 	   = wc[i].opcode;
-		resp->wc[i].vendor_err 	   = wc[i].vendor_err;
-		resp->wc[i].byte_len 	   = wc[i].byte_len;
-		resp->wc[i].ex.imm_data    = (__u32 __force) wc[i].ex.imm_data;
-		resp->wc[i].qp_num 	   = wc[i].qp->qp_num;
-		resp->wc[i].src_qp 	   = wc[i].src_qp;
-		resp->wc[i].wc_flags 	   = wc[i].wc_flags;
-		resp->wc[i].pkey_index 	   = wc[i].pkey_index;
-		resp->wc[i].slid 	   = wc[i].slid;
-		resp->wc[i].sl 		   = wc[i].sl;
-		resp->wc[i].dlid_path_bits = wc[i].dlid_path_bits;
-		resp->wc[i].port_num 	   = wc[i].port_num;
+		ret = copy_wc_to_user(data_ptr, &wc);
+		if (ret)
+			goto out_put;
+		data_ptr += sizeof(struct ib_uverbs_wc);
+		count++;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response, resp, rsize))
-		ret = -EFAULT;
+	ret = copy_header_to_user(header_ptr, count);
+	if (ret)
+		goto out_put;
 
-out:
-	kfree(resp);
+	ret = in_len;
 
-out_wc:
-	kfree(wc);
-	return ret ? ret : in_len;
+out_put:
+	put_cq_read(cq);
+	return ret;
 }
 
 ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
