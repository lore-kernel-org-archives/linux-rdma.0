From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v4 04/27] IB/Verbs: Reform IB-core cm
Date: Thu, 16 Apr 2015 14:55:35 +0200
Message-ID: <552FB147.8060407@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com> <552F6D67.1070509@profitbricks.com> <552FAE87.50303@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FAE87.50303-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/16/2015 02:43 PM, Hal Rosenstock wrote:
[snip]
>> +
>> +		count++;
>>  	}
>> +
>> +	if (!count) {
>> +		device_unregister(cm_dev->device);
>> +		kfree(cm_dev);
>> +		return;
> 
> Nit: alternatively, this could be goto at end of this routine where
> there is same 2 calls. I think Jason made this comment on earlier set of
> these patches.

Thanks for the notify, I guess I missed it, my bad :-P

Will be "goto free" in next version.

Regards,
Michael Wang

> 
> -- Hal
> 
>> +	}
>> +
>>  	ib_set_client_data(ib_device, &cm_client, cm_dev);
>>  
>>  	write_lock_irqsave(&cm.device_lock, flags);
>> @@ -3825,6 +3835,9 @@ error1:
>>  	port_modify.set_port_cap_mask = 0;
>>  	port_modify.clr_port_cap_mask = IB_PORT_CM_SUP;
>>  	while (--i) {
>> +		if (!rdma_ib_or_iboe(ib_device, i))
>> +			continue;
>> +
>>  		port = cm_dev->port[i-1];
>>  		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
>>  		ib_unregister_mad_agent(port->mad_agent);
>> @@ -3853,6 +3866,9 @@ static void cm_remove_one(struct ib_device *ib_device)
>>  	write_unlock_irqrestore(&cm.device_lock, flags);
>>  
>>  	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
>> +		if (!rdma_ib_or_iboe(ib_device, i))
>> +			continue;
>> +
>>  		port = cm_dev->port[i-1];
>>  		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
>>  		ib_unregister_mad_agent(port->mad_agent);
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
