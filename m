From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [bug report] net/mlx5e: TLS, Add Innova TLS TX offload data path
Date: Thu, 3 May 2018 15:07:57 +0300
Message-ID: <20180503120757.GA1641@mtr-leonro.local>
References: <20180503112300.GA6309@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180503112300.GA6309@mwanda>
Sender: netdev-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Saeed Mahameed <saeedm@mellanox.com>, Boris Pismenny <borisp@mellanox.com>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+ Saeed, Boris and netdev

On Thu, May 03, 2018 at 02:23:00PM +0300, Dan Carpenter wrote:
> Hello Ilya Lesokhin,
>
> The patch bf23974104fa: "net/mlx5e: TLS, Add Innova TLS TX offload
> data path" from Apr 30, 2018, leads to the following static checker
> warning:
>
> 	drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c:63 mlx5e_tls_add_metadata()
> 	warn: struct type mismatch 'ethhdr vs mlx5e_tls_metadata'
>
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
>     55  static int mlx5e_tls_add_metadata(struct sk_buff *skb, __be32 swid)
>     56  {
>     57          struct mlx5e_tls_metadata *pet;
>     58          struct ethhdr *eth;
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>     59
>     60          if (skb_cow_head(skb, sizeof(struct mlx5e_tls_metadata)))
>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>     61                  return -ENOMEM;
>     62
>     63          eth = (struct ethhdr *)skb_push(skb, sizeof(struct mlx5e_tls_metadata));
>                                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This feels like it should be sizeof(*eth) + sizeof(*pet)?
>
>     64          skb->mac_header -= sizeof(struct mlx5e_tls_metadata);
>     65          pet = (struct mlx5e_tls_metadata *)(eth + 1);
>     66
>     67          memmove(skb->data, skb->data + sizeof(struct mlx5e_tls_metadata),
>     68                  2 * ETH_ALEN);
>     69
>     70          eth->h_proto = cpu_to_be16(MLX5E_METADATA_ETHER_TYPE);
>     71          pet->syndrome_swid = htonl(SYNDROME_OFFLOAD_REQUIRED << 24) | swid;
>     72
>     73          return 0;
>     74  }
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrq+5UACgkQ5GN7iDZy
WKf0nRAAhd7f7AdWsEgsxRyB5GOUBMOdAWw+moXu6EN2FqruCh2kbdMwAXzv058c
dXJvDkGPLs76RhQL2RF4HGurRONoC0V2n0MxMP0b+f9MKv1SPSTCwzNOVPVhSE3o
iSnL59Wc8SjYhYNATDvGpAPDBJyZwa3PCm1pBGZKo75PG4SbAkMk/iQVcAFez+hy
mi8JBDFA7wRxMyEu5cg6N3t1+hHjKGjqx0tJm31iXhBtLI2mcm2KPenI2BrBt087
Rm8ynteZ4mA6nYfEiOXSbvZg9zlKfWkZzz7c1VRNl+CxUhDGLcViOBKAM2PtTJ/o
1twDMvbse1Qfwu0bVt+QfupodtuGTnbOnBsJ2v0ToA5D/PKeqUBB+GTAjYejF6ps
Q9QaRN7A61r591sqMsb+pQz/4fc7bMWSkjR/SAh8qVOo5cSMc5JkgI18wlg/gIP7
aT2zKrajIOTUhxCzadabi2QjgE46OPYtLgfD94NeTVlecfykGciRCtQN87/POxak
giisEDZTICv16mWk9KYKsYEFdF7VoSNEnw/NW/sDwNrGAmvKlBlDk1aMNqsTeL21
p6GzpuKlBS6Wl/t45eln2WTzfsKtVuALl5NfhuzT/tBaBU6GwMa5niJPu5W4fRgl
3kdQWyCdLMNOcKC4zuuj+YkMQ9uic/IRj4IrjXPmrgZVUiQtOpo=
=nS9F
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
