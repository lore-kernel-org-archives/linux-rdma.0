From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Fri, 29 May 2015 11:06:10 -0600
Message-ID: <20150529170610.GA32378@obsidianresearch.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
 <1431515438-24042-2-git-send-email-yishaih@mellanox.com>
 <20150525165449.GA4379@obsidianresearch.com>
 <1432742669.28905.228.camel@redhat.com>
 <55662D63.3030806@dev.mellanox.co.il>
 <20150528061923.GA4054@obsidianresearch.com>
 <AM3PR05MB0935AB183EA8764FD83C36A0DCC90@AM3PR05MB0935.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AM3PR05MB0935AB183EA8764FD83C36A0DCC90-LOZWmgKjnYgQouBfZGh8ttqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 29, 2015 at 10:30:52AM +0000, Shachar Raindel wrote:
> > The locking scheme makes no sense, see my other email, design it for a
> > rwsem and then consider rcu if necessary.
> 
> Jason, the RCU based scheme is important, as it allows the performance
> critical path (verbs such as ibv_reg_mr) to avoid cross core dependencies.

The difference between RCU and rwsem is at worst a cache line bounce
if simultaneously stressed by different readers on different CPUs (at
best it might be faster). Can reg_mr even run concurrently on multiple
cpus?

Right now I want to see a locking scheme that makes sense, isn't so
damn subtle and follows the RCU usage guidelines.

> > Hint: Get rid of dev->disassociated and use ib_dev == null to
> 
> Initially, I liked this idea, as it makes it easier to prove the RCU
> correctness. However, it makes life really complicated:

It doesn't make it 'easier to prove RCU correctness' it is 'the
correct way to use RCU'.

> - We will need to latch ib_dev in uverbs_cmd, and handle possible NULL
>   value. There are 17 uses of ib_dev in uverbs_cmd. This makes the patch
>   even bigger.

rwsem avoids that, of course. But even so, it is a pretty small change
to have ib_uverbs_write grab the ib_dev and ucontext under rcu and
then pass them as function arguments to the callback.

> - To make life even more complicated, a large number of objects (i.e. PD,
>   MR, QP, XRCD, etc.) are keeping a pointer to the same ib_dev
>   struct.
>   Making ib_dev NULL will not magically make these pointer NULL as well.
>   As a result, attempting to RCU annotating all affected users will be
>   impossible.

This point makes no sense. I don't think you understand RCU. Only the
member in the ib_uverbs_device device needs to be read while holding
rcu. Once ib_dev is copied and kref incr'd into the PD it is outside
of uverbs concern, and no longer covered by the RCU.

> - The release flows for the relevant uverbs object might be accessing the
>   ib_dev pointer from time to time. Setting ib_dev to NULL before calling
>   the relevant ib_verbs_cleanup_context seems like the recipe for a kernel
>   OOPS for NULL pointer deref.

Are you just guessing at this? Did you check them? I briefly did, and
again just now. Looks OK.

> > ib_uverbs_close:
> 
> This is give or take the same as what is in the current code.

It looks similar but works very differently.

> > down(lists_mutex)
> 
> This name is better than the current "disassociate_mutex" name we have for
> this mutex, will fix in next version.
> 
> > tmp = file->ucontext;
> > if (tmp) {
> >    list_del(&file->list);
> >    file->ucontext = NULL;
> 
> We avoid setting the file->ucontext to NULL early, to avoid a spurious
> NULL pointer dereferences.

Again, this comment makes no sense. You are concerned about a NULL
dereference when this code is freeing the structure? No concern about
use-after-free?

Are you just guessing there might be a problem? Did you study this
scenario?

> However, if you think that this is what will fix the readability, we can 
> set it to NULL and avoid touching the pointer after this point.

This has nothing to do with readability, it is mandatory that the null
set be possible.

> > }
> > up(lists_mutex);
> > 
> > if (tmp)
> >   ib_uverbs_cleanup_ucontext(file, tmp);
> > 
> > ib_uverbs_free_hw_resources:
> > 
> 
> Here is where subtle locking is getting out of the bag.
> Your skeleton flow only handles the main uverbs file.
> However, this will get the user applications stuck. If
> the application is waiting for an event, we should raise
> a fatal "device disassociated" event to release the application.

I'm not going to code this for you, I just showed the basic idea. You
need to extrapolate that to the other cases.

> Doing so after you started NULLifying pointers and removing
> elements from lists seems the wrong way to do it, a way which
> can lead to large amount of oopsing and deadlocking later on.

You should actually look at how event delivery works.

> > down(lists_mutex)
> > while (!lists_empty(&uverbs_dev->uverbs_file_list) {
> >   file = list_first_entry(&uverbs_dev->uverbs_file_list, list)
> >   tmp = file->ucontext;
> >   list_del(&file->list);
> 
> This is where a bug will hit you - if ib_uverbs_close also
> unconditionally does list_del from file->list, you have
> a nice big race here.

And #3 'this comment makes no sense' - seriously?

 down(lists_mutex)
 tmp = file->ucontext;
 if (tmp) {
    list_del(&file->list);
    file->ucontext = NULL;
 }
 up(lists_mutex);

Does that look unconditional/unlocked to you?

Look, this is wasting my time. If you are going to answer a detailed
email then you had better study the subject matter deeply.

> The current code takes reference to all files with a single
> locking, and after that releases them all without holding a
> lock. Your suggestion is busy bouncing the lock back and forth.

This is removal, so any cost we pay is completely irrelevant.
Be Clear. Be Clean. Be Correct.

> To make it more interesting, if we try to use SRCU with your
> suggestion, we will need to sync the SRCU every time we drop
> the lock. Syncing the SRCU is really long operation (seconds). 
> Doing it once during the device removal is OK. Doing it for every
> FD is not practical.

You really don't understand RCU if you think that loop needs to
synchronize_rcu.

> > Now the krefs are unquestionably paired, we don't leave a dangling
> > ucontext pointer, we don't leave a dangling list entry, locking of the
> > list is explicit and doesn't rely on an unlocked access with an
> > implicit exclusion.
> 
> We don't leave a dangling list entry in our code either.

I see two missing list_del's at least.

> If the module is in the process of being removed, it will call the 
> ib_uverbs_remove_one. This calls our disassociate code, and is synchronize
> using the list_mutex. This will prevent such issues, without dirtying
> another cache line in the good case.

You need to stop micro optimizing things that don't need to be micro
optimized.

It doesn't hurt things to follow the normal pattern and release the
lock early.

I feel like looking at this patch has been a waste of my time.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
