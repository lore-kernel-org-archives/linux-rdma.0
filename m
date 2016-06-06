From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Remove unused DMA attributes
Date: Mon, 6 Jun 2016 19:28:14 -0400
Message-ID: <d533cca2-94e1-182a-4ea7-06e02f68104b@redhat.com>
References: <1464860701-11376-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gQr06Oh1kLItHs7BmVvgTUOKMv6wbpvSe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464860701-11376-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gQr06Oh1kLItHs7BmVvgTUOKMv6wbpvSe
Content-Type: multipart/mixed; boundary="HP36B5Iwi1Sn3Of7hpbtdtROP0h1pL95I"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
 Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>,
 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock
 <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Message-ID: <d533cca2-94e1-182a-4ea7-06e02f68104b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Remove unused DMA attributes
References: <1464860701-11376-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <1464860701-11376-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

--HP36B5Iwi1Sn3Of7hpbtdtROP0h1pL95I
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/2/2016 5:45 AM, Krzysztof Kozlowski wrote:
> The DMA attributes are set but never used.
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_uiom.c | 5 -----
>  1 file changed, 5 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infinib=
and/hw/usnic/usnic_uiom.c
> index 7209fbc03ccb..a0b6ebee4d8a 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -36,7 +36,6 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/sched.h>
>  #include <linux/hugetlb.h>
> -#include <linux/dma-attrs.h>
>  #include <linux/iommu.h>
>  #include <linux/workqueue.h>
>  #include <linux/list.h>
> @@ -112,10 +111,6 @@ static int usnic_uiom_get_pages(unsigned long addr=
, size_t size, int writable,
>  	int i;
>  	int flags;
>  	dma_addr_t pa;
> -	DEFINE_DMA_ATTRS(attrs);
> -
> -	if (dmasync)
> -		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
> =20
>  	if (!can_do_mlock())
>  		return -EPERM;
>=20

Thanks, applied.


--HP36B5Iwi1Sn3Of7hpbtdtROP0h1pL95I--

--gQr06Oh1kLItHs7BmVvgTUOKMv6wbpvSe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVgcOAAoJELgmozMOVy/d3YQP/RnzAKiXwk37qcaBEB6IgCN5
CewTpvhS3lYXMTlbxSKP13olV4vIMXXzsG4276oZZej+xkC/VxKfL0QbLElbSNH9
f2C9lGKZnOWKGeOvmUkY7Jrih84HpXdrsjH3wfQLqxN1Dimp0CwTNK9e/qYtuLcv
NJeQnf1BIQuHfk0fhU74s+uAFlg6G8LeD+H0Zitgi+AazvNDfUKGg+gBT0NCkB7g
zW2IG1oa7Of0UVX1V658N2MrQLwaN8z9orQKDkR3JJXvWoLWF8Yrcvjh8ilkEBjO
7lAvMz1dXwIh/499YEGgO0rIWIFDZQHuOlb5vN4f93tXXQN5JH7FnSxSnsuNh3c7
tR9hqzsBIUFAa+03FNJKc33LdaeGOuUIAXKFwhUWoMZevzKlHdfyPtwY76a3+sBJ
mHgfBV9TDXM3IyawjQhlUlaKjwlsGQPMBZRwnRWG6DsThbpmyisCyeYAWYNSVGN5
rWA9x+872QmQi6LzOr3byJfBqOC+dmAYwO/N/tF7aja13gAfdwNU0aCqQzPjBDoz
Pcbsrzv3y7JGdpPs6/F5+JZi1aG5/C9lNlhThR2LFb1k5I20OjcpXEm/hxWYNzwj
cIuvp8djtWRuFm+v5LyCrA2nlMGIBktMRPf0BF6ZYQiHjiREI6A7Ga5i9f+ltYXZ
bn9btCXlHcFenX+W+Q+Z
=0MJJ
-----END PGP SIGNATURE-----

--gQr06Oh1kLItHs7BmVvgTUOKMv6wbpvSe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
