From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch] mlx4: make mcg entry size a module parameter
Date: Wed, 23 Mar 2011 12:22:23 -0400
Message-ID: <1300897343.19018.1838.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B+lK+EHgs+gnCsSeDg38"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-B+lK+EHgs+gnCsSeDg38
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

We ran across a problem at a customer's site where the qp array in the
mcg entry was being filling up and denying further qp attaches.  In
addition, the upcoming SRIOV support is expected to increase use of this
array as well for unicast address steering (or so the comments in a
patch Yevgeny's original patch that statically increased the size of the
mcg entries stated).  But, since increasing the size of this to an
arbitrarily large number is just a waste of memory, and since we don't
know that 0x200 will be large enough for all use cases, make the option
a module parameter instead.  This has been tested at our customer's site
and solves their problem.

commit ff608ce370b49d2e5b614ff91f4e23b5deaac8a4
Author: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Wed Mar 23 12:20:47 2011 -0400

    mlx4: make the size of the mcg entry a module parameter
   =20
    Testing showed that the default size of 0x100 could be overrun.
    Bumping to 0x200 would fix the problem, but only until we hit
    the cap again, and at the expense of making memory consumption in
    all scenarios worse.  So, make the size of the mcg entry a module
    parameter and let those people who need to bump the size do so.
   =20
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4=
/main.c
index c7a6213..322f0af 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -158,7 +158,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev=
,
 	props->masked_atomic_cap   =3D IB_ATOMIC_HCA;
 	props->max_pkeys	   =3D dev->dev->caps.pkey_table_len[1];
 	props->max_mcast_grp	   =3D dev->dev->caps.num_mgms + dev->dev->caps.num_=
amgms;
-	props->max_mcast_qp_attach =3D dev->dev->caps.num_qp_per_mgm;
+	props->max_mcast_qp_attach =3D dev->dev->caps.num_qp_per_mcg;
 	props->max_total_mcast_qp_attach =3D props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr =3D (1 << (32 - ilog2(dev->dev->caps.num_mpts))) -=
 1;
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 5de1db8..800cb2d 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -434,8 +434,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx=
4_dev_cap *dev_cap)
 		 dev_cap->reserved_mrws, dev_cap->reserved_mtts);
 	mlx4_dbg(dev, "Max PDs: %d, reserved PDs: %d, reserved UARs: %d\n",
 		 dev_cap->max_pds, dev_cap->reserved_pds, dev_cap->reserved_uars);
-	mlx4_dbg(dev, "Max QP/MCG: %d, reserved MGMs: %d\n",
-		 dev_cap->max_pds, dev_cap->reserved_mgms);
+	mlx4_dbg(dev, "Max QP/MCG: %d, Max MCGs: %d, reserved MGMs: %d\n",
+		 dev_cap->max_qp_per_mcg, dev_cap->max_mcgs, dev_cap->reserved_mgms);
 	mlx4_dbg(dev, "Max CQEs: %d, max WQEs: %d, max SRQ WQEs: %d\n",
 		 dev_cap->max_cq_sz, dev_cap->max_qp_sz, dev_cap->max_srq_sz);
 	mlx4_dbg(dev, "Local CA ACK delay: %d, max MTU: %d, port width cap: %d\n"=
,
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 2765a3c..5306141 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -101,6 +101,10 @@ module_param_named(use_prio, use_prio, bool, 0444);
 MODULE_PARM_DESC(use_prio, "Enable steering by VLAN priority on ETH ports =
"
 		  "(0/1, default 0)");
=20
+static int log_mcg_size =3D 8;
+module_param_named(log_mcg_size, log_mcg_size, int, 0444);
+MODULE_PARM_DESC(log_mcg_size, "Log2 size of MCG struct (8-11)");
+
 static int log_mtts_per_seg =3D ilog2(MLX4_MTT_ENTRY_PER_SEG);
 module_param_named(log_mtts_per_seg, log_mtts_per_seg, int, 0444);
 MODULE_PARM_DESC(log_mtts_per_seg, "Log2 number of MTT entries per segment=
 (1-7)");
@@ -203,7 +207,14 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct m=
lx4_dev_cap *dev_cap)
 	dev->caps.reserved_srqs	     =3D dev_cap->reserved_srqs;
 	dev->caps.max_sq_desc_sz     =3D dev_cap->max_sq_desc_sz;
 	dev->caps.max_rq_desc_sz     =3D dev_cap->max_rq_desc_sz;
-	dev->caps.num_qp_per_mgm     =3D MLX4_QP_PER_MGM;
+	dev->caps.max_qp_per_mcg     =3D dev_cap->max_qp_per_mcg;
+	dev->caps.max_mcgs           =3D dev_cap->max_mcgs;
+	i =3D 0;
+	do {
+		dev->caps.mcg_entry_size     =3D 1 << (log_mcg_size - i++);
+		dev->caps.num_qp_per_mcg     =3D 4 * (dev->caps.mcg_entry_size / 16 - 2)=
;
+	} while (dev->caps.num_qp_per_mcg > dev->caps.max_qp_per_mcg);
+
 	/*
 	 * Subtract 1 from the limit because we need to allocate a
 	 * spare CQE so the HCA HW can tell the difference between an
@@ -642,7 +653,7 @@ static int mlx4_init_icm(struct mlx4_dev *dev, struct m=
lx4_dev_cap *dev_cap,
 	 * and it's a lot easier than trying to track ref counts.
 	 */
 	err =3D mlx4_init_icm_table(dev, &priv->mcg_table.table,
-				  init_hca->mc_base, MLX4_MGM_ENTRY_SIZE,
+				  init_hca->mc_base, dev->caps.mcg_entry_size,
 				  dev->caps.num_mgms + dev->caps.num_amgms,
 				  dev->caps.num_mgms + dev->caps.num_amgms,
 				  0, 0);
@@ -1330,6 +1341,11 @@ static int __init mlx4_verify_params(void)
 		return -1;
 	}
