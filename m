From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/ipath: Do not build ipath driver without infiniband
 subsystem
Date: Fri, 14 Aug 2015 16:56:45 -0400
Message-ID: <55CE560D.8070206@redhat.com>
References: <1438705021-20337-1-git-send-email-dennis.dalessandro@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="j9nDkmgnMdLIQtTjDglKmK3OSTK9iW4e5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438705021-20337-1-git-send-email-dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j9nDkmgnMdLIQtTjDglKmK3OSTK9iW4e5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/04/2015 12:17 PM, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Moving the ipath driver to staging now requires a guard on the INFINIBA=
ND
> subsytem in order to prevent the driver from being built without infini=
band
> enabled. This will lead to a broken build.
>=20
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Picked up, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--j9nDkmgnMdLIQtTjDglKmK3OSTK9iW4e5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzlYNAAoJELgmozMOVy/dqbkP/3Wnn2YN+p9rndXd+nqyFyFP
TLHAn0rqWqk13dTGqItyatEnBRjXbhAaHBU2zNza3Z53qVwsB2xZsfXxpwRJWMRC
JT3XNwyga0SOjL7YXPptS7NweYZx9KoJDPdSG3/w7X3qbJOVxLRaJk76eX+hynqh
YWclsFK7ejQdGrfhYbEnZWUAtvzLlH4g0VHOo+uBHrqEYFf9u7c8fjO6u5z8pT/O
R8xXjebs6/4HwLBSGMMBd8SaFvGMdlzL8RrNkYgkEj3Dj0LK0ExMkGDxqObkcr2d
4fD7zfTWwDyx4c/ymm9ZNcFkm80/rNMY0c7wkr7bF2iiC2M2s8MIIj9nIYjs/DeV
ZLHLnWVabHxCUzJyVvZFEkAUrxHnM2oeTJKM2Un/YV2UQ8Adf4OX2DbkePdau8wx
NdAl6JxjCTMUxwXmoejVRgctsNbYi8JUdnuVSO8aDIrja1ZZUBYoFIx6OSsQ1fMR
XrkxifFwWi/4C0wRhp6BGhNJcc7zNem7POB49vVxTve2j/xY9NOppoS7+AYUqyxU
mzRSOxGtUuy1r9uMtwjFXQ4/AM413h7mupumt0DsceFkVPVYrk+509/WhCCIAkDc
0N2lEPavqvfv6ooOV6PDL5nKzjUDsr5YYpfVm3mtheQdCDEtzB51OExgGxCcdbLJ
f5q3fm6OG17PsE/oNu4j
=QWyb
-----END PGP SIGNATURE-----

--j9nDkmgnMdLIQtTjDglKmK3OSTK9iW4e5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
