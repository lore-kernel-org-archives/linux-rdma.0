From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Tue, 8 Jul 2014 12:24:27 +0300
Message-ID: <53BBB8CB.2010300@mellanox.com>
References: <53B55E55.5040907@acm.org>	<53B55F1F.6000704@acm.org>	<CAJZOPZ+RPe8B_KhKZ-8-S6g871-EKQSnExZgsZ2Z+bo-9L=P9w@mail.gmail.com>	<53B67B0E.5070004@acm.org> <CAJZOPZJokriDMCAxnoXJo+RTRvtDquSMGpQThp8OoDnHjKU32A@mail.gmail.com> <53BBA79A.9000000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BBA79A.9000000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/07/2014 11:11, Bart Van Assche wrote:
> e might each be referring to different concepts here. What you are
> referring to is average response time for QD > 1. What I was referring
> to is average response time for QD = 1. The measurements I ran with fio
> have shown that the response time for QD = 1 is lower when processing
> completions in interrupt context compared to processing interrupts in
> softirq context.

I see, but wait, I had few arguments... among them the fact that the 
vast majority if not the entire set of networking drivers live well with 
this CS to softirqD over-head also for their ping-ping (~ QD=1) latency 
tests and their latency is ~3x small vs block drivers.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
