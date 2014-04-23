From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: IB/cma: Make timeout dependent on the subnet timeout
Date: Wed, 23 Apr 2014 08:55:22 -0400
Message-ID: <5357B83A.5070000@dev.mellanox.co.il>
References: <53566BB5.5030203@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F2F15@ORSMSX109.amr.corp.intel.com> <5357B25D.2000108@dev.mellanox.co.il> <5357B626.8050209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5357B626.8050209-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/23/2014 8:46 AM, Bart Van Assche wrote:
> On 04/23/14 14:30, Hal Rosenstock wrote:
>> On 4/22/2014 2:41 PM, Hefty, Sean wrote:
>>>> +static u8 cma_get_ib_subnet_timeout(struct rdma_cm_id *id)
>>>> +{
>>>> +	struct ib_port_attr attr;
>>>> +	int ret;
>>>> +
>>>> +	ret = ib_query_port(id->device, id->port_num, &attr);
>>>> +	return ret == 0 ? attr.subnet_timeout : 18;
>>>> +}
>>>
>>> Can we query the port once (or only on a change) and cache the result, rather than querying it for every request?
>>
>> To be IBA spec compliant, SubnetTimeout could change so some new local
>> event would need to be added and handled to avoid the requerying.
>>
>> In practice, however, that's not very likely AFAIK.
> 
> Thanks Sean and Hal for the feedback.
> 
> Regarding SubnetTimeout changes: the code in
> drivers/infiniband/core/cache.c already queues a work request after each
> port state change. Inside that work request e.g. the P_Key cache is
> updated. Would it be acceptable to modify ib_cache_update() such that it
> also queries the port attributes and caches these ? Cached port
> attributes could e.g. be stored in struct ib_port. However, doing so
> would probably require to protect the port_list member in struct
> ib_device against concurrent modifications of that list by the sysfs code.

Unfortunately, it's possible that the subnet timeout could be modified
without any of the local events that currently trigger cache update
occurring.

-- Hal

> Bart.
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
