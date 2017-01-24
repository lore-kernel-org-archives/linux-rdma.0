From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/cma: Allow port reuse for rdma_id
Date: Tue, 24 Jan 2017 16:32:46 -0500
Message-ID: <1485293566.43764.85.camel@redhat.com>
References: <20170105141636.23284-1-leon@kernel.org>
         <20170105141636.23284-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Lwxi8qIMO0cC4/tBDVfn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170105141636.23284-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Lwxi8qIMO0cC4/tBDVfn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-05 at 16:16 +0200, Leon Romanovsky wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> When allocating a port number for binding to a rdma_id, assuming the
> allocation is not for a specific port, the rule is to allow only
> ports
> that were not in use before by any other rdma_id.
>=20
> This condition is too strong to achieve the goal of a unique 5 tuple
> rdma_id. Instead, we can compare current rdma_id with other rdma_id
> for
> difference in one of destination port, source address and destination
> address to allow port reuse.
>=20
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to -next, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Lwxi8qIMO0cC4/tBDVfn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8f+AAoJELgmozMOVy/dYdEP/1gEw87kpTaHIB+IXbadmq9+
+FylDI5IN/Tk5BrxH0WfSsu5AvGJ6uqUuB7FrA/Q8eJRNuEXAPkJh+09LZNb7fIq
o/rvbT4BsbbHBN7WJnV33cj4U959FdsvGa7JmJevrL8O2wFkdmx7WjFrODGnT3jQ
McqTBIHiKou7JCtaxt+sTDuWQ53Y2uiq5CkOVNki0GuKtgNp9gsEW1SwMKx9lvUh
xxvmYnTtdpB50G/5vhjCSjHtR+gGsrcVKlFPDf0HiAdVxdTJtk9JMlv0dvAAxxLB
APenqF5Glsb0TXyYfvwy6AbtUu+DhNKdgXOO6ReydWSkwQ0T/P4ox90VqbB7znWX
58VvvwkgTUbm06X4U5kWrTwyKdtDafSdSL6gelPMOZdMX5zG31ifZeU/lXNB+LNl
FXi1ZBnNxNXfztOftpOIEldJjJb2S5lEc3+R49WrimRgtw/mIhNlsNEtWhlqFYsd
2GxdPVRNWZ8jTB+4/ONOoEAYS94U3FpnJaGlpwZ8oITpHOM1nRYUZ9iwPUed69+2
74dqEIN4/DXvmTrA/+YO9gMncB6j8aWvF3wfLmjWuYd1mTlkdGo2S/qIDAlKa7rQ
gNWJBDtTXg/yruWq68iskXNIxXYeaLjXIYQYGqcIwnmc6Cpu+hpnhI2x/thYKo95
VhX4M0/wTbcaMGKiR5Ln
=6qxO
-----END PGP SIGNATURE-----

--=-Lwxi8qIMO0cC4/tBDVfn--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
