From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Tue, 08 Jul 2014 10:11:06 +0200
Message-ID: <53BBA79A.9000000@acm.org>
References: <53B55E55.5040907@acm.org>	<53B55F1F.6000704@acm.org>	<CAJZOPZ+RPe8B_KhKZ-8-S6g871-EKQSnExZgsZ2Z+bo-9L=P9w@mail.gmail.com>	<53B67B0E.5070004@acm.org> <CAJZOPZJokriDMCAxnoXJo+RTRvtDquSMGpQThp8OoDnHjKU32A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJokriDMCAxnoXJo+RTRvtDquSMGpQThp8OoDnHjKU32A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/08/14 09:55, Or Gerlitz wrote:
> On Fri, Jul 4, 2014 at 12:59 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>>
>> [...] the blk-iopoll framework defers work to softirq
>> context. This means that a context switch from interrupt to softirq
>> context has to occur before SRP completion processing can start. Recent
>> measurements on current hardware have shown that such a context switch
>> takes about 0.5 microseconds. Since I prefer to keep the latency of SRP
>> I/O as low as possible I haven't looked further into using blk-iopoll for the SRP initiator driver.
> 
> In the same manner that SoftirqD is the right place to process
> received packets in the networking space, it should be
> the case for IO completions in the storage space too.  Note that
> typical packet latency in latest/fastest 10g NICs go below 5us
> when using NAPI so if we (== NIC drivers) are happy with the CS
> overhead there, we (== SCSI LLD storage drivers whose
> latency is in the area of 15-20us) should be happy here too.
> Specifically, the CS cost is amortized across multiple IOs.

Hello Or,

We might each be referring to different concepts here. What you are
referring to is average response time for QD > 1. What I was referring
to is average response time for QD = 1. The measurements I ran with fio
have shown that the response time for QD = 1 is lower when processing
completions in interrupt context compared to processing interrupts in
softirq context.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
