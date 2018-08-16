From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3] net/mlx5e: Delete unneeded function argument
Date: Thu, 16 Aug 2018 14:26:40 +0300
Message-ID: <20180816112640.GG2796@mtr-leonro.mtl.com>
References: <20180816090220.4537-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180816090220.4537-1-yuval.shaia@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: saeedm@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 16, 2018 at 12:02:20PM +0300, Yuval Shaia wrote:
> priv argument is not used by the function, delete it.
>
> Fixes: a89842811ea98 ("net/mlx5e: Merge per priority stats groups")
> Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
> ---
> v1 -> v2:
> 	* Remove blank line as pointed by Leon.
>
> v2 -> v3:
> 	* Change prefix to mlx5e
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Thanks Yuval,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbdV9vAAoJEORje4g2clinaEQP/Aj1O5utU7goVKQbAwC9eLe2
A03r+/7FvE5BeHIcwGnfHFx07Iyq4B/PQ9XM0yrbFTx65NEgO+EeMnT32mRrMsNL
DC35Q/1KZwaCXr927tOsWjPKyJLhMPBFWKYIoskQdd/WxmkbtrVA4SgJxz7g0vDb
S8G+mX1cznSnub80W7WkgVFB3eiirDmPhn/hclpWnJBlpsTfiTuG5FPC11ZXznvN
1EpzfzGnDsPKS+VDL77tJ0qo8Cdvm6/2Du1vjQsp+yW0EDyftT6slh9putdkWLpE
Ll+NW2LobaVOtuWwSyKzM6tXqnwY6f/MeARrScIvuu8TPXBSa2JvMWvj3i3EOD1z
X5gswHIRR1DG4cLdiPGzARMREoMyow6PE0vt72zGO94zBqYkySuyvSOzb2avki1m
zwy7ZAVEqfHY0NQHrDlmicZdmIJAvb0+OX7o3gwUNFRrWS3NNZFD7ScbJ4oCVEsn
wbh/W3f1pWGtHEAN6QgHqxLReZ4ShG+xvDMuyMtT/Ht2/FcwrqNPXtx5UWKDPmMZ
9p0xNXxTw2w/eElyaGG0O+qRWu6GN2c5bMhqchH9ZiqLs2H3U09QJZ0fII9y22g0
hVlXw1a750UMU+aXlVZjh3eqBjPNYi8oDMpgIa7R5Sl3WFkFE4h0viq/ow9YV/7m
+pnNxuZMSOUsbLXyI1bQ
=IyQa
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
