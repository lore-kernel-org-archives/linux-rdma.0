From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] verbs: Use correct type for printf from struct rlimit
Date: Wed, 31 Jan 2018 07:58:40 +0200
Message-ID: <20180131055840.GP2055@mtr-leonro.local>
References: <20180130224904.GA11309@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rfwNdt5cNUUjB/69"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180130224904.GA11309-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rfwNdt5cNUUjB/69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 30, 2018 at 03:49:04PM -0700, Jason Gunthorpe wrote:
> The actual type of the members is rlim_t which only happens to be
> unsigned long on the platforms we have tested so far. x32 uses something
> else.
>
> Casting to unsigned long long for printing is the safe solution.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibverbs/init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Thanks, applied.

--rfwNdt5cNUUjB/69
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxWxAACgkQ5GN7iDZy
WKfVKQ/9GRhnW1GP4Mv7W8MLYqCWTBpGVtHAITYgS7Vayezx1T7XH7RpqNvwGr2k
8Kdd6OYrqFciiU2Q9nzcfs+bZR67/44iqUjuxZgFtgid6Z9e/cW5eJKyTVVIp3z2
WBDuDN7Eo3SdTbM8rnOA3ETRJ/Ju7eiu2tV7cj5uRyC7eKMGRq7UYK9EKteiRRnZ
OuKV30COjVgWeYkt19tAbOs67XE0hV6r3sfPeHUDi+1Hesa9SvHqitiCoS6uxpoI
XPvjcgqzw4nAWLRk+gFprW+Pqx20ABqoJPm+JJKoUADe0Y+KZxzcjoXQyLCPSqkQ
Fir2wxdqHyuFqEEN1M32WgTwcmNlRh9EUGvMfarBD+LIi1YW/I2Q98EB2S8ylRLN
3WYy7RleFrcsozI82IRc9yaUvUCsfnmkUzs+NNxGM1NI4G41G7iB7lXxJ1XbJHJR
/8gfjdrXvL9O8xyS0axL4Wt/mDGw+FLrbv1DnBjnnAwY4t4Ul6LC4oKvRCPMd/mw
RpUNcHHyDZzplauiId6ei6+3t9sXSqzGw7SX4PlDuk2Pmoi//PwcH0zMLnAxZ+gl
mucbUL63jPX0b+vm7sonj1oZ0vV+evc55RWBNGQcQ1D1cN2bRW1dgm8ztZrZoJrk
7KUkK2dABKChxg7GMOSJ8H/JixqN52TguySQ4zo69cpqukgpBsM=
=Sh7H
-----END PGP SIGNATURE-----

--rfwNdt5cNUUjB/69--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
