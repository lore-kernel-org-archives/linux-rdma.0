From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_trap_rcv.c: fix possible core dump
Date: Sun, 12 Sep 2010 12:06:56 +0200
Message-ID: <4C8CA640.7010906@dev.mellanox.co.il>
References: <4C8651CF.2080807@mellanox.co.il> <20100907195801.GL11502@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907195801.GL11502@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07-Sep-10 10:58 PM, Sasha Khapyorsky wrote:
> On 17:53 Tue 07 Sep     , Yevgeny Kliteynik wrote:
>> Handle the case when source physical port
>> for trap 145 wasn't found.
>>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>   opensm/opensm/osm_trap_rcv.c |   14 ++++++++++----
>>   1 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
>> index 500632c..9f39644 100644
>> --- a/opensm/opensm/osm_trap_rcv.c
>> +++ b/opensm/opensm/osm_trap_rcv.c
>> @@ -510,10 +510,16 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
>>   				"ERR 3812: No physical port found for "
>>   				"trap 144: \"node description update\"\n");
>>   		goto check_sweep;
>> -	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145)
>> -		/* this assumes that trap 145 content is not broken? */
>> -		p_physp->p_node->node_info.sys_guid =
>> -			p_ntci->data_details.ntc_145.new_sys_guid;
>> +	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145) {
>> +		if (p_physp)
>> +			/* this assumes that trap 145 content is not broken? */
>> +			p_physp->p_node->node_info.sys_guid =
>> +				p_ntci->data_details.ntc_145.new_sys_guid;
>> +		else
>> +			OSM_LOG(sm->p_log, OSM_LOG_ERROR,
>> +				"ERR 3813: No physical port found for "
>> +				"trap 145: \"SystemImageGUID update\"\n");
>> +	}
> 
> Wouldn't it be better to make such check for all traps and not
> separately for selected values?

Such check exists:

   407          if (p_physp)
   408                  p_smp->m_key = p_physp->port_info.m_key;
   409          else
   410                  OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3809: "
   411                          "Failed to find source physical port for trap\n");

However, even if p_physp wasn't found, the function continues,
and for each trap it is doing something else. For instance,
p_physp can be absent, but trap 144 will still cause heavy sweep.

-- Yevgeny

> Sasha
> 
>>
>>   check_sweep:
>>   	/* do a sweep if we received a trap */
>> -- 
>> 1.6.2.4
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
