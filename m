From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 0/2] Fix counters support in mlx4
Date: Wed, 17 Feb 2016 11:19:45 -0500
Message-ID: <56C49DA1.1070204@redhat.com>
References: <1455457871-17354-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MGAXdhKIvSIaEv084WLsQKc3KBk3qwHuD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455457871-17354-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MGAXdhKIvSIaEv084WLsQKc3KBk3qwHuD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/14/2016 08:51 AM, Matan Barak wrote:
> From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Hi Doug,
>=20
> This series fixes an issue introduced in 4.5 after applying Christoph L=
ameter's
> "IB 64 bit counter support" series.  Christoph used a mad in order to q=
uery the
> vendor driver for extended counters support, however this mad wasn't ha=
ndled in
> mlx4 when link layer is Ethernet.  Thus, counters in RoCE could be brok=
en.
>=20
> Thanks,
> Eran and Matan.
>=20
> Eran Ben Elisha (2):
>   IB/mlx4: Add support for extended counters over RoCE ports
>   IB/mlx4: Add support for the port info class for RoCE ports
>=20
>  drivers/infiniband/hw/mlx4/mad.c | 63 +++++++++++++++++++++++++++++++-=
--------
>  1 file changed, 50 insertions(+), 13 deletions(-)
>=20

I went ahead and picked these two up for 4.5-rc.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MGAXdhKIvSIaEv084WLsQKc3KBk3qwHuD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxJ2hAAoJELgmozMOVy/dJVsP/iyVqK/ieq4i9bEmav8boCoq
xv48/bem8S8fN6C44gmlDDk+EgmAlg715MnsTHGqL4N03ubgiJ/TEb0+o8czYJIn
zUNzxg3peUKfYtQdzNkBRSAcCjTx4Znf2tq3gzYAZVbpYHE7OSTkgT7wL3iAQzbi
aoxyw6gxKuVqTiFA5PvnpmHVucSRPdAne4atzpYlbj1aAMn5m4dYSTIyIEvX3P7O
Kv3yQfpO1TEh+FyrYlAUSoIWGOcNmS996EK4JIy5vXD60r5pWoXCKg6ZPYAS0/5n
xH4TgcGWIFnJxWvWMcmFMrXY4vtIRLAtQIgUIYZYYPcLr7Vn+XH0JyP2iXzQ+3SH
mr/kNuucururvouu22IwOXVtLrilF5mbt2WmltbOP8D7WHRjvhom3l3695WmgyVl
1dCJIz7ao8011s2awg5PUHJOMXP9Jto37iHbbIw3ZvSakBt8AiVj3DMKEDtXITSJ
mTQEN9ru+2qzILtOwEFMW1CC0Z/mNFqigErrS1iVBW5m0DLT5MFcmYoi4ZU0B1WK
kyeBZpapRFvBzcRClENz8znO5nAq9vh7GTkvRC0bogctZwAk7tD+hjIa9i/ldVOZ
ylmePfTS0i/fCKO9pSii2pdV0SRvQfa+IUKZd8C1f+VPDNZppzXMEj8ofOavixlx
H3t3/OKlXTjK9AyW2D5K
=x9tG
-----END PGP SIGNATURE-----

--MGAXdhKIvSIaEv084WLsQKc3KBk3qwHuD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
