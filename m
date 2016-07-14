From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Thu, 14 Jul 2016 08:30:05 +0300
Message-ID: <5fdae959-5ab2-ee17-e36e-3642ddd3e6ce@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-5-git-send-email-matanb@mellanox.com>
 <20160712192345.GC8206@obsidianresearch.com>
 <081a02c0-0650-d0c2-494c-19a64b83cbc1@mellanox.com>
 <20160713163924.GA19657@obsidianresearch.com>
 <0959d391-75fb-75e8-ef2e-9d8c06b1b96f@mellanox.com>
 <20160713172116.GC19657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160713172116.GC19657-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13/07/2016 20:21, Jason Gunthorpe wrote:
> On Wed, Jul 13, 2016 at 07:57:04PM +0300, Matan Barak wrote:
>
>> Maybe instead of having an idr per device, it's better to have an idr per
>> uverbs file.
>
> Oh, I thought you were doing that already!
>
> Yes, the idr must be per ucontext, otherwise we create a big security
> problem. Access to one files object #'s cannot be allowed from another
> file.
>

We don't have a security problem, as the ucontext pointer is store on 
the uobject. Therefore, the uobject is returned only if it matches the 
current ucontext.

>> However, when a device is removed, we need to find all its related objects
>> and destroy them. In order to do that in a simple way, we could say that a
>> uverbs_file is either not bound to any rdma device or bound to a
>> single IB
>
> This is just more searching on the disassociate path. Search all
> ucontexts for any uobj connected to the victim device.
>
> If we drop the file == device scheme then we need a generic op to
> tell what device a uobj is associated with. All our kobjs already
> store this information, so it isn't a big deal.
>

I've thought about ditching the lists, but there's one fundamental 
problem. Keeping reference counts in kernel doesn't encompass dependency 
relations in the user space. For example, since memory windows could be 
bounded and unbounded from a MR, we need to delete all MWs before 
deleting the MRs.
Secondly, we could safely change the list to hlist. The memory overhead 
will be minimal (probably better than adding and IDR per type).

If we break the file == device scheme, it also requires a few new object 
types (for example, DEVICE and CLIENT object) to pass them from user-space.
So the flow might be using the QUERY ioctl code and query the 
devices/clients. Creating a device/client and get a IDR handle for that. 
For every IOCTL code (either device or client commands), you pass this 
idr handle as part of the ioctl code specific header.

However, does it really worth it? Do you see any usage of binding the 
same uverbs_file to several rdma devices?
If not, we could have a simpler approach of having a file either bounded 
to a device or not bounded to any device. We could still share the IDR 
with clients on the same fd, but they are all guaranteed to set or use 
this exact device.

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
