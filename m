From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v3 04/28] IB/Verbs: Reform IB-core cm
Date: Tue, 14 Apr 2015 09:57:00 +0200
Message-ID: <552CC84C.60101@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB552.1030905@profitbricks.com> <20150413181248.GA2464@phlsvsds.ph.intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FC0A3A@ORSMSX109.amr.corp.intel.com> <20150413192930.GA18587@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150413192930.GA18587-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/13/2015 09:29 PM, Jason Gunthorpe wrote:
> On Mon, Apr 13, 2015 at 06:40:35PM +0000, Hefty, Sean wrote:
>>>> -	if (rdma_node_get_transport(ib_device->node_type) !=
>>> RDMA_TRANSPORT_IB)
>>>> -		return;
>>>> +	int count = 0;
>>>
>>> I'm ok with this as an intermediate patch but going forward if we are
>>> going to
>>> have calls like
>>>
>>> static inline int cap_ib_cm_dev(struct ib_device *device)
>>
>> I would rather keep everything to checking per port, not per device.
>> Specifically, because we have code that does this:
> 
> Argee.
> 
> I asked Michael for it and stand by it, the property is per-port, not
> per device. Having the per-device tests just muddles the logic, look
> at the trouble Sean notices in #10 when we are now forced to think of
> things clearly.

The only per-dev checking left is all included in #24 (now may be #10 too),
which is inside:

1. cma_listen_on_dev
2. ib_ucm_add_one

I can't find a good way to apply per-port check in this two, seems like
they are at the stage which not related to port yet... any ideas on how
to improve that?

Regards,
Michael Wang

> 
> Jason
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
