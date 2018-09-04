From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 7/9] net/mlx4: Do not call pcie_print_link_status()
Date: Tue, 4 Sep 2018 15:51:08 +0300
Message-ID: <20180904125108.GE2796@mtr-leonro.mtl.com>
References: <20180903180242.14504-1-mr.nuke.me@gmail.com>
 <20180903180242.14504-8-mr.nuke.me@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="utUizcr4eQAkV3Ky"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903180242.14504-8-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org


--utUizcr4eQAkV3Ky
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 03, 2018 at 01:02:34PM -0500, Alexandru Gagniuc wrote:
> This is now done by the PCI core to warn of sub-optimal bandwidth.
>
> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c | 7 -------
>  1 file changed, 7 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--utUizcr4eQAkV3Ky
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbjn+8AAoJEORje4g2clinjGkP/jCPp9UzQgvYbqPCf4Gse/bM
v4sDzUw1p4vsseeu+tUvImwsGaOKBdXLBXh0yyx0DEePtXAnA+Y9l2ZECBAnqRze
x88FJOZiut8n/OZCXuh34d9UgUuK4nZel9l+R5V6OE1Bw7Hvd5CDN+DELpawQxQS
RW1CI9A0gyzNZuVaquR8ZIPPH03HJPAvY8xSWum1u7D+mQC1s3PvBAHo/1U+f9tO
zWYo3ohY5TEC0ug0IENE1Y10PhAMkF8W4W+y9DO2/FYbycbP73rOpmO8k+sWZ9QS
l02bTVuCEnSzTamZ4s3Rz0uURBCdrq6mjluKRiVbDqArJ2l5APsXjptsjDfP9Dox
BblZ+oc4LfEOzpb2dYHWhSbFJWzIn9p+DkS9Y4ur/5HXAQsHmE4CkY03U0UE6H0k
Xn6lOJD6QkZ3hZu6M+y4iU+eZGOX4cH+K93AvLMtReXrQHJIxKd8Iyk14jpNc4JO
AnDhiDjSURIISQwEBWVx8EselbI7S4o2DzWic4lDJhPjFjYhtDcsH9D65eB1IIVR
4c+OGQ+lYHgUVxshx+XM+VlTjxev72ZE9vS+tOzZdCND01c2uUDQeCDZTJW6VFnn
u9B+NQ77G035Yn186RhLQkbIJHBGRF8nvX4KTEjRErry5BD+yqrgKz115P8y6F3X
PhbXQE6O7fllfTO/Vqe/
=LxEI
-----END PGP SIGNATURE-----

--utUizcr4eQAkV3Ky--
