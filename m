From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix decision to avoid using MAD_IFC command in
 ISSI > 0 mode
Date: Mon, 12 Sep 2016 07:29:02 +0300
Message-ID: <20160912042902.GA8812@leon.nu>
References: <1473232990-22766-1-git-send-email-dchang@suse.com>
 <20160908140752.GN18398@leon.nu>
 <20160909025527.GC3042@linux-kyyb.suse>
 <20160910074719.GG6415@leon.nu>
 <20160911071542.GH6415@leon.nu>
 <9293c685-7ce9-be56-89fa-a5562a703b81@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9293c685-7ce9-be56-89fa-a5562a703b81-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Chang <dchang-IBi9RG/b67k@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 11, 2016 at 06:51:32PM +0300, Or Gerlitz wrote:
> On 9/11/2016 10:15 AM, Leon Romanovsky wrote:
> >
> > From 9147fabc9b189e09a982de8ac30f01f04468f6ce Mon Sep 17 00:00:00 2001
> >From: Noa Osherovich<noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Date: Sun, 11 Sep 2016 10:00:27 +0300
> >Subject: [PATCH rdma-rc] IB/mlx5: Enable MAD_IFC commands for IB ports o=
nly
> >
> >MAD_IFC command is supported only for physical function (PF) drivers
> >and only when physical port is IB.
>
> the word drivers isn't accurate
>
> your change log doesn't say enough on the nature of the fix. You can say
> "MAD_IFC command is supported only for physical function (PF) and when the
> port link type is IB, enforce that"
>
> >The lack of check if port is IB caused to following trace to appear.
>
> This trace teaches us nothing.  If you really want to keep it here, say
> something what the trace means
>
>
> >
> >[    8.456327] mlx5_core 0000:03:00.0: firmware version: 12.12.780
>
> does the FW version matters here or the bug/fix apply for all GA FWs that
> support IB SRIOV and ETH (Roce)?
>
>
> >...
> >[   10.417421] mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (Fe=
b 2014)
> >[   10.419282] ------------[ cut here ]------------
> >[   10.419291] WARNING: CPU: 2 PID: 2517 at ../drivers/infiniband/core/c=
ache.c:702 ib_cache_gid_set_default_gid+0x2f8/0x340 [ib_core]()
> >[   10.419386] CPU: 2 PID: 2517 Comm: modprobe Tainted: G		X 4.4.19-1-de=
fault #1
> >[   10.419387] Hardware name: Dell Inc. PowerEdge R730xd/072T6D, BIOS2.1=
=2E7 06/16/2016
> >[   10.419389]  0000000000000000 ffffffff8130d740 0000000000000000 fffff=
fffa04e0300
> >[   10.419395]  ffffffff8107c121
> >[   10.419400]  ffff88017bfe0000 ffff88003712b9e0 ffff88045ad905c0
> >[   10.419401]  0000000000000001 fffffffffffffffc ffffffffa04d8a58 00000=
00000000000
> >[   10.419406] Call Trace:
> >[   10.419415]  [<ffffffff81019a59>] dump_trace+0x59/0x310
> >[   10.419419]  [<ffffffff81019dfa>] show_stack_log_lvl+0xea/0x170
> >[   10.419421]  [<ffffffff8101ab81>] show_stack+0x21/0x40
> >[   10.419426]  [<ffffffff8130d740>] dump_stack+0x5c/0x7c
> >[   10.419431]  [<ffffffff8107c121>] warn_slowpath_common+0x81/0xb0
> >[   10.419436]  [<ffffffffa04d8a58>] ib_cache_gid_set_default_gid+0x2f8/=
0x340 [ib_core]
> >[   10.419449]  [<ffffffffa04da2dd>] add_netdev_ips+0x9d/0xa0 [ib_core]
> >[   10.419456]  [<ffffffffa04da45b>] enum_all_gids_of_dev_cb+0x7b/0xb0 [=
ib_core]
> >[   10.419461]  [<ffffffffa04d641d>] ib_enum_roce_netdev+0xdd/0x100 [ib_=
core]
> >[   10.419466]  [<ffffffffa04da5ed>] roce_rescan_device+0x1d/0x20 [ib_co=
re]
> >[   10.419470]  [<ffffffffa04d8cdb>] ib_cache_setup_one+0x23b/0x3d0 [ib_=
core]
> >[   10.419475]  [<ffffffffa04d606b>] ib_register_device+0x2bb/0x4f0 [ib_=
core]
> >[   10.419483]  [<ffffffffa0618bbf>] mlx5_ib_add+0xaaf/0x12e0 [mlx5_ib]
> >[   10.419492]  [<ffffffffa08b76c1>] mlx5_add_device+0x41/0xa0 [mlx5_cor=
e]
> >[   10.419498]  [<ffffffffa08b7785>] mlx5_register_interface+0x65/0xa0 [=
mlx5_core]
> >[   10.419502]  [<ffffffffa0474030>] mlx5_ib_init+0x30/0x42 [mlx5_ib]
> >[   10.419506]  [<ffffffff81002138>] do_one_initcall+0xc8/0x1f0
> >[   10.419510]  [<ffffffff811827e8>] do_init_module+0x5a/0x1d7
> >[   10.419514]  [<ffffffff81103536>] load_module+0x1366/0x1c50
> >[   10.419518]  [<ffffffff81103fd0>] SYSC_finit_module+0x70/0xa0
> >[   10.419523]  [<ffffffff815e126e>] entry_SYSCALL_64_fastpath+0x12/0x6d
> >[   10.420681] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0=
x6d
> >[   10.420682] Leftover inexact backtrace:
> >[   10.420684] ---[ end trace fc8ccb16c9d8e28a ]---
> >
>
> say here what commit/s you are fixing, add Fixes: line  -- I assume this =
bug
> is here before 4.8-rc1 so the fix needs to go anyway to stable kernels. As
> we're close to rc6, its better to push the patch for rdma-next (4.9) and
> later carry it back to stable.
>
> >Reported-by: David Chang<dchang-IBi9RG/b67k@public.gmane.org>
> >Signed-off-by: Noa Osherovich<noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Signed-off-by: Leon Romanovsky<leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >---
> >  drivers/infiniband/hw/mlx5/main.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/m=
lx5/main.c
> >index 8150ea3..0480b64 100644
> >--- a/drivers/infiniband/hw/mlx5/main.c
> >+++ b/drivers/infiniband/hw/mlx5/main.c
> >@@ -288,7 +288,9 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *d=
ev, u8 port_num,
> >
> >  static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
> >  {
> >-	return !MLX5_CAP_GEN(dev->mdev, ib_virt);
> >+	if (MLX5_CAP_GEN(dev->mdev, port_type) =3D=3D MLX5_CAP_PORT_TYPE_IB)
> >+		return !MLX5_CAP_GEN(dev->mdev, ib_virt);
> >+	return 0;
> >  }

