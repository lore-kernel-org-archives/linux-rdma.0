From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 for-next] IB/mlx5: Add UARs write-combining and
 non-cached mapping
Date: Fri, 13 May 2016 18:55:11 -0400
Message-ID: <70548f9f-a7ca-2b4d-80b4-b13232080a24@redhat.com>
References: <1461764990-549-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EHWOfInefqoHU9RBnWPQeA70xKNMQLf77"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461764990-549-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EHWOfInefqoHU9RBnWPQeA70xKNMQLf77
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/27/2016 09:49 AM, Matan Barak wrote:
> From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> By this patch, the user space library will be able to improve
> performance using appropriate ringing DoorBell method according to the
> memory type it asked for.
>=20
> Currently only one mapping command is allowed for UARs:
> MLX5_IB_MMAP_REGULAR_PAGE. Using this mapping, the kernel maps the
> UARs to write-combining (WC) if the system supports it.
> If the system is not supporting WC the UARs are mapped to
> non-cached(NC). In this case the user space library can't tell which
> mapping is applied.
> This patch adds 2 new mapping commands: MLX5_IB_MMAP_WC_PAGE and
> MLX5_IB_MMAP_NC_PAGE. For these commands the kernel maps exactly as
> requested and fails if it can't.
>=20
> Since there is no generic way to check if the requested memory region
> can be mapped as WC, driver enables conclusive WC mapping only for
> x86, PowerPC and ARM which support WC for the device's memory region.
>=20
> Signed-off-by: Guy Levy <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Hi Doug,
>=20
> Currently the kernel UAR mapping interface provides a best effort
> mechanism in which the caller simply invokes one mapping command which
> silently maps to one of the memory types (write-combining or
> non-cached).
>=20
> However, the user space library will be able to improve the performance=

> using the appropriate ringing DoorBell method according to the memory
> type.
>=20
> This patch adds two new mapping commands which enable the library to
> get an explicit mapping type.

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--EHWOfInefqoHU9RBnWPQeA70xKNMQLf77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNltPAAoJELgmozMOVy/dbJQP/i0FULoeugPVfCYVf1wgh/e7
1a6vO5qaP6Oj5MsZBr5YOADB9oD/6i5s08l/p1krZMkzoAlfbPtWBzSCM4UugIG4
KaQJt9ItXVoiPLGIG8k8+8V3As40Wau/nM3DZy1KDlqM20evE/mq3VvkLj702eMd
at9f7peCD7O146UFAIAO6q+/ICCuQsZ3qyVxzG2+wKtWI/gnzF3vL1ZtbrmUarxE
NMHNH6ayWAjS+AMF8CAABKaPCIn5w0wWExvTeyR6arUzHRqDaFMcCru6CgJ4A3oq
Pm7VwaZseaR0T+6rI1XVIb3hQt9OyRxdsUaguvAu/DdgZ91BXbf38h+f16in6Wfy
j0tPBQuqlyxnGtqYWc8vrMTU9Fvy0Vtu6us+3MWSvpZtEnjPD5caZ+lsKphIsRHR
cNd7Qv/z9AVgF+igpg+lraJzWnywcpXDjBpG8RnxFDFcmDFcBHTdka2S2C3bdzZE
nwxWQD705wW4WpHwIHFsBt/1k/91wxLWRx7MsD8ZNMpdvjzRipCEsIHz7cTI2em3
si2cSTeyYpEVPQNnKSyQ6hYVatIAwv5QUESX0iFzYadTTUyAM0AkA8OTorhOJnau
0OTsNJxpQE4W4FsR0uGlNkaJ3hCpWYrEBsOgfY34X4/5oAhmQzx6ZRt4uC+ThLHm
hi4Fn6I5yZM/HwiWP23k
=rFPe
-----END PGP SIGNATURE-----

--EHWOfInefqoHU9RBnWPQeA70xKNMQLf77--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
