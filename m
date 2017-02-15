From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 6/7] IB/core: Add support for fd objects
Date: Wed, 15 Feb 2017 11:54:48 -0700
Message-ID: <20170215185448.GE19162@obsidianresearch.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-7-git-send-email-matanb@mellanox.com>
 <20170210210350.GE4335@obsidianresearch.com>
 <CAAKD3BDbQVfC06Kzud=j=+a32YFxwcxrqm41SyhL0uWXm0O0Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BDbQVfC06Kzud=j=+a32YFxwcxrqm41SyhL0uWXm0O0Hw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 15, 2017 at 03:48:40PM +0200, Matan Barak wrote:
> >> +static struct ib_uobject *lookup_get_fd_uobject(const struct uverbs_obj_type *type,
> >> +                                             struct ib_ucontext *ucontext,
> >> +                                             int id, bool write)
> >> +{
> >> +     struct file *f;
> >> +     struct ib_uobject *uobject;
> >> +     const struct uverbs_obj_fd_type *fd_type =
> >> +             container_of(type, struct uverbs_obj_fd_type, type);
> >> +
> >> +     if (write)
> >> +             return ERR_PTR(-EOPNOTSUPP);
> >> +
> >> +     f = fget(id);
> >> +     if (!f)
> >> +             return ERR_PTR(-EBADF);
> >> +
> >> +     uobject = f->private_data;
> >> +     if (f->f_op != fd_type->fops ||
> >> +         !uobject->context) {
> >> +             fput(f);
> >> +             return ERR_PTR(-EBADF);
> >> +     }
> >
> > The read of uobject->context needs locking
> >
> 
> All these callbacks are assumed to run when the context is alive.

'uboject->context' is touched outside the SRCU, eg in
uverbs_close_fd() - so it absolutely needs locking.

> The only call we allow the user to execute while this is in process
> is uverbs_close_fd and that's why this is the only call which is
> protected by the cleanup_mutex.

So cleanup_mutex would need to be held during lookup

> >> +static void alloc_commit_fd_uobject(struct ib_uobject *uobj)
> >> +{
> >> +     struct ib_uobject_file *uobj_file =
> >> +             container_of(uobj, struct ib_uobject_file, uobj);
> >> +
> >> +     kref_get(&uobj_file->ufile->ref);
> >
> > Something has gone wrong with the krefs here..
> >
> > kref_get needs to be done for anon_inode_getfile. That kref_get pairs
> > with the put in uverbs_close_fd.
> >
> 
> The code assumes close_fd shall always be called from the release
> function. So, I guess
> alloc_uobj should kref_init and close_fd should be always paired
> with it.

You could make this work, but is is not a great approach. For clarity
a kref should never be shared by two pointers, that provides the
fewest surprises. For instance this is very confusing

uobj = alloc_uobj();   // uobj hold the kref
filp = anon_inode_getfile(); // now another uobj pointer is in filp
[..]
if (err) {
   fput(filp)
   // Oops! Now uobj is toast, but we still have a uobj pointer on our stack!

Make filp totally self-contained and make uobj on the stack totally
self contained with regard to the krefs.

> Something like:
>         mutex_lock(&uobj_file->ufile->cleanup_mutex);
>         if (uobj_file->uobj.context) {
>                 mutex_lock(&uobj_file->uobj.context->uobjects_lock);
>                 list_del(&uobj_file->uobj.list);
>                 mutex_unlock(&uobj_file->uobj.context->uobjects_lock);
>                 uobj_file->uobj.context = NULL;
>         }
>         mutex_unlock(&uobj_file->ufile->cleanup_mutex);
> 
> It removes it from the list and nullify the context that we wouldn't do that
> again in close_fd.
> 
> The cleanup callback runs from the context termination. It actually destroys
> the real object (or marks it as closed in the fd case).

Maybe, I'd have to see this to comment I think.. But this locking is
looking nasty

> > We had lots of problems with this sort of scheme in the hotplug
> > series, is this OK like this? Feels potentially dangerous..
> >
> > I feel like we need a rwsem for cleanup. Write lock the rwsem above
> > which will inhibit changes to the list and have all the remove paths
> > try_read the rwsem and if that fails then skip removing from the list
> > and doing the destroy because we know uverbs_cleanup_ucontext is
> > running and will do both.
> >
> > That sounds like a much more self-contained and clearer mechanism
> > compared to where we are today.

I think you should try something like this:

void add_object_to_cleanup(struct ib_uobject *uobj)
{
    // Cleanup is running. Calling this should have been impossible
    if (!down_read_trylock(&ucontext->cleanup_rwsem)) {
       WARN();
       return;
    }
    
    mutex_lock(&icontext->uobjects_lock);
    // kref is held while the object is on the list
    get_uobj(uobj);
    list_add(&uobj->list, &ucontext->uobjects);
    mutex_unlock(&iucontext->uobjects_lock);

    up_read(&ucontext->cleanup_rwsem);
}

/* For an object on the cleanup list, remove it from the list and
   call the remove function. This is either done immediately
   or defered to an ongoing cleanup. Caller must hold a kref on uobj */
void destory_object_from_cleanup(struct ib_uobject *uobj,
                                 enum rdma_remove_reason why)
{
    // Cleanup is running, the object will be destroyed by the cleanup.
    if (!down_read_trylock(&ucontext->cleanup_rwsem))
       return;

    // Remove it from the list
    mutex_lock(&ucontext->uobjects_lock);
    list_del(&uobj->list);
    uobj->context = NULL;
    put_uobj(uobj);
    mutex_unlock(&ucontext->uobjects_lock);

    [..]->remove(uobj, why);

    up_read(&ucontext->cleanup_rwsem);
}

void cleanup()
{
    /* Claim ownership of the context list. Every add attempt will
       fail and every remove attempt will defer to this loop */
    down_write(&ucontext->cleanup_rwsem);

    /* Note all uobjects_lock's are nested inside cleanup_rwsem, by
       holding the write side we prove we have exclusive list access */
    
    for_each_safe(uobj) {
        [..]->remove(uobj, why);
        put_uobj(uobj);
    }

    // rwsem remains held forever, uncontext is going to be destroyed
}

void uverbs_close_fd(struct file *f)
{
   destroy_object_from_cleanup(uobj);
   put_uobj(uobj);
}

> >> +     if (uobj_file->uobj.context) {
> >> +             mutex_lock(&uobj_file->uobj.context->lock);
> >> +             list_del(&uobj_file->uobj.list);
> >> +             mutex_unlock(&uobj_file->uobj.context->lock);
> >
> > Again, I don't like this. If we remove something from the list then it
> > should go through the whole destruction cycle. Why do we skip
> > is_closed=1 on this path, for instance? Seems wrong.
> >
> 
> An object could be destroyed in two ways:
> a. handler + remove_commit
> b. context cleanup

Again, this doesn't really make sense and is just going to cause bugs

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
