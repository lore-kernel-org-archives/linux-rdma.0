From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/15] IB/rxe: Remove superfluous casts
Date: Thu, 5 Jan 2017 08:48:47 +0200
Message-ID: <20170105064847.GA12077@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353522.3592.22.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GFHULmA0mO3kKGOo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353522.3592.22.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GFHULmA0mO3kKGOo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 02, 2017 at 10:40:30AM +0000, Bart Van Assche wrote:
> Casting a pointer to 'void *' explicitly is not necessary in C code.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--GFHULmA0mO3kKGOo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlht7E8ACgkQ5GN7iDZy
WKfvvhAA0sD+ul16v2sZaPAtaZZg3uJR5N5ommzkPdXA/K+22TDVGjKabrJjC64l
V/mp8h45wrxyI2yWZD3b2nTxAvwgiz7nMU1ezLaZOi+L4yuYlIbVvg8Yy70+oW+B
Pw8GYiVMLgwOymKiLtsqZdXih9MlrvtnmPy/c6gFQBdYzS3pNVIcXpeBtusOURiK
WhiIexQzIqvorWQwqDz6NzGRHc0C5jPeR5yyE1ClPSca4jLHh/r/q1ADSVxmqRSJ
09mBrcISs4W362jLUtP/fvtKu/4XYvY9zB+gBMll4gMU5aCsn4SWZLpVPfMI0mlX
tmdfjsXO9z20O+kO3u32J/CoouCQ5umK53UXT/rH5UEXl0jO69YUELrbAgHPnal7
aRgIbAwNBWRWJCxLtLnxKwjCPqUI3zoLzEdn1abY13a82em+XuaeK+/78Qi81gL8
hLxgyPf7W2dMp3rYOexSX3xFvJ2kqw4iyiwvSR1YBv+mLjQj+4qhcQ7F578om0UY
ehWGffom3qnkRgVrwxSmB+6k3EUclHM06kHSPTWU7IkPSAHx4tlXv1YPXRJ2ao37
JQivPnIF2N1f5T7J4KCE9s3HvfFof+Ygm6En/ajldxBGTdg1LPIT1g8N3EyyjJyS
3t8hsMbEUkiWbqdG39TMVAjk2Tp07a6TqQY3VkkcfvfuaXkTMeg=
=5DDu
-----END PGP SIGNATURE-----

--GFHULmA0mO3kKGOo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
