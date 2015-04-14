From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v3 04/28] IB/Verbs: Reform IB-core cm
Date: Tue, 14 Apr 2015 09:50:55 +0200
Message-ID: <552CC6DF.8070704@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB552.1030905@profitbricks.com> <20150413181248.GA2464@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150413181248.GA2464-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/13/2015 08:12 PM, ira.weiny wrote:
[snip]
>> -
>> -	if (rdma_node_get_transport(ib_device->node_type) != RDMA_TRANSPORT_IB)
>> -		return;
>> +	int count = 0;
> 
> I'm ok with this as an intermediate patch but going forward if we are going to
> have calls like 
> 
> static inline int cap_ib_cm_dev(struct ib_device *device)

Actually I really don't want to introduce this kind of helper, it's slow, ugly
and break the consistency, but I can't find a good way to avoid that...

For example the check inside cma_listen_on_dev(), how could we do per-port check
while don't even know which port will be used later...

> 
> Then I think we should have similar calls like
> 
> cap_ib_mad_dev(device)
> 
> Which eliminates the clean up below...

I'd like to avoid using such helper as long as possible :-P

> 
>>  
>>  	cm_dev = kzalloc(sizeof(*cm_dev) + sizeof(*port) *
>>  			 ib_device->phys_port_cnt, GFP_KERNEL);
>> @@ -3783,6 +3781,9 @@ static void cm_add_one(struct ib_device *ib_device)
>>  
>>  	set_bit(IB_MGMT_METHOD_SEND, reg_req.method_mask);
>>  	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
>> +		if (!rdma_ib_or_iboe(ib_device, i))
>> +			continue;
>> +
>>  		port = kzalloc(sizeof *port, GFP_KERNEL);
>>  		if (!port)
>>  			goto error1;
>> @@ -3809,7 +3810,16 @@ static void cm_add_one(struct ib_device *ib_device)
>>  		ret = ib_modify_port(ib_device, i, 0, &port_modify);
>>  		if (ret)
>>  			goto error3;
>> +
>> +		count++;
>>  	}
>> +
>> +	if (!count) {
>> +		device_unregister(cm_dev->device);
>> +		kfree(cm_dev);
>> +		return;
> 
> Here.
> 
> I worry about mistakes being made when we loop through only to find that none
> of the ports support the feature and then we have to clean up.  As this is
> initialization code I don't see any issue with looping through the ports 2
> times and making the code cleaner.

This style of logical could be found in other core module too, may be keep
consistent is not a bad idea?

After all, it's just initialization code which relatively rarely used :-)

Regards,
Michael Wang

> 
> This applies to the SA and CM modules as well.
> 
> However, in the ib_cm module you already have cap_ib_cm_dev(device) so you
> should use it at the start of cm_add_one.
> 
> Ira
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
