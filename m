From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Tue, 12 Nov 2013 06:31:04 -0400
Message-ID: <CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
	<5281FFF9.5070705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5281FFF9.5070705-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Gabriel,

Thanks for your reply.

That makes sense. This way, we have no consistency between the CPU's
view and the HCA's view - it all depends when the cache gets flushed
to RAM.

However, if the HCA performs reads from L3 cache, then everything
should be consistent, right? While ordering the writes, I think we can
assume that they are ordered till the cache hierarchy (with no
guarantees for when they appear in RAM). Ido Shamai (@Mellanox) told
me that RDMA writes go to L3 cache. This, plus on-chip memory
controllers make me think that reads should come from L3 cache too.

I believe the atomic operations would be a lot more expensive than
reads/writes. I'm targetting maximum performance so I don't want to
look that way yet.

--Anuj


On Tue, Nov 12, 2013 at 6:16 AM, Gabriele Svelto
<gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>  Hi Anuj,
>
>
> On 10/11/2013 11:46, Anuj Kalia wrote:
>>
>> How can this happen in the presence of memory barriers? With barriers,
>> A[i].counter should be updated later and therefore should always be
>> smaller than A[i].value.
>
>
> memory barriers such as mfence synchronize memory operations from the point
> of view of CPUs only. Practically this means that the stores you wrote might
> go out to memory in a different order than what the processor sees and
> external devices such as a PCIe HCAs might thus see a different ordering
> even in the presence of memory barriers.
>
> To ensure that an external devices sees your store in the order you meant
> you will need some form of external barrier though I do not know if it is
> possible at all in userspace and besides it will be a fragile solution.
>
> Instead I would suggest you to use verbs atomic operations such as
> IBV_WR_ATOMIC_CMP_AND_SWP and IBV_WR_ATOMIC_FETCH_AND_ADD to implement what
> you have in mind.
>
>  Gabriele
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
