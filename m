From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] net/mlx5: increase async EQ to avoid EQ overrun
Date: Mon, 05 Feb 2018 11:02:10 -0500
Message-ID: <1517846530.3936.71.camel@redhat.com>
References: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VhciqkttP+dvbQ1+7B5Y"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517840992-29813-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-VhciqkttP+dvbQ1+7B5Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-02-05 at 16:29 +0200, Max Gurtovoy wrote:
> Currently the async EQ has 256 entries only. It might not be big enough
> for the SW to handle all the needed pending events. For example, in case
> of many QPs (let's say 1024) connected to a SRQ created using NVMeOF targ=
et
> and the target goes down, the FW will raise 1024 "last WQE reached" event=
s
> and may cause EQ overrun. Increase the EQ to more reasonable size, that b=
eyond
> it the FW should be able to delay the event and raise it later on using i=
nternal
> backpressure mechanism.
>=20
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.  But if this gets me in trouble with DaveM for sending
a patch to drivers/net, I'm gonna tell him it's because you sent it here
and excluded netdev@ and that it was part of a series related to an RDMA
issue that I took it, all while giving you the evil eye ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-VhciqkttP+dvbQ1+7B5Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp4gAIACgkQuCajMw5X
L917DA//YuOayVQAzaH954J+ev9QinxqtcLYVhCOH6FCxAP91TkV9fKuSL5UeYV0
Pcw3qLQw5MjM+bmUh1CZxQTUqf5VLIr96PLccGgJpcN1URK5P9KPXba7yzJoaozF
uqchD91cHtFUoAzso7Y/cymspg8GWxEcFfJ9Rso+kIoxQEVDOSZqbV7FzYWBjf0k
vvd4tkmLq6ZMcHc81iI9XrMVgfeZ44n037RsKHxImqTquXyZSRNfcaa8FA/HUQ1+
tkyo6s+A0NxJgCRKswVOCK47Yue9CXWiZYRh1BSWId62bl9iu+yEJf/UaV8UP4iU
whUKhBJHrlOVsMsf0IgiELS5OxCvejBcuno1FvEkZ6eY1vbi66IJ2lAkPYj5OMwL
muSZjSp76FB7GyaWZKd3zf0MkLtszTkJbcRWMGwf509mQQyhCsAEvILFOe+pCb+V
orypValwgGuaCgq69+J9taf5D/pBGYSXWZI3ZRAOJr/496wQAb0HpQ+yeRKlc8JK
HX64Ao00SELGoOrcZcir3TxwTW7XyssEUS4HKDRdAmlma/3Z2DVj4DL067YjTQlN
cjiEbhfuywFbZw9toj6fze9y4qbV+e1JO5/sLcVA8iDePMzaubSiMYatAhhEuybe
aasHzGRXF+1wy693O7TnQPXhWOWsof69/Evnppi3FqFOAxlEMU4=
=wwTr
-----END PGP SIGNATURE-----

--=-VhciqkttP+dvbQ1+7B5Y--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
