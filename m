From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_post_send/recv kernel path optimizations
Date: Mon, 27 Dec 2010 15:18:08 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066C547E0@irsmsx503.ger.corp.intel.com>
References: <20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>
	<adahbf6gytv.fsf@cisco.com> <20101124221845.GH2369@obsidianresearch.com>
	<adad3pugi90.fsf@cisco.com> <20101125041337.GA11049@obsidianresearch.com>
	<4CEE7A22.2040706@voltaire.com>
	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
	<4CF60343.7050602@voltaire.com>
	<BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>
 <20101214181735.GA2506@obsidianresearch.com> <4D1888CB.2010101@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D1888CB.2010101-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I don't think this should be such a big problem. The simplest solution
> would be to front the idr_read_qp with a small learning hashing table.

I implemented the very small hash table and I achieved performance comparable to previous solution. 

>I think there should be some validation on the uverbs level, as the caller is untrusted
>user space application, e.g in a similar way for each system call done on a file-descriptor

Such validation is performed during QP creation. When uses has not sufficient privilege the RAW QP is not created.
For me there is no need to make double checking of this capability. When QP is not created it is not in the hash list so there is no possibility to send packets. 

The patch for ofed-1.5.3 looks like below. I will try to push it to kernel.org after porting.

    Now an uverbs  post_send/post_recv path is modified to make pre-lookup
    for RAW_ETH QPs. When a RAW_ETH QP is found the driver specific path
    is used for posting buffers. for example using a shared page approach in
    cooperation with user-space library

Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/uverbs_cmd.c |   94 +++++++++++++++++++++++++++++++++-
 include/rdma/ib_verbs.h              |    4 +
 2 files changed, 95 insertions(+), 3 deletions(-)


diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3520182..234324f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -269,6 +269,54 @@ static void put_xrcd_read(struct ib_uobject *uobj)
 	put_uobj_read(uobj);
 }
 
+#define RAW_QP_HASH(h) ((((h) >> 24) ^ ((h) >> 16) ^ \
+			((h) >> 8) ^ (h)) & (MAX_RAW_QP_HASH - 1))
+
+static void init_raw_qp_hash(struct ib_ucontext *ucontext) {
+	int idx;
+
+	for (idx = 0; idx < MAX_RAW_QP_HASH; idx++)
+		INIT_LIST_HEAD(&ucontext->raw_qp_hash[idx]);
+}
+
+static void raw_qp_hash_add(struct ib_ucontext *ucontext,
+			u32 qp_handle,
+			struct ib_qp *qp)
+{
+	int key;
+
+	if (qp->qp_type != IB_QPT_RAW_ETH)
+		return;
+
+	key = RAW_QP_HASH(qp_handle);
+	list_add(&qp->uobject->raw_qp_list, &ucontext->raw_qp_hash[key]); }
+
+static void raw_qp_hash_del(struct ib_qp *qp) {
+	if (qp->qp_type != IB_QPT_RAW_ETH)
+		return;
+
+	list_del(&qp->uobject->raw_qp_list);
+}
+
+static struct ib_qp *raw_qp_lookup(u32 qp_handle, struct ib_ucontext 
+*ucontext) {
+	int key;
+	struct ib_qp *qp;
+	struct ib_uobject *uobj, *tmp;
+
+	key = RAW_QP_HASH(qp_handle);
+	list_for_each_entry_safe(uobj, tmp,
+				&ucontext->raw_qp_hash[key], raw_qp_list) {
+		qp = uobj->object;
+		if (qp->uobject->id == qp_handle)
+			return qp;
+	}
+	return NULL;
+}
+
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      const char __user *buf,
 			      int in_len, int out_len)
@@ -313,6 +361,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->srq_list);
 	INIT_LIST_HEAD(&ucontext->ah_list);
 	INIT_LIST_HEAD(&ucontext->xrc_domain_list);
+	init_raw_qp_hash(ucontext);
 	ucontext->closing = 0;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors; @@ -1155,6 +1204,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
+	raw_qp_hash_add(file->ucontext, obj->uevent.uobject.id, qp);
 	mutex_unlock(&file->mutex);
 
 	obj->uevent.uobject.live = 1;
@@ -1412,6 +1462,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
+	raw_qp_hash_del(qp);
 	mutex_unlock(&file->mutex);
 
 	ib_uverbs_release_uevent(file, &obj->uevent); @@ -1450,6 +1501,25 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (cmd.wqe_size < sizeof (struct ib_uverbs_send_wr))
 		return -EINVAL;
 
