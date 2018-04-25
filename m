From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/ipoib: fix ipoib_start_xmit()'s return type
Date: Wed, 25 Apr 2018 18:35:32 +0300
Message-ID: <20180425153532.GM24820@mtr-leonro.local>
References: <20180424131549.2859-1-luc.vanoostenryck@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mFHiwr52TKrxpkjc"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180424131549.2859-1-luc.vanoostenryck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Alex Vesker <valex@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, Erez Shitrit <erezsh@mellanox.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Feras Daoud <ferasda@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--mFHiwr52TKrxpkjc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 24, 2018 at 03:15:47PM +0200, Luc Van Oostenryck wrote:
> The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> which is a typedef for an enum type, but the implementation in this
> driver returns an 'int'.
>
> Fix this by returning 'netdev_tx_t' in this driver too.
>
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--mFHiwr52TKrxpkjc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrgoEQACgkQ5GN7iDZy
WKfggg/8DGJIl7K00Hfuds0eJ/eySzKl4A/0UJYwtFnLB+DugSnjk2grpmgpZXQi
HJO/j/OARdVe1FfLQqxXqel1ALn8lnT1f5h5jzSySiDlJmtxMvCwKCkZuKnQEf8e
8xJ+xF6IaeWPUo54AB2nNgj9TedVgqfwoXUIj8hGER+YSaty7IyUswJpqdURIMON
q9Pv+FY82Ila2hQDb8/ZVwlHGr7PRvofcCLbP9q+R5XzPZx/WxPPaxhtuifjLTeO
a2x5NpVp80wOf3FxMC0BimL+pWJU9NPJPubU1Lk1peFsOSHMnwGGXYzm3/uqBobQ
fv0Dh93W0twseGA+tpi/xVQXHoejtp/4pcRmOaIA9MWcrmTMnOcXbiYAzEc97b2k
++lJW/qRixhCfink3+PTjmCQLPFJzDYYJ/BgknEHf1irNy0gmZgzmnvDA43cMWhc
CWjCsuwgitTSV6++9V3rL9APGL3JINVf24ZSrM8eMLLKWJzuHqUfdYDf4ifxTaus
PqTa45iGv4IuaTXJy2HSSKZHpa4GAg5TctauOzIAZONIkba08xdv0Hkui6wsyblz
cP6GsMyZnyCf9iMrR9dzBbQXAocYoN1wUEuaKoIUiD+kPIHoh7t5bIxWUqj/O/yk
LjaiC6aDVKQKqqhHqsKvjCG7MUnTDLMxlyv+u0F+TgNU73simIA=
=f+da
-----END PGP SIGNATURE-----

--mFHiwr52TKrxpkjc--
