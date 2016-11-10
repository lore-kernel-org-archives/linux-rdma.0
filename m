From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V5 02/10] RDMA/core: Add support for custom types
Date: Thu, 10 Nov 2016 10:29:13 +0200
Message-ID: <d0f0960d-f53e-9bff-7e72-cbb5e3ef200f@mellanox.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-3-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0A47BD@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BDWyb10baLrDu=m_mYPB64i9OOPEPVYKtDo9zVbvMM-UA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0A8000@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0A8000-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/11/2016 20:00, Hefty, Sean wrote:
>> I had thought about that, but the user could initialize its part of
>> the object in the function handler. It can't allocate the object as we
>> need it in order to allocate an IDR entry and co. The assumption here
>> is that the "unlock" stage can't fail.
>
> This is creating a generic OO type of framework, so just add constructor/destructor functions and have all objects inherit from a base ioctl object class.
>

Adding a constructor and destructor to every object would make the 
infrastructure slower, it'll open code the locks (which are more related 
to the actions themselves and not to the types), it'll duplicate more 
code. Anyway, examining our use, I don't really see good value for ctors 
and dtors for our usage right now.

>>> In fact, it would be great if we could just cleanup the list in the
>> reverse order that items were created.  Maybe this requires supporting
>> a pre-cleanup handler, so that the driver can pluck items out of the
>> list that may need to be destroyed out of order.
>>>
>>
>> So that's essentially one layer of ordering. Why do you consider a
>> driver iterating over all objects simpler than this model?
>
> This problem is a verbs specific issue, and one that only involves MW .  We have reference counts that can provide the same functionality.  I want to avoid the amount of meta-data that needs to be used to describe objects.
>

It's currently happens in the verbs MW/MRs. However, it could happen 
with any types whose bindings happen in the user-space or hardware.

