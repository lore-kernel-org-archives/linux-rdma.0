From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: [ANNOUNCE] librdmacm-1.0.16
Date: Mon, 13 Aug 2012 17:10:20 +1000
Message-ID: <CAOzFzEhwt-XFowYf4J=cphJ_hxQBmtf0GOZVdS7az2ReH4cfdw@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A61E63@ORSMSX101.amr.corp.intel.com>
	<CAOzFzEgkqKYcP99sGC+SP-pgS2abt1wA9dtJ7x9O99kzO31xtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEgkqKYcP99sGC+SP-pgS2abt1wA9dtJ7x9O99kzO31xtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13 August 2012 06:29, Joseph Glanville
<joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org> wrote:
> Hi Sean,
>
> On 14 July 2012 03:57, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> librdmacm release 1.0.16 is now available from
>>
>> www.openfabrics.org/downloads/rdmacm
>>
>> This release contains several bug fixes from 1.0.15, plus introduces the rsocket API and protocol.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Are there any plans to include SOCK_DGRAM support?
>
> I could see that being potentionally interesting along with mapping
> broadcast/multicast to IB physical layer multicast.

I took a look at linux/net/rds to see if something similar could be
done in terms of transparently supporting existing UDP applications
but some of the semantics I think could get difficult.
Specifically RDS won't send to congested hosts, which is not a UDPism at all.
Also the queuing etc doesn't map very well to UDP, this would have to
be massaged into working nicely.

Has anyone done anything similar to rsockets for exposing IB UD
(transparently) to apps as UDP?

>
> Joseph.
>
> --
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846



-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
