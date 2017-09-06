From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] IB/uverbs: clean up INIT_UDATA() macro usage
Date: Wed,  6 Sep 2017 23:34:26 +0200
Message-ID: <20170906213521.1845893-2-arnd@arndb.de>
References: <20170906213521.1845893-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170906213521.1845893-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Moses Reuben <mosesr@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

After changing INIT_UDATA_BUF_OR_NULL() to an inline function,
this does the same change to INIT_UDATA for consistency.
I'm keeping it separate as this part is much larger and
we wouldn't want to backport this to stable kernels if we
ever want to address the gcc warnings by backporting the
first patch.

Again, using an inline function gives us better type
safety here among other issues with macros. I'm using
u64_to_user_ptr() to convert the user pointer to simplify
the logic rather than adding lots of new type casts.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/core/uverbs.h     |  22 +++---
 drivers/infiniband/core/uverbs_cmd.c | 125 +++++++++++++++--------------------
 2 files changed, 67 insertions(+), 80 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a8f104a4a91b..ee2739ae4305 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -47,13 +47,17 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
 
-#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
-	do {								\
-		(udata)->inbuf  = (const void __user *) (ibuf);		\
-		(udata)->outbuf = (void __user *) (obuf);		\
-		(udata)->inlen  = (ilen);				\
-		(udata)->outlen = (olen);				\
-	} while (0)
+static inline void
+ib_uverbs_init_udata(struct ib_udata *udata,
+		     const void __user *ibuf,
+		     void __user *obuf,
+		     size_t ilen, size_t olen)
+{
+	udata->inbuf  = ibuf;
+	udata->outbuf = obuf;
+	udata->inlen  = ilen;
+	udata->outlen = olen;
+}
 
 static inline void
 ib_uverbs_init_udata_buf_or_null(struct ib_udata *udata,
@@ -61,7 +65,9 @@ ib_uverbs_init_udata_buf_or_null(struct ib_udata *udata,
 				 void __user *obuf,
 				 size_t ilen, size_t olen)
 {
-	INIT_UDATA(udata, ilen ? ibuf : NULL, olen ? obuf : NULL, ilen, olen);
+	ib_uverbs_init_udata(udata,
+			     ilen ? ibuf : NULL, olen ? obuf : NULL,
+			     ilen, olen);
 }
 
 /*
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 4ab30d832ac5..cf787fabd88c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -91,8 +91,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err;
 	}
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
@@ -141,8 +141,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_fd;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_file;
 	}
@@ -238,8 +237,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	memset(&resp, 0, sizeof resp);
 	copy_query_dev_fields(file, ib_dev, &resp, &ib_dev->attrs);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		return -EFAULT;
 
 	return in_len;
@@ -295,8 +293,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.link_layer      = rdma_port_get_link_layer(ib_dev,
 							cmd.port_num);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		return -EFAULT;
 
 	return in_len;
@@ -320,8 +317,8 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
                    in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
                    out_len - sizeof(resp));
 
@@ -344,8 +341,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	memset(&resp, 0, sizeof resp);
 	resp.pd_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -490,8 +486,8 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
                    in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
                    out_len - sizeof(resp));
 
@@ -556,8 +552,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		atomic_inc(&xrcd->usecnt);
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -655,8 +650,8 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
                    in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
                    out_len - sizeof(resp));
 
@@ -705,8 +700,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	resp.rkey      = mr->rkey;
 	resp.mr_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -748,8 +742,8 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
                    in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
                    out_len - sizeof(resp));
 
@@ -800,8 +794,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	resp.lkey      = mr->lkey;
 	resp.rkey      = mr->rkey;
 
-	if (copy_to_user((void __user *)(unsigned long)cmd.response,
-			 &resp, sizeof(resp)))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof(resp)))
 		ret = -EFAULT;
 	else
 		ret = in_len;
@@ -867,8 +860,8 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 		goto err_free;
 	}
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long)cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
@@ -889,8 +882,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	resp.rkey      = mw->rkey;
 	resp.mw_handle = uobj->id;
 
-	if (copy_to_user((void __user *)(unsigned long)cmd.response,
-			 &resp, sizeof(resp))) {
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -956,8 +948,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 			       uobj_file.uobj);
 	ib_uverbs_init_event_queue(&ev_file->ev_queue);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		uobj_alloc_abort(uobj);
 		return -EFAULT;
 	}
@@ -1087,10 +1078,11 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	INIT_UDATA(&ucore, buf, (unsigned long)cmd.response, sizeof(cmd), sizeof(resp));
+	ib_uverbs_init_udata(&ucore, buf, u64_to_user_ptr(cmd.response),
+			     sizeof(cmd), sizeof(resp));
 
-	INIT_UDATA(&uhw, buf + sizeof(cmd),
-		   (unsigned long)cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&uhw, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
@@ -1173,8 +1165,8 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
@@ -1188,8 +1180,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 
 	resp.cqe = cq->cqe;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp.cqe))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp.cqe))
 		ret = -EFAULT;
 
 out:
@@ -1249,7 +1240,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 		return -EINVAL;
 
 	/* we copy a struct ib_uverbs_poll_cq_resp to user space */
-	header_ptr = (void __user *)(unsigned long) cmd.response;
+	header_ptr = u64_to_user_ptr(cmd.response);
 	data_ptr = header_ptr + sizeof resp;
 
 	memset(&resp, 0, sizeof resp);
@@ -1343,8 +1334,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	resp.async_events_reported = obj->async_events_reported;
 
 	uverbs_uobject_put(uobj);
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		return -EFAULT;
 
 	return in_len;
@@ -1650,10 +1640,10 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	INIT_UDATA(&ucore, buf, (unsigned long)cmd.response, sizeof(cmd),
-		   resp_size);
-	INIT_UDATA(&uhw, buf + sizeof(cmd),
-		   (unsigned long)cmd.response + resp_size,
+	ib_uverbs_init_udata(&ucore, buf, u64_to_user_ptr(cmd.response),
+		   sizeof(cmd), resp_size);
+	ib_uverbs_init_udata(&uhw, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + resp_size,
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - resp_size);
 
@@ -1750,8 +1740,8 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
@@ -1795,8 +1785,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	resp.qpn       = qp->qp_num;
 	resp.qp_handle = obj->uevent.uobject.id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_destroy;
 	}
@@ -1911,8 +1900,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	resp.max_inline_data        = init_attr->cap.max_inline_data;
 	resp.sq_sig_all             = init_attr->sq_sig_type == IB_SIGNAL_ALL_WR;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		ret = -EFAULT;
 
 out:
@@ -2042,7 +2030,7 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	    ~((IB_USER_LEGACY_LAST_QP_ATTR_MASK << 1) - 1))
 		return -EOPNOTSUPP;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd.base), NULL,
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd.base), NULL,
 		   in_len - sizeof(cmd.base) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len);
 
