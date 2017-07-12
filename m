From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: This merge window...
Date: Wed, 12 Jul 2017 20:10:44 +0300
Message-ID: <20170712171044.GE1528@mtr-leonro.local>
References: <824b3771-78a6-7c80-50d9-a34383169185@redhat.com>
 <CAJ3xEMh-YcUgydmc96UumX3cfgr7P+0rRenOvBe_6m_bo+K3mg@mail.gmail.com>
 <1499875106.2924.26.camel@redhat.com>
 <20170712160432.GA24552@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v+ytF4ERyld7fWQH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170712160432.GA24552-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--v+ytF4ERyld7fWQH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 12, 2017 at 09:04:32AM -0700, Christoph Hellwig wrote:
> Can we make sure the tree is simply always in pullable state for the
> future?  That's what I do for my (not too important) trees, and that's
> the state of many other major trees.    At least past -rc4 or so.

It will be awesome and it will minimize chances that -rc1 is broken,
which we had in last cycles.

It works extremely well for rdma-core and I don't see any reason why it
wouldn't work for rdma tree in kernel.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--v+ytF4ERyld7fWQH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllmWBQACgkQ5GN7iDZy
WKeNuA/9FRUpjZORZ2o9QjFyLLwHmHb1LZ+AAkjQJy9MvDUe/gC2BbawWaN3yaPk
leWGQWbA7qPY7+YGin5zuBjTLUVdFh/zo+bYK0G8gtp5nQriG5Fs10sUHF8Vj91T
O0LmQrydw7bumzNVhNUBZlACR7TlKph0LcG62hKZTBawWMDK0WuyVWhYOshWUWNx
hrCxqH2tdLzgueMK69NVaFLYVmnCo/H/n3+LTQH/uwKO6Q9pUI8FED77uBfcb4wA
SZKle58UOu10P1THqQMFgb+uojHF4rWFyJDPaDB9qXkVnxN8XkqeC14NB9pVZxSw
2s/ZrmSBKEJwFvOQJUQnRkuD+xqvKeSVJWWpwJ7wBAw+EbIQjVOVtuhuqWjvOlEi
pJd2Rcn2SUtznuBw2w1chm5tFJDfeSQCKJnJ0BFdEW6I/8L/IE2Cq6bBqJowu0Lt
AuzCTg7osl2djosTWHUvEzi2jis6IuBK59BmgA09lkH+bOunggj8VEhNmggfzfhy
6VPxPohguhZtTpTO3cWmnMZf63gnunKp0QSEOoBLIP3fw9791TJkv/ruFMDVgXnY
NgR2d2cdDGqx5TEgMTg7epa+PQIhNtLaO83wHzOuX/+J4aVtDTfEqjyVJ1IapPZp
pIXYAUIm0LBdcJ1INcYJq3gaQdeCUhpv+DvATgFtVz5huWpYtI4=
=txAD
-----END PGP SIGNATURE-----

--v+ytF4ERyld7fWQH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
