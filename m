From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 for-next 6/7] IB/core: Add support for fd objects
Date: Wed, 15 Feb 2017 15:48:40 +0200
Message-ID: <CAAKD3BDbQVfC06Kzud=j=+a32YFxwcxrqm41SyhL0uWXm0O0Hw@mail.gmail.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-7-git-send-email-matanb@mellanox.com> <20170210210350.GE4335@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210210350.GE4335-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 10, 2017 at 11:03 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Feb 01, 2017 at 02:39:04PM +0200, Matan Barak wrote:
>> The completion channel we use in verbs infrastructure is FD based.
>> Previously, we had a separate way to manage this object. Since we
>> strive for a single way to manage any kind of object in this
>> infrastructure, we conceptually treat all objects as subclasses
>> of ib_uobject.
>>
>> This commit adds the necessary mechanism to support FD based objects
>> like their IDR counterparts. FD objects release need to be synchronized
>> with context release. We use the cleanup_mutex on the uverbs_file for
>> that.
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>  drivers/infiniband/core/rdma_core.c   | 157 +++++++++++++++++++++++++++++++++-
>>  drivers/infiniband/core/rdma_core.h   |   7 ++
>>  drivers/infiniband/core/uverbs.h      |   1 +
>>  drivers/infiniband/core/uverbs_main.c |   4 +-
>>  include/rdma/ib_verbs.h               |   6 ++
>>  include/rdma/uverbs_types.h           |  16 ++++
>>  6 files changed, 189 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
>> index 7ce4d67..1d24f26 100644
>> +++ b/drivers/infiniband/core/rdma_core.c
>> @@ -160,6 +160,73 @@ static void uverbs_uobject_add(struct ib_uobject *uobject)
>>       mutex_unlock(&uobject->context->lock);
>>  }
>>
>> +static struct ib_uobject *alloc_begin_fd_uobject(const struct uverbs_obj_type *type,
>> +                                              struct ib_ucontext *ucontext)
>> +{
>> +     const struct uverbs_obj_fd_type *fd_type =
>> +             container_of(type, struct uverbs_obj_fd_type, type);
>> +     int new_fd;
>> +     struct ib_uobject_file *uobj_file = NULL;
>> +     struct file *filp;
>> +
>> +     new_fd = get_unused_fd_flags(O_CLOEXEC);
>> +     if (new_fd < 0)
>> +             return ERR_PTR(new_fd);
>> +
>> +     uobj_file = kmalloc(fd_type->obj_size, GFP_KERNEL);
>> +     if (!uobj_file) {
>> +             put_unused_fd(new_fd);
>> +             return ERR_PTR(-ENOMEM);
>> +     }
>
> Move to alloc_uobj, see prior patches
>

Ok

>> +static struct ib_uobject *lookup_get_fd_uobject(const struct uverbs_obj_type *type,
>> +                                             struct ib_ucontext *ucontext,
>> +                                             int id, bool write)
>> +{
>> +     struct file *f;
>> +     struct ib_uobject *uobject;
>> +     const struct uverbs_obj_fd_type *fd_type =
>> +             container_of(type, struct uverbs_obj_fd_type, type);
>> +
>> +     if (write)
>> +             return ERR_PTR(-EOPNOTSUPP);
>> +
>> +     f = fget(id);
>> +     if (!f)
>> +             return ERR_PTR(-EBADF);
>> +
>> +     uobject = f->private_data;
>> +     if (f->f_op != fd_type->fops ||
>> +         !uobject->context) {
>> +             fput(f);
>> +             return ERR_PTR(-EBADF);
>> +     }
>
> The read of uobject->context needs locking
>

All these callbacks are assumed to run when the context is alive.
Some upper synchronization mechanism (SRCU) should take care of not calling
uverbs_cleanup_ucontext while executing some other action on a uobject.
The only call we allow the user to execute while this is in process is
uverbs_close_fd and that's
why this is the only call which is protected by the cleanup_mutex.
close_fd is called from the file's release function. This could happen
in two cases - either the object
wasn't exposed to user-space and then commit_abort does the last fput
or the user-space closes the
file. In the first case, nobody should use the fd object as it wasn't
committed yet.
In the second case, fget and __close_fd should protect us.

>> +static void alloc_commit_fd_uobject(struct ib_uobject *uobj)
>> +{
>> +     struct ib_uobject_file *uobj_file =
>> +             container_of(uobj, struct ib_uobject_file, uobj);
>> +
>> +     kref_get(&uobj_file->ufile->ref);
>
> Something has gone wrong with the krefs here..
>
> kref_get needs to be done for anon_inode_getfile. That kref_get pairs
> with the put in uverbs_close_fd.
>

The code assumes close_fd shall always be called from the release
function. So, I guess
alloc_uobj should kref_init and close_fd should be always paired with it.
You could reach close_fd either from alloc_abort, close system call or
some external kernel code
calling fput (with file_get that was called before. In this case
lookup_get isn't valid anymore).

>> +     uverbs_uobject_add(&uobj_file->uobj);
>> +     fd_install(uobj_file->uobj.id, uobj->object);
>> +     /* This shouldn't be used anymore. Use the file object instead */
>> +     uobj_file->uobj.id = 0;
>
> Needs a put to pair with the kref_get done by alloc_uobj.
>
>> +static void alloc_abort_fd_uobject(struct ib_uobject *uobj)
>> +{
>> +     struct ib_uobject_file *uobj_file =
>> +             container_of(uobj, struct ib_uobject_file, uobj);
>> +     struct file *filp = uobj->object;
>> +
>> +     /* Unsuccessful NEW */
>> +     fput(filp);
>> +     put_unused_fd(uobj_file->uobj.id);
>
> And here is the bug that fixes: since fput(filp) will call
> uverbs_close_fd it just put the last kref and free'd the struct.
>

We could either remove uverbs_uobject_put call.

>> +static void destroy_commit_null_uobject(struct ib_uobject *uobj)
>> +{
>> +     WARN_ON(true);
>> +}
>
> So in the model I suggest this would be remove and the purpose is to
> disconnect the driver and leave the FD 'detached'.
>

As stated in the previous patch, remove_commit (the new name) is
entirely different
than cleanup. This just removes the object from the objects list and
decrease its
reference count.
I guess if we want to enable that for fds too, we need some lighter
version of uverbs_close_fd:

Something like:
        mutex_lock(&uobj_file->ufile->cleanup_mutex);
        if (uobj_file->uobj.context) {
                mutex_lock(&uobj_file->uobj.context->uobjects_lock);
                list_del(&uobj_file->uobj.list);
                mutex_unlock(&uobj_file->uobj.context->uobjects_lock);
                uobj_file->uobj.context = NULL;
        }
        mutex_unlock(&uobj_file->ufile->cleanup_mutex);

It removes it from the list and nullify the context that we wouldn't do that
again in close_fd.

The cleanup callback runs from the context termination. It actually destroys
the real object (or marks it as closed in the fd case).

>> +
>>  const struct uverbs_obj_type_ops uverbs_idr_ops = {
>>       .alloc_begin = alloc_begin_idr_uobject,
>>       .lookup_get = lookup_get_idr_uobject,
>> @@ -254,8 +363,15 @@ void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
>>
>>               /*
>>                * This shouldn't run while executing other commands on this
>> -              * context, thus no lock is required.
>> +              * context. Thus, the only thing we should take care of is
>> +              * releasing a FD while traversing this list. The FD could be
>> +              * closed and released from the _release fop of this FD.
>> +              * In order to mitigate this, we add a lock.
>> +              * We take and release the lock per order traversal in order
>> +              * to let other threads (which might still use the FDs) chance
>> +              * to run.
>>                */
>> +             mutex_lock(&ucontext->lock);
>
> I think you may as well move this lock to patch 2, reads better that way.
>

Ok

>>               list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
>>                                        list)
>>                       if (obj->type->destroy_order == cur_order) {
>> @@ -265,6 +381,7 @@ void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
>>                               next_order = min(next_order,
>>                                                obj->type->destroy_order);
>>                       }
>> +             mutex_unlock(&ucontext->lock);
>
> We had lots of problems with this sort of scheme in the hotplug
> series, is this OK like this? Feels potentially dangerous..
>
> I feel like we need a rwsem for cleanup. Write lock the rwsem above
> which will inhibit changes to the list and have all the remove paths
> try_read the rwsem and if that fails then skip removing from the list
> and doing the destroy because we know uverbs_cleanup_ucontext is
> running and will do both.
>
> That sounds like a much more self-contained and clearer mechanism
> compared to where we are today.
>

We use SRCU to make sure all handlers are completed and no new handlers
could be executed. This means we're safe (I'll add WARN_ON to be sure).
We could only race with closing fd objects and this is handled with
the cleanup_mutex.
If we run handlers and context cleanup at the same time, we could end
up with double
cleanups of the objects themselves (without additional locks of course).

>> +void uverbs_close_fd(struct file *f)
>> +{
>> +     struct ib_uobject_file *uobj_file = f->private_data;
>> +
>> +     mutex_lock(&uobj_file->ufile->cleanup_mutex);
>
> I don't get what cleanup_mutex is doing. Nothing in here seems like it
> needs that lock...
>

cleanup_mutex protects a race when the context is cleaned up and
uverbs_close_fd is called. They both tries to alter the uobjects list,
so they need the lock on the context. The problem here is that the
context might be released and its pointer could be nullified.
It could be even nullified after the "if (uobj_file->uobj.context) "
statement. In order to solve that, the cleanup_context delays
"file->ucontext = NULL;" and thus makes this safe.


>> +     if (uobj_file->uobj.context) {
>> +             mutex_lock(&uobj_file->uobj.context->lock);
>> +             list_del(&uobj_file->uobj.list);
>> +             mutex_unlock(&uobj_file->uobj.context->lock);
>
> Again, I don't like this. If we remove something from the list then it
> should go through the whole destruction cycle. Why do we skip
> is_closed=1 on this path, for instance? Seems wrong.
>

An object could be destroyed in two ways:
a. handler + remove_commit
b. context cleanup

is_closed = 1 is part of the free function of the completion channel objects.
This series only refactors how these objects are managed and tries hard
not to change the internal implementation there.

> Jason

Thanks for the review

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
