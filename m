From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_qos_policy.c: fix SL for TS-precreated mcast
 group
Date: Mon, 06 Sep 2010 23:57:41 +0300
Message-ID: <4C8555C5.6080607@dev.mellanox.co.il>
References: <4C836A74.3070004@mellanox.co.il> <20100906165647.GF11502@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100906165647.GF11502@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06-Sep-10 7:56 PM, Sasha Khapyorsky wrote:
> On 13:01 Sun 05 Sep     , Yevgeny Kliteynik wrote:
>> Assuming we still need to support TopSpin's non-compliant join
>> compmask for IPoIB v4 multicast group ff12:401b:<pkey>::1
> 
> Wouldn't it be better to understand an use case of this group? It is
> probably obsolete and such addition is not needed.

Sure, I'd trade this patch for another patch
that removes the mcast group pre-creation.

If no one objects, I'll remove that TS hack.

-- Yevgeny

> Sasha
> 
>>
>> The group is pre-defined and maintained as a well-known
>> multicast group, hence it's SL needs to be fixed too in
>> accordance with QoS policy configuration, same as for
>> ff12:401b:<pkey>::ffff:ffff MGID.
>>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>   opensm/opensm/osm_qos_policy.c |   35 +++++++++++++++++++++++++++++++++++
>>   1 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/opensm/opensm/osm_qos_policy.c b/opensm/opensm/osm_qos_policy.c
>> index ac49ab3..bdd27d0 100644
>> --- a/opensm/opensm/osm_qos_policy.c
>> +++ b/opensm/opensm/osm_qos_policy.c
>> @@ -764,6 +764,20 @@ static osm_qos_port_group_t *__qos_policy_get_port_group_by_name(
>>
>>   /***************************************************
>>    ***************************************************/
>> +/*
>> + * HACK: Until TS resolves their noncompliant join compmask,
>> + * we have to fix SL for this pre-defined the MGID too
>> + */
>> +static const ib_gid_t osm_ts_ipoib_mgid = {
>> +	{
>> +	 0xff,			/*  multicast field */
>> +	 0x12,			/*  non-permanent bit, link local scope */
>> +	 0x40, 0x1b,		/*  IPv4 signature */
>> +	 0xff, 0xff,		/*  16 bits of P_Key (to be filled in) */
>> +	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/*  48 bits of zeros */
>> +	 0x00, 0x00, 0x00, 0x01,	/*  32 bit IPv4 broadcast address */
>> +	 },
>> +};
>>
>>   static void __qos_policy_validate_pkey(
>>   			osm_qos_policy_t * p_qos_policy,
>> @@ -773,6 +787,9 @@ static void __qos_policy_validate_pkey(
>>   	uint8_t sl;
>>   	uint32_t flow;
>>   	uint8_t hop;
>> +	ib_gid_t mgid;
>> +	ib_net16_t pkey;
>> +	osm_mgrp_t * mgrp;
>>   	char gid_str[INET6_ADDRSTRLEN];
>>
>>   	if (!p_qos_policy || !p_qos_match_rule || !p_prtn)
>> @@ -810,6 +827,24 @@ static void __qos_policy_validate_pkey(
>>   		p_prtn->mgrp->mcmember_rec.sl_flow_hop =
>>   			ib_member_set_sl_flow_hop(p_prtn->sl, flow, hop);
>>   	}
>> +
>> +	/* workaround for TS */
>> +	/* FIXME: remove this upon TS fixes */
>> +	mgid = osm_ts_ipoib_mgid;
>> +	pkey = p_prtn->pkey | cl_hton16(0x8000);
>> +	memcpy(&mgid.raw[4],&pkey, sizeof(pkey));
>> +	mgrp = osm_get_mgrp_by_mgid(p_qos_policy->p_subn,&mgid);
>> +	if (mgrp) {
>> +		OSM_LOG(&p_qos_policy->p_subn->p_osm->log, OSM_LOG_DEBUG,
>> +			"TS workaround: Updating MCGroup (MGID %s) SL to "
>> +			"match partition SL (%u)\n",
>> +			inet_ntop(AF_INET6, mgid.raw, gid_str, sizeof gid_str),
>> +			p_prtn->sl);
>> +		ib_member_get_sl_flow_hop(mgrp->mcmember_rec.sl_flow_hop,
>> +				&sl,&flow,&hop);
>> +		mgrp->mcmember_rec.sl_flow_hop =
>> +			ib_member_set_sl_flow_hop(p_prtn->sl, flow, hop);
>> +	}
>>   }
>>
>>   /***************************************************
>> -- 
>> 1.6.2.4
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
