From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch v4] infiniband: uverbs: handle large number of entries
Date: Wed, 24 Nov 2010 14:07:40 -0800
Message-ID: <adahbf6gytv.fsf@cisco.com>
References: <20101007071610.GC11681@bicker>
	<20101007161649.GD21206@obsidianresearch.com>
	<20101007165947.GD11681@bicker>
	<20101009231607.GA24649@obsidianresearch.com>
	<20101012113117.GB6742@bicker>
	<20101012210118.GR24268@obsidianresearch.com>
	<20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101123071025.GI1522@bicker> (Dan Carpenter's message of "Tue,
	23 Nov 2010 10:10:25 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Crap!  Apparently c99 initialization zeroes out the holes most of the
 > time but not all the time.

I think in this case we would be OK, since the structs involved here
don't have holes.  Right?

However, I think this final patch is not really what I would like here.
I didn't follow the discussion carefully, but it seems things ended up
off track.

poll_cq is a data path operation where performance matters, and the
whole point of passing in cmd.ne (the number of completion entries to
poll) is to allow the low level driver to batch things up to save
overhead.  So converting this into a loop that polls one at a time is
not the best thing to do.

What was wrong with:

 - Fixing the potential integer overflow by capping cmd.ne at some high
   but safe value (1000 say)

 - Fixing the information leaks by setting resp->reserved = 0 and inside
   the loop resp->wc[i].reserved = 0, and then only copying the actual
   number of completions polled to userspace

 - And as a bonus handling the (nearly impossible) case of ib_poll_cq
   returning a negative value

IOW a patch like the below (compile tested only):

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b342248..ec6e434 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -903,17 +903,17 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	struct ib_wc                  *wc;
 	int                            ret = 0;
 	int                            i;
-	int                            rsize;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	cmd.ne = min_t(u32, cmd.ne, IB_UVERBS_POLL_CQ_MAX_ENTRIES);
+
 	wc = kmalloc(cmd.ne * sizeof *wc, GFP_KERNEL);
 	if (!wc)
 		return -ENOMEM;
 
-	rsize = sizeof *resp + cmd.ne * sizeof(struct ib_uverbs_wc);
-	resp = kmalloc(rsize, GFP_KERNEL);
+	resp = kmalloc(sizeof *resp + cmd.ne * sizeof *resp->wc, GFP_KERNEL);
 	if (!resp) {
 		ret = -ENOMEM;
 		goto out_wc;
@@ -925,10 +925,17 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 		goto out;
 	}
 
-	resp->count = ib_poll_cq(cq, cmd.ne, wc);
+	ret = ib_poll_cq(cq, cmd.ne, wc);
+	if (ret < 0) {
+		ret = -EIO;
+		goto out;
+	}
 
 	put_cq_read(cq);
 
+	resp->count    = ret;
+	resp->reserved = 0;
+
 	for (i = 0; i < resp->count; i++) {
 		resp->wc[i].wr_id 	   = wc[i].wr_id;
 		resp->wc[i].status 	   = wc[i].status;
@@ -944,9 +951,11 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 		resp->wc[i].sl 		   = wc[i].sl;
 		resp->wc[i].dlid_path_bits = wc[i].dlid_path_bits;
 		resp->wc[i].port_num 	   = wc[i].port_num;
+		resp->wc[i].reserved	   = 0;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response, resp, rsize))
+	if (copy_to_user((void __user *) (unsigned long) cmd.response, resp,
+			 sizeof *resp + resp->count * sizeof *resp->wc))
 		ret = -EFAULT;
 
 out:
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index fe5b051..61b0286 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -278,6 +278,10 @@ struct ib_uverbs_resize_cq_resp {
 	__u64 driver_data[0];
 };
 
+enum {
+	IB_UVERBS_POLL_CQ_MAX_ENTRIES	= 1000
+};
+
 struct ib_uverbs_poll_cq {
 	__u64 response;
 	__u32 cq_handle;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
