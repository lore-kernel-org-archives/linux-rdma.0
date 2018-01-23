From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Tue, 23 Jan 2018 14:42:01 +0200
Message-ID: <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hi,

Hey Oren,

> Today host and target stacks will respond to RDMA device reset (or plug out
> and plug in) by cleaning all resources related to that device, and sitting
> idle waiting for administrator intervention to reconnect (host stack) or
> rebind subsystem to a port (target stack).
> 
> I'm thinking that maybe the right behaviour should be to try and restore
> everything as soon as the device becomes available again. I don't think a
> device reset should look different to the users than ports going down and up
> again.

Hmm, not sure I fully agree here. In my mind device removal means the
device is going away which means there is no point in keeping the 
controller around...

AFAIK device resets usually are expected to quiesce inflight I/O,
cleanup resources and restore when the reset sequence completes (which 
is what we do in nvme controller resets). I'm not sure I understand why
RDMA device resets manifest as DEVICE_REMOVAL events to ULPs (via
rdma_cm or .remove_one via ib_client API). I think the correct interface
would be suspend/resume semantics for RDMA device resets (similar to pm
interface).

I think that it would make a much cleaner semantics and ULPs should be
able to understand exactly what to do (which is what you suggested
above).

CCing linux-rdma.

> At the host stack we already have a reconnect flow (which works great when
> ports go down and back up). Instead of registering to ib_client callback
> rdma_remove_one and clean up everything, we could respond to the
> RDMA_CM_EVENT_DEVICE_REMOVAL event and go into that reconnect flow.

Regardless of ib_client vs. rdma_cm, we can't simply perform normal
reconnects because we have dma mappings we need to unmap for each
request in the tagset which we don't teardown in every reconnect (as
we may have inflight I/O). We could have theoretically use reinit_tagset
to do that though.

Personally I think ib_client is much better than the rdma_cm
DEVICE_REMOVAL event interface because:
(1) rdma_cm is per cm_id which means we effectively only react to the
first one and the rest are nops which is a bit awkward
(2) it requires special handling for resource cleanup with respect to
the cm_id removal which must be destroyed within the DEVICE_REMOVAL
event by returning non-zero return value from the event handler (as
rdma_destroy_id() would block from the event_handler context) and
must not be done in the removal sequence (which is the normal flow).

Both of these make unnecessary complications which are much cleaner
with ib_client interface. see Steve's commit e87a911fed07 ("nvme-rdma: 
use ib_client API to detect device removal")

> 
> In the reconnect flow the stack already repeats creating the cm_id and
> resolving address and route, so when the RDMA device comes back up, and
> assuming it will be configured with the same address and connected to the same
> network (as is the case in device reset), connections will be restored
> automatically.

As I said, I think that the problem is the interface of RDMA device
resets. IMO, device removal means we need to delete all the nvme
controllers associated with the device.

If we were to handle hotplug events where devices come into the system,
the correct way would be to send a udev event to userspace and not keep
stale controllers around with hope they will come back. userspace is a
much better place to keep a state with respect to these scenarios IMO.

> At the target stack things are even worse. When the RDMA device resets or
> disappears the softlink between the port and the subsystem stays "hanging". It
> does not represent an active bind, and when the device will come back with the
> same address and network it will not start working (even though the softlink
> is there). This is quite confusing to the user.

Right, I think we would need to reflect port state (active/inactive) via
configfs and nvmetcli could reflect it in its UI.

> What I suggest here is to implement something similar to the reconnect flow at
> the host, and repeat the flow that is doing the rdma_bind_addr. This way,
> again, when the device will come back with the same address and network the
> bind will succeed and the subsystem will become functional again. In this case
> it makes sense to keep the softlink during all this time, as the stack really
> tries to re-bind to the port.

I'm sorry but I don't think that is the correct approach. If the device
is removed than we break the association and do nothing else. As for
RDMA device resets, this goes back to the interface problem I pointed
out.

> These changes also clean the code as RDMA_CM applications should not be
> registering as ib_clients in the first place...

I don't think that there is a problem in rdma_cm applications
registering to the ib_client API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
