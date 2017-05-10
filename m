From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] NULL required to terminate attr array
Date: Wed, 10 May 2017 08:35:43 +0300
Message-ID: <20170510053543.GA1839@mtr-leonro.local>
References: <20170509210907.GA29717@oc1783850105.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509210907.GA29717-i3Uw2LK+iw9rGVE3K263K1aTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 09, 2017 at 04:09:07PM -0500, Steven Roberts wrote:
>
> This patch fixes a kernel panic when loading the hfi driver as a dynamic module.Addressing this patch will make performance tweaking the driver as a loadable mdule possible.
>
> Signed-off-by: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sys
> index 50d140d..2f3bbca 100644
> --- a/drivers/infiniband/hw/hfi1/sysfs.c
> +++ b/drivers/infiniband/hw/hfi1/sysfs.c
> @@ -196,7 +196,8 @@ static ssize_t cc_attr_store(struct kobject *kobj, struct at
>  };
>
>  static struct attribute *port_cc_default_attributes[] = {
> -       &cc_prescan_attr.attr
> +       &cc_prescan_attr.attr,
> +       NULL
>  };
>
>  static struct kobj_type port_cc_ktype = {

How did you prepare the patch? Please use git format-patch, add
"IB/hfi1: " right after "[PATCH]" to limit the scope, add diffstat to
the patch and, run checkpathch.pl on it.

Thanks

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkSpq8ACgkQ5GN7iDZy
WKe5KA/+KpvJkzxUHh8HiTmAI6tHAPlphOpiteKiqNj35BUdzC2o7yr0CAGTZWTE
VZ3s3GAj92ELKejSGjeeERlRfVcw/FgfTOtFE3UYg1hy4gvxZ4QxhhzChm8nW5Cm
nfbUDmiev3DOq+QHeltbnhXiVn85JHoDHQ3jDPl13OtCrEWDbdVysZNpK+wybHcS
pY/ehMk6r+qpd14LCy5+yWdxJ8mcrruFZW0MKhPi9lsB8kErcTvXZjHfoDQW+3nC
XoIdzx6Wk2ocxwmhjN5kr84HDcad1NgUj1N5U3wQoKjEo4uIyYspLOXY08rm9WqN
7qKHnnFBOEPIscjfKksFVUiPP+Sb9Evj4NzrIv0w884oEJlzQybThrG4Si+beqIE
5ipB8G/r/oangRXWDt69wLVUHWUVHRwRxcFXD3+CF55+GVKSjXOiCyP/FX4oPjBF
OpFFuglHwfGozwMovUyjSuasaV9I9Un5q2C2WiDEAqEVMMLd2UxRZ57eeXWRLe7K
h8gf3E2V+oVqWuntfnqz9gcoEp6d+CJm0NVQUbk4EjyFZtjmbgZcEdo770HebUGM
Jz5vG1inq7RlQ6mh6yEQBucj5I9k5Z+O44qiZiPEcQltxb9KUHMbMd7k9WD/jpID
WavrZ1764zuog+Q12Zcm23sRoLIB3BROwsMbEnz0LYwM29xSoB4=
=uEwk
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
