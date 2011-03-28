From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA CM: private_data_len
Date: Mon, 28 Mar 2011 11:46:14 +0200
Message-ID: <1301305574.804.1.camel@dworkin.quest-ce.net>
References: <1301077661.2192.31.camel@deela.quest-ce.net>
	 <4D904B52.5000004@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D904B52.5000004-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le lundi 28 mars 2011 =C3=A0 10:48 +0200, Or Gerlitz a =C3=A9crit :
> Yann Droneaud wrote:
> > On a client, rdma_connect() returns -1 and set errno EINVAL if=20
> > struct rdma_conn_param->private_data_len is set to something higher=
 than
> > 56 bytes.
> >=20
> > But on a server, using rdma_accept() with struct
> > rdma_conn_param->private_data_len is set to 64 (for example) didn't
> > return any error.=20
> >=20
> > What is the maximum data size that can be exchanged between peers a=
t
> > connection time, and where to find its definition (at compile time =
or at
> > runtime) ?
>=20
> yep, this isn't clear from the librdmacm man pages see the patch
> that follows.=20

Oh yes, it's clear now.
Thanks for the patch and the link to IB specs.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
