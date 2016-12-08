From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Thu, 8 Dec 2016 16:08:05 -0500
Message-ID: <cd667d80-cc1b-c8df-07d1-a5e7b9f94c68@redhat.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <a909ae78-ed49-407a-29c7-b86729f356b8@redhat.com>
 <CA+sbYW1P4MqsBF14d9ZK_VjV4edU2bh=sLNTVnGs9F3ojF6vWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pn7dCiFpOqaOMwRSX4Mk5gHqmTpsj5HPj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+sbYW1P4MqsBF14d9ZK_VjV4edU2bh=sLNTVnGs9F3ojF6vWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pn7dCiFpOqaOMwRSX4Mk5gHqmTpsj5HPj
Content-Type: multipart/mixed; boundary="JfIt5IBJPvMttkffwtcD0kOLl2IMuwNsN";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <cd667d80-cc1b-c8df-07d1-a5e7b9f94c68-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
References: <1480919912-1079-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
 <a909ae78-ed49-407a-29c7-b86729f356b8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CA+sbYW1P4MqsBF14d9ZK_VjV4edU2bh=sLNTVnGs9F3ojF6vWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CA+sbYW1P4MqsBF14d9ZK_VjV4edU2bh=sLNTVnGs9F3ojF6vWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--JfIt5IBJPvMttkffwtcD0kOLl2IMuwNsN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/8/2016 4:38 AM, Selvin Xavier wrote:
> On Thu, Dec 8, 2016 at 5:03 AM, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>> +#include <net/dcbnl.h>
>=20
> in the kernel which i used for compilation and testing,
> linux/netdevice.h is including net/dcbnl.h. bnxt_re_main.c is
> including netdevice.h.  Anyway, i will add this explicitly in
> bnxt_re_main.c in V2.
>=20
> Doug,
>  Since David Miller applied the bnxt_en changes to his net-next tree
> (both pending patches and bnxt_re related changes), can you please
> pull those changes to your bnxt_re branch?
>=20
> Thanks,
> Selvin
>=20

I had already pulled the changes, I just hadn't pushed them.  Now pushed.=


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--JfIt5IBJPvMttkffwtcD0kOLl2IMuwNsN--

--pn7dCiFpOqaOMwRSX4Mk5gHqmTpsj5HPj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYScu2AAoJELgmozMOVy/dyhsP/1njywWhLlw6DnwVAnyrkUk5
Uy9sfToF+YisVKhU5RM2pMjy7uLt0DNV89sck5RReAzZp/vHrwogbVWrpsUqOyX9
Dfx8P2hGrrgF+f1uarXsOccHEypnsadilKQCBcjbN9h0gnCHKwrbIFxxFHCe5CnS
koLZHB53Wmb6921xdTNKP7YsB7g5R+/zuulwyWwuLYd0W5kQFuSZWghi0fRXR6Tr
NBMbwK+KF3hYondMSMjlHBY8ZV3DD6P6L2ErkXY/dMWa4pGHEflyCe25HX5PGG8D
BZ5ZP6P8hHVeQjlA9JXby1odhPyv/kaW1Hx+FIdUgS7JK7NC78RNQMkkyqzZtKfl
fiA4XmcAWrn+LG/s8hzrJPOlZtsh6kY3rx7j5G1AcVg1Zt+HWKoRIjHafzJF1o8C
G4bbEBU68n/QZD/n8P4frHM0oJEuTKbUK/OSCoStV4RpjtWn3Poo9W6JSLkWDqbq
XtFWSAe7qaReq6jw8vRWrXjWI61+sQqL2BW4NMq96h7ocheQWgqR2dfoF6JMMbrc
M5kCpr4cyPxoxETZILfDX/O18ixX9+O4pKOcnW8A5RwgSYUJflwXwSX7zKQMhA/p
U+KDosf5T5W1IS/9GGG6dqWUMa9jJOWCtQZG26puJ8Y6NUuvc5T4X0qKCeEbBjUS
gaPO+ODScKJuo2I4hlhn
=FlTU
-----END PGP SIGNATURE-----

--pn7dCiFpOqaOMwRSX4Mk5gHqmTpsj5HPj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
