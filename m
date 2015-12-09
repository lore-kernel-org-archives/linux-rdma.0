From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 16:35:02 -0500
Message-ID: <56689E86.9080807@redhat.com>
References: <56683080.1090801@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185810D9@CRSMSX101.amr.corp.intel.com>
 <5668354B.4090903@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB18581111@CRSMSX101.amr.corp.intel.com>
 <56683C6C.7070106@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185811ED@CRSMSX101.amr.corp.intel.com>
 <5668458A.7020809@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AAFE7F21@ORSMSX109.amr.corp.intel.com>
 <56685B98.5080803@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AAFE7FB6@ORSMSX109.amr.corp.intel.com>
 <20151209182212.GF31636@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rIf7IaVi7o2xC1uWrnRpl4lApfkqFj8cn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151209182212.GF31636-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rIf7IaVi7o2xC1uWrnRpl4lApfkqFj8cn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 01:22 PM, Jason Gunthorpe wrote:
> On Wed, Dec 09, 2015 at 05:13:49PM +0000, Hefty, Sean wrote:
> =20
>> Example: Compute nodes are assigned pkeys 0x8000 and 0x7fff.  A node
>> running the job scheduler has pkeys 0xffff and 0x8000 (maybe it's
>> also the backup SA).  Ibacm would need to select pkey 0x8000 for
>> communication.
>=20
> I've also seen the reverse, eg 0xFFFF is used for default ipoib
> communication and 0x8001 is assigned to only some nodes as a child
> vlan.

That's what I use internally in our test lab.

> Choosing 0x8001 in that case won't work either.

Nope.  The suggestion here would break our setup.  Well, *would* being
the operative word where what I mean is would if we used ibacm.  But
that's a story for another email...

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rIf7IaVi7o2xC1uWrnRpl4lApfkqFj8cn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWaJ6GAAoJELgmozMOVy/d/NUP+wXktwDOQua72f1/SJcZWCT0
8VW4xk+mlIqiZzOd2r0iJ3JuzFj/LGC7XL2RIoa6wVOrmRM/MW8dHQL8KKFxBqWr
Mi6Cio2sheUUJDp3QKb7VY3k0IyMP0TvrAL4rlFh8K1Ow6UHtx7CTVWwluq2kUBU
NBCFGutF9vq1iR7DIcyiu10LCwE+fv+LyxW4hNXcc0CsjxVuT2iLT6n++cwo5KGc
Dlb90/YakC/5lvgD0QMNZnrGIlpP/fBfGyLNVaSBjpigXMumaPUJj4YMi41vM0mn
HEEFUhpmCmMy6LE+VT+vtfVO1duuGfbvolb0nhM0Mqz4dh4EnXxgEyD35N1yKQ5K
JHSNTlE1/WfV4nIEGdtjPtupZ+J2/u09Z1UuN0KHcQ/b9ie5cCPZ7dRsig2KAYom
YFo0kRlHkcwW5iThDlLr8zc/9bqRjfZC3qWcUcvYrW3Ce6s0BkJnw1SBzOlnfQEn
z7uJTHSRVzzAvYcFjDGhKaiQr/ABxYAmImpbUufff2rO5Qc+QgNiH4q5u2bPLaW5
HjT7jmpp2mTABjluhItX7kqt0pod/fNXwmDheSF2cdDSkOf8tY/nR3TAAi2eENq5
wwn+ZH31XZpHs+6xv5ft40Y2hWX+mpwXYtg/J6CT3hOiqnHMEHsdHAlV0Nc1D84y
6qkmJxHGImKdtJKDJO3q
=m5rH
-----END PGP SIGNATURE-----

--rIf7IaVi7o2xC1uWrnRpl4lApfkqFj8cn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
