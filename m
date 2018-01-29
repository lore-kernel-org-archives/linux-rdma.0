From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next v2 15/16] IB/core: Map iWarp AH type to undefined
 in rdma_ah_find_type
Date: Mon, 29 Jan 2018 08:24:52 -0500
Message-ID: <368266b8-ae79-3804-38d0-e7730126b532@intel.com>
References: <20180126211126.12097.47410.stgit@scvm10.sc.intel.com>
 <20180126213043.12097.88707.stgit@scvm10.sc.intel.com>
 <20180126223252.GE23869@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126223252.GE23869-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/26/2018 5:32 PM, Jason Gunthorpe wrote:
>>   	if (rdma_protocol_roce(dev, port_num))
>>   		return RDMA_AH_ATTR_TYPE_ROCE;
>> +	else if (rdma_protocol_iwarp(dev, port_num))
>> +		return RDMA_AH_ATTR_TYPE_UNDEFINED;
>>   	else if ((rdma_protocol_ib(dev, port_num)) &&
>>   		 (rdma_cap_opa_ah(dev, port_num)))
>> 		return RDMA_AH_ATTR_TYPE_OPA;
> 
> Let's not add an UNDEFINED type in the middle of an if casecade with an all
> other cases fall through please:

Sounds reasonable to me, we will fix that up.

> I'm not sure sending all these unrelated patches in one series is such
> a helpful idea. Lot of trouble for everyone just to respond to one
> minor comment.
> 
> This series looks like 4-5 topics to me:
>   - Optimize HFI
>   - 2 patches realted to the interrupt race
>   - Random driver fixes
>   - IPoIB fix
>   - This patch

Totally agree. I have been just batching up all our patches at once and 
sending as that is what Doug preferred at one time. Driver is a 
different animal though at this point I guess. So I can start breaking 
them into logical series again.

How about just drop this series from patchworks and I'll resubmit with 
it broken out into multiple patch sets?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
