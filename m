From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/mthca: Less function calls in mthca_reset() after
 error detection
Date: Mon, 25 Jul 2016 16:20:34 +0300
Message-ID: <20160725132034.GC20674@leon.nu>
References: <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546CE09B.9090101@users.sourceforge.net>
 <55b7a06e-6bb4-f1bb-e4dd-7812648ecf34@users.sourceforge.net>
 <060a2178-afb2-28a3-9568-25c124972062@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gIORF5nGxIt+AP0s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <060a2178-afb2-28a3-9568-25c124972062-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gIORF5nGxIt+AP0s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 23, 2016 at 12:59:15PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Sat, 23 Jul 2016 11:28:30 +0200
>=20
> The kfree() function was called in a few cases by the mthca_reset()
> function during error handling even if the passed variables "bridge_heade=
r"
> and "hca_header" contained a null pointer.
>=20
> Adjust jump targets according to the Linux coding style convention.
>=20
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--gIORF5nGxIt+AP0s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXlhIiAAoJEORje4g2clinBPgQAKFWkrZtyLZ3gPB4pifyu7jL
UMLSGT9jDJRkl6hS+MHzxS18qxOIn79DWl3+JKBOIm2pGKk9tiVyhZ3PD9Mw+G1g
bQFqL0nXbLaBOxEh8iKm+MFWvldHvpeoXDIBMbDMMrGFiaG20joHOZNyYALnYmzy
GZi2no5PwouJn0OZwE6jREFrgQUmOfqKpAA8suV2LwR6CjQUNeU+Ss+zHVhCjlDT
I46ZGMco8ZDr9vS6zlq/d1vvZqZKfG5eY3M8FMqsji5AKCDgx3v4Zh/BHbnYhwic
l29T+XOgdDJtYr+S7VzK4LplyoL/sNNVR5x4V8GqIJgscSQnEL5ARDqnV0Qmr/kb
n4FkaqUcnJW4PT70PlL/l+FEU7tsNTamRqEjTn9Dcp/N6zXGmjs+Sm+AN+ln7ycb
wTvi6k+59dK4nhQpjK5EFetl3VitLeXQxrcD+hEvBBDapwgyH60T6iR1eAzenv5G
2dqVjqE4JfBZx2aROBpT3qw/3f5U8ihC3VoJT/A4Zy4o5azwaqmarDK++wa5IEDx
IxHb5S/9LUVmpcYNbXJNwmwkG+kGQXNe29EniX34WNU0DrKFnGDGwLJIsXSx4Sx/
T4eWcAyu8TMTM57yeHgU5P3dOpbdEcaoV5wo2YakqSqiJ9D/sSvEmP3JYQrv0rpv
mLuT+nuTeMfXhKmm0eQf
=BOmy
-----END PGP SIGNATURE-----

--gIORF5nGxIt+AP0s--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
