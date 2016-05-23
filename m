From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/cxgb3: device driver frees DMA memory with
 different size
Date: Mon, 23 May 2016 09:10:51 +0300
Message-ID: <20160523061051.GE25500@leon.nu>
References: <1463963529-23183-1-git-send-email-honli@redhat.com>
Reply-To: leon@kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463963529-23183-1-git-send-email-honli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Honggang LI <honli@redhat.com>
Cc: swise@chelsio.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 23, 2016 at 08:32:09AM +0800, Honggang LI wrote:
> From: Honggang Li <honli@redhat.com>
>=20
> [  598.852037] ------------[ cut here ]------------
> [  598.856698] WARNING: at lib/dma-debug.c:887 check_unmap+0xf8/0x920()
> [  598.863079] cxgb3 0000:01:00.0: DMA-API: device driver frees DMA memor=
y with different size [device address=3D0x0000000003310000] [map size=3D17 =
bytes] [unmap size=3D16 bytes]
> [  598.878265] Modules linked in: xprtrdma ib_isert iscsi_target_mod ib_i=
ser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_trans=
port_srp scsi_tgt ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm =
iw_cm ib_sa ib_mad kvm_amd kvm ipmi_devintf ipmi_ssif dcdbas pcspkr ipmi_si=
 sg ipmi_msghandler acpi_power_meter amd64_edac_mod shpchp edac_core sp5100=
_tco k10temp edac_mce_amd i2c_piix4 acpi_cpufreq nfsd auth_rpcgss nfs_acl l=
ockd grace sunrpc ip_tables xfs libcrc32c sd_mod crc_t10dif crct10dif_gener=
ic crct10dif_common ata_generic iw_cxgb3 pata_acpi ib_core ib_addr mgag200 =
syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm pata_atii=
xp drm ahci libahci serio_raw i2c_core cxgb3 libata bnx2 mdio dm_mirror dm_=
region_hash dm_log dm_mod
> [  598.946822] CPU: 3 PID: 11820 Comm: cmtime Not tainted 3.10.0-327.el7.=
x86_64.debug #1
> [  598.954681] Hardware name: Dell Inc. PowerEdge R415/0GXH08, BIOS 2.0.2=
 10/22/2012
