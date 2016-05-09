From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [oss-security] CVE Request: Linux: IB/security: Restrict use of
 the write() interface'
Date: Mon, 09 May 2016 21:48:59 +0200
Message-ID: <1462823339.4268.54.camel@opteya.com>
References: <20160507042232.GA5286@eldamar.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160507042232.GA5286-yvBWh1Eg28aNj9Bq2fkWzw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Red Hat Security Response Team <secalert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <benh-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le samedi 07 mai 2016 =C3=A0 06:22 +0200, Salvatore Bonaccorso a =C3=A9=
crit=C2=A0:
>=20
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
> > For the immediate repair, detect and deny suspicious accesses to
> > the write API.
> >=20
> > For long term, update the user space libraries and the kernel API
> > to something that doesn't present the same security vulnerabilities
> > (likely a structured ioctl() interface).
> >=20
> > The impacted uAPI interfaces are generally only available if
> > hardware from drivers/infiniband is installed in the system.

As a workaround, I would suggest that systems which do not require
(userspace) RDMA/Infiniband to blacklist/remove the following modules:

=C2=A0 rdma_ucm
=C2=A0 ib_uverbs
=C2=A0 ib_ucm
=C2=A0=C2=A0ib_umad

=46or example, adds the following in /etc/modprobe.d/blacklist.conf

=C2=A0 blacklist rdma_ucm
=C2=A0 blacklist ib_uverbs
=C2=A0 blacklist ib_ucm
=C2=A0 blacklist ib_umad

Those building their own kernel might want to disable, if not already,

=C2=A0 CONFIG_INFINIBAND_USER_ACCESS,=C2=A0
=C2=A0 CONFIG_INFINIBAND_USER_MAD,
=C2=A0 CONFIG_INFINIBAND_ADDR_TRANS

(Unfortunately the last one will also disable those features:
=C2=A0 iSCSI Extensions for RDMA (iSER)
=C2=A0 iSCSI Extensions for RDMA (iSER) target support
=C2=A0 RDS over Infiniband and iWARP
=C2=A0 9P RDMA Transport (Experimental)
=C2=A0 RPC-over-RDMA transport
=C2=A0 =C2=A0 (which actually disable NFSoRDMA))

Regards.

--=C2=A0
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
