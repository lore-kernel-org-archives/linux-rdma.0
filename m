From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Fri, 29 May 2015 10:30:52 +0000
Message-ID: <AM3PR05MB0935AB183EA8764FD83C36A0DCC90@AM3PR05MB0935.eurprd05.prod.outlook.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
 <1431515438-24042-2-git-send-email-yishaih@mellanox.com>
 <20150525165449.GA4379@obsidianresearch.com>
 <1432742669.28905.228.camel@redhat.com> <55662D63.3030806@dev.mellanox.co.il>
 <20150528061923.GA4054@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528061923.GA4054-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, May 28, 2015 9:19 AM
> Subject: Re: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal
> when there are active user space applications
> 
> On Wed, May 27, 2015 at 11:47:31PM +0300, Yishai Hadas wrote:
> > That's correct, it was chosen from performance reasons to enable
> parallel
> > commands as part of ib_uverbs_write with minimum synchronization
> overhead
> > comparing the rwsem.
> 
> The locking scheme makes no sense, see my other email, design it for a
> rwsem and then consider rcu if necessary.
> 

Jason, the RCU based scheme is important, as it allows the performance
critical path (verbs such as ibv_reg_mr) to avoid cross core dependencies.

> Hint: Get rid of dev->disassociated and use ib_dev == null to

Initially, I liked this idea, as it makes it easier to prove the RCU
correctness. However, it makes life really complicated:

- We will need to latch ib_dev in uverbs_cmd, and handle possible NULL
  value. There are 17 uses of ib_dev in uverbs_cmd. This makes the patch
  even bigger.

- To make life even more complicated, a large number of objects (i.e. PD,
  MR, QP, XRCD, etc.) are keeping a pointer to the same ib_dev struct.
  Making ib_dev NULL will not magically make these pointer NULL as well.
  As a result, attempting to RCU annotating all affected users will be
  impossible.

- The release flows for the relevant uverbs object might be accessing the
  ib_dev pointer from time to time. Setting ib_dev to NULL before calling
  the relevant ib_verbs_cleanup_context seems like the recipe for a kernel
  OOPS for NULL pointer deref.

> accomplish the same thing. Now it is clear that ib_dev is what must be
> protected by a rwlock and the locking scheme will flow sanely from
> that point. If you must use RCU for performance then it is now clear
> that rcu_dereference must be applied to the ib_dev.

See above, it will make the patch ~4x bigger, without performing any actual
annotation value.

> 
> Then the other locking can stop being so subtle:
> 

Locks are subtle creatures by nature. I will explain why your scheme will
break below.

> -----
> ib_uverbs_close:
> 

This is give or take the same as what is in the current code.

> down(lists_mutex)

This name is better than the current "disassociate_mutex" name we have for
this mutex, will fix in next version.

> tmp = file->ucontext;
> if (tmp) {
>    list_del(&file->list);
>    file->ucontext = NULL;

We avoid setting the file->ucontext to NULL early, to avoid a spurious
NULL pointer dereferences. 
However, if you think that this is what will fix the readability, we can 
set it to NULL and avoid touching the pointer after this point.

> }
> up(lists_mutex);
> 
> if (tmp)
>   ib_uverbs_cleanup_ucontext(file, tmp);
> 
> -----
> ib_uverbs_free_hw_resources:
> 

Here is where subtle locking is getting out of the bag.
Your skeleton flow only handles the main uverbs file.
However, this will get the user applications stuck. If
the application is waiting for an event, we should raise
a fatal "device disassociated" event to release the application.

Doing so after you started NULLifying pointers and removing
elements from lists seems the wrong way to do it, a way which
can lead to large amount of oopsing and deadlocking later on.

> down(lists_mutex)
> while (!lists_empty(&uverbs_dev->uverbs_file_list) {
>   file = list_first_entry(&uverbs_dev->uverbs_file_list, list)
>   tmp = file->ucontext;
>   list_del(&file->list);

This is where a bug will hit you - if ib_uverbs_close also
unconditionally does list_del from file->list, you have
a nice big race here.

>   file->ucontext = NULL;
>   kref_get(&file->ref);

The current code takes reference to all files with a single
locking, and after that releases them all without holding a
lock. Your suggestion is busy bouncing the lock back and forth.
To make it more interesting, if we try to use SRCU with your
suggestion, we will need to sync the SRCU every time we drop
the lock. Syncing the SRCU is really long operation (seconds). 
Doing it once during the device removal is OK. Doing it for every
FD is not practical.

>   up(list_mutex);
> 
>   ib_uverbs_cleanup_ucontext(file, tmp);
> 
>   down(list_mutex);
>   kref_put(&file->ref,ib_uverbs_release_file);
> }
> up(list_mutex);
> 
> Now the krefs are unquestionably paired, we don't leave a dangling
> ucontext pointer, we don't leave a dangling list entry, locking of the
> list is explicit and doesn't rely on an unlocked access with an
> implicit exclusion.

We don't leave a dangling list entry in our code either.
The list locking in our scheme, while slightly less bold, is much more
efficient, especially for the hot path of the IB verb operations.

> Basically, it is actually obvious what each lock
> is protecting.
> 
> > In case the low level driver can be unloaded (e.g. rmmod mlx4_ib)
> > unconditionally to active uverbs clients we should prevent the module
> > dependency by ignoring the get/put mechanism. Hope that it clarifies
> the
> > usage here.
> 
> Okay, that does make sense. But I do suspect try_module_get should still
> be run, just immediately released. Otherwise the check for in-progress
> module removal is skipped.
> 

If the module is in the process of being removed, it will call the 
ib_uverbs_remove_one. This calls our disassociate code, and is synchronize
using the list_mutex. This will prevent such issues, without dirtying
another cache line in the good case.


Thanks,
--Shachar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
