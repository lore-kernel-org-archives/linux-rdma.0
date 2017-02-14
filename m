From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/5] USNIC and RAW enhancements series
Date: Tue, 14 Feb 2017 11:45:34 -0500
Message-ID: <1487090734.86943.80.camel@redhat.com>
References: <20170124110239.31555-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MxOxLGZ7jsR33BO2Ncnr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170124110239.31555-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-MxOxLGZ7jsR33BO2Ncnr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-24 at 13:02 +0200, Leon Romanovsky wrote:
> Hi Doug,
>=20
> Please find below second version og USNIC and RAW protocols
> enhancements from Or.
>=20
> from: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This series adds the USNIC and RAW protocols to the core and relevant
> devices
> (usnic, and mlx5/mlx4 over Eth ports) such that now the protocol part
> of the
> caps covers all in-tree HW/SW devices.
>=20
> It also contains a cleanup patch to the HW/SW drivers such that they
> use
> ib_query_port when needed to query their own ports and not apply
> their
> internal callback. The patch doesn't add new functionality but makes
> the different drivers to be behave the same in that respect and makes
> the IB stack code a little bit more robust and clear.
>=20
> Thanks

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-MxOxLGZ7jsR33BO2Ncnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYozQuAAoJELgmozMOVy/dPx8P/Ri0EG05xpRLujwEaydlrVy4
ATi1oeIzug8dyjvjfO7Gqtgq/dap9N1FwInDgGxDjWIircu4juHpgWmTh8kmDF1b
dl91if4Je8iNVAt6Y3cR3AhduXvn01iBhuFKVyx+cO0aMdRHxh2meJTizleBmsPE
ea26RmQWAC/1QOlcmYv62KZ7ng6EKKHHA1iqdy+H1TtwPThHqBmpcDT2w/IltVMq
vciwHB8WVoniCCgbklArMm5tn/wAX90QyiQqSdzBI4NpcsHUxkWDEt5iaJdsDE9Q
1jzP+Moe8B7odW4pP3QEPaoIH0sAMzPxmEnw4vtPfuy7KVIa4wtugUsLMeoX4E8D
UPWBc7RnOT6Z7HEt31mPNWs4BRA7q6b0Qf7JOa9jiHGFxR8GYhVGsZlzJ/jN5LJC
L9hQoTjPfHceSklGGH7Bd7UXTaVsC5QEIwl02l11MKEgFWxa70FS8ZysPumGMSff
whlrAHkxT91ugdfMf4YXnlW5s/Mc3pRPDWvxMeFko1ytcMoy2R/1PagzaW6Z3s+g
p5IrHXEmT0cj0P7awzPWWY+pUSprp+p6S4q68n5LXQJ0t6N1ZpeKOQOyi3r7smYi
f/6lWxnU0TXejDhco1OROdI8t8Nng/zxf/CGo/26/uNqcvKawsQTDMQaOnfs+dCc
iDTHsjt6TS5H4Im4Bcs4
=pvht
-----END PGP SIGNATURE-----

--=-MxOxLGZ7jsR33BO2Ncnr--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
