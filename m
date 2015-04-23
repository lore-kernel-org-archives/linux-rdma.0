From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 09/27] IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
Date: Thu, 23 Apr 2015 11:25:29 +0200
Message-ID: <5538BA89.6090709@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <5534BA7C.2010600@profitbricks.com> <20150421231958.GA15893@phlsvsds.ph.intel.com> <55375011.7010805@profitbricks.com> <20150422162833.GB1494@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422162833.GB1494@phlsvsds.ph.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ira.weiny" <ira.weiny@intel.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/22/2015 06:28 PM, ira.weiny wrote:
[snip]
> 
>>
>> link_layer_show() was supposed to report the same info to user
>> space as usual, so user tool don't have to change anything :-)
> 
> We need to expose the "cap_*" functionality to userspace which can then convert
> to this interface and stop relying on inferring support based on the link
> layer.  But that is a separate issue from correctly reporting the link layer.
> 
> The link layer should be reported correctly from the drivers "get_link_layer"
> call.

I get your point :-) link_layer_show() and ib_uverbs_query_port() do
only need the link layer type rather then a mgmt check, modification
on these two will be dropped in next version.

Regards,
Michael Wang

> 
> Ira
> 
>>
>> Regards,
>> Michael Wang
>>
>>>
>>> Ira
>>>
>>>>  		return sprintf(buf, "%s\n", "InfiniBand");
>>>> -	case IB_LINK_LAYER_ETHERNET:
>>>> +	else
>>>>  		return sprintf(buf, "%s\n", "Ethernet");
>>>> -	default:
>>>> -		return sprintf(buf, "%s\n", "Unknown");
>>>> -	}
>>>>  }
>>>>  
>>>>  static PORT_ATTR_RO(state);
>>>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
>>>> index a9f0489..5dc90aa 100644
>>>> --- a/drivers/infiniband/core/uverbs_cmd.c
>>>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>>>> @@ -515,8 +515,10 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
>>>>  	resp.active_width    = attr.active_width;
>>>>  	resp.active_speed    = attr.active_speed;
>>>>  	resp.phys_state      = attr.phys_state;
>>>> -	resp.link_layer      = rdma_port_get_link_layer(file->device->ib_dev,
>>>> -							cmd.port_num);
>>>> +	resp.link_layer      = rdma_tech_ib(file->device->ib_dev,
>>>> +							cmd.port_num) ?
>>>> +			       IB_LINK_LAYER_INFINIBAND :
>>>> +			       IB_LINK_LAYER_ETHERNET;
>>>>  
>>>>  	if (copy_to_user((void __user *) (unsigned long) cmd.response,
>>>>  			 &resp, sizeof resp))
>>>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>>>> index 626c9cf..7264860 100644
>>>> --- a/drivers/infiniband/core/verbs.c
>>>> +++ b/drivers/infiniband/core/verbs.c
>>>> @@ -200,11 +200,9 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
>>>>  	u32 flow_class;
>>>>  	u16 gid_index;
>>>>  	int ret;
>>>> -	int is_eth = (rdma_port_get_link_layer(device, port_num) ==
>>>> -			IB_LINK_LAYER_ETHERNET);
>>>>  
>>>>  	memset(ah_attr, 0, sizeof *ah_attr);
>>>> -	if (is_eth) {
>>>> +	if (rdma_tech_iboe(device, port_num)) {
>>>>  		if (!(wc->wc_flags & IB_WC_GRH))
>>>>  			return -EPROTOTYPE;
>>>>  
>>>> @@ -873,7 +871,7 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
>>>>  	union ib_gid  sgid;
>>>>  
>>>>  	if ((*qp_attr_mask & IB_QP_AV)  &&
>>>> -	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num) == IB_LINK_LAYER_ETHERNET)) {
>>>> +	    (rdma_tech_iboe(qp->device, qp_attr->ah_attr.port_num))) {
>>>>  		ret = ib_query_gid(qp->device, qp_attr->ah_attr.port_num,
>>>>  				   qp_attr->ah_attr.grh.sgid_index, &sgid);
>>>>  		if (ret)
>>>> -- 
>>>> 2.1.0
