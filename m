From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Fwd: Re: [PATCH 04/10] IB/hfi1: Remove snoop/diag interface
Date: Wed, 25 May 2016 16:32:55 -0400
Message-ID: <d73fa33f-16a4-f401-e103-771f2f173532@redhat.com>
References: <5a69c05b-bb26-6e79-bb7b-4b3809a277dd@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pljM9oCVDT9sVulTeVX8FAv52I3DhU9Nb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5a69c05b-bb26-6e79-bb7b-4b3809a277dd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pljM9oCVDT9sVulTeVX8FAv52I3DhU9Nb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable




-------- Forwarded Message --------
Subject: Re: [PATCH 04/10] IB/hfi1: Remove snoop/diag interface
Date: Wed, 25 May 2016 16:07:38 -0400
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Organization: Red Hat, Inc.
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org jgunthorpe"@obsidianresearch.com Mike
Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuE@public.gmane.org=
m>

On 05/19/2016 08:26 AM, Dennis Dalessandro wrote:
> The snoop/diag interface is better served by an implementation which is=

> more general and usable by other drivers perhaps. Go ahead and remove
> the code now and get rid of the char dev. We can put the feature back
> when we have a more agreeable solution.
>=20
> Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Dennis,

This series failed on this patch.  I was going to take the series in and
fixup patch 6/10 to move the ioctl numbers up to the upper end of the
0x1b range so that we won't have to worry about number collision with
the soon-to-come IB ioctl(s).  But, since this patch failed, I'll let
you fix both of those issue up.  Please make your changes relative to my
hfi1-3 branch on github:

git://github.com/dledford/linux hfi1-3


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD




--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--pljM9oCVDT9sVulTeVX8FAv52I3DhU9Nb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRgv3AAoJELgmozMOVy/d7qwQAJFLY2U1hS0PawwizEu2IJEG
j6SQ42r5y9eqlvVQ+Efa9PI+wemS3+Jj/KeXwEO8l7lYCXagi314dLfccOaY6fFQ
tisOxSf2rEex0TkVdjgIit2qSMWlSn+fB78X0U2w0tqtnJq9Emce3k1rch/8wtXg
W1SoEVVPGefDbOMU2oA69Y4e7I0PDuCtfYgC3u6HjPMYR/oeoI/Q9YnIFlNTS4JI
AyfTSRN2066NDCNrMpDU3M9B1MKWuOk2ITdH4ROS54uBznr1ZVKaL5XEbqquoUb+
S37fu2h2dUDz5uRzd1QRaE4oVVJlYFSki4NQyilTKxzrnGITuAWeW0ecHZg2h5oK
760/XK6Mf2S4dX8pufwhCrVWmljOszTPFJOENKavRXa+aF5qhQXVfs/ZNKybBQ9q
hnJfMrEvWZz1CmCP/ROd7PNUkZ6ifNzAnEto42GxgqCVuTdqJKFR/wX09mzZ/p6Z
5R9HABmPXnFmXpaIK+S3snVHF49td5F0yJDAsBGrVdIyFGOiAXf/Skogdx1gy740
QUuq5K9AsEUwmBUQ/K1K77E8FCpCT917elQ0u48GwdtOrFBi758ERjnG6X230RvR
dhVi94zAwTZM8R78DCeCJjeCWOlEqKIUNAT+lPNY5gyOI2ln0kdEX6naYnxDwhZG
ZsunrMKTJ0nOmaqp7uK0
=pw1F
-----END PGP SIGNATURE-----

--pljM9oCVDT9sVulTeVX8FAv52I3DhU9Nb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
