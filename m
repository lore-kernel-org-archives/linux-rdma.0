From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Tue, 28 Nov 2017 08:15:17 +0200
Message-ID: <20171128061517.GO29104@mtr-leonro.local>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
 <20171127183637.GA13966@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="72k7VsmfIboquFwl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171127183637.GA13966-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, xavier_huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--72k7VsmfIboquFwl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 27, 2017 at 11:36:37AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 27, 2017 at 10:41:21AM +0800, Wei Hu (Xavier) wrote:
> > This patch-set introduces three patches to fix about the memory
> > related issues.
>
> If these patches are for-rc can you revise the commit message to more
> clearly explain what the bug is, and supply Fixes lines?
>
> Otherwise these will go to 4.16

Jason,

If you treat all unmarked patches (without mentioning in cover letter or
subject title) as targeted to for-next, it will make your life much more
easier than trying to pick each patch alone. As an outcome, it will make
the patch flow more predictable for us.

Thanks

--72k7VsmfIboquFwl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloc/vUACgkQ5GN7iDZy
WKf5Gw//aZhOccGuSh05JUYZWBkOG52bWy5QHb7mnIzWapDHcgZgsQhXEJ9unlcz
EuN+Lk1IDBM10hAMn3/KmgL02WdeR6mSr5HMNnS6/LXuV/CXXiSzA1wHI80MkhVH
obqd+1eVuwq8C2mfVFPD23IVdC1xQEQgUfgGkUPG28RKRznCnfq+DkqKb1QaLK0n
kteLRYIPiTG52cE7JJ8tvN2DDecgD7zeYKVorp3NTjRXKmumNkp2R4AAYZ+ZlHKF
qFTso23Pk6alPFV2zRVXRg7ZXH7vXnu2ChHh0q/9fMfMuiqRbj9jiWOQZ8kG2gAr
pDyRUXJkpylE8l9EStobeLnoYAxoGL752c2jqF2Hp9ymkxIOp2ONA/lV+Zcjfzdx
lix2OE6MaiDEgpVC8+uD+9SPQ1BG1pBQ3JzwFGIy93cGnDjv5ChdwWNGFJJp6nk9
bdQ6h+rR1ZgdjWVdIoGTlO+7cpmPy4ysNxH625i0w8/aYVaiKHGaXeERcQzwIZiM
BLg7axRJL10ndX2RHntbWnGSsbFa3naYFgwo6KzwRFQ9A6aAS/B09lotmJyZrJVL
WhsoB4nhldscUU5jV/0BjhRr5plJaOf3SJ2uv+oRBECvFE8ngqDpNKyD4BlsS67L
I4Z2zfShSEK7rQwEvTYj4eSo+i9nSfmdRz5nMjUEdeg+tLO6Xyo=
=ZhGJ
-----END PGP SIGNATURE-----

--72k7VsmfIboquFwl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
