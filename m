From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 03/22] IB/core: Add ib_find_exact_cached_pkey()
 to search for 16-bit pkey match
Date: Tue, 11 Sep 2012 12:53:42 -0400
Message-ID: <504F6C96.7050700@redhat.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-4-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDEDFA1B94747BBB4BCFBACFF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-4-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDEDFA1B94747BBB4BCFBACFF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> When port pkey table potentially contains both full and partial
> membership copies for the same pkey, we need a function to find
> the exact (16-bit) pkey index.

The code on this patch is fine, just see my previous email about the
function naming...

> This is particularly necessary when the master forwards QP1 MADS
> sent by guests.  If the guest has sent the MAD with a limited
> membership pkey, we wish to forward the MAD using the same limited
> membership pkey.  Since master may have both the limited and
> the full member pkeys in its table, we must make sure to retrieve
> the limited membership pkey in this case.
>=20
> This requires the 16-bit pkey lookup function (which includes the
> membership bit).
>=20
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cache.c |   32 +++++++++++++++++++++++++++++++=
+
>  include/rdma/ib_cache.h         |   16 ++++++++++++++++
>  2 files changed, 48 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/=
cache.c
> index 0f2f2b7..d8a8c83 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -198,6 +198,38 @@ int ib_find_cached_pkey(struct ib_device *device,
>  }
>  EXPORT_SYMBOL(ib_find_cached_pkey);
> =20
> +int ib_find_exact_cached_pkey(struct ib_device *device,
> +			      u8                port_num,
> +			      u16               pkey,
> +			      u16              *index)
> +{
> +	struct ib_pkey_cache *cache;
> +	unsigned long flags;
> +	int i;
> +	int ret =3D -ENOENT;
> +
> +	if (port_num < start_port(device) || port_num > end_port(device))
> +		return -EINVAL;
> +
> +	read_lock_irqsave(&device->cache.lock, flags);
> +
> +	cache =3D device->cache.pkey_cache[port_num - start_port(device)];
> +
> +	*index =3D -1;
> +
> +	for (i =3D 0; i < cache->table_len; ++i)
> +		if (cache->table[i] =3D=3D pkey) {
> +			*index =3D i;
> +			ret =3D 0;
> +			break;
> +		}
> +
> +	read_unlock_irqrestore(&device->cache.lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ib_find_exact_cached_pkey);
> +
>  int ib_get_cached_lmc(struct ib_device *device,
>  		      u8                port_num,
>  		      u8                *lmc)
> diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
> index 00a2b8e..ad9a3c2 100644
> --- a/include/rdma/ib_cache.h
> +++ b/include/rdma/ib_cache.h
> @@ -101,6 +101,22 @@ int ib_find_cached_pkey(struct ib_device    *devic=
e,
>  			u16                 *index);
> =20
>  /**
> + * ib_find_exact_cached_pkey - Returns the PKey table index where a sp=
ecified
> + *   PKey value occurs. Comparison uses the FULL 16 bits (incl members=
hip bit)
> + * @device: The device to query.
> + * @port_num: The port number of the device to search for the PKey.
> + * @pkey: The PKey value to search for.
> + * @index: The index into the cached PKey table where the PKey was fou=
nd.
> + *
> + * ib_find_exact_cached_pkey() searches the specified PKey table in
> + * the local software cache.
> + */
> +int ib_find_exact_cached_pkey(struct ib_device    *device,
> +			      u8                   port_num,
> +			      u16                  pkey,
> +			      u16                 *index);
> +
> +/**
>   * ib_get_cached_lmc - Returns a cached lmc table entry
>   * @device: The device to query.
>   * @port_num: The port number of the device to query.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigDEDFA1B94747BBB4BCFBACFF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQT2yWAAoJELgmozMOVy/dwhMP/2YC3lWA/DthBrElZT8u6rVP
TeBboe7JzNZ7aAamlbt2/AIxhlzy+u8M4RqcuLMYIXkerYKa4H4kGfwLcl73rF/N
51PuaD/pV2BZ3ggwv8D3tjdUbKhFaY9KL5Iae8EAYj8GNPjT8Hm+H0XVop+fEqJT
2zE+HxLfvjxfmR1GCzup+i0b16aGlADfqjIDPUaGqTgYF/VuxPuDD6SUIlaYr0il
x5Po4Vts1qXSjPGCbJHWg8roo/1fihVXA13NDz89d2tUIBrCSWtVRrzqRPRhO1+s
N8ZojEXNjsM3r6OopqzbBARpOIPlgYFXUUJ67/XLlxvz5Gv6MDTJxVa4I73nYMf+
LBnY26EDNXRij1RcB2KzwKpytsolSIFDdKjxaJ4L4cZtCP3VB0N/UaJ09OUeTpRL
LRkkAPpq0xUlRedMhNmgTWtKQzeR5nTkLo5CUk/icsmDwiAZjQ31PNeJIwy8HSB0
b7H+jqTnxTW7hzj794ZmjGjQ7YYsmm0rUCL6DDNHeLF8N56f0NrJGKjElgIyQG7N
RvXJ4M2KNhjlhCZg6qu/nvWGrLoYl70kgTmRvmTfwrO2qQxjPMLlBGYh1xb2jL/s
xtB0kPs5pK/ieiYjF2OG31Eluc0bwigMCJRD3NTzBojqSBHK10xK4rk28F0Zah/p
2CeVLzDM1/LW0mT9LTlf
=Qjcp
-----END PGP SIGNATURE-----

--------------enigDEDFA1B94747BBB4BCFBACFF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
