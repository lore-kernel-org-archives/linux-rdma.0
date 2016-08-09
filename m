From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V3 1/7] RDMA/core: Export RDMA IOCTL declarations
Date: Tue, 9 Aug 2016 20:46:33 +0300
Message-ID: <20160809174633.GA23921@leon.nu>
References: <1470760775-6813-1-git-send-email-matanb@mellanox.com>
 <1470760775-6813-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470760775-6813-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 09, 2016 at 07:39:29PM +0300, Matan Barak wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Place all external RDMA IOCTL declarations into one UAPI exported
> header file and move all legacy MAD commands to that file.
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/user_mad.c  |  2 +-
>  include/rdma/rdma_ioctl.h           | 38 ++++++++++++++++++++++++
>  include/uapi/rdma/Kbuild            |  1 +
>  include/uapi/rdma/ib_user_mad.h     | 12 --------
>  include/uapi/rdma/rdma_user_ioctl.h | 59 +++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 99 insertions(+), 13 deletions(-)
>  create mode 100644 include/rdma/rdma_ioctl.h
>  create mode 100644 include/uapi/rdma/rdma_user_ioctl.h

Regarding this patch,
We created proper series instead of this one and will submit in near
future.

Thanks.

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqhb5AAoJEORje4g2clink3MP+QFi+0veZxCQQAtVgJJ8n0Ie
+8uLWMS9UTtaFOHbVKI+dSwZg/kZpYB4mB95qmB5J/cfSJFdjkOW97xNGWyv+be0
r3anDfZjLysAir9k0gr10WLzx9Z07mRy2i0JWKCeC0xPb+XpF40lqKh3pBU8YgPI
hrm1fBI1tvVHDKVCMQprBuSwNtAOTu29ShYw1oSXBm+8XBA+nu2c4A2olRXfNiAJ
5hxPLl15dXOh1m+zzZoC5T5S4MN1rZDFgOAwyuNne7bRHvIucTBPdIPyDdy+Qcc9
nQTgGM3JrJwRszxhjI6hahp9efaxCOSE8r7tVrJcisrSXBVKftAuxKQ2I0O0FjRT
1ENuG651MbLnOdbxLuUcDvFcFxjVPOwU3CFVXB4wRfkfHPkV8WWqbB98bgnSLwJn
EAC8h3QF+rlAxNTvNs5Ouo4qDiUczCRbOzu7GmNxcwA+0bdl7uTWnBrgmh99spbp
4shnMghj51YgQZcWqWp56JD3tNliqFGRHaQ1ETfbOEcKYvzpTFWA3oGMy/dlx8Gd
zDreudZoyzAsK4cTXFlgVxt/az/wQ2iMGpsneNj3wca9liWGtA5s9K/ylbPwprwW
6j5iWXTLa6f5x7N6wLmusHUVHI3V/y3++fVxRKqWj9evXsXzPCIZ8iUI6EYRXMwl
XSelAClbU3wPY6FkIGqg
=gvjK
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
