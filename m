From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH v6 6/9] ixgbe: Do not call pcie_print_link_status()
Date: Tue, 07 Aug 2018 10:51:49 -0700
Message-ID: <5c5e532859f4322cd6f8d15af1fad47231aaf95e.camel@intel.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
         <20180806232600.25694-1-mr.nuke.me@gmail.com>
         <20180806232600.25694-6-mr.nuke.me@gmail.com>
Reply-To: jeffrey.t.kirsher@intel.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pPzt0jonzh3gyG7n0GJr"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180806232600.25694-6-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Gagniuc <mr.nuke.me@gmail.com>, linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com
Cc: keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org


--=-pPzt0jonzh3gyG7n0GJr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-08-06 at 18:25 -0500, Alexandru Gagniuc wrote:
> This is now done by the PCI core to warn of sub-optimal bandwidth.
>=20
> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 26 ---------------
> ----
>  1 file changed, 26 deletions(-)

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--=-pPzt0jonzh3gyG7n0GJr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAltp3DUACgkQ5W/vlVpL
7c5JQw/9Fo7T4k0FAjGAyShZDwDb7xKB9kdLlyat5WsUfbW1EYdHwfc0U0nd3KeB
QGUyMPIwqDi6tSTCJmIyHozKALqwY4ukd7ei6Thkap3NN8AKlUbiAuZtbFbpvbp/
3lOEph9Qqsu2ECAz8YYrpd3cEiyPdPmSaPOJCC6evWd9NKeWE5LQ/oqxR4I9+nVx
zjnUfyiUuhdwQpPVyo61V4b/OeQZJK2vhWjFzSFU4AJpm1Ieb+e9dZnZE/rTbXN6
pT4BonB7lB0LNLi5tuYTIODkYWoh/aOfjP1oPXApQRvUlw7KaUYVWCkIhta4R1Kh
gPstjHJe2nn8vYsAeId9m5+t+g0G6RfpD9KtVDidsCCDAZe0gOW4SzA4aE3pBGb2
DwArJ93VxqhGdNc+Ll1GyuMRBB4quwoaAAQDdDd18OwXivYZ1kHrZIOpjj9rANia
wGRyimWjpEmLg9OZbvHypsUc5bC8Nd36WeZJeEMNtcLaCJRBoxeoaRgwVTGqNYiU
/EGMNnKE5OuLlwfHt8t0rFwz+4BAVIm+SKwYN5SXN6EjC2y0HlXE8OmdPkXLf7oL
S0FEm3v6TB0KeQJpxZ7WBjAKK9TBoXMvf7M169DtQKJ18M2OnOhUQ8pIC+/vnGh1
ALsptbV/M0dQiHEL8fj2DtchOLS9p1D3ccQ6VWMPtE2hTAEwtmI=
=iqdT
-----END PGP SIGNATURE-----

--=-pPzt0jonzh3gyG7n0GJr--
