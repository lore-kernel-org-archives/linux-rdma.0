From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] IB/core,rdmavt,hfi1,opa-vnic: Send OPA cap_mask3 in
 trap
Date: Sun, 4 Jun 2017 23:13:21 -0700
Message-ID: <20170605061321.GA62566@knc-06.sc.intel.com>
References: <1496361842-58389-1-git-send-email-niranjana.vishwanathapura@intel.com>
 <20170604164600.GE6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170604164600.GE6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Michael N. Henry" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 04, 2017 at 07:46:00PM +0300, Leon Romanovsky wrote:
>On Thu, Jun 01, 2017 at 05:04:02PM -0700, Vishwanathapura, Niranjana wrote:
>> --- a/drivers/infiniband/hw/hfi1/mad.c
>> +++ b/drivers/infiniband/hw/hfi1/mad.c
>> @@ -260,6 +260,7 @@ void hfi1_cap_mask_chg(struct rvt_dev_info *rdi, u8 port_num)
>>  	data.issuer_lid = cpu_to_be32(lid);
>>  	data.ntc_144.lid = data.issuer_lid;
>>  	data.ntc_144.new_cap_mask = cpu_to_be32(ibp->rvp.port_cap_flags);
>> +	data.ntc_144.cap_mask3 = cpu_to_be16(ibp->rvp.port_cap3_flags);
>>
>>  	send_trap(ibp, &data, sizeof(data));
>>  }
>> @@ -704,11 +705,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
>>  	buffer_units |= (dd->vl15_init << 11) & OPA_PI_MASK_BUF_UNIT_VL15_INIT;
>>  	pi->buffer_units = cpu_to_be32(buffer_units);
>>
>> -	pi->opa_cap_mask = cpu_to_be16(OPA_CAP_MASK3_IsSharedSpaceSupported |
>> -				       OPA_CAP_MASK3_IsEthOnFabricSupported);
>> -	/* Driver does not support mcast/collective configuration */
>> -	pi->opa_cap_mask &=
>> -		cpu_to_be16(~OPA_CAP_MASK3_IsAddrRangeConfigSupported);
>> +	pi->opa_cap_mask = cpu_to_be16(ibp->rvp.port_cap3_flags);
>>  	pi->collectivemask_multicastmask = ((HFI1_COLLECTIVE_NR & 0x7)
>>  					    << 3 | (HFI1_MCAST_NR & 0x7));
>>
>> diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
>> index 5aa3fd1..a4e2506 100644
>> --- a/drivers/infiniband/hw/hfi1/mad.h
>> +++ b/drivers/infiniband/hw/hfi1/mad.h
>> @@ -115,7 +115,7 @@ struct opa_mad_notice_attr {
>>  			__be32	lid;		/* LID where change occurred */
>>  			__be32	new_cap_mask;	/* new capability mask */
>>  			__be16	reserved2;
>> -			__be16	cap_mask;
>> +			__be16	cap_mask3;
>
>Did I miss the usage of that cap_mask3 field?
>

It is being set in mad.c above in this patch before sending the trap.

Niranjana

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
