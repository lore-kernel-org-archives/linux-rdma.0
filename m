From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/core: Fix two kernel warnings triggered by rxe
 registration
Date: Mon, 25 Dec 2017 12:28:39 +0200
Message-ID: <20171225102839.GD2942@mtr-leonro.local>
References: <20171222213852.3481-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrxji9MxLi9YGTOD"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171222213852.3481-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--yrxji9MxLi9YGTOD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 22, 2017 at 01:38:52PM -0800, Bart Van Assche wrote:
> Avoid that the following two warnings are reported when registering an
> rxe device:
>
> WARNING: CPU: 2 PID: 1005 at drivers/infiniband/core/device.c:449 ib_register_device+0x591/0x640 [ib_core]
> CPU: 2 PID: 1005 Comm: run_tests Not tainted 4.15.0-rc4-dbg+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> RIP: 0010:ib_register_device+0x591/0x640 [ib_core]
> Call Trace:
>  rxe_register_device+0x3c6/0x470 [rdma_rxe]
>  rxe_add+0x543/0x5e0 [rdma_rxe]
>  rxe_net_add+0x37/0xb0 [rdma_rxe]
>  rxe_param_set_add+0x5a/0x120 [rdma_rxe]
>  param_attr_store+0x5e/0xc0
>  module_attr_store+0x19/0x30
>  sysfs_kf_write+0x3d/0x50
>  kernfs_fop_write+0x116/0x1a0
>  __vfs_write+0x23/0x120
>  vfs_write+0xbe/0x1b0
>  SyS_write+0x44/0xa0
>  entry_SYSCALL_64_fastpath+0x23/0x9a
>
> WARNING: CPU: 2 PID: 1005 at drivers/infiniband/core/sysfs.c:1279 ib_device_register_sysfs+0x11d/0x160 [ib_core]
> CPU: 2 PID: 1005 Comm: run_tests Tainted: G        W        4.15.0-rc4-dbg+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> RIP: 0010:ib_device_register_sysfs+0x11d/0x160 [ib_core]
> Call Trace:
>  ib_register_device+0x3f7/0x640 [ib_core]
>  rxe_register_device+0x3c6/0x470 [rdma_rxe]
>  rxe_add+0x543/0x5e0 [rdma_rxe]
>  rxe_net_add+0x37/0xb0 [rdma_rxe]
>  rxe_param_set_add+0x5a/0x120 [rdma_rxe]
>  param_attr_store+0x5e/0xc0
>  module_attr_store+0x19/0x30
>  sysfs_kf_write+0x3d/0x50
>  kernfs_fop_write+0x116/0x1a0
>  __vfs_write+0x23/0x120
>  vfs_write+0xbe/0x1b0
>  SyS_write+0x44/0xa0
>  entry_SYSCALL_64_fastpath+0x23/0x9a
>
> Fixes: commit 99db9494035f ("IB/core: Remove ib_device.dma_device")

	^^^^^^ redundant

> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: stable@vger.kernel.org # v4.11
> ---
>  drivers/infiniband/core/device.c | 2 +-
>  drivers/infiniband/core/sysfs.c  | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 30914f3baa5f..b9d7570e9989 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -446,7 +446,6 @@ int ib_register_device(struct ib_device *device,
>  	struct ib_udata uhw = {.outlen = 0, .inlen = 0};
>  	struct device *parent = device->dev.parent;
>
> -	WARN_ON_ONCE(!parent);
>  	WARN_ON_ONCE(device->dma_device);
>  	if (device->dev.dma_ops) {

I understand that it fixed warning for you, but why is it correct?
You are using "parent" in this "if (device->dev.dma_ops)" too.

>  		/*
> @@ -465,6 +464,7 @@ int ib_register_device(struct ib_device *device,
>  		 * The caller did not provide custom DMA operations. Use the
>  		 * DMA mapping operations of the parent device.
>  		 */
> +		WARN_ON_ONCE(!parent);
>  		device->dma_device = parent;
>  	}
>
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> index e30d86fa1855..8ae1308eecc7 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -1276,7 +1276,6 @@ int ib_device_register_sysfs(struct ib_device *device,
>  	int ret;
>  	int i;
>
> -	WARN_ON_ONCE(!device->dev.parent);
>  	ret = dev_set_name(class_dev, "%s", device->name);
>  	if (ret)
>  		return ret;
> --
> 2.15.1
>

--yrxji9MxLi9YGTOD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpA0tcACgkQ5GN7iDZy
WKdE2xAAoTG7bSwt+TtIf/9tUMmi1a85gDT/Aln338R/bw8i4pS7wvnI9zkDb6zC
qZSwFLdg32Z7AgvPxU/H/FGQQP12jxZFbbVNhAffHiGHw9Q56hYpJm8CbV55yvd6
KAMks+VByZ4bCCPhVYYY9y9ahG0g8ooUrU0v/pWIE62Qp3JxBS3+15pez0Hgaz/f
94ybn9JUJ6TCEjNTFC9KN+fyyXcuYADGGOB0ePCWLylzrxp2EXl3DQnEiEZPxbhR
D7BYfiMO8taa/VEAfGM7OVByyelaR7r1MzHUWMHzr7jLTlfiwxa7y/m2ANtDtgD1
12dqjsQuEBQQ6NROuPXOoMuNqe86UBm+7qY9ekxhwxM3B4e1udU8/BOGKDyzQgoZ
hycYCoaJ/rYVmSlIweO6MDvjyDoZ3KAUP0Ww8E0OMfuxwitg4Pq9brE63rtEj5Ai
36FZoPB9kVFTZoNcFRjZ70HLG6ULlUbE7pQtp2sAALK2XsoRfzt96xJwcmsv+shW
IaLfvHST1Y+vKiL3PbuwmAV24dCKB35orF08/pGQc8rLicbfTc2K6ec2zRqvdHgu
GKjhindWmKlH32zANtQvWW7YGrqRtt1/jdute52qVjr07gYyVL5V8+N5DU4bnQQ4
SwuJL5BJKtz7oMNF8wb2A8mZxlfq1oOKi11p8EBPFIRp4s9VI/U=
=BG3f
-----END PGP SIGNATURE-----

--yrxji9MxLi9YGTOD--
