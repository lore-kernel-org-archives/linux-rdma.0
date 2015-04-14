From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v3 10/28] IB/Verbs: Reform cm related part in IB-core
 cma
Date: Tue, 14 Apr 2015 10:35:34 +0200
Message-ID: <552CD156.9060709@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB60F.60109@profitbricks.com> <1828884A29C6694DAF28B7E6B8A82373A8FC0ACF@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC0ACF@ORSMSX109.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, "Weiny, Ira" <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/13/2015 09:25 PM, Hefty, Sean wrote:
>> @@ -1037,17 +1033,13 @@ void rdma_destroy_id(struct rdma_cm_id *id)
>>  	mutex_unlock(&id_priv->handler_mutex);
>>
>>  	if (id_priv->cma_dev) {
>> -		switch (rdma_node_get_transport(id_priv->id.device-
>>> node_type)) {
>> -		case RDMA_TRANSPORT_IB:
>> +		if (rdma_ib_or_iboe(id_priv->id.device, id_priv->id.port_num))
> 
> A listen id can be associated with a device without being associated with a port (see the listen_any_list). 
Some other check is needed to handle this case.  I guess the code could check the first port on the device
(replace port_num with hardcoded value 1).  Then we wouldn't be any more broken than the code already is.
(The 'break' is conceptual, not practical.)

Agree, seems like this is very similar to the case of cma_listen_on_dev() which
do not associated with any particular port in #24.

If the port 1 is enough to present the whole device's cm capability, maybe we can
get rid of cap_ib_cm_dev() too?

And maybe cap_ib_cm(device, device->node_type == RDMA_NODE_IB_SWITCH ? 0:1) would
be safer?

Regards,
Michael Wang


> 
> This appears to be highlighting an architectural flaw in the iboe integration.
> 
>> {
>>  			if (id_priv->cm_id.ib)
>>  				ib_destroy_cm_id(id_priv->cm_id.ib);
>> -			break;
>> -		case RDMA_TRANSPORT_IWARP:
>> +		} else if (rdma_tech_iwarp(id_priv->id.device,
>> +					   id_priv->id.port_num)) {
>>  			if (id_priv->cm_id.iw)
>>  				iw_destroy_cm_id(id_priv->cm_id.iw);
>> -			break;
>> -		default:
>> -			break;
>>  		}
>>  		cma_leave_mc_groups(id_priv);
>>  		cma_release_dev(id_priv);
> 
>  - Sean
> 