+	mutex_lock(&file->mutex);
+	qp = raw_qp_lookup(cmd.qp_handle, file->ucontext);
+	mutex_unlock(&file->mutex);
+	if (qp) {
+		if (qp->qp_type == IB_QPT_RAW_ETH) {
+			resp.bad_wr = 0;
+			ret = qp->device->post_send(qp, NULL, &bad_wr);
+			if (ret)
+				resp.bad_wr = cmd.wr_count;
+
+			if (copy_to_user((void __user *) (unsigned long)
+					cmd.response,
+					&resp,
+					sizeof resp))
+					ret = -EFAULT;
+					goto out_raw_qp;
+		}
+	}
+
 	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL);
 	if (!user_wr)
 		return -ENOMEM;
@@ -1579,7 +1649,7 @@ out_put:
 
 out:
 	kfree(user_wr);
-
+out_raw_qp:
 	return ret ? ret : in_len;
 }
 
@@ -1664,7 +1734,6 @@ err:
 		kfree(wr);
 		wr = next;
 	}
-
 	return ERR_PTR(ret);
 }
 
@@ -1681,6 +1750,25 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	mutex_lock(&file->mutex);
+	qp = raw_qp_lookup(cmd.qp_handle, file->ucontext);
+	mutex_unlock(&file->mutex);
+	if (qp) {
+		if (qp->qp_type == IB_QPT_RAW_ETH) {
+			resp.bad_wr = 0;
+			ret = qp->device->post_recv(qp, NULL, &bad_wr);
+			if (ret)
+				resp.bad_wr = cmd.wr_count;
+
+			if (copy_to_user((void __user *) (unsigned long)
+					cmd.response,
+					&resp,
+					sizeof resp))
+				ret = -EFAULT;
+			goto out_raw_qp;
+		}
+	}
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size); @@ -1713,7 +1801,7 @@ out:
 		kfree(wr);
 		wr = next;
 	}
-
+out_raw_qp:
 	return ret ? ret : in_len;
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index f5b054a..adf1dd8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -838,6 +838,8 @@ struct ib_fmr_attr {
 	u8	page_shift;
 };
 
+#define MAX_RAW_QP_HASH 8
+
 struct ib_ucontext {
 	struct ib_device       *device;
 	struct list_head	pd_list;
@@ -848,6 +850,7 @@ struct ib_ucontext {
 	struct list_head	srq_list;
 	struct list_head	ah_list;
 	struct list_head	xrc_domain_list;
+	struct list_head	raw_qp_hash[MAX_RAW_QP_HASH];
 	int			closing;
 };
 
@@ -859,6 +862,7 @@ struct ib_uobject {
 	int			id;		/* index into kernel idr */
 	struct kref		ref;
 	struct rw_semaphore	mutex;		/* protects .live */
+	struct list_head        raw_qp_list;    /* raw qp hash */
 	int			live;
 };

Mirek

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
Sent: Monday, December 27, 2010 1:39 PM
To: Jason Gunthorpe; Walukiewicz, Miroslaw
Cc: Roland Dreier; Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: ibv_post_send/recv kernel path optimizations

Jason Gunthorpe wrote:
> Walukiewicz, Miroslaw wrote:

>> called for many QPs, there is a single entry point to
>> ib_uverbs_post_send using write to /dev/infiniband/uverbsX. In that
>> case there is a lookup to QP store (idr_read_qp) necessary to find a
>> correct ibv_qp Structure, what is a big time consumer on the path.

> I don't think this should be such a big problem. The simplest solution
> would be to front the idr_read_qp with a small learning hashing table.

yes, there must be a few ways (e.g as Jason suggested) to do this house-keeping
much more efficient, in a manner that fits fast path - which maybe wasn't the mindset 
when this code was written as its primary use was to invoke control plane commands.

>> The NES IMA kernel path also has such QP lookup but the QP number
>> format is designed to make such lookup very quickly.  The QP numbers in
>> OFED are not defined so generic lookup functions like idr_read_qp() must be use.

> Maybe look at moving the QPN to ibv_qp translation into the driver
> then - or better yet, move allocation out of the driver, if Mellanox
> could change their FW.. You are right that we could do this much
> faster if the QPN was structured in some way

I think there should be some validation on the uverbs level, as the caller is untrusted
user space application, e.g in a similar way for each system call done on a file-descriptor

Or.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
