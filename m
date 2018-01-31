From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Trivial patches for SoftRoCE
Date: Wed, 31 Jan 2018 16:34:15 -0500
Message-ID: <1517434455.19117.48.camel@redhat.com>
References: <20180130073006.GA3244@yuvallap>
         <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
         <20180131123901.GE10485@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-kUyJGerUXYmLnNXwCARJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180131123901.GE10485@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-kUyJGerUXYmLnNXwCARJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-31 at 14:39 +0200, Yuval Shaia wrote:
> On Wed, Jan 31, 2018 at 06:06:53AM -0500, Zhu Yanjun wrote:
> > Follow advice from Yuval and Leon, to the functions rxe_av_chk_attr,
> > rxe_av_to_attr and rxe_av_fill_ip_info, the unnecessary parameter
> > are removed and the funtion type are changed to void.
> >=20
> > To track the changes to these functions, every change is made
> > to a single patch.
> >=20
> > Zhu Yanjun (6):
> >   IB/rxe: remove redudant parameter in function
> >   IB/rxe: change the function to void from int
> >   IB/rxe: remove unnecessary parameter in rxe_av_to_attr
> >   IB/rxe: change the function to void from int
> >   IB/rxe: change the function rxe_av_fill_ip_info to void
> >   IB/rxe: remove redudant parameter in rxe_av_fill_ip_info
>=20
> Since all seems to be related i wonder why not in a single patch.
> I assume they will squashed to one before merge, right?
>=20
> Besides that, for all:
>=20
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, series applied.  And I couldn't squash it without loosing info,
so they stayed separate (Leon reviewed 4 of the 6, if I squashed it I
would to have either added his name on the single commit, indicating he
reviewed all of it when I didn't have the right to indicate that, or
drop his name and thereby drop the credit for what he did review).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-kUyJGerUXYmLnNXwCARJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpyNlgACgkQuCajMw5X
L92cPxAAuPW/vAcQl0sDJ6Dz7dJq/USGws1UxNKmTRpqjIZTmCX1UxGAPnuHtY1m
YBg5t6dKgA1O2dQvNur/bNwk+sNKO9rFndRYIO7paiQU1Bcs9j8/aR5ig7HwCCfJ
DuH5TK2CaLSwVcSaVFj1tiJJJv3JuVGyw+mG1uFqig3+YFcpwYP3W+xvCVn8LRWy
o1vvS1XEJKzP+2ZkZW2Sd/T0H4MNEx4KOLqLykKSQD+wkv0PoKMaQYHRSfsLIaBA
foeryfhC7EYmIx2wWfC1WTMJgW32n44yfDC2fcw6N600hsF3Wo5EiwMsx0NnSuXS
yZCkZKUlYC3C8EZxG31HiN7lj0cOIoXoPzn9+bDSrLWVjgIopA2CUqULHOWnu6Mc
qWInbjE6j/h4LfT+Yhbp4D1MPvekvKFgrK+aRUaTai/TC06wtgQlaFpKSu3QWia1
2ifVMLdikgNLy7CIay7qnOYwnzJ+YsF70MGQnE/VhceCZsdMgDlkHJXNXINBX73x
jbq0Vp+5MoqRSiD8DpRa2EC/jKVk+ttU1dWbo7O9uFsOoYBSvHfaklJWLqowmOel
QgFKoW1ZQUKYhBU+G0whOr8EwPG7uyNylqEnesTL/lLcVfHKviu6wIgLsUvQix2y
mSDQc4mY0ArVk455ivJqQlKN9AhI45dy9Lr429I8aX5t66idhXo=
=9ht6
-----END PGP SIGNATURE-----

--=-kUyJGerUXYmLnNXwCARJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
