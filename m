From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] IB/core: Support rate limit for packet
 pacing
Date: Wed, 9 Nov 2016 15:00:17 -0600
Message-ID: <1998470f-fa12-4bdc-958e-38fa1419f29a@mellanox.com>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
 <1477909297-14491-3-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7F70@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0A7F70-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/9/2016 11:27 AM, Hefty, Sean wrote:
>>   enum ib_qp_state {
>> @@ -1151,6 +1152,7 @@ struct ib_qp_attr {
>>   	u8			rnr_retry;
>>   	u8			alt_port_num;
>>   	u8			alt_timeout;
>> +	u32			rate_limit;
>>   };
> We already have ib_qp_attr::ib_ah_attr::static_rate, and that accounts for both the primary and alternate paths.  We should not add a conflicting rate_limit field.  Either use static_rate as defined by the spec, or replace/update it, with corresponding changes to how it is used in conjunction with SM data.

They are different features. Static rate has a limitation on how many 
different speeds we could get, while packet pacing(rate limit) allows 
customer to set any number between the min and max range.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
