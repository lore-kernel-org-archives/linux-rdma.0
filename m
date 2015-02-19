From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 09/30] IB/core: Modify ib_verbs and cma in order to use
 roce_gid_cache
Date: Thu, 19 Feb 2015 17:24:15 +0200
Message-ID: <54E6001F.2080304@mellanox.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <f91c8ed3-f6a4-4b63-85f9-870d9687a14f@CMEXHTCAS2.ad.emulex.com>
 <54E5F51B.8020806@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E5F51B.8020806-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2/19/2015 4:37 PM, Haggai Eran wrote:
> On 20/02/2015 00:02, Somnath Kotur wrote:
>> @@ -203,21 +235,30 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
>>
>>   	memset(ah_attr, 0, sizeof *ah_attr);
>>   	if (is_eth) {
>> +		u16 vlan_id = wc->wc_flags & IB_WC_WITH_VLAN ?
>> +				wc->vlan_id : 0xffff;
>> +
>>   		if (!(wc->wc_flags & IB_WC_GRH))
>>   			return -EPROTOTYPE;
>>
>> -		if (wc->wc_flags & IB_WC_WITH_SMAC &&
>> -		    wc->wc_flags & IB_WC_WITH_VLAN) {
>> -			memcpy(ah_attr->dmac, wc->smac, ETH_ALEN);
>> -			ah_attr->vlan_id = wc->vlan_id;
>> -		} else {
>> +		if (!(wc->wc_flags & IB_WC_WITH_SMAC) ||
>> +		    !(wc->wc_flags & IB_WC_WITH_VLAN)) {
>>   			ret = rdma_addr_find_dmac_by_grh(&grh->dgid, &grh->sgid,
>> -					ah_attr->dmac, &ah_attr->vlan_id);
>> +							 ah_attr->dmac,
>> +							 wc->wc_flags & IB_WC_WITH_VLAN ?
>> +							 NULL : &vlan_id,
>> +							 0);
>>   			if (ret)
>>   				return ret;
>>   		}
>> -	} else {
>> -		ah_attr->vlan_id = 0xffff;
>
> Previously vlan_id would get set to 0xffff on non-Ethernet link-layer,
> and now it is left as zero. Wouldn't that break things for non-Ethernet
> protocols?

On non-Ethernet link-later, vlan_id was ignored. This field was deleted 
in this patchset.

>
>> +
>> +		ret = get_sgid_index_from_eth(device, port_num, vlan_id,
>> +					      &grh->dgid, &gid_index);
>> +		if (ret)
>> +			return ret;
>> +
>> +		if (wc->wc_flags & IB_WC_WITH_SMAC)
>> +			memcpy(ah_attr->dmac, wc->smac, ETH_ALEN);
>>   	}
>>
>>   	ah_attr->dlid = wc->slid;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
