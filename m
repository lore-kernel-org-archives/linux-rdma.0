From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/mlx5: Enlarge autogroup flow table
Date: Wed, 29 Mar 2017 07:23:20 +0300
Message-ID: <20170329042320.GJ20443@mtr-leonro.local>
References: <20170329030901.5772-1-leon@kernel.org>
 <20170329030901.5772-2-leon@kernel.org>
 <1490757621.4362.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dMdWWqg3F2Dv/qfw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490757621.4362.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--dMdWWqg3F2Dv/qfw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 29, 2017 at 03:20:37AM +0000, Bart Van Assche wrote:
> On Wed, 2017-03-29 at 06:09 +0300, Leon Romanovsky wrote:
> > -#define MLX5_FS_MAX_TYPES	 10
> > -#define MLX5_FS_MAX_ENTRIES	 32000UL
> > +#define MLX5_FS_MAX_TYPES	 6
> > +#define MLX5_FS_MAX_ENTRIES	 BIT(16)
>
> Hello Leon and Maor,
>
> The use of the BIT() macro here looks misleading to me. Elsewhere in the
> kernel BIT() is used to represent a bitmask. My understanding is that
> MLX5_FS_MAX_ENTRIES is not a bitmask but a value?

Hello Bart,

I agree with you that the name "MAX_ENTRIES" is misleading. This define
MLX5_FS_MAX_ENTRIES is needed to compare num_entries with max_table_size
which is represented in BIT() format. The max_table was added in previous
patch and we thought that it will be much convenient for the reader to
compare the same BIT(..) constructions.

If you think that we abused the BIT() macro, let me know and I'll send
updated version (without BIT()).

>
> Thanks,

Thanks

>
> Bart.

--dMdWWqg3F2Dv/qfw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljbNrcACgkQ5GN7iDZy
WKeInQ/8Cvoec/TniTdPDQDI+X4I0GEff8Iu8gpLa3CQuA0qZ0b3u3gd6ByudbQA
SYagEc2ukoEBDBPFxBE1TMS9n9UOQ3L2qgVnF3EMPy7+36LHoCTOImJ7fYJ5VskY
QgzhFFh1kVtf77WFrmdRrjRnwX5mK0O+rCVHJJP250oyQoX9ukXzExcBCK9sSC0a
N0DDh0SwBEHPbFc1jnDdowDlwSZfBwifQg9DlJu5hzOGfYbUxjIYuF5aaXugZ1HF
YLfcMgqQjaBixHp5wxdhoBRdzC2SpgDiNniGBcdmbA0CB5fxM3J2NIDwl1O4HjYG
xTT9UWaK4z2PdXQ/VNdPzLxHlMosp1s5/dZvM9DqGCY+EP5UEa4WQ7C73jYDXk8R
XY61cEp/UiSgU7NchnTXfm4juZBOmntdiWbiU2THNk2IBi2q30AtAgJXHCuksp5n
vKC/wunJUQfC9kL07PTqqLoWMVq0lTyXgTJzNCWEumF7r1EQuSdK5cyQDPDVtSzW
odMXZJVVjdoCOWk+w/BJV+rehSytA20axkaLh0yT5cA2mB3h1B7N3sbJWQL2OoIc
sATyb4GJ8Az6bsUX9PVYmJXxus8D7L7IxdC3yzwaYZDHCXalkPoreWZjfQGOEVca
kAxbzelGsEwA4ZNSNrJmmKiIZs298e2Sd4MBe3EhPv6/ecXzXEc=
=Rkrm
-----END PGP SIGNATURE-----

--dMdWWqg3F2Dv/qfw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
