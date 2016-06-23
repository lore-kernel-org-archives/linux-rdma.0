From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Report mlx5 TSO capabilities when querying
 device
Date: Thu, 23 Jun 2016 11:12:50 -0400
Message-ID: <fd3a2f12-6299-60a7-d1d8-8f340932a749@redhat.com>
References: <1466164940-31400-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S9JDo68M7g6GwhjoIAreMwATbtJntRaf9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466164940-31400-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S9JDo68M7g6GwhjoIAreMwATbtJntRaf9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/17/2016 08:02 AM, Leon Romanovsky wrote:
> From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Enable mlx5 based hardware to report TCP segmentation offload (TSO)
> capabilities from kernel to user space. A TSO enabled NIC will accept
> big chunks of data with sizes greater than MTU for TCP traffic.  The TS=
O
> engine will break the data into separate packets and will insert header=
s
> automatically.
>=20
> The capabilities are exposed to user space through query_device by uhw
> directly. The following capabilities are reported:
>=20
> 1. The maximum payload size in bytes supported for segmentation by TSO
>    engine.
> 2. Bitmap showing which QP types are supported by TSO operation. The bi=
tmap
>    is built by members from 'enmu ib_qp_type'. For example, similar cod=
e
>    should be performed if UD QP is supported:
> 	supported_qpts |=3D 1 << IB_QPT_UD;
>=20
> To make user-space library aware of whether kernel supports uhw or not,=
 a
> new flag: cmds_supp_uhw will be returned back to user-space through
> alloc_ucontext.
>=20
> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This has been applied, although it didn't apply cleanly.  It's slated
for 4.8.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--S9JDo68M7g6GwhjoIAreMwATbtJntRaf9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa/xyAAoJELgmozMOVy/dM+UP/i5NuGiLbeh8WZsbD6y+1jYt
H9No+Qe1VNcGZN8YYedTyi8VKl7QfMsHV2JzfjucdnbuKtuqR5c5+uUQLhw3pq0U
Y5oo67EVs4ZCFldYW0Tsi8tBuLjTcKt4K9uDTRHAgS6c2gF+pqLh90RkkF1cLILM
zVB3pU+ZiNAl2gT86TKtaSkJmxVdI71IIPmvLiCLeVrZwVsG7Xg9dDvJXWkBS6TE
GABZUZaiFY6AEDBcjQMLxCJlqHgoDey7liMT5/A+lCjTI54v91HvkUWNXl0pjRth
gGRXXHJCtoBm3hRXzwZcO5NMukUCKXmYS46ksT/Ia8PEkn1NPKK1Juf/W/KsOXuo
tFKdZWjWt9pb2gdy1avMDdDvDBUfWae2onY6C/yaGxXjd1YqvrG5xN6M6bGR/i/B
lwvteYNt3aWEgmBn9iuiidOQ4YSRNKLxPt5b+GOj3CcnIwa+JcAoivD8zQru/yrz
Ffv6WaiBafcawIOo2w7FMk+E/9+QH8EVxlWLTrL5qxW2s7nebLi/SL+w2rdL/LF9
dE4Upyy0ohAMFqqU7dblh2Brob2L9euZKg1yDq1VmHyuIEakDymWKut68tUs+CJo
LQ3Gc8cbTU2z/VjJQ13fuX0ZOXl9rB1h2ohIWnmuj/t/me15OtTouo9YT4n6MVgt
a5tp5ApQfKCL1rk/Ry6S
=hFpA
-----END PGP SIGNATURE-----

--S9JDo68M7g6GwhjoIAreMwATbtJntRaf9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
