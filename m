From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Fri, 1 May 2015 09:28:40 +0300
Message-ID: <CAAKD3BBGQwZ_Ainm6MSQjSkaXsJd9M5Vo4oarTLyFiVMQVS5_Q@mail.gmail.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
	<9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
	<CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
	<553DF294.4070507@mellanox.com>
	<CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
	<553F931F.6000302@mellanox.com>
	<20150428174312.GB5497@obsidianresearch.com>
	<5540F8F4.5010906@dev.mellanox.co.il>
	<20150429164847.GA12781@obsidianresearch.com>
	<5541E5ED.7000606@mellanox.com>
	<20150430172606.GA32666@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150430172606.GA32666-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 30, 2015 at 8:26 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Apr 30, 2015 at 11:21:01AM +0300, Matan Barak wrote:
>
>> ib_unregister_device calls the remove function with device_mutex
>> help. In addition, ib_enum_roce_ports_of_netdev does the same. Every
>> interesting netdev/inet/inet6 event that's handled in roce_gid_mgmt
>> triggers ib_enum_roce_ports_of_netdev by using the workqueue (for
>> example, netdevice_event->*work*->netdevice_event_work_handler->ib_enum_roce_ports_of_netdev).
>
> So, okay, now it is very clear. This should have been described
> explicitly in the kref commit message, for instance:
>
>  ...
>
>  Later commits in this series are going to extend the use of
>  device_mutex via ib_enum_roce_ports_of_netdev resulting in ...
>  .. To solve this deadlock introduce ....
>
> Part of the job of the patch author is to make review work better by
> highlighting the most troublesome areas, remember we have more patch
> authors than reviewers so work must be pushed onto the author side.
>
> Lets look at the original commit message provided:
>
>  Previously. we used device_mutex lock in order to protect
>  the device's list.
>
>   ** 'previously' is wrong, this patch does nothing to change what
>       device_mutex covers, it still protects the device_list and still
>       protects the client_list
>
>  That means that in order to guarantee a
>  device isn't freed while we use it, we had to lock all
>  devices.
>
>   ** No, locking the device_mutex does nothing to protect a device
>      from being freed. The existing kref does that. The device_mutex
>      protects the device_list from mutation, and
>      ib_enum_roce_ports_of_netdev must hold it when it iterates over
>      that list.
>
>      It prevents a device from being unregistered.
>      Accurate specificity is important in these commit messages.
>      Otherwise nobody understands what is being described.
>
>  Adding a kref per IB device. Before an IB device
>  is unregistered, we wait before its not held anymore.
>
>   ** Well, that is what the patch did, but the commit message is
>      supposed to explain *why* too
>
> Do you understand why this is so confusing?
>

I agree, it should have been clarified better. The "why" is as important as the
"what" and an accurate reason could have make review's life easier.
I'll fix that. Thanks.

>> You could argue that flush_workqueue isn't needed, but that let's
>> look at the following flow:
>
> No, I wouldn't argue that, all the async work obviously needs to
> cancel or complete during remove(), that's what I've been saying.
>
>> There might be some ways around it - for example, introduce another
>> workqueue for roce_rescan_device and flush this workqueue only.
>> Every way has its advantages and disadvantages.
>
> I don't see that either, like I keep saying, all work must complete,
> more work queues don't really seem to help that.
>

I think this is a possible solution, as all works but the "rescan" work
aren't device specific. That means that after we move the rescan work
to another workqueue and synchronize it in the client->remove function,
we could be sure the device won't be used by this client anymore.

The rest of the works only iterate on the *existing* device list. Since the
ib_unregister_device
(a) lock (b) iterate over client->remove (c) remove from list (d) free
(e) unlock
all roce_gid_cache's works won't find it in the list and we'll be safe.

Regarding ib_unregister_client - if we guarantee that after each
client->remove(dev)
dev isn't used in this client, we actually guarantee that after removing all IB
devices no IB device will be used (induction).

What do you think?

>> I think it's problematic that device_mutex can't be held in a work
>> as *most* client works are synchronized when the a device is being
>> unregistered. It could affect future clients as well.
>
> But until this patch set added ib_enum_roce_ports_of_netdev the
> device_mutex would never conflict with anything a client could do.
>
> So, ultimtely, this is really a self created problem, and infact, the
> problem lies with the introduction of ib_enum_roce_ports_of_netdev -
> adding a new use of the device_mutex that is not register/unregister
> related exposes the design limitations of that mutex *that Roland
> clearly explained in a giant comment!*
>

I agree, while it's a general problem - it was first introduced by using
device_mutex in an asynchronous context (that should be flushed in
the remove function).

> So we need to fix that problem, not add a new mechanism. Off the top
> of my head:
>  - Split device_mutex into client_mutex and device_mutex,
>    hold only the client_mutex when working with the client_list.

