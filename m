From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 0/4] Add network namespace support in the RDMA-CM
Date: Wed, 21 Oct 2015 23:37:05 -0400
Message-ID: <562859E1.4020807@redhat.com>
References: <1440685772-14076-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0hISj8AmG7UIVglREvegeR3RTmJmw90Uv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440685772-14076-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0hISj8AmG7UIVglREvegeR3RTmJmw90Uv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/27/2015 10:29 AM, Haggai Eran wrote:
> Hi,
>=20
> Now that the code for demuxing requests is inside rdma_cm, here are the=
 patches
> to add InfiniBand network namespace again.
>=20
> Changes from v5:
> - removed patches that got in as part of the cleanup series.

Hi Haggai,

This series no longer applies cleanly after all of the cm changes that
made it into 4.3.  Can you please rebase and resend?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--0hISj8AmG7UIVglREvegeR3RTmJmw90Uv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWKFnhAAoJELgmozMOVy/docwP/R3OKkp7lZfNbb9u6BZCupQF
F8ccU6VK6AlkFF02eeusfJF0kYWFGCgQc8Pn8DgoSCllxjiNnKRHERWG1fF+L9Fv
BI5v0FSuYtyK9UKAlKSIyuIAKWfUxXmM9YCGnUd5NdW49P+73aQDa2H3noup3rjK
W3fbRaJM1ADSpeU/dBCstAZti30TxcvXjR6klfbERXBFsMFspqAZ0hv1czu7kZif
Sbs+ordzNLDMjTGBAJRKKLskorlOWB+rvTAdDKfvvcRktIuM99W9YsSKdSHPSAmf
2qkVNgfkuR99JSDMEVqhAzsb3GsOjeLb0OuDLZ9oJHlq8ScTOr2axqYBSx7CX88P
Qy145vjkDQlDPT/HnLigGf5BUwHyUZsxvwCEB3yPcSjfG9bqlSjOx5GmioqjSrVx
Emcskikg2NZcyZfVC6g8Lb6RaZSNwqZWk9ItLtJ35oCJ5Dy4V2++bqyzopBpqNaz
YNfLEkL37YGynNkmMDYwI9pPWgnxJs+4sti3h1Qw787bjsFzjLCss2o91pXFZLxE
A2kwvvafPGzfF2ZFxnXsW+hfqGEWUdmoh0LPRVRmoZL+AQDW29Anl7Tlz9P01BPE
25OFugevnc0uxDe0+TkYMfD/g4LS2hFIZvs0JqoPAtbLy2KM14/fvZVLYmIWN8io
d3FZhrQVCoFCkNE7JIi3
=weZB
-----END PGP SIGNATURE-----

--0hISj8AmG7UIVglREvegeR3RTmJmw90Uv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
