From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_cache.c: Cosmetic change to log message
 for consistency
Date: Fri, 16 Oct 2009 00:05:48 +0200
Message-ID: <4AD79CBC.10606@dev.mellanox.co.il>
References: <20091015133639.GB8041@comcast.net> <20091015192647.GF20210@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091015192647.GF20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 09:36 Thu 15 Oct     , Hal Rosenstock wrote:
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_ucast_cache.c
>> index 31a5333..8db9df2 100644
>> --- a/opensm/opensm/osm_ucast_cache.c
>> +++ b/opensm/opensm/osm_ucast_cache.c
>> @@ -876,7 +876,7 @@ void osm_ucast_cache_add_link(osm_ucast_mgr_t * p_mgr,
>>  	if (osm_node_get_type(p_node_1) != IB_NODE_TYPE_SWITCH &&
>>  	    osm_node_get_type(p_node_2) != IB_NODE_TYPE_SWITCH) {
>>  		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
>> -			"Dropping CA-2-CA link - cache invalid\n");
>> +			"Dropping CA/RTR-2-CA/RTR link - cache invalid\n");
> 
> IMHO it looks more confusing after the change.
> 
> BTW why should OSM_LOG_INFO level be used here?

If I remember it correctly, there's an INFO message
in the ucast mgr saying something like "switches
configured for unicast" or "<routing engine name>
tables configured", or something like that (I don't
have access to the code right now).
So I wanted to see one more line that says that
cache is not applicable.

-- Yevgeny

> Sasha
> 
>>  		osm_ucast_cache_invalidate(p_mgr);
>>  		goto Exit;
>>  	}
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
