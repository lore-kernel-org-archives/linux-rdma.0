From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] IB/hns: Fix return value check in
 hns_roce_get_cfg()
Date: Sun, 7 Aug 2016 08:31:15 +0300
Message-ID: <20160807053115.GQ27667@leon.nu>
References: <1470445284-28970-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwgCY5hL6Igino+O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470445284-28970-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--LwgCY5hL6Igino+O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 06, 2016 at 01:01:24AM +0000, Wei Yongjun wrote:
> In case of error, the function devm_ioremap_resource() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should
> be replaced with IS_ERR().
>=20
> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On which branch did you base your patch?
It would be helpful to us if you followed SubmittionPatches document,
section with Fixes description. In such case "git describe" will give
immediate answer on my first question.

Thanks

--LwgCY5hL6Igino+O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXpsejAAoJEORje4g2clinSDAQALANi+SF+gcgUDNd5yaHBLBj
EsZSdI/l/3RslLAi9XlC3GNH0kMmYoSHnMN+VYXwYiJSW918aJwmiW6+UoXZ4Ene
5r5VdHgy3Yj+oj0sr4daT+j4+3B6U1RorA3s1G1Tt2WN80vpeA3G3m6fxQFNJKZ1
zKXYtqOqG6rI8/hIVv+s6pGQ5rrGjbGmfhz6cigl0XfdlIgj0GL3PoFHwzFXridp
/R22lSVQ2zVZtbRWzW6yjEkQ3fZ7e5Ys1DJyWqW5Vqj1ycYDpwlSVA/N1OdOnjcp
Wx9j8aY2wVO3CqaaQBxcXWHQas0Zc/nxdtnuBrSqXGTpVmStCz5766yDKDxP3k2M
iVBdF1iiSTwG3EIVHFKlmFdwXtXvTuGDnYVpY1LVica64q4e1vxTnv/q35o3kKZE
KcI5rSfxEAscxj9GwSzj0CrNhl8R/1uVZelK3ZSkGdMeXfgtp4kCUk7t3nMtU7a7
E+WUowGgP5ygAjzd5BNkuzqu5cwBWMbelg2QdQr1Kg4tEQyufOvvnE6G2wP2wSHG
6+nvdRU3AAwm2AsTlT1WUPXhVimb+HR0t8ThaKNgyQD+fXecOWwd27ujywD+6Cm0
Ru3BJVkETJieNYRDEbh9UZo746Nr4k9TpAcrsmMBp/eyflILSzDt+kSUeJXna36P
zwAe+cPGjOyFLL/jvccc
=pSJ1
-----END PGP SIGNATURE-----

--LwgCY5hL6Igino+O--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
