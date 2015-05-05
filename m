From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFC PATCH 3/5] IB/core: Convert cap_ib_mad to core_cap_flags
 bit mask
Date: Tue, 05 May 2015 10:00:13 +0200
Message-ID: <5548788D.8050708@profitbricks.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com> <1430720099-32512-4-git-send-email-ira.weiny@intel.com> <20150504184610.GB20586@obsidianresearch.com> <20150504224342.GD10115@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504224342.GD10115-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 05/05/2015 12:43 AM, ira.weiny wrote:
[snip]
> 
>>
>>>  static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
>>>  {
>>> -	return rdma_ib_or_iboe(device, port_num);
>>> +	return !!(device->core_cap_flags[port_num] & RDMA_CORE_CAP_IB_MAD);
>>
>>
>> 'bool' is OK in the kernel, just use that instead of !! - in fact all of
>> thse cap returns should return bool. Michael should fix that in his
>> series too.
> 
> Michael?

Ok, I will use bool in next version :-)

Regards,
Michael Wang

> 
> Ira
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
