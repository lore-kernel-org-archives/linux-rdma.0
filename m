From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/rxe: add the static type to the variable
Date: Mon, 08 Jan 2018 17:45:45 -0500
Message-ID: <1515451545.3403.122.camel@redhat.com>
References: <1515326928-22282-1-git-send-email-yanjun.zhu@oracle.com>
         <20180107133833.GB6823@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-6X+N0VUzNHsfCDGcQMpW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180107133833.GB6823-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-6X+N0VUzNHsfCDGcQMpW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2018-01-07 at 15:38 +0200, Leon Romanovsky wrote:
> On Sun, Jan 07, 2018 at 07:08:48AM -0500, Zhu Yanjun wrote:
> > The variable recv_sockets is only used in the file rxe_net.c. So
> > it is better to add static type to it.
> >=20
> > CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > CC: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/sw/rxe/rxe_net.c | 2 +-
> >  drivers/infiniband/sw/rxe/rxe_net.h | 1 -
> >  2 files changed, 1 insertion(+), 2 deletions(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-6X+N0VUzNHsfCDGcQMpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpT9JkACgkQuCajMw5X
L93uVQ//fUL1fQ3hiwdf0cev7Dxt42E2hcv0uwhf13PONSOZVhLQH8QFesmRfiJs
YRU7U8IWWjJw1I7yV7ByCGhXjzfbzz5hhcuVoqOdB08BeXm/+CcQefudWhYPuNZp
FDgd4pBJxVdixnWAwQMq+xXWMby0UPLPpLO+VtJ/BOfDur2XOUqy/5l2SUGg7I90
wabzvPddsb+fCh0sfur6TuD2iOSeBDtDLDAZEq76Km4i006AF6kb7z2az6m1GnyP
ccuu4tXPHbg1Gkebn/kSV+tykh6B4oRHR9DMdjcGP5jwCC4PhpFS484DKXnCGyMK
lOhZ6md2pXzsStkuuprTIgOdYa+VzwsCSZJO0z0DA8Z1uhXaT85PXgkLpCH8eeNa
0BSeX7dcnsltSfI/yyoeJHNB2uYokKlPgwoWoSLGbuIisqYuewZ4Iu5K3Rym94aa
d31mKoXtCBlXG4Z7nydQuZAYRBH7Ee0lFTzbeZJ2iDszajhfqvfmPoxClkMERuMK
SE4/02X06TAL3yJSVt/6OE4bmEURlXeysrIeL5jBvM8xrAdJ1R1hOyiqae4dsk+r
jU2AOpmJvMgrn92hw+n0WcZT043u4phUzdlxq1GJTQR1793CvQFUrxmlF77nFsDn
FqGjqAmZWJmuMRqNVIy7iB4nN1AbA1ah1yxB9DWIBzOiBsyIJfY=
=EJ53
-----END PGP SIGNATURE-----

--=-6X+N0VUzNHsfCDGcQMpW--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
