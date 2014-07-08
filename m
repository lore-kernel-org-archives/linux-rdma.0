From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Tue, 08 Jul 2014 15:49:23 +0200
Message-ID: <53BBF6E3.3040403@acm.org>
References: <53B55E55.5040907@acm.org> <53B55F1F.6000704@acm.org>	 <1404407103.32754.3.camel@haswell.thedillows.org>	 <53B6868A.3070705@acm.org> <1404501176.16296.18.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404501176.16296.18.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/04/14 21:12, David Dillow wrote:
> On Fri, 2014-07-04 at 12:48 +0200, Bart Van Assche wrote:
>> Do you still have that measurement data available and/or the scripts
>> that were used to collect that data?
> 
> I had looked for them before posting and thought they were lost to the
> sands of time, but your pointer to the email gave me the proper search
> terms, thanks!
> 
> srptest.c is a simple test target that fakes a single-LUN, read-only
> target. It's special, in that it does not actually transfer any data, it
> just responds to the SRP command as though it had. It's intended to do
> the minimum work necessary to try push the IOP bottlenecks into the
> initiator.
> 
> run_tests.sh runs the battery, which was saved into an appropriately
> named file for parse.{sh,awk} to process into a csv, which gets turned
> into all.ods.
> 
> In the runs from then, batching (using your patch from that time) saw a
> 2 to 11% decrease in the number of IOPS, though it isn't perfectly clear
> what the noise level is from the pivot table in the spreadsheet. Using
> iopoll (weight of 128, 10, and with the batched CQ patch [not sure of
> weight, probably 10]) shows some scattered small improvements in IOPS
> (1-2%) but quickly fell to a 30+% loss of IOPS. I never had time to
> investigate further.
> 
> In none of the cases did the test target seem to become the bottleneck.
> 
>>  I'd like to have a look at which
>> test you ran such that I can repeat that test with Linus' master tree. A
>> lot has been changed since kernel 2.6.38 was released, e.g. several more
>> SCSI core and SRP initiator driver optimizations have been accepted
>> upstream since then.
> 
> Certainly, things have changed in the code, but I'll be pleasantly
> surprised if the relative results change much -- the only changes were
> the batching, and/or the conversion to iopoll.
> 
> Also, these tests were on QDR on Connect-X (maybe X2) hardware if I
> recall correctly. It would be interesting to see it on X3, or Connect-IB
> to see if they respond better to the changes -- I could easily see the
> batching being pretty hardware-specific in terms of tuning.

Hello Dave,

Thanks for digging up this information and also for sharing it. This is
interesting. What I noticed is that the in the SRP target driver
attached to the previous e-mail ("srptest.c") one command at a time is
processed. However, in the SRP target driver I ran my own tests with
(based on SCST) multiple SCSI commands are processed simultaneously by a
single thread. A finite state machine is associated with each SCSI
command and events like IB work completions trigger transitions of that
state machine. So that might be a possible explanation why my
measurement results were different.

However, before I repost (a variant of) this patch I will try to find a
way to combine the advantages of interrupt-based processing (low
latency) and the blk-iopoll approach (minimal time spent in interrupt
context).

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
