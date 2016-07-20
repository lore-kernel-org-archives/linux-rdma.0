From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Wed, 20 Jul 2016 11:01:18 +0300
Message-ID: <9727f6e6-47fd-fb0a-537f-6264e8d742a9@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-5-git-send-email-matanb@mellanox.com>
 <20160712192345.GC8206@obsidianresearch.com>
 <081a02c0-0650-d0c2-494c-19a64b83cbc1@mellanox.com>
 <20160713163924.GA19657@obsidianresearch.com>
 <0959d391-75fb-75e8-ef2e-9d8c06b1b96f@mellanox.com>
 <20160713172116.GC19657@obsidianresearch.com>
 <5fdae959-5ab2-ee17-e36e-3642ddd3e6ce@mellanox.com>
 <20160714164121.GA2046@obsidianresearch.com>
 <a1fcb1a7-0028-329a-d34a-ca8b52323916@mellanox.com>
 <20160719203609.GD16042@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160719203609.GD16042-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/07/2016 23:36, Jason Gunthorpe wrote:
> On Tue, Jul 19, 2016 at 05:05:46PM +0300, Matan Barak wrote:
>
>> According to the IB spec, a CI could choose either to return an error or to
>> move MWs to orphaned MWs (and make sure any access to these MWs will be
>> blocked). Some hardwares might implement the first approach and keep
>> reference from MRs to MWs in hardware (without having a way to query that in
>> software). In these cases, you can't force this unbound (as you don't know
>> if they were unbound because of remote invalidate).
>
> Ugh, I don't why that was let in the spec, from an app perspective you
> have to assume the annoying behavior...
>

I agree.

>>> The MW case could be handled specially with a simple priority field.
>
>> So you suggest having a priority field in the uobject and iterate over the
>> IDR freeing by order. Seems simple enough.
>
> That is one option..
>
>>>> So the flow might be using the QUERY ioctl code and query the
>>>> devices/clients. Creating a device/client and get a IDR handle for that. For
>>>> every IOCTL code (either device or client commands), you pass this idr
>>>> handle as part of the ioctl code specific header.
>>>
>>> Yes, as I said, we pretty much have to do that already, and it
>>> wouldn't be on every ioctl, just certain top level ones like PDs.
>
>> I meant querying the possible devices or clients. Meaning, introduce another
>> ioctl code that is used to get all available clients and devices.
>
> Not necessarily, the 'create device' could accept the existing sysfs
> device string as the starting point, libibverbs already has that
> information.
>

But how would you know if rdma-cm is loaded and available? Don't we want 
to have a decent query interface rather than iterating through sysfs?
I agree that it could be lower priority than the rest.

>> The point here isn't about unifying rdma-cm and uverbs. Assuming we do that,
>> we could still allow a user to bind fd to several devices or just to a
>> single device.
>
> I don't understand this comment.
>
> If we keep /dev/uverbs0 then that has to remain 1:1 with a device
> because that is our permissions model.
>
> If we move to /dev/rdma_uapi, then that would support 1:N devices.
>
> I can't see a reason to do both concurrently even though that would be
> easy enough technically..
>

I meant moving to /dev/rdma_uapi, but when you fopen the device and get 
a fd, you could either have fd->NULL or fd->single_rdma_dev mapping.
It's a little bit simpler, however, not that much from just doing 1:N 
mapping.

>> It's simpler as you don't need to tie objects in the IDR to an IB device (as
>> there's only one option). In addition, you don't have to pass a device
>> handle to all commands. You could either have a bounded device and then it's
>> clear what you're using or you didn't bind any device and then all device
>> specific commands (except init_ucontext) fail. Client commands (i.e rdma-cm)
>> could either fail or succeed, depending on their requirements. It's a closer
>> model to what we have today - uverbs_file points to an ib_dev (which might
>> be NULL).
>
> I don't see todays model as actually be very good, and those don't
> seem like very strong reasons. An extra argument on a couple of
> commands (and PD create is the only one that springs to mind) seems
> trivial. libiverbs already keeps track of this.
>

I agree that if we move to /dev/rdma_uapi file, the gap from doing 1:N 
mapping isn't large.

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
