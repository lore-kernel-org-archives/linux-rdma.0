From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] pull request v2: linux-firmware: Add Intel OPA hfi1
 firmware
Date: Thu, 3 Sep 2015 08:37:11 -0400
Message-ID: <55E83EF7.5020906@redhat.com>
References: <20150824152844.GA3066@phlsvsds.ph.intel.com>
 <55E75DF3.4090202@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1CB7F73A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hRgd13LFk9AqcXKUo9Vwn9I7hGSt7PM3s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1CB7F73A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-firmware-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <linux-firmware-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Sowa, David" <david.sowa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Vogel, Steve" <steve.vogel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hRgd13LFk9AqcXKUo9Vwn9I7hGSt7PM3s
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/02/2015 06:15 PM, Weiny, Ira wrote:
>>
>> On 08/24/2015 11:28 AM, ira.weiny wrote:
>>> git://github.com/weiny2/linux-firmware.git  master-hfi1-firmware-v2
>>
>> Should this go through me or though the linux-firmware tree?
>=20
> I don't know.  My apologizes for being ignorant in this case.
>=20
> I was thinking that as the rdma kernel maintainer you would have access=
 to merge it into the Linux-firmware tree.  The README in the Linux-firmw=
are project only says to email linux-firmware-DgEjT+Ai2yi4UlQgPVntAg@public.gmane.org  I have not hea=
rd from anyone on that list.
>=20
> Does anyone on Linux-firmware have any objections to merging my branch?=


I had to pull your changes to figure out exactly what you were doing.
You could have been submitting the firmware to the kernel proper (there
is a firmware directory after all, but I think it's mainly intended for
firmware for which we have source and which can be rebuilt, but my
information on that may be out of date), but this is for the
linux-firmware tree.  I have no git access to that repo, so it's not
something I can commit.  I'm not sure who takes care of that.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--hRgd13LFk9AqcXKUo9Vwn9I7hGSt7PM3s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6D73AAoJELgmozMOVy/dD/YQAKS7TqppIsF3fC3d8rODB8l3
CG9SkuhTyYGIwWyrQ6kqSLOtzDruRu7ZBy6xRAjo4T2l5H1otNLcAYdtKeFqWhAA
dTF9Q1UW5Zwcz/Pm4hkD7290+Ar/XbVYWuG98B4INc+rPT4IQZ35fYALlqjp7S1/
OfQWlw9pTT4R470UIZXDH3nnFmHBz6IM5eOVm0v4jc1t244Wgd6DiXsp8Idchjdf
srDoiw2sMupQKsKf+ZIUpj0FTWZpz1Uaj+zWRR/5C70XmkA2F/BeKhpFb6ZS+pQd
F1/jIaZ4muMPWS/xqcpTh2bDl8nZZYPXGU0keDOPXuzbZFGYKAX9x8QXvUtKWtSO
doe8uKlzluVcenR+I4eGcd5Z3rWc+cIbRmKBmVL6E3JFRgLrfZiUPQlQmfxmIGlK
tdO69JcrQJzsz/EEVInA3JSlmk5++ilvHoEiHHvL8ExTNXsej6Op7ayJD7RQ0KMx
q587eizD7b8S7CCXJB5RSpUYvleKq7woic6ah5OnJsZJXhiC2m1KdBAq7faCSAKl
1I/z5jp+vH/q9CSJ88d+lARHOIEW84I0uQkgU+ycjH/IH//ZX3O/zd5P6maBFMar
W9CFMWDAnXQp7MTLIzGcggxC/95QBC/Rk4FDQVVjuG00hfhP3iOM3oqVcKUSkTEz
7tjKjS3H6mAKzQPAaJwR
=PJS8
-----END PGP SIGNATURE-----

--hRgd13LFk9AqcXKUo9Vwn9I7hGSt7PM3s--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