@@ -2126,8 +2114,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	resp.events_reported = obj->uevent.events_reported;
 	uverbs_uobject_put(uobj);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		return -EFAULT;
 
 	return in_len;
@@ -2311,8 +2298,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 				break;
 		}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		ret = -EFAULT;
 
 out_put:
@@ -2460,8 +2446,7 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 		}
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		ret = -EFAULT;
 
 out:
@@ -2510,8 +2495,7 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 				break;
 		}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		ret = -EFAULT;
 
 out:
@@ -2548,8 +2532,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (!rdma_is_port_valid(ib_dev, cmd.attr.port_num))
 		return -EINVAL;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long)cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
@@ -2600,8 +2584,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 
 	resp.ah_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -3627,8 +3610,8 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	xcmd.max_sge	 = cmd.max_sge;
 	xcmd.srq_limit	 = cmd.srq_limit;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
@@ -3654,8 +3637,8 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+	ib_uverbs_init_udata(&udata, buf + sizeof(cmd),
+		   u64_to_user_ptr(cmd.response) + sizeof(resp),
 		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
 		   out_len - sizeof(resp));
 
@@ -3680,7 +3663,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
+	ib_uverbs_init_udata(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
 		   out_len);
 
 	srq = uobj_get_obj_read(srq, cmd.srq_handle, file->ucontext);
@@ -3731,8 +3714,7 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	resp.max_sge   = attr.max_sge;
 	resp.srq_limit = attr.srq_limit;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof resp))
 		return -EFAULT;
 
 	return in_len;
@@ -3773,8 +3755,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	}
 	resp.events_reported = obj->events_reported;
 	uverbs_uobject_put(uobj);
-	if (copy_to_user((void __user *)(unsigned long)cmd.response,
-			 &resp, sizeof(resp)))
+	if (copy_to_user(u64_to_user_ptr(cmd.response), &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
-- 
2.9.0
