From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 libibverbs 0/2] Add memory re-registration support
Date: Thu, 17 Mar 2016 10:00:09 -0400
Message-ID: <56EAB869.1030703@redhat.com>
References: <1457953147-4280-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cmxuhhNfm9dWtK03W8dQF0mprBvoETxGL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457953147-4280-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cmxuhhNfm9dWtK03W8dQF0mprBvoETxGL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/14/2016 06:59 AM, Yishai Hadas wrote:
> Hi Doug,
>=20
> Sending V3 to address your note to return an informative error code
> when ibv_rereg_mr has failed.
> This will let an application to clearly know what is the state of
> both old and new MRs.
>=20
> Man page was updated accordingly.

Thanks for the updates, I've applied this set now.

> Yishai
>=20
>=20
> Details:
> Memory re-registration is a feature that enables one to change
> the attributes of a memory region, including PD, translation
> (address and length) and access flags.
>=20
> The first patch changes the API between libibverbs and the provider's
> library. This change is safe as there's no ibv_rereg_mr verb exposed to=

> the user and thus no reason for a vendor to implement or use this funct=
ion.
>=20
> The second patch adds the actual memory region re-registration support.=

>=20
> Changes from V2:
> #patch #2:
> - Return an informative error code as part of ibv_rereg_mr.
> - Update man page to match above.
>=20
> Changes from V1:
> #patch #2:
> - Fix man page issues.
> - Fix mismatch in the API around the 'access' field.
> - Improve input parameters validation.
> - Drop some un-relevant comment.
>=20
> Changes from V0:
> Split to 2 patches:
>   libibverbs <--> provider's library API change
>   Add MR re-registration support
> Matan Barak (1):
>   Change rereg_mr API between libibverbs and the provider's library
>=20
> Yishai Hadas (1):
>   Add MR re-registeration
>=20
>  Makefile.am                   |  3 +-
>  include/infiniband/driver.h   |  5 +++
>  include/infiniband/kern-abi.h | 20 ++++++++++++
>  include/infiniband/verbs.h    | 25 ++++++++++++--
>  man/ibv_rereg_mr.3            | 76 +++++++++++++++++++++++++++++++++++=
++++++++
>  src/cmd.c                     | 29 +++++++++++++++++
>  src/libibverbs.map            |  1 +
>  src/verbs.c                   | 62 +++++++++++++++++++++++++++++++++++=

>  8 files changed, 218 insertions(+), 3 deletions(-)
>  create mode 100644 man/ibv_rereg_mr.3
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--cmxuhhNfm9dWtK03W8dQF0mprBvoETxGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW6rhpAAoJELgmozMOVy/dApoQAL88/l3ggFn9ks3+971VlTD/
+5rMnm/AMT64gn6ZQvN5QouPdGkRIaFZFLhVvSxUdBv3Z8i242/FxLgSeaQGcaGM
HIffEl0AOsZjYM1TO6YdJY74VIB+7g2llxTLGE2bnejqoy2RZZZ33xw5VSmczCKA
OmTWP+45tlIk9khpade4/E4tT88VCabJnjoRdaW0Jx3pQPWf6EMKxoTvq+odqu81
s9QvWDBbFeQkQpyLKyC+Yr2iiOvc8cUlqDr2wacp61FdpRgxL+9TlrQNz8nNAvMm
gsU6FY81PVK62DQT+siu0FjrmyjY2OPxQluiwx7D+70jIR2hllAtBdbnlL9JfJTb
njuGh8BXRrJGYA76Y1rVjlha8Z2erxWwPsPW4w8DBbu8VUyKmHKRaUcnJKhFFznj
rV+Lg+IjxvwrhjNrMMni+4BPwjF6CkQpyZMo8loycCt2/W0tsTHyOi4oXkjQJGRd
Y8XjE62Yi6qdAnFrvSdEFOQRWnOpID7hszo8fdt6vA4g2lVm16t7RS4qhyNxRPV1
BTc8fzb2VP0jIKrGTRYHZll8XbW1mK1BSiCIC5JHEsBIaOTyl6uHmiq7jRK1tL6S
6n5eyoLLb/CKwZennYKa0KL4aptFVdEfZbdOlsSyxRfwLW+keXU3ZbQe0KXjl9Ta
whX+GTpMzWisI+k2gkCb
=mME8
-----END PGP SIGNATURE-----

--cmxuhhNfm9dWtK03W8dQF0mprBvoETxGL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
