From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH][v3.19.y-ckt] IB/ipoib: change init sequence ordering
Date: Wed, 01 Jul 2015 13:42:28 -0400
Message-ID: <55942684.1000502@redhat.com>
References: <55942302.10602@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4xIx3wEFaOi7qnvfD4WGpielJVQsQ3XPH"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55942302.10602@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>, Kamal Mostafa <kamal.mostafa@canonical.com>
Cc: sean.hefty@intel.com, hal.rosenstock@gmail.com, roland@purestorage.com, ogerlitz@mellanox.com, erezsh@mellanox.com, alex.estrin@intel.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, kamalh@mellanox.com
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4xIx3wEFaOi7qnvfD4WGpielJVQsQ3XPH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/01/2015 01:27 PM, Joseph Salisbury wrote:
> Hello,
>=20
> Please consider including upstream commits
> be7aa663fc1d9156798f5af3c60e6df45e1fe5de and
> e135106fac9525352feb8e49077c8f46c3eaf288 in the next v3.19.y-ckt
> release.  They were included mainline as of v4.1-rc1.  These commits
> have been tested and confirmed to resolve
> http://bugs.launchpad.net/bugs/1467912 .
>=20
>=20
> commit be7aa663fc1d9156798f5af3c60e6df45e1fe5de
> Author: Doug Ledford <dledford@redhat.com>
> Date:   Sat Feb 21 19:27:00 2015 -0500
>=20
>     IB/ipoib: change init sequence ordering
>=20
> commit e135106fac9525352feb8e49077c8f46c3eaf288
> Author: Doug Ledford <dledford@redhat.com>
> Date:   Sat Feb 21 19:26:59 2015 -0500
>=20
>     IB/ipoib: factor out ah flushing
>=20
> The bug reporter states this bug is only happening with the 3.19 kernel=
,
> these commits may not be needed in other stable kernels.

I have no objection to these two patches going into a 3.19 stable
kernel.  They are both stand alone, safe patches.

However, there is no difference in the IPoIB code between 3.18 and 3.19,
and I didn't think this bug existed in 3.19 (my commit logs called the
work preparatory for upcoming patches).  If your testing does in fact
show that this is only a 3.19 bug, and 3.18 tests clear, then that means
the bug was introduced by some other change in the core kernel (probably
in how work queues are scheduled and we likely had a situation where our
code worked based upon how they used to be scheduled, but with the
change we now need explicit flushes).

In any case, ack from me for these two patches.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--4xIx3wEFaOi7qnvfD4WGpielJVQsQ3XPH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVlCaEAAoJELgmozMOVy/d99sP/j1Go6ZTQ6MKSljgoAHww1xy
PQu7z9OAjOJk8q7l+UltLOHhsft3noZ3QLiboGx5f5yq2Y9oWBzhc0EfutcpHCD8
Ko0fvPC2pczm1squ5vT+AFtZwVtzjs1lxKQ5HyGdlu6anzjmdQ2619YdRwlWT/Mw
wQ4btdFLiR2w69CwJTjPWip665FaLtWwaUzJLKAUaIbjZQIg+pGQYXQqXEr1CTBb
U2mZyg15YjsdP2VDePtWCEuyBlk+rIDaRUP8fwL6SJcDxay/lXfkxIx3tAXY2TIa
d8S+pyRiZL5J/VeJaTFV3CvOo+uOhkVcNe2L/poDGEtrBBP7HegEVM3QhtiVNfvy
4U818GDNVAblomFiupZ/Cijuj5C7zQSkWBDP1pB9EaUeTt6ydgn3bPk3d28jveNa
Czrg3qZnNzH5HvcneYj0yLdTA7ts21eefWJMujen3EvVmAR76vL3lb18/BZrmPSV
0wYb6v1hd9PFAtQw5GTRt26+sswFDLDK7SA31/4XfJi/+piS5gG3p1X/NPMNOZJ8
VOC6BSnHqL9BQZwrEgZk0BYX5dM89yB58+Zuy7hRIs6KR+tjP6WQCZCe35sVbt/P
9dRa7A6Hlt4xq14F4YXJ8oTaKazE2rvuYBWLUS3/UlRt/r9texbE/oI23Ciwd9uO
vTCVEcn697W17exrUsUY
=pLt/
-----END PGP SIGNATURE-----

--4xIx3wEFaOi7qnvfD4WGpielJVQsQ3XPH--
