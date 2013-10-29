From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: AW: ACK behaviour difference LRO/GRO
Date: Tue, 29 Oct 2013 14:55:45 +0200
Message-ID: <526FB051.5020709@dev.mellanox.co.il>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>,<526F725A.1040009@mellanox.com> <12EF8D94C6F8734FB2FF37B9FBEDD173585A0CFD@EXCHANGE.collogia.de> <526F9F5A.7010903@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526F9F5A.7010903-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=D7=91=D7=AA=D7=90=D7=A8=D7=99=D7=9A 10/29/2013 1:43 PM, =D7=A6=D7=99=D7=
=98=D7=95=D7=98 Or Gerlitz:
> On 29/10/2013 13:10, Markus Stockhausen wrote:
>> Just to be on the right way: What are the basics to get GRO working
>> with a ConnectX (not 2 or 3) card in 2044 MTU datagram mode?
>>
>> - enable GRO with ethtool.
>> - Activate Coalescing with ethtool? If yes how?
> GRO is SW element of the network stack, so the HCA doesn't matter, yo=
u=20
> need IPoIB to support that correct and enable it with ethtool
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
In addition to what Or just wrote,
GRO currently doesn't work on ipoib interfaces, that according to bad=20
handling mac address that are not 6 bytes (we have plans to fix that in=
=20
the near future), that is the reason you don't see 64k packets on=20
tcpdump (like you see in LRO).

you have few options:
1. use old kernels and enable LRO (which works fine with ipoib)
2. use CM mode instead of UD, that probably will improve the performanc=
e.

Thanks, Erez
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
