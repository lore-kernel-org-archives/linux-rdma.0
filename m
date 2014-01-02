From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: Fwd: IPoIB and STP
Date: Thu, 02 Jan 2014 17:42:21 +0100
Message-ID: <1388680941.22995.41.camel@localhost.localdomain>
References: <CAJH6TXgBySmP9JG=dt1Gp8_oYPBK+g=O84DOjpUu-sZZJ9p-6g@mail.gmail.com>
	 <CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le samedi 28 d=C3=A9cembre 2013 =C3=A0 12:08 +0100, Gandalf Corvotempes=
ta a
=C3=A9crit :
> Hi,
> i'm trying to configure a redundant IPoIB network.
> Obviously, IB switches doesn't talk IP and so doesn't have STP suppor=
t.
>=20

Beware, you're mixing L3 and L2.

STP, Spanning Tree Protocol (IEEE 802.1D), is a component of Ethernet,
which is Layer-2/Link layer. It does not involve IP, which is
Layer-3/Network layer. IP is not bound to Ethernet, indeed.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
