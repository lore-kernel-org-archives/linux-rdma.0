From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix decision to avoid using MAD_IFC command in
 ISSI > 0 mode
Date: Sun, 11 Sep 2016 10:15:42 +0300
Message-ID: <20160911071542.GH6415@leon.nu>
References: <1473232990-22766-1-git-send-email-dchang@suse.com>
 <20160908140752.GN18398@leon.nu>
 <20160909025527.GC3042@linux-kyyb.suse>
 <20160910074719.GG6415@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="poJSiGMzRSvrLGLs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160910074719.GG6415-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--poJSiGMzRSvrLGLs
Content-Type: multipart/mixed; boundary="+QwZB9vYiNIzNXIj"
Content-Disposition: inline


--+QwZB9vYiNIzNXIj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 10, 2016 at 10:47:19AM +0300, Leon Romanovsky wrote:
> On Fri, Sep 09, 2016 at 10:55:27AM +0800, David Chang wrote:
> > On Thu, Sep 08, 2016 at 05:07:52PM +0300, Leon Romanovsky wrote:
> > > On Wed, Sep 07, 2016 at 03:23:10PM +0800, David Chang wrote:
> > > > When using MAD_IFC command, we should also consider avoiding in
> > > > ISSI > 0 mode, otherwise most of the MAD_IFC command features
> > > > are deprecated and cannot be used.
> > > >
> > > > Fixes: d603c809ef91 ("IB/mlx5: Fix decision on using MAD_IFC")
> > > > Reported-by: Sujith Pandel <sujith_pandel-8PEkshWhKlo@public.gmane.org>
> > > > Signed-off-by: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
> > >
> > > NAK,
> > > It is wrong, the deprecation is removed from programming manual.
> > >
> >
> > Without the patch, we got the following message.
> > [    8.456327] mlx5_core 0000:03:00.0: firmware version: 12.12.780
> > ...
>
> This command is supported only for physical function (PF) drivers
> and only when physical port is IB without relation to ISSI.
>
> When I'll return to office (next week), I'll check that we are checking
> this requirement correctly.
>
> Thanks for providing dump and FW version to reproduce it.

Hi David,

Please find this UNTESTED patch. We will do formal testing during the
coming work week and will properly submit it for inclusion for 4.8.

--+QwZB9vYiNIzNXIj
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-IB-mlx5-Enable-MAD_IFC-commands-for-IB-ports-only.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 9147fabc9b189e09a982de8ac30f01f04468f6ce Mon Sep 17 00:00:00 2001
=46rom: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 11 Sep 2016 10:00:27 +0300
Subject: [PATCH rdma-rc] IB/mlx5: Enable MAD_IFC commands for IB ports only

MAD_IFC command is supported only for physical function (PF) drivers
and only when physical port is IB.

The lack of check if port is IB caused to following trace to appear.

