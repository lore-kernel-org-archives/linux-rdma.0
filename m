From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 17/18] IB/core: Define 'ib' and 'eth'
 rdma_ah_attr types
Date: Tue, 11 Apr 2017 23:29:00 -0700
Message-ID: <6380e095-c59e-edf0-853c-06d9abb1a0bc@intel.com>
References: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1491932545-60894-18-git-send-email-dasaratharaman.chandramouli@intel.com>
 <VI1PR0502MB3008F933EA086C3A47C025B3D1000@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1119AC@ORSMSX109.amr.corp.intel.com>
 <VI1PR0502MB3008E3D0873AFF6F05D7C0BCD1030@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1119E4@ORSMSX109.amr.corp.intel.com>
 <VI1PR0502MB300833BF0033D3259B29EC69D1030@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB300833BF0033D3259B29EC69D1030-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/11/2017 6:29 PM, Parav Pandit wrote:
>
>
>> -----Original Message-----
>> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>> Sent: Tuesday, April 11, 2017 7:24 PM
>> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Chandramouli, Dasaratharaman
>> <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; linux-rdma <linux-
>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Subject: RE: [PATCH rdma-next 17/18] IB/core: Define 'ib' and 'eth'
>> rdma_ah_attr types
>>
>>>>>> +struct ib_ah_attr {
>>>>>> +	struct ib_global_route	grh;
>>>>>> +	u16			dlid;
>>>>>> +	u8			sl;
>>>>>> +	u8			src_path_bits;
>>>>>> +	u8			static_rate;
>>>>>> +	u8			dmac[ETH_ALEN];
>>>>
>>>> I might have missed something in my review.  Why is dmac in the ib
>>>> attributes?
>>>>
>>> Yes. Is should be removed similar to removing dlid from eth_ah_attr.
>>> Respective if-else code will also go away with that.
>>>
>>>>>> +};
>>>>>> +
>>>>>> +struct eth_ah_attr {
>>>>>>  	struct ib_global_route	grh;
>>>>>>  	u16			dlid;
>>>>> Please remove it from eth, as there is no dlid for Eth.
>>>>>
>>>>>>  	u8			sl;
>>>>>>  	u8			src_path_bits;
>>>>>>  	u8			static_rate;
>>>>>> -	u8			ah_flags;
>>>>>> -	u8			port_num;
>>>>>>  	u8			dmac[ETH_ALEN];
>>>>>>  };
>>>>>>
>>>>>
>>>>> Its better to have
>>>>> struct ib_ah_common_attr {} to have common fields between IB and
>>> ETH.
>>>>> And have instance of them in eth_ah_attr and ib_ah_attr structure.
>>>>
>>>> I think part of this exercise is to figure out what fields belong to
>>> each ah type.
>>> Right.
>>>
>>>> I'm not even sure why ethernet has a grh, sl, or src_path_bits.  Are
>>> these
>>> Sl is applicable. Src_path_bits is IB only.
>>>
>>>> used?  Are all of the fields of the grh needed?
>>> Yes. Most of them are common between IB/RoCE. Not sure of iWarp as AH
>>> attribute is common for iwarp and roce.
>>> Can the eth attributes be split
>>>> further based on roce v1 or v2?
>>>
>>> Most fields appear common between all 3 IB/RoCEv1,v2 so far to me in
>>> ib_global_route and are used too.
>>
>> I think this is what we have so far then:
>>
>> /* common */
>> struct rdma_ah_attr {
>> 	u8			ah_flags;
>> 	u8			port_num;
>> 	union ...
>> };
>>
>> struct ib_ah_attr {
>> 	struct ib_global_route	grh;
>> 	u16			dlid;
>> 	u8			sl;
>> 	u8			src_path_bits;
>> 	u8			static_rate;
>> };
>>
>> struct eth_ah_attr {
>>  	struct ib_global_route	grh;
>> 	u8			sl;
>> 	u8			static_rate;
>> 	u8			dmac[ETH_ALEN];
>>  };
>>
>> struct opa_ah_attr {
>> 	struct ib_global_route	grh;
>> 	u32			dlid;
>> 	u8			sl;
>> 	u8			src_path_bits;
>> 	u8			static_rate;
>> };
>>
>> So, the grh, sl, and static_rate are candidates to move directly into
>> rdma_ah_attr.  IMO, it's arguable if that's better, but I don't have a strong
>> opinion either way.  I don't know if iwarp uses ah attributes.
>
> Grep in cxgb4 driver for ah refers only to c4iw_ah_create which returns -ENOSYS
> With that I think we should keep grh, sl, static rate in rdma_ah_attr.
>

Thanks for the feedback. Will move them under rdma_ah_attr.

mlx4 and mlx5 maintain some of these grh fields in their driver data 
structures a little differently. There is ah->av.ib.sl_tclass_flowlabel 
in mlx4 and something like ah->av.grh_gid_fl in mlx5. Now that there is 
an eth specific grh, we might attempt to redefine the grh so the driver 
data structures are a little bit cleaner. Something that could be 
attempted by the respective drivers later.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
