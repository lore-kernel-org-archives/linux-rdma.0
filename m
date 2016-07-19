From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 7/8] RDMA/core: Change locking of ib_uobject
Date: Tue, 19 Jul 2016 18:16:11 +0300
Message-ID: <b47386f4-fdb5-d24b-dbc6-9b5e18be6bf9@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-8-git-send-email-matanb@mellanox.com>
 <20160713171657.GB19657@obsidianresearch.com>
 <6ae1a553-408c-723a-93a2-3d46d952ce35@mellanox.com>
 <20160714170051.GB2046@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160714170051.GB2046-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14/07/2016 20:00, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2016 at 10:59:41AM +0300, Matan Barak wrote:
>
>> I'm not at the office right now, but AFAIK it's attach_mcast, detach_mcast,
>> rereg_mr and all the destroy functions.
>
> I don't think we can change those three, I would be too scared that
> would break existing apps that don't serialize them.
>
> I think we need to change the kernel locking for those three cases to
> rely on a different lock so that the modify style operations can not
> return EBUSY.
>
> That seems like it should be simple enough? Can we use the lock in the
> kobj or something? Why is it like that today anyhow?
>

Yeah, I think it'll be safer to use lower level locking (like in kobj).

>>> I also think this should be stand-alone as part of the uobject rework
>>> series.. Again it seems like this benifits any approach.
>>
>> Yeah, but since the new infrastructure is going to do the locks
>> automatically for you, we'll ditch the locks in uverbs_cmd anyway.
>> Therefore, I don't see a real benefit refactoring uverbs_cmd and then
>> ditching all these changes.
>
> We still have to go through a transitional approach here, to me that
> means we should move existing uverbs closer to the new approach
> (particularly in terms of locking and code sharing), trial that in
> real apps, and then add the new api on that tested basis. We can't
> just abandon uverbs, and we probably shouldn't try to do a flag day
> convert either.
>

Well, another option (not saying it's a better one) is to develop the 
new ABI in a separate branch and try real world applications using it 
(with a modified libibverbs of course). This shall give use a feel if 
things are mature enough. The last step could be adding a write->ioctl 
interface. That's qualified to "flag day" conversion in the main branch.

Saying that, I see that advantages of a transitional approach. We need 
to balance between transitional approach and try avoiding write code 
that we know will be dumped anyway.

Lets decide on the development phases here after we have a clear idea on 
how the new ABI is going to look like and we could all work towards this 
approach.

> So I don't know what your plan is to 'ditch the locks' with the new
> infrastucture while maintaining the uverbs api..
>

Using a conversion layer of the old ABI to the new ABI. Move the current 
write locks to lower kobj level as you suggested.

> My preference is to see smaller patch series with clear goals that can
> be applied - and 'rework uverbs locking' seems to fit that bill quite
> well.
>
> For instance, if we are introducing a uobject type scheme like this
> series does then it should be another stand alone series that doesn't
> try and introduce the ioctl stuff..
>

Yeah, changes have a clear smaller goals and won't be changed 
dramatically as the ABI task is evolving should definitely go through a 
different patch-set.

>> No, it's not the same thing. SRCU protects device removal from command
>> execution. close_sem protects context destruction from command
>> execution.
>
> It is the same, device removal requires 'context destruction' as
> a precondition, so it should be able to ride on the same lock.
>
> The 'context destruction' for device removal is a bit special but it
> is still basically the same action as close(fd).
>

rechecked - you're right, both calls ib_uverbs_cleanup_ucontext.

>> You're correct that in the current state of the code, context is only closed
>> when a file is closed or when a device is removed, so it's protected.
>> However, if we want to add a destroy_context action - it becomes necessary.
>
> What would destroy_context do? Why would we need that?
>

If you want to break device != fd, you might want to destroy a device 
and start using the same fd with another device.

>> If we move to a per uverbs_file idr, contexts (either file context or client
>> context), we still need to sync destruction of these contexts with carrying
>> out actions. Since the uverbs_file outlives them, it's reasonable to put the
>> lock there.
>
> Are you proposing that all object destroy will be serialized?
>

When a process/device dies, I think it's reasonable to destroy objects 
in a serial way. I think it's reasonable that when a device is removed, 
you serialize this with handling commands on the same fd. Of course 
destroying unrelated objects could be done in parallel.

>> Currently, as far as I remember, modify isn't protected by the write lock
>> anyway. Besides that, nothing stops the user from syncing the actions.
>
> You can't make that argument when dealing with compat. We can't change
> something like the locking requirements in user space.
>

Of course, but if currently modify_qp uses read_lock - there's no change 
in user space locking requirement.

>>> While holding the lock. But that is a really ugly API. Nothing should be
>>> added to the idr until it is 100% initialized, so we don't need
>>> concurrency protection. What is the write lock doing at that point??
>>
>> We assume the enable function can't fail. Since adding something to idr
>> could fail, we preferred adding it first with live = 0 flag and then
>> enabling it.
>
> Why can't it fail?
>

Because in our v2 (to be sent soon) we only adds it to the type list and 
set the live flag.

>>>  uobj = uobj_alloc(file->ucontext, 0, sizeof(*uobj));
>>>  [.. full setup ..]
>>>  uobj_activate(uobj); // live = 1, list_add_tail, idr_add
>>>
>>>  resp.handle = uobj->id;
>>>  copy_to_user(..);
>>>
>>>  put_uobj(uobj);
>>>  return ret;
>>>
>>> err1:
>>>  uobj_deactivate(uobj);
>>> err2:
>>>  put_obj(uobj);
>>>
>>
>> I agree with the general schema, but I think idr_add should be done in
>> uobj_alloc as it can fail.
>
> In my version uobj_activate can fail, and we already have to have the
> goto-unwind infrastructure to cope with that (copy_to_user could
> fail), so I'm not sure why avoiding it would be helpful?
>

I think it should be the other way around - copy_to_user is done by the 
handler and uobj_activate is done by the infrastructure. Therefore, the 
general doesn't know how to roll back the command and I want to 
guarantee anything it does after calling the handler succeed.

> I also wonder if the above flow is enough to remove live? That always
> seemed like a strange approach to me, most idr users would just use in-idr
> as 'live' ...
>
>>> I would do the above sort of restructuring as another (mergable, even)
>>> patch, then rip out the locking.
>>
>> This locking is done automatically using the new infrastructure. The goal is
>> to remove all these locking semantics from the user handler.
>> Therefore, I don't think we should refactor uverbs_cmd and then delete all
>> locks from there.
>
> What happens to uverbs_cmd then? As I said above we still need to keep
> it around and it still need to fit with the new infrastructure. I'd
> rather see a patch flow that slowly transforms uverbs_cmd to a point
> where adding the new ioctl becomes a simpler patch.
>

IMHO, uverbs_cmd should become write_format->ioctl_format convertor.
We don't want to have two paths doing almost the same thing in two 
different ways.

> There is obvoisly a lot of in-kernel infrastructure work to do.
>

Yeah, that's why we're still in the RFC phase. I think we need to agree 
on how we are going to do things and get the general picture clear.

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
