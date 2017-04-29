From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2] IB/i40iw: use setup_timer
Date: Sat, 29 Apr 2017 09:45:27 -0400
Message-ID: <1bf32409-ac2a-0b14-19db-896e146db23f@redhat.com>
References: <d2a4d5220abf014f8e5629a7217eaa71262199fd.1493188028.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="etx2PeRAsn0PVItv2iJAjUsvLUh4T4w1A"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d2a4d5220abf014f8e5629a7217eaa71262199fd.1493188028.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--etx2PeRAsn0PVItv2iJAjUsvLUh4T4w1A
Content-Type: multipart/mixed; boundary="s5K61G73uSICSJ1SebDhJEgxDUhOSkFTU";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Geliang Tang <geliangtang@gmail.com>,
 Faisal Latif <faisal.latif@intel.com>,
 Shiraz Saleem <shiraz.saleem@intel.com>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1bf32409-ac2a-0b14-19db-896e146db23f@redhat.com>
Subject: Re: [PATCH v2] IB/i40iw: use setup_timer
References: <d2a4d5220abf014f8e5629a7217eaa71262199fd.1493188028.git.geliangtang@gmail.com>
In-Reply-To: <d2a4d5220abf014f8e5629a7217eaa71262199fd.1493188028.git.geliangtang@gmail.com>

--s5K61G73uSICSJ1SebDhJEgxDUhOSkFTU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 4/28/2017 9:37 PM, Geliang Tang wrote:
> Use setup_timer() instead of init_timer() to simplify the code.
>=20
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> Changes in v2:
>  - use setup_timer() in i40iw_terminate_start_timer().

I already applied your previous patch and did the fixup to add
i40iw_terminate_start_timer() into the patch myself.  Thanks.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--s5K61G73uSICSJ1SebDhJEgxDUhOSkFTU--

--etx2PeRAsn0PVItv2iJAjUsvLUh4T4w1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZBJj9AAoJELgmozMOVy/d2C0QALRpBw9KJOCBxzJU466rm59H
YyvSFRq/f/uE2GjSKBx2szb3dNBi991QQynNpp8II4WUDAHd9P9jySzxgLJgOXnk
IfkrgtrI9W2X6HJ9t25Eu1bIV0aVnpDybXzVJ+qoZNw3APuo0FusJmro+TB6ruWu
IV0HoA8HciUHib/zLB3YLjL/MTz8CEYyZNT8cB+4ClcffMi7V0p17uqQ8EJ//6p8
IIqoybkwcpqfv3HeUeGyDrt7kaFdiPdqbaVEVCBezIjeLksOnRu1+9IhgksqpZiV
7gZielbnKlv9JvDmszZt124nqWwwQsLcAgpf13CxZsCL03gyrakkfXdzgJdGHmi/
uUYmvBprCTIzyvt2bYlpFCZyoQyeUMlgI3iDn5OkIebtviLO3hJv8y3uJfQeDRe+
1o0i334pEOhrYaEunstNd2duuU5Ue5HC4Jsa3/MC/Z6gM+snvstsx4LQmc6w05Ir
NdnKdI1db8PyISbIem0Y2/nnulwsnUCudYz7CsaJuDoSWKOiSERIJqzCVu7LKfFR
treu091DMST8Batk6M480WgA0v9Ds0Afi+I8yWEl2VQj9dKbDjE6EvI2uUBZO32b
6+MzIB89AFQmp/EnjmMMr8GIhU8ST41n7PjznMY6H9KiiV2iyUWC7h1Ci0SiLq5L
jiDznHJaz1lQ3nwTYy+p
=Ee8O
-----END PGP SIGNATURE-----

--etx2PeRAsn0PVItv2iJAjUsvLUh4T4w1A--
