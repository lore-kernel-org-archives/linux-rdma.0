From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Tue, 15 Mar 2016 14:33:00 +0530
Message-ID: <CANjDDBgjwHHFgZiyBaGtxhzg6s+RkN_sbDa8RqjWy4pGxt2GXA@mail.gmail.com>
References: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com>
 <20160312204502.GA8346@obsidianresearch.com> <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA@mail.gmail.com>
 <20160314174814.GB5240@obsidianresearch.com> <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry, I pressed send too early, just one more point I wanted to make,
listed below

On Tue, Mar 15, 2016 at 2:30 PM, Devesh Sharma
<devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
> On Mon, Mar 14, 2016 at 11:18 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> On Mon, Mar 14, 2016 at 11:10:33AM +0530, Devesh Sharma wrote:
>>> On Sun, Mar 13, 2016 at 2:15 AM, Jason Gunthorpe
>>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>> >
>>> > On Sat, Mar 12, 2016 at 10:18:47AM -0500, Devesh Sharma wrote:
>>> > > CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> >
>>> > I'm still pretty convinced this is wrong... But even still:
>>> >
>>> > > @@ -954,6 +955,17 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
>>> > >       struct ib_uverbs_file *file = filp->private_data;
>>> > >       struct ib_uverbs_device *dev = file->device;
>>> > >       struct ib_ucontext *ucontext = NULL;
>>> > > +     struct ib_device *ib_dev;
>>> > > +     int srcu_key;
>>> > > +
>>> > > +     srcu_key = srcu_read_lock(&dev->disassociate_srcu);
>>> > > +     ib_dev = srcu_dereference(dev->ib_dev,
>>> > > +                               &dev->disassociate_srcu);
>>> > > +     if (!ib_dev) {
>>> > > +             srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
>>> > > +             wait_for_completion(&file->fcomp);
>>> > > +             goto out;
>>> >
>>> > This jumps over this:
>>>
>>> I am not sure, to my mind kref_put(...,ib_uverbs_release_file) should
>>> also be skipped.
>>
>> I am talking about ib_uverbs_release_event_file
>
> And I am adding ib_uverbs_release_file() as well. the other thread is already
> cleaning it up and if ib_uverbs_close() reads it NULL then why to put krefs?
>
>>
>>> Because, by putting an wait_for_completion(), this context is
>>> effectively waiting for ib_uverbs_cleanup_ucontext to finish
>>> cleaning up this file pointer. if the other thread is cleaning up,
>>> why do I need to put the kerf again?
>>
>> The other context doesn't do a balancing kref_put(..,ib_uverbs_release_event_file).
>
> Actually it does, in the very next while loop on event_file list.
>
>>
>>> > As I've said, I'm not sure how this is any different from using
>>> > lists_mutex. The wait_for_completion will still block and deadlock if
>>> > ib_uverbs_close is entered during the disassociate flow.
>>>
>>> Taking list-mutex is not stopping ib_dev pointer to become NULL, while
>>> if we split the mutex
>>
>> I don't think you understand the problem. ib_uverbs_device->ib_dev can
>> be NULL just fine. In fact, it is always NULL when
>> ib_uverbs_free_hw_resources calls ib_uverbs_cleanup_ucontext - that is
>> obviously fine (or if it isn't fine today, there is yet another bug).
>
> Okay, I meant it is being freed. before entring
> ib_uverb_free_hw_resource() it is obviously set to NULL
> which is well understood.
>
>>
>> The issue appears to be that ib_uverbs_free_hw_resources does not wait
>> for ib_uverbs_cleanup_ucontext to complete before it goes ahead and
>> wrecks the ib_dev, resulting in use-after-free/etc on copies of ib_dev
>> pointer that are used by the still running ib_uverbs_free_hw_resources.
>
> Exactly, that is the real problem. I have explained it in the description of V4.
>
>>
>>> and wait_for_completion(), then effectively we are trying to sync
>>> ib_uverb_close() and
>>> remove_one() in such a way that no ib_uverb_close context hit ib_dev = NULL
>>
>> No, that is the wrong problem statement and wrong solution.
>>
>> The solution is to strong fence ib_uverbs_cleanup_ucontext so that
>> ib_uverbs_free_hw_resources does not exit until it is completed,
>> either by its thread or in the close thread.
>>
>> I prefer a mutex, but perhaps there are other ways to build the
>> fence (eg uverbs_dev->refcount springs to mind)
>
> uverbs_dev->refcount is already there, we can choose to wait for
> ref_count to become zero
>
> static void ib_uverbs_remove_one(struct ib_device *device, void *client_data)
> .
> .
> .
> .
> .
>                 rcu_assign_pointer(uverbs_dev->ib_dev, NULL);
>                 ib_uverbs_free_hw_resources(uverbs_dev, device);
>                 wait_clients = 0;
>         }
>
> wait for zero here instead of dec_and_test, I think things will
> automatically fall in place after that

Off-course ib_uverb_close() will have to take the ref-count on entry and
drop on exit.

>
>         if (atomic_dec_and_test(&uverbs_dev->refcount))
>                 ib_uverbs_comp_dev(uverbs_dev);
>         if (wait_clients)
>                 wait_for_completion(&uverbs_dev->comp);
>         kobject_put(&uverbs_dev->kobj);
> }
>
>>
>>> Can you please explain how it can lead to a deadlock?
>>
>> Yishai's note outlines it:
>>
>>                 /* We must release the mutex before going ahead and calling
>>                  * disassociate_ucontext. disassociate_ucontext might end up
>>                  * indirectly calling uverbs_close, for example due to freeing
>>                  * the resources (e.g mmput).
>>
>> Meaning when we call ib_uverbs_cleanup_ucontext from within
>> ib_uverbs_free_hw_resources it may recurse down into ib_uverbs_close.
>>
>> If this happens, with your patch ib_uverbs_close will wait on the
>> completion in the same thread that is supposed to trigger it. That is
>> the same deadlock as would happen if the lists_mutex would be used.
>>
>> The last patch I sent is much closer to what is needed, it is
>> just completely wrong to try and use the srcu for this.
>>
>> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
