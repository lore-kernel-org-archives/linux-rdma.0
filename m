From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH librdmacm 2/2] examples/riostream.c: Eliminate unneeded
 include
Date: Mon, 03 Mar 2014 14:36:33 -0500
Message-ID: <5314D9C1.5000308@dev.mellanox.co.il>
References: <5314CD84.5010104@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237388D1F6A0@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D1F6A0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/3/2014 2:25 PM, Hefty, Sean wrote:
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> diff --git a/examples/riostream.c b/examples/riostream.c
>> index a1d3671..019d9e1 100644
>> --- a/examples/riostream.c
>> +++ b/examples/riostream.c
>> @@ -44,7 +44,6 @@
>>  #include <netinet/in.h>
>>  #include <netinet/tcp.h>
>>
>> -#include <rdma/rdma_cma.h>
> 
> Isn't this now needed for rdma_getaddrinfo?

It's included by rsocket.h so not sure if it should be explicit here or
not. I just made the includes consistent with rstream example.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