>>>> Adding an object is done in two parts.
>>>> First, an object is allocated and added to IDR/fd table. Then, the
>>>> command's handlers (in downstream patches) could work on this object
>>>> and fill in its required details.
>>>> After a successful command, ib_uverbs_uobject_enable is called and
>>>> this user objects becomes ucontext visible.
>>>
>>> If you have a way to mark that an object is used for exclusive
>> access, you may be able to use that instead of introducing a new
>> variable.  (I.e. acquire the object's write lock).  I think we want to
>> make an effort to minimize the size of the kernel structure needed to
>> track every user space object (within reason).
>>>
>>
>> I didn't really follow. A command attribute states the nature of the
>> locking (for example, in MODIFY_QP the QP could be exclusively locked,
>> but in QUERY_QP it's only locked for reading). I don't want to really
>> grab a lock, as if I were I could face a dead-lock (user-space could
>> pass parameters in a colliding order), It could be solved by sorting
>> the handles, but that would degrade performance without a good reasob.
>
> I'm suggesting that the locking attribute and command be separate.  This allows the framework to acquire the proper type of lock independent of what function it will invoke.
>

The locking is tied to what you want to do on that type. If you query 
something, read locks are probably enough. I don't think separating them 
will make the code more readable.

> The framework doesn't need to hold locks.  It should be able to mark access to an object.  If that access is not available, it can abort.  This pushes more complex synchronization and thread handling to user space.
>

The try_{read,write} locks achieve exactly that and are simple enough.

>>>> Removing an uboject is done by calling ib_uverbs_uobject_remove.
>>>>
>>>> We should make sure IDR (per-device) and list (per-ucontext) could
>>>> be accessed concurrently without corrupting them.
>>>>
>>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>
>>> As a general comment, I do have concerns that the resulting
>> generalized parsing of everything will negatively impact performance
>> for operations that do have to transition into the kernel.  Not all
>> devices offload all operations to user space.  Plus the resulting code
>> is extremely difficult to read and non-trivial to use.  It's equivalent
>> to reading C++ code that has 4 layers of inheritance with overrides to
>> basic operators...
>>
>> There are two parts here. I think the handlers themselves are simpler,
>> easier to read and less error-prone. They contain less code
>> duplications. The macro based define language explicitly declare all
>> attributes, their types, size, etc.
>> The model here is a bit more complex as we want to achieve both code
>> resue and add/override of new types/actions/attributes.
>>
>>
>>>
>>> Pre and post operators per command that can do straightforward
>> validation seem like a better option.
>>>
>>>
>>
>> I think that would duplicate a lot of code and will be more
>> error-prone than one infrastrucutre that automates all that work for
>> you.
>
> I think that's a toss-up.  Either you have to write the code correctly or write the rules correctly.  Reading code is straightforward, manually converting rules into code is not.
>
> In any case, the two approaches are not exclusive.  By forcing the rule language into the framework, everything is forced to deal with it.  By leaving it out, each ioctl provider can decide if they need this or not.  If you want verbs to process all ioctl's using a single pre-validation function that operates based on these rules you can.  Nothing prevents that.  But ioctl providers that want better performance can elect for a more straightforward validation model.
>

Please see Jason's response.

>>>>  drivers/infiniband/core/Makefile      |   3 +-
>>>>  drivers/infiniband/core/device.c      |   1 +
>>>>  drivers/infiniband/core/rdma_core.c   | 489
>>>> ++++++++++++++++++++++++++++++++++
>>>>  drivers/infiniband/core/rdma_core.h   |  75 ++++++
>>>>  drivers/infiniband/core/uverbs.h      |   1 +
>>>>  drivers/infiniband/core/uverbs_main.c |   2 +-
>>>>  include/rdma/ib_verbs.h               |  28 +-
>>>>  include/rdma/uverbs_ioctl.h           | 195 ++++++++++++++
>>>>  8 files changed, 789 insertions(+), 5 deletions(-)
>>>>  create mode 100644 drivers/infiniband/core/rdma_core.c
>>>>  create mode 100644 drivers/infiniband/core/rdma_core.h
>>>>  create mode 100644 include/rdma/uverbs_ioctl.h
>>>>
>>>> diff --git a/drivers/infiniband/core/Makefile
>>>> b/drivers/infiniband/core/Makefile
>>>> index edaae9f..1819623 100644
>>>> --- a/drivers/infiniband/core/Makefile
>>>> +++ b/drivers/infiniband/core/Makefile
>>>> @@ -28,4 +28,5 @@ ib_umad-y :=                        user_mad.o
>>>>
>>>>  ib_ucm-y :=                  ucm.o
>>>>
>>>> -ib_uverbs-y :=                       uverbs_main.o uverbs_cmd.o
>>>> uverbs_marshall.o
>>>> +ib_uverbs-y :=                       uverbs_main.o uverbs_cmd.o
>>>> uverbs_marshall.o \
>>>> +                             rdma_core.o
>>>> diff --git a/drivers/infiniband/core/device.c
>>>> b/drivers/infiniband/core/device.c
>>>> index c3b68f5..43994b1 100644
>>>> --- a/drivers/infiniband/core/device.c
>>>> +++ b/drivers/infiniband/core/device.c
>>>> @@ -243,6 +243,7 @@ struct ib_device *ib_alloc_device(size_t size)
>>>>       spin_lock_init(&device->client_data_lock);
>>>>       INIT_LIST_HEAD(&device->client_data_list);
>>>>       INIT_LIST_HEAD(&device->port_list);
>>>> +     INIT_LIST_HEAD(&device->type_list);
>>>>
>>>>       return device;
>>>>  }
>>>> diff --git a/drivers/infiniband/core/rdma_core.c
>>>> b/drivers/infiniband/core/rdma_core.c
>>>> new file mode 100644
>>>> index 0000000..337abc2
>>>> --- /dev/null
>>>> +++ b/drivers/infiniband/core/rdma_core.c
>>>> @@ -0,0 +1,489 @@
>>>> +/*
>>>> + * Copyright (c) 2016, Mellanox Technologies inc.  All rights
>>>> reserved.
>>>> + *
>>>> + * This software is available to you under a choice of one of two
>>>> + * licenses.  You may choose to be licensed under the terms of the
>> GNU
>>>> + * General Public License (GPL) Version 2, available from the file
>>>> + * COPYING in the main directory of this source tree, or the
>>>> + * OpenIB.org BSD license below:
>>>> + *
>>>> + *     Redistribution and use in source and binary forms, with or
>>>> + *     without modification, are permitted provided that the
>> following
>>>> + *     conditions are met:
>>>> + *
>>>> + *      - Redistributions of source code must retain the above
>>>> + *        copyright notice, this list of conditions and the
>> following
>>>> + *        disclaimer.
>>>> + *
>>>> + *      - Redistributions in binary form must reproduce the above
>>>> + *        copyright notice, this list of conditions and the
>> following
>>>> + *        disclaimer in the documentation and/or other materials
>>>> + *        provided with the distribution.
>>>> + *
>>>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>>>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
>> OF
>>>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>>>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
>> HOLDERS
>>>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
>> AN
>>>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
>> IN
>>>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>>>> + * SOFTWARE.
>>>> + */
>>>> +
>>>> +#include <linux/file.h>
>>>> +#include <linux/anon_inodes.h>
>>>> +#include <rdma/ib_verbs.h>
>>>> +#include "uverbs.h"
>>>> +#include "rdma_core.h"
>>>> +#include <rdma/uverbs_ioctl.h>
>>>> +
>>>> +const struct uverbs_type *uverbs_get_type(const struct ib_device
>>>> *ibdev,
>>>> +                                       uint16_t type)
>>>> +{
>>>> +     const struct uverbs_types_group *groups = ibdev->types_group;
>>>> +     const struct uverbs_types *types;
>>>> +     int ret = groups->dist(&type, groups->priv);
>>>> +
>>>> +     if (ret >= groups->num_groups)
>>>> +             return NULL;
>>>> +
>>>> +     types = groups->type_groups[ret];
>>>> +
>>>> +     if (type >= types->num_types)
>>>> +             return NULL;
>>>> +
>>>> +     return types->types[type];
>>>> +}
>>>> +
>>>> +static int uverbs_lock_object(struct ib_uobject *uobj,
>>>> +                           enum uverbs_idr_access access)
>>>> +{
>>>> +     if (access == UVERBS_IDR_ACCESS_READ)
>>>> +             return down_read_trylock(&uobj->usecnt) == 1 ? 0 : -
>> EBUSY;
>>>> +
>>>> +     /* lock is either WRITE or DESTROY - should be exclusive */
>>>> +     return down_write_trylock(&uobj->usecnt) == 1 ? 0 : -EBUSY;
>>>
>>> This function could take the lock type directly (read or write),
>> versus inferring it based on some other access type.
>>>
>>
>> We can, but since we use these enums in the attribute specifications,
>> I thought it could be more convinient.
>>
>>>> +}
>>>> +
>>>> +static struct ib_uobject *get_uobj(int id, struct ib_ucontext
>>>> *context)
>>>> +{
>>>> +     struct ib_uobject *uobj;
>>>> +
>>>> +     rcu_read_lock();
>>>> +     uobj = idr_find(&context->device->idr, id);
>>>> +     if (uobj && uobj->live) {
>>>> +             if (uobj->context != context)
>>>> +                     uobj = NULL;
>>>> +     }
>>>> +     rcu_read_unlock();
>>>> +
>>>> +     return uobj;
>>>> +}
>>>> +
>>>> +struct ib_ucontext_lock {
>>>> +     struct kref  ref;
>>>> +     /* locking the uobjects_list */
>>>> +     struct mutex lock;
>>>> +};
>>>> +
>>>> +static void init_uobjects_list_lock(struct ib_ucontext_lock *lock)
>>>> +{
>>>> +     mutex_init(&lock->lock);
>>>> +     kref_init(&lock->ref);
>>>> +}
>>>> +
>>>> +static void release_uobjects_list_lock(struct kref *ref)
>>>> +{
>>>> +     struct ib_ucontext_lock *lock = container_of(ref,
>>>> +                                                  struct
>> ib_ucontext_lock,
>>>> +                                                  ref);
>>>> +
>>>> +     kfree(lock);
>>>> +}
>>>> +
>>>> +static void init_uobj(struct ib_uobject *uobj, u64 user_handle,
>>>> +                   struct ib_ucontext *context)
>>>> +{
>>>> +     init_rwsem(&uobj->usecnt);
>>>> +     uobj->user_handle = user_handle;
>>>> +     uobj->context     = context;
>>>> +     uobj->live        = 0;
>>>> +}
>>>> +
>>>> +static int add_uobj(struct ib_uobject *uobj)
>>>> +{
>>>> +     int ret;
>>>> +
>>>> +     idr_preload(GFP_KERNEL);
>>>> +     spin_lock(&uobj->context->device->idr_lock);
>>>> +
>>>> +     ret = idr_alloc(&uobj->context->device->idr, uobj, 0, 0,
>>>> GFP_NOWAIT);
>>>> +     if (ret >= 0)
>>>> +             uobj->id = ret;
>>>> +
>>>> +     spin_unlock(&uobj->context->device->idr_lock);
>>>> +     idr_preload_end();
>>>> +
>>>> +     return ret < 0 ? ret : 0;
>>>> +}
>>>> +
>>>> +static void remove_uobj(struct ib_uobject *uobj)
>>>> +{
>>>> +     spin_lock(&uobj->context->device->idr_lock);
>>>> +     idr_remove(&uobj->context->device->idr, uobj->id);
>>>> +     spin_unlock(&uobj->context->device->idr_lock);
>>>> +}
>>>> +
>>>> +static void put_uobj(struct ib_uobject *uobj)
>>>> +{
>>>> +     kfree_rcu(uobj, rcu);
>>>> +}
>>>> +
>>>> +static struct ib_uobject *get_uobject_from_context(struct
>> ib_ucontext
>>>> *ucontext,
>>>> +                                                const struct
>>>> uverbs_type_alloc_action *type,
>>>> +                                                u32 idr,
>>>> +                                                enum
>> uverbs_idr_access access)
>>>> +{
>>>> +     struct ib_uobject *uobj;
>>>> +     int ret;
>>>> +
>>>> +     rcu_read_lock();
>>>> +     uobj = get_uobj(idr, ucontext);
>>>> +     if (!uobj)
>>>> +             goto free;
>>>> +
>>>> +     if (uobj->type != type) {
>>>> +             uobj = NULL;
>>>> +             goto free;
>>>> +     }
>>>> +
>>>> +     ret = uverbs_lock_object(uobj, access);
>>>> +     if (ret)
>>>> +             uobj = ERR_PTR(ret);
>>>> +free:
>>>> +     rcu_read_unlock();
>>>> +     return uobj;
>>>> +
>>>> +     return NULL;
>>>> +}
>>>> +
>>>> +static int ib_uverbs_uobject_add(struct ib_uobject *uobject,
>>>> +                              const struct uverbs_type_alloc_action
>>>> *uobject_type)
>>>> +{
>>>> +     uobject->type = uobject_type;
>>>> +     return add_uobj(uobject);
>>>> +}
>>>> +
>>>> +struct ib_uobject *uverbs_get_type_from_idr(const struct
>>>> uverbs_type_alloc_action *type,
>>>> +                                         struct ib_ucontext
>> *ucontext,
>>>> +                                         enum uverbs_idr_access
>> access,
>>>> +                                         uint32_t idr)
>>>> +{
>>>> +     struct ib_uobject *uobj;
>>>> +     int ret;
>>>> +
>>>> +     if (access == UVERBS_IDR_ACCESS_NEW) {
>>>> +             uobj = kmalloc(type->obj_size, GFP_KERNEL);
>>>> +             if (!uobj)
>>>> +                     return ERR_PTR(-ENOMEM);
>>>> +
>>>> +             init_uobj(uobj, 0, ucontext);
>>>> +
>>>> +             /* lock idr */
>>>
>>> Command to lock idr, but no lock is obtained.
>>>
>>
>> ib_uverbs_uobject_add calls add_uobj which locks the IDR.
>>
>>>> +             ret = ib_uverbs_uobject_add(uobj, type);
>>>> +             if (ret) {
>>>> +                     kfree(uobj);
>>>> +                     return ERR_PTR(ret);
>>>> +             }
>>>> +
>>>> +     } else {
>>>> +             uobj = get_uobject_from_context(ucontext, type, idr,
>>>> +                                             access);
>>>> +
>>>> +             if (!uobj)
>>>> +                     return ERR_PTR(-ENOENT);
>>>> +     }
>>>> +
>>>> +     return uobj;
>>>> +}
>>>> +
>>>> +struct ib_uobject *uverbs_get_type_from_fd(const struct
>>>> uverbs_type_alloc_action *type,
>>>> +                                        struct ib_ucontext
>> *ucontext,
>>>> +                                        enum uverbs_idr_access
>> access,
>>>> +                                        int fd)
>>>> +{
>>>> +     if (access == UVERBS_IDR_ACCESS_NEW) {
>>>> +             int _fd;
>>>> +             struct ib_uobject *uobj = NULL;
>>>> +             struct file *filp;
>>>> +
>>>> +             _fd = get_unused_fd_flags(O_CLOEXEC);
>>>> +             if (_fd < 0 || WARN_ON(type->obj_size < sizeof(struct
>>>> ib_uobject)))
>>>> +                     return ERR_PTR(_fd);
>>>> +
>>>> +             uobj = kmalloc(type->obj_size, GFP_KERNEL);
>>>> +             init_uobj(uobj, 0, ucontext);
>>>> +
>>>> +             if (!uobj)
>>>> +                     return ERR_PTR(-ENOMEM);
>>>> +
>>>> +             filp = anon_inode_getfile(type->fd.name, type-
>>> fd.fops,
>>>> +                                       uobj + 1, type->fd.flags);
>>>> +             if (IS_ERR(filp)) {
>>>> +                     put_unused_fd(_fd);
>>>> +                     kfree(uobj);
>>>> +                     return (void *)filp;
>>>> +             }
>>>> +
>>>> +             uobj->type = type;
>>>> +             uobj->id = _fd;
>>>> +             uobj->object = filp;
>>>> +
>>>> +             return uobj;
>>>> +     } else if (access == UVERBS_IDR_ACCESS_READ) {
>>>> +             struct file *f = fget(fd);
>>>> +             struct ib_uobject *uobject;
>>>> +
>>>> +             if (!f)
>>>> +                     return ERR_PTR(-EBADF);
>>>> +
>>>> +             uobject = f->private_data - sizeof(struct ib_uobject);
>>>> +             if (f->f_op != type->fd.fops ||
>>>> +                 !uobject->live) {
>>>> +                     fput(f);
>>>> +                     return ERR_PTR(-EBADF);
>>>> +             }
>>>> +
>>>> +             /*
>>>> +              * No need to protect it with a ref count, as fget
>>>> increases
>>>> +              * f_count.
>>>> +              */
>>>> +             return uobject;
>>>> +     } else {
>>>> +             return ERR_PTR(-EOPNOTSUPP);
>>>> +     }
>>>> +}
>>>> +
>>>> +static void ib_uverbs_uobject_enable(struct ib_uobject *uobject)
>>>> +{
>>>> +     mutex_lock(&uobject->context->uobjects_lock->lock);
>>>> +     list_add(&uobject->list, &uobject->context->uobjects);
>>>> +     mutex_unlock(&uobject->context->uobjects_lock->lock);
>>>
>>> Why not just insert the object into the list on creation?
>>>
>>>> +     uobject->live = 1;
>>>
>>> See my comments above on removing the live field.
>>>
>>
>> Seems that the list could suffice, but I'll look into that.
>>
>>>> +}
>>>> +
>>>> +static void ib_uverbs_uobject_remove(struct ib_uobject *uobject,
>> bool
>>>> lock)
>>>> +{
>>>> +     /*
>>>> +      * Calling remove requires exclusive access, so it's not
>> possible
>>>> +      * another thread will use our object.
>>>> +      */
>>>> +     uobject->live = 0;
>>>> +     uobject->type->free_fn(uobject->type, uobject);
>>>> +     if (lock)
>>>> +             mutex_lock(&uobject->context->uobjects_lock->lock);
>>>> +     list_del(&uobject->list);
>>>> +     if (lock)
>>>> +             mutex_unlock(&uobject->context->uobjects_lock->lock);
>>>> +     remove_uobj(uobject);
>>>> +     put_uobj(uobject);
>>>> +}
>>>> +
>>>> +static void uverbs_unlock_idr(struct ib_uobject *uobj,
>>>> +                           enum uverbs_idr_access access,
>>>> +                           bool success)
>>>> +{
>>>> +     switch (access) {
>>>> +     case UVERBS_IDR_ACCESS_READ:
>>>> +             up_read(&uobj->usecnt);
>>>> +             break;
>>>> +     case UVERBS_IDR_ACCESS_NEW:
>>>> +             if (success) {
>>>> +                     ib_uverbs_uobject_enable(uobj);
>>>> +             } else {
>>>> +                     remove_uobj(uobj);
>>>> +                     put_uobj(uobj);
>>>> +             }
>>>> +             break;
>>>> +     case UVERBS_IDR_ACCESS_WRITE:
>>>> +             up_write(&uobj->usecnt);
>>>> +             break;
>>>> +     case UVERBS_IDR_ACCESS_DESTROY:
>>>> +             if (success)
>>>> +                     ib_uverbs_uobject_remove(uobj, true);
>>>> +             else
>>>> +                     up_write(&uobj->usecnt);
>>>> +             break;
>>>> +     }
>>>> +}
>>>> +
>>>> +static void uverbs_unlock_fd(struct ib_uobject *uobj,
>>>> +                          enum uverbs_idr_access access,
>>>> +                          bool success)
>>>> +{
>>>> +     struct file *filp = uobj->object;
>>>> +
>>>> +     if (access == UVERBS_IDR_ACCESS_NEW) {
>>>> +             if (success) {
>>>> +                     kref_get(&uobj->context->ufile->ref);
>>>> +                     uobj->uobjects_lock = uobj->context-
>>> uobjects_lock;
>>>> +                     kref_get(&uobj->uobjects_lock->ref);
>>>> +                     ib_uverbs_uobject_enable(uobj);
>>>> +                     fd_install(uobj->id, uobj->object);
>>>
>>> I don't get this.  The function is unlocking something, but there are
>> calls to get krefs?
>>>
>>
>> Before invoking the user's callback, we're first locking all objects
>> and afterwards we're unlocking them. When we need to create a new
>> object, the lock becomes object creation and the unlock could become
>> (assuming the user's callback succeeded) enabling this new object.
>> When you add a new object (or fd in this case), we take a reference
>> count to both the uverbs_file and the locking context.
>>
>>>> +             } else {
>>>> +                     fput(uobj->object);
>>>> +                     put_unused_fd(uobj->id);
>>>> +                     kfree(uobj);
>>>> +             }
>>>> +     } else {
>>>> +             fput(filp);
>>>> +     }
>>>> +}
>>>> +
>>>> +void uverbs_unlock_object(struct ib_uobject *uobj,
>>>> +                       enum uverbs_idr_access access,
>>>> +                       bool success)
>>>> +{
>>>> +     if (uobj->type->type == UVERBS_ATTR_TYPE_IDR)
>>>> +             uverbs_unlock_idr(uobj, access, success);
>>>> +     else if (uobj->type->type == UVERBS_ATTR_TYPE_FD)
>>>> +             uverbs_unlock_fd(uobj, access, success);
>>>> +     else
>>>> +             WARN_ON(true);
>>>> +}
>>>> +
>>>> +static void ib_uverbs_remove_fd(struct ib_uobject *uobject)
>>>> +{
>>>> +     /*
>>>> +      * user should release the uobject in the release
>>>> +      * callback.
>>>> +      */
>>>> +     if (uobject->live) {
>>>> +             uobject->live = 0;
>>>> +             list_del(&uobject->list);
>>>> +             uobject->type->free_fn(uobject->type, uobject);
>>>> +             kref_put(&uobject->context->ufile->ref,
>>>> ib_uverbs_release_file);
>>>> +             uobject->context = NULL;
>>>> +     }
>>>> +}
>>>> +
>>>> +void ib_uverbs_close_fd(struct file *f)
>>>> +{
>>>> +     struct ib_uobject *uobject = f->private_data - sizeof(struct
>>>> ib_uobject);
>>>> +
>>>> +     mutex_lock(&uobject->uobjects_lock->lock);
>>>> +     if (uobject->live) {
>>>> +             uobject->live = 0;
>>>> +             list_del(&uobject->list);
>>>> +             kref_put(&uobject->context->ufile->ref,
>>>> ib_uverbs_release_file);
>>>> +             uobject->context = NULL;
>>>> +     }
>>>> +     mutex_unlock(&uobject->uobjects_lock->lock);
>>>> +     kref_put(&uobject->uobjects_lock->ref,
>>>> release_uobjects_list_lock);
>>>> +}
>>>> +
>>>> +void ib_uverbs_cleanup_fd(void *private_data)
>>>> +{
>>>> +     struct ib_uboject *uobject = private_data - sizeof(struct
>>>> ib_uobject);
>>>> +
>>>> +     kfree(uobject);
>>>> +}
>>>> +
>>>> +void uverbs_unlock_objects(struct uverbs_attr_array *attr_array,
>>>> +                        size_t num,
>>>> +                        const struct uverbs_action_spec *spec,
>>>> +                        bool success)
>>>> +{
>>>> +     unsigned int i;
>>>> +
>>>> +     for (i = 0; i < num; i++) {
>>>> +             struct uverbs_attr_array *attr_spec_array =
>> &attr_array[i];
>>>> +             const struct uverbs_attr_group_spec *group_spec =
>>>> +                     spec->attr_groups[i];
>>>> +             unsigned int j;
>>>> +
>>>> +             for (j = 0; j < attr_spec_array->num_attrs; j++) {
>>>> +                     struct uverbs_attr *attr = &attr_spec_array-
>>>>> attrs[j];
>>>> +                     struct uverbs_attr_spec *spec = &group_spec-
>>>>> attrs[j];
>>>> +
>>>> +                     if (!attr->valid)
>>>> +                             continue;
>>>> +
>>>> +                     if (spec->type == UVERBS_ATTR_TYPE_IDR ||
>>>> +                         spec->type == UVERBS_ATTR_TYPE_FD)
>>>> +                             /*
>>>> +                              * refcounts should be handled at the
>> object
>>>> +                              * level and not at the uobject level.
>>>> +                              */
>>>> +                             uverbs_unlock_object(attr-
>>> obj_attr.uobject,
>>>> +                                                  spec->obj.access,
>> success);
>>>> +             }
>>>> +     }
>>>> +}
>>>> +
>>>> +static unsigned int get_type_orders(const struct uverbs_types_group
>>>> *types_group)
>>>> +{
>>>> +     unsigned int i;
>>>> +     unsigned int max = 0;
>>>> +
>>>> +     for (i = 0; i < types_group->num_groups; i++) {
>>>> +             unsigned int j;
>>>> +             const struct uverbs_types *types = types_group-
>>>>> type_groups[i];
>>>> +
>>>> +             for (j = 0; j < types->num_types; j++) {
>>>> +                     if (!types->types[j] || !types->types[j]-
>>> alloc)
>>>> +                             continue;
>>>> +                     if (types->types[j]->alloc->order > max)
>>>> +                             max = types->types[j]->alloc->order;
>>>> +             }
>>>> +     }
>>>> +
>>>> +     return max;
>>>> +}
>>>> +
>>>> +void ib_uverbs_uobject_type_cleanup_ucontext(struct ib_ucontext
>>>> *ucontext,
>>>> +                                          const struct
>> uverbs_types_group
>>>> *types_group)
>>>> +{
>>>> +     unsigned int num_orders = get_type_orders(types_group);
>>>> +     unsigned int i;
>>>> +
>>>> +     for (i = 0; i <= num_orders; i++) {
>>>> +             struct ib_uobject *obj, *next_obj;
>>>> +
>>>> +             /*
>>>> +              * No need to take lock here, as cleanup should be
>> called
>>>> +              * after all commands finished executing. Newly
>> executed
>>>> +              * commands should fail.
>>>> +              */
>>>> +             mutex_lock(&ucontext->uobjects_lock->lock);
>>>
>>> It's really confusing to see a comment about 'no need to take lock'
>> immediately followed by a call to lock.
>>>
>>
>> Yeah :) That was before adding the fd. I'll delete the comment.
>>
>>>> +             list_for_each_entry_safe(obj, next_obj, &ucontext-
>>>>> uobjects,
>>>> +                                      list)
>>>> +                     if (obj->type->order == i) {
>>>> +                             if (obj->type->type ==
>> UVERBS_ATTR_TYPE_IDR)
>>>> +                                     ib_uverbs_uobject_remove(obj,
>> false);
>>>> +                             else
>>>> +                                     ib_uverbs_remove_fd(obj);
>>>> +                     }
>>>> +             mutex_unlock(&ucontext->uobjects_lock->lock);
>>>> +     }
>>>> +     kref_put(&ucontext->uobjects_lock->ref,
>>>> release_uobjects_list_lock);
>>>> +}
>>>> +
>>>> +int ib_uverbs_uobject_type_initialize_ucontext(struct ib_ucontext
>>>> *ucontext)
>>>
>>> Please work on the function names.  This is horrendously long and
>> still doesn't help describe what it does.
>>>
>>
>> This just initialized the types part of the ucontext. Any suggestions?
>>
>>>> +{
>>>> +     ucontext->uobjects_lock = kmalloc(sizeof(*ucontext-
>>>>> uobjects_lock),
>>>> +                                       GFP_KERNEL);
>>>> +     if (!ucontext->uobjects_lock)
>>>> +             return -ENOMEM;
>>>> +
>>>> +     init_uobjects_list_lock(ucontext->uobjects_lock);
>>>> +     INIT_LIST_HEAD(&ucontext->uobjects);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +void ib_uverbs_uobject_type_release_ucontext(struct ib_ucontext
>>>> *ucontext)
>>>> +{
>>>> +     kfree(ucontext->uobjects_lock);
>>>> +}
>>>
>>> No need to wrap a call to 'free'.
>>>
>>
>> In order to abstract away the ucontext type data structure.
>>
>>>> +
>>>> diff --git a/drivers/infiniband/core/rdma_core.h
>>>> b/drivers/infiniband/core/rdma_core.h
>>>> new file mode 100644
>>>> index 0000000..8990115
>>>> --- /dev/null
>>>> +++ b/drivers/infiniband/core/rdma_core.h
>>>> @@ -0,0 +1,75 @@
>>>> +/*
>>>> + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
>>>> + * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
>>>> + * Copyright (c) 2005-2016 Mellanox Technologies. All rights
>> reserved.
>>>> + * Copyright (c) 2005 Voltaire, Inc. All rights reserved.
>>>> + * Copyright (c) 2005 PathScale, Inc. All rights reserved.
>>>> + *
>>>> + * This software is available to you under a choice of one of two
>>>> + * licenses.  You may choose to be licensed under the terms of the
>> GNU
>>>> + * General Public License (GPL) Version 2, available from the file
>>>> + * COPYING in the main directory of this source tree, or the
>>>> + * OpenIB.org BSD license below:
>>>> + *
>>>> + *     Redistribution and use in source and binary forms, with or
>>>> + *     without modification, are permitted provided that the
>> following
>>>> + *     conditions are met:
>>>> + *
>>>> + *      - Redistributions of source code must retain the above
>>>> + *        copyright notice, this list of conditions and the
>> following
>>>> + *        disclaimer.
>>>> + *
>>>> + *      - Redistributions in binary form must reproduce the above
>>>> + *        copyright notice, this list of conditions and the
>> following
>>>> + *        disclaimer in the documentation and/or other materials
>>>> + *        provided with the distribution.
>>>> + *
>>>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>>>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
>> OF
>>>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>>>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
>> HOLDERS
>>>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
>> AN
>>>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
>> IN
>>>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>>>> + * SOFTWARE.
>>>> + */
>>>> +
>>>> +#ifndef UOBJECT_H
>>>> +#define UOBJECT_H
>>>> +
>>>> +#include <linux/idr.h>
>>>> +#include <rdma/uverbs_ioctl.h>
>>>> +#include <rdma/ib_verbs.h>
>>>> +#include <linux/mutex.h>
>>>> +
>>>> +const struct uverbs_type *uverbs_get_type(const struct ib_device
>>>> *ibdev,
>>>> +                                       uint16_t type);
>>>> +struct ib_uobject *uverbs_get_type_from_idr(const struct
>>>> uverbs_type_alloc_action *type,
>>>> +                                         struct ib_ucontext
>> *ucontext,
>>>> +                                         enum uverbs_idr_access
>> access,
>>>> +                                         uint32_t idr);
>>>> +struct ib_uobject *uverbs_get_type_from_fd(const struct
>>>> uverbs_type_alloc_action *type,
>>>> +                                        struct ib_ucontext
>> *ucontext,
>>>> +                                        enum uverbs_idr_access
>> access,
>>>> +                                        int fd);
>>>> +void uverbs_unlock_object(struct ib_uobject *uobj,
>>>> +                       enum uverbs_idr_access access,
>>>> +                       bool success);
>>>> +void uverbs_unlock_objects(struct uverbs_attr_array *attr_array,
>>>> +                        size_t num,
>>>> +                        const struct uverbs_action_spec *spec,
>>>> +                        bool success);
>>>> +
>>>> +void ib_uverbs_uobject_type_cleanup_ucontext(struct ib_ucontext
>>>> *ucontext,
>>>> +                                          const struct
>> uverbs_types_group
>>>> *types_group);
>>>> +int ib_uverbs_uobject_type_initialize_ucontext(struct ib_ucontext
>>>> *ucontext);
>>>> +void ib_uverbs_uobject_type_release_ucontext(struct ib_ucontext
>>>> *ucontext);
>>>> +void ib_uverbs_close_fd(struct file *f);
>>>> +void ib_uverbs_cleanup_fd(void *private_data);
>>>> +
>>>> +static inline void *uverbs_fd_to_priv(struct ib_uobject *uobj)
>>>> +{
>>>> +     return uobj + 1;
>>>> +}
>>>
>>> This seems like a rather useless function.
>>>
>>
>> Why? The user sholdn't know or care how we put our structs together.
>>
>>>> +
>>>> +#endif /* UIDR_H */
>>>> diff --git a/drivers/infiniband/core/uverbs.h
>>>> b/drivers/infiniband/core/uverbs.h
>>>> index 8074705..ae7d4b8 100644
>>>> --- a/drivers/infiniband/core/uverbs.h
>>>> +++ b/drivers/infiniband/core/uverbs.h
>>>> @@ -180,6 +180,7 @@ void idr_remove_uobj(struct ib_uobject *uobj);
>>>>  struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file
>>>> *uverbs_file,
>>>>                                       struct ib_device *ib_dev,
>>>>                                       int is_async);
>>>> +void ib_uverbs_release_file(struct kref *ref);
>>>>  void ib_uverbs_free_async_event_file(struct ib_uverbs_file
>>>> *uverbs_file);
>>>>  struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd);
>>>>
>>>> diff --git a/drivers/infiniband/core/uverbs_main.c
>>>> b/drivers/infiniband/core/uverbs_main.c
>>>> index f783723..e63357a 100644
>>>> --- a/drivers/infiniband/core/uverbs_main.c
>>>> +++ b/drivers/infiniband/core/uverbs_main.c
>>>> @@ -341,7 +341,7 @@ static void ib_uverbs_comp_dev(struct
>>>> ib_uverbs_device *dev)
>>>>       complete(&dev->comp);
>>>>  }
>>>>
>>>> -static void ib_uverbs_release_file(struct kref *ref)
>>>> +void ib_uverbs_release_file(struct kref *ref)
>>>>  {
>>>>       struct ib_uverbs_file *file =
>>>>               container_of(ref, struct ib_uverbs_file, ref);
>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>>> index b5d2075..7240615 100644
>>>> --- a/include/rdma/ib_verbs.h
>>>> +++ b/include/rdma/ib_verbs.h
>>>> @@ -1329,8 +1329,11 @@ struct ib_fmr_attr {
>>>>
>>>>  struct ib_umem;
>>>>
>>>> +struct ib_ucontext_lock;
>>>> +
>>>>  struct ib_ucontext {
>>>>       struct ib_device       *device;
>>>> +     struct ib_uverbs_file  *ufile;
>>>>       struct list_head        pd_list;
>>>>       struct list_head        mr_list;
>>>>       struct list_head        mw_list;
>>>> @@ -1344,6 +1347,10 @@ struct ib_ucontext {
>>>>       struct list_head        rwq_ind_tbl_list;
>>>>       int                     closing;
>>>>
>>>> +     /* lock for uobjects list */
>>>> +     struct ib_ucontext_lock *uobjects_lock;
>>>> +     struct list_head        uobjects;
>>>> +
>>>>       struct pid             *tgid;
>>>>  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
>>>>       struct rb_root      umem_tree;
>>>> @@ -1363,16 +1370,28 @@ struct ib_ucontext {
>>>>  #endif
>>>>  };
>>>>
>>>> +struct uverbs_object_list;
>>>> +
>>>> +#define OLD_ABI_COMPAT
>>>> +
>>>>  struct ib_uobject {
>>>>       u64                     user_handle;    /* handle given to us
>> by userspace
>>>> */
>>>>       struct ib_ucontext     *context;        /* associated user
>> context
>>>> */
>>>>       void                   *object;         /* containing object
>> */
>>>>       struct list_head        list;           /* link to context's
>> list */
>>>> -     int                     id;             /* index into kernel
>> idr */
>>>> -     struct kref             ref;
>>>> -     struct rw_semaphore     mutex;          /* protects .live */
>>>> +     int                     id;             /* index into kernel
>> idr/fd */
>>>> +#ifdef OLD_ABI_COMPAT
>>>> +     struct kref             ref;
>>>> +#endif
>>>> +     struct rw_semaphore     usecnt;         /* protects exclusive
>>>> access */
>>>> +#ifdef OLD_ABI_COMPAT
>>>> +     struct rw_semaphore     mutex;          /* protects .live */
>>>> +#endif
>>>>       struct rcu_head         rcu;            /* kfree_rcu()
>> overhead */
>>>>       int                     live;
>>>> +
>>>> +     const struct uverbs_type_alloc_action *type;
>>>> +     struct ib_ucontext_lock *uobjects_lock;
>>>>  };
>>>>
>>>>  struct ib_udata {
>>>> @@ -2101,6 +2120,9 @@ struct ib_device {
>>>>        */
>>>>       int (*get_port_immutable)(struct ib_device *, u8, struct
>>>> ib_port_immutable *);
>>>>       void (*get_dev_fw_str)(struct ib_device *, char *str, size_t
>>>> str_len);
>>>> +     struct list_head type_list;
>>>> +
>>>> +     const struct uverbs_types_group *types_group;
>>>>  };
>>>>
>>>>  struct ib_client {
>>>> diff --git a/include/rdma/uverbs_ioctl.h
>> b/include/rdma/uverbs_ioctl.h
>>>> new file mode 100644
>>>> index 0000000..2f50045
>>>> --- /dev/null
>>>> +++ b/include/rdma/uverbs_ioctl.h
>>>> @@ -0,0 +1,195 @@
>>>> +/*
>>>> + * Copyright (c) 2016, Mellanox Technologies inc.  All rights
>>>> reserved.
>>>> + *
>>>> + * This software is available to you under a choice of one of two
>>>> + * licenses.  You may choose to be licensed under the terms of the
>> GNU
>>>> + * General Public License (GPL) Version 2, available from the file
>>>> + * COPYING in the main directory of this source tree, or the
>>>> + * OpenIB.org BSD license below:
>>>> + *
>>>> + *     Redistribution and use in source and binary forms, with or
>>>> + *     without modification, are permitted provided that the
>> following
>>>> + *     conditions are met:
>>>> + *
>>>> + *      - Redistributions of source code must retain the above
>>>> + *        copyright notice, this list of conditions and the
>> following
>>>> + *        disclaimer.
>>>> + *
>>>> + *      - Redistributions in binary form must reproduce the above
>>>> + *        copyright notice, this list of conditions and the
>> following
>>>> + *        disclaimer in the documentation and/or other materials
>>>> + *        provided with the distribution.
>>>> + *
>>>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>>>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
>> OF
>>>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>>>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
>> HOLDERS
>>>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
>> AN
>>>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
>> IN
>>>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>>>> + * SOFTWARE.
>>>> + */
>>>> +
>>>> +#ifndef _UVERBS_IOCTL_
>>>> +#define _UVERBS_IOCTL_
>>>> +
>>>> +#include <linux/kernel.h>
>>>> +
>>>> +struct uverbs_object_type;
>>>> +struct ib_ucontext;
>>>> +struct ib_uobject;
>>>> +struct ib_device;
>>>> +struct uverbs_uobject_type;
>>>> +
>>>> +/*
>>>> + * =======================================
>>>> + *   Verbs action specifications
>>>> + * =======================================
>>>> + */
>>>
>>> I intentionally used urdma (though condensed to 3 letters that I
>> don't recall atm), rather than uverbs.  This will need to work with
>> non-verbs devices and interfaces -- again, consider how this fits with
>> the rdma cm.  Verbs has a very specific meaning, which gets lost if we
>> start referring to everything as 'verbs'.  It's bad enough that we're
>> stuck with 'drivers/infiniband' and 'rdma', such that 'infiniband' also
>> means ethernet and rdma means nothing.
>>>
>>
>> IMHO - let's agree on the concept of this infrastructure. One we
>> decide its scope, we could generalize it (i.e - ioctl_provider and
>> ioctl_context) and implement it to rdma-cm as well.
>>
>>>> +
>>>> +enum uverbs_attr_type {
>>>> +     UVERBS_ATTR_TYPE_PTR_IN,
>>>> +     UVERBS_ATTR_TYPE_PTR_OUT,
>>>> +     UVERBS_ATTR_TYPE_IDR,
>>>> +     UVERBS_ATTR_TYPE_FD,
>>>> +};
>>>> +
>>>> +enum uverbs_idr_access {
>>>> +     UVERBS_IDR_ACCESS_READ,
>>>> +     UVERBS_IDR_ACCESS_WRITE,
>>>> +     UVERBS_IDR_ACCESS_NEW,
>>>> +     UVERBS_IDR_ACCESS_DESTROY
>>>> +};
>>>> +
>>>> +struct uverbs_attr_spec {
>>>> +     u16                             len;
>>>> +     enum uverbs_attr_type           type;
>>>> +     struct {
>>>> +             u16                     obj_type;
>>>> +             u8                      access;
>>>
>>> Is access intended to be an enum uverbs_idr_access value?
>>>
>>
>> Yeah, worth using this enum. Thanks.
>>
>>>> +     } obj;
>>>
>>> I would remove (flatten) the substructure and re-order the fields for
>> better alignment.
>>>
>>
>> I noticed there are several places which aren't aliged. It's in my todo
>> list.
>>
>>>> +};
>>>> +
>>>> +struct uverbs_attr_group_spec {
>>>> +     struct uverbs_attr_spec         *attrs;
>>>> +     size_t                          num_attrs;
>>>> +};
>>>> +
>>>> +struct uverbs_action_spec {
>>>> +     const struct uverbs_attr_group_spec             **attr_groups;
>>>> +     /* if > 0 -> validator, otherwise, error */
>>>
>>> ? not sure what this comment means
>>>
>>>> +     int (*dist)(__u16 *attr_id, void *priv);
>>>
>>> What does 'dist' stand for?
>>>
>>
>> dist = distribution function.
>> It maps the attributes you got from the user-space to your groups. You
>> could think of each group as a namespace - where its attributes (or
>> types/actions) starts from zero in the sake of compactness.
>> So, for example, it gets an attribute 0x8010 and maps to to "group 1"
>> (provider) and attribute 0x10.
>>
>>>> +     void                                            *priv;
>>>> +     size_t                                          num_groups;
>>>> +};
>>>> +
>>>> +struct uverbs_attr_array;
>>>> +struct ib_uverbs_file;
>>>> +
>>>> +struct uverbs_action {
>>>> +     struct uverbs_action_spec spec;
>>>> +     void *priv;
>>>> +     int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file
>>>> *ufile,
>>>> +                    struct uverbs_attr_array *ctx, size_t num, void
>>>> *priv);
>>>> +};
>>>> +
>>>> +struct uverbs_type_alloc_action;
>>>> +typedef void (*free_type)(const struct uverbs_type_alloc_action
>>>> *uobject_type,
>>>> +                       struct ib_uobject *uobject);
>>>> +
>>>> +struct uverbs_type_alloc_action {
>>>> +     enum uverbs_attr_type           type;
>>>> +     int                             order;
>>>
>>> I think this is being used as destroy order, in which case I would
>> rename it to clarify the intent.  Though I'd prefer we come up with a
>> more efficient destruction mechanism than the repeated nested looping.
>>>
>>
>> In one of the earlier revisions I used a sorted list, which was
>> efficient. I recall that Jason didn't like its complexity and
>> re-thinking about that - he's right. Most of your types are "order
>> number" 0 anyway. So you'll probably iterate very few objects in the
>> next round (in verbs, everything but MRs and PDs).
>>
>>>> +     size_t                          obj_size;
>>>
>>> This can be alloc_fn
>>>
>>>> +     free_type                       free_fn;
>>>> +     struct {
>>>> +             const struct file_operations    *fops;
>>>> +             const char                      *name;
>>>> +             int                             flags;
>>>> +     } fd;
>>>> +};
>>>> +
>>>> +struct uverbs_type_actions_group {
>>>> +     size_t                                  num_actions;
>>>> +     const struct uverbs_action              **actions;
>>>> +};
>>>> +
>>>> +struct uverbs_type {
>>>> +     size_t                                  num_groups;
>>>> +     const struct uverbs_type_actions_group  **action_groups;
>>>> +     const struct uverbs_type_alloc_action   *alloc;
>>>> +     int (*dist)(__u16 *action_id, void *priv);
>>>> +     void                                    *priv;
>>>> +};
>>>> +
>>>> +struct uverbs_types {
>>>> +     size_t                                  num_types;
>>>> +     const struct uverbs_type                **types;
>>>> +};
>>>> +
>>>> +struct uverbs_types_group {
>>>> +     const struct uverbs_types               **type_groups;
>>>> +     size_t                                  num_groups;
>>>> +     int (*dist)(__u16 *type_id, void *priv);
>>>> +     void                                    *priv;
>>>> +};
>>>> +
>>>> +/* =================================================
>>>> + *              Parsing infrastructure
>>>> + * =================================================
>>>> + */
>>>> +
>>>> +struct uverbs_ptr_attr {
>>>> +     void    * __user ptr;
>>>> +     __u16           len;
>>>> +};
>>>> +
>>>> +struct uverbs_fd_attr {
>>>> +     int             fd;
>>>> +};
>>>> +
>>>> +struct uverbs_uobj_attr {
>>>> +     /*  idr handle */
>>>> +     __u32   idr;
>>>> +};
>>>> +
>>>> +struct uverbs_obj_attr {
>>>> +     /* pointer to the kernel descriptor -> type, access, etc */
>>>> +     const struct uverbs_attr_spec *val;
>>>> +     struct ib_uverbs_attr __user    *uattr;
>>>> +     const struct uverbs_type_alloc_action   *type;
>>>> +     struct ib_uobject               *uobject;
>>>> +     union {
>>>> +             struct uverbs_fd_attr           fd;
>>>> +             struct uverbs_uobj_attr         uobj;
>>>> +     };
>>>> +};
>>>> +
>>>> +struct uverbs_attr {
>>>> +     bool valid; > >> +     union {
>>>> +             struct uverbs_ptr_attr  cmd_attr;
>>>> +             struct uverbs_obj_attr  obj_attr;
>>>> +     };
>>>> +};
>>>
>>> It's odd to have a union that's part of a structure without some
>> field to indicate which union field is accessible.
>>>
>>
>> You index this array but the attribute id from the user's callback
>> funciton. The user should know what's the type of the attribute, as
>> [s]he declared the specification.
>>
>>>> +
>>>> +/* output of one validator */
>>>> +struct uverbs_attr_array {
>>>> +     size_t num_attrs;
>>>> +     /* arrays of attrubytes, index is the id i.e SEND_CQ */
>>>> +     struct uverbs_attr *attrs;
>>>> +};
>>>> +
>>>> +/* =================================================
>>>> + *              Types infrastructure
>>>> + * =================================================
>>>> + */
>>>> +
>>>> +int ib_uverbs_uobject_type_add(struct list_head      *head,
>>>> +                            void (*free)(struct uverbs_uobject_type
>> *type,
>>>> +                                         struct ib_uobject
>> *uobject,
>>>> +                                         struct ib_ucontext
>> *ucontext),
>>>> +                            uint16_t obj_type);
>>>> +void ib_uverbs_uobject_types_remove(struct ib_device *ib_dev);
>>>> +
>>>> +#endif
>>>> --
>>>> 2.7.4
>
> Matan, please re-look at the architecture that I proposed:
>
> https://patchwork.kernel.org/patch/9178991/
>
> including the terminology (and consider using common OOP terms).  The *core* of the ioctl framework is to simply invoke a function dispatch table.  IMO, that's where we should start.  Anything beyond that is extra that we should have a strong reason for including.  (Yes, I think we need more.)  Starting simple and adding necessary functionality should let us get something upstream quicker and re-use more of the existing code.

Actually, I've looked at your proposal. Some of the ideas are blend 
between your proposal and my original proposal.
One of our goals is to get rid of the commonalities between handlers and 
push the validation and locking to a common code which could validated 
once to be correct. It tends to be a lot easier (and correct) than to 
re-examine every function call.

>
> If we're going to re-create netlink as part of the rdma ioctl interface, then why don't we just use netlink directly?
>

We had a netlink based proposal first, but:
(a) We want one call dispatching (as opposed to send-receive).
(b) We don't want to copy the driver's data from the user-space to the 
libibverbs buffer.
(c) We don't need the complexity of nesting.
(d) Bare netlink is considered unreliable.
(e) We need semantics of objects.
(f) By using pointers, we could eliminate some copies.

Thanks for looking at this patch.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
