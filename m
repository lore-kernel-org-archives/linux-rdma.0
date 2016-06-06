From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs 0/3] Scatter FCS support
Date: Mon, 6 Jun 2016 18:59:46 -0400
Message-ID: <e204445a-1f37-2d4e-8658-e8f827ca21d8@redhat.com>
References: <1463662369-18395-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FoBTcC1hkc4PefavslEipC7agQSucmAQ6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463662369-18395-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FoBTcC1hkc4PefavslEipC7agQSucmAQ6
Content-Type: multipart/mixed; boundary="h3JRKhCxwXtdgKs8E0tDR2a83Xn5b1RCV"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <e204445a-1f37-2d4e-8658-e8f827ca21d8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs 0/3] Scatter FCS support
References: <1463662369-18395-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1463662369-18395-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--h3JRKhCxwXtdgKs8E0tDR2a83Xn5b1RCV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/19/2016 8:52 AM, Yishai Hadas wrote:

> Frame Check Sequence(FCS) is an error detecting code that terminates an=

> Ethernet frame. When using Raw Ethernet, users sometimes want to
> validate the FCS themselves, and therefore it should be scattered to th=
e
> receive buffers.
>=20
> This series adds the above support.
>=20
> The user can control scattering the FCS using Queue-Pair(QP) creation f=
lag
> called IBV_QP_CREATE_SCATTER_FCS.
>=20
> Also, to report this new device capability, we had to add a new device
> capability flags in the uverbs response called device_cap_flags_ex, sin=
ce all
> the current device_cap_flags are occupied.
>=20
> device_cap_flags_ex 0-31 bits are identical to the legacy device_cap_fl=
ags, and
> the upper 32 bits (32-63 bits) report new extended device capabilities.=

>=20
> Devices that support scattering the FCS should report it in device_cap_=
flags_ex
> using IBV_DEVICE_RAW_SCATTER_FCS.
>=20
>=20
> Majd Dibbiny (3):
>   Extend devinfo verbosity mode
>   Add extended device capability flags
>   Add SCATTER_FCS QP create flag
>=20
>  examples/devinfo.c            | 96 +++++++++++++++++++++++++++++++++++=
++++++++
>  include/infiniband/kern-abi.h |  2 +
>  include/infiniband/verbs.h    |  8 ++++
>  man/ibv_query_device_ex.3     |  1 +
>  src/cmd.c                     | 13 +++++-
>  5 files changed, 119 insertions(+), 1 deletion(-)
>=20

Thanks, series applied.


--h3JRKhCxwXtdgKs8E0tDR2a83Xn5b1RCV--

--FoBTcC1hkc4PefavslEipC7agQSucmAQ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVgBtAAoJELgmozMOVy/dhQIQAMKbk/cP5+mBCSQ9dP1mXUs7
c2XaY2KrxSEFdv0z7QxvbD8vAjDKyQzfCERHksU34hQrfanBfy74iRXKEVucKfOi
t31O+3X3e/w8/mWwcVexTvULajpkIg08Z4loJK3kkBS30q/s1QKBApYdWqW2K6CX
87lvcPOkbgUEJ930Q1Jo5LIYPVPeFfmacq0lDuiczfpuOECsxbQj5RgPdeX6G7Cs
+lwBAWHCMiwh2kKKugcl8MfjeuGiITEtfJ83QoQ+GA+f4aLxwrGNrGaeHDl0wEdE
IWLYhk7/xJG83OR+gFG2LuI1h64bjROqccpwZaZkMqWw17p/ZBIKWt+aXdnPkGTq
wTbvAc8MQm8R1urNLkIxVy1KmsjPp5dzLDYupIAJnv/i1doc4X4Kh0cFk4ANVdVc
jvfFmUbL/3TvH3WmGH3/eicQadM9L+FhenVgmtatrn9Pi62+/Tu4cdfmaGTqNG1E
tJhFJ7chPZNlGe1n9iYyH2Rh/+j2gCPimgyWXfiQdBrpYM3j0cJJMlIHoknleNWH
WKuF3pm/JpDCdvBs6qvekQNXSE1wFcZvosNfncsrKYrtrQZQ/qXH5ivbNRQTb12K
2m7w1pJRMwX1GPirRCI58OMoMtZxHenD0sklf85mOspXUlTTu/pjVx9LkEwPfJD9
N6oDKi6Qa9ypU1U8NkV8
=KikH
-----END PGP SIGNATURE-----

--FoBTcC1hkc4PefavslEipC7agQSucmAQ6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
