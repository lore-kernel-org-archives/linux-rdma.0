From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core] libhns: Add rereg mr interface in userspace
Date: Sun, 26 Nov 2017 15:11:16 +0200
Message-ID: <20171126131116.GI29104@mtr-leonro.local>
References: <1511579396-43112-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511579396-43112-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 25, 2017 at 11:09:56AM +0800, Lijun Ou wrote:
> This patch adds the rereg mr verbs in userspace.
>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> Change from V1:
> 1. Remove the if statement
> ---
>  providers/hns/hns_roce_u.c       |  1 +
>  providers/hns/hns_roce_u.h       |  2 ++
>  providers/hns/hns_roce_u_verbs.c | 11 +++++++++++
>  3 files changed, 14 insertions(+)
>

Thanks, pending successful Travis CI check.
https://github.com/linux-rdma/rdma-core/pull/266

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloavXMACgkQ5GN7iDZy
WKdkFg//eTJNQfWqGQxojI+5fLhlau9mAiap/C2LG0UxyfIj3DqnkgsfLRMovQNN
nCR/ZxsrC+OM3pMEPB9D1acpuBkiYDLF/VczCZ0tClMGbORCC2QAfP/aA4dWC+ol
tLxXeE9YrKPtTDKw9YyHL2+DHB0ej+zgAb4mrtX3IDSb4cSVkvZQvXfwL1OBM7Yk
xB5khgSEnbJ4yh6yT6ByCBm0Z+aPnoCWX/FTVvOnNxMiEgjuJItqDmnIvniNCrbm
N2GR3q+/mqeNySe42MY721rgk9PcqItl+aCa4wuoXNiiIHcvbGlYq8XU7lKJ/FET
LtPT3qqopIIa/8mz0mp+RpR3f0EPkrqRmwQ5jZqJmm2S0hp8PXQ0Ql1oYa+N8kSl
YWz8WZL3NEQJttw1ihqSomrzYS+m2RG3JGieKrVUABnT1LdvPjzBO+s4GpF6XGEF
w3KIyxJY4vnNppMXmvWVklWx5dzwSag88gLkRk2qSMCncolWdvmQ7DzwOWFS9WAH
zkJ/HQbVyD60NIv/nK0Ai41f31w6oBY1/sP7CQmOpto9Yi1xnGQuvgctl91HuA59
QGLqYwUDrbg/v9H1UIzTSYEX/P3yNj5CFmJJDIRiw9ICw/eGmNCutYmFNLTDwHy8
pWo3ip1UT995Hu+yASGmbOm4txi/JMsYoiNJiVK1NjAZI0TV+XE=
=iGXn
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
