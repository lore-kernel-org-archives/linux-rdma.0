From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for rdma-next] RDMA: Adding ethertype ETH_P_IBOE
Date: Tue, 10 Jan 2017 14:05:33 -0500
Message-ID: <1484075133.2149.26.camel@redhat.com>
References: <1482175726-27366-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-rZwGR7Ax1OJE/tyvq49j"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482175726-27366-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-rZwGR7Ax1OJE/tyvq49j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-12-19 at 11:28 -0800, Selvin Xavier wrote:
> Update the if_ether.h with the=C2=A0 ethertype for Infiniband over
> Ethernet packets. Also, removing the occurances of 0x8915
> from infiniband vendor drivers.
>=20
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-rZwGR7Ax1OJE/tyvq49j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYdTB9AAoJELgmozMOVy/dluIQAI+51AVK0iwiGB21oSI5XOhf
leGoIjRp9XxrbJRvNx03YmaBXaEcnZZ1MSsSyy6pNF2lRy8ZIC8yvR6+VpwW/FE6
Njnl9eNqjxSYeIbUGAb5Imybm/KQ4Klb91ofCbB/5PTqFMRck2pnJtxKqdcskK7P
ouxYoLehHtWgxmKIulJagRQf+j6+ZHVuKPg0vw7E2iwZwABYYUHVq4H7l0eoMS/m
avXsntEcKM9ztgfUWCj+Hpts+ouNNr2XNp+h5Z6DXgUgpM8eYtaX80fpfRI4urbj
yZA8y8sRC9ZNzw7r2uPuJs2Vk1Q522NG6RXGkEoyN0b1K/4v+Uyf968repkLCm/9
GS1tCoB9byD+5kOTNaQZq1xfF/gA2FwZe8l++eR+aTbbAuUh2OvXNDfV0c5vFT2/
o2rvXjVo+fDzOxXUQ/pD7QoO7Kv2u5CXfz1abJTT8GqVYyu/VlFdcdSSS8ohW4pv
ObfAXpNRfLt05KfHqTS4wzccMdZUgsPr5IhNHWqMC5qso9tiBD+N5UVoYoM99L9W
72/R8Nrr/24UsJFFtOGzxXVhojtzXJf7pSSMbHThS6UrNbuK3a5zxszrfxlL+XvA
nZ0NZgg3QkKGFJBRmwMgmI8t2b4tgBpERG6whfamU4Wf0ikrrfcgv+FW04CaTBRT
akeF8A93pelYUf87bHx/
=MTJC
-----END PGP SIGNATURE-----

--=-rZwGR7Ax1OJE/tyvq49j--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
