From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Fixing segfault in libibverbs
Date: Fri, 27 May 2011 19:06:12 +0200
Message-ID: <1306515973.1835.11.camel@deela.quest-ce.net>
References: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7@ch.ibm.com>
	 <1306493434.1835.4.camel@deela.quest-ce.net>
	 <BANLkTik4e-kygpRTnxfpTdRMSTbyYNO1_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTik4e-kygpRTnxfpTdRMSTbyYNO1_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,=20

Le vendredi 27 mai 2011 =C3=A0 09:22 -0700, Roland Dreier a =C3=A9crit =
:
> >> This patch fixes SEGFAULT in libibverbs in case when there are no =
user
> >> space drivers found. I've cloned the libibverbs from
> >> git://git.openfabrics.org/ofed_1_1_5/libibverbs.git (I hope this i=
s
> >> correct)
>=20
> Thanks for the patches.  I think I would prefer to fix this more like=
 the
> following (sorry for the attachment, using the gmail web interface AT=
M).
> This actually simplifies things I think, and sticks to the original i=
dea
> that we should only be calling ibverbs_init once.
>=20
> I only compile tested this, can one of you guys confirm this also fix=
es
> the problem?
>=20

It fixes the problem of segfault on empty driver list.

But __ibv_get_device_list() returns a non NULL pointer when there's no
device.

> -       if (!num_devices)
> -               num_devices =3D ibverbs_init(&device_list);
> +       pthread_once(&device_list_once, count_devices);
=20
It miss

        if (!num_devices)
               return NULL;

>        if (num_devices < 0) {
>                errno =3D -num_devices;
>-               goto out;
>+               return NULL;
>        }

Tested-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

BTW, my others patches are still interesting.

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
