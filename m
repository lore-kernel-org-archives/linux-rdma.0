From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Mon, 15 May 2017 21:55:57 +0300
Message-ID: <20170515185557.GN3616@mtr-leonro.local>
References: <20170515145203.10708.16921.stgit@klimt.1015granger.net>
 <20170515145757.GI3616@mtr-leonro.local>
 <02AFF424-A387-47F7-BD24-61C7734B9008@oracle.com>
 <20170515170021.GJ3616@mtr-leonro.local>
 <AE3152CC-B7C8-4C51-ADDE-C3822533BB94@oracle.com>
 <20170515174646.GC6229@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m1G908gh+QHqN0Gd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170515174646.GC6229-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--m1G908gh+QHqN0Gd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 11:46:46AM -0600, Jason Gunthorpe wrote:
> On Mon, May 15, 2017 at 01:22:59PM -0400, Chuck Lever wrote:
>
> > I find the feature useful. But it is correct to say that such
> > development knobs are often left to kernel compile-time, as
> > it is not especially useful to end users.
>
> Put it in debugfs?

Why bother? In good year, we will have one new user of this RW API who
will need that knob during development phase.

>
> Jason

--m1G908gh+QHqN0Gd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkZ+b0ACgkQ5GN7iDZy
WKcx2Q//RhpM/QtaYyvwiXOHmKIb2+r069luJPaQRV3MoHSvjdUtT3FUqnbQqg1C
w+yxMRQATj/12RNH2Jk2kTaxMIqILtxDSlVPn0/5jacSwuIPSkPQNlTIGOuPGWba
/y7nXIXVtvVvs+7XW03c3pwYVir37kS4hD+UWJPAyzb+QYd09oARJBbfYsDO6wHe
DnHF0RpnFpkypB9LqPD3uxn4h2EbchQHsxTt1fMD6qyQ/Eaac7pC/SVpimopnZv5
PjfAvTQNCgFdgrXhfaYcnhDKEXkuQlhXppWFuR3rMZRVFWJbefSLuAZnle60yvku
VEuEZ3gcyeKmCb5aJt+mwW0BA49n8nrsSVv/xlFQBSrHBlaAq9St3YGS75g+xv5q
w9/3sQuC66FyZsIppZ6o2l/Nl9SxyQxW0NnFaUAkPkgGcu2ZzOfF3b9QxS6Qr3gH
O6Xkc3AXOiVqCFA++AiwT7UooJULeDyj5Xi+KtbBq5xjdxXPrTwLLVlWzIbMZFp+
lDJB6joWuTTX4IkxfA0T3p/xoKBa48Wf55e9ABycwDuzqWYOal4nWkgLBpzOGMGh
O6SlazMq/MlDzayc7d0QUJyKJUMcHq7CRmbTwTMB3lwRtESU6u3hIGTMNwdGlCEy
YfEQwyyyhXV6TbLStIYyMm26BFbebQZqoPQOBVMZ6aokq2xpooc=
=0Vg/
-----END PGP SIGNATURE-----

--m1G908gh+QHqN0Gd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
