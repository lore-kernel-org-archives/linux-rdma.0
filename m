From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/47] IB/core: Fix endianness annotation in
 rdma_is_multicast_addr()
Date: Sun, 8 Oct 2017 16:50:06 +0300
Message-ID: <20171008135006.GE25829@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XVddTWRQMr0ODUnD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006213333.6721-2-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--XVddTWRQMr0ODUnD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 02:32:47PM -0700, Bart Van Assche wrote:
> Since ipv4_addr is a big endian 32-bit number, annotate it as such.
>
> Fixes: commit be1d325a3358 ("IB/core: Set RoCEv2 MGID according to spec")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> ---
>  include/rdma/ib_addr.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--XVddTWRQMr0ODUnD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaLQ0ACgkQ5GN7iDZy
WKeS3xAAxBvrYjlnfOoRbH49y43HABRip2CzJvsCyLWl185+BhVaTu4QxId6/hKm
OpMqEhpKgDWr47YuFNcQAUj6MV1weK7A5R/6OWYsDwDCO/xh2ISvNPMywfiS2FfZ
cZLkuHxODYq3V+Em8irddcSmn0GEA4EP26Lh9Sum/eQ8p8LVg8cfLGfg8F6PZhet
g+4uk/85o82rYjBrpHxTZvgLr7cf9dONwerYtSP+16kPtE5c+yIXGUt3jy7ewjFx
D3Opf8WnJaxwbARHD6knoOkgSoUVM4nZxUdsaCyUsHBOAjRy8xoJFT6psDWGBG1t
99Co7ViFhxc5kSCNkj655wU9Rfhbj00yj40gL1d6GR9WqEk0mZaEbjGsgJgWUSop
6DezDR4XVJb20MOo8wQsZwlZS9bmEqtqurEUskeFn7d+71UU1Z0+s9OHURzMlMRt
OxVv/Vk8PvrsfBF2/GosCzP3VFWW/k5loJn9VcUIiZRRGnk7ySs5rQ1ga9RTk9t8
uLzinjZpGdTkM40wvb63et5t+Qzz0DsA6K0A0Jl4do7uE1dJcUQ+dGgS9QLx3iIQ
H5Bou70JIX9+6s3mcHrI/ehRlKlR1VN1QYS+u1NUwMDuNFfJsy0AKNlQMvBJcMX7
jI2KHwRJ/54a1852pJUrHbNjhvSK3txiiWCTz1d8l50WuwbgDXk=
=Zje+
-----END PGP SIGNATURE-----

--XVddTWRQMr0ODUnD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
