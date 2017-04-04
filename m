From: Mark Brown <broonie@kernel.org>
Subject: Re: next-20170404 build: 1 failures 3 warnings (next-20170404)
Date: Tue, 4 Apr 2017 13:36:04 +0100
Message-ID: <20170404123604.hhiajnks7i2gifsa@sirena.org.uk>
References: <E1cvMgy-00057J-Hs@optimist>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tknrapelwoz6tozr"
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1cvMgy-00057J-Hs@optimist>
Sender: linux-next-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--tknrapelwoz6tozr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2017 at 12:32:08PM +0100, Build bot for Mark Brown wrote:

This failure from last week is still present in -next today:

> 	arm64-allmodconfig
> ../drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1384:15: error: implicit declaration of function 'of_parse_phandle' [-Werror=implicit-function-declaration]
> ../drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1389:22: error: dereferencing pointer to incomplete type 'struct device_node'

I sent a fix at the time: https://patchwork.kernel.org/patch/9654357/

--tknrapelwoz6tozr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAljjkzMACgkQJNaLcl1U
h9DmNAf/c6U8LRwpYiv2yTUxJLTlaVx4nLZOaNHeTLnAoeY7KtNernulmfXbmxt5
969iIIVqjTYNeMDoF72o+VDDfRr6FF/bRgRXlPT0knlcHikQTbFTP+aypXU0iPGv
W/9155+Q8xXzwl+CyNwat8+iYzHIOquPHKpmGnQczFfD8S1B8OtdvDbqziI425GY
1grruIDrc50gYGht8eYjz98XjNqh9L6Z0Sv9ea5OTGD/x30la9sqrf2WLMfqjjs1
DK0Q1Exj/BA9kEIcNK3Sf6nHIdDelN8AWhmInQ33T5veKu5zgNVVbcDeKaqG789p
ik9IM6mNikBz3GaluxwuW5L8MBRg2w==
=zl4S
-----END PGP SIGNATURE-----

--tknrapelwoz6tozr--
