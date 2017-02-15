From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/10] Provide a compat infiniband/arch.h
Date: Wed, 15 Feb 2017 07:15:11 +0200
Message-ID: <20170215051511.GK6989@mtr-leonro.local>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CNK/L7dwKXQ4Ub8J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--CNK/L7dwKXQ4Ub8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2017 at 02:53:22PM -0700, Jason Gunthorpe wrote:
> Prior commits made arch.h into a private header, but there are several places
> out there that include it to get htonll. Provide a dummy compat header that
> will let such places continue to compile, but with warnings.
>
> To do this we need to move the internal tree to use util/udma_barrier.h for
> the barrier macros to free up the header file name and in the process replace
> more of the crazy mix of byteswapping macros with endian.h equivalents.
>
> To make sure that everything remains working travis also learns to
> compile-test all the header files.
>
> Jason Gunthorpe (10):
>   Have check-build confirm that every public header is standalone
>   Remove uses of htonll
>   Remove uses of ntohll
>   Do not use kernel byteswap macros
>   Remove extraneous byteswap.h include
>   mlx4: Remove include of asm/unistd.h
>   rdmacm: Remove dangling cpu_to_be64 definitions
>   umad: Replace htonll macros with proper inlines and mark deprecated
>   Move the now private infiniband/arch.h to util/udma_barrier.h
>   verbs: Add a compatibility arch.h
>

Thanks, applied.

--CNK/L7dwKXQ4Ub8J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlij498ACgkQ5GN7iDZy
WKfisQ/9EeYY62X9yMKOKHWSIv1eZVBNsHCjprep6qUU4waHLWsq0zipb6cFlDAt
cEzGtH+oN50gor1+NuvtSFuJXOZwID7aeHgG+QVcMuogrhqKXPmiKKLaESJPpDMn
YMJ6OemXjHYQh105OqBc0OFrZWSpqZY5XHWgxIiIeg4aRbyJ+k4wkuZFMpd4VOFH
5V0XD+zuSaA/+Zmtu23WecUzUMzO1GgmWKUhNyvt30vYt2CLZDKuNbfJv20tP0cA
IglWL7QqppMdAgQz4e1R3I4qPx163ruh7Z6cGDFjCGuiDIFem6BxkISnd3YMIUyT
n3TqjjkmoF29SiD4zdI+2rAyPQpOzwakHE0aJwUv2kef6OnwP2dDkQKmHGM9gUag
rR8wDMMV+ylVtyfLjYDiQYqfOH4oMntu1BBp4HMQsGsYkJhOgZlMlztxu1HDdiYz
9wzdXsELDgIPoaDVtnrKALKMv+YPWgSo6ppbUYdjoQxi3jq0QFmEImFzcw/agL++
rtvvB8QhD/DPIfbDA9HUNdacYypwCMqnpkqd2WWqURI6BkohH0arLDbMWXwGt1Y0
1cCjxoKo7uGQSJFlvE5GnK7e678fhUpUjjwGaXEJZF57vVW7SFWA4qFg6SCHCKwy
+UN3v7iA65djrCBU2L24QWuTd2lO2+Tz4ocl+deSKGNyp1zN2/k=
=R+fz
-----END PGP SIGNATURE-----

--CNK/L7dwKXQ4Ub8J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
