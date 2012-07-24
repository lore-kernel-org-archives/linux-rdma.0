From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: Kernel panic under 3.2.14 Xen dom0 and SCST trunk
Date: Wed, 25 Jul 2012 06:14:55 +1000
Message-ID: <CAOzFzEi8rnbTyomWEByJL3J_7QnCJSj-yWhMdh8d5mHnBRLVzw@mail.gmail.com>
References: <CAOzFzEjjbofQZyubdpH10WKeoE3-grMVdEOqJhJtbRtMdgCr=Q@mail.gmail.com>
	<500EE108.2090605@acm.org>
	<CAOzFzEiiiEsUqLjRM-TFsVZhQyvQi=abX0ufS6obvuZxtWgB-Q@mail.gmail.com>
	<500EFEB3.5020806@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <500EFEB3.5020806-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 25 July 2012 05:59, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 07/24/12 19:50, Joseph Glanville wrote:
>> On 25 July 2012 03:53, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>>> On 07/24/12 15:16, Joseph Glanville wrote:
>>>> I have been seeing this KP occur about every 3 days on our staging cluster.
>>>> I am not exactly sure what the root cause would be.. I assume this
>>>> would be a bug in SCST.
>>>> The kernel is a 3.2.14 with Ubuntu patch series applied and Bart's SRP
>>>> HA patches.
>>>
>>> It would help if you could tell us a bit more about your setup. It looks
>>> like SCST is running in dom0, and an IB workload in domU ? If so, which
>>> workload was running in domU ?
>>
>> There is no IB workload in the domU's.
>> In this particular case there are 2 dom0s connected together both
>> acting as SRP targets and initators.
>> Their are sometimes vms running on these dom0s but they aren't
>> currently in production so they aren't doing very much at the moment.
>>
>> The workload is typically one of adding and removing luns to
>> ini_groups, rescan the host to ensure they are removed cleanly etc.
>> As far as I can tell this would have to manifest as a race condition
>> as it can go for about 2 or so weeks without occuring.
>> Also worth noting is that I have a similar setup running on 2.6.32
>> with no issues also a pvops dom0 using SCST and ib_srp.
>>
>> Could it be your patch series introduced the bug? Those are the only
>> patches we have in our tree that effect SRP.
>
> You might be hitting a device removal bug in the SCSI core. It would be
> appreciated if you could retest with the srp-ha branch of this kernel
> tree: http://github.com/bvanassche/linux. That tree contains Linux
> kernel 3.5 + SCSI 3.6-rc1 + latest (yet to be posted) srp-ha patch series.
>
> Bart.

Will do.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
