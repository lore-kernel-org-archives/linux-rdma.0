From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 13/15] IB/uverbs: Tidy uverbs_uobject_add
Date: Tue, 13 Feb 2018 10:20:41 -0700
Message-ID: <20180213172041.GJ4499@mellanox.com>
References: <20180213101841.20101-1-leon@kernel.org>
 <20180213101841.20101-14-leon@kernel.org>
 <c43bec28-0437-961e-fe65-55886973b6da@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c43bec28-0437-961e-fe65-55886973b6da-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 13, 2018 at 12:09:55PM -0500, Dennis Dalessandro wrote:
> On 2/13/2018 5:18 AM, Leon Romanovsky wrote:
> >From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >Maintaining the uobjects list is mandatory, hoist it into the common
> >rdma_alloc_commit_uobject() function and inline it as there is now
> >only one caller.
> >
> >Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >  drivers/infiniband/core/rdma_core.c | 13 ++++---------
> >  1 file changed, 4 insertions(+), 9 deletions(-)
> >
> >diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> >index 7aee1c0b9884..1cb6849b2231 100644
> >+++ b/drivers/infiniband/core/rdma_core.c
> >@@ -350,13 +350,6 @@ struct ib_uobject *rdma_alloc_begin_uobject(const struct uverbs_obj_type *type,
> >  	return type->type_class->alloc_begin(type, ucontext);
> >  }
> >-static void uverbs_uobject_add(struct ib_uobject *uobject)
> >-{
> >-	mutex_lock(&uobject->context->uobjects_lock);
> >-	list_add(&uobject->list, &uobject->context->uobjects);
> >-	mutex_unlock(&uobject->context->uobjects_lock);
> >-}
> >-
> >  static int __must_check remove_commit_idr_uobject(struct ib_uobject *uobj,
> >  						  enum rdma_remove_reason why)
> >  {
> >@@ -501,7 +494,6 @@ int rdma_explicit_destroy(struct ib_uobject *uobject)
> >  static void alloc_commit_idr_uobject(struct ib_uobject *uobj)
> >  {
> >-	uverbs_uobject_add(uobj);
> >  	spin_lock(&uobj->context->ufile->idr_lock);
> >  	/*
> >  	 * We already allocated this IDR with a NULL object, so
> >@@ -517,7 +509,6 @@ static void alloc_commit_fd_uobject(struct ib_uobject *uobj)
> >  	struct ib_uobject_file *uobj_file =
> >  		container_of(uobj, struct ib_uobject_file, uobj);
> >-	uverbs_uobject_add(&uobj_file->uobj);
> >  	fd_install(uobj_file->uobj.id, uobj->object);
> >  	/* This shouldn't be used anymore. Use the file object instead */
> >  	uobj_file->uobj.id = 0;
> >@@ -544,6 +535,10 @@ int rdma_alloc_commit_uobject(struct ib_uobject *uobj)
> >  	assert_uverbs_usecnt(uobj, true);
> >  	atomic_set(&uobj->usecnt, 0);
> >+	mutex_lock(&uobj->context->uobjects_lock);
> >+	list_add(&uobj->list, &uobj->context->uobjects);
> >+	mutex_unlock(&uobj->context->uobjects_lock);
> >+
> >  	uobj->type->type_class->alloc_commit(uobj);
> >  	up_read(&uobj->context->cleanup_rwsem);
> >
> 
> From the subject it sounds like you are doing a cosmetic clean-up, but this
> is doing a bit more.

The behavior is identical before/after.

There are only two implementations of alloc_commit and both of them do
the list_add as the first operation.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
