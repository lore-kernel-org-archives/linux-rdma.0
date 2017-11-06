From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v1] IB/core: Make function rdma_copy_addr return void
Date: Mon, 6 Nov 2017 17:05:10 +0000
Message-ID: <VI1PR0502MB3008B424A11D9A9C41B5131FD1500@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20171106114926.18385-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106114926.18385-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, November 06, 2017 5:49 AM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org;
> pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; Moni Shoua
> <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; Parav Pandit
> <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
> ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; Majd Dibbiny
> <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; arnd-r2nGTMty4D4@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH v1] IB/core: Make function rdma_copy_addr return void
>=20
> Function returns zero - make it void.
>=20
> While there make struct net_device const.
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Accept comment from Parav Pandit and make struct net_device const
> ---
>  drivers/infiniband/core/addr.c | 26 ++++++++++++++------------
> drivers/infiniband/core/cma.c  |  8 ++------
>  include/rdma/ib_addr.h         |  5 +++--
>  3 files changed, 19 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/add=
r.c index
> 12523f630b61..a80a4040352a 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -229,8 +229,9 @@ void rdma_addr_unregister_client(struct
> rdma_addr_client *client)  }  EXPORT_SYMBOL(rdma_addr_unregister_client);
>=20
> -int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *de=
v,
> -		     const unsigned char *dst_dev_addr)
> +void rdma_copy_addr(struct rdma_dev_addr *dev_addr,
> +		    const struct net_device *dev,
> +		    const unsigned char *dst_dev_addr)
>  {
>  	dev_addr->dev_type =3D dev->type;
>  	memcpy(dev_addr->src_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
> @@ -238,7 +239,6 @@ int rdma_copy_addr(struct rdma_dev_addr *dev_addr,
> struct net_device *dev,
>  	if (dst_dev_addr)
>  		memcpy(dev_addr->dst_dev_addr, dst_dev_addr,
> MAX_ADDR_LEN);
>  	dev_addr->bound_dev_if =3D dev->ifindex;
> -	return 0;
>  }
>  EXPORT_SYMBOL(rdma_copy_addr);
>=20
> @@ -247,15 +247,14 @@ int rdma_translate_ip(const struct sockaddr *addr,
>  		      u16 *vlan_id)
>  {
>  	struct net_device *dev;
> -	int ret =3D -EADDRNOTAVAIL;
>=20
>  	if (dev_addr->bound_dev_if) {
>  		dev =3D dev_get_by_index(dev_addr->net, dev_addr-
> >bound_dev_if);
>  		if (!dev)
>  			return -ENODEV;
> -		ret =3D rdma_copy_addr(dev_addr, dev, NULL);
> +		rdma_copy_addr(dev_addr, dev, NULL);
>  		dev_put(dev);
> -		return ret;
> +		return 0;
>  	}
>=20
>  	switch (addr->sa_family) {
> @@ -264,9 +263,9 @@ int rdma_translate_ip(const struct sockaddr *addr,
>  			((const struct sockaddr_in *)addr)->sin_addr.s_addr);
>=20
>  		if (!dev)
> -			return ret;
> +			return -EADDRNOTAVAIL;
>=20
> -		ret =3D rdma_copy_addr(dev_addr, dev, NULL);
> +		rdma_copy_addr(dev_addr, dev, NULL);
>  		dev_addr->bound_dev_if =3D dev->ifindex;
>  		if (vlan_id)
>  			*vlan_id =3D rdma_vlan_dev_vlan_id(dev); @@ -279,7
> +278,7 @@ int rdma_translate_ip(const struct sockaddr *addr,
>  			if (ipv6_chk_addr(dev_addr->net,
>  					  &((const struct sockaddr_in6 *)addr)-
> >sin6_addr,
>  					  dev, 1)) {
> -				ret =3D rdma_copy_addr(dev_addr, dev, NULL);
> +				rdma_copy_addr(dev_addr, dev, NULL);
>  				dev_addr->bound_dev_if =3D dev->ifindex;
>  				if (vlan_id)
>  					*vlan_id =3D
> rdma_vlan_dev_vlan_id(dev); @@ -290,7 +289,7 @@ int
> rdma_translate_ip(const struct sockaddr *addr,
>  		break;
>  #endif
>  	}
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL(rdma_translate_ip);
>=20
> @@ -346,7 +345,8 @@ static int dst_fetch_ha(struct dst_entry *dst, struct
> rdma_dev_addr *dev_addr,
>  			neigh_event_send(n, NULL);
>  		ret =3D -ENODATA;
>  	} else {
> -		ret =3D rdma_copy_addr(dev_addr, dst->dev, n->ha);
> +		rdma_copy_addr(dev_addr, dst->dev, n->ha);
> +		ret =3D 0;
>  	}
>  	rcu_read_unlock();
>=20
> @@ -494,7 +494,9 @@ static int addr_resolve_neigh(struct dst_entry *dst,
>  	if (!(dst->dev->flags & IFF_NOARP))
>  		return fetch_ha(dst, addr, dst_in, seq);
>=20
> -	return rdma_copy_addr(addr, dst->dev, NULL);
> +	rdma_copy_addr(addr, dst->dev, NULL);
> +
> +	return 0;
>  }
>=20
>  static int addr_resolve(struct sockaddr *src_in, diff --git
> a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c index
> 852c8fec8088..0527a6a7ef26 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1846,9 +1846,7 @@ static struct rdma_id_private
> *cma_new_conn_id(struct rdma_cm_id *listen_id,
>  		rt->path_rec[1] =3D *ib_event->param.req_rcvd.alternate_path;
>=20
>  	if (net_dev) {
> -		ret =3D rdma_copy_addr(&rt->addr.dev_addr, net_dev, NULL);
> -		if (ret)
> -			goto err;
> +		rdma_copy_addr(&rt->addr.dev_addr, net_dev, NULL);
>  	} else {
>  		if (!cma_protocol_roce(listen_id) &&
>  		    cma_any_addr(cma_src_addr(id_priv))) { @@ -1894,9
> +1892,7 @@ static struct rdma_id_private *cma_new_udp_id(struct
> rdma_cm_id *listen_id,
>  		goto err;
>=20
>  	if (net_dev) {
> -		ret =3D rdma_copy_addr(&id->route.addr.dev_addr, net_dev,
> NULL);
> -		if (ret)
> -			goto err;
> +		rdma_copy_addr(&id->route.addr.dev_addr, net_dev, NULL);
>  	} else {
>  		if (!cma_any_addr(cma_src_addr(id_priv))) {
>  			ret =3D cma_translate_addr(cma_src_addr(id_priv),
> diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h index
> ec5008cf5d51..910a5703d9a9 100644
> --- a/include/rdma/ib_addr.h
> +++ b/include/rdma/ib_addr.h
> @@ -125,8 +125,9 @@ int rdma_resolve_ip_route(struct sockaddr *src_addr,
>=20
>  void rdma_addr_cancel(struct rdma_dev_addr *addr);
>=20
> -int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *de=
v,
> -	      const unsigned char *dst_dev_addr);
> +void rdma_copy_addr(struct rdma_dev_addr *dev_addr,
> +		    const struct net_device *dev,
> +		    const unsigned char *dst_dev_addr);
>=20
>  int rdma_addr_size(struct sockaddr *addr);
>=20
> --
> 2.13.6

I prefer subject to be RDMA/core <..> as this change is applicable to IB, i=
Warp and RoCE.
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
