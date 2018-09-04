From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 8/9] net/mlx5: Do not call pcie_print_link_status()
Date: Tue, 4 Sep 2018 15:51:25 +0300
Message-ID: <20180904125125.GF2796@mtr-leonro.mtl.com>
References: <20180903180242.14504-1-mr.nuke.me@gmail.com>
 <20180903180242.14504-9-mr.nuke.me@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zKD0QXBepZ0ysD7Q"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903180242.14504-9-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org


--zKD0QXBepZ0ysD7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 03, 2018 at 01:02:35PM -0500, Alexandru Gagniuc wrote:
> This is now done by the PCI core to warn of sub-optimal bandwidth.
>
> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ----
>  1 file changed, 4 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--zKD0QXBepZ0ysD7Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbjn/NAAoJEORje4g2clinvdIP/1XmGCCJjlghx2pUotnL9h17
mR3f+K0cueebvFKq6dvEnK7HwzxU0FZ7dLxgkBcNzEGmT2wHU2sqAjOPGQDJAm8j
i08jEixwBvkt18wJgBaIszwThxDVCqeMIygsdeVKJ1cz5KyWjJ2S3k2S7k3OVP1W
zJgJx5pYiGgaMDuM/NAgWNn+Vq0Ra/rrVtYVxxcfpZ5P0Pvw0FC+nFqrtpkyra3f
VROx2cxjIco9QaukhPan65dV6GTVQkVmOjxj7S+4gGuTAFcpWknpKE33QujPprEP
YIwvql4uaJ1UDitfj6iiKHPH+1BK4uEQycvX5I0XeZQVkY04NcmcQEYi2WJSFmGu
vqf1W974lKR08cEwsmJSo4FRZSpBtWO51bcuGI9/DsU4KxbjrlX5OvxmsEiStBh4
fLeaSLRolCfUZD0aEa2/GcYxxmnVcDujt8UeQbUqGY+BkdZZaUTVi/vh2JaSaMis
SIbR6UN1E0BKutTPmBiG1XWNyr6SDF9rkVZInvTbEfofT/aFsbCxVeSD6QdbysJJ
cr0ylqouKVWat5m5FgAL86QYyno9NNDfOKgjRI/Q6FdgglHh2G2mYc7jUlgNuvCj
B7jOdxO12I46ql2DNbnmdyHjlJH/aRgrnGpdTxH6lhtl81Z/GlENm+HIX0PuVmN7
7DzWa4DghmRtb3Dq/L5A
=qx2/
-----END PGP SIGNATURE-----

--zKD0QXBepZ0ysD7Q--
