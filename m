From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 8/9] net/mlx5: Do not call pcie_print_link_status()
Date: Wed, 8 Aug 2018 18:41:42 +0300
Message-ID: <20180808154142.GZ13378@mtr-leonro.mtl.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
 <20180806232600.25694-1-mr.nuke.me@gmail.com>
 <20180806232600.25694-8-mr.nuke.me@gmail.com>
 <20180808060848.GQ13378@mtr-leonro.mtl.com>
 <05056a70-ee78-ea3c-0b9b-6d64a8663b11@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cfJ13FhsvNR/yOpm"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <05056a70-ee78-ea3c-0b9b-6d64a8663b11@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tal Gilboa <talgi@mellanox.com>
Cc: Alexandru Gagniuc <mr.nuke.me@gmail.com>, linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org


--cfJ13FhsvNR/yOpm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 08, 2018 at 05:23:12PM +0300, Tal Gilboa wrote:
> On 8/8/2018 9:08 AM, Leon Romanovsky wrote:
> > On Mon, Aug 06, 2018 at 06:25:42PM -0500, Alexandru Gagniuc wrote:
> > > This is now done by the PCI core to warn of sub-optimal bandwidth.
> > >
> > > Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> > > ---
> > >   drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ----
> > >   1 file changed, 4 deletions(-)
> > >
> >
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> >
>
> Alex,
> I loaded mlx5 driver with and without these series. The report in dmesg is
> now missing. From what I understood, the status should be reported at least
> once, even if everything is in order.

It is not what this series is doing and it removes prints completely if
fabric can deliver more than card is capable.

> We need this functionality to stay.

I'm not sure that you need this information in driver's dmesg output,
but most probably something globally visible and accessible per-pci
device.

>
> net-next (dmesg output for 07:00.0):
> [270498.625351] mlx5_core 0000:07:00.0: firmware version: 14.22.4020
> [270498.632130] mlx5_core 0000:07:00.0: 63.008 Gb/s available PCIe bandwidth
> (8 GT/s x8 link)
> [270499.169533] (0000:07:00.0): E-Switch: Total vports 9, per vport: max
> uc(1024) max mc(16384)
> [270499.182358] mlx5_core 0000:07:00.0: Port module event: module 0, Cable
> plugged
>
> net-next + patches (dmesg output for 07:00.0):
> [  331.608472] mlx5_core 0000:07:00.0: firmware version: 14.22.4020
> [  332.564938] (0000:07:00.0): E-Switch: Total vports 9, per vport: max
> uc(1024) max mc(16384)
> [  332.616271] mlx5_core 0000:07:00.0: Port module event: module 0, Cable
> plugged
>
>

--cfJ13FhsvNR/yOpm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbaw82AAoJEORje4g2clinSrcQAIG8XlaVMnqmX9ZIn10cfkoz
lngbzsg4KBPfVjhswO/NwYTa6S9Q0E8rMqGZJ1oWW9lPkiNJHxf6eK82lRerJmER
Le5Bx6uUWDXPUg5UV1cpSlC6VwOW3oBrlo0EnHJRYK7mmLNnQJ7yLAGleWTNySpk
S6ZkX3nO4x1a2CjUIxg4d1Jl9m9iP8enQyPsBPTIdgYlH39xFh8NwaQ3fjytErEV
kW/C1K2mKryiSs9ss+xLfS4c7v2BT552DrnwMsOpdVF6zUWt8a2yA0vrQP4G+b+s
q1s1i1SCHVGiDXT62T8lAL3p/sTf1k8ERwJHhxNuVlPc+cuC1rUt8MJ8my+DACbk
JqPhwo+HSKDGphsUTbrJ0Hc9f7PW9fv+nRDrciE/9Q/0tBj5zVR+kh+53EJzJcEW
q1wXpbh26dYdeo93Ki48a9kmJJ/mjlRn6ma1TfAgaab6Ct//rIBhpkDt1eOUn773
xoiXVNdwRWzQTFgeeWiA8pebyUU+e08gZSvhHyQjT0d1WWpZQMmVpUJ2MKCdaHF9
8kNsjww4h/F9PozSYlvQwduxp+3F+D/K656TC0rtAUvCRKsfynZWfRIb3KlBIWnE
7uTCDmvmLLf6W+8tVWY0u9obmtVHkcyvkUEPElyhfVazdw1dLue2UigdNN2SN7Y+
YY+vEw9UQ/ez/RY9zQD6
=/LzE
-----END PGP SIGNATURE-----

--cfJ13FhsvNR/yOpm--
