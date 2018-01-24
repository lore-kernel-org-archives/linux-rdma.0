From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Wed, 24 Jan 2018 22:52:04 +0200
Message-ID: <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
 <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
 <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> Today host and target stacks will respond to RDMA device reset (or plug
>>> out
>>> and plug in) by cleaning all resources related to that device, and sitting
>>> idle waiting for administrator intervention to reconnect (host stack) or
>>> rebind subsystem to a port (target stack).
>>>
>>> I'm thinking that maybe the right behaviour should be to try and restore
>>> everything as soon as the device becomes available again. I don't think a
>>> device reset should look different to the users than ports going down and
>>> up
>>> again.
>>
>>
>> Hmm, not sure I fully agree here. In my mind device removal means the
>> device is going away which means there is no point in keeping the controller
>> around...
> 
> The same could have been said on a port going down. You don't know if it will
> come back up connected to the same network...

That's true. However in my mind port events are considered transient,
and we do give up at some point. I'm simply arguing that device removal
has different semantics. I don't argue that we need to support it.

>> AFAIK device resets usually are expected to quiesce inflight I/O,
>> cleanup resources and restore when the reset sequence completes (which is
>> what we do in nvme controller resets). I'm not sure I understand why
>> RDMA device resets manifest as DEVICE_REMOVAL events to ULPs (via
>> rdma_cm or .remove_one via ib_client API). I think the correct interface
>> would be suspend/resume semantics for RDMA device resets (similar to pm
>> interface).
>>
>> I think that it would make a much cleaner semantics and ULPs should be
>> able to understand exactly what to do (which is what you suggested
>> above).
>>
>> CCing linux-rdma.
> 
> Maybe so. I don't know what's the "standard" here for Linux in general and
> networking devices in particular. Let's see if linux-rdma agree here.

I would like to hear more opinions on the current interface.

>> Regardless of ib_client vs. rdma_cm, we can't simply perform normal
>> reconnects because we have dma mappings we need to unmap for each
>> request in the tagset which we don't teardown in every reconnect (as
>> we may have inflight I/O). We could have theoretically use reinit_tagset
>> to do that though.
> 
> Obviously it isn't that simple... Just trying to agree on the right direction
> to go.

Yea, I agree. It shouldn't be too hard also.

>>> In the reconnect flow the stack already repeats creating the cm_id and
>>> resolving address and route, so when the RDMA device comes back up, and
>>> assuming it will be configured with the same address and connected to the
>>> same
>>> network (as is the case in device reset), connections will be restored
>>> automatically.
>>
>>
>> As I said, I think that the problem is the interface of RDMA device
>> resets. IMO, device removal means we need to delete all the nvme
>> controllers associated with the device.
> 
> Do you think all associated controllers should be deleted when a TCP socket
> gets disconnected in NVMe-over-TCP? Do they?

Nope, but that is equivalent to QP going into error state IMO, and we
don't do that in nvme-rdma as well.

There is a slight difference as tcp controllers are not responsible for
releasing any HW resource nor standing in the way of the device to reset
itself. In RDMA, the ULP needs to cooperate with the stack, so I think
it would be better if the interface would map better to a reset process
(i.e. transient).

>> If we were to handle hotplug events where devices come into the system,
>> the correct way would be to send a udev event to userspace and not keep
>> stale controllers around with hope they will come back. userspace is a
>> much better place to keep a state with respect to these scenarios IMO.
> 
> That's the important part I'm trying to understand the direction we should go.
> First, let's agree that the user (admin) expects a simple behaviour:

No argues here..

> if a configuration was made to connect with a remote storage, the stack (driver,
> daemons, scripts) should make an effort to keep those connections whenever
> possible.

True, and in fact Johannes suggested a related topic for LSF:
http://lists.infradead.org/pipermail/linux-nvme/2018-January/015159.html

For now, we don't have a good way to auto-connect (or auto-reconnect)
for IP based nvme transports.

> Yes, it could be a userspace script/daemon job. But I was under the impression
> that this group tries to consolidate most (all?) of the functionality into the
> driver, and not rely on userspace daemons. Maybe a lesson learnt from iSCSI?

Indeed that is a guideline that was taken early on. But
auto-connect/auto-discovery is not something I think we'd like to
implement in the kernel...

> You mean the softlink should disappear in this case?
> It can't stay as it means nothing (the bond between the port and the subsystem
> is gone forever the way it is now).

I meant that we expose a port state via configfs. As for device hotplug,
maybe the individual transports can propagate udev event to userspace to
try to re-enable the port or something... Don't have it all figured
out..

>>> What I suggest here is to implement something similar to the reconnect
>>> flow at
>>> the host, and repeat the flow that is doing the rdma_bind_addr. This way,
>>> again, when the device will come back with the same address and network
>>> the
>>> bind will succeed and the subsystem will become functional again. In this
>>> case
>>> it makes sense to keep the softlink during all this time, as the stack
>>> really
>>> tries to re-bind to the port.
>>
>>
>> I'm sorry but I don't think that is the correct approach. If the device
>> is removed than we break the association and do nothing else. As for
>> RDMA device resets, this goes back to the interface problem I pointed
>> out.
> 
> Are we in agreement that the user (admin) expects the software stack to keep
> this bound when possible (like keeping the connections in the initiator case)?
> After all, the admin has specifically put the softlink there - it expresses
> the admin's wish.

It will be the case if port binds to INADDR_ANY :)

Anyways, I think we agree here (at least partially). I think that we
need to reflect port state in configfs (nvmetcli can color it red),
and when a device completes reset sequence we get an event that tells
us just that we we send it to userspace and re-enable the port...

> We could agree here too that it is the task of a userspace daemon/script. But
> then we'll need to keep the entire configuration in another place (meaning
> configfs alone is not enough anymore),

We have nvmetcli for that. we just need a reactor to udev.

> constantly compare it to the current configuration in configfs, and make the adjustments.

I would say that we should have it driven from changes from the
kernel...

> And we'll need the stack to remove the symlink, which I still think is an odd
> behaviour.

No need to remove the symlink.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
