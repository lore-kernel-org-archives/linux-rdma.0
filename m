From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: fix test of unsigned variable
Date: Mon, 11 May 2015 14:46:05 +0200
Message-ID: <1431348365.25060.31.camel@opteya.com>
References: <20150511121315.21044.78464.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511121315.21044.78464.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 11 mai 2015 =C3=A0 08:13 -0400, Mike Marciniszyn a =C3=A9crit =
:
> Commit d4988623cc60 ("IB/qib: use arch_phys_wc_add()")
> adjusted mtrr inititialization to use the new interface.
>=20
> Unfortunately, the new interface returns a signed
> value and the patch tested the unsigned wc_cookie.
>=20
> Fix the issue by using 'ret' and only assigning
> wc_cookie from ret when ret >=3D 0.   Additionally, insure
> ret is 0 on success.
>=20
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Cc: Luis R. Rodriguez <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Cc: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>

> ---
>  drivers/infiniband/hw/qib/qib_wc_x86_64.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infi=
niband/hw/qib/qib_wc_x86_64.c
> index 6d61ef9..85525be 100644
> --- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> +++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> @@ -116,9 +116,11 @@ int qib_enable_wc(struct qib_devdata *dd)
>  	}
> =20
>  	if (!ret) {
> -		dd->wc_cookie =3D arch_phys_wc_add(pioaddr, piolen);
> -		if (dd->wc_cookie < 0)
> -			ret =3D -EINVAL;
> +		ret =3D arch_phys_wc_add(pioaddr, piolen);
> +		if (ret >=3D 0) {
> +			dd->wc_cookie =3D ret;
> +			ret =3D 0;
> +		}
>  	}
> =20
>  	return ret;
>=20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
