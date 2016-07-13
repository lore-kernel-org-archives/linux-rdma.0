From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Wed, 13 Jul 2016 19:57:04 +0300
Message-ID: <0959d391-75fb-75e8-ef2e-9d8c06b1b96f@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-5-git-send-email-matanb@mellanox.com>
 <20160712192345.GC8206@obsidianresearch.com>
 <081a02c0-0650-d0c2-494c-19a64b83cbc1@mellanox.com>
 <20160713163924.GA19657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160713163924.GA19657-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13/07/2016 19:39, Jason Gunthorpe wrote:
> On Wed, Jul 13, 2016 at 05:44:46PM +0300, Matan Barak wrote:
>
>> We can, but then every driver should declare the common objects
>> order by itself.  Maybe we could provide a macro that does this for
>> you (if you don't have any custom types interleaved).
>
> Hum, that seems so very fragile and complex..
>
> There are other ways to deal with destruction ordering. refcounts
> only for use during descruction might be easier. Repeatedly iterate
> over the uobject list deleting 0 refcount objects until the list is
> empty.
>
> So, eg when you create a MR on a PD then PD's destruct refcount gets
> ++'d, and when the MR is deleted it gets --'d. This naturally forces
> the needed ordering.
>

Yeah, that's nicer. We'll do that instead :)

>>> What use is tracking the ubojects in a per-type list? Do we ever
>>> iterate that way other than on global destruct?
>>>
>>
>> The only purpose of these lists are either ucontext destruction or device
>> removal (which ultimately deletes all ucontexts).
>> ucontext destruction requires list per ucontext x type.
>
> I wouldn't waste memory on optimizing destruction like that, just run
> over the idr repeatedly, matching against the object type.
>

Maybe instead of having an idr per device, it's better to have an idr 
per uverbs file. Doing that, if we decide to unify rdma-cm with the 
device itself, they can share the same idr. This gives us another 
advantage of destroying a ucontext without going over all opened objects.

However, when a device is removed, we need to find all its related 
objects and destroy them. In order to do that in a simple way, we could 
say that a uverbs_file is either not bound to any rdma device or bound 
to a single IB device (do you see any value of bounding a uverbs_file to 
several devices?). By this model you could have one ioctl code for 
device commands, another one for client commands (rdma-cm) and a third 
one for infrastructure based commands (query devices, query clients).

This is of course only relevant if we go for a unified fd for rdma-cm 
and rdma device.


> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
