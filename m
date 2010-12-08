From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/uverbs: Handle large number of entries in poll CQ
Date: Wed, 08 Dec 2010 15:56:09 -0800
Message-ID: <adaaakfkeee.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

So I finally got around to applying this, and I ended up monkeying
around a fair bit, mostly because gcc (my version is 4.4.4) seems to end
up generating horrible code for non-constant designated initializers.
Please look this over before I send it to Linus (and Dan, if you don't
want to be author any more, let me know ;)

 - R.


In ib_uverbs_poll_cq() code there is a potential integer overflow if
userspace passes in a large cmd.ne.  The calls to kmalloc() would
allocate smaller buffers than intended, leading to memory corruption.
There iss also an information leak if resp wasn't all used.
Unprivileged userspace may call this function, although only if an
RDMA device that uses this function is present.

Fix this by copying CQ entries one at a time, which avoids the
allocation entirely, and also by moving this copying into a function
that makes sure to initialize all memory copied to userspace.

Special thanks to Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
for his help and advice.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

[ Monkey around with things a bit to avoid bad code generation by gcc
  when designated initializers are used.  - Roland ]

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |  101 +++++++++++++++++++---------------
 1 files changed, 57 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b342248..f8c6f4e 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -893,68 +893,81 @@ out:
 	return ret ? ret : in_len;
 }
 
+static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
+{
+	struct ib_uverbs_wc tmp;
+
+	tmp.wr_id		= wc->wr_id;
+	tmp.status		= wc->status;
+	tmp.opcode		= wc->opcode;
+	tmp.vendor_err		= wc->vendor_err;
+	tmp.byte_len		= wc->byte_len;
+	tmp.ex.imm_data		= (__u32 __force) wc->ex.imm_data;
+	tmp.qp_num		= wc->qp->qp_num;
+	tmp.src_qp		= wc->src_qp;
+	tmp.wc_flags		= wc->wc_flags;
+	tmp.pkey_index		= wc->pkey_index;
+	tmp.slid		= wc->slid;
+	tmp.sl			= wc->sl;
+	tmp.dlid_path_bits	= wc->dlid_path_bits;
+	tmp.port_num		= wc->port_num;
+	tmp.reserved		= wc->port_num;
+
+	if (copy_to_user(dest, &tmp, sizeof tmp))
+		return -EFAULT;
+
+	return 0;
+}
+
 ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 			  const char __user *buf, int in_len,
 			  int out_len)
 {
 	struct ib_uverbs_poll_cq       cmd;
-	struct ib_uverbs_poll_cq_resp *resp;
+	struct ib_uverbs_poll_cq_resp  resp;
+	u8 __user                     *header_ptr;
+	u8 __user                     *data_ptr;
 	struct ib_cq                  *cq;
-	struct ib_wc                  *wc;
-	int                            ret = 0;
-	int                            i;
-	int                            rsize;
+	struct ib_wc                   wc;
+	int                            ret;
 
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
+	header_ptr = (void __user *)(unsigned long) cmd.response;
+	data_ptr = header_ptr + sizeof resp;
 
-	put_cq_read(cq);
+	memset(&resp, 0, sizeof resp);
+	while (resp.count < cmd.ne) {
+		ret = ib_poll_cq(cq, 1, &wc);
+		if (ret < 0)
+			goto out_put;
+		if (!ret)
+			break;
+
+		ret = copy_wc_to_user(data_ptr, &wc);
+		if (ret)
+			goto out_put;
 
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
+		data_ptr += sizeof(struct ib_uverbs_wc);
+		++resp.count;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response, resp, rsize))
+	if (copy_to_user(header_ptr, &resp, sizeof resp)) {
 		ret = -EFAULT;
+		goto out_put;
+	}
 
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
