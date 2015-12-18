From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] bject: IB Core: Display extended counter set if
 available
Date: Fri, 18 Dec 2015 08:52:12 -0500
Message-ID: <56740F8C.4060703@dev.mellanox.co.il>
References: <20151217195255.334854705@linux.com>
 <20151217195312.334770847@linux.com> <567316F7.9030707@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512171527060.22782@east.gentwo.org>
 <56732D97.2080303@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512171649070.22782@east.gentwo.org>
 <567342F5.5090000@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512180737150.32514@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1512180737150.32514-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/18/2015 8:39 AM, Christoph Lameter wrote:
> On Thu, 17 Dec 2015, Hal Rosenstock wrote:
> 
>>> +	if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH) {
>>> +		/* We have extended counters */
>>> +
>>> +		if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF)
>>> +			/* But not the IETF ones */
>>> +			return &pma_group_noietf;
>>
>> These 2 capability bits are mutually exclusive so I think it should be:
>>
>> 	if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH) {
>> 		/* We have extended counters */
>> 		return &pma_group_ext;
>>   	}
>>
>> 	if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF)
>> 		/* But not the IETF ones */
>> 		return &pma_group_noietf;
> 
> This case would then use the 64 bit counters despite of the
> IB_PMA_CLASS_CAP_EXT_WIDTH not being set.

Yes, IB_PMA_CLASS_CAP_EXT_WIDTH means all extended counters including
IETF ones whereas IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF means extended
counters without IETF ones ([uni multi]cast [rcv xmit] pkts).

> 
>> 	}
>>
>> 	return &pma_group;
>>
>>> +
> 
> The tables contain all the counters each. So we would need another table
> of counters that has the ietf counters but not the 64 bit extended ones?

I'm not following what you mean. I thought pma_group_noietf and
pma_group_ext take care of the 2 different options for extended counters
(with the error counters needed from the mandatory PortCounters) and
pma_group is when neither of the extended counter capabilities is
indicated.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
