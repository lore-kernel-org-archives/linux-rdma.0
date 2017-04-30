From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mlx4: Fix incorrect order of formal and actual
 parameters
Date: Sun, 30 Apr 2017 14:36:56 +0300
Message-ID: <20170430113656.GQ14088@mtr-leonro.local>
References: <20170428110654.13176-1-Haakon.Bugge@oracle.com>
 <20170428110654.13176-3-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Cjvo8w+V8lMs5Jsv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170428110654.13176-3-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hakon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Cjvo8w+V8lMs5Jsv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 28, 2017 at 01:06:54PM +0200, Hakon Bugge wrote:
> The last two actual parameters when calling id_map_find_by_sl_id()
> from id_map_get() are swapped. However, the same formal parameters to
> id_map_get() have them swapped as well, inverting the effect of the
> first error.
>
> Hence, this commit is a non-functional fix, improving readability.
>
> Signed-off-by: H=E5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---

"non-functional fix" =3D> "no functional change"

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--Cjvo8w+V8lMs5Jsv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkFzFgACgkQ5GN7iDZy
WKckmA//ZYOdmqaF5z3G8WSwGsfkDI1l+Aq70JP9tM3wbxRMrGym9LEAIX1KnRbq
xskSyP846AMTiceFICVcZNYjI5zAGtYphcNsmCg5OE/YII81iFoEGb1x1BqnlxZR
XxMdfi298HhgImRB3ECg9V3BThel0Jz8a6HRKezIZmQRmPGDzx7uefEzW/3n+1LT
An8gpObm5lpPohguKjppe8LuR7Ea7j+3Uwu8/1SIsIPAKmWEWGOAV3f37qfrUt8V
h1QdoOPHx24H12nV0/bO3/FpwQy3kiFcsIAW7TN8XWt/e+etf92Bwe1zmd0v7kwn
QXkCuUjQzueH81+WOQdpmNhDIGEPu4yGfp788OngNWEZ/p+bGydqodrMICOzhwaI
2Ab5oktuZoIa9OXV4eVNNquK/6Xq+wC/KNj+O8kOX9MnlDgqED5M49JBt8giuvQD
Oqpowsuon5WXSGy5iZ1mQ3HHRByA+PUyaOD3twALozTSGbEZvEgbi3SePAXt3cm+
IhpggmWxcQ2tsjlywUnIGzBRFOzBpNCVAw4qAcXxB648/RByOTOK4Gqt6yfWiCvV
oVZcVytwNid3mRbwMDPCYWP5yteOY3UsUr2EfekHYXZek6tmmxXdW0S9ThIDJoKI
Atd+YLmcxSNOcB3MZrwee+LpX4tZTGPY5uS6TvhOmmUk7Wj4fJo=
=CJ31
-----END PGP SIGNATURE-----

--Cjvo8w+V8lMs5Jsv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