[    8.456327] mlx5_core 0000:03:00.0: firmware version: 12.12.780
=2E..
[   10.417421] mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (Feb 2=
014)
[   10.419282] ------------[ cut here ]------------
[   10.419291] WARNING: CPU: 2 PID: 2517 at ../drivers/infiniband/core/cach=
e.c:702 ib_cache_gid_set_default_gid+0x2f8/0x340 [ib_core]()
[   10.419386] CPU: 2 PID: 2517 Comm: modprobe Tainted: G		X 4.4.19-1-defau=
lt #1
[   10.419387] Hardware name: Dell Inc. PowerEdge R730xd/072T6D, BIOS2.1.7 =
06/16/2016
[   10.419389]  0000000000000000 ffffffff8130d740 0000000000000000 ffffffff=
a04e0300
[   10.419395]  ffffffff8107c121
[   10.419400]  ffff88017bfe0000 ffff88003712b9e0 ffff88045ad905c0
[   10.419401]  0000000000000001 fffffffffffffffc ffffffffa04d8a58 00000000=
00000000
[   10.419406] Call Trace:
[   10.419415]  [<ffffffff81019a59>] dump_trace+0x59/0x310
[   10.419419]  [<ffffffff81019dfa>] show_stack_log_lvl+0xea/0x170
[   10.419421]  [<ffffffff8101ab81>] show_stack+0x21/0x40
[   10.419426]  [<ffffffff8130d740>] dump_stack+0x5c/0x7c
[   10.419431]  [<ffffffff8107c121>] warn_slowpath_common+0x81/0xb0
[   10.419436]  [<ffffffffa04d8a58>] ib_cache_gid_set_default_gid+0x2f8/0x3=
40 [ib_core]
[   10.419449]  [<ffffffffa04da2dd>] add_netdev_ips+0x9d/0xa0 [ib_core]
[   10.419456]  [<ffffffffa04da45b>] enum_all_gids_of_dev_cb+0x7b/0xb0 [ib_=
core]
[   10.419461]  [<ffffffffa04d641d>] ib_enum_roce_netdev+0xdd/0x100 [ib_cor=
e]
[   10.419466]  [<ffffffffa04da5ed>] roce_rescan_device+0x1d/0x20 [ib_core]
[   10.419470]  [<ffffffffa04d8cdb>] ib_cache_setup_one+0x23b/0x3d0 [ib_cor=
e]
[   10.419475]  [<ffffffffa04d606b>] ib_register_device+0x2bb/0x4f0 [ib_cor=
e]
[   10.419483]  [<ffffffffa0618bbf>] mlx5_ib_add+0xaaf/0x12e0 [mlx5_ib]
[   10.419492]  [<ffffffffa08b76c1>] mlx5_add_device+0x41/0xa0 [mlx5_core]
[   10.419498]  [<ffffffffa08b7785>] mlx5_register_interface+0x65/0xa0 [mlx=
5_core]
[   10.419502]  [<ffffffffa0474030>] mlx5_ib_init+0x30/0x42 [mlx5_ib]
[   10.419506]  [<ffffffff81002138>] do_one_initcall+0xc8/0x1f0
[   10.419510]  [<ffffffff811827e8>] do_init_module+0x5a/0x1d7
[   10.419514]  [<ffffffff81103536>] load_module+0x1366/0x1c50
[   10.419518]  [<ffffffff81103fd0>] SYSC_finit_module+0x70/0xa0
[   10.419523]  [<ffffffff815e126e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[   10.420681] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[   10.420682] Leftover inexact backtrace:
[   10.420684] ---[ end trace fc8ccb16c9d8e28a ]---

Reported-by: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index 8150ea3..0480b64 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -288,7 +288,9 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev,=
 u8 port_num,

 static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
 {
-	return !MLX5_CAP_GEN(dev->mdev, ib_virt);
+	if (MLX5_CAP_GEN(dev->mdev, port_type) =3D=3D MLX5_CAP_PORT_TYPE_IB)
+		return !MLX5_CAP_GEN(dev->mdev, ib_virt);
+	return 0;
 }

 enum {
--
2.7.4


--+QwZB9vYiNIzNXIj--

--poJSiGMzRSvrLGLs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX1QSeAAoJEORje4g2clineVYP/2IICOP2i69R5kSskJ8KK7jH
ExHFQIJDGm9MChTWGQVtiAMZ9bLVuAxfn3Cbyv1cCeA0Xof+MASgMxHoNl7GJUUG
3el+cf7U1f6hHmH7AtO6i0AT248Wf1A7MFNgJ4vO+WhBvkjTv57cUGxXIKxGTFLJ
CdVUybrktTORCwTE/jpvw46edz83I707/tfg5MxigyAzzuIzS2yydy7wYjwlE3Vi
+Y0gEsNk9Pk/RCKtJUXeyFLWYExyIgCzM/hZa/cwrKGESWQ4BrIIJWHL/pJ8KYPZ
Oc4+kgZ9ktxrZbgmpYDSaHtZWd0Fd1+m0ciTy9QE21k7NaKs4qq4gQCexstJgCmd
5wgd4GVTKvWNRZuOABmpojh/RdTBNfcbtXjCjpOnL/iL4Lxs7SKTCdUBgWo05wpv
Res7S6OWzSJjJvLCCsYWC/9fPzJMVPK3Yu/J0EuxKDsRwTtlE1MfZOSBeCEkR9/P
6Ef8Kfba17tlxiiZtHOb5cILU32NasjTslX7C4dyifs2u4Nuy0NrvVQn1Exqsqkd
ReOZzCGAbndDJ+C4EWEqPu/0ezXTeeIPn4r5iL6KQM+kKqBpjIEgz/v3P0gJYBUY
a09/nudQo5XSdiq2LPL5ePaSphnCupxFwP4Q9si9pzk+lpl0gzIl41NvzY5Y8D22
RlSdTEz+a+2Z1+04NS0W
=U/Bg
-----END PGP SIGNATURE-----

--poJSiGMzRSvrLGLs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
