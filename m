From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v3 05/28] IB/Verbs: Reform IB-core sa_query
Date: Tue, 14 Apr 2015 10:03:33 +0200
Message-ID: <552CC9D5.2030408@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB572.4040300@profitbricks.com> <1828884A29C6694DAF28B7E6B8A82373A8FC0A58@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC0A58-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/13/2015 08:45 PM, Hefty, Sean wrote:
>> @@ -1153,9 +1153,7 @@ static void ib_sa_add_one(struct ib_device *device)
>>  {
>>  	struct ib_sa_device *sa_dev;
>>  	int s, e, i;
>> -
>> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
>> -		return;
>> +	int count = 0;
>>
>>  	if (device->node_type == RDMA_NODE_IB_SWITCH)
>>  		s = e = 0;
>> @@ -1175,7 +1173,7 @@ static void ib_sa_add_one(struct ib_device *device)
>>
>>  	for (i = 0; i <= e - s; ++i) {
>>  		spin_lock_init(&sa_dev->port[i].ah_lock);
>> -		if (rdma_port_get_link_layer(device, i + 1) !=
>> IB_LINK_LAYER_INFINIBAND)
>> +		if (!rdma_tech_ib(device, i + 1))
> 
> Note for someone who cares.  This patch didn't introduce this problem, but I think the port number should be "i + s".

Actually I'm planning to cleanup the places play with 's' and 'e' too, for
example both cache.c and device.c implemented helper start_port() end_port()
with exactly the same logical, and there are also many places like here which
play with port number ugly, I'd like to refine these part later if no one else
interested :-P

Regards,
Michael Wang

> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
