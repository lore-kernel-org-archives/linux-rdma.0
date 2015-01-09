From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibccconfig.c: Account for enhanced switch
 port 0 in SwitchPortCongestionSetting handling
Date: Fri, 09 Jan 2015 11:00:50 -0500
Message-ID: <54AFFB32.1090200@dev.mellanox.co.il>
References: <54AFF110.9000005@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CBF0137@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBF0137-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/9/2015 10:46 AM, Weiny, Ira wrote:
> [off-list]
> 
> This replaces the first one?

This is ibccconfig. Other was for ibccquery. Similar subjects but
separated by tool rather than one patch for both.

> 
>> -----Original Message-----
>> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> Sent: Friday, January 09, 2015 7:18 AM
>> To: Weiny, Ira
>> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); Chu, Al
>> Subject: [PATCH infiniband-diags] ibccconfig.c: Account for enhanced switch
>> port 0 in SwitchPortCongestionSetting handling
>>
>> Enhanced switch port 0 can support CC (indicated in CC
>> ClassPortInfo:CapabilityMask.EnhancedPort0CC).
>>
>> portnum 0 is a valid port number and offsets should be calculated based on
>> port 0 rather than port 1.
>>
>> Also, fix some error messages to indicate switch port congestion setting rather
>> then switch congestion setting failure.
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> diff --git a/src/ibccconfig.c b/src/ibccconfig.c index 11dfc07..22b16db 100644
>> --- a/src/ibccconfig.c
>> +++ b/src/ibccconfig.c
>> @@ -371,9 +371,6 @@ static char
>> *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
>>  	if ((errstr = parseint(argv[5], &cong_parm_marking_rate, 0)))
>>  		return errstr;
>>
>> -	if (!portnum)
>> -		return "invalid port number specified";
>> -
>>  	/* Figure out number of ports first */
>>  	if (!smp_query_via(data, dest, IB_ATTR_NODE_INFO, 0, 0, srcport))
>>  		return "node info config failed";
>> @@ -389,10 +386,10 @@ static char
>> *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
>>
>>  	/* We are modifying only 1 port, so get the current config */
>>  	if (!cc_query_status_via(payload, dest,
>> IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING,
>> -				 (portnum - 1) / 32, 0, NULL, srcport, cckey))
>> -		return "switch congestion setting query failed";
>> +				 portnum / 32, 0, NULL, srcport, cckey))
>> +		return "switch port congestion setting query failed";
>>
>> -	ptr = payload + (((portnum % 32 - 1) * 4));
>> +	ptr = payload + (((portnum % 32) * 4));
>>
>>  	mad_encode_field(ptr,
>>
>> IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_VALID_F,
>> @@ -415,8 +412,8 @@ static char
>> *switch_port_congestion_setting(ib_portid_t * dest, char **argv, int
>>  			 &cong_parm_marking_rate);
>>
>>  	if (!cc_config_status_via(payload, rcv, dest,
>> IB_CC_ATTR_SWITCH_PORT_CONGESTION_SETTING,
>> -				  (portnum - 1) / 32, 0, NULL, srcport, cckey))
>> -		return "switch congestion setting config failed";
>> +				  portnum / 32, 0, NULL, srcport, cckey))
>> +		return "switch port congestion setting config failed";
>>
>>  	return NULL;
>>  }
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