Seems like a possible nice solution. I'll look into that.

>  - Convert device_mutex into a r/w sem

I'm not sure this will solve the problem, as besides the new enumerate
devices function, all existing functions update the list - so we'll have
read-while-write scenario and we'll be in the exact same condition.

>  - Use a different scheme to match netdevs for
>    ib_enum_roce_ports_of_netdev, that doesn't rely on holding
>    device_mutex during query
>

We could switch to RCU protected list or something similar,
but I honestly don't think it worth the complexity.

> The first two seem really simple to me. I'd do that.
>

Agree, but please consider also the addition of another
workqueue as a possible solution. It *does* (seem) to answer
all of your concerns and could be safer and cause less code changes.

>> >No, it really isn't, from the attached drivers perspective after
>> >unregister_netdevice returns the driver is not allowed to operate the
>> >net device anymore. netdev_wait_allrefs is part of making
>> >unregister_netdevice synchronous.
>> >
>> >The same is true of our IB client attaches, after a client returns
>> >from remove it is not allowed to operate the IB device anymore.
>> >
>>
>> ib_unregister_device is synchronous in the exact same manner - after
>> it returns, no client operate on the IB device.
>> wait_for_completion(&device->free) was added for this exact reason.
>
> No, you are missing the layering here.
>
> In this context ib_client is the *driver*, and like all drivers once
> it's remove method returns the driver can no longer expect the
> attached device is operable, and must guarentee the driver's .text is
> freeable.
>
>> >That is a standard idiom, and we'd need a huge compelling reason to go
>> >away from that.
>>
>> A device can be remove if and only if it's reference count is zero.
>> That's the only point where we guarantee nobody uses it anymore.
>> That's a standard idiom as well.
>
> No actually. The kref is tied to the memory lifetime, and is pretty
> much universal that the memory lifetime and device operable lifetime
> (ie still registered) are very different things.
>
> This is why using a kref to describe anything other than memory
> lifetime is not correct, and two krefs in a structure is obviously
> nonsense.
>
> Some places use an 'active count + completion', like netdev, kernfs,
> etc to track active users and use that to block an unregister path,
> but that isn't a kref.
>

kref just hides an atomic refcount - so you're actually saying using
the abstraction contradicts the kernel object's lifetime strategy?
I get that, I could have used an atomic refcount - but I agree that it's
worth exploring other solutions the will preserve the invariant of
client->remove being synchronous.

> Okay, lets break down and understand why this is an important standard
> guarentee, for our specific case. Lets generalize this scenario a
> bit. roce_gid_cache isn't modular, but lets assume it is (after all
> the intent of this patch is to weaken the remove() invarient for
> everyone.)
>
> On module remove it will call ib_unregister_client, and when
> ib_unregister_client returns the module will be become unloaded.
>
> The invariant for module unload requires no module code to be
> running and no module code to be runnable in future -- ie all work
> must be complete or canceled.
>
> module unload always calls the driver's remove function, that is a
> standard idiom.
>
> So, the first thing to notice, the kref patch didn't actually change
> ib_unregister_client - it doesn't
> 'wait_for_completion(&device->free)'.  Immediately we have a
> architectural bug, modules can exit while they have outstanding code
> runnable in their .text. Oops.
>

I tend to agree. The __exit function flushes the workqueue (so eventually
we guarentee that no code will execute before the module is unloaded).
IMHO, after ib_unregister_client returns, the module could still run code
(this is why the __exit handler exists), but it's not allowed to use any
data of the module which unregistered it, meaning - we can't allow it to
use any IB device.

> Next, we realize we cannot fix this by waiting on device->free, it is
> ostensibly a general lock that all clients use on the ib_device, we
> need something isolated to this client.
>
> Finally, we realize if we can isolate something to one client, then
> the client can handle it during it's own remove() function, we don't
> need core support.
>
> Thus, the way out is to make ib_client.remove() completely synchronous
> and *guarentee* that the module's .text will never be used again after
> remove() returns. Obviously this means all work is complete or
> canceled.
>
> *THIS* is why driver remove is idiomatically always synchronous in the
> kernel.
>

Ok, I get your point, thanks. I'll keep that call synchronous. The two
options which are on the table right now are:
(a) split the device_mutex to device_mutex and client_mutex.
      ib_unregister_device first grabs only client_mutex and after it called
      client->remove it grabs device->mutex to the rest of the work.
(b) Introduce another workqueue for all device-specific events
(actually, only rescan).
      This allows us to flush only this workqueue without waiting for any
      work which needs device_mutex.

> Please appreciate how much time it takes to explain all of this :(
> Just fix it already :(
>

I really appreciate it, again - thanks for looking at this and writing
this *long*
explanation.

> Jason
> --

Thanks a lot,
Matan

> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
