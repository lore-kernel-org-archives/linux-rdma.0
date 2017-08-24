From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Thu, 24 Aug 2017 08:27:16 +0300
Message-ID: <20170824052716.GD1724@mtr-leonro.local>
References: <20170817173932.GJ23648@mtr-leonro.local>
 <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
 <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
 <20170823160816.GA11188@obsidianresearch.com>
 <20170823164555.GV1724@mtr-leonro.local>
 <20170823165221.GB23928@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f/XZMZU9ST6S8MjH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170823165221.GB23928-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--f/XZMZU9ST6S8MjH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2017 at 10:52:21AM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 23, 2017 at 07:45:55PM +0300, Leon Romanovsky wrote:
>
> > > Provide two implementations of mlx5dv_init_obj, one that has the
> > > historical behaviour that has existed until now of returning the
> > > void **uar and a new version that returns the 'void *' version
> > > renamed to arb_db.
> >
> > arb_db -> arm_db
>
> Oops, I fixed that, thanks.
>
> > Strange, in github it has 7 digits (the same was with rsocket fixes)
> > Fixes: c6e3439 ("mlx5: Return pointer to CQ doorbell")
>
> Yeah, side effect of github rendering it into a web link, I think.
>
> > The overall looks good, but I need to run checks with before
> > applying it.
>
> Sure, I didn't test it obviously, but the readelf is what I expect:
>
>    101: 000000000000e4d0    55 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_ob=
j@MLX5_1.0
>    168: 000000000000e4d0    55 FUNC    LOCAL  DEFAULT   13 __mlx5dv_init_=
obj_1_0
>    102: 000000000000e300   451 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_ob=
j@@MLX5_1.2
>    169: 000000000000e300   451 FUNC    LOCAL  DEFAULT   13 __mlx5dv_init_=
obj_1_2

It is not complete output as I would expect to see. It doesn't have
mlx5dv_init_obj (without explicit @MLX5_1.2). There is a need to declare de=
fault
function name for the static linking has no knowledge of versions.

The simplest approach which is used in whole rdma-core is just retain
the original function name and the patch below on top of your patch
achieves it.

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 7ec5951b..49dd4f12 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -716,8 +716,7 @@ static int mlx5dv_get_srq(struct ibv_srq *srq_in,
 	return 0;
 }

-int __mlx5dv_init_obj_1_2(struct mlx5dv_obj *obj, uint64_t obj_type);
-int __mlx5dv_init_obj_1_2(struct mlx5dv_obj *obj, uint64_t obj_type)
+int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type)
 {
 	int ret =3D 0;

@@ -732,14 +731,13 @@ int __mlx5dv_init_obj_1_2(struct mlx5dv_obj *obj, uin=
t64_t obj_type)

 	return ret;
 }
-asm(".symver __mlx5dv_init_obj_1_2, mlx5dv_init_obj@@MLX5_1.2");

 int __mlx5dv_init_obj_1_0(struct mlx5dv_obj *obj, uint64_t obj_type);
 int __mlx5dv_init_obj_1_0(struct mlx5dv_obj *obj, uint64_t obj_type)
 {
 	int ret =3D 0;

-	ret =3D __mlx5dv_init_obj_1_2(obj, obj_type);
+	ret =3D mlx5dv_init_obj(obj, obj_type);
 	if (!ret && (obj_type & MLX5DV_OBJ_CQ)) {
 		/* ABI version 1.0 returns the void ** in this memory
 		 * location

------

=E2=9E=9C  rdma-core git:(tst-uar) =E2=9C=97 readelf -s build/lib/libmlx5.s=
o |grep -i mlx5dv_init
    99: 000000000000dab0    55 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_obj@=
MLX5_1.0
   165: 000000000000dab0    55 FUNC    LOCAL  DEFAULT   13 __mlx5dv_init_ob=
j_1_0
   194: 000000000000d8f0   443 FUNC    LOCAL  DEFAULT   13 mlx5dv_init_obj
   268: 000000000000dab0    55 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_obj@=
MLX5_1.0


>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--f/XZMZU9ST6S8MjH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmeY7MACgkQ5GN7iDZy
WKcZZg//ZTh6nxo0DY44nAHTJCQV9Pci81sXk4NI6GDW2asW7wFg+wlbs5nz94qI
aofDHcCK0S5QND8UDwssy46mJZo1RKhi8KGh6ymTQTvYOoNeu56T5EVVK2aRJIz8
3Mi4FbBtcviXcZfRX9wseI/01MgoA3IO8Rtfbh9K/Dz+2aFNjxkhtcfdSQxNObtq
6zfheNJVKp0RBpp0/DTvPTIXn/JklQsgaYE1YEsvX59BRu60vtbCGWAnm5CQDrAY
A4c3UBacWj7hRNjVPCwObNqkLkNGRNpO3uIQUsvUdZi+d4f7MZSlWcvJlayP9Xzr
+FRmQhhGbwzJHbc+x6lLcM+qQ8bbTpP2H6vfefN5JlGOr57G+7EZAcIv00sdZyLN
yYtwrP8gXYcxECV6Wl5OS6r4ZvqfuHVjYlbS22n+Gvk9/Kl2S3rsXSaUsrBNSl76
VrDLUx3xkZsVSpMqRJcp2WvHvTugMklkOiS12Qe2vVDTiFTD9OFJtncE31pt/teb
hCS5aAJJ6UGh8geOyX1MPxA6TLgOvLQk6jsqggLnoLlY6ugncEecwpsJSFVG7W0V
8yCLLbZl2ZrP+60UqCqMYQrPA5IyqJLh7qcSDMyM5FfIcd5yelTVhYf996IxK7jn
nKV4tqCf1DLD8tP6fjNC/8CNLB4Jp6Rj+SbHWm15re24pZb4Zu4=
=ugrg
-----END PGP SIGNATURE-----

--f/XZMZU9ST6S8MjH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
