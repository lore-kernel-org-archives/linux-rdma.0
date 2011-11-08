From: vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH] mlx4_core: enable changing HCA default max resource limits
Date: Tue, 8 Nov 2011 09:39:40 -0800
Message-ID: <20111108173940.GA23912@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, abenjamin-sJ/iWh9BUns@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This patch allow users to change HCA default profile resourses (num_qp, num_cq, num_mpt...)
especially for users with big clusters

>From 1d85e3d05fb2e6899c32e3b64047c446269f835a Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 28 Sep 2011 14:07:25 -0700
Subject: [PATCH] mlx4_core: enable changing HCA default max resource limits

Enable module-initialization time modification of HCA default
maximum resource limits via module parameters, as is done in mthca.

Specify the log of the parameter value, rather than the value itself
to avoid the hidden side-effect of rounding up values to next power-of-2.

Signed-off-by: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/mlx4/main.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index a7527d1..5878981 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -109,6 +109,63 @@ MODULE_PARM_DESC(log_mtts_per_seg, "Log2 number of MTT entries per segment (1-7)
 static int rr_proto = MLX4_RR_DEF_PROTO;
 module_param(rr_proto , uint, 0444);
 
+static struct mlx4_profile mod_param_profile = { 0 };
+
+module_param_named(log_num_qp, mod_param_profile.num_qp, int, 0444);
+MODULE_PARM_DESC(log_num_qp, "log maximum number of QPs per HCA ");
+
+module_param_named(log_num_srq, mod_param_profile.num_srq, int, 0444);
+MODULE_PARM_DESC(log_num_srq, "log maximum number of SRQs per HCA ");
+
+module_param_named(log_rdmarc_per_qp, mod_param_profile.rdmarc_per_qp, int, 0444);
+MODULE_PARM_DESC(log_rdmarc_per_qp, "log number of RDMARC buffers per QP ");
+
+module_param_named(log_num_cq, mod_param_profile.num_cq, int, 0444);
+MODULE_PARM_DESC(log_num_cq, "log maximum number of CQs per HCA ");
+
+module_param_named(log_num_mcg, mod_param_profile.num_mcg, int, 0444);
+MODULE_PARM_DESC(log_num_mcg, "log maximum number of multicast groups per HCA ");
+
+module_param_named(log_num_mpt, mod_param_profile.num_mpt, int, 0444);
+MODULE_PARM_DESC(log_num_mpt,
+		"log maximum number of memory protection table entries per HCA ");
+
+module_param_named(log_num_mtt, mod_param_profile.num_mtt, int, 0444);
+MODULE_PARM_DESC(log_num_mtt,
+		 "log maximum number of memory translation table segments per HCA ");
+
+static void process_mod_param_profile(void)
+{
+	if (mod_param_profile.num_qp &&
+	    mod_param_profile.num_qp < ilog2(MLX4_NUM_FEXCH) + 1) {
+		printk(KERN_WARNING
+			"log max QPs=%d is too small - reset to %d\n",
+			mod_param_profile.num_qp, ilog2(MLX4_NUM_FEXCH) + 1);
+		mod_param_profile.num_qp = ilog2(MLX4_NUM_FEXCH) + 1;
+	}
+	default_profile.num_qp = (mod_param_profile.num_qp ?
+				  1 << mod_param_profile.num_qp :
+				  default_profile.num_qp);
+	default_profile.num_srq = (mod_param_profile.num_srq ?
+				  1 << mod_param_profile.num_srq :
+				  default_profile.num_srq);
+	default_profile.rdmarc_per_qp = (mod_param_profile.rdmarc_per_qp ?
+				  1 << mod_param_profile.rdmarc_per_qp :
+				  default_profile.rdmarc_per_qp);
+	default_profile.num_cq = (mod_param_profile.num_cq ?
+				  1 << mod_param_profile.num_cq :
+				  default_profile.num_cq);
+	default_profile.num_mcg = (mod_param_profile.num_mcg ?
+				  1 << mod_param_profile.num_mcg :
+				  default_profile.num_mcg);
+	default_profile.num_mpt = (mod_param_profile.num_mpt ?
+				  1 << mod_param_profile.num_mpt :
+				  default_profile.num_mpt);
+	default_profile.num_mtt = (mod_param_profile.num_mtt ?
+				  1 << mod_param_profile.num_mtt :
+				  default_profile.num_mtt);
+}
+
 int mlx4_check_port_params(struct mlx4_dev *dev,
 			   enum mlx4_port_type *port_type)
 {
@@ -801,6 +858,7 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 		goto err_stop_fw;
 	}
 
+	process_mod_param_profile();
 	profile = default_profile;
 
 	icm_size = mlx4_make_profile(dev, &profile, &dev_cap, &init_hca);
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
