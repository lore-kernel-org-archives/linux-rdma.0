From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] rdma/core: Don't dereference device->get_link_layer
 directly
Date: Wed, 20 Sep 2017 16:47:23 +0300
Message-ID: <20170920134723.GO5788@mtr-leonro.local>
References: <1505908483-29641-1-git-send-email-sagi@grimberg.me>
 <F3529576D8E232409F431C309E29399336CD902F@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rpGc+ACYPE+RMC+Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F3529576D8E232409F431C309E29399336CD902F-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--rpGc+ACYPE+RMC+Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 20, 2017 at 12:33:39PM +0000, Estrin, Alex wrote:
> Patch for this issue was already posted about 3 weeks ago.
> https://patchwork.kernel.org/patch/9932505/

Yeah, exactly.
I had a dejavu while I read the "crash IPoIB" report.

I assume that it didn't make to Linus, because it was posted after Doug
went to vacation.

Thanks

--rpGc+ACYPE+RMC+Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnCcWsACgkQ5GN7iDZy
WKeyGA//UsFGt3G/MVdsmdBj8eya4zrVT0oNWijaYztb6ZSdoXhbT7+O3TUHocqb
6A+KzbXPNX+m0T5+nGlHZh4EjoLQJN4mVJVPJaU1s37Q0yQQYtXimJUPJn4mNnyL
cM0af2QZyMRADiIM/nmwB0O7xZnZi+sOxtGewH9WWSPwOd1rDPbuXzxm7f3qAH6P
0bp7fOy1Nf1bWvzfD1BYiumYdXYrUSoN29EgEVcGndRjlw252sFmcTyuG588aZO8
KSe///51zC4YwYn31lUJRHFXmwc2ronfbzrS0C/sIb+gnHMxcX/7nJi+GAppS/Lp
wSBEbT4yTYBTMRXYDxaxPNDD0Dtw9fziCDHrg0llfjG+ABtyx+OgaUpTGbwx9tMb
N5YuZ1sBKXfHKX1PJUmQ5I15H+lR/Ky1jK2fPFT8ttElxJ9kWYggFOV2MK6QQo84
UtdT0FXxSw6RlLvucCLa1NDShfLhmjDQngi4KAlJa/65Y7vygTMXAM2rjZuajNSf
5ykH3H00zri8p2q5KEdFYFe2pbjjQvBCgcWbHG0OmIksdBJqqDfLH/OBy7Bsm0pK
ysQSR7aZZ0+6Ob9igs4TXRaeLn6W9I5ns6YeSWJHYyInk4HATrMLo8tXkh3jbjG9
PNmuDi/UbK+VFZA86fQVKz3j0T27BnmbGOR0/pD2p1bpIzQYmC8=
=Sl2o
-----END PGP SIGNATURE-----

--rpGc+ACYPE+RMC+Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
