From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RFC PATCH v2 08/13] ib/core: IB cache enhancements to support
 Infiniband security
Date: Thu, 7 Apr 2016 18:09:58 +0300
Message-ID: <20160407150958.GB20789@leon.nu>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-9-git-send-email-danielj@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459985638-37233-9-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2016 at 02:33:53AM +0300, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Cache the subnet prefix and add a function to access it. Enforcing
> security requires frequent queries of the subnet prefix and the pkeys in
> the pkey table.
>=20
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cache.c     |   36 +++++++++++++++++++++++++++++=
+++++-
>  drivers/infiniband/core/core_priv.h |    3 ++
>  include/rdma/ib_verbs.h             |    1 +
>  3 files changed, 39 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/ca=
che.c
> index cb00d59..83cf528 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -925,6 +925,26 @@ int ib_get_cached_pkey(struct ib_device *device,
>  }
>  EXPORT_SYMBOL(ib_get_cached_pkey);
> =20
> +int ib_get_cached_subnet_prefix(struct ib_device *device,
> +				u8                port_num,
> +				u64              *sn_pfx)
> +{
> +	unsigned long flags;
> +	int ret =3D 0;
> +	int p =3D port_num - rdma_start_port(device);
> +
> +	if (port_num < rdma_start_port(device) ||
> +	    port_num > rdma_end_port(device))
> +		return -EINVAL;
> +
> +	read_lock_irqsave(&device->cache.lock, flags);
> +	*sn_pfx =3D device->cache.subnet_prefix_cache[p];
> +	read_unlock_irqrestore(&device->cache.lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ib_get_cached_subnet_prefix);
> +
>  int ib_find_cached_pkey(struct ib_device *device,
>  			u8                port_num,
>  			u16               pkey,
> @@ -1101,6 +1121,8 @@ static void ib_cache_update(struct ib_device *devic=
e,
> =20
>  	device->cache.lmc_cache[port - rdma_start_port(device)] =3D tprops->lmc;
> =20
> +	device->cache.subnet_prefix_cache[port - rdma_start_port(device)] =3D
> +							tprops->subnet_prefix;
>  	write_unlock_irq(&device->cache.lock);
> =20
>  	kfree(gid_cache);
> @@ -1159,8 +1181,19 @@ int ib_cache_setup_one(struct ib_device *device)
>  					  (rdma_end_port(device) -
>  					   rdma_start_port(device) + 1),
>  					  GFP_KERNEL);
> +
> +	device->cache.subnet_prefix_cache =3D kcalloc((rdma_end_port(device) -
> +						     rdma_start_port(device) + 1),
> +						    sizeof(*device->cache.subnet_prefix_cache),
> +						    GFP_KERNEL);
> +
>  	if (!device->cache.pkey_cache ||
> -	    !device->cache.lmc_cache) {
> +	    !device->cache.lmc_cache ||
> +	    !device->cache.subnet_prefix_cache) {
> +		kfree(device->cache.pkey_cache);
> +		kfree(device->cache.lmc_cache);
> +		kfree(device->cache.subnet_prefix_cache);
> +
>  		pr_warn("Couldn't allocate cache for %s\n", device->name);

Please remove this print. You won't miss failure in memory allocation.

>  		return -ENOMEM;
>  	}
> @@ -1204,6 +1237,7 @@ void ib_cache_release_one(struct ib_device *device)
>  	gid_table_release_one(device);

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXBnhGAAoJEORje4g2clinJu8P/0WBIGizz2r0C1P6MT8KDLLz
ED5qeZ9yhpXZEy12gLrJ+u25qieXvaayFbMY8kxpYlQhImwwIaXRmRYnbKebHvKg
0/4KyN65jRnEFLAnf0iGSoJE8wzKZWpGHObS3dU4iP1rV/lQR+fX07HFDQIjMtwM
CTDzQGilY+0X71Fp2rBPZi2FSufoEhdZYy2zVQQ7y7Edq0j8ovMgx2aNQ4NfXmAn
ZLkAcjBxJ+VZycj+aWayztckKz0UuffNqiT4QsKP5Oi8kq7CUGijYYW6zPswKpjD
NYBgGjSa2eqGihZIMNZwCtaiAsfTN+Bz5QHwOfMj82Ia8tEOgwylJocG1aeSBw0b
tujRHcSAkvj2x7H95DT4Ehdp5C9X8GVS3Rr267OA1UASQ+6fPqgdveWh44Yg9pfs
z6QHFH4XbnkJXup4j3iHsSDU8yxKtNzAFX6YVLZH8DUMfEJBFSfgF5x/Iv7i+m73
Sw97kHjtxFJEGTJbrjJcD/tdjW5XXzk9JD4YdmvimIMwBkAlfyxJtOLNsgG4iwPd
IUK+gEbPSTrB9u8+94GZ1pvfYqTENg2uOLuMxba3j/yt++K7Ke2/KoHxHjk6TnZf
xK4f8rJJEn6D04svqK+hiTM3ACqxbVjqQRFIKFUga0BNm7itaRgG3tuFvJeciIJF
UySdFc9yE7wn9lJbSrTj
=rFVX
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
