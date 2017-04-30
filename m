From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: Change flush logic so it adheres to the
 variable name
Date: Sun, 30 Apr 2017 14:34:49 +0300
Message-ID: <20170430113449.GP14088@mtr-leonro.local>
References: <20170428110654.13176-1-Haakon.Bugge@oracle.com>
 <20170428110654.13176-2-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lHWX6A2F7795X8SZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170428110654.13176-2-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hakon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--lHWX6A2F7795X8SZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 28, 2017 at 01:06:53PM +0200, Hakon Bugge wrote:
> Change and simplify the code to match the variable name. This is a
> non-functional change which improves readability.
>
> Signed-off-by: H=E5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Suggested-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/cm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>

Except the word, "non-functional change", instead of "no functional change",
everything looks good.

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--lHWX6A2F7795X8SZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkFy9kACgkQ5GN7iDZy
WKetGhAAstHPBHTOhY/URDddJ3eSde4ZVtxNbhvMAW381/M0RfFmINWL3h4cs4L8
hL0Rxltu/Lkfh/x/8XgKoY76CEx9yWEl1NQZIPLT2tY108RZH6abLI2VaszLAvHx
9FPU0jn+crFimqGH3AtYxBDdc1AQFnf5ZGv1yKXGVr97KiSj7EJWyFSh9hUEUywX
4WXmZGJ4FUgN96H7ceQ3R10pKdq3cyjMQC4U9xqVQu5SAj5OXSgj8tAgyw/kJPtv
sypalHi/P5PZQLx1EeBaO0bXq+jbRtXv8wJLFoXqC4GTg3OW9N9trvxHzrKhqgdG
Ucj3c6gqthMpkoebF2cu+zW0hh3kxmYhOZCzOzn5kW8pRdZKcdXQP1gU/WsdGfha
NUKGZOu3GEisrll5Opy7BQ1rhSSu3SRCvxjh4+m03osuarMSEFpIHP/pkhPfW+Yw
NrwXLeHBlTNEo5nR/1U4O5z8bYTt4+qPNM6cf0b5B8q/SDRIXX16q/b6LUt3xN7y
aBmxx94RxxD5Xk1WkkF230KnJh/GbJcl+Q59mDyEIKw53S/IIFNDKDgHzCyzZ7IS
od97B9n9ZeL9QXb2X41Yex3xrbI/BBrRf+0wiewmvzVYpmJH2x+C43XTifkGAg6+
emSKhMDMyC0UPbutV2MYoqcWZ1jyyv8X1zCA85j99G5v/wV2LAY=
=t6ix
-----END PGP SIGNATURE-----

--lHWX6A2F7795X8SZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
