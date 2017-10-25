From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] ibacm: In acm_util.c:acm_if_iter_sys, try
 IPv4 if IPv6 doesn't find any appropriate interfaces
Date: Wed, 25 Oct 2017 11:29:28 -0400
Message-ID: <cb3ecc66-d128-e735-4bc7-c35aca3fa915@dev.mellanox.co.il>
References: <8d19d9a9-1f97-408e-ca60-d42e67fbf60c@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AB1A24BB@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1A24BB-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 10/25/2017 11:17 AM, Hefty, Sean wrote:
>> This can occur when IPv6 is disabled.
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  ibacm/src/acm_util.c | 22 ++++++++++++++++------
>>  1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/ibacm/src/acm_util.c b/ibacm/src/acm_util.c index
>> b50fd74..5b84be8 100644
>> --- a/ibacm/src/acm_util.c
> 	> +++ b/ibacm/src/acm_util.c
>> @@ -127,7 +127,8 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void
>> *ctx)
>>  	struct ifconf *ifc;
>>  	struct ifreq *ifr;
>>  	char ip_str[INET6_ADDRSTRLEN];
>> -	int s, ret, i, len;
>> +	int family = AF_INET6;
>> +	int s, ret, i, len, intfs = 0;
>>  	uint16_t pkey;
>>  	union ibv_gid sgid;
>>  	uint8_t addr_type;
>> @@ -135,9 +136,12 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void
>> *ctx)
>>  	size_t addr_len;
>>  	char *alias_sep;
>>
>> -	s = socket(AF_INET6, SOCK_DGRAM, 0);
>> -	if (!s)
>> -		return -1;
>> +next_family:
>> +	s = socket(family, SOCK_DGRAM, 0);
>> +	if (!s) {
> 
> If ipv6 is disabled, wouldn't we fail here and could open an ipv4 socket?  So, we don't goto out just to go back to this location?

In the case where ipv6 is disabled in kernel, the socket is created but
the ioctl failed.

> If we successfully open this socket, 

(and ioctl also works)

> and fail to find any interfaces, do we expect that opening an ipv4 socket would produce anything different?

I don't think so. I'll submit a revised patch shortly.

-- Hal

> If that's actually the case, then maybe we should always open both sockets.
> 
>> +		ret = -1;
>> +		goto out;
>> +	}
>>
>>  	len = sizeof(*ifc) + sizeof(*ifr) * 64;
>>  	ifc = malloc(len);
>> @@ -152,7 +156,8 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void
>> *ctx)
>>
>>  	ret = ioctl(s, SIOCGIFCONF, ifc);
>>  	if (ret < 0) {
>> -		acm_log(0, "ioctl ifconf error: %s\n", strerror(errno));
>> +		acm_log(0, "ioctl IPv%s ifconf error: %s\n",
>> +			(family == AF_INET6) ? "6" : "4", strerror(errno));
>>  		goto out2;
>>  	}
>>
>> @@ -199,6 +204,7 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void
>> *ctx)
>>  			continue;
>>
>>  		cb(ifr[i].ifr_name, &sgid, pkey, addr_type, addr,
>> addr_len, ip_str, ctx);
>> +		intfs++;
>>  	}
>>  	ret = 0;
>>
>> @@ -206,6 +212,10 @@ out2:
>>  	free(ifc);
>>  out1:
>>  	close(s);
>> +out:
>> +	if (family == AF_INET6 && intfs == 0) {
>> +		family = AF_INET;
>> +		goto next_family;
>> +	}
>>  	return ret;
> 
> - Sean
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
