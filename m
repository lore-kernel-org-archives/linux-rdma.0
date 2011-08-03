From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/1] mlx4-core: enable changing default max HCA resource limits.
Date: Wed, 3 Aug 2011 12:58:05 +0300
Message-ID: <201108031258.05725.erezsh@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Enable module-initialization time modification of default HCA
maximum resource limits via module parameters, as is done in mthca.

Specify the log of the parameter value, rather than the value itself
to avoid the hidden side-effect of rounding up values to next power-of-2.

Signed-off-by: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/main.c |   51 
+++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 3814fc9..0c36854 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -106,6 +106,56 @@ static int log_mtts_per_seg = ilog2
(MLX4_MTT_ENTRY_PER_SEG);
 module_param_named(log_mtts_per_seg, log_mtts_per_seg, int, 0444);
 MODULE_PARM_DESC(log_mtts_per_seg, "Log2 number of MTT entries per segment 
(1-7)");
 
+static struct mlx4_profile mod_param_profile = { 0 };
+
+module_param_named(log_num_qp, mod_param_profile.num_qp, int, 0444);
+MODULE_PARM_DESC(log_num_qp, "log maximum number of QPs per HCA ");
+
+module_param_named(log_num_srq, mod_param_profile.num_srq, int, 0444);
+MODULE_PARM_DESC(log_num_srq, "log maximum number of SRQs per HCA ");
+
+module_param_named(log_rdmarc_per_qp, mod_param_profile.rdmarc_per_qp, int, 
0444);
+MODULE_PARM_DESC(log_rdmarc_per_qp, "log number of RDMARC buffers per QP ");
+
+module_param_named(log_num_cq, mod_param_profile.num_cq, int, 0444);
+MODULE_PARM_DESC(log_num_cq, "log maximum number of CQs per HCA ");
+
+module_param_named(log_num_mcg, mod_param_profile.num_mcg, int, 0444);
+MODULE_PARM_DESC(log_num_mcg, "log maximum number of multicast groups per 
HCA ");
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
@@ -791,6 +841,7 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 		goto err_stop_fw;
 	}
 
+	process_mod_param_profile();
 	profile = default_profile;
 
 	icm_size = mlx4_make_profile(dev, &profile, &dev_cap, &init_hca);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
