From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0261/1285] Replace numeric parameter like 0444 with macro
Date: Tue, 2 Aug 2016 15:32:42 +0300
Message-ID: <20160802123242.GB27667@leon.nu>
References: <20160802105418.31139-1-baolex.ni@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160802105418.31139-1-baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2016 at 06:54:18PM +0800, Baole Ni wrote:
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permiss=
ion.
> As we know, these numeric value for access permission have had the corres=
ponding macro,
> and that using macro can improve the robustness and readability of the co=
de,
> thus, I suggest replacing the numeric parameter with the macro.
>=20
> Signed-off-by: Chuansheng Liu <chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>  drivers/infiniband/hw/mlx5/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index b48ad85..3ae01dc 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -65,7 +65,7 @@ MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_VERSION(DRIVER_VERSION);
> =20
>  static int deprecated_prof_sel =3D 2;
> -module_param_named(prof_sel, deprecated_prof_sel, int, 0444);
> +module_param_named(prof_sel, deprecated_prof_sel, int, S_IRUSR | S_IRGRP=
 | S_IROTH);
>  MODULE_PARM_DESC(prof_sel, "profile selector. Deprecated here. Moved to =
module mlx5_core");
> =20
>  static char mlx5_version[] =3D
> --=20
> 2.9.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXoJLpAAoJEORje4g2clinlqQQAJ84pjRm+RKlo9dSwpkasMPF
+ByD63qVYfjHKI2Pe3DW0t72/suZkKf4DClsJmCpewKASZKywKopZ7zUCP5xcziS
piQ06EH7XkoL3lOlGJzZwXVAjVzsK+6QfmZa/F2erNu8xiKLZO0azSZqN1/L8yJ0
0KmiQC08bc8CvN48kBwemLZcKdfG1lwor+lSmHQjFNvS2/Xtli8BGxOU6db5XMXB
HM0CWphvoZBaWuQl8YdDxQ6TTbOhUsAkxuSZU3SCzi0uXjKcgcywa7lOWQ7yEAAB
cZC4A4yZhEpu4OVxD9fbZBAT98Jp0i5gMhqcQ2EJhzUhvBlbZRGspIg1TJT38bzA
GNF/NR26S7ZlVYpXOzDHyhQQ4MB58/GuEKknjDLPvf22NVKxGqIhEKTU6ovE8frE
E3SF2dOjcSk17uq3E9fzPp4C6WTDB1e5B3fqO4kGh4atUBrmhCEITpJKsixRPFDE
M3EC1Vj6mYTHcsB3Pd0GkTfVISqM8ucPxPa0N/492t7mWCsnoRx/dPx3gYE+A6fP
hwFU6zsA1vUykwFXnkekCGfntih6WY17nAX/cgXUxgPYqIhn2slGg3xEbrp5iTq9
tqD/nP7hbn0Pth6YNfEgrJVl+ob2YjH8CJTvUvgVMO3VP5GojvlMXTi6hdHhO/vj
gkuVAq0+zlrQYkbLNeA0
=2KNV
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
