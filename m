From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: Fix issues causing const warnings for strings
Date: Tue, 12 Mar 2013 10:49:15 -0400
Message-ID: <513F406B.9040903@dev.mellanox.co.il>
References: <513F3173.4080908@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510EBB2D9E@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510EBB2D9E-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/12/2013 10:12 AM, Weiny, Ira wrote:
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
>> Sent: Tuesday, March 12, 2013 9:45 AM
>> To: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>> Subject: [PATCH] opensm: Fix issues causing const warnings for strings
>>
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
> 
> [snip]
> 
>>
>> diff --git a/opensm/main.c b/opensm/main.c index 1a061a8..db5429a 100644
>> --- a/opensm/main.c
>> +++ b/opensm/main.c
>> @@ -718,7 +718,7 @@ int main(int argc, char *argv[])
>>  	optind = 0;		/* reset command line */
>>
>>  	if (!config_file)
>> -		config_file = OSM_DEFAULT_CONFIG_FILE;
>> +		config_file = strdup(OSM_DEFAULT_CONFIG_FILE);
>>
> 
> Why is the strdup here but not on the optarg above?
> 
> Also, is this free'ed anywhere?  Can the config file change at run time?  I don't think it can but perhaps you are moving that direction?
> 
> Also, perhaps the strdup should be within osm_subn_parse_conf_file?  

Version 2 patch to follow shortly.

-- Hal

> 
> Ira
> 
> [snip]
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
