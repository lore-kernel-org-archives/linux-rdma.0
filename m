From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v5 13/27] IB/Verbs: Reserve legacy transport type in 'dev_addr'
Date: Tue, 21 Apr 2015 10:05:38 +0200
Message-ID: <553604D2.80008@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <5534BAE8.9010805@profitbricks.com> <EE7902D3F51F404C82415C4803930ACD5DC44144@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC44144-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/21/2015 07:58 AM, Devesh Sharma wrote:
[snip]
>>
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>> index ebac646..6195bf6 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -244,14 +244,35 @@ static inline void cma_set_ip_ver(struct cma_hdr
>> *hdr, u8 ip_ver)
>>  	hdr->ip_version = (ip_ver << 4) | (hdr->ip_version & 0xF);  }
>>
>> +static inline void cma_set_legacy_transport(struct rdma_cm_id *id) {
>> +	switch (id->device->node_type) {
>> +	case RDMA_NODE_IB_CA:
>> +	case RDMA_NODE_IB_SWITCH:
>> +	case RDMA_NODE_IB_ROUTER:
>> +		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_IB;
> 
> What about IBOE transport, am I missing something here? As of today ocrdma exports node_type  as RDMA_NODE_IB_CA, here transport will be set to RDMA_TRANSPORT_IB,
> Should it be RDMA_TRANPORT_IBOE?

This part is actually just the old method we used to get transport type, I'm
not sure about the usage of this 'transport' so reserve the old way for it :-P

Actually I can't locate the place using this stuff in core layer, thus I guess it
may be used by user layer or the protocol, as long as these layer using the old
logical, we better don't touch anything ;-)

Regards,
Michael Wang

> 
>> +		break;
>> +	case RDMA_NODE_RNIC:
>> +		id->route.addr.dev_addr.transport =
>> RDMA_TRANSPORT_IWARP;
>> +		break;
>> +	case RDMA_NODE_USNIC:
>> +		id->route.addr.dev_addr.transport =
>> RDMA_TRANSPORT_USNIC;
>> +		break;
>> +	case RDMA_NODE_USNIC_UDP:
>> +		id->route.addr.dev_addr.transport =
>> RDMA_TRANSPORT_USNIC_UDP;
>> +		break;
>> +	default:
>> +		BUG();
>> +	}
>> +}
>> +
>>  static void cma_attach_to_dev(struct rdma_id_private *id_priv,
>>  			      struct cma_device *cma_dev)
>>  {
>>  	atomic_inc(&cma_dev->refcount);
>>  	id_priv->cma_dev = cma_dev;
>>  	id_priv->id.device = cma_dev->device;
>> -	id_priv->id.route.addr.dev_addr.transport =
>> -		rdma_node_get_transport(cma_dev->device->node_type);
>> +	cma_set_legacy_transport(&id_priv->id);
>>  	list_add_tail(&id_priv->list, &cma_dev->id_list);  }
>>
>> --
>> 2.1.0
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
>> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
