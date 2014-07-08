From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Tue, 08 Jul 2014 17:45:38 +0300
Message-ID: <53BC0412.3070706@dev.mellanox.co.il>
References: <53B55E55.5040907@acm.org> <53B55F1F.6000704@acm.org>	 <1404407103.32754.3.camel@haswell.thedillows.org>	 <53B6868A.3070705@acm.org> <1404501176.16296.18.camel@haswell.thedillows.org> <53BBF6E3.3040403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BBF6E3.3040403-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/8/2014 4:49 PM, Bart Van Assche wrote:

<SNIP>
> Hello Dave,
>
> Thanks for digging up this information and also for sharing it. This is
> interesting. What I noticed is that the in the SRP target driver
> attached to the previous e-mail ("srptest.c") one command at a time is
> processed. However, in the SRP target driver I ran my own tests with
> (based on SCST) multiple SCSI commands are processed simultaneously by a
> single thread. A finite state machine is associated with each SCSI
> command and events like IB work completions trigger transitions of that
> state machine. So that might be a possible explanation why my
> measurement results were different.
>
> However, before I repost (a variant of) this patch I will try to find a
> way to combine the advantages of interrupt-based processing (low
> latency) and the blk-iopoll approach (minimal time spent in interrupt
> context).

Hey Bart, Dave & Or (CC'ing Jens)

Or and myself did some experiments with blk-iopoll for iSER some time ago.
We noticed that we got better overall performance using this type of 
"internal" budget logic (vs. blk-iopoll approach)
while stats clearly show more interrupts occurring. The reason for that 
is still unknown to us given that iSER completion
context is softirq to begin with (tasklet).

We didn't submit the "internal" budget solution since we believe that 
the correct way to go is using blk-iopoll.
So IMHO the correct way to continue here is with the blk-iopoll approach 
trying to resolve the unexplained performance
gaps we got in the past.

I do agree with Or that SRP should benefit using blk-iopoll as well, the 
canonical Latency lost here seems pretty minor
against the gain in decreasing the amount of interrupts.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
