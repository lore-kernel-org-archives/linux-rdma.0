From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 7/9] net/mlx4: Do not call pcie_print_link_status()
Date: Wed, 8 Aug 2018 09:10:21 +0300
Message-ID: <20180808061021.GR13378@mtr-leonro.mtl.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
 <20180806232600.25694-1-mr.nuke.me@gmail.com>
 <20180806232600.25694-7-mr.nuke.me@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806232600.25694-7-mr.nuke.me@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 06, 2018 at 06:25:41PM -0500, Alexandru Gagniuc wrote:
> This is now done by the PCI core to warn of sub-optimal bandwidth.
>
> Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c | 7 -------
>  1 file changed, 7 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbaolMAAoJEORje4g2clinfugP/iITkTHH34v7JIFBRMNf5eJO
x/u7soOhVxwjlcx2sh80ibyFi36V/t9gzGK0UWRMFRLbpEsSUUZJESKiePQbqVeH
f3EuwTrgi4pO80WyDev6/OlitwGJ1K73qdFKB5ZiwwZ4weXhvKwR1rscIac84AFf
qFQ7f7nZOXmvgQS99tjgOV/K5DOMe+2ZApknkDFf0rjShVIzHmlaxIpv7LFbLJuM
ubA3BzN+tlSu6olsE/OGGcqOm4LYaa0IAZW9Xy1zDal1QcWCF5jHGRvzYMCbsPT9
ma6SMEhwdLXSQwX0Q5NtZIaKA50uGLvPrEvIt2s+AEAsDen6STm/itMt8Eo6eLz4
nwMEmIQYPEbS+y5pOrsFnFDx+EcSkMX0Hr2qOKvhVLfJ5+HoKQG0I0dhiaYC7yAB
Qth+068qGKos5r2Yx4z4xht+cF4Zgo1w5P9QXxpJRtMyRZZ/cH9ofaihxm8YzjtE
lSVHjfmwbfPkM17A9r7NQXk6NagBxQ4ZBnl4ryxUxJG5FaXJrbpbgNuO0qIA5Z4m
gy72uCrcmisYp67BjVgJqYU4O2lBMz6sWa0ZgSqyNB8f636Zps2jvwTpMOjBxdt5
huhp40WQOcOUl/rLAOIMgeFw+ElVe5Y9/ucSnAvOZ3//PLhETY6cmMCiSIeGbDrK
FyMgiAXS6gfUn1oITAKu
=KHMZ
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