=20
+	if ((log_mcg_size < 8) || (log_mcg_size > 11)) {
+		printk(KERN_WARNING "mlx4_core: bad log_mcg_size: %d\n", log_mcg_size);
+		return -1;
+	}
+
 	return 0;
 }
=20
diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index 79cf42d..70e2ba6 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -45,7 +45,7 @@ struct mlx4_mgm {
 	__be32			members_count;
 	u32			reserved[2];
 	u8			gid[16];
-	__be32			qp[MLX4_QP_PER_MGM];
+	__be32			qp[MLX4_MAX_QP_PER_MGM];
 };
=20
 static const u8 zero_gid[16];	/* automatically initialized to 0 */
@@ -185,12 +185,12 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struc=
t mlx4_qp *qp, u8 gid[16],
 		}
 		index +=3D dev->caps.num_mgms;
=20
-		memset(mgm, 0, sizeof *mgm);
+		memset(mgm, 0, dev->caps.mcg_entry_size);
 		memcpy(mgm->gid, gid, 16);
 	}
=20
 	members_count =3D be32_to_cpu(mgm->members_count) & 0xffffff;
-	if (members_count =3D=3D MLX4_QP_PER_MGM) {
+	if (members_count =3D=3D dev->caps.num_qp_per_mcg) {
 		mlx4_err(dev, "MGM at index %x is full.\n", index);
 		err =3D -ENOMEM;
 		goto out;
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 0da5bb72..1818d84 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -58,8 +58,8 @@ enum {
 };
=20
 enum {
-	MLX4_MGM_ENTRY_SIZE	=3D  0x100,
-	MLX4_QP_PER_MGM		=3D 4 * (MLX4_MGM_ENTRY_SIZE / 16 - 2),
+	MLX4_MAX_MGM_ENTRY_SIZE	=3D 1 << 11,
+	MLX4_MAX_QP_PER_MGM	=3D 4 * (MLX4_MAX_MGM_ENTRY_SIZE / 16 - 2),
 	MLX4_MTT_ENTRY_PER_SEG	=3D 8
 };
=20
diff --git a/drivers/net/mlx4/profile.c b/drivers/net/mlx4/profile.c
index e749f82..2f19831 100644
--- a/drivers/net/mlx4/profile.c
+++ b/drivers/net/mlx4/profile.c
@@ -99,7 +99,7 @@ u64 mlx4_make_profile(struct mlx4_dev *dev,
 	profile[MLX4_RES_DMPT].size   =3D dev_cap->dmpt_entry_sz;
 	profile[MLX4_RES_CMPT].size   =3D dev_cap->cmpt_entry_sz;
 	profile[MLX4_RES_MTT].size    =3D dev->caps.mtts_per_seg * dev_cap->mtt_e=
ntry_sz;
-	profile[MLX4_RES_MCG].size    =3D MLX4_MGM_ENTRY_SIZE;
+	profile[MLX4_RES_MCG].size    =3D dev->caps.mcg_entry_size;
=20
 	profile[MLX4_RES_QP].num      =3D request->num_qp;
 	profile[MLX4_RES_RDMARC].num  =3D request->num_qp * request->rdmarc_per_q=
p;
@@ -220,7 +220,7 @@ u64 mlx4_make_profile(struct mlx4_dev *dev,
 			dev->caps.num_mgms	  =3D profile[i].num >> 1;
 			dev->caps.num_amgms	  =3D profile[i].num >> 1;
 			init_hca->mc_base	  =3D profile[i].start;
-			init_hca->log_mc_entry_sz =3D ilog2(MLX4_MGM_ENTRY_SIZE);
+			init_hca->log_mc_entry_sz =3D ilog2(dev->caps.mcg_entry_size);
 			init_hca->log_mc_table_sz =3D profile[i].log_num;
 			init_hca->log_mc_hash_sz  =3D profile[i].log_num - 1;
 			break;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 0492146..2a86dbd 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -230,10 +230,13 @@ struct mlx4_caps {
 	int			reserved_mtts;
 	int			reserved_mrws;
 	int			reserved_uars;
+	int			max_qp_per_mcg;
+	int			max_mcgs;
+	int			mcg_entry_size;
+	int			num_qp_per_mcg;
 	int			num_mgms;
 	int			num_amgms;
 	int			reserved_mcgs;
-	int			num_qp_per_mgm;
 	int			num_pds;
 	int			reserved_pds;
 	int			mtt_entry_sz;


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-B+lK+EHgs+gnCsSeDg38
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk2KHj8ACgkQg6WylM+/8ZTEQgCePpflk98LTv5d51BsHTMis1rs
99kAn0+hpnVFXEFMyZTqd0a0KHFUxqnM
=sUXu
-----END PGP SIGNATURE-----

--=-B+lK+EHgs+gnCsSeDg38--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
