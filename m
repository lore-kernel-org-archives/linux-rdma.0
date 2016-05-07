From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [oss-security] CVE Request: Linux: IB/security: Restrict use of
 the write() interface'
Date: Sat, 07 May 2016 20:19:46 +0200
Message-ID: <1462645186.4268.27.camel@opteya.com>
References: <20160507042232.GA5286@eldamar.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160507042232.GA5286-yvBWh1Eg28aNj9Bq2fkWzw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le samedi 07 mai 2016 =C3=A0 06:22 +0200, Salvatore Bonaccorso a =C3=A9=
crit=C2=A0:
>=C2=A0
> Jann Horn reported an issue in the infiniband stack. It has been
> fixed
> in v4.6-rc6 with commit e6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3:
>=20
> https://git.kernel.org/linus/e6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3
>=20
> >=20
> > IB/security: Restrict use of the write() interface
> > The drivers/infiniband stack uses write() as a replacement for
> > bi-directional ioctl().=C2=A0=C2=A0This is not safe. There are ways=
 to
> > trigger write calls that result in the return structure that
> > is normally written to user space being shunted off to user
> > specified kernel memory instead.
> >=20

That's an interesting issue.

I thought access_ok() done as part of copy_to_user() would protect from
such unwelcomed behavior. But it's not if the kernel invoke write()
handler outside of a user process.

Anyway, as I don't see yet how to reproduce the issue, is there a PoC
available, I would be interested by a mean to trigger such write().

Regards.

--=C2=A0
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
