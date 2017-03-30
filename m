From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: next-20170330 build: 2 failures 8 warnings (next-20170330)
Date: Thu, 30 Mar 2017 15:57:50 +0100
Message-ID: <20170330145750.w2yrq3z3bey4el4g@sirena.org.uk>
References: <E1ctZXC-0008DB-4g@optimist>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ru5w525tgyif66gv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E1ctZXC-0008DB-4g@optimist>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kernel-build-reports-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ru5w525tgyif66gv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 30, 2017 at 01:50:39PM +0100, Build bot for Mark Brown wrote:

Today's -next fails to build an arm64 allmodconfig due to:

> 	arm64-allmodconfig
> ../drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1384:15: error: implicit declaration of function 'of_parse_phandle' [-Werror=implicit-function-declaration]
> ../drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1389:22: error: dereferencing pointer to incomplete type 'struct device_node'

The driver uses DT interfaces but does not include linux/of.h, it seems
that some reorganization in the headers has removed an implicit
inclusion introducing the failure.  I sent a fix.

--ru5w525tgyif66gv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAljdHO0ACgkQJNaLcl1U
h9BPjAf9GnQkndIosbvhk6mfwAvEthuBnd9j2x8zwhZ2WL35ZBmnbQgG/RzX6YeN
2Rv9orwkWvMPFHRvSjDqeZ/76UGBlvKQNJXoWnZzl16kkXe1p/lCzx6SISUeDRU4
wZHMJxdgCzrVuEbWtnMWaQeJ6EJW+OuEvT6ytKp2fPkFZWvwgWjStCwbTvX8CSec
66JL/29tknJnf0DkamFC2OuY9zJhmk/d4zwAFlo4x5+TLYkSax2CGTEL7ewbXbXw
45/7yRMy7nmYQMJdeHggITTvuuNr3wkywTVPnTerQpIvFbCCoULqUYymJ/1U6XBp
/iL91YMHeSBgknmY/niMAkqlmykinA==
=RPUe
-----END PGP SIGNATURE-----

--ru5w525tgyif66gv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
