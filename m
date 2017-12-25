From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 02/15] net/mlx5: Set software owner ID during
 init HCA
Date: Mon, 25 Dec 2017 07:35:34 +0200
Message-ID: <20171225053534.GT2942@mtr-leonro.local>
References: <20171224125741.25464-1-leon@kernel.org>
 <20171224125741.25464-3-leon@kernel.org>
 <CAJ3xEMiq-4DGFW-Z3hX3NfsSGXD6bm_uarGF_cm6K7+YuutJBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Jz4B0QKJ3xxfGEtb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiq-4DGFW-Z3hX3NfsSGXD6bm_uarGF_cm6K7+YuutJBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Jz4B0QKJ3xxfGEtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 25, 2017 at 12:00:43AM +0200, Or Gerlitz wrote:
> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >
> > +#define MLX5_ARRAY_SET(typ, p, fld, idx, v) do { \
> > +       BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 32); \
> > +       MLX5_SET(typ, p, fld[idx], v); \
> > +} while (0)
> > +
>
> Parav, Dan, we I pointed to you during the dscp trust mode work, changes
> to this area of the code should have the RB sig of Eli Cohen or Saeed if you
> can't get Eli, please do that.
>

Or,

This patch and other patches in this series were seen by Saeed during
preparation to shared code pull request. In addition, he was being added
as an reviewer for the months.

Thanks

--Jz4B0QKJ3xxfGEtb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpAjiYACgkQ5GN7iDZy
WKfkQw//RHxW4cd6CrzmLZIY9W9y7vHJrdlIQ8gRrsbHTIQ8qpwmtDRy49/S9bPQ
vtYdFjkUpyJD463YOXwWkpNaeeulR15NpS5BVcI0MFiBjdt8Qhap2h5VWdxo821s
qd02yuXbZ2YbgbxSA7+6S5xlrjThe/P2USfX0IXt7s7GU6tr8hP2plGT1h9sU+Ug
gkVsZvKtHX4Bfv6YS0gMPZSMSFP2KhfQZ/K1CXCk5gqdizOXJPS9XzMdTARELk7Y
qzArrz2uPd5ABm6Ib2lARqKQ204hhoCcHZXXJpC3Lxz/WidNNEHM2aLZcqdjTUQx
jmAjvceXANYMnqoOYNRZrBmc2Exbc+wx63ODLC1H8rh59W2ijtyKg+7rE9Xzad7B
w4lbGMTy2uG/xVceX5AGQZNA4WmVEOdWQP4scbxaL7T0tuQgxwAseNNNjPRdku3f
kguNvMttUcqJUdjEqdNgdhhOyXRwo1PA1/WgHf0U255m3JG8mgxa5S35b/IbqSdB
I/GTr4HSXP7bYhuW32T60ugQrUXep1yT/vKsZ/IQMilQYgpjIa26krtRrqYfNQb4
EqCcolNZc2L5uE/tpdMi+DxOjFvuK4ukDZ0N1+j9dyLLo/NQj/csH+66DMxTOCcD
NmYExkyjz6OLOGSXV6VoEKBr3M2y/AW5d73hqYX+ap57lS/GL3E=
=x3Lc
-----END PGP SIGNATURE-----

--Jz4B0QKJ3xxfGEtb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
