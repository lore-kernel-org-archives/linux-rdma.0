From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Respect mlx5_core reserved GIDs
Date: Thu, 6 Jul 2017 13:38:11 +0300
Message-ID: <20170706103811.GY1528@mtr-leonro.local>
References: <20170706093923.4azhres5ymy4vefp@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+2GlJm56SCtLHYlr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170706093923.4azhres5ymy4vefp@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: ilant-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+2GlJm56SCtLHYlr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 06, 2017 at 12:39:24PM +0300, Dan Carpenter wrote:
> Hello Ilan Tayari,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 095b0927f0ce: "IB/mlx5: Respect mlx5_core reserved GIDs"
> from May 14, 2017, leads to the following Smatch complaint:
>
> drivers/infiniband/hw/mlx5/main.c:327 set_roce_addr()
> 	 error: we previously assumed 'gid' could be null (see line 300)
>
> drivers/infiniband/hw/mlx5/main.c
>    299
>    300		if (gid) {
>                     ^^^
> Before we used to return early if gid was NULL.

Thanks Dan,
It is bug.
mlx5_ib_del_gid calls this function with gid == NULL.

 363 static int mlx5_ib_del_gid(struct ib_device *device, u8 port_num,
 364                            unsigned int index, __always_unused void **context)
 365 {
 366         return set_roce_addr(device, port_num, index, NULL, NULL);
 367 }

>
>    301			gid_type = attr->gid_type;
>    302			ether_addr_copy(mac, attr->ndev->dev_addr);
>    303
>    304			if (is_vlan_dev(attr->ndev)) {
>    305				vlan = true;
>    306				vlan_id = vlan_dev_vlan_id(attr->ndev);
>    307			}
>    308		}
>    309
>    310		switch (gid_type) {
>    311		case IB_GID_TYPE_IB:
>    312			roce_version = MLX5_ROCE_VERSION_1;
>    313			break;
>    314		case IB_GID_TYPE_ROCE_UDP_ENCAP:
>    315			roce_version = MLX5_ROCE_VERSION_2;
>    316			if (ipv6_addr_v4mapped((void *)gid))
>    317				roce_l3_type = MLX5_ROCE_L3_TYPE_IPV4;
>    318			else
>    319				roce_l3_type = MLX5_ROCE_L3_TYPE_IPV6;
>    320			break;
>    321
>    322		default:
>    323			mlx5_ib_warn(dev, "Unexpected GID type %u\n", gid_type);
>    324		}
>    325
>    326		return mlx5_core_roce_gid_set(dev->mdev, index, roce_version,
>    327					      roce_l3_type, gid->raw, mac, vlan,
>                                                             ^^^^^^^^
> Dereference.
>
>    328					      vlan_id);
>    329	}
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+2GlJm56SCtLHYlr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlleExIACgkQ5GN7iDZy
WKf0dxAA00tCOfsrge5zCxQWMT+cZhGw5Yu2c3UjTFQv04VMSUyjquYH0XpIqaXq
EyFWXwLT3yfGCjoEKVvOd0kDPkqfe8dFI4jN6cyFAtqAAtWB6CeGhHGXkOYQ6+3I
jE1T68Ja/OpgfdjLEoPQ1O39vsEFWEXm+mFfrgjxliRrJrqSW9HxpGEymEeQVG9f
rIEF3n+2scRc/oRN1/1WOaYnO/lfX9g3mzsOEqy3D3WAKK+rLjDmmBtzBin1TaFc
M+L1J0fPOzkTTG4Nn1LKbaIqilUc3Dcgo6V/53ESYW8QjQk/Wy1LEfzUawPh7SdZ
j/Nm5mWYts+3RlTE7LNgU/2jLQQsBe+1Krlt4bSvXgPrBJDZX5AvNFr1XzKZF9AG
w6RZLL5YtydHW+mB+evfEXPKNUUw8FXuCiyuSFN/ek4zYehSEq56tx4cHyq/SGQe
SmcXeD6cdjfhWWzerx+XJpBZDP5jYzRLbwOECeX0c7h0Pwj1mKm32BEgqy4Oiq13
gpOeQuNXz+C2ByVyP/8/CY4VEFFSAwsEj7TObfGrmIJZi950+21BWE9pcWNVFm3e
SmrXJks4RhYDbhh3PVESeY1xOn978O+CfRV44g+5hO2aCSfA6/1VJn9NMCGYzFL5
PW6THVP32P1gHASVmUBZ12vsjHaXsK23YlVcRS7uKaQl6TPrAc8=
=H46b
-----END PGP SIGNATURE-----

--+2GlJm56SCtLHYlr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
