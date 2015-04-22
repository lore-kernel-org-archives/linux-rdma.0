From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v5 09/27] IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
Date: Wed, 22 Apr 2015 09:38:57 +0200
Message-ID: <55375011.7010805@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <5534BA7C.2010600@profitbricks.com> <20150421231958.GA15893@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150421231958.GA15893-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, Ira

Thanks for the review :-)

On 04/22/2015 01:19 AM, ira.weiny wrote:
[snip]
>> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
>> index cbd0383..8570180 100644
>> --- a/drivers/infiniband/core/sysfs.c
>> +++ b/drivers/infiniband/core/sysfs.c
>> @@ -248,14 +248,10 @@ static ssize_t phys_state_show(struct ib_port *p, struct port_attribute *unused,
>>  static ssize_t link_layer_show(struct ib_port *p, struct port_attribute *unused,
>>  			       char *buf)
>>  {
>> -	switch (rdma_port_get_link_layer(p->ibdev, p->port_num)) {
>> -	case IB_LINK_LAYER_INFINIBAND:
>> +	if (rdma_tech_ib(p->ibdev, p->port_num))
> 
> Is the final intention to remove Link Layer from the rdma stack entirely?
> 
> I know that the use of link layer in userspace is just as convoluted as what we
> are trying to fix here in the kernel.  So it would be nice if we can eventually
> get user space cleaned up to not use link layer as it currently does.
> 
> However, standard networking tools can report the link layer.  So while the
> current use of "link layer" via userspace software is wrong I don't think it is
> wrong to report this information _to_ userspace.
> 
> So unless we intend to completely hide the link layer from userspace I don't
> think we should be removing the rdma_port_get_link_layer call.  It is still
> valid information even though we don't want to use it in most places.

This series won't erase the rdma_port_get_link_layer(), although
currently only mlx4 still using it in kernel...

link_layer_show() was supposed to report the same info to user
space as usual, so user tool don't have to change anything :-)

Regards,
Michael Wang

> 
> Ira
> 
>>  		return sprintf(buf, "%s\n", "InfiniBand");
>> -	case IB_LINK_LAYER_ETHERNET:
>> +	else
>>  		return sprintf(buf, "%s\n", "Ethernet");
>> -	default:
>> -		return sprintf(buf, "%s\n", "Unknown");
>> -	}
>>  }
>>  
>>  static PORT_ATTR_RO(state);
>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
>> index a9f0489..5dc90aa 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -515,8 +515,10 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
>>  	resp.active_width    = attr.active_width;
>>  	resp.active_speed    = attr.active_speed;
>>  	resp.phys_state      = attr.phys_state;
>> -	resp.link_layer      = rdma_port_get_link_layer(file->device->ib_dev,
>> -							cmd.port_num);
>> +	resp.link_layer      = rdma_tech_ib(file->device->ib_dev,
>> +							cmd.port_num) ?
>> +			       IB_LINK_LAYER_INFINIBAND :
>> +			       IB_LINK_LAYER_ETHERNET;
>>  
>>  	if (copy_to_user((void __user *) (unsigned long) cmd.response,
>>  			 &resp, sizeof resp))
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>> index 626c9cf..7264860 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -200,11 +200,9 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
>>  	u32 flow_class;
>>  	u16 gid_index;
>>  	int ret;
>> -	int is_eth = (rdma_port_get_link_layer(device, port_num) ==
>> -			IB_LINK_LAYER_ETHERNET);
>>  
>>  	memset(ah_attr, 0, sizeof *ah_attr);
>> -	if (is_eth) {
>> +	if (rdma_tech_iboe(device, port_num)) {
>>  		if (!(wc->wc_flags & IB_WC_GRH))
>>  			return -EPROTOTYPE;
>>  
>> @@ -873,7 +871,7 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
>>  	union ib_gid  sgid;
>>  
>>  	if ((*qp_attr_mask & IB_QP_AV)  &&
>> -	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num) == IB_LINK_LAYER_ETHERNET)) {
>> +	    (rdma_tech_iboe(qp->device, qp_attr->ah_attr.port_num))) {
>>  		ret = ib_query_gid(qp->device, qp_attr->ah_attr.port_num,
>>  				   qp_attr->ah_attr.grh.sgid_index, &sgid);
>>  		if (ret)
>> -- 
>> 2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
