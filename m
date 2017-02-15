From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next 1/1] IB/IPoIB: Add destination address when
 re-queue packet
Date: Wed, 15 Feb 2017 09:54:05 -0500
Message-ID: <1487170445.86943.90.camel@redhat.com>
References: <20170201171005.15587-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-98F2F3DE/6a8QQcfESmR"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170201171005.15587-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Erez Shitrit <erezsh@mellanox.com>, "# v4 . 8+" <stable@vger.kernel.org>, Noa Osherovich <noaos@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-98F2F3DE/6a8QQcfESmR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-02-01 at 19:10 +0200, Leon Romanovsky wrote:
> From: Erez Shitrit <erezsh@mellanox.com>
>=20
> When sending packet to destination that was not resolved yet
> via path query, the driver keeps the skb and tries to re-send it
> again when the path is resolved.
>=20
> But when re-sending via dev_queue_xmit the kernel doesn't call
> to dev_hard_header, so IPoIB needs to keep 20 bytes in the skb
> and to put the destination address inside them.
>=20
> In that way the dev_start_xmit will have the correct destination,
> and the driver won't take the destination from the skb->data, while
> nothing exists there, which causes to packet be be dropped.
>=20
> The test flow is:
> 1. Run the SM on remote node,
> 2. Restart the driver.
> 4. Ping some destination,
> 3. Observe that first ICMP request will be dropped.
>=20
> Fixes: fc791b633515 ("IB/ipoib: move back IB LL address into the hard
> header")
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
> Signed-off-by: Noa Osherovich <noaos@mellanox.com>
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-98F2F3DE/6a8QQcfESmR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYpGuNAAoJELgmozMOVy/dkzUP+wWay2VTvPigtRQP2jHsKSrl
Fh15YLKALOI9dRM4tkTfE3BXgEi2CkhC068hmRN9SaFxZaRfKacV8CArbjj9ZcPG
OsnF75VkuNKiZvXQxHB6GYTQGrZ/lDt4qGiAXpMqeDzmPqS76bPVHUZ64jaC9hiv
u7lWxjt2RLGzEWK5iPNCXVZRcvWP6/JTtrNUUdnbLW9/UR70jzq8kKnTpmVzJATh
xnXLB5a1JRmHfHrxhvknDj1EFhq/2Bb8GXY2zPLCfxq0PeGD64EpOk2NMQ+SdTvX
dRRsRODV/cUO9akPF3xwwieozodY2h1SjGPN+6cGyBA3iKbEXDLsL3H37zF+ErIB
pwNZRs/XNgIomKWMVbxNiLel1+ljzBVfVMvxfHkHHO62Xc0aIp+fMAIaSkU91AH2
Druk6QGzIOdkuCLojYaEib7a4ST6N8GOsYWNXmaMGFHo+CINEjZYeevm1gAppspF
HB053XfVq7sD3giA4B9yI9/Am4OzYvSx6PJtP67AsunV+7xxqHsNd3KzkgExv5e/
igUc4WQvWaNe42bnAisLfCRIcH7NhAbeYnkhJaCJ3jZ4+U1ggv0eoTQSAiND8TDt
RWqntj6bKptmvshRQ65S/wHwaWULfIlWX1dNRnsxhaWTGdA4fap4t2AksCALFrKf
ZI9cPNCZfCHXbTXjSmsH
=Jp7E
-----END PGP SIGNATURE-----

--=-98F2F3DE/6a8QQcfESmR--
