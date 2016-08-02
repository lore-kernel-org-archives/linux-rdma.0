From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 0266/1285] Replace numeric parameter like 0444 with macro
Date: Tue, 2 Aug 2016 21:52:47 +0300
Message-ID: <20160802185247.GC27667@leon.nu>
References: <20160802105446.31475-1-baolex.ni@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160802105446.31475-1-baolex.ni@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baole Ni <baolex.ni@intel.com>
Cc: faisal.latif@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, bp@alien8.de, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, hch@infradead.org, matanb@mellanox.com, markb@mellanox.com, jgunthorpe@obsidianresearch.com, dean.luick@intel.com
List-Id: linux-rdma@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2016 at 06:54:46PM +0800, Baole Ni wrote:
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permiss=
ion.
> As we know, these numeric value for access permission have had the corres=
ponding macro,
> and that using macro can improve the robustness and readability of the co=
de,
> thus, I suggest replacing the numeric parameter with the macro.
>=20
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Baole Ni <baolex.ni@intel.com>

Looks good,
Reviewed-By: Leon Romanovsky <leonro@mellanox.com>


> ---
>  drivers/infiniband/hw/nes/nes_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/n=
es/nes_hw.c
> index a1c6481..f25c37f 100644
> --- a/drivers/infiniband/hw/nes/nes_hw.c
> +++ b/drivers/infiniband/hw/nes/nes_hw.c
> @@ -41,7 +41,7 @@
>  #include "nes.h"
> =20
>  static int wide_ppm_offset;
> -module_param(wide_ppm_offset, int, 0644);
> +module_param(wide_ppm_offset, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH=
);
>  MODULE_PARM_DESC(wide_ppm_offset, "Increase CX4 interface clock ppm offs=
et, 0=3D100ppm (default), 1=3D300ppm");
> =20
>  static u32 crit_err_count;
> --=20
> 2.9.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXoOv/AAoJEORje4g2clinqG0QAKVb/jBwugcuaiesqHceBosj
rxazLVxfMTse/Qzpm9b5WD1TSvXPsE537P1CQqzgv6jf3Fz26iJtxdyuaefXFfLG
xPaj0CsCJXQwZEh1jve0GImBgqNfzwQ84Sv5KOwaLlpFecgHIay1UxIkSjl+D8ok
vY1VmnaeZcaGtMsu2KlmgOu4lXluo2/wiTtjMc306FGn1IDJHa/Kc+mp73MMjar7
UjFge0dvl+eaLELX6zncoSJZ9ok96fYbFfS178H0hbTf9dW7O/sdl7LFlgRIY1uL
QKUHPHRPIc/+tmh79Ca4xD2H43Vyw0rTHmTgfq8jyXEY3itLI9j0wzCDc67XAdRO
T0uOFvYmnppG2jmILE5dJ97uJYgUNQ2nXheusHeLz+5zh2ftDWz6ytNz8EgWAbXn
sPgKCEwXabx5Tjn8Ujx/RKhwdKKU9WiYlWGdMdCnLbE6A5CiU5JxIDGJdsG8RFGY
rlH9O/8RH1Scy1IEo/kfWS7LbfaqfesswgEzEeQ/ms4FJZi4q5MiXbGTJEF2NlZO
WWmjWqWZCP6NwgQBijyYvGmqn+dbs/XfsSpABNvD4coqt0WkZXJVW3PhMy9wCkcp
8enCd1s2yxHozRSa2XjyyCLkPc/npAj8M+17+/3VGeqW5270HNcMap8/U6aIK8p0
zY7CDXUGc4B5oTO5xm6O
=6hNZ
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
