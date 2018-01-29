From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Mon, 29 Jan 2018 22:36:39 +0200
Message-ID: <26056a83-2f81-6b56-7bbf-fcecfc4518d6@grimberg.me>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
 <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
 <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
 <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
 <1516904022.27592.187.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516904022.27592.187.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I *think* for SRP this is already the case.  The SRP target uses the
> kernel LIO framework, so if you bounce the device under the SRPt layer,
> doesn't the config get preserved?  So that when the device came back up,
> the LIO configuration would still be there and the SRPt driver would see
> that? Bart?

I think you're right. I think we can do that if we keep the listener
cm_id device node_guid and when a new device comes in we can see if we 
have a cm listener on that device and re-listen. That is a good idea
Doug.

> For the SRP client, I'm almost certain it will try to reconnect since it
> uses a user space daemon with a shell script that restarts the daemon on
> various events.  That might have changed...didn't we just take a patch
> to rdma-core to drop the shell script?  It might not reconnect
> automatically with the latest rdma-core, I'd have to check.  Bart should
> know though...

srp driver relies on srp_daemon to discover and connect again over the
new device. iSER relies on iscsiadm to reconnect. I guess it should be
the correct approach for nvme as well (which we don't have at the
moment)...

>>>> AFAIK device resets usually are expected to quiesce inflight I/O,
>>>> cleanup resources and restore when the reset sequence completes (which is
>>>> what we do in nvme controller resets).
> 
> I think your perspective here might be a bit skewed by the way the NVMe
> stack is implemented (which was intentional for speed as I understand
> it).  As a differing example, in the SCSI stack when the LLD does a SCSI
> host reset, it resets the host but does not restore or restart any
> commands that were aborted.  It is up to the upper layer SCSI drivers to
> do so (if they chose, they might send it back to the block layer).  From
> the way you wrote the above, it sounds like the NVMe layer is almost
> monolithic in nature with no separation between upper level consumer
> layer and lower level driver layer, and so you can reset/restart all
> internally.  I would argue that's rare in the linux kernel and most
> places the low level driver resets, and some other upper layer has to
> restart things if it wants or error out if it doesn't.

That is the case for nvme as well, but I was merely saying that device
reset is not really a device removal. And this makes it hard for the ULP
to understand what to do (or for me at least...)

>>>>   I'm not sure I understand why
>>>> RDMA device resets manifest as DEVICE_REMOVAL events to ULPs (via
>>>> rdma_cm or .remove_one via ib_client API). I think the correct interface
>>>> would be suspend/resume semantics for RDMA device resets (similar to pm
>>>> interface).
> 
> No, we can't do this.  Suspend/Resume is not the right model for an RDMA
> device reset.  An RDMA device reset is a hard action that stops all
> ongoing DMA regardless of its source.

Suspend also requires that.

> Those sources include kernel
> layer consumers, user space consumers acting without the kernel's direct
> intervention, and ongoing DMA with remote RDMA peers (which will throw
> the remote queue pairs into an error state almost immediately).  In the
> future it very likely could include RDMA between things like GPU offload
> processors too.  We can't restart that stuff even if we wanted to.  So
> suspend/resume semantics for an RDMA device level reset is a non-
> starter.

I see. I can understand the argument "we are stuck with what we have"
for user-space, but does that mandate that we must live with that for
kernel consumers as well? Even if the semantics is confusing? (Just
asking, its only my opinion :))

>>>> I think that it would make a much cleaner semantics and ULPs should be
>>>> able to understand exactly what to do (which is what you suggested
>>>> above).
>>>>
>>>> CCing linux-rdma.
>>>
>>> Maybe so. I don't know what's the "standard" here for Linux in general and
>>> networking devices in particular. Let's see if linux-rdma agree here.
>>
>> I would like to hear more opinions on the current interface.
> 
> There is a difference between RDMA device and other network devices.
> The net stack is much more like the SCSI stack in that you have an upper
> layer connection (socket or otherwise) and a lower layer transport and
> the net core code which is free to move your upper layer abstraction
> from one lower layer transport to another.  With the RDMA subsystem,
> your upper layer is connecting directly into the low level hardware.  If
> you want a semantic that includes reconnection on an event, then it has
> to be handled in your upper layer as there is no intervening middle
> layer to abstract out the task of moving your connection from one low
> level device to another (that's not to say we couldn't create one, and
> several actually already exist, like SMC-R and RDS, but direct hooks
> into the core ib stack are not abstracted out and you are talking
> directly to the hardware).  And if you want to support moving your
> connection from an old removed device to a new replacement device that
> is not simply the same physical device being plugged back in, then you
> need an addressing scheme that doesn't rely on the link layer hardware
> address of the device.

Actually, I didn't suggest that at all. I fully agree that the ULP needs
to cooperate with the core and the HW as its holding physical resources.
All I suggested is that the core would reflect that the device is
resetting and not reflect that the device is going away, and after that
a new device comes in, that happens to be the same device...

> As a user of things like iSER/SRP/NVMe, I would personally like
> connections to persist across non-fatal events.  But the RDMA stack, as
> it stands, can't reconnect things for you, you would have to do that in
> your own code.

Again, I fully agree. Didn't mean that the core would handle everything
for the consumer of the device at all. I just think that the interface
can improve such that the consumers life (and code) would be easier.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
