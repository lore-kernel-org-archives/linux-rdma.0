From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: fix first byte overwritten for AF_IB
Date: Thu, 18 Dec 2014 10:13:13 +0100
Message-ID: <CAMGffEktJGzk4FyLh85UAu2Y1998OZJ_p8=-6rzsQ28-KwEDzA@mail.gmail.com>
References: <1418744596-25251-1-git-send-email-jinpu.wang@profitbricks.com>
 <1828884A29C6694DAF28B7E6B8A8237399E2DE69@ORSMSX110.amr.corp.intel.com>
 <CAMGffEn9cxNqv48Vyv_TSB5yO7CgGLDHGjVJBRTihPw0v=EJhw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237399E30341@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E30341-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

On Wed, Dec 17, 2014 at 6:58 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> I checked nfiniBand TM Architecture Release 1.2.1 VOLUME 1 - GENERAL
>> SPECIFICATIONS, for RDMA IP CM service,
>> the private data for CM REQ is defined in:
>> Table 532 IP Addressing CM REQ Message Private Data Format
>> So you mean even for RDMA IB, the private data format is also
>> required, could you point me a little more detail?
>
> The RDMA IP CM service Annex in the IB spec defines a range of servic=
e IDs that apply to the RDMA CM.  If a service ID falls into this range=
, the private data format should also match.
>
> For example, an app could start with AF_INET, use an alternate method=
 to resolve the IP address to a GID (such as a user space daemon), then=
 provide the mapped address directly to the kernel using AF_IB.  This p=
revents the kernel from needing to perform a duplicate address resoluti=
on.  The listening side of the connection may still be using AF_INET.  =
In this example, the client side is still required to format the privat=
e data as indicated in the Annex.  I.e. the original IP addressing that=
 was used should appear as part of the private data.

So it's possible on server side listen using AF_INET, but client
rdma_resolve_addr/rdma_resolve_route/rdma_connect with AF_IB?

Jack


>
> The port space (which maps to the service ID) needs to be included as=
 part of the check that determines the format of the private data, and =
not simply the address family.
>



> - Sean



--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
