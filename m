From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] ucma: fix a use-after-free in ucma_resolve_ip()
Date: Thu, 13 Sep 2018 13:05:51 -0400
Message-ID: <766785311ebb5f5b0f36196f67125262a7c7afe8.camel@redhat.com>
References: <20180912232744.12693-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-4Gspl+N3iMdt1XPSWxxa"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912232744.12693-1-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-4Gspl+N3iMdt1XPSWxxa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-09-12 at 16:27 -0700, Cong Wang wrote:
> There is a race condition between ucma_close() and ucma_resolve_ip():
>=20
> CPU0                            CPU1
> ucma_resolve_ip():              ucma_close():
>=20
> ctx =3D ucma_get_ctx(file, cmd.id);
>=20
>         list_for_each_entry_safe(ctx, tmp, &file->ctx_list, list) {
>                 mutex_lock(&mut);
>                 idr_remove(&ctx_idr, ctx->id);
>                 mutex_unlock(&mut);
>                 ...
>                 mutex_lock(&mut);
>                 if (!ctx->closing) {
>                         mutex_unlock(&mut);
>                         rdma_destroy_id(ctx->cm_id);
>                 ...
>                 ucma_free_ctx(ctx);
>=20
> ret =3D rdma_resolve_addr();
> ucma_put_ctx(ctx);
>=20
> Before idr_remove(), ucma_get_ctx() could still find the ctx
> and after rdma_destroy_id(), rdma_resolve_addr() may still
> access id_priv pointer. Also, ucma_put_ctx() may use ctx after
> ucma_free_ctx() too.
>=20
> ucma_close() should call ucma_put_ctx() too which tests the
> refcnt and waits for the last one releasing it. The similar
> pattern is already used by ucma_destroy_id().
>=20
> Reported-and-tested-by: syzbot+da2591e115d57a9cbb8b@syzkaller.appspotmail=
.com
> Reported-by: syzbot+cfe3c1e8ef634ba8964b@syzkaller.appspotmail.com
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-4Gspl+N3iMdt1XPSWxxa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAluamO8ACgkQuCajMw5X
L91vag/+PEBcI6iJ5wMe0EaVhj/e1hk7rFHGJpcdPiaCOaN/BpOiU7EJDzcjAx+b
IpoLAQ90A7jzO9lrgptpt0wS878AFaFspsPEoanD4xpekeeiowchouKfJ6ghLGVg
4KPpchWkkS39uaUH5wBnPe5mM2okk3iTrCOxRLjLJ0vmWnlmDCfzmREiqEu/W9OQ
2OZVC0C4wjeRrd7/HQ39sgSk2D8rfcSEIY29SBN4M9CbwhAkP9VYBHoHyNWXQoJt
dc8uh0WlSqV08QFeN507mViMqSYlTIwwMBj5vusZ2mDesxe67nk0cMDdIssPqwUc
MzqfBJ8es2/FJ44AMuVs2jGhZDzGWCHFo1BL3PO5Lkb6t4NVCj+IWdHGGH/+6HAC
vCPthQ60kKsSm6MApSpf7j1Y1PDH2gkJgRLRHLiPOiH8/LceyQg2MhyFS/cUMQmg
0l+dKo1qIgjela/idsTX6fwsQbITggST1ZB3MOvCk7Vb4ak+yp+vJgrrUv/oMlYT
9kBOGGjY+WfpPlzhbwl+p8bREkyRtuaSQ/nQgvcbrpsl4SRnLeqcuDfoFAOIIU9e
StqXNTlGQwbn47ISs2eoR3536r/3eBbhEQflHQiWAVGTuemLSLgH9EDOBgA5Ayv8
cXfx2HGyeMtzL1q/zTvxE+TDYlagmvHl4oXJKPNw8R6Fz6oiOH8=
=oBty
-----END PGP SIGNATURE-----

--=-4Gspl+N3iMdt1XPSWxxa--