I don't know why your reply didn't get into Linux RDMA, but I hope that
my will be.

While I posted this patch, I wrote this sentence "Please find this
UNTESTED patch. We will do formal testing during the
coming work week and will properly submit it for inclusion for 4.8."

=46rom your response, I understand that one word in capital letters are
not enough and I'll repeat it in all capital letters:
"PLEASE FIND THIS UNTESTED PATCH. WE WILL DO FORMAL TESTING DURING THE
COMING WORK WEEK AND WILL PROPERLY SUBMIT IT FOR INCLUSION FOR 4.8."

>
>

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX1i8OAAoJEORje4g2clinpFAP/0dQpIyC1V/yJzfmuhbxl7/h
yfxjtS/R24lheheERB7F98QrM5iilyDZZgF/0YdicJjJ9cwumxx047c9u7nV5zNm
o6n9gBP62U5ksEnjG5gv9sbtHs61FSpQrLGV1v5NkYU508yDQfMEPU8f5cXpkj3z
1oYiaYqV5a4FeLbEZuL9zlxEUCfpg4phVzZjzz/zXzuT2jXw4UUkqFslsyaeU2gu
IQ7Pc9NdDDSmEgYYWS+Tif3x2tjbmL/M8R9aSI1T+HA8GnfgPJMscicD/AeaUXmt
mQ87oce7T4in0eSp3qI6GEINS/N35LmkPeQGFUbeI+c/MgRcybnIXmTQNNNNdaQJ
7SD5nD0bkFtyptg+psXV6VyUYZZrWZ4X0Xbrxe8X7l2eXLBALh/575rtCit6nucv
iMhMXVoYtGb1j/U+e2Jfg8C3OsXvbspQ+OifWq1+UCs5dr8aKRizhxxxFrDiI7Sd
GtFVaLoldPsCL4ENKE5TmpIZQSh7rzKdR/VGcWiCV4Pa9n0hSBZNr6IUr9iNuquv
gntbnHRrX8mdfF+cH8yNjAJNAulQhA6QQaeiwshyLgU0WYLQ2nldLPw6hOeJdoRw
XE/k0WJOl7MNrbm+wJGOv9r5Zku2DNndMiWQwRBp56dzLw95yah44hsqHZsy0Isp
AISXaVv62I0Zt09X/TX7
=740I
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
