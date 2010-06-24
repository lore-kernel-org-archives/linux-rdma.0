From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA synchronous operations
Date: Thu, 24 Jun 2010 21:21:02 +0200
Message-ID: <4C23B01E.2050100@gmail.com>
References: <4C2312F0.8020308@dev.mellanox.co.il> <964270.1277390217198.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <964270.1277390217198.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

On 24/06/2010 16:36, Andrea Gozzelino wrote:
> Hi all,
>
> I=E2=80=99m testing the latency time of an RDMA system (2 card and 1 =
switch).
> The connection server/client is established and the code is just as
> mirror on both sides.
>
> The RDMA action scheme is below:
> 1-	client sends a buffer;
> 2-	server receives a buffer;
> 3-	server sends a buffer;
> 4-	client receives a buffer.
>
> The scheme is in a for loop, so after step 4 client repeats step 1.
> On client side I put a clock: t_start is before loop and t_end is aft=
er
> loop.
> I consider the round trip time RTT as (t_end-t_start)/NTX where NTX i=
s
> number of transfer (number of loop). The latency time is half RTT, if
> transfer time is negligible, i.e. for small (8 Bytes =E2=80=93 4 Kbyt=
es) buffer
> size and high NTX value (>  10000) is true.
>
> The RDMA communication stops casually with error status 5. It means t=
hat
> the send or receive operation on one side (server or client) casually=
 is
> not in time. I summarize post_send and post_receive operation are
> quasi-synchronous. I would like that RDMA operation are completely
> synchronous. I use the completion queue and the acknowledgement event=
=2E
>
>   =20
Do you have any asynchronous event handler on the QP/SRQ?
(maybe there is an error on your QP/SRQ)

Did you get any completion with error before the completion with status=
 5?

Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
