From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v1 13/22] RDMA/hns: Remove empty functions
Date: Fri, 18 Aug 2017 18:40:45 +0300
Message-ID: <20170818154045.GL23648@mtr-leonro.local>
References: <20170813101816.3120-1-leon@kernel.org>
 <20170813101816.3120-14-leon@kernel.org>
 <CA+sbYW2ZJj2SdchU8M4dZz-KOGSxw2EPX-9oGJhMf3LSzMtA2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QxN5xOWGsmh5a4wb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW2ZJj2SdchU8M4dZz-KOGSxw2EPX-9oGJhMf3LSzMtA2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--QxN5xOWGsmh5a4wb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 18, 2017 at 03:16:12PM +0530, Selvin Xavier wrote:
>  Removing the "modify_port" hook is causing some issues with ib_cm module.
> While adding a mad agent for the new device, ib_cm invokes
> ib_modify_port  which fails
> with return value -ENOSYS. So the mad agent gets unregistered. This
> break the connection
> establishment. It is broken for bnxt_re also.
>
> The following patch helps. But it is like a workaround to solve the problem.
>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index d5ca101..59911dd 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -4189,7 +4189,7 @@ static void cm_add_one(struct ib_device *ib_device)
>                         goto error2;
>
>                 ret = ib_modify_port(ib_device, i, 0, &port_modify);
> -               if (ret)
> +               if (ret && ret != -ENOSYS)
>                         goto error3;
>
>                 count++;
>
> Or should we have the modify_port hook with some basic checks?

I think that your proposal is right thing to do. The driver should
properly return the status of its callbacks (-ENOSYS) and it is
responsibility of the caller to decide what to do in such case.

The dummy function (return 0) hides the fact that modify_port do
nothing and it can be wrong for some callers.

Thanks

--QxN5xOWGsmh5a4wb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmXCnwACgkQ5GN7iDZy
WKdP7xAAp2m+spaPiABsTpLyg8f1Xv2KS7Ui89Crh7SBmNchP3Dw4dkw48fi8vXe
W76GUQB/euyQRUiX+J5xqb/EuE7QsXRsnTaRvBM57acfy49BHmdezOGRcb9+uM/r
d9Wh9+3/KMi7TzTia3TR2r/2YMAFse/SkC/LEh37B5FNnE/KqirOpjOb42Q9jP7s
on8bt+aJtVdZDZW+aTun/J1ihJPrgeUt60g9RC25VuF++ITWfFxJ8zF3q/CPH4q+
AcYTEMp71KvMpu/12t+KlN+7liJlZagwp+lG3lCDrrQ4mS2BxC4vZvvdO3gyrM5+
+sEXSzbQn1LudmOZvJU9kIIKPqkWLyQ4IyqRJoFfmv5xvYKTh9LvptV332TCXjD7
ums4XOiZ14OabkHJdVFgmaXOT0Cf+FB3ilYoq1iqPUo4outqHbt2IaMkHvhm1ZQF
S51eW3RZz0Zw94SwDtIP+u2leW0/XqiHVGwR/xeod48raBkO6+Drzw2OcNGp0jTE
5VyVjdhgPLDoC1qUOXooTkffgJLqkgW8iIIGO8NT9L0WoseapBI698OFtl4EJeVq
i2+CV2ASzYe4E2bKQ0GsVSz82Na6QWtVlFmR/YeXRD3hB9kUOVoPAKK/yLLSvVU5
/Kxaq0ICOLjknuP3APw3sQsqxyBxZPqc7fAyyhTYmHieP3bCm0c=
=cuI9
-----END PGP SIGNATURE-----

--QxN5xOWGsmh5a4wb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
