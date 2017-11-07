From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/core: Make function rdma_copy_addr return void
Date: Tue, 7 Nov 2017 10:20:13 +0200
Message-ID: <20171107082013.GC18825@mtr-leonro.local>
References: <20171107064424.4588-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171107064424.4588-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 07, 2017 at 08:44:24AM +0200, Yuval Shaia wrote:
> Function returns zero - make it void.
>
> While there make struct net_device const.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> v0 -> v1:
> 	* Accept comment from Parav Pandit and make struct net_device const
> v1 -> v2:
> 	* s/IB/RDMA (header)
> 	* Add Parav Pandit r-b
> ---
>  drivers/infiniband/core/addr.c | 26 ++++++++++++++------------
>  drivers/infiniband/core/cma.c  |  8 ++------
>  include/rdma/ib_addr.h         |  5 +++--
>  3 files changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index 12523f630b61..a80a4040352a 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -229,8 +229,9 @@ void rdma_addr_unregister_client(struct rdma_addr_client *client)
>  }
>  EXPORT_SYMBOL(rdma_addr_unregister_client);
>
> -int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *dev,
> -		     const unsigned char *dst_dev_addr)
> +void rdma_copy_addr(struct rdma_dev_addr *dev_addr,
> +		    const struct net_device *dev,
> +		    const unsigned char *dst_dev_addr)
>  {
>  	dev_addr->dev_type = dev->type;
>  	memcpy(dev_addr->src_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
> @@ -238,7 +239,6 @@ int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *dev,
>  	if (dst_dev_addr)
>  		memcpy(dev_addr->dst_dev_addr, dst_dev_addr, MAX_ADDR_LEN);
>  	dev_addr->bound_dev_if = dev->ifindex;
> -	return 0;
>  }
>  EXPORT_SYMBOL(rdma_copy_addr);
>
> @@ -247,15 +247,14 @@ int rdma_translate_ip(const struct sockaddr *addr,
>  		      u16 *vlan_id)
>  {
>  	struct net_device *dev;
> -	int ret = -EADDRNOTAVAIL;
>
>  	if (dev_addr->bound_dev_if) {
>  		dev = dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
>  		if (!dev)
>  			return -ENODEV;
> -		ret = rdma_copy_addr(dev_addr, dev, NULL);
> +		rdma_copy_addr(dev_addr, dev, NULL);
>  		dev_put(dev);
> -		return ret;
> +		return 0;
>  	}
>
>  	switch (addr->sa_family) {
> @@ -264,9 +263,9 @@ int rdma_translate_ip(const struct sockaddr *addr,
>  			((const struct sockaddr_in *)addr)->sin_addr.s_addr);
>
>  		if (!dev)
> -			return ret;
> +			return -EADDRNOTAVAIL;
>
> -		ret = rdma_copy_addr(dev_addr, dev, NULL);
> +		rdma_copy_addr(dev_addr, dev, NULL);
>  		dev_addr->bound_dev_if = dev->ifindex;
>  		if (vlan_id)
>  			*vlan_id = rdma_vlan_dev_vlan_id(dev);
> @@ -279,7 +278,7 @@ int rdma_translate_ip(const struct sockaddr *addr,
>  			if (ipv6_chk_addr(dev_addr->net,
>  					  &((const struct sockaddr_in6 *)addr)->sin6_addr,
>  					  dev, 1)) {
> -				ret = rdma_copy_addr(dev_addr, dev, NULL);
> +				rdma_copy_addr(dev_addr, dev, NULL);
>  				dev_addr->bound_dev_if = dev->ifindex;
>  				if (vlan_id)
>  					*vlan_id = rdma_vlan_dev_vlan_id(dev);
> @@ -290,7 +289,7 @@ int rdma_translate_ip(const struct sockaddr *addr,
>  		break;
>  #endif
>  	}
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL(rdma_translate_ip);
>
> @@ -346,7 +345,8 @@ static int dst_fetch_ha(struct dst_entry *dst, struct rdma_dev_addr *dev_addr,
>  			neigh_event_send(n, NULL);
>  		ret = -ENODATA;
>  	} else {
> -		ret = rdma_copy_addr(dev_addr, dst->dev, n->ha);
> +		rdma_copy_addr(dev_addr, dst->dev, n->ha);
> +		ret = 0;

Except very little comment, that is is better to set 0 to "ret"
at the initialization phase and save assignment here.

Looks good, thanks Yuval.
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloBbL0ACgkQ5GN7iDZy
WKco9w//a/az8ELcDWE1LiuFqoREfh8gwXqVFnltTKoJ8mdt1ikfNH+gRrqeHa7x
vf9lSEzSiT1ZHYhOBm+NB23M30qTKZz5AXs5WlF5TSgmHBS3hdx9Lcm6Gpa2c+Zu
IQyGt98GivsrIFyZQzBWgiw1FwtzsiSpr4Es88XPp1jAs5wdwR2IISO6kndqmV1p
D9ZRto3mZjLXSQWT3xHdgIbX6gURr9OkKibHvoKEG2TCQ6Gxlqan9zU2gBKLdlRv
fpxEvda8P03qqaAOKvzkaN0QBckZIgFnK+bZfrgjmxLdlIi/kczIeA4z+BQSzLDL
jfeHj+Ud44HMsinRGyYLi0ZvYz40yWcj7dgoDEOPQg+KB8DhaIL6DIc26/6ZYj+U
44dnTQaYgUm4WH3K6rCn3TY0IYNDWZ0WRcrvw0nKWcypy/P9uVs94Av0/sWMJoTH
mAhWa88op3/lSQcuLlFWmmUT8dFw1PqsDoD9bDaC/ai1Og6yJEIw3pKlT4TmgR8l
Ec8OMNpcGbVyGLMUpyMBf2HA55B+Sin4tRQKhoVT67n8+g/CR0zHuG86FONhd9i2
u3ILmztmNr0ssYF/GrAQS19IBkvmsR7H5XKVYud7AggTyJcbIWdlEzcUYCiunV2A
eq58r/eF9tBPI4jkJuX+1h3n95r+0s+ZGU4siGazt9pRB2C1gTA=
=iE/K
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
