From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libhns: Add rq inline data support for hip08
 RoCE user mode
Date: Wed, 22 Nov 2017 12:04:37 +0200
Message-ID: <20171122100437.GF18825@mtr-leonro.local>
References: <1511183164-197590-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ozl6FSroOtzUD70i"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511183164-197590-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Ozl6FSroOtzUD70i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 20, 2017 at 09:06:04PM +0800, Lijun Ou wrote:
> This patch implements rq inline data feature in hip08
> userspace.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/hns/hns_roce_u.h       | 17 ++++++++++
>  providers/hns/hns_roce_u_hw_v2.c | 70 ++++++++++++++++++++++++++++++++++++++--
>  providers/hns/hns_roce_u_verbs.c | 35 +++++++++++++++++++-
>  3 files changed, 118 insertions(+), 4 deletions(-)
>

Thanks, merged

--Ozl6FSroOtzUD70i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloVS7UACgkQ5GN7iDZy
WKdOzBAApcqfofk6dG5bD50YD5R9oyQgfYN7CzmxyXMj1pfY5MxWiqAmSBjmIl3I
YEOIC0NEXBHu7q530FHYjkZ2zAgxLeUhKD55e8juN8sOzE3PoV8Sl9adZJR2wr5u
P+6AP03n53lDqGf8aibCa9pwTlch2bIuV0/mzj/lj4gwZPNKL/B0y+c8Ihmo6an2
+KExP9I+IKC0mjPq1r9KzknG0Rz6aXKNNPDlljI6KJGmFAie/ozgaGLfbOoyLlEa
Q+fRw5iE12ZlWVh7U5404/yvwnbLoteRVXICOy9G9OG5qKyf/VELGt9Moh6W2NDC
B2fxfRmPyO2AOHKMLjlxyjJQAkFAPr0cORuDtOjm6Sldo42RZe5KEgDyXnjhjRcQ
v8Lfl35hvbsa5IeObYMvPrIGqRYuH4R6C0ULJykYyu6rRt6okjLbsRvyUpcjRT+c
UlMleWeVnYbpoyWxZBXHBKwQEfySlrt3PQHB4XdLZ+tq3ImZcI7PDL03ceSFPTNB
24HO8RxSdOP7JQ0ZAm5WatXTwdhZF2TSXSnYrLaJfKykph7BJdxw7UsXo5v724gC
BObdzqDu3voLbfK9g+UIkfWuR0xbGBP2MKHjgVJTb/dKH7run3PqUYJGLEyWuq6O
57rCwkK4RtACENR8vIEKz71A/0HKr1vHCt/tSbq9mZhVqdCgy9E=
=ws+m
-----END PGP SIGNATURE-----

--Ozl6FSroOtzUD70i--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
