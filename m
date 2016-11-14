From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 rdma-core 0/7] libhns: userspace library for hns
Date: Mon, 14 Nov 2016 07:53:03 +0200
Message-ID: <20161114055303.GA4240@leon.nu>
References: <1479033360-56035-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479033360-56035-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 13, 2016 at 06:35:53PM +0800, Lijun Ou wrote:
> This patch series introduces userspace library for hns RoCE driver.
>
> changes v4 -> v5:
> 1. elminate the warning when CFLAGS equal to -m32
>
> changes v3 -> v4:
> 1. eliminate the warning by Travis CI testing
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


Thanks, applied.
https://github.com/linux-rdma/rdma-core/pull/38

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYKVE/AAoJEORje4g2clin3eoP/RslRMom/Q8DvogvIEyZVhY5
yoSZ7/8lIilYyMd6kJvkLQS7oSvmwWiQvSwmLdj1hj6x4hMDKl6WZAwPJTSc0IC+
GZrIz5fhneFJFOvXVP6ZI362NYdQkffBR0Mt454dJprCneWnlmD6xJrZLXoQHcx5
Ut5P5lTIaNX3tSsP6uxlD3xgAqYnrIwiFNaai/DSUzqmytYoWZJnqh6v2wHDpBag
kjXJeA+ZEXrcCVMW7m3rIjBH6Tm9xEobQyQkTITBZZ/Wxt+TiZKtBkdY1AKbdtL8
jAKzGnLTaXGupEAeO7NQstNHV2p9SXTS96OQWN989REjkBwrGqFqiFeeBaCPs+s2
ELh909conLVZHoljlN49Pi5Sj3+HvleiJCk1+4hVfnhxtqJMr2z/yzWumIDsccE4
yj6TKIwn9XZk/Kabthy3uNuFfvXV4cqqAeymeEQ6tqjwuDpBEO006v3mH3GUiZx5
MU0SoTh4KURfF+uTLTSr2fZTmEQ+Ue/Pi2QgNA2AThIM23QHKkpyxa/xsowwvZ9G
eD5YgnhHnNPnam0pWQvOqj1B96L5gA3116qHi4J8fh2EpFXmHgVPAGGtMdElJPZ7
kC9OcuRLafzXpptFckjYhJUG0r+Z5+7ybR3E6ir7p6rxjLJwcBy1fZ37dp16uwBE
dpzU2OUBIYnIyfvAsaDq
=tfZY
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
