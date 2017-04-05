From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 for-next 2/7] IB/core: Add support for idr types
Date: Wed, 5 Apr 2017 09:50:52 -0600
Message-ID: <20170405155052.GA11251@obsidianresearch.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
 <1491301907-32290-3-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB10F5A5@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BD=dM8B+bnGu_DTR220wWeo2ce2Sgoy1WwBpUYs6XHoQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BD=dM8B+bnGu_DTR220wWeo2ce2Sgoy1WwBpUYs6XHoQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 05, 2017 at 01:55:22PM +0300, Matan Barak wrote:
> >> +struct ib_uobject *rdma_lookup_get_uobject(const struct
> >> uverbs_obj_type *type,
> >> +                                        struct ib_ucontext *ucontext,
> >> +                                        int id, bool write)
> >> +{
> >> +     struct ib_uobject *uobj;
> >> +     int ret;
> >> +
> >> +     uobj = type->type_class->lookup_get(type, ucontext, id, write);
> >> +     if (IS_ERR(uobj))
> >> +             return uobj;
> >> +
> >> +     if (uobj->type != type) {
> >> +             ret = -EINVAL;
> >> +             goto free;
> >> +     }
> >> +
> >> +     ret = uverbs_try_lock_object(uobj, write);
> >> +     if (ret) {
> >> +             WARN(ucontext->cleanup_reason,
> >> +                  "ib_uverbs: Trying to lookup_get while cleanup
> >> context\n");
> >> +             goto free;
> >> +     }
> >> +
> >> +     return uobj;
> >> +free:
> >> +     uobj->type->type_class->lookup_put(uobj, write);
> >> +     uverbs_uobject_put(uobj);
> >
> > There's an unexpected asymmetry here.  lookup_get is pairing with lookup_put + uobject_put.
> >
> 
> lookup_get also calls uverbs_uobject_get. It's done in the idr/fd's
> callback, as sometimes we need to wrap it in rcu (or some other
> equivalent mechanism). In the previous version, it was more
> symmetrical but Jason suggested simplicity over symmetry and I think
> it looks better this way.

The real problem here is that we have 'rdma_lookup_put' and
'uvbers_uobject_put' with very similar names which is very confusing.

Do we really need to have lookup_put at all? This is only to hold on
to the 'struct file *' across the lookup, which doesn't seem
important.

I suspect we can simplify this by eliminating the implicit fget held
by lookup_get and instead use an accessor to access the 'struct file
*' in the few places that need to do that:

  struct file *uverbs_get_file(struct ib_uobject *object)

We don't really care about the ordering here, if a caller does

 uobj = rdma_lookup_get_uobject(...);
 filp = uverbs_get_file(uobj);
 fput(filep);
 uverbs_uobject_put(uobj);

And filp is NULL because it raced with close(), we can cope with it
just fine.

With this approach we could get rid of the confusing rdma_lookup_put
entirely.

> >> +      */
> >> +     struct ib_uobject *(*alloc_begin)(const struct uverbs_obj_type
> >> *type,
> >> +                                       struct ib_ucontext *ucontext);
> >> +     void (*alloc_commit)(struct ib_uobject *uobj);
> >> +     void (*alloc_abort)(struct ib_uobject *uobj);
> >> +
> >> +     struct ib_uobject *(*lookup_get)(const struct uverbs_obj_type
> >> *type,
> >> +                                      struct ib_ucontext *ucontext, int id,
> >> +                                      bool write);
> >> +     void (*lookup_put)(struct ib_uobject *uobj, bool write);
> >
> > Rather than passing in a write/exclusive flag to a bunch of different calls, why not just have separate calls?  E.g. get_shared/put_shared, get_excl/put_excl?
> >
> 
> Actually, there are only two functions which get "exclusive" flag.
> That's the lookup_get and lookup_put.
> Currently, in respect of idr/fd class types, this flag only used by fd
> in order to forbid exclusive access.

Why doesn't uverbs_try_lock_object work with FDs? I understand that we
don't use it right now, but that doesn't seem to explain why we
couldn't.

try_lock_object for a FD could hold the flip and the refcount?

> I don't think that qualifies another set of _excel and _shared
> callbacks. Maybe, instead of having these callbacks,
> we could add .allow_exclusive flag on the type itself.

Yes, that is nicer if we need this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
