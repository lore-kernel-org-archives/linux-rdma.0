From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 3/3] IB/mlx5: Fix mlx5_set_path for Raw Packet QP
Date: Mon, 4 Jul 2016 08:14:03 +0300
Message-ID: <20160704051403.GB5289@leon.nu>
References: <1467549727-23479-1-git-send-email-leon@kernel.org>
 <1467549727-23479-4-git-send-email-leon@kernel.org>
 <CAJ3xEMhZiBjQwjgXj8peLYW4wETEE96UJ8BC7TLyO0G_jn-iBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhZiBjQwjgXj8peLYW4wETEE96UJ8BC7TLyO0G_jn-iBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2016 at 12:55:36AM +0300, Or Gerlitz wrote:
> On Sun, Jul 3, 2016 at 3:42 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>=20
> > --- a/drivers/infiniband/hw/mlx5/qp.c
> > +++ b/drivers/infiniband/hw/mlx5/qp.c
> > @@ -2175,7 +2175,8 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev,=
 struct mlx5_ib_qp *qp,
> >         }
> >
> >         if (ll =3D=3D IB_LINK_LAYER_ETHERNET) {
> > -               if (!(ah->ah_flags & IB_AH_GRH))
> > +               if (!(ah->ah_flags & IB_AH_GRH) &&
> > +                   (qp->ibqp.qp_type !=3D IB_QPT_RAW_PACKET))
> >                         return -EINVAL;
> >                 memcpy(path->rmac, ah->dmac, sizeof(ah->dmac));
> >                 path->udp_sport =3D mlx5_get_roce_udp_sport(dev, port,
>=20
> As you can see here, that code was written with RoCE state of mind,
> e.g they set the remote mac and udp source port, with both being
> irrelevant for RAW packet QPs. So in that respect, your fix is wrong.
> Make the code clear and correct in what they set to RoCE QPs, to RAW
> Packet QPs and to both.

If I read your response and code correctly, we can safely drop this
patch. Am I right?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXefCbAAoJEORje4g2clinTrUP/1r9UWEp98QN/TBlRag8WeHu
GV81i560ZSxGZjFu0lTfUotP2ZcTSrPOhJO+mEr09p3xfOJJgGQWt77tiMQzrZfs
fiwijUYk/l9nVh72sg2oIk7jes3faK4uYGWMEftDUzn3dSJfjfV07VD/yc7gi0H9
vVTIDWnZFCoV3WyyYe/ey/cGbWFglOX5bp4ybeKVwThrDl00ABj6Qu0m1nrpUhHl
xC4S1gx7DP6JLS+ovJ1I8/8Ld/D2vSgRq8lf52CCLbIfzNGdCcpY9X+e8etBb0Cj
o3hficUT5Eg84fdLWhYCqJnhvMzI3M13gViikCgFteyF1Ano/JVzmI/XYXRYndCD
Cw/uNIVR782YTvAeUKCGjqyJKGkx4nLV5sDhAYhMMbTX76ivt02TdW3yn/VPkWpF
FGVh3qdsviur62UxxgKMBLQslg/tbG0D5SmHy1v0wXPCdwyZ9zgifGqBHNMJ3rK4
6K01FUYsWU+S/k91SsgtHymOFVaAVm2m8lzXaNgwujQiBTnoohxOt/F5vFWXkcLM
WBwN5bENzLb/SOB12X3iU1mU9diivo0W2EVKzNZy4YqpQhgyJWrVaZIr0gjKZb2L
L5poPv0idTWF2sTIo8dPVseoLg9zqgrYpjoFJXB2k03dcV+jUbJMBtnIoqcnBL7l
giNsazk+Tf1kfgQZzJL6
=cGRO
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
