From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: ibstat fix strncpy coverity check and
 -l bug
Date: Thu, 13 Jun 2013 14:26:29 -0400
Message-ID: <51BA0ED5.9070202@dev.mellanox.co.il>
References: <20130612211537.1eef2098a821426c466a83b5@intel.com> <51B9A5CD.4010209@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E02084650@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E02084650-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/13/2013 2:20 PM, Weiny, Ira wrote:
>> -----Original Message-----
>> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> Subject: Re: [PATCH] infiniband-diags: ibstat fix strncpy coverity check and -l
>> bug
>>
>> On 6/13/2013 12:15 AM, Ira Weiny wrote:
>>>
>>> Changes since V1:
>>> 	Fix port parameter usage.
>>>
>>> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> ---
>>>  src/ibstat.c |   11 +++--------
>>>  1 files changed, 3 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/src/ibstat.c b/src/ibstat.c index 665bb0a..37f2361 100644
>>> --- a/src/ibstat.c
>>> +++ b/src/ibstat.c
>>> @@ -314,7 +314,8 @@ int main(int argc, char *argv[])
>>>  		if (i >= n)
>>>  			IBPANIC("'%s' IB device can't be found", argv[0]);
>>>
>>> -		strncpy(names[i], argv[0], sizeof names[i]);
>>> +		strncpy(names[0], argv[0], sizeof(names[0])-1);
>>> +		names[0][sizeof(names[0])-1] = '\0';
>>>  		n = 1;
>>>  	}
>>>
>>> @@ -324,16 +325,10 @@ int main(int argc, char *argv[])
>>>  		return 0;
>>>  	}
>>>
>>> -	if (!list_only && argc) {
>>> -		if (ca_stat(argv[0], dev_port, short_format) < 0)
>>> -			IBPANIC("stat of IB device '%s' failed", argv[0]);
>>> -		return 0;
>>> -	}
>>> -
>>>  	for (i = 0; i < n; i++) {
>>>  		if (list_only)
>>>  			printf("%s\n", names[i]);
>>> -		else if (ca_stat(names[i], -1, short_format) < 0)
>>> +		else if (ca_stat(names[i], dev_port, short_format) < 0)
>>
>> I don't think this works when ib device is not first one and port is also
>> supplied.
> 
> That is what the change in the first hunk does.  It places argv[0] in name[0] and sets n=1.
> 
> This works fine for me:
> 
> 11:17:42 > ./ibstat -l         
> mlx4_0
> mlx4_1
> 
> 11:16:33 > ./ibstat mlx4_1 1
> CA: 'mlx4_1'
> Port 1:
> State: Down
> Physical state: Polling
> Rate: 10
> Base lid: 0
> LMC: 0
> SM lid: 0
> Capability mask: 0x02510868
> Port GUID: 0x0002c9030003ced7
> Link layer: InfiniBand
> 
> Or are you speaking of some other use case?

No; I missed looking carefully at the first hunk.

Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

-- Hal

> 
> Ira
> 
>>
>> -- Hal
>>
>>>  			IBPANIC("stat of IB device '%s' failed", names[i]);
>>>  	}
>>>
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
