From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH] IB/core: avoid 32-bit warning
Date: Wed, 07 Oct 2015 15:00:26 +0200
Message-ID: <1444222826.3188.62.camel@opteya.com>
References: <17269152.DqJfCm1LOx@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17269152.DqJfCm1LOx@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org, Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 07 octobre 2015 =C3=A0 14:29 +0200, Arnd Bergmann a =C3=A9c=
rit :
> The INIT_UDATA() macro requires a pointer or unsigned long argument=20
> for both input and output buffer, and all callers had a cast from=20
> when the code was merged until a recent restructuring, so now we get
>=20
> core/uverbs_cmd.c: In function 'ib_uverbs_create_cq':
> core/uverbs_cmd.c:1481:66: warning: cast to pointer from integer of
> different size [-Wint-to-pointer-cast]
>=20
> This makes the code behave as before by adding back the cast to
> unsigned long.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 565197dd8fb1 ("IB/core: Extend ib_uverbs_create_cq")
>=20

Reviewed-by: Yann Droneaud <ydroneaud@opteya.com>

> diff --git a/drivers/infiniband/core/uverbs_cmd.c
> b/drivers/infiniband/core/uverbs_cmd.c
> index be4cb9f04be3..88b3b78340f2 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -1478,7 +1478,7 @@ ssize_t ib_uverbs_create_cq(struct
> ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof(cmd)))
>  		return -EFAULT;
> =20
> -	INIT_UDATA(&ucore, buf, cmd.response, sizeof(cmd),
> sizeof(resp));
> +	INIT_UDATA(&ucore, buf, (unsigned long)cmd.response,
> sizeof(cmd), sizeof(resp));
> =20
>  	INIT_UDATA(&uhw, buf + sizeof(cmd),
>  		   (unsigned long)cmd.response + sizeof(resp),
>=20

Regards.

--=20
Yann Droneaud
OPTEYA
