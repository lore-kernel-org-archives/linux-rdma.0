From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 for-next] RDMA/hns: Fix the endian problem for hns
Date: Mon, 05 Feb 2018 10:51:08 -0500
Message-ID: <1517845868.3936.68.camel@redhat.com>
References: <1517836440-80350-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9/RiZaEvyl+uuRvqyFcc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517836440-80350-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-9/RiZaEvyl+uuRvqyFcc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-02-05 at 21:14 +0800, Lijun Ou wrote:
> The hip06 and hip08 run on a little endian ARM, it needs to
> revise the annotations to indicate that the HW uses little
> endian data in the various DMA buffers, and flow the necessary
> swaps throughout.
>=20
> The imm_data use big endian mode. The cpu_to_le32/le32_to_cpu
> swaps are no-op for this, which makes the only substantive
> change the handling of imm_data which is now mandatory swapped.
>=20
> This also keep match with the userspace hns driver and resolve
> the warning by sparse.
>=20
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-9/RiZaEvyl+uuRvqyFcc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp4fWwACgkQuCajMw5X
L93xig//TNmmQtHOBJTa8yVZTpHeOM1RdfKNJJNIY+bkamfPTZPc2sQWkNsQsApV
Yc9EghVYW33yYft3ECVAEXy2H0O5+LRA825Nnr2+e26bA3H2VRSzjBHoisbamPV2
oNCy1Ij1aKDZlP1lIbuaP1g95tGWh7uWvu/pzDtBpuUkyrPE0N8dxsC+I5JjI1ZB
q3Zlkbr79WdAPFjJcGKdOqUFcx30R8s6q/E3+Hy/QR+S4UjR0CJzb2WWD1npejWL
i78JJDR9wGlN1jWJ+s4K87JEj4dEg5HwjMGrqPBBBSQyD2xvXsE0Lwau+K4oXjlV
Yy69eA8E+VToelSyvmHjaANGd1qFMUYyy99yselKnK0luXZkgj+PX/K7HzkLmDSJ
MPeDynCLxxX48NM2EySUUlSdluVy+fXvdoDHc2KF9WNsrVdACSBuR8emK9awcBqH
oKwC+zTEnlPq9L/5W3h9ko6HQipT0Gumh7y4Nc0mPYscl4OmlH8FLB8Qby0xbxVQ
pLxbdgSOSOj2rqYUvuTsjiE0WbapGlgAZdOFsDkHIxr+xFIBIXrMBWea1pDVLPWY
UQaWADqLowaJInYODetaGxBejtFbfxNB0Lxu7+AGrvhWPfnlkClwu4yOovk6rDlg
YNskjDrYYzWOtUbIlKUZDpf2K2QEZL9F1LHWubGV9AQUeFY/Mag=
=7aiv
-----END PGP SIGNATURE-----

--=-9/RiZaEvyl+uuRvqyFcc--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
