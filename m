From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA Relaxed Ordering on Linux
Date: Mon, 15 Oct 2012 12:59:47 +0200
Message-ID: <OFA1302BD4.32B4974B-ONC1257A98.003C3F2C-C1257A98.003C6ADA@de.ibm.com>
References: <OF926F7A9B.81FB4B34-ONC1257A91.003EF9D7-C1257A91.00413F9B@de.ibm.com> <CAL1RGDXMicbZcWbpoSJkPnCLX-tN4bfarjeYGxyKHn1JnwXFuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXMicbZcWbpoSJkPnCLX-tN4bfarjeYGxyKHn1JnwXFuQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,
now we opted for a solution without being dependent on RO altogether.
Thank you for your help.

Kind regards
Klaus Wacker
IBM Systems &Technology Group, Systems Software Development
SW Linux on System z Dev & Service
Phone:  +49-7031-16-3779   IBM Deutschland  E-Mail:  kdwacker-tA70FqPdS9Zhl2p70BpVqQ@public.gmane.org=
m
Schoenaicher Str. 220   71032 Boeblingen   Germany
IBM Deutschland Research & Development GmbH / Vorsitzende des
Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: Amtsgericht Stutt=
gart,
HRB 243294


|------------>
| From:      |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>                              =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
|------------>
| To:        |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |Klaus Wacker/Germany/IBM@IBMDE,                                     =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
|------------>
| Date:      |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |08/10/2012 18:06                                                    =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
|------------>
| Subject:   |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |Re: RDMA Relaxed Ordering on Linux                                  =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|





On Mon, Oct 8, 2012 at 4:52 AM, Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
wrote:
> we are doing a Infiniband/RoCE project on Linux/x86_64 based on
> Mellanox/RoCE cards. Our data exchange is heavily build on RDMA. For =
some
> reasons we want to suppress the Relaxed Ordering (RO) of RDMA. This w=
ould
> serialize the RDMA requests on the server in the strict order as issu=
ed
on
> the client.

Does your x86 system really enable PCI relaxed ordering in the first pl=
ace?

 - R.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
