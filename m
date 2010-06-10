From: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH/RFC] mlx4_core: module param to limit msix vec allocation
Date: Thu, 10 Jun 2010 09:59:21 -0700
Message-ID: <20100610165921.GF22247@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


The mlx4_core driver allocates 'nreq' msix vectors (and irqs), 
where:

  nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
               num_possible_cpus() + 1);

ConnectX HCAs support 512 event queues (4 reserved). On a system 
with enough processors, we get:

  mlx4_core 0006:01:00.0: Requested 508 vectors, but only 256 MSI-X vectors available, trying again

Further attempts (by other drivers) to allocate interrupts fail, 
because mlx4_core got 'em all.

How about this?

Signed-off-by: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>

---

 main.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index e3e0d54..0a316d0 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -68,6 +68,10 @@ static int msi_x = 1;
 module_param(msi_x, int, 0444);
 MODULE_PARM_DESC(msi_x, "attempt to use MSI-X if nonzero");
 
+static int max_msi_x_vec = 64;
+module_param(max_msi_x_vec, int, 0444);
+MODULE_PARM_DESC(max_msi_x_vec, "max MSI-X vectors we'll attempt to allocate");
+
 #else /* CONFIG_PCI_MSI */
 
 #define msi_x (0)
@@ -968,8 +972,10 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 	int i;
 
 	if (msi_x) {
+		nreq = min_t(int, num_possible_cpus() + 1, max_msi_x_vec);
 		nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
-			     num_possible_cpus() + 1);
+			     nreq);
+
 		entries = kcalloc(nreq, sizeof *entries, GFP_KERNEL);
 		if (!entries)
 			goto no_msi;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
