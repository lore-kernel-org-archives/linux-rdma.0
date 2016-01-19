From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] net/mlx4: Remove unused macro
Date: Tue, 19 Jan 2016 15:58:15 -0500
Message-ID: <569EA367.5080603@redhat.com>
References: <1452786487-30438-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6PhHl2RTjQoW02uSf2nn6QgsPa0bEawUT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452786487-30438-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6PhHl2RTjQoW02uSf2nn6QgsPa0bEawUT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/14/2016 10:48 AM, Moni Shoua wrote:
> The macro mlx4_foreach_non_ib_transport_port() is not used anywhere. Re=
move it.
>=20
> Fixes: aa9a2d51a3e7 ("mlx4: Activate RoCE/SRIOV")
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/linux/mlx4/device.h | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> index f70d210..6309ff1 100644
> --- a/include/linux/mlx4/device.h
> +++ b/include/linux/mlx4/device.h
> @@ -982,10 +982,6 @@ struct mlx4_mad_ifc {
>  	for ((port) =3D 1; (port) <=3D (dev)->caps.num_ports; (port)++)	\
>  		if ((type) =3D=3D (dev)->caps.port_mask[(port)])
> =20
> -#define mlx4_foreach_non_ib_transport_port(port, dev)                 =
    \
> -	for ((port) =3D 1; (port) <=3D (dev)->caps.num_ports; (port)++)	  \
> -		if (((dev)->caps.port_mask[port] !=3D MLX4_PORT_TYPE_IB))
> -
>  #define mlx4_foreach_ib_transport_port(port, dev)                     =
    \
>  	for ((port) =3D 1; (port) <=3D (dev)->caps.num_ports; (port)++)	  \
>  		if (((dev)->caps.port_mask[port] =3D=3D MLX4_PORT_TYPE_IB) || \
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--6PhHl2RTjQoW02uSf2nn6QgsPa0bEawUT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqNnAAoJELgmozMOVy/dlX0P/A8MEe0wxo32bkG7IX/9VZMG
QhrMb4Av/zR6FtBLoMC6j2pbJO4FgQsl7kEJW/vsxaBenY/EKri3nbMV03KM4M5+
sucEa1piGYF2I4imuhLGg26zis2kuVj7PSt2gGqxgFbrSE4Lj9/kAOsbtQ2QOyMQ
Pj0RLTp2SIt7SFFbanPxUrtABb/FxCl5WHX2bED8OF1wnDs+2Qb9P1PaaC7igQC5
NzAqNFOTmw+jmqfl27OvkwYn19VFcX0fzzRtWDiRVcKUwh53WIT071aovgTHNEwz
m+u050ZLgvK8VvTrWEsiKjdb4rvhXt5nQy73sWQoXXmvodmkeby4uVSgsAyWnBzs
NwmLOKH/w3PdYW3RuY6LvfrsXhVbaJP9J7qoGwhSmjfM2SRhF3HBukS0mlcW2Zqm
GlMzsNRPJ+pVZWyP5zReAk7gdXxeoygZAt2ezNTpHKiwpD09SUNuF4JVQh2TVC6h
RZOJ2tLtnZiyRO13eDTXNz/MK4GobJXblUScTF5Hzzx6JqQ9YKlzkyiZHUqcyru0
+tonrKfW1U+2lfpXFRFQs73UXyITSu7e5K4m+P9zMMznulIK4kwDGp++VTF/7tYb
5Yza2BGEMO5uKXYWlZAvUZ8spuxvlvW2l2gqeyk+tz+CCqfwwIxZJgQ+wYw/ibDs
9quHj9c+iWqoE70CyWRd
=qxK9
-----END PGP SIGNATURE-----

--6PhHl2RTjQoW02uSf2nn6QgsPa0bEawUT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
