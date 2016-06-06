From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/core: fix null pointer dereference and memory leak in
 error handling
Date: Mon, 6 Jun 2016 19:21:17 -0400
Message-ID: <730297f0-41e8-45f0-52b3-c5657ce2a1ee@redhat.com>
References: <1464804396-13936-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uKwFH9iidbTVMxNcPml9ELp2eHfsOTwkw"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464804396-13936-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Ira Weiny <ira.weiny@intel.com>, Christoph Lameter <cl@linux.com>, Matan Barak <matanb@mellanox.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uKwFH9iidbTVMxNcPml9ELp2eHfsOTwkw
Content-Type: multipart/mixed; boundary="M86GKbGL1xEvVVqJaw1wsp5Iqrq2rjp1H"
From: Doug Ledford <dledford@redhat.com>
To: Colin King <colin.king@canonical.com>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, Ira Weiny <ira.weiny@intel.com>,
 Christoph Lameter <cl@linux.com>, Matan Barak <matanb@mellanox.com>,
 Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <730297f0-41e8-45f0-52b3-c5657ce2a1ee@redhat.com>
Subject: Re: [PATCH] IB/core: fix null pointer dereference and memory leak in
 error handling
References: <1464804396-13936-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1464804396-13936-1-git-send-email-colin.king@canonical.com>

--M86GKbGL1xEvVVqJaw1wsp5Iqrq2rjp1H
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/1/2016 2:06 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> The current error handling in setup_hw_stats has a couple of issues.
> It is possible to generate a null pointer deference on the
> kfree of hsag->attrs[i] because two of the early error exit paths
> jump to the kfree when hsags NULL and not allocated. Fix this by
> moving the kfree on stats and jumping to that, avoiding the hsag
> freeing.
>=20
> Secondly, there is a memory leak of stats if the hsag allocation
> fails; instead of returning, jump to the kfree on stats.
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, applied.



--M86GKbGL1xEvVVqJaw1wsp5Iqrq2rjp1H--

--uKwFH9iidbTVMxNcPml9ELp2eHfsOTwkw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVgVtAAoJELgmozMOVy/dj1AQAKGY3uTmRahizppS87YEqxoD
n9lbavF+7vhBkeY28juEpEdvkmqPydBXfDJq6YUbNaW9K7QqMSrhTpdeKIgc8KvF
jTpqfEdj/L4sg+KhwLbLqK3DSIlk1Bjk1UsA0DTSXdXs+SzJu6Yi8ng1irnYtPs3
oNrx0h4lpf/NeP0V/sEpO9rEShmm3BX26uwMjZOixk5KEqtcFeqc4iZL/81DTPqT
vKNEjBwosMw/7FOiCyaNfSzkRD3BQEd1xFwWp9dIX72L47IgfkH0mCjMtFiddV7n
TbxPP2fSxR/KJ23rVmtz5XSqSE7mxOLYTjprDWQTL5EKXUAT7LKmAQW90aLbeGRr
sy4POL48NwHDo1P1sE32H52cPpdGb9MeDdAZ0CvB+ZzuV2XRaS9blfVZ17Y5NnWk
Dp6QTY9+HDJ0GcwWltL5prI7K+wiNGeEvQOhLPyH8jJ6hm3hmMGff85gHc4yk+wR
UX18wBLkEJPOmpgS7sOisstK4+FVjb+M++N9mNskxBXWq5W9K+QUp7BW2I4wltBs
P3HnM50AIqnssaEjldPV77K6llIy23WRE7yuNbPABtsMnFyI3bVn9PROoDAlNE0t
TvEvxITfoRS38Hs2qoxLSfem6521xs/IDQUxquS+cXx0NKAgOzlIYUIAfBHWCYG2
BzhNrzAKQmjGV3ezO73E
=+Fng
-----END PGP SIGNATURE-----

--uKwFH9iidbTVMxNcPml9ELp2eHfsOTwkw--
