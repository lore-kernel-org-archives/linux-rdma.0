From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] verbs: fix compilation error with ICC
Date: Wed, 4 Oct 2017 20:11:29 +0300
Message-ID: <20171004171129.GG25829@mtr-leonro.local>
References: <1506434711-3828-1-git-send-email-nelio.laranjeiro@6wind.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JkW1gnuWHDypiMFO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506434711-3828-1-git-send-email-nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--JkW1gnuWHDypiMFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 04:05:11PM +0200, Nelio Laranjeiro wrote:
> Compiling a program including verbs.h with ICC fails with the following
> error (seen with DPDK):
>
>  /root/development/rdma-core/build/include/infiniband/verbs.h(84):
>  warning #61: integer operation result is out of range
>    static void *__VERBS_ABI_IS_EXTENDED = ((uint8_t *) NULL) - 1;
>
> Fixes: 6be16586e081 ("Infrastructure to support verbs extensions")
> Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
>
> Signed-off-by: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
> Acked-by: Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
> ---
>  libibverbs/verbs.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
> index 8cdf8ab..cc633a1 100644
> --- a/libibverbs/verbs.h
> +++ b/libibverbs/verbs.h
> @@ -42,6 +42,7 @@
>  #include <errno.h>
>  #include <string.h>
>  #include <linux/types.h>
> +#include <stdint.h>
>
>  #ifdef __cplusplus
>  #  define BEGIN_C_DECLS extern "C" {
> @@ -81,7 +82,7 @@ union ibv_gid {
>
>  #define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))
>
> -static void *__VERBS_ABI_IS_EXTENDED = ((uint8_t *) NULL) - 1;
> +static void *__VERBS_ABI_IS_EXTENDED = (void *)UINTPTR_MAX;
>

Nelio,

I applied the patch, but it broke C++ users of the rdma-core.
UINTPTR_MAX is declared in <cstdint> for C++ and not in stdint.h [1].

Please provide fix or we will be required to revert it prior next
release.

Thanks

[1] http://en.cppreference.com/w/cpp/header/cstdint


>  enum ibv_node_type {
>  	IBV_NODE_UNKNOWN	= -1,
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--JkW1gnuWHDypiMFO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnVFkAACgkQ5GN7iDZy
WKfUUw/+PdVX5i5hdS5wCBHrLvlwi8ux2XoJsVEtTFk+ZFF3P7FSaK+hIvfkbMF8
2bG07E2eDtMoxccxAMO7STrFFoDSCPbZSl0AB29Frl9HSFGv0jbcDAtzEFFhXhsr
WkhICGSLros9eLInZR9lhEu/WGhm5MKLarCKEUM6B28ZZIWbsAvbYHhSWcsXYmL/
jwDpUKeV5qtYewTaYRMLiMv+58Iu2rpzq8SkKTNEnPs91p20lQY9ALCMzn0UUvlN
f9m7Y0TNedU2TXViVJClXad7IJRfQLdAmL9320P17W9msMqJiK5I2x0reQAlmqG+
K/ThKhagpmv4hmc34UNBJe9IkT5IxCfnN3dcs5X6jdLV2Eopa2192r196ZHrtWCk
7iWYVr1DFMbyuUwBKbn9FwzAdf9nRBD44AIADrr7yab2SNN80W3Yw9wbl6qu/tju
ctdZ87FZ4g3eQIDranOU9fADx2o8d6zon2BDQPOvkOzQ5fUg5MYS9Jjjw/dd0DrL
DosX6ZccukWOS1rD65F0/2uqH2CnzCsTFMcKCOtQaEKRzkuUPW8sXe+3Orlx7rux
xqvQUU8+Vh9KORt5sUv15pNJ8egHnnYbTfEQZszUMPB3RWbtwlNGPygsY2UKkd9l
hFzMAYvnOOTAcLC6Z0omU6qgwHEabvGbdNG27Wj3JMcs/b63f2U=
=hLjV
-----END PGP SIGNATURE-----

--JkW1gnuWHDypiMFO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
