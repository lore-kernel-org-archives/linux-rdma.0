From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 02/22] IB/core: change pkey table lookups
 to support full and partial membership for the same pkey
Date: Tue, 11 Sep 2012 12:52:31 -0400
Message-ID: <504F6C4F.6050207@redhat.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-3-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAB7913E67ACA28D07BBF9ACB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-3-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAB7913E67ACA28D07BBF9ACB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> Enhance the cached and non-cached pkey table lookups to enable limited =
and full
> members of the same pkey to co-exist in the pkey table.
>=20
> This is necessary for SRIOV to allow for a scheme where some guests wou=
ld have the full
> membership pkey in their virtual pkey table, where other guests on the =
same hypervisor
> would have the limited one. In that sense, its an extension of the IBTA=
 model for
> non virtualized nodes.

OK, maybe I'm not getting something, but I'm curious why we always pick
the full pkey in preference to the partial pkey.  Shouldn't we pick the
pkey that's appropriate for the vHCA sending the message?

Also, given the rule of least surprise, don't you think it would be best
to rename this function ib_find_cached_full_or_parital_pkey and in your
next patch instead of naming it ib_find_exact_pkey just call that one
ib_find_cached_pkey?

> To accomplish this, we need both the limited and full membership pkeys =
to be present
> in the master's (hypervisor physical port) pkey table.
>=20
> The algorithm for supporting pkey tables which contain both the limited=
 and the full
> membership versions of the same pkey works as follows:
>=20
> When scanning the pkey table for a 15 bit pkey:
>=20
> A. If there is a full member version of that pkey anywhere
>     in the table, return its index (even if a limited-member
>     version of the pkey exists earlier in the table).
>=20
> B. If the full member version is not in the table,
>     but the limited-member version is in the table,
>     return the index of the limited pkey.
>=20
> Signed-off-by: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cache.c  |   14 +++++++++++---
>  drivers/infiniband/core/device.c |   17 +++++++++++++----
>  2 files changed, 24 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/=
cache.c
> index 9353992..0f2f2b7 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -167,6 +167,7 @@ int ib_find_cached_pkey(struct ib_device *device,
>  	unsigned long flags;
>  	int i;
>  	int ret =3D -ENOENT;
> +	int partial_ix =3D -1;
> =20
>  	if (port_num < start_port(device) || port_num > end_port(device))
>  		return -EINVAL;
> @@ -179,10 +180,17 @@ int ib_find_cached_pkey(struct ib_device *device,=

> =20
>  	for (i =3D 0; i < cache->table_len; ++i)
>  		if ((cache->table[i] & 0x7fff) =3D=3D (pkey & 0x7fff)) {
> -			*index =3D i;
> -			ret =3D 0;
> -			break;
> +			if (cache->table[i] & 0x8000) {
> +				*index =3D i;
> +				ret =3D 0;
> +				break;
> +			} else
> +				partial_ix =3D i;
>  		}
> +	if (ret && partial_ix >=3D 0) {
> +		*index =3D partial_ix;
> +		ret =3D 0;
> +	}
> =20
>  	read_unlock_irqrestore(&device->cache.lock, flags);
> =20
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core=
/device.c
> index e711de4..a645c68 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -707,18 +707,27 @@ int ib_find_pkey(struct ib_device *device,
>  {
>  	int ret, i;
>  	u16 tmp_pkey;
> +	int partial_ix =3D -1;
> =20
>  	for (i =3D 0; i < device->pkey_tbl_len[port_num - start_port(device)]=
; ++i) {
>  		ret =3D ib_query_pkey(device, port_num, i, &tmp_pkey);
>  		if (ret)
>  			return ret;
> -
>  		if ((pkey & 0x7fff) =3D=3D (tmp_pkey & 0x7fff)) {
> -			*index =3D i;
> -			return 0;
> +			/* if there is full-member pkey take it.*/
> +			if (tmp_pkey & 0x8000) {
> +				*index =3D i;
> +				return 0;
> +			}
> +			if (partial_ix < 0)
> +				partial_ix =3D i;
>  		}
>  	}
> -
> +	/*no full-member, if exists take the limited*/
> +	if (partial_ix >=3D 0) {
> +		*index =3D partial_ix;
> +		return 0;
> +	}
>  	return -ENOENT;
>  }
>  EXPORT_SYMBOL(ib_find_pkey);
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigAB7913E67ACA28D07BBF9ACB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQT2xPAAoJELgmozMOVy/dmM8P/AtZl3BbZ67YKBiE+JD6f5pN
uJkJsfmCpbxqOX3P0/xPO2tj8y0yoUFDeSzS5ITitSU5/BDnpP7KFFd2bRkznN9e
BqLwCSq6pBzuJzQhy+Oe69L51J12k92SKLzvSPuq9hLacZ72xmgVIUBQA59bdOdM
iNgNC2eyUSaTw9GaJeGiv1gxLLBwKmaBqjFO+gTAcK7TUlAhUsL942MScCtBVk+5
guw0/tFTqBpgaRxQflcMurGt/rsDlGsQ6AQaeVmzxyrTTNus6THXJiwh/Oh9Xtq0
ZXIqBJ7vKeRwnuX8kJ2Qzcj+yOvNyTVcGlef7KG2S7Vxl7NvXs9B9uvertAVVLJf
bL06BbpvF9UiLRn1B+a4k8wcNFhKfYo9JotyTrfIDdWQZVpbmhjcYm6GoLThPqt4
cxWaX53hHulmhNk193i+6C/qCwpNT4/S1EbeZY1CmxK7EUOZkWD8aJ2iuqMzyvQp
gYlz3Uw8m2MFIWMIxNYs3x6x3dosSLOcHEEmt8nKHOW056rYuEXzBLbNq1Lei/eN
QosBMhPyU27kglFpMu0ev/aQVkzWhVaARIUIeMBbNV8yLNeC90i6xxCXLO1J/Pp/
Lm3O6wJirnzkyP+9dNezZMhHQ7sDlmKbMjr0r0j79d5VhtPrVKqNSVAvTMEGamWl
KjODSRRcA5pJZe3r7aWI
=GLI6
-----END PGP SIGNATURE-----

--------------enigAB7913E67ACA28D07BBF9ACB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
