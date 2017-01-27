From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Add inline function to validate port
Date: Fri, 27 Jan 2017 14:34:32 -0500
Message-ID: <1485545672.2432.11.camel@redhat.com>
References: <1485362497-18723-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-1XsGkyzEa0dmcUiamgnA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485362497-18723-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-1XsGkyzEa0dmcUiamgnA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-25 at 18:41 +0200, Yuval Shaia wrote:
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/core/cache.c=C2=A0 | 18 ++++++++----------
> =C2=A0drivers/infiniband/core/cma.c=C2=A0=C2=A0=C2=A0 |=C2=A0 6 ++----
> =C2=A0drivers/infiniband/core/device.c |=C2=A0 4 ++--
> =C2=A0drivers/infiniband/core/verbs.c=C2=A0 |=C2=A0 3 +--
> =C2=A0include/rdma/ib_verbs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 7 +++++++
> =C2=A05 files changed, 20 insertions(+), 18 deletions(-)

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-1XsGkyzEa0dmcUiamgnA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYi6DIAAoJELgmozMOVy/dmXQP/1D3nIDhSZfyWgSaPnfcOdaL
3LkEdnJlXCVDQf05piKbe27mw+ucqDwb0oc9rutrIbrGdRjgj1hCVHj2SC0ko4Y0
neOVEC4cfOXPcfK/8CMcFKyxLNZ6pNWgLjLCMneIkomexW5eXIHZjzTxlcZTlwMF
QLbbNYKkfhjEmraHsGgNpjgD9doypYBKj5LfjIcSEARNTJb3FmCNYvXG2JANBav+
8vaPMlabv9fi3kI4DAis/ir2ocuIANK8IZfG0L4Uo+vzViYbqVemrsokypRPYwz4
HDUJImsYpJ/qoKjUPR5ui5mxBNW7Co8ycs7atbhVaJBh8a9WW16JP69WXj8/rQzt
FU9jOwj8OXtRrltukx7YvoRzxZvHgv/vNBMeVG/hC826n9hFndBYk4HORxACVa7g
3r5aLTCEYccGxmRn6KTnKPrNck4TmFOKd5HkY+6HO8ow0nY9leLNeyKenfZqx6l2
ki4C8ssXb19ieS2piBgloDIB3mX2YUYFcx1hCZ0un0xoFqohlo0knfKbwrlBRuQ9
d8HXpc4zxLDOY2cLfhhgvB3qcEGmFKp0b3UMhGQingXqyEX0qZu+QKdGY65vPD47
xwawLgy3cXS++v56KRCCzREdGSUNFSZoSWcexWC3LDW1e+Bp7P6q2cQnacvNF1Lh
/agRVipMoKO3L4iDCehe
=xRWU
-----END PGP SIGNATURE-----

--=-1XsGkyzEa0dmcUiamgnA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
