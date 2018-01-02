From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 02/15] net/mlx5: Set software owner ID during
 init HCA
Date: Tue, 2 Jan 2018 12:10:51 +0200
Message-ID: <20180102101051.GB10145@mtr-leonro.local>
References: <20171224125741.25464-1-leon@kernel.org>
 <20171224125741.25464-3-leon@kernel.org>
 <CAJ3xEMiq-4DGFW-Z3hX3NfsSGXD6bm_uarGF_cm6K7+YuutJBQ@mail.gmail.com>
 <b329f348-2462-2bf4-ee06-064e798c9b86@mellanox.com>
 <CAJ3xEMixQ-Tw9gUYYPhNLvrEbntNTQBvLcVUe+x130hkEq15Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMixQ-Tw9gUYYPhNLvrEbntNTQBvLcVUe+x130hkEq15Bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 02, 2018 at 11:34:03AM +0200, Or Gerlitz wrote:
> On Wed, Dec 27, 2017 at 5:27 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > On 12/24/2017 4:00 PM, Or Gerlitz wrote:
>
> >>> @@ -5531,6 +5533,7 @@ struct mlx5_ifc_init_hca_in_bits {
> >>>         u8         op_mod[0x10];
> >>>
> >>>         u8         reserved_at_40[0x40];
> >>> +       u8         sw_owner_id[4][0x20];
> >>>  };
>
> >> can we do here just a plane addition of bits? don't have the code
> >> infront of me, but seems suspicious
>
> > I don't understand what you are asking.  This is what the tool generated.
>
> Dan, the tool is serving us and not the other way around, so
>
> before your changes we had:
>
> struct mlx5_ifc_init_hca_in_bits {
>         u8         opcode[0x10];
>         u8         reserved_at_10[0x10];
>
>         u8         reserved_at_20[0x10];
>         u8         op_mod[0x10];
>
>         u8         reserved_at_40[0x40];
> };
>
> and now we have a struct which is 128b bigger
> but is used for the same FW command
>
> struct mlx5_ifc_init_hca_in_bits {
>         u8         opcode[0x10];
>         u8         reserved_at_10[0x10];
>
>         u8         reserved_at_20[0x10];
>         u8         op_mod[0x10];
>
>         u8         reserved_at_40[0x40];
>
>         u8         sw_owner_id[16][0x8];
> };
>
> my question is if/why this is legal. Maybe I am wrong, but
> I don't think we can just go and change the size of the inbox
> payload for a command.

Yes, you are wrong. It is ok to change the payload.

Thanks

>
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpLWqsACgkQ5GN7iDZy
WKelbRAAsGWNGSd3iMaOehZuMBGavtKO0Fxwc8fmA7+RAAa2GLYEpb2YajJW/ngk
Qi0C1aURlSoCdQAkDtChUA8dDuBkyt1eBvYTb1W374kPT5RMkPGsdcoxpbtwyoK8
LyTWNVu48lhfqduwwov9Srajd+tyfZ99T2zekbpKDYzHFxg7X756Upic2voEJoCD
M1RKc/Axy+sYYgtbjGRb8p6DgQmPIPswZp7KGcNxuD9vTf/BV+f0gSeXOcif17Qn
zUSCevzCUFc9ls7iL5XD9EP4Wo30r4QpwKRIn9h+wlO+OUvcCn/SWTqHIcHQD+WP
wXrv5fpniTFZz5okUqRYr8PUtBsuYbZnoH10KDzDj3B0XTAQoek8nAg8s9bLLuEB
7Eo4a+fZzsoOmTx1FMNAC7fQknveXaszVQLYImkMhbx90n5cYmvDKMfS0Vvo7DNr
BmhQmHeuMOAzgB49WqVJcqOc9CFp3UgEf7tARWmyLs/dCHG8ajlBiOSe38Na8zWu
xvqrocX2DTBcA525BCdS5FuCMJQ/dApbZUaBmmRUV2UNaLj0bMPjJIfT0v0Z1okx
vk2rLnnN8loJzoUMvZhOielvz7NOJ7mi/pGlfyfIK18aql+Q+KamGEERiAPFJz/T
zc1/o7YxLDSVV5dpGYu6CZkhtJ6UIFyRaZxjXeQVL/PkemwD/RA=
=5Oml
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
