From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDS: Fix rds-ping inducing kernel panic
Date: Mon, 22 Jan 2018 09:04:28 -0800
Message-ID: <2cf712c8-3c1f-17de-743f-0fe26331da2e@oracle.com>
References: <20180122112415.GA41074@beast>
 <20180122151054.GJ1393@mtr-leonro.local>
 <20180122.104730.362327971778717733.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122.104730.362327971778717733.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, sbeattie-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/22/2018 7:47 AM, David Miller wrote:
> From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Mon, 22 Jan 2018 17:10:54 +0200
> 
>> On Mon, Jan 22, 2018 at 03:24:15AM -0800, Kees Cook wrote:
>>> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
>>> index 8557a1cae041..5fbf635d17cb 100644
>>> --- a/net/rds/ib_send.c
>>> +++ b/net/rds/ib_send.c
>>> @@ -506,7 +506,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
>>>   	int flow_controlled = 0;
>>>   	int nr_sig = 0;
>>>
>>> -	BUG_ON(off % RDS_FRAG_SIZE);
>>> +	BUG_ON(!conn->c_loopback && off % RDS_FRAG_SIZE);
>>>   	BUG_ON(hdr_off != 0 && hdr_off != sizeof(struct rds_header));
>>
>> To be honest this function full of BUG_ONs and it looks fishy to have them there.
>> Why don't we return EINVAL instead of crashing system?
> 
> I completely agree that these assertions should just cause an error-out
> rather than trigger a BUG().

Andy did remove bunch of them but there are still few more left overs.
Will have a look at remainder set since most of them were added during
early development and remained there. Thanks Dave/Leon.

Regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
