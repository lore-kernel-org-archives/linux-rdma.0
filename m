From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/1] IB/cxgb3: fix misspelling in header guard
Date: Sun, 22 Jan 2017 15:55:34 +0200
Message-ID: <20170122135534.GH28570@mtr-leonro.local>
References: <20170122134122.10352-1-nicolas.iooss_linux@m4x.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170122134122.10352-1-nicolas.iooss_linux@m4x.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 22, 2017 at 02:41:22PM +0100, Nicolas Iooss wrote:
> Use CXGB3_... instead of CXBG3_...
>
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> ---
>  include/uapi/rdma/cxgb3-abi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Fixes: a85fb3383340 ("IB/cxgb3: Move user vendor structures")

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliEuc4ACgkQ5GN7iDZy
WKcidw/9GHlhIbD1ZtnH6RAHnRPYL0TuZ06kg467N6kBt5lFThLqq74bAop7fEuQ
cDZZG1XAxhLq3scMUKy1JdBKgO1VDrMIzSWvwaDf7UmOHlPSPcj0BASSZpRyUVoF
DGN+B/xs5tNLydlbD0Cu9LOJQ5iFJVMSeQXxNepAO1pqjAIVR3XfG1wHKOAzL2h4
ruB6QfZ/LhKKA948d2rU17OulgzOwPSwqGaahfDH64mSqwYd3otv/uyYfOnh5WcS
Gbc+bnN9pjUhY2GUigFxfnJqMFM03Zl2BzGjnwll+L0nVNvTYb9NPrhMp1rWDG9n
yDvMvGhtH4JJ/7TP276rMfhLxb2VBmnLuEVGpADyrS44SUkXERtH/XbZvLkjEtbC
bpGQuTkLbyzSu4RxPdi7/IGF1S3C6LxYNHW/8fljsOYoNDv3Z9G/ErHwDj/P0IAp
vXDGTAAlDsUSmuSRKlCaRrvNmPPC++R2lwvirdd2z/Tql3l/Wq/Pc5kygHU63In2
WdNJelQ8IZ9EcZh+MpA41ohB3y/cEYYgmT/bvs1mUhTgQrGdzZ1ZZbxIyEQpQWfA
aQLjybyAaoXSDz2WFxWJsIlfOZhypFNmyk7pRzDSuS2RKp9iXvh3CGPYi5HAEAQ6
diikOdIgtB9fYwdsy0LFaEK3mMnl0uwGJBDHOYju1NeLdU7MUG4=
=hyC1
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
