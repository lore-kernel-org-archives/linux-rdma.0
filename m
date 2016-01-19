From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: fix mcast detach when qp not attached
Date: Tue, 19 Jan 2016 13:10:22 -0500
Message-ID: <569E7C0E.7070608@redhat.com>
References: <20160107214410.12728.82007.stgit@phlsvslse11.ph.intel.com>
 <32E1700B9017364D9B60AED9960492BC259E6FE0@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KVShfNmQBulro5S4oFSJBE6tNPGnQh5hA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC259E6FE0-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KVShfNmQBulro5S4oFSJBE6tNPGnQh5hA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/07/2016 04:48 PM, Marciniszyn, Mike wrote:
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Reported-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Doug,
>=20
> We are blending this into the rdmvat for hfi1, but I wanted the fix for=
 qib to precede qib's use of the common multicast code to allow stable ba=
ckport from the older code base.

Makes sense.  Applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--KVShfNmQBulro5S4oFSJBE6tNPGnQh5hA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnnwOAAoJELgmozMOVy/dg1UP/RjdOZ9wPhT+ZHRnDa1i+q3V
o63Rkh0FqVWDcUXmfxOZ6GjbE1FBn/1DIOxgoLJeRnBe4KxSkJlhVOYtyz7v4FOq
0qpERVZS3m9Vv4JeW450KOEHvIFoqL5pZ+T1LAZ+J5rCAMiePl/4EfueN9L8bl6g
hITXOASrdrmGFcsnVr5mIVoCggnoEhpq0XV7sxt3eU44vJUkdZKI2fDLoUlCyS2Y
zMY2qTwB7tXhTMmKRbnxJPrlovhPpP3aS8EBS9XnpoNRGlYfaWW7axu4RWWfPkO7
POufPr8MDj5sM+FcUw1IEcm3opTFSCLq7yz4UEu0AAyZtay7twTmqyeiaKvonb6h
AYgOFAOxqYGaUbmfWZmKQTRiNx1nCkitaOM/sfxISbcEpoKXHDuLt/AWFRqxofWl
QhbW998EjrNUKXUe9udac9PY7B4/WcHbW+Zk+HPwkOjIEBQAzOfjZ5XFacgdnqKX
Xuoj0SXbFRgr9JaWq/rGVeGZNhIIJ7mFTg1v7kmjVNo96+eJwQWMWh9Zhhp6VTq+
HGqGhbXH6wJyi7AlmUwK/8MK0tvOPyMZhL6WPvb7wpRrWJIGwau90j5NO6B2p93u
WEzK3vBKj43IGG/Lo0BMnyCuyx17QicgAJrBoBMPMUPpUoG3Ftdr1aBGpwevoOF1
0sw0ei7RRMMaukvHbbu1
=fFud
-----END PGP SIGNATURE-----

--KVShfNmQBulro5S4oFSJBE6tNPGnQh5hA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
