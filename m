From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Tue, 14 Apr 2015 17:51:32 +0200
Message-ID: <552D3784.3010706@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB5AC.6050101@profitbricks.com> <20150413192701.GA19112@obsidianresearch.com> <20150413194602.GA21467@phlsvsds.ph.intel.com> <20150413200138.GC19112@obsidianresearch.com> <20150414141806.GA7354@phlsvsds.ph.intel.com> <552D2519.6000500@profitbricks.com> <20150414154012.GA13852@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150414154012.GA13852-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/14/2015 05:40 PM, ira.weiny wrote:
> On Tue, Apr 14, 2015 at 04:32:57PM +0200, Michael Wang wrote:
>>
>>
>> On 04/14/2015 04:18 PM, ira.weiny wrote:
>> [snip]
>>>  
>>>  /**
>>> - * cap_ib_cm_dev - Check if any port of device has the capability Infiniband
>>> - * Communication Manager.
>>> + * cap_ib_cm_any_port - Check if any port of the device has Infiniband
>>> + * Communication Manager (CM) support.
>>>   *
>>>   * @device: Device to be checked
>>>   *
>>> - * Return 0 when all port of the device don't support Infiniband
>>> - * Communication Manager.
>>> + * Return 1 if any port of the device supports the IB CM.
>>>   */
>>> -static inline int cap_ib_cm_dev(struct ib_device *device)
>>> +static inline int cap_ib_cm_any_port(struct ib_device *device)
>>>  {
>>>         int i;
>>
>> I think we maybe able to get rid of this helper according to Sean's suggestion :-)
>>
>> We just need to check the port 1 of HCA see if it support ib cm, seems like
>> currently there is no case that port 1 support cm while others doesn't.
> 
> But that moves us in the wrong direction.  If we later support port 2 without
> port 1 that code will be broken.

I'm not sure if we should sacrifice the consistency at this moment for such 'future'
capability... maybe we can leave such reform work to those who introduce the new capability?

Regards,
Michael Wang

> 
> Ira
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
