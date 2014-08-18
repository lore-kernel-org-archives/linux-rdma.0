From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH] infiniband: hw: cxgb3: cxio_hal.c:  Cleaning up missing
 null-terminate after strncpy call
Date: Mon, 18 Aug 2014 15:30:08 +0200
Message-ID: <1408368608.3030.4.camel@localhost.localdomain>
References: <1408315225-16807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408315225-16807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 18 ao=C3=BBt 2014 =C3=A0 00:40 +0200, Rickard Strandqvist a =C3=
=A9crit :
> Added a guaranteed null-terminate after call to strncpy.
>=20

Good catch. Do you have an automated way to catch such mistake ?

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigit=
al.se>
> ---
>  drivers/infiniband/hw/cxgb3/cxio_hal.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infinib=
and/hw/cxgb3/cxio_hal.c
> index de1c61b4..5fc04e4 100644
> --- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
> +++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
> @@ -933,6 +933,7 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
>  		netdev_p =3D rdev_p->t3cdev_p->lldev;
>  		strncpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
>  			T3_MAX_DEV_NAME_LEN);
> +		rdev_p->dev_name[T3_MAX_DEV_NAME_LEN - 1] =3D '\0';

Why not replacing this by

		strlcpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
			T3_MAX_DEV_NAME_LEN);

Regards.

--=20
Yann Droneaud
OPTEYA
