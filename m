From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 rdma-core 0/7] libhns: userspace library for hns
Date: Thu, 10 Nov 2016 18:15:50 +0200
Message-ID: <20161110161550.GD28957@leon.nu>
References: <1478781977-116803-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478781977-116803-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 10, 2016 at 08:46:10PM +0800, Lijun Ou wrote:
> This patch series introduces userspace library for hns RoCE driver.
>
> changes v2 -> v3:
> 1. Fix the code style, for example, if (addr == NULL)
> 2. Fix the bug for hns_roce_u_reg_mr
>
> changes v1 -> v2:
> 1. Delete the min() definition and instead of ccan header
> 2. Delete the CHECK_C_SOURCE_COMPILES
> 3. sort the c file in rdma_provider()
> 4. Delete the unused code in hns_roce_u_db.h
>
> Lijun Ou (7):
>   libhns: Add initial main frame
>   libhns: Add verbs of querying device and querying port
>   libhns: Add verbs of pd and mr support
>   libhns: Add verbs of cq support
>   libhns: Add verbs of qp support
>   libhns: Add verbs of post_send and post_recv support
>   libhns: Add consolidated repo for userspace library of hns

Hi Lijun,

I tried to take your patch set, but it fails to pass our Travis CI
tests.

https://github.com/linux-rdma/rdma-core/pull/38
https://travis-ci.org/linux-rdma/rdma-core/builds/174815897

You need to fix it prior to our acceptance.

Thanks


>
>  CMakeLists.txt                   |   1 +
>  MAINTAINERS                      |   6 +
>  README.md                        |   1 +
>  providers/hns/CMakeLists.txt     |   6 +
>  providers/hns/hns_roce_u.c       | 228 +++++++++++
>  providers/hns/hns_roce_u.h       | 255 ++++++++++++
>  providers/hns/hns_roce_u_abi.h   |  69 ++++
>  providers/hns/hns_roce_u_buf.c   |  61 +++
>  providers/hns/hns_roce_u_db.h    |  54 +++
>  providers/hns/hns_roce_u_hw_v1.c | 839 +++++++++++++++++++++++++++++++++++++++
>  providers/hns/hns_roce_u_hw_v1.h | 242 +++++++++++
>  providers/hns/hns_roce_u_verbs.c | 525 ++++++++++++++++++++++++
>  12 files changed, 2287 insertions(+)
>  create mode 100644 providers/hns/CMakeLists.txt
>  create mode 100644 providers/hns/hns_roce_u.c
>  create mode 100644 providers/hns/hns_roce_u.h
>  create mode 100644 providers/hns/hns_roce_u_abi.h
>  create mode 100644 providers/hns/hns_roce_u_buf.c
>  create mode 100644 providers/hns/hns_roce_u_db.h
>  create mode 100644 providers/hns/hns_roce_u_hw_v1.c
>  create mode 100644 providers/hns/hns_roce_u_hw_v1.h
>  create mode 100644 providers/hns/hns_roce_u_verbs.c
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJJ02AAoJEORje4g2clinbFoQAJx90SF59bIPq/Bl5EzZ57Y4
3U75IkbAtOP0nFmxYnWgyuxogSbvQFJUVMSE34SGlLojhZHGXuoWjB4e6epSM4L2
DIPJghnoRvVE1rwYVEfV832C4zx57xqApqI9OtPKxE1gzIInnGOGgBFHE+AaL+vF
u3eM9maP77uYFtWi84z14tTu2oBMgtkmDw83cPMQDh0oT4g6opIbgMh2/Y0PZBlt
D1IBEK6lXUnVIEEMiScDLHy4kdcOPhSkT3UlQuruvGBD4PbnK8Xbwe+9LiyEi3Cy
qOOESVLcgJnQLPvazq5WXiZsyxGwY5iNk7H+Ftvdg7eHJYnAK/oUPcRFQnaPRttQ
h6x1L56ipjcHNis0cSW+4jnpyB2zTOEdp93SV6OLBWb5tUxt8hMZ0HvKbatpgotL
3/gI3nWQggFXXTfBOZ5qH5tFx9WQ68jSsZushOhOqI6FJTszNHgPPUg9EoxC3wLI
a44vywPBrAlfpCLwOY4wE7NjIoKWYbZg+7UL9sRl7YBv6yinxJhCY4JUGAjqOsCD
v2QVWZWNtgmBznZS1OwxjR+GyK0P5rEKAmBD+70oW2e2+hTJcaK1vLIH4zh5hgAx
I4R/8q9dlDA53R2af+XHUdIfABxvvsCPjO7G8KwfDNrz/9e0A0dsKJyHQRU/ldIA
NpiBv9eC/H2Waye6yfZp
=f+cE
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
