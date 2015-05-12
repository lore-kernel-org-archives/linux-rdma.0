From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4][RESEND] IB/mad: refactor functions based on the
 needs of those functions.
Date: Tue, 12 May 2015 16:07:02 -0400
Message-ID: <1431461222.43876.80.camel@redhat.com>
References: <1431109644-27226-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-NU0Zukb7NVoE1MFGGawz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431109644-27226-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-NU0Zukb7NVoE1MFGGawz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-08 at 14:27 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Resent due to patchworks being reset.
>=20
> validate_mad, ib_response_mad, and rcv_has_same_class only need the IB he=
ader.
> Refactor these functions as appropriate.
>=20
> In addition set const for functions which take read only structures.
>=20
> Added Jason and Sean's Review by.
>=20
>=20
> Ira Weiny (4):
>   IB/mad: Change validate_mad signature to take const ib_mad_hdr rather
>     than ib_mad
>   IB/mad: Change ib_response_mad signature to take const ib_mad_hdr
>     rather than ib_mad
>   IB/mad: Clean up rcv_has_same_class
>   IB/mad: Add const qualifiers to query only functions
>=20
>  drivers/infiniband/core/mad.c      | 54 +++++++++++++++++++-------------=
------
>  drivers/infiniband/core/mad_priv.h |  4 +--
>  drivers/infiniband/core/user_mad.c |  6 ++---
>  include/rdma/ib_mad.h              |  4 +--
>  4 files changed, 34 insertions(+), 34 deletions(-)
>=20

These have been picked up for 4.2.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-NU0Zukb7NVoE1MFGGawz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUl1nAAoJELgmozMOVy/d7VgQAKlUYMVuBFh2qEmPDDxdsXbQ
elxL77BRb1yimCfCh/jofouvgImKDEag0kLVKZOkB7CPZqB2/IsrHJ1mMh5FkOTv
5gzHTKF44sdwMubKcCHo0R8lNOI5z6O3p2vl0de/OMjSckt73yNd4WtX4AFUbxXv
B8RbQHj4yGOElRwWphhRLQMJjMkbUqHizKu6gdJdhoZVfsl5S46uFCA4sSVjEA21
n+qZHn8c/YpSMyG555hEVGD5uBGsoyFiYFu8rryJogwEf3iFDy3YcYPWo8Ac/1k6
8W8jvwfdkcFyjkhT9eihrxcBSETnIAYIMBxRxyMb3UWz63iz+/LWP38kksGc3FK7
sPxkTfTh8Fic2MdruTnd8FI+GpHxwhK3vic5QSOL4OHRSBqZ6QYKpnKPuG5adxjj
qPSfk1AKYQGvsSxPE76EP5c2x13wBw00QOzqfXIEDP1H3hMDVxA8E7lyyKo3MurC
Ppc4vGMo0mAVbK++wrstGPS7UqS7J3ZUi6fprQGyYWs3qr9aAN8Qf4rPhgRIyL4s
M9uuMyNqn+nB/OKCMTUnjbkDUZr0Xoh2NHtqzuP2v/R9bxDWlCorD2yYSl7k/we4
/T1vYeTeAjd0FJGHGIWuN5ccx+1YMxG2O3YiYoSkbEA1yhX6N10rD0LM0Kf97jTc
snaOx3O9XLtAVbZz2cqR
=h6jM
-----END PGP SIGNATURE-----

--=-NU0Zukb7NVoE1MFGGawz--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
