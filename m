From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH v6 5/9] fm10k: Do not call pcie_print_link_status()
Date: Tue, 07 Aug 2018 10:52:17 -0700
Message-ID: <263e783d8aa8b50c27d8919d178066367162488e.camel@intel.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
         <20180806232600.25694-1-mr.nuke.me@gmail.com>
         <20180806232600.25694-5-mr.nuke.me@gmail.com>
Reply-To: jeffrey.t.kirsher@intel.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-J5aSTQDattGGpjY4QXtq"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180806232600.25694-5-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Gagniuc <mr.nuke.me@gmail.com>, linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com
Cc: keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org


--=-J5aSTQDattGGpjY4QXtq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-08-06 at 18:25 -0500, Alexandru Gagniuc wrote:
> This is now done by the PCI core to warn of sub-optimal bandwidth.
>=20
> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> ---
>  drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 3 ---
>  1 file changed, 3 deletions(-)

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--=-J5aSTQDattGGpjY4QXtq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAltp3FEACgkQ5W/vlVpL
7c7Vag/9HVyuEGVsk8QblGk3urNCoL2kGmQG2Gm4z/7uv5SZUqkWMBTa1n2y+N+U
w3wIC9/eSLz7GOUUEU6pWobU/ORkiPzl7D6yYVMvNLb3eS7InWvKiAvBkF/+e1Ya
ktzRLiacJFGwkavQfYa6ga5suNEC1YA7uf1yZ7yWxsahdLcFrznY7uhmRe+93wLs
jWpMr3HClUj1dUkfqjc3f/C42yALGCOdi328+OrV0APx3063eu73peNoDvbM+oXA
9S+p1sb2pG7wwWs9VHLPjGm3r6Qgl3fyWVTsTmV1KhJRajMq4Dw6/fjGqb219vZE
L3Y5y4MCLoteCQmBIbHBanLOjXG/JYq7CBR8sPZyBcYlYcWRqNJd3DiQGyHS+a8c
NePyrPa6LLIxLEJfUqk0hNWSYiPshc3YipoZhhVFlp+dGNVZZJJ2UKhSZMsweFAw
aYMVh/gjumHM2EJe9AYKob4aCH94KbA0WJfQ79phvr8Z6VS47Ikv3kojAHvmwJe4
FHI+s8adHTvM4eJZePCuhUBoP9rEZDgchnUpZVAoUxvYUeKdopNAwfizTor1Jg2a
QUdfz6SDVqf9sHBzT4ypvXy7A/9mgi/GhY2FisDAl76a2yemkjuOP1J4W2ivpkrP
z0A0LQ6u17Eko9abpm89jFx1qwJEiE9RNtxDjkrzb6DSASzMizo=
=PPMO
-----END PGP SIGNATURE-----

--=-J5aSTQDattGGpjY4QXtq--
