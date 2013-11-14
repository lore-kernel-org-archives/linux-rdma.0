From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Wed, 13 Nov 2013 22:11:46 -0400
Message-ID: <CADPSxAi71wpxS+sUpFoVgyWwiP1KHYqz+_m1e-vgXG+mRKuUMA@mail.gmail.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
	<5281FFF9.5070705@gmail.com>
	<CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
	<5283C3B2.6010106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5283C3B2.6010106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 13, 2013 at 2:23 PM, Gabriele Svelto
<gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 12/11/2013 11:31, Anuj Kalia wrote:
>>
>> I believe the atomic operations would be a lot more expensive than
>> reads/writes. I'm targetting maximum performance so I don't want to
>> look that way yet.
>
>
> This sounds like premature optimization to me which as you know is the root
> of all evil :)
> Try using the atomic primitives, they have been designed specifically for
> this kind of scenario, and then measure their performance in the real world
> before spending time on optimizing something that might just be fast enough
> for your purposes (and far more robust). If you're already polling your CQs
> those operations will be *very* fast.
>

I'm working on a project where I'm trying to extract the maximum IOPS
from a server for an application. If atomic operations are even 2-X
slower than RDMA writes (which I'd expect because they involve a read
and a write), I can't use them. However, it would be interesting to
find their performance. I'll try that.

Thanks!
>  Gabriele
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
