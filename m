From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v4 03/27] IB/Verbs: Reform IB-core mad/agent/user_mad
Date: Thu, 16 Apr 2015 14:51:42 +0200
Message-ID: <552FB05E.2020707@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com> <552F6D53.70804@profitbricks.com> <552FAE66.6020900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FAE66.6020900-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,Hal

Thanks for the comments :-)

On 04/16/2015 02:43 PM, Hal Rosenstock wrote:
[snip]
>> @@ -3102,9 +3102,6 @@ static void ib_mad_remove_device(struct ib_device *device)
>>  {
>>  	int i, num_ports, cur_port;
>>  
>> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
>> -		return;
>> -
>>  	if (device->node_type == RDMA_NODE_IB_SWITCH) {
>>  		num_ports = 1;
>>  		cur_port = 0;
>> @@ -3113,6 +3110,9 @@ static void ib_mad_remove_device(struct ib_device *device)
>>  		cur_port = 1;
>>  	}
>>  	for (i = 0; i < num_ports; i++, cur_port++) {
>> +		if (!rdma_ib_or_iboe(device, i))
> 
> Shouldn't this be:
> 		if (!rdma_ib_or_iboe(device, cur_port))
> ?

Agree, actually it's unnecessary to use both i and cur_port, we can just use the
same way inside ib_mad_init_device() ;-)

Regards,
Michael Wang

> 
> -- Hal
> 
>> +			continue;
>> +
>>  		if (ib_agent_port_close(device, cur_port))
>>  			dev_err(&device->dev,
>>  				"Couldn't close port %d for agents\n",
>> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
>> index 928cdd2..71fc8ba 100644
>> --- a/drivers/infiniband/core/user_mad.c
>> +++ b/drivers/infiniband/core/user_mad.c
>> @@ -1273,9 +1273,7 @@ static void ib_umad_add_one(struct ib_device *device)
>>  {
>>  	struct ib_umad_device *umad_dev;
>>  	int s, e, i;
>> -
>> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
>> -		return;
>> +	int count = 0;
>>  
>>  	if (device->node_type == RDMA_NODE_IB_SWITCH)
>>  		s = e = 0;
>> @@ -1296,11 +1294,21 @@ static void ib_umad_add_one(struct ib_device *device)
>>  	umad_dev->end_port   = e;
>>  
>>  	for (i = s; i <= e; ++i) {
>> +		if (!rdma_ib_or_iboe(device, i))
>> +			continue;
>> +
>>  		umad_dev->port[i - s].umad_dev = umad_dev;
>>  
>>  		if (ib_umad_init_port(device, i, umad_dev,
>>  				      &umad_dev->port[i - s]))
>>  			goto err;
>> +
>> +		count++;
>> +	}
>> +
>> +	if (!count) {
>> +		kobject_put(&umad_dev->kobj);
>> +		return;
>>  	}
>>  
>>  	ib_set_client_data(device, &umad_client, umad_dev);
>> @@ -1308,8 +1316,12 @@ static void ib_umad_add_one(struct ib_device *device)
>>  	return;
>>  
>>  err:
>> -	while (--i >= s)
>> +	while (--i >= s) {
>> +		if (!rdma_ib_or_iboe(device, i))
>> +			continue;
>> +
>>  		ib_umad_kill_port(&umad_dev->port[i - s]);
>> +	}
>>  
>>  	kobject_put(&umad_dev->kobj);
>>  }
>> @@ -1322,8 +1334,10 @@ static void ib_umad_remove_one(struct ib_device *device)
>>  	if (!umad_dev)
>>  		return;
>>  
>> -	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i)
>> -		ib_umad_kill_port(&umad_dev->port[i]);
>> +	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i) {
>> +		if (rdma_ib_or_iboe(device, i))
>> +			ib_umad_kill_port(&umad_dev->port[i]);
>> +	}
>>  
>>  	kobject_put(&umad_dev->kobj);
>>  }
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
