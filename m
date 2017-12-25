From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 rdma-core] srp_daemon: Remove duplicate sync_res
 shutdown
Date: Mon, 25 Dec 2017 12:31:17 +0200
Message-ID: <20171225103117.GE2942@mtr-leonro.local>
References: <20171219215102.GA28841@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CgyvWwj/llZsteoZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219215102.GA28841-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--CgyvWwj/llZsteoZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 19, 2017 at 02:51:02PM -0700, Jason Gunthorpe wrote:
> The very first thing free_res does is the same lock/signal/unlock
> sequence, so there is no reason to open code it before calling
> free_res.
>
> res->sync_res always exists at this point so remove the assert too.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  srp_daemon/srp_daemon.c | 6 ------
>  1 file changed, 6 deletions(-)
>

Thanks, applied

--CgyvWwj/llZsteoZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpA03QACgkQ5GN7iDZy
WKeJqBAAv9BlC8S5edTKjryGhjkJkZjv06hUfTAd7kySKtxH99NFLpGlnbMcrmK7
RSpGdNm1RdClVlSW0XFlptSAtNzDfY0G6nqioN/sc2z7lwH6YbT/uhCfBzXCaZwl
QpujKnOt370bxX0xZum0dWonGvhjxYPD4LrVHzsPuSXBFVtmZu+C8yaoXmkP37nu
UhFOX5khLo4MuLq4xxFfqdDXkZ63S14KZMG+g64DWUABQg8/M1ka82MtfwDEd4TB
U5vMTBaDyPsWK8/QdFu/usoPfZ8uHuR3QWm9pXWRTpnijBbZSQa97hNRz4CBHHs3
q2IUl81jHVeJWR8FWN4PgdN46qIdj5Vlie3o7l8zQzcIkZAnAaGF3hV/O8W5SA8C
BOEHCsZcM9O8J5BtAwtc9VCkzIlw64hvsuqdWLa9ZhfYcCC2wYOOBclGQAqx/eR3
cazOnzcVp47g+YNySW6tP2mmkrKtVEe6z1jCb8mIWEt6fJA56q3x2KGWGIBigouA
8FofB6APfrlx1Rl3vUSCb1C32JP4h+9e6eX4txoLFzD3Phm6Z5YlyPNstvC0jUW1
KZ9DDUqyJwzEUkraX+PH5ikruvXasIJ4meIaRIMe1xuhyZ8Z8swuGE0xQvZJiJuk
7DasajkNlcx107ay6evnJDZySIWAH/Zk31z9kUBYKhkc6gPbP1I=
=OLjd
-----END PGP SIGNATURE-----

--CgyvWwj/llZsteoZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
