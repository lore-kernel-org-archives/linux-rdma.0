From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB: Update references to libibverbs
Date: Sun, 4 Feb 2018 11:11:48 +0200
Message-ID: <20180204091148.GE27780@mtr-leonro.local>
References: <20180202213529.GA28581@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180202213529.GA28581-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 02, 2018 at 02:35:29PM -0700, Jason Gunthorpe wrote:
> These days the userspace comes from rdma-core, revise references
> in the kernel to point to the current repository.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  Documentation/infiniband/user_verbs.txt | 2 +-
>  MAINTAINERS                             | 2 +-
>  drivers/infiniband/Kconfig              | 5 +++--
>  3 files changed, 5 insertions(+), 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp2zlQACgkQ5GN7iDZy
WKdwWQ//W+dUI+nBGzWYqZZA0TWYcPQxvwr/IOuoGggl226S9kNhP+0Lrq8QoWC5
RzRsJgJzII+44B9MMYfuvHNzEFSXWjqy1lj/T2BuhoA8sJIkGB0y8gXbELISeFyJ
5vhvkdDFchUdJvD+F8qW4WnvNrxq0QjwtCNExq/bq18kGtgPCEjpCaoFdD5lRMLT
5wSuIc6ErVZEvXJLnf2rDaSutal2bVOhCEwbcUud0ej3zKGEYuSna4E0/7VmDkZZ
IuPIUhSnD9g4ozrpYJoqAgOV58W2n8+hk6wwG3mipxmUsdOt50RfQ3JKmVPaZMqD
vWDOd/HLvV/ZFNCDeSncuX+32sS9qFNVpja48w/6bHd6ahCbjmDJNMfuNMJSQ5qj
K9sD99s/FVHIytx/xw2aPNNiXdYDSfjxyHX4Ff2EXr7MHC8J63FVisczs9+sme8+
864/t6zeXKOqPT0+ey7qAJh94WSdfsUMNDfjDhnXeSeoCaONDWyiFYD74tth9H0X
JtHPAPz6uW6C64U4PomrpnSWHq/Z1VzRJrO4Lq5UHk1pyIix3lZnc7/ByALKu+B7
z74wrv/yKz2VREtwhoTyrTfSrYhHqTGevnDZNJoSlIFfYogT0ASewtHuYrD77jbP
Q1qLZxs8BmnSdeDcui34elzckfKit+A9TruddHoNICnDzVlXsh4=
=tXlq
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
