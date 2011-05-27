From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH:rdmacm] ucma_init: fail if ibv_get_device_list() returns
 empty list
Date: Fri, 27 May 2011 23:12:01 +0200
Message-ID: <1306530722.1835.18.camel@deela.quest-ce.net>
References: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7@ch.ibm.com>
	 <1306493434.1835.4.camel@deela.quest-ce.net>
	 <BANLkTik4e-kygpRTnxfpTdRMSTbyYNO1_Q@mail.gmail.com>
	 <1306515973.1835.11.camel@deela.quest-ce.net>
	 <1306517515.1835.15.camel@deela.quest-ce.net>
	 <1306518158-7770-1-git-send-email-ydroneaud@opteya.com>
	 <1828884A29C6694DAF28B7E6B8A823730119BA@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823730119BA-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,=20

Le vendredi 27 mai 2011 =C3=A0 18:01 +0000, Hefty, Sean a =C3=A9crit :
> >   ibv_get_device_list() returns the array of available RDMA devices=
, or
> >   sets errno and returns NULL if the request fails. If no devices a=
re
> >   found then num_devices is set to 0, and non-NULL is returned.
>=20
> Thanks.  I think the following fixes the same issue.  If this looks o=
kay to you, I'll will commit.
>=20

You're not handling the error case when ibv_get_device_list() returns
NULL.
We need two different error path: one for NULL and one for empty list.
In the latter case, the list must be freed.

Regards.
--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
