From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Tue, 19 Jul 2016 17:05:46 +0300
Message-ID: <a1fcb1a7-0028-329a-d34a-ca8b52323916@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-5-git-send-email-matanb@mellanox.com>
 <20160712192345.GC8206@obsidianresearch.com>
 <081a02c0-0650-d0c2-494c-19a64b83cbc1@mellanox.com>
 <20160713163924.GA19657@obsidianresearch.com>
 <0959d391-75fb-75e8-ef2e-9d8c06b1b96f@mellanox.com>
 <20160713172116.GC19657@obsidianresearch.com>
 <5fdae959-5ab2-ee17-e36e-3642ddd3e6ce@mellanox.com>
 <20160714164121.GA2046@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160714164121.GA2046-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14/07/2016 19:41, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2016 at 08:30:05AM +0300, Matan Barak wrote:
>
>> We don't have a security problem, as the ucontext pointer is store on the
>> uobject. Therefore, the uobject is returned only if it matches the current
>> ucontext.
>
> That still allows a different security problem, idrs have bounded
> capacity and now unprivileged users can exhaust them for all users.
>

Right, but that's an existing security issue.

>> I've thought about ditching the lists, but there's one fundamental problem.
>> Keeping reference counts in kernel doesn't encompass dependency relations in
>> the user space. For example, since memory windows could be bounded and
>> unbounded from a MR, we need to delete all MWs before deleting the MRs.
>> Secondly, we could safely change the list to hlist. The memory overhead will
>> be minimal (probably better than adding and IDR per type).
>
> Bleck, that is a terrible API. Destroying the MR should return
> associated MW's to unbound.
>
> Is MR the only case of this? I can't think of much else that uses the
> WQ that way..
>

According to the IB spec, a CI could choose either to return an error or 
to move MWs to orphaned MWs (and make sure any access to these MWs will 
be blocked). Some hardwares might implement the first approach and keep 
reference from MRs to MWs in hardware (without having a way to query 
that in software). In these cases, you can't force this unbound (as you 
don't know if they were unbound because of remote invalidate).

AFAIK, MW are the only case.

> I think the lists should always go, always use repeated iteration. If
> you really can't make refcount work then use a type compare instead,
> but I don't think we don't need the overhead of keeping lists to
> optimize destruction.
>
> The MW case could be handled specially with a simple priority field.
>

So you suggest having a priority field in the uobject and iterate over 
the IDR freeing by order. Seems simple enough.

>> If we break the file == device scheme, it also requires a few new object
>> types (for example, DEVICE and CLIENT object) to pass them from
>> user-space.
>
> Don't know what a CLIENT object is, but I think we always need to
> have a DEVICE object even if there is only allowed 1 device object per
> FD.
>

By saying CLIENT I mean rdma-cm or other such users which can handle 
rdma devices and provide services.

> We need the device object to match what ibv_open_device does and
> provide a basis for sending device specific driver commands and
> issuing device specific queries.
>
> If it is a singleton per-fd or created doesn't really matter from an
> API design perspective.
>

If it's a singleton per-fd, you don't need to pass it per action. If you 
get an action on this fd - you know exactly to which device you should 
delegate it.

>> So the flow might be using the QUERY ioctl code and query the
>> devices/clients. Creating a device/client and get a IDR handle for that. For
>> every IOCTL code (either device or client commands), you pass this idr
>> handle as part of the ioctl code specific header.
>
> Yes, as I said, we pretty much have to do that already, and it
> wouldn't be on every ioctl, just certain top level ones like PDs.
>

I meant querying the possible devices or clients. Meaning, introduce 
another ioctl code that is used to get all available clients and devices.

>> However, does it really worth it? Do you see any usage of binding the same
>> uverbs_file to several rdma devices?
>
> I'd like to hear more arguments on this point.
>
> The main value I see is combining rdma_cm and uverbs into one fd & IDR, and
> that requires allowing multiple devices per fd.
>
> This seems simpler for clients and helps move things in the direction
> Sean was talking about where all events can all be aggregated into one
> poll loop.
>
> As far as I can tell, the only downside to that is we loose the
> per-device permissions on /dev/infiniband/uverbsX, which don't really
> work today anyhow.
>

The point here isn't about unifying rdma-cm and uverbs. Assuming we do 
that, we could still allow a user to bind fd to several devices or just 
to a single device.

>> If not, we could have a simpler approach of having a file either bounded to
>> a device or not bounded to any device. We could still share the IDR with
>> clients on the same fd, but they are all guaranteed to set or use this exact
>> device.
>
> Why is this simpler?
>

It's simpler as you don't need to tie objects in the IDR to an IB device 
(as there's only one option). In addition, you don't have to pass a 
device handle to all commands. You could either have a bounded device 
and then it's clear what you're using or you didn't bind any device and 
then all device specific commands (except init_ucontext) fail. Client 
commands (i.e rdma-cm) could either fail or succeed, depending on their 
requirements. It's a closer model to what we have today - uverbs_file 
points to an ib_dev (which might be NULL).

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
