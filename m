From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 13/33] RDMA/core: Add iterator over ib_devices
Date: Wed, 9 Aug 2017 13:09:00 -0400
Message-ID: <9ae5be78-67ef-5803-9737-f913dc874861@redhat.com>
References: <20170809160405.25142-1-leon@kernel.org>
 <20170809160405.25142-14-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r99WQuKuXC7I9bQPKgVEGMnlqrP0inhwB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809160405.25142-14-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r99WQuKuXC7I9bQPKgVEGMnlqrP0inhwB
Content-Type: multipart/mixed; boundary="s1TTWT95XD4PhpTAw2jOg5jPS0GFMf7HG";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <9ae5be78-67ef-5803-9737-f913dc874861-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 13/33] RDMA/core: Add iterator over ib_devices
References: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20170809160405.25142-14-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170809160405.25142-14-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--s1TTWT95XD4PhpTAw2jOg5jPS0GFMf7HG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The coming nldev needs to iterate over all IB devices in the system
> and in order to not expose the ib_devices list outside the devices.c,
> it is necessary to provide function iterator.
>=20
> Current version is written explicitly for nldev callback to avoid
> over-engineering at this stage, but it can be easily extended for
> other types.
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/core_priv.h |  8 ++++++++
>  drivers/infiniband/core/device.c    | 25 +++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>=20
> diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/c=
ore/core_priv.h
> index e759c27113cd..0c175590cf92 100644
> --- a/drivers/infiniband/core/core_priv.h
> +++ b/drivers/infiniband/core/core_priv.h
> @@ -102,6 +102,14 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter f=
ilter,
>  			      roce_netdev_callback cb,
>  			      void *cookie);
> =20
> +typedef int (*nldev_callback)(struct ib_device *device,
> +			      struct sk_buff *skb,
> +			      struct netlink_callback *cb,
> +			      unsigned int idx);
> +
> +int ib_enum_all_devs(nldev_callback nldev_cb, struct sk_buff *skb,
> +		     struct netlink_callback *cb);
> +
>  enum ib_cache_gid_default_mode {
>  	IB_CACHE_GID_DEFAULT_MODE_SET,
>  	IB_CACHE_GID_DEFAULT_MODE_DELETE
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core=
/device.c
> index a1d5798fa4d7..54143476a020 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -892,6 +892,31 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter f=
ilter,
>  	up_read(&lists_rwsem);
>  }
> =20
> +/**
> + * ib_enum_all_devs - enumerate all ib_devices
> + * @cb: Callback to call for each found ib_device
> + *
> + * Enumerates all ib_devices and calls callback() on each device.
> + */
> +int ib_enum_all_devs(nldev_callback nldev_cb, struct sk_buff *skb,
> +		     struct netlink_callback *cb)
> +{
> +	struct ib_device *dev;
> +	unsigned int idx =3D 0;
> +	int ret =3D 0;
> +
> +	down_read(&lists_rwsem);
> +	list_for_each_entry(dev, &device_list, core_list) {
> +		ret =3D nldev_cb(dev, skb, cb, idx);

This clearly enumerates more than just ib devs, should the signature not
be rdma_enum_all_devs?

> +		if (ret)
> +			break;
> +		idx++;
> +	}
> +
> +	up_read(&lists_rwsem);
> +	return ret;
> +}
> +
>  /**
>   * ib_query_pkey - Get P_Key table entry
>   * @device:Device to query
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--s1TTWT95XD4PhpTAw2jOg5jPS0GFMf7HG--

--r99WQuKuXC7I9bQPKgVEGMnlqrP0inhwB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZi0GsAAoJELgmozMOVy/d+VkQAMBGb40eNJdIDixCiByG5Sj9
ZmTsDHo+nOIS5b7VZxkBn7TEGRFXPhaWzh+eoxAd97UnDgls3ExA+ttPHoUIc6H6
069FN3fwA5gkqzaxcG8NmORck93xalcbef9EKFCYF961PWr346Z4Wh26lyws6K8r
erQVPeaiqz9gZosLdpb13yBzb6sUYUs2uhuS1wX+Vel/b14jgx9XZEe0mbB6iHbS
eSg8yq39LoGDmczvAkYz8yJS5P8zILRwsl2NbGlhPgdlzRX5Ogs0GWdeeKVrPjVg
On8QIef/HiiD6yzP6XzvgUOJkvHXvwjhlNLqR8emowF3jXIfPQYxKRRdi0nEsHYm
yymn/x0NXSrfpN6Um0HSfn+ni942cQBITY8brPoT/c5PXEUITjUcL1TPEAwBPteT
BkhHobnqpHHai1Rv5Yf59fTs8eQUFsadPMerd9IMDbKHRIw1UzZa3AoTCl+F009d
Lj1eTfijQZOdkuKPQiD5zw77nnBtfdklaKMpaS9NhtfH58F8n+VR7TA7rimAHoAb
EWL6UnxNDByVitGvf06pde1q6I51TL06p7AGNp9VY4HXqGcXjRawWjO7TxppOrbw
JULF4xdhKGoS7WZmxgPpte83yluu1J6ikHQmPwFWtw/A5yrucuqy1oBToRz+/PxA
5NG9N2AQDfYoofIwKWSD
=OvKO
-----END PGP SIGNATURE-----

--r99WQuKuXC7I9bQPKgVEGMnlqrP0inhwB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
