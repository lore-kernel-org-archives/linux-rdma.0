From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Sun, 03 May 2015 12:05:19 +0300
Message-ID: <5545E4CF.1090401@dev.mellanox.co.il>
References: <553DF294.4070507@mellanox.com> <CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com> <553F931F.6000302@mellanox.com> <20150428174312.GB5497@obsidianresearch.com> <5540F8F4.5010906@dev.mellanox.co.il> <20150429164847.GA12781@obsidianresearch.com> <5541E5ED.7000606@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373A8FC929B@ORSMSX109.amr.corp.intel.com> <20150430175252.GB32666@obsidianresearch.com> <CAAKD3BCJbUAMYhBzwuQFct=cRSXnGC=ELzNkvw2X04a4UipQwQ@mail.gmail.com> <20150501173643.GC17940@obsidianresearch.com>
Reply-To: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150501173643.GC17940-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/1/2015 8:36 PM, Jason Gunthorpe wrote:
> On Fri, May 01, 2015 at 09:34:24AM +0300, Matan Barak wrote:
>
>>> This current scheme is just so ugly, there are so many wonky
>>> possibilities. What happens if I remove an IP and then add a new one?
>>> The GID index will eventually be re-used, and QPs bound to that gid
>>> index will silently change source IPs. Horrible.
>>
>> This should be handled by the vendor's driver/other future ib_core part.
>> This patchset introduces roce_gid_cache that manages the GID table and
>> notify vendors about GID changes.
>>
>> The vendor needs to:
>> (a) Move all QPs that use GID x to error state when GID x is deleted from
>>        the table.
>> (b) Change all QPs that use GID x to use a special invalid GID entry.
>> (c) Don't delete GIDs that are being used by a QP.
>
> What about AH's for UD?
>

The plan is to have read-only memory-mapped AHs for UD. The kernel will
create AH with a sequence counter. This AH will be mapped as read-only
memory to the user-space. When sending, the user-space will atomically 
use this AH. If a GID is changed, the kernel will update this GID index 
internally. That's a long-term goal.

> What about clients that discover and then hold the GID index
> internally?
>
> What about the impossible to fix race of returing the GID index in the
> work completion and translating that back to an IP?
>
> It is a terrible scheme, Sean is right, the clients should work with
> the actual sock addr, somehow, at least kernel side. Converting from a
> sockaddr to a gid index cannot really be done without some kind of
> lock and ref count scheme.

This is the current behavior as well. The current patch-set doesn't make
it any worse or better. We don't expect to fix all world's problems.
We could add reference-count in a later patchset. Working with sockaddr
has its own (similar) problems - if the net-device's IP is changed -
using a sockaddr will just use an old incorrect IP address (which by
now could be prohibited by the administrator).

>
> At the very least, that should be the starting point, if we can't get
> there then patch on a case by case basis why.
>

I agree - we don't want to regress, but we only add the roce_gid_cache 
in this patchset (next version will postpone adding RoCE V2 to later 
patchset).

> Jason
>

Matan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
