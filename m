From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V5 01/10] RDMA/core: Refactor IDR to be per-device
Date: Wed, 9 Nov 2016 11:34:15 +0200
Message-ID: <f96e5510-8d93-4926-8491-1194187c1dbd@mellanox.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-2-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0A445F@ORSMSX109.amr.corp.intel.com>
 <20161107235516.GE7002@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161107235516.GE7002-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/11/2016 01:55, Jason Gunthorpe wrote:
> On Fri, Oct 28, 2016 at 10:53:13PM +0000, Hefty, Sean wrote:
>>> The current code creates an IDR per type. Since types are currently
>>> common for all vendors and known in advance, this was good enough.
>>> However, the proposed ioctl based infrastructure allows each vendor
>>> to declare only some of the common types and declare its own specific
>>> types.
>>>
>>> Thus, we decided to implement IDR to be per device and refactor it to
>>> use a new file.
>>
>> I think this needs to be more abstract.  I would consider
>> introducing the concept of an 'ioctl provider', with the idr per
>> ioctl provider.  You could then make each ib_device an ioctl
>> provider.  (Just embed the structure).  I believe this will be
>> necessary to support the rdma_cm, ib_cm, as well as devices that
>> export different sets of ioctls, where an ib_device isn't
>> necessarily available.
>>
>> Essentially, I would treat plugging into the uABI independent from
>> plugging into the kernel verbs API.  Otherwise, I think we'll end up
>> with multiple ioctl 'frameworks'.
>
> Matan,
>
> I think you should change things so that all the *general* code uses
> 'urdma_' as a prefix instead of uverbs_. Only use uverbs_ on things
> that truely only apply to uverbs. This will make things much
> clearer how the code sharing is expected to work with rdma_cm
>

Yeah, I'll change the general infrastructure to be urdma.

> Sean is right, this shows why having the IDR be per device does not
> work, rdma-cm really does need a per-file or global IDR - both
> approaches should really be the same, and I think per-file has better
> locking characteristics, so I'd recommend that.
>

Eventually, I think ending up with an ioctl_provider and ioctl_context 
is the way to go here. The IDR and locks should be per ioctl_provider.
In ib_device world, an ioctl_provider is indeed an ib_device. In rdma_cm 
world, the ioctl_provider is the rdma_cm global file.
However, I think in order to do such large amount of changes, lets push 
things incrementally. We could start with the current schema, where it's 
ib_device specific, lay out the foundations and then refactor this to be 
more abstract when adding rdma_cm. We could even do that refactoring 
before enabling the ioctl interface, so if we see that something in the 
model is broken, we could still back-off.
Sounds reasonable?

> Jason
>

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
