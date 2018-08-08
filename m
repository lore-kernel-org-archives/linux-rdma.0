From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 8/9] net/mlx5: Do not call pcie_print_link_status()
Date: Wed, 8 Aug 2018 09:08:48 +0300
Message-ID: <20180808060848.GQ13378@mtr-leonro.mtl.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
 <20180806232600.25694-1-mr.nuke.me@gmail.com>
 <20180806232600.25694-8-mr.nuke.me@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2hMgfIw2X+zgXrFs"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806232600.25694-8-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org


--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 06, 2018 at 06:25:42PM -0500, Alexandru Gagniuc wrote:
> This is now done by the PCI core to warn of sub-optimal bandwidth.
>
> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ----
>  1 file changed, 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--2hMgfIw2X+zgXrFs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbaojwAAoJEORje4g2clin/HIP/2W8reNA2ST0qw9ktcqoAtM5
XQKIgyD8DVxLkj0MjeQ+bzCpWwHzhNzXWMp+roOdvwhZSFav1uW+KyFidPn+r/0Q
6OR57qkoWv0Z/+35kFu5XWcSXg0g+3AzdukC42x6icE9zJKHzFIOYP5Q4AxUwNG0
ucAaouLXgioVQEyl64H7LgTzQNaUXPNb4zX8SaEtPBBeE1q0bo1LqBLLfUxRlGb8
LcgkPpKcDoLM5MKZVWmPGPR2S0imdDgt7K/1d8QvW7obq02dkwCLUG6DRw2qjLdC
K9heg0zilZlS2/fpzxIgrBTmdrSVxTU3ThEYF6h5PHcJTAZ3QNo8BYOmpG0Htic3
/QT317O6cM/gEZbySsBxGMJHa/li/5+Btv7e1B1lsoARsIuZsuEYy0giK5c1rqx0
pgD2miV4TnJdOmqvImtsrLQQF43PE9oemIYvhRIuItEDPWBEU6eElnQoGiH23RXE
l4X1NVruTJzEpEkirzpkdQ1GdsL82AXeil1QO0iD/f4+4j04mDbzRoVeYFLO/OM1
qRTZhfvydrbQIzP4zw9yWVqxbqHiRoEMjyY0vfD0lvnhq+8shcWFeFQLzBGOXDSn
sqFSL7sFxAG3VcnWYwEiBvacuuEr4vSMCgbm9rvhBwXzNFp5XT3v02eYvgQ9P6Lr
ph6iCl9z86ww3oO/AGmo
=I8Ry
-----END PGP SIGNATURE-----

--2hMgfIw2X+zgXrFs--
