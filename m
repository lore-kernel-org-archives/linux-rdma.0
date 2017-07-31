From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [rdma-rc 13/14] RDMA/mthca: Make explicit conversion to 64bit
 value
Date: Mon, 31 Jul 2017 17:11:24 +0000
Message-ID: <1501521083.2466.20.camel@wdc.com>
References: <20170731070924.7193-1-leon@kernel.org>
         <20170731070924.7193-14-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-14-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <CAE18F6478A8DC46869C01096D40808B-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-31 at 10:09 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The "lg" variable is declared as int so in all places where
> this variable is used as a shift operand, the output will be
> int too.
>=20
> This produces the following smatch warning:
> drivers/infiniband/hw/mthca/mthca_cmd.c:701 mthca_map_cmd() warn:
> 	should '1 << lg' be a 64 bit type?
>=20
> Simple declaration of "1" to be "1ULL" will fix the issue.
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mthca/mthca_cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband=
/hw/mthca/mthca_cmd.c
> index 9d83a53c0c67..1052c35f2e75 100644
> --- a/drivers/infiniband/hw/mthca/mthca_cmd.c
> +++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
> @@ -698,7 +698,7 @@ static int mthca_map_cmd(struct mthca_dev *dev, u16 o=
p, struct mthca_icm *icm,
>  		for (i =3D 0; i < mthca_icm_size(&iter) >> lg; ++i) {
>  			if (virt !=3D -1) {
>  				pages[nent * 2] =3D cpu_to_be64(virt);
> -				virt +=3D 1 << lg;
> +				virt +=3D 1ULL << lg;
>  			}
> =20
>  			pages[nent * 2 + 1] =3D

Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
