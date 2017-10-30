From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] vmw_pvrdma: Add SRQ support
Date: Mon, 30 Oct 2017 08:07:54 +0200
Message-ID: <20171030060754.GT16127@mtr-leonro.local>
References: <20171029224429.GA21993@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kPvmKZRaHW6UEX9w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171029224429.GA21993-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--kPvmKZRaHW6UEX9w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 29, 2017 at 03:44:46PM -0700, Bryan Tan wrote:
> Enable userlevel applications to use SRQs.
>
> Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Nitish Bhat <bnitish-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  buildlib/fixup-include/rdma-vmw_pvrdma-abi.h |   4 +
>  providers/vmw_pvrdma/pvrdma-abi-fix.h        |  10 +
>  providers/vmw_pvrdma/pvrdma.h                |  41 ++++
>  providers/vmw_pvrdma/pvrdma_main.c           |   6 +
>  providers/vmw_pvrdma/pvrdma_ring.h           |   1 -
>  providers/vmw_pvrdma/qp.c                    | 319 +++++++++++++++++++++++----
>  6 files changed, 333 insertions(+), 48 deletions(-)
>

Once kernel will be accepted, we will merge it.

Thanks

--kPvmKZRaHW6UEX9w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln2wboACgkQ5GN7iDZy
WKco6RAAnxex6m92KcNwCX0rkPYKHrHi93LZfGUfYf7z00w+TWS+mMW/nzpgcPhT
TrHkC57S0h7hkbF9Ag6tKD7gpdUZ9MvA6uBEXwqlWiOi/TDp076jEvMIzEqstT0d
S87xP68k+HQiHRwbTz8ix+wvYabubrm3zNJpSFUQ9b3RSyb38pZ2RACaYA6Dw467
djbJhTlr8iMfgmOJcidGOOAW+jxGgSL4FzpjdE/i4tZJXUQqnQmg64e6R1J19b+E
6+e0RxzWDrJieLzb7iwMoHSIC0aD1OkkfePTEetK99NNBRXhJmMXrJ+Q7CopfF7W
bEbfRFYwT13o7EPthx0Kh6Ti/DOA2id4nyAYVS+RDXmXwVoK0P4PmsCFdgRQHOPo
61G+SCJBdL2GlEKMsydC9nXibg/X1LHzC7DdGYIbmveJ1P0mdcNqojRShbkob/U9
HDwELBKAeW9l5oH2IrbL7kz5EDuFv1vsv0irwH9lTA+dBYyyBQcgpBNf3x0z++7A
OKGeWz/xTzib1kWA//jXkVxx51zG3t0X5RQliADotLG2wFHR4lfAWpeqQ9YfI/0N
FqRIAv8LODJU2SnfNxJ2/lopHExuMuf+hocuQClBZ6MJ6aoqn8DWr40hwowWEMMV
f7TTl0S1h4BqmaTHWxeJenNqyeyU8ERiI8iVHPEbTo9ZT8NVyZM=
=dpga
-----END PGP SIGNATURE-----

--kPvmKZRaHW6UEX9w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
