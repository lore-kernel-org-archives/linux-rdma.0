From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix a parameter of find_first_bit
Date: Fri, 26 Aug 2016 09:52:40 +0000
Message-ID: <97F399F1-3A57-494E-916B-EB6EC446B6F2@mellanox.com>
References: <1472188577-14550-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472188577-14550-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> On Aug 26, 2016, at 8:25 AM, Christophe JAILLET <christophe.jaillet@wanad=
oo.fr> wrote:
>=20
> The 2nd parameter of 'find_first_bit' is the number of bits to search.
> In this case, we are passing 'sizeof(tmp)' which is likely to be 4 or 8
> because 'tmp' is an 'unsigned long'.
>=20
> It is likely that the number of bits of 'tmp' was expected here. So use
> BITS_PER_LONG instead.
>=20
> It has been spotted by the following coccinelle script:
> @@
> expression ret, x;
>=20
> @@
> *  ret =3D \(find_first_bit \| find_first_zero_bit\) (x, sizeof(...));
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
> ---
> __ffs could be used to reduce code verbosity
> ---
> drivers/infiniband/hw/mlx5/mem.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx=
5/mem.c
> index 40df2cca0609..996b54e366b0 100644
> --- a/drivers/infiniband/hw/mlx5/mem.c
> +++ b/drivers/infiniband/hw/mlx5/mem.c
> @@ -71,7 +71,7 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,=
 int *count, int *shift,
>=20
>    addr =3D addr >> page_shift;
>    tmp =3D (unsigned long)addr;
> -    m =3D find_first_bit(&tmp, sizeof(tmp));
> +    m =3D find_first_bit(&tmp, BITS_PER_LONG);
>    skip =3D 1 << m;
>    mask =3D skip - 1;
>    i =3D 0;
> @@ -81,7 +81,7 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,=
 int *count, int *shift,
>        for (k =3D 0; k < len; k++) {
>            if (!(i & mask)) {
>                tmp =3D (unsigned long)pfn;
> -                m =3D min_t(unsigned long, m, find_first_bit(&tmp, sizeo=
f(tmp)));
> +                m =3D min_t(unsigned long, m, find_first_bit(&tmp, BITS_=
PER_LONG));
>                skip =3D 1 << m;
>                mask =3D skip - 1;
>                base =3D pfn;
> @@ -89,7 +89,7 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,=
 int *count, int *shift,
>            } else {
>                if (base + p !=3D pfn) {
>                    tmp =3D (unsigned long)p;
> -                    m =3D find_first_bit(&tmp, sizeof(tmp));
> +                    m =3D find_first_bit(&tmp, BITS_PER_LONG);
>                    skip =3D 1 << m;
>                    mask =3D skip - 1;
>                    base =3D pfn;
> --=20
> 2.7.4
>=20
>=20
> ---
> L'absence de virus dans ce courrier =E9lectronique a =E9t=E9 v=E9rifi=E9e=
 par le logiciel antivirus Avast.
> https://www.avast.com/antivirus
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
