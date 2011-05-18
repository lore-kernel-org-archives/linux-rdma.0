From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 18 May 2011 12:22:52 -0700
Message-ID: <BANLkTi=cLjErM3pKzihyFtGWZ0kSu9BiPA@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <BANLkTimWMU9ohSQGYEEnFR0HbBaypFR51A@mail.gmail.com> <20110518170226.GA2595@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373FBC7@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373FBC7-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2011 at 10:30 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
>> As long as the version number in the ibv_context is increasing and n=
ot
>> branching then I think it is OK. 0 =3D what we have now. 1 =3D + XRC=
, 2 =3D
>> +XRC+ummunotify, etc. Drivers 0 out the function pointers they do no=
t
>> support.
>
> I was thinking more along this line, but I can see how using a named =
extension could be useful for OFED or vendor specific extensions that a=
ren't part of the upstream libibverbs. =A0(Whether _that_ is useful is =
another matter, but it seems to be the world that we're in anyway.)
>

Exactly... we seem to be in a world of branches, and I do think that
decoupling independent extensions is better for everyone.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
