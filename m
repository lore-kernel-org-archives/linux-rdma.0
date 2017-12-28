From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Remove the obsolete libibcm library
Date: Thu, 28 Dec 2017 07:30:29 +0200
Message-ID: <20171228053029.GO3494@mtr-leonro.local>
References: <20171225123132.6063-1-leon@kernel.org>
 <20171227201945.GG25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m0vRWufqUC70IDnR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171227201945.GG25436-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--m0vRWufqUC70IDnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 27, 2017 at 01:19:45PM -0700, Jason Gunthorpe wrote:
> On Mon, Dec 25, 2017 at 02:31:32PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The libibcm library was marked as obsolete long time ago,
> > the following patch is first step before removing ucm from
> > the kernel.
>
> I understand the distros will not want to loose libibcm in their
> stable releases.
>
> It might make more sense instead to just not build libibcm by default
> with a cmake option but still keep the sources..

We are not removing it from the stable branches, so if they want to keep it
till last person who used this library dies, they are free to do it.

The disabled build doesn't give much benefit at all. It will be dead code exactly
as now, but without any alert that it is broken. Most possible, it will be broken
till some distro will notice it.

Exactly as some distros have EOL, this libibcm library came to its EOL.

Thanks

>
> Jason

--m0vRWufqUC70IDnR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpEgXUACgkQ5GN7iDZy
WKeQfQ/9G7OREd1RotzBcV4u4bBcSxlJye+RJXE9haNKiMT5jsxyQ7PPcneHU+z/
B0Fp6FjJ3p4j7chyOTboQ2IjN+7m6XwyYCM0yJFwItrqybFHNNz2D1tfeRxdC0KR
hP7xeOU/YoEyI4XNTIms37+tQY2pVa2fPPDWIs0B+dGUB4z8qO0/6y4Awsmzc8NU
JF6STBcTCGNP3MI+Qq3N2toFHub8D8DzCgaGO/O61fu5WrMTgQFnzzsjXO4TNPiF
PzGA6v1nAz1JhHx3HzS64YW4rX4O0UQMcUTbxEHM3PMt8XW5ta8MOh7OqAe4bwcI
nnKx+R3U+dWfsvsTWpQib/oZXtW0mn7FINrMvnX+Xn3xqAhjn9DZfxqW3oRXNM23
Dt61QoeUJ0MvjqdXYkKWwnkTvtCmV86ISdIt3QyKNc5Nokq3WNz8aLTBN6s1rYxt
9WP44iv8Jbs606T1uhHTdRWCifxGMY0wLMNrpx4dteQj54rw4YFjKPlTT5IFwDcK
6Qydgo1t76ECRWF70v6Ha39D++uPs3G1jQTix61z1iv14fNWUuerI4JlBTZUQpeN
ZKoWz4iZtESDG5aKiG1qyl4KeAgjswg5ffLDEQrxW2tT8aWWQ494VyyQBFpy+6NX
kaPteFrOEFoKduF6wJWShB5u+vBaY2YGNmi2GPwXDHDaNbaoUUY=
=5QXd
-----END PGP SIGNATURE-----

--m0vRWufqUC70IDnR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
