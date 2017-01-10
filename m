From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core] rdma: Handle uninitialized data for
 ibv_cmd_modify_qp
Date: Tue, 10 Jan 2017 21:15:27 +0200
Message-ID: <20170110191527.GU7218@mtr-leonro.local>
References: <1484069070-17174-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o+ZCuNqY+dEAKBWl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484069070-17174-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--o+ZCuNqY+dEAKBWl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 10, 2017 at 07:24:30PM +0200, Yishai Hadas wrote:
> Instead of checking per field whether wasn't set then use explicit = 0,
> go over the providers and initialize their input command by using = {}.
>
> This comes as a pre-patch before introducing the ibv_cmd_modify_qp_ex
> which will do the same.
>
> The above drops the need to add an extra 'zeroing' code each time
> when a new field is introduced.
>
> This improves commit 77fbb25e4c2a1f99d812752f85a28978ece32fe0 as pointed
> above.
>
> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibverbs/cmd.c                 | 47 +---------------------------------------
>  providers/cxgb3/verbs.c          |  2 +-
>  providers/cxgb4/qp.c             |  2 +-
>  providers/cxgb4/verbs.c          |  2 +-
>  providers/hfi1verbs/verbs.c      |  2 +-
>  providers/hns/hns_roce_u_hw_v1.c |  2 +-
>  providers/i40iw/i40iw_uverbs.c   |  2 +-
>  providers/ipathverbs/verbs.c     |  2 +-
>  providers/mlx4/verbs.c           |  2 +-
>  providers/mlx5/verbs.c           |  2 +-
>  providers/mthca/verbs.c          |  2 +-
>  providers/nes/nes_uverbs.c       |  2 +-
>  providers/ocrdma/ocrdma_verbs.c  |  2 +-
>  providers/qedr/qelr_verbs.c      |  2 +-
>  providers/rxe/rxe.c              |  2 +-
>  15 files changed, 15 insertions(+), 60 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--o+ZCuNqY+dEAKBWl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh1Ms8ACgkQ5GN7iDZy
WKeolA//ZEtjmwrA14bU6doLjCNnkKXMdZ/VFuHpb6QTqhoZL67q/4AxkQ0i5cCB
p+P7uoPR5x84eUtqaJWUBKQeAXafPlTL5E8b3fk8Ay1n06fw9RGDalIktH1yZ6Sc
93lknEd9q6xhhIHaL1Dfvc9iTq5VaY5/937j2rNHcXiHWd3WtoCMFiHZ8Lztuz5f
2ARNuHZWCv68zXOfKkjSH/RXucJ14hmkQp0Jqnh0CNymBsmxDG9OORHWZNmeydLT
z7IxwpwXBb/FLPSaDaJcdyjFTV6CNYikN8l8gQrjvFBt/oWM14FP7wFG3DOuGWVb
gkLH6fo4t4tiJcqfHIXEqtKqEeyQe6lMWpcQktHaNczekAUa3GsLh2Q537fwL+8h
DOo2Qunxi4fUWOkutlhn80Oi1XQapzzaHZWIwP4EdvgiecWziT+IP/1dA/DoA1/O
5trAXvbvs1H/WP6k9jL9+CoKFa52ub0EYSria+wgRM/UpZC0yw9IVZxYW3nV0/II
8r5DITO3Px6O1lEX/2UXSqbLYEIlISk2Bj3HLWQd/OFgacDSDNxoFcVNG2GhTTNj
kVyJSskkdaOui36nt2u6G+GhP93ymrH8GEVw4H9ByEqMqYyu3S7nqhoysKzRB6XU
8lURt11ddfl8NpmI52Jz9D0T1/4OiXK2Bqx0g/aCEcBltiwQUbM=
=uJId
-----END PGP SIGNATURE-----

--o+ZCuNqY+dEAKBWl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
