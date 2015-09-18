From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] IB/hfi: Properly set permissions for user device files
Date: Fri, 18 Sep 2015 11:54:00 -0400
Message-ID: <55FC3398.2040207@redhat.com>
References: <1442512069-29793-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ae58nNh4s6wiSjN3A89LAsFhgR2roQAkM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442512069-29793-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Haralanov-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org, "mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <Mitko-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ae58nNh4s6wiSjN3A89LAsFhgR2roQAkM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/17/2015 01:47 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Some of the device files are required to be user accessible for PSM whi=
le
> most should remain accessible only by root.
>=20
> Add a parameter to hfi1_cdev_init which controls if the user should hav=
e access
> to this device which places it in a different class with the appropriat=
e
> devnode callback.
>=20
> In addition set the devnode call back for the existing class to be a bi=
t more
> explicit for those permissions.
>=20
> Finally remove the unnecessary null check before class_destroy
>=20
> Tested-by: Donald Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Haralanov, Mitko (mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> ---
>=20
> Changes from V1:
> 	Fixed typo in error message
> 	added missing goto on error
> 	Remove null checks for class
> 	set user_class to NULL on error

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Ae58nNh4s6wiSjN3A89LAsFhgR2roQAkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV/DOYAAoJELgmozMOVy/dOeUQAIPsdomye8iy9XstebBIOQ4j
QOZvYFZfNAA0BbxcncB0sNGQm3haDsz+L2vuhNOE5AZxfXikj1U4VPJ66EkTIwZ+
QbN7FWRJ4uXZPZC3W+Aj8wrgiIXATtuBVAtOaZRy3W45+6aysL9SIjFBFozgiWjy
C1d4FC50HRYbn2mRkHpi5VVmtHlsNkWFISCsMvkRe12LHZus2RwHx7tEPHbgXyGx
++9KhgDiEqmMAU6SpGSXY41QExQJm3y+hhOLH7IMpyWEsmoJ1P5XZ9LF9LUxebOf
RAEsfA/ZxgGLyljUIOAuM3n3Om5ImT4SuSN8VpZ2cu+QK12o9OZ+FfRBuP0I0vIb
X9FzNO9igIVzsZBUMt35FuVTdSwBHk4cBD/E+/NHY2FI1pA9uqw8jWntt9O6gGTa
nVpYx8FQam7aLu+9cCpzejeB56aKk3TVh+g4xLVeXZfBa5JhD8nJnaJ8gRjT069I
lCVrwBuqNOWu6Z0Xhsu2/DalLBeCJYiNwvdbJA8XpV6IXELhx0YNQFvG66ffGVAj
2bhwb1U27dLen+2ruXvxkdLZX6qjCpAfIWrhE3+u8+nn4FvTtqES/PGnQ59in18M
kdYKkFQIVd0YIR+DZGNmue3tM4+GE/hMlxpCvOUsDRTSBntaNNiiih5METTBhEwj
oCw7iqejEXKhao2AkGEs
=ekLm
-----END PGP SIGNATURE-----

--Ae58nNh4s6wiSjN3A89LAsFhgR2roQAkM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
