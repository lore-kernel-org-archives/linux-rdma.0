From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osmtest/osmt_multicast.c: Use proper defines for
 rate
Date: Sun, 19 Jun 2011 10:46:59 -0400
Message-ID: <4DFE0BE3.6060208@dev.mellanox.co.il>
References: <4DFCB0AE.80400@dev.mellanox.co.il> <20110619120535.GA2431@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110619120535.GA2431-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 6/19/2011 8:05 AM, Alex Netes wrote:
> Hi Hal,
> 
> On 10:05 Sat 18 Jun     , Hal Rosenstock wrote:
>> Rather than using width defines, use rate defines when setting rate in MCMemberRecord.
>> The conversions here are 1 for 1.
>>
>> Also, fix typo in an OSM_LOG message
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
>> index e4eba64..4e471ce 100644
>> --- a/osmtest/osmt_multicast.c
>> +++ b/osmtest/osmt_multicast.c
>> @@ -385,7 +385,7 @@ void osmt_init_mc_query_rec(IN osmtest_t * const p_osmt,
>>  	/*  uint8_t     mtu; - keep it zero means - anything you have please. */
>>  	/*  uint8_t     tclass; can leave as zero for now (between subnets) */
>>  	/*  ib_net16_t  pkey; leave as zero */
>> -	p_mc_req->rate = IB_LINK_WIDTH_ACTIVE_4X;
>> +	p_mc_req->rate = IB_PATH_RECORD_RATE_2_5_GBS;
>>  	/*  uint8_t     pkt_life; zero means greater than zero ... */
>>  	/*  ib_net32_t  sl_flow_hop; keep it all zeros */
>>  	/*  we want to use a link local scope: 0x02 */
>> @@ -900,7 +900,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  
>>  	/* impossible requested rate */
>>  	mc_req_rec.rate =
>> -	    IB_LINK_WIDTH_ACTIVE_12X | IB_PATH_SELECTOR_GREATER_THAN << 6;
>> +	    IB_PATH_RECORD_RATE_60_GBS | IB_PATH_SELECTOR_GREATER_THAN << 6;
>>  
>>  	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
>>  	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
>> @@ -1216,14 +1216,14 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
>>  		"Checking Create given MGID=0 valid Set several options :\n\t\t"
>>  		"First above min RATE, Second less than max RATE\n\t\t"
>> -		"Third above min MTU, Second less than max MTU\n\t\t"
>> +		"Third above min MTU, Fourth less than max MTU\n\t\t"
>>  		"Fifth exact MTU & RATE feasible, Sixth exact RATE feasible\n\t\t"
>>  		"Seventh exact MTU feasible (o15.0.1.4)...\n");
>>  
>>  	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
>>  
>>  	mc_req_rec.rate =
>> -	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_GREATER_THAN << 6;
>> +	    (IB_PATH_RECORD_RATE_2_5_GBS - 1) | IB_PATH_SELECTOR_GREATER_THAN << 6;
>>  
>>  	comp_mask = IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
>>  	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
>> @@ -1247,7 +1247,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  	/* Good Flow - mgid is 0 while giving all required fields for join : P_Key, Q_Key, SL, FlowLabel, Tclass */
>>  
>>  	mc_req_rec.rate =
>> -	    IB_LINK_WIDTH_ACTIVE_12X | IB_PATH_SELECTOR_LESS_THAN << 6;
>> +	    IB_PATH_RECORD_RATE_60_GBS | IB_PATH_SELECTOR_LESS_THAN << 6;
>>  
>>  	comp_mask = IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
>>  	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
>> @@ -1843,7 +1843,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  		"Checking JoinState update request should return 0x22 (o15.0.1.11)...\n");
>>  
>>  	mc_req_rec.rate =
>> -	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_GREATER_THAN << 6;
>> +	    (IB_PATH_RECORD_RATE_2_5_GBS - 1) | IB_PATH_SELECTOR_GREATER_THAN << 6;
> 
> (IB_PATH_RECORD_RATE_2_5_GBS - 1) is defined as 1 and it's a reserved value
> IBTA p917.

Yes, it's a reserved value but is equivalent to what was there.

> Moreover in the OpenSM code opensm/osm_sa_mcmember_record.c:288 the check is:
> 
> 	if (rate_mgrp <= rate_required) { //equal or greater

Is that another bug ? It says greater than rather than greater than or
equal to. Also, other places there do the comparison without the equal.

> So I guess rate here could be defined as:
> 	mc_req_rec.rate =
> 		(IB_PATH_RECORD_RATE_2_5_GBS) | IB_PATH_SELECTOR_GREATER_THAN << 6;

AFAIT it's not greater than or equal to but just greater than.

-- Hal

>>  	mc_req_rec.mgid = good_mgid;
>>  
>>  	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
>> @@ -1980,7 +1980,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  
>>  	mc_req_rec.mgid = good_mgid;
>>  	mc_req_rec.rate =
>> -	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_LESS_THAN << 6;
>> +	    (IB_PATH_RECORD_RATE_2_5_GBS - 1) | IB_PATH_SELECTOR_LESS_THAN << 6;
>>  	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
>>  	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
>>  
>> @@ -2055,7 +2055,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  		"Checking partial JoinState delete request - removing NonMember (o15.0.1.14)...\n");
>>  
>>  	mc_req_rec.rate =
>> -	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_GREATER_THAN << 6;
>> +	    (IB_PATH_RECORD_RATE_2_5_GBS - 1) | IB_PATH_SELECTOR_GREATER_THAN << 6;
>>  	mc_req_rec.mgid = good_mgid;
>>  	comp_mask = IB_MCR_COMPMASK_GID | IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/* all above are required */
>>  	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
>> @@ -2136,7 +2136,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  
>>  	mc_req_rec.mgid = osm_ipoib_mgid;
>>  	mc_req_rec.rate =
>> -	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_GREATER_THAN << 6;
>> +	    (IB_PATH_RECORD_RATE_2_5_GBS - 1) | IB_PATH_SELECTOR_GREATER_THAN << 6;
>>  	mc_req_rec.scope_state = 0x21;	/* delete full member */
>>  
>>  	status = osmt_send_mcast_request(p_osmt, 0,	/* delete flag */
>> @@ -2194,7 +2194,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  
>>  	mc_req_rec.mgid = osm_ipoib_mgid;
>>  	mc_req_rec.rate =
>> -	    IB_LINK_WIDTH_ACTIVE_1X | IB_PATH_SELECTOR_GREATER_THAN << 6;
>> +	    (IB_PATH_RECORD_RATE_2_5_GBS - 1) | IB_PATH_SELECTOR_GREATER_THAN << 6;
>>  	mc_req_rec.scope_state = 0x21;	/* delete full member */
>>  
>>  	status = osmt_send_mcast_request(p_osmt, 0,	/* delete flag */
>> @@ -2411,7 +2411,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
>>  			   join : P_Key, Q_Key, SL, FlowLabel, Tclass */
>>  
>>  			mc_req_rec.rate =
>> -			    IB_LINK_WIDTH_ACTIVE_1X |
>> +			    (IB_PATH_RECORD_RATE_2_5_GBS - 1) |
>>  			    IB_PATH_SELECTOR_GREATER_THAN << 6;
>>  			mc_req_rec.mlid = max_mlid;
>>  			memset(&mc_req_rec.mgid, 0, sizeof(ib_gid_t));
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
