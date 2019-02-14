From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [rdma-rc PATCH 1/2] cxgb4: export sge_host_page_size to ulds
Date: Thu, 14 Feb 2019 17:51:34 +0200
Message-ID: <20190214155134.GS21447@mtr-leonro.mtl.com>
References: <20190214121054.11693-1-rajur@chelsio.com>
 <20190214121054.11693-2-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eWbcAUUbgrfSEG1c"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190214121054.11693-2-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: Raju Rangoju <rajur@chelsio.com>
Cc: jgg@mellanox.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org


--eWbcAUUbgrfSEG1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2019 at 05:40:53PM +0530, Raju Rangoju wrote:
> Export the sge_host_page_size field to ULDs via
> cxgb4_lld_info, so that iw_cxgb4 can make use of
> this in calculating the correct qp/cq mask.
>
> Fixes: 2391b0030e ("cxgb4: Remove SGE_HOST_PAGE_SIZE dependency on page
> size")

Please don't break Fixes line.

Thanks

--eWbcAUUbgrfSEG1c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcZY6GAAoJEORje4g2clinmEYP/3+emoNf2q1spLkFU0pu8jnT
waMz9ERBe4h9FDs9k9FcfdExmgb1spGRVr/sfcR2GxPDAEGVSZ3+ncXnmMwSrjiP
HfzGdicNW8KuWbnP1QsGBzy8XL2dEBrxLadHNIrbK/K98vN//L208yFTO++qaT+t
mS/qdccmJdA3L1zSNM5A+SaXhRK3b9y1dZSXSOtrbHZzfcZVUUGCjYCzx0r2wUlf
lBNkdtPXZZMH8wWWjLspUnnxdWna0y7f52eg8BIZ/n/bXRWFfUwmFDO44Vah54se
m3HZXSi5cM6qcJZJo2DBpP2HmMlTb6kVIMxZn3ycANcWM6ibZ9OGCZIAviUsQXM4
NS90ZoaPinGZe15XND4Snhw/WGnWhT7WdtUnChUwB4rLPcJALBiS7kRgeywuRfzd
5fTrstqR+y4RBnGdROro1SAiiB+yZmUEY22CJQpY8gAvetVbh+9QAMb3yZfg67d1
9fVWpyuKO4meEUNl2Fm3TwpAi/HL9mfY/uUJGIMjCmipi5kUw4fYSGGARsJ05frE
BPRcjJRac1+93aVFwhgxX3eKRWOLSVLQ5NmUbsYjEl4ppAr8brQSxQCYXnrCpd9U
irGrk4Ru/LCW1+MsAzFJ2b19ELuXeUY1seByH5Yqkx8L55DLf/hDTiUw3QUcUZJ6
DFXdI0oslBnQjRXKr+yt
=2bjL
-----END PGP SIGNATURE-----

--eWbcAUUbgrfSEG1c--
