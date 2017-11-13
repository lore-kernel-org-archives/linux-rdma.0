From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: avoid uninitialized variable warning in
 create_udata
Date: Mon, 13 Nov 2017 16:14:36 -0500
Message-ID: <1510607676.3735.37.camel@redhat.com>
References: <20171110221053.3549147-1-arnd@arndb.de>
         <20171111092105.GU18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-U+NHCnYo+NQwgQ1cc7rY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171111092105.GU18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-U+NHCnYo+NQwgQ1cc7rY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2017-11-11 at 11:21 +0200, Leon Romanovsky wrote:
> On Fri, Nov 10, 2017 at 11:10:31PM +0100, Arnd Bergmann wrote:
> > As Dan pointed out, the rework I did makes it harder for smatch and oth=
er
> > static checkers to figure out what is going on with the uninitialized
> > pointers.
> >=20
> > By open-coding the call in create_udata(), we make it more readable for
> > both humans and tools.
> >=20
> > Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Fixes: 12f727721eee ("IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL usage"=
)
> > Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> > ---
> >  drivers/infiniband/core/uverbs_std_types.c | 21 ++++++++++-----------
> >  1 file changed, 10 insertions(+), 11 deletions(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-U+NHCnYo+NQwgQ1cc7rY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKCzwACgkQuCajMw5X
L92kaw//cthcnBeEBRHPiYG6tjOlywNfyXYifkwYxUXEIOd4MUwWB83+AKceHJUr
Vxng/spTgfL/VDhF7HxnL71QXGgVtWJGeQoREulhnrPSjWwMGll6MsDMlyF4sL3e
hsn4A5iPAPIYmwXTgJfaJ23MRHUzykWl6u/Err98PL2d9ql2/rJdfT6BG/oSHVOv
oY+vhd/PXkHDgGGZb44Ekr2rzNhNK7v+Vt03w/BGkw069qnUUjcknSC1FKtKiG6a
zH02PU7CEu5svETByMDt8Q27MtioOxY/QHPJjxivom3vE3rQJemYSLuhuFBZ+y5f
0sA/wIHft9POyIqIdwAdDlNSZEPbxr1401vHMN8ylO9ysgyWzvUZux6vEoP3o6L4
UUmdE6JSbLp5CQ1Z+rMQS/vyH3ysBSwYvdAbEQxyAxajny0JFNpLTuhdKFw84Hje
TB6ov/CiZqHZ05qGugt3vwZF9+J5RTvssPaxkeezhGzXC/XsGrXoo35+gFsq66Uy
jdnjM5Io7BhyFijX+9J8PLRkIlH0sCYYLxZc6/+TJGnC4ipzrFsh6ZYBl087Yt2W
BEXiQIHuL3vi792hpsRzZnPo5ei1/gheu4OD3SUyi72JzIQZ7l8BUI3+0p2Kdess
hEb25adv7UeJWu19MaKcaZMsYbErh3L85c5WAUOjBTb17kIMEeA=
=Smde
-----END PGP SIGNATURE-----

--=-U+NHCnYo+NQwgQ1cc7rY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
