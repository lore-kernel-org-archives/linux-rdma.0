From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH acm] acme.c: Fix IPv6 address handling in inet_any_pton
Date: Wed, 17 Jun 2015 06:09:18 -0400
Message-ID: <5581474E.4030007@dev.mellanox.co.il>
References: <558026A4.3090907@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FF64BF@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FF64BF-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/17/2015 1:50 AM, Hefty, Sean wrote:
> Thanks - applied manually

Thanks.

>>  acm/src/acme.c |    2 +-
> 
> Path?
> 
>> diff --git a/acm/src/acme.c b/acm/src/acme.c
>> index 9bf7557..d54c8b9 100644
>> --- a/acm/src/acme.c
>> +++ b/acm/src/acme.c
>> @@ -787,7 +787,7 @@ static int inet_any_pton(char *addr, struct sockaddr
> 
> This was off by a couple hundred lines.  Can you check your branch?

My bad; patch I sent was against SSA ACM. I only compared code to see it
was needed upstream and forgot to port it against upstream tree.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