> [  598.962193]  ffff8808077479a8 000000000381a432 ffff880807747960 ffffff=
ff81700918
> [  598.969663]  ffff880807747998 ffffffff8108b6c0 ffff880807747a80 ffff88=
08063f55c0
> [  598.977132]  ffffffff833ca850 0000000000000282 ffff88080b1bb800 ffff88=
0807747a00
> [  598.984602] Call Trace:
> [  598.987062]  [<ffffffff81700918>] dump_stack+0x19/0x1b
> [  598.992224]  [<ffffffff8108b6c0>] warn_slowpath_common+0x70/0xb0
> [  598.998254]  [<ffffffff8108b75c>] warn_slowpath_fmt+0x5c/0x80
> [  599.004033]  [<ffffffff813903b8>] check_unmap+0xf8/0x920
> [  599.009369]  [<ffffffff81025959>] ? sched_clock+0x9/0x10
> [  599.014702]  [<ffffffff81390cee>] debug_dma_free_coherent+0x7e/0xa0
> [  599.021008]  [<ffffffffa01ece2c>] cxio_destroy_cq+0xcc/0x160 [iw_cxgb3]
> [  599.027654]  [<ffffffffa01e8da0>] iwch_destroy_cq+0xf0/0x140 [iw_cxgb3]
> [  599.034307]  [<ffffffffa01c4bfe>] ib_destroy_cq+0x1e/0x30 [ib_core]
> [  599.040601]  [<ffffffffa04ff2d2>] ib_uverbs_close+0x302/0x4d0 [ib_uver=
bs]
> [  599.047417]  [<ffffffff812335a2>] __fput+0x102/0x310
> [  599.052401]  [<ffffffff8123388e>] ____fput+0xe/0x10
> [  599.057297]  [<ffffffff810bbde4>] task_work_run+0xb4/0xe0
> [  599.062719]  [<ffffffff81092a84>] do_exit+0x304/0xc60
> [  599.067789]  [<ffffffff81025905>] ? native_sched_clock+0x35/0x80
> [  599.073820]  [<ffffffff81025959>] ? sched_clock+0x9/0x10
> [  599.079153]  [<ffffffff8170a49c>] ? _raw_spin_unlock_irq+0x2c/0x50
> [  599.085358]  [<ffffffff8109346c>] do_group_exit+0x4c/0xc0
> [  599.090779]  [<ffffffff810a8661>] get_signal_to_deliver+0x2e1/0x960
> [  599.097071]  [<ffffffff8101c497>] do_signal+0x57/0x6e0
> [  599.102229]  [<ffffffff81714bd1>] ? sysret_signal+0x5/0x4e
> [  599.107738]  [<ffffffff8101cb7f>] do_notify_resume+0x5f/0xb0
> [  599.113418]  [<ffffffff81714e7d>] int_signal+0x12/0x17
> [  599.118576] ---[ end trace 1e4653102e7e7019 ]---
> [  599.123211] Mapped at:
> [  599.125577]  [<ffffffff8138ed8b>] debug_dma_alloc_coherent+0x2b/0x80
> [  599.131968]  [<ffffffffa01ec862>] cxio_create_cq+0xf2/0x1f0 [iw_cxgb3]
> [  599.139920]  [<ffffffffa01e9c05>] iwch_create_cq+0x105/0x4e0 [iw_cxgb3]
> [  599.147895]  [<ffffffffa0500584>] create_cq.constprop.14+0x184/0x2e0 [=
ib_uverbs]
> [  599.156649]  [<ffffffffa05027fb>] ib_uverbs_create_cq+0x10b/0x140 [ib_=
uverbs]
>=20
> Fixes: b955150ea784 ('RDMA/cxgb3: When a user QP is marked in error, also=
 mark the CQs in error')
> Signed-off-by: Honggang Li <honli@redhat.com>
> ---
>  drivers/infiniband/hw/cxgb3/cxio_hal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/=
hw/cxgb3/cxio_hal.c
> index de1c61b4..ada2e50 100644
> --- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
> +++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
> @@ -327,7 +327,7 @@ int cxio_destroy_cq(struct cxio_rdev *rdev_p, struct =
t3_cq *cq)
>  	kfree(cq->sw_queue);
>  	dma_free_coherent(&(rdev_p->rnic_info.pdev->dev),
>  			  (1UL << (cq->size_log2))
> -			  * sizeof(struct t3_cqe), cq->queue,
> +			  * sizeof(struct t3_cqe) + 1, cq->queue,

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

158 int cxio_create_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq, int kern=
el
159 {
160         struct rdma_cq_setup setup;
161         int size =3D (1UL << (cq->size_log2)) * sizeof(struct t3_cqe)
162
163         size +=3D 1; /* one extra page for storing cq-in-err state */
<...>
172         cq->queue =3D dma_alloc_coherent(&(rdev_p->rnic_info.pdev->dev)=
, size,
173		&(cq->dma_addr), GFP_KERNEL);


>  			  dma_unmap_addr(cq, mapping));
>  	cxio_hal_put_cqid(rdev_p->rscp, cq->cqid);
>  	return err;
> --=20
> 2.5.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXQp7rAAoJEORje4g2cling4cP/2FlH5Ln5u8H3739hd+7vVBE
EpL85bUC59E1DsipfEGgsG0BZIjm/LlLxZfAtR8u/MLCjBAG1XI20Ch+0N4QcyIb
w/2orwGVKazXyhc32P2me213VoC9QeJJ/UNH9Ye00sg4OxU8AA47GDWVKUEpxX1G
IgLW3lTwDSfTKVajAHK0nAZ4VRlQOh2F0kyySbntdOmLOmsDNjbXEPz4+mvFz8Nj
RsXceYUq1qgvG/VO42yYr1ueNhCqPnSusk7cw7DmE5pT8Zefe5vdJVtUkLyakXue
mtGmzYeJ6qhXvpvg+sGXpu5R3znLFMTfnFs8EP/JauIgayeXROfQ8QdMJGfMZCOQ
1fB9PDI5UG6hhq8JvmAocwOhmeVaE1zIP+qA38N/NpONe2prdPVkHwVLxTB4Yy3i
6+sZA12+CCtngRm46RmUpRjGYo0KveGzK59mJ+S7FGWc6zpkRCM/ih4KpGibiSno
lspexhoI2fargqdDLw2OV9FBjtJszjrvmwpJQYUW12ATfKbdERa+pVHwEv/roUry
k3JcbvHy3SnkyKq5StpWBdN+7sfvZlbP+teviYK9KtE9tFZC1/n5zYUiBOGfmw9X
hs93LVSVS8myNaRh6uP5q3juf6ZrRyaMC8NkQDCtCNFaE7oLIGSzFljFgv+lWkqj
ioCYv8USqSD0qBTWqWOo
=XcHY
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
