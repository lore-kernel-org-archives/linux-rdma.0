From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Free QP PBLEs when the QP is destroyed
Date: Sat, 22 Jul 2017 13:25:38 -0400
Message-ID: <d7820cca-36c0-1635-a490-bc51a2111adb@redhat.com>
References: <20170706022533.34860-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FiJGuXSknWglGUxxe4e5FPCKWlMQddmLu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170706022533.34860-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FiJGuXSknWglGUxxe4e5FPCKWlMQddmLu
Content-Type: multipart/mixed; boundary="t9xhXROEi0cLIPSNqkM8choHULVX4CiTR";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <d7820cca-36c0-1635-a490-bc51a2111adb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Free QP PBLEs when the QP is destroyed
References: <20170706022533.34860-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20170706022533.34860-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--t9xhXROEi0cLIPSNqkM8choHULVX4CiTR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/5/2017 10:25 PM, Henry Orosco wrote:
> From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> If the physical buffer list entries (PBLEs) of a QP are freed
> up at i40iw_dereg_mr, they can be assigned to a newly
> created QP before the previous QP is destroyed. Fix this
> by freeing PBLEs only when the QP is destroyed.
>=20
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--t9xhXROEi0cLIPSNqkM8choHULVX4CiTR--

--FiJGuXSknWglGUxxe4e5FPCKWlMQddmLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4qSAAoJELgmozMOVy/dwu4P/1RGBJzimT+CZYZ395WhB5/a
dHl/kj4fypUTlJSNrs+S92ZMqfTw3XcmpbN+tyR5PCVPTiZeQ8kdpoQNOBuffcMm
NrHMrkPdjo5KwB1mTd1E1ALydMdXmJGIseWrPm9j/eMYUnppx9uqn1l1AenIMue1
eclhHhnbLt3DTx6q/7qeYLI2XOfEMXSGcDKNZ/7qeDtmse9yDJAZzDtShrWi993W
iOhfguDukUSixBSL+/YaB+EYIQSqi7E+KM1tPEvfqvuOM1JgGSpwS8+vpQ2thX8K
S0e2j7ggbYqidTc/AoIo2Waj8okjJXySYChpTwxtAlg/OS/n1P9Ol/LOyLizO/Gt
+M/qZG8lbBHwSbkr7Ms/jxQDQn5O3v0UfIzvXnHLfWpVdgw6Ao7UjHPM7zrZQ2Zv
jNpMIcvVIoyOX9o4clVPn7RNXw6uXVQukw9blFlpJBcfhZa2vYk9dh0irDmq11Nn
x0uISrk8fC9aoaDgbiJOVVyB9KPOrzDTGh82yO4oHUfUjuElF9dOSPH4TwHO7v9A
AYe90kifFvqALh+4h6gVWG1Lz0V98uZ6w/ABrbUJrGIwW8esSzjVMYjIKTOgPO2c
8nfnwHdrzYtK61WqeXXyllRybClkfFMXAjCzJkch034WV+0COlZHNM9aUO4j4wE8
PPr2NjJ7+qUJhzYH1dzi
=5WgY
-----END PGP SIGNATURE-----

--FiJGuXSknWglGUxxe4e5FPCKWlMQddmLu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
