From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/4] IB/uverbs: Support for associating XRC domains to inodes
Date: Mon, 1 Feb 2010 15:52:24 +0200
Message-ID: <201002011552.24904.jackm@dev.mellanox.co.il>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com> <1264446094-4460-5-git-send-email-rolandd@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1264446094-4460-5-git-send-email-rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Monday 25 January 2010 21:01, Roland Dreier wrote:
> From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> 
> Add support for associating an XRC domain to an inode so that XRC
> domains can be shared between processes.  We keep a per-device RB tree
> of XRCDs (indexed by inode) in the uverbs module, and use struct
> ib_xrcd's usecnt member to reference count XRCDs so that an XRCD is
> not freed until the last process with a reference is done with it.
> 
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

Feedback on the patch set.
I think I have uncovered a couple of bugs in my review (not surprising, since you
most likely could not try out the code).

1. the xrcd refcnt is incremented when creating an xrc qp and xrc srq, but is unconditionally
   decremented in destroy_qp/destroy_srq whether we have an xrcd or not.

2. In closing/deallocating xrc domains, it is not an error if ib_dealloc_xrcd returns "busy".
   This simply means that there are other user processes still using that xrc domain.
   The current process still needs to clean up its uobject.  In particular, the usecnt should
   not be re-incremented on the busy return. (If it gets re-incremented on busy, no one can ever
   succeed in closing an xrc domain if more that one process is using it).

The following patch fixes the above issues I think. (The patch below assumes that
the only error value returned by ib_dealloc_xrcd is "-EBUSY" -- as is the case with pd's.
The mlx4 driver always returns 0 for the deallocate functions).

Please review this and send me your feedback.

Thanks!
-Jack
=========================================================================================
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3db78cb..98c4ded 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1382,6 +1382,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	struct ib_uobject		*uobj;
 	struct ib_qp               	*qp;
 	struct ib_uqp_object        	*obj;
+	struct ib_xrcd			 *xrcd;
 	int                        	 ret = -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -1400,6 +1401,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 		return -EBUSY;
 	}
 
+	xrcd = qp->xrcd;
 	ret = ib_destroy_qp(qp);
 	if (!ret)
 		uobj->live = 0;
@@ -1409,7 +1411,8 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	atomic_dec(&obj->uxrcd->refcnt);
+	if (xrcd)
+		atomic_dec(&obj->uxrcd->refcnt);
 
 	idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
 
@@ -2294,6 +2297,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_uobject		 *uobj;
 	struct ib_srq               	 *srq;
 	struct ib_usrq_object		 *obj;
+	struct ib_xrcd			 *xrcd;
 	int                         	  ret = -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -2305,6 +2309,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	srq = uobj->object;
 	obj = container_of(uobj, struct ib_usrq_object, uevent.uobject);
 
+	xrcd = srq->xrcd;
 	ret = ib_destroy_srq(srq);
 	if (!ret)
 		uobj->live = 0;
@@ -2314,7 +2319,8 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
-	atomic_dec(&obj->uxrcd->refcnt);
+	if (xrcd)
+		atomic_dec(&obj->uxrcd->refcnt);
 
 	idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 
@@ -2604,12 +2610,9 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 
 	live = uobj->live;
 
-	if (inode && ret)
-		atomic_inc(&xrcd->usecnt);
-
 	put_uobj_write(uobj);
 
-	if (ret)
+	if (ret && !inode)
 		goto out;
 
 	if (inode && !live)
@@ -2637,15 +2640,10 @@ void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
 	int ret = 0;
 
 	inode = xrcd->inode;
-	if (inode && !atomic_dec_and_test(&xrcd->usecnt))
-		return;
+	if (inode)
+		atomic_dec(&xrcd->usecnt);
 
 	ret = ib_dealloc_xrcd(xrcd);
-
-	if (inode) {
-		if (!ret)
-			xrcd_table_delete(dev, inode);
-		else
-			atomic_inc(&xrcd->usecnt);
-	}
+	if (!ret && inode)
+		xrcd_table_delete(dev, inode);
 }
=======================================================================
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
