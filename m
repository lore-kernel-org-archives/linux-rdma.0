From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Thu, 02 Jan 2014 16:17:07 +0100
Message-ID: <1388675827.22995.7.camel@localhost.localdomain>
References: <527F6896.1080802@mellanox.com> <527F69B1.9070701@mellanox.com>
	 <1828884A29C6694DAF28B7E6B8A8237388CF6F78@ORSMSX109.amr.corp.intel.com>
	 <00000142485f86e5-c3027528-9892-4d5c-8d72-0ed5f98666c4-000000@email.amazonses.com>
	 <1828884A29C6694DAF28B7E6B8A8237388CF6FD0@ORSMSX109.amr.corp.intel.com>
	 <52C533C0.3070103@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52C533C0.3070103-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 02 janvier 2014 =C3=A0 11:39 +0200, Or Gerlitz a =C3=A9crit :

> Can you please prepare a fresh (gift to 2014) release of librdmacm, s=
uch=20
> that distributions && people using kernels >=3D 3.11 will be able to =
have=20
> this functionality restored once they upgrade librdmacm.
>=20

Why is this issue addressed by a patch in librdmacm ?

After reading quickly the thread, I still believe that's sound like a
kernel regression which broke existing userspace applications.

So a patch must be applied on the kernel to fix that regression.

Introducing AF_IB must not have changed the behavor for existing
applications. Existing applications must not need a new librdmacm when
they don't use newer kernel extensions.

Regards.

PS: Happy new (gregorian calendar's) year 2014 and best wishes ;)

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
