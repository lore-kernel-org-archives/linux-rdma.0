From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: perftest proprietary files
Date: Sun, 23 Jul 2017 08:27:29 +0300
Message-ID: <20170723052729.GC3259@mtr-leonro.local>
References: <2411a5c0-84f8-124e-83ce-1ee587dcf4ce@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="K5roPakIqCb4O6y8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2411a5c0-84f8-124e-83ce-1ee587dcf4ce-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--K5roPakIqCb4O6y8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 21, 2017 at 10:29:11AM +0200, Nicolas Morey-Chaisemartin wrote:
> Hi,
>
> While packaging perftest for SUSE, I discovered that some files have headers
>  declaring the software as Mellanox proprietary while the COPYING declares LGPL/BSD.
>
> The files are:
> * Makefile.am
> * Makefile.in
> * configure.ac
>
> Should these headers be dropped ?
>
> (I pinged zoharb about this already without much luck. Figured it might be worth a shot here)

Thank you for letting us know.
Let's take it offline.

>
> Nicolas
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--K5roPakIqCb4O6y8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll0M8AACgkQ5GN7iDZy
WKfSUw/+K/SbLOT30GNPeclE5dEF5bfFwYzqojbPQolYDnhtRIMchzXmbl77nyPp
uY/6r/p1HKrZqNgVXTDteTjruqOqi5L57L2qmRjCAlN5azx0KIPw9yYfaVrpMx0c
6RV33zqnxEvS8HCOVog1343/7jNyU9R4bMT0KEZJ8biZeFrRaGAdQF5i9EnMCsNn
WRSmeGzDHe9/JV5RqM1NGggoOpc+fZV5JQlW0gJRkDRgXmTo8vgEz0NwGqdAFXYS
QFT6HCplTFcRP7MQNe/qjO2ydu7K/cMP6p8PHKbbpGzwQfpumbrSi7dCUX9DoUrb
UZla6+CHpXqcH1cG4lg0orJIH7dbs+aVdp4dPeNq92kNIpvg2wJZEi4y9TPLw4qf
ILGwEPsyMG37iJNDDcONqwHqjthMOgHhWtnlgqZ4cttwbZjW0YNlwdsTYQ4Uznao
bfiiCkqidgsAqqK48QOQtLllhURpiGh50k143m4+9uNkaqe7fxgjmYg7x9J52b8L
tEBm5LcLS0Cz74OqgDgSKnmdGUio0iWEGryX21di0zNsovfv2Vaog1LVJwNvRLwP
YPJvtBZl9XhPKylozxga+5r6SXavj2ez4hYy4buzKGSuREUvH7pOvhHSm5lOH2eg
Kmz/hZdB+ErNnBeZ01eSP3RpDaudOC8+ulF68HP3HcO0HYZDnF8=
=cE3r
-----END PGP SIGNATURE-----

--K5roPakIqCb4O6y8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
