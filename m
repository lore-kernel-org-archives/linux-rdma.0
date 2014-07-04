From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Fri, 04 Jul 2014 11:59:42 +0200
Message-ID: <53B67B0E.5070004@acm.org>
References: <53B55E55.5040907@acm.org>	<53B55F1F.6000704@acm.org> <CAJZOPZ+RPe8B_KhKZ-8-S6g871-EKQSnExZgsZ2Z+bo-9L=P9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+RPe8B_KhKZ-8-S6g871-EKQSnExZgsZ2Z+bo-9L=P9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/03/14 18:46, Or Gerlitz wrote:
> On Thu, Jul 3, 2014 at 4:48 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> [...]
>>
>> Limit the number of poll cycles per completion notification to preserve fairness
> 
> [...]
> 
> Any reason not to make use of the block layer NAPI like API for that
> (blk-iopoll http://lwn.net/Articles/346187/) ?

Hello Or,

As you maybe remember about four years ago I have been experimenting
with adding blk-iopoll support in the SRP initiator. What I learned at
that time is that the blk-iopoll framework defers work to softirq
context. This means that a context switch from interrupt to softirq
context has to occur before SRP completion processing can start. Recent
measurements on current hardware have shown that such a context switch
takes about 0.5 microseconds. Since I prefer to keep the latency of SRP
I/O as low as possible I haven't looked further into using blk-iopoll
for the SRP initiator driver.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
