From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Thu, 02 Jan 2014 17:59:59 +0100
Message-ID: <1388681999.22995.46.camel@localhost.localdomain>
References: <527F6896.1080802@mellanox.com> <527F69B1.9070701@mellanox.com>
	 <1828884A29C6694DAF28B7E6B8A8237388CF6F78@ORSMSX109.amr.corp.intel.com>
	 <00000142485f86e5-c3027528-9892-4d5c-8d72-0ed5f98666c4-000000@email.amazonses.com>
	 <1828884A29C6694DAF28B7E6B8A8237388CF6FD0@ORSMSX109.amr.corp.intel.com>
	 <52C533C0.3070103@mellanox.com>
	 <1388675827.22995.7.camel@localhost.localdomain>
	 <1828884A29C6694DAF28B7E6B8A8237388D0FBFA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D0FBFA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le jeudi 02 janvier 2014 =C3=A0 16:33 +0000, Hefty, Sean a =C3=A9crit :
> > After reading quickly the thread, I still believe that's sound like=
 a
> > kernel regression which broke existing userspace applications.
> >=20
> > So a patch must be applied on the kernel to fix that regression.
>=20
> When AF_IB was added to the kernel, corresponding changes were added =
to the librdmacm.
> Those changes to the librdmacm are the cause of the issue.
>=20

I was missing this part, the original message was misleading for me.

So it's the combination of librdmacm >=3D 1.0.17 and kernel >=3D 3.10+ =
which
is affected by the problem reported.

> The kernel rdma cm previously supported a single 'query' call.=20
> With AF_IB, it supports the original call, plus 3 additional calls.
> The problem is the librdmacm using the newer query calls.
> =20
> > Introducing AF_IB must not have changed the behavor for existing
> > applications. Existing applications must not need a new librdmacm w=
hen
> > they don't use newer kernel extensions.
>=20
> An older version of the librdmacm that does NOT support AF_IB should =
work fine.
>=20

Thanks for clarifying this for me.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
