From: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Subject: Re: [PATCH] Fixing segfault in libibverbs
Date: Fri, 27 May 2011 19:31:30 +0200
Message-ID: <1306517491.1835.14.camel@deela.quest-ce.net>
References: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7@ch.ibm.com>
	 <1306493434.1835.4.camel@deela.quest-ce.net>
	 <BANLkTik4e-kygpRTnxfpTdRMSTbyYNO1_Q@mail.gmail.com>
	 <1306515973.1835.11.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306515973.1835.11.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 27 mai 2011 =C3=A0 19:06 +0200, Yann Droneaud a =C3=A9crit =
:

> But __ibv_get_device_list() returns a non NULL pointer when there's n=
o
> device.
>=20

=46orget about my comment, I haven't checked the manpage for the functi=
on:

ibv_get_device_list(3) :

RETURN VALUE

ibv_get_device_list()  returns  the array of available RDMA devices, or
sets errno and returns NULL if the request fails.  If  no  devices  are
found then num_devices is set to 0, and non-NULL is returned.

I'm sending a patch against rdmacm to address the problem.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
