From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] {net,IB}/{rxe,usnic}: Utilize generic mac to eui32
 function
Date: Sun, 5 Mar 2017 09:46:50 +0200
Message-ID: <20170305074650.GH14379@mtr-leonro.local>
References: <1488574145-27179-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488574145-27179-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 03, 2017 at 10:49:05PM +0200, Yuval Shaia wrote:
> This logic seems to be duplicated in (at least) three separate files.
> Move it to one place so code can be re-use.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Add missing #include
> 	* Rename to genaddrconf_ifid_eui48
> ---
>  drivers/infiniband/hw/usnic/usnic_common_util.h | 11 +++--------
>  drivers/infiniband/sw/rxe/rxe_net.c             | 11 ++---------
>  include/net/addrconf.h                          | 18 ++++++++++++------
>  3 files changed, 17 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/infiniband/hw/usnic/usnic_common_util.h b/drivers/infiniband/hw/usnic/usnic_common_util.h
> index b54986d..09871da 100644
> --- a/drivers/infiniband/hw/usnic/usnic_common_util.h
> +++ b/drivers/infiniband/hw/usnic/usnic_common_util.h
> @@ -34,6 +34,8 @@
>  #ifndef USNIC_CMN_UTIL_H
>  #define USNIC_CMN_UTIL_H
>
> +#include <net/addrconf.h>
> +
>  static inline void
>  usnic_mac_to_gid(const char *const mac, char *raw_gid)
>  {
> @@ -57,14 +59,7 @@
>  	raw_gid[1] = 0x80;
>  	memset(&raw_gid[2], 0, 2);
>  	memcpy(&raw_gid[4], &inaddr, 4);
> -	raw_gid[8] = mac[0]^2;
> -	raw_gid[9] = mac[1];
> -	raw_gid[10] = mac[2];
> -	raw_gid[11] = 0xff;
> -	raw_gid[12] = 0xfe;
> -	raw_gid[13] = mac[3];
> -	raw_gid[14] = mac[4];
> -	raw_gid[15] = mac[5];
> +	genaddrconf_ifid_eui48(&raw_gid[8], mac);
>  }
>
>  static inline void
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 4abdeb3..23ba9e1 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -38,6 +38,7 @@
>  #include <linux/if_vlan.h>
>  #include <net/udp_tunnel.h>
>  #include <net/sch_generic.h>
> +#include <net/addrconf.h>
>  #include <linux/netfilter.h>
>  #include <rdma/ib_addr.h>
>
> @@ -86,18 +87,10 @@ struct rxe_dev *get_rxe_by_name(const char *name)
>
>  static __be64 rxe_mac_to_eui64(struct net_device *ndev)
>  {
> -	unsigned char *mac_addr = ndev->dev_addr;
>  	__be64 eui64;
>  	unsigned char *dst = (unsigned char *)&eui64;
>
> -	dst[0] = mac_addr[0] ^ 2;
> -	dst[1] = mac_addr[1];
> -	dst[2] = mac_addr[2];
> -	dst[3] = 0xff;
> -	dst[4] = 0xfe;
> -	dst[5] = mac_addr[3];
> -	dst[6] = mac_addr[4];
> -	dst[7] = mac_addr[5];
> +	genaddrconf_ifid_eui48(dst, ndev->dev_addr);
>
>  	return eui64;
>  }
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index 8f998af..07d0341 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -105,12 +105,21 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
>  				 u32 addr_flags, bool sllao, bool tokenized,
>  				 __u32 valid_lft, u32 prefered_lft);
>
> +static inline void genaddrconf_ifid_eui48(u8 *eui, const char *const addr)
> +{
> +	memcpy(eui, addr, 3);
> +	eui[0] ^= 2;
> +	eui[3] = 0xFF;
> +	eui[4] = 0xFE;
> +	memcpy(eui + 5, addr + 3, 3);
> +}
> +
>  static inline int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
>  {
>  	if (dev->addr_len != ETH_ALEN)
>  		return -1;
> -	memcpy(eui, dev->dev_addr, 3);
> -	memcpy(eui + 5, dev->dev_addr + 3, 3);
> +
> +	genaddrconf_ifid_eui48(eui, dev->dev_addr);
>
>  	/*
>  	 * The zSeries OSA network cards can be shared among various
> @@ -128,11 +137,8 @@ static inline int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
>  	if (dev->dev_id) {
>  		eui[3] = (dev->dev_id >> 8) & 0xFF;
>  		eui[4] = dev->dev_id & 0xFF;
> -	} else {
> -		eui[3] = 0xFF;
> -		eui[4] = 0xFE;
> -		eui[0] ^= 2;

Sorry, but NAK.
You missed the assignment below. In original code it WASN'T for dev->dev_id != NULL, and now it is.

>  	}
> +
>  	return 0;
>  }
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli7wmoACgkQ5GN7iDZy
WKcmjQ//RA2l7R9AdTgBAmhqQb3jyiKMrQ5iDXCQ2MTCX8UIDz4qD0pKT7NxOyed
wWnZc8Msr+jXm4PisZvXbbST3jRPmIvly6PkzHNGjnUpSv5URLsAodMoVzgS5IQL
DxxXn9GI86HuN+oW4gKr4O77NJxpfzOA17eltrxz4YLV0353+Zd1wwQAjAr4iKZa
7Mjvf6H5rxBcpPcYl0HhgEFXaJVqOd2d1dtl8tV37L9D2MhKxxoV0eUseokFfsNu
Z6kuDKgsT5PO3EXtO+r9Ri0pKkIdc24UATD19K5Y9wMGW9OlMz7T/8czd4vXIWx8
S/5DTWF0iM+s/wSW0VFuAOvdNiFxsuS+KpvgIKdwQCOUlwdk4ooO3z/mPEK47fSk
1gB2iyIlc9s2HzkRVrFAhgMblGP9qbwVS2diYxtCZS9+c1+sGIw2G8PzpU1WqNnL
WPpfk3st5Ex8/bktwudp64ZfZjAbGkvRYiijN36l91UZkdwL0tj6ea5R/vkbttKX
trxiiQNQZ1H2cxE5fiSx8t6yHjBta2Aq+wtFFE/ctPRYtEkT0wdR/oCUs/JzptFI
Icv7qEgKWtB1fPfiuu1IUT+9jWHO9ksvI+UiphWi5gkM8h9dYbU3OD0ujioXf9zl
Xos24MnIUYhyKK62XBxOj9qkZN3GZ7ZHmgiJ2XutaxwH9bFJdkw=
=8ll6
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
