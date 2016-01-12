From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] IB/cma: allocating too much memory in make_cma_ports()
Date: Tue, 12 Jan 2016 12:29:21 +0300
Message-ID: <20160112092921.GB29804@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The issue here is that there is a cut and paste bug.  When we allocate
cma_dev_group->default_ports_group we use "sizeof(*cma_dev_group->ports)"
instead of "sizeof(*cma_dev_group->default_ports_group)".

We're bumping up against the 80 character limit so I introduced a new
local pointer "ports_group" to get around that.

Fixes: 045959db65c6 ('IB/cma: Add configfs for rdma_cm')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Not tested.

diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index bd1d640..18b112a 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -158,6 +158,7 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
 	unsigned int i;
 	unsigned int ports_num;
 	struct cma_dev_port_group *ports;
+	struct config_group **ports_group;
 	int err;
 
 	ibdev = cma_get_ib_dev(cma_dev);
@@ -168,12 +169,9 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
 	ports_num = ibdev->phys_port_cnt;
 	ports = kcalloc(ports_num, sizeof(*cma_dev_group->ports),
 			GFP_KERNEL);
+	ports_group = kcalloc(ports_num + 1, sizeof(*ports_group), GFP_KERNEL);
 
-	cma_dev_group->default_ports_group = kcalloc(ports_num + 1,
-						     sizeof(*cma_dev_group->ports),
-						     GFP_KERNEL);
-
-	if (!ports || !cma_dev_group->default_ports_group) {
+	if (!ports || !ports_group) {
 		err = -ENOMEM;
 		goto free;
 	}
@@ -187,15 +185,16 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
 		config_group_init_type_name(&ports[i].group,
 					    port_str,
 					    &cma_port_group_type);
-		cma_dev_group->default_ports_group[i] = &ports[i].group;
+		ports_group[i] = &ports[i].group;
 	}
-	cma_dev_group->default_ports_group[i] = NULL;
+	ports_group[i] = NULL;
+	cma_dev_group->default_ports_group = ports_group;
 	cma_dev_group->ports = ports;
 
 	return 0;
 free:
 	kfree(ports);
-	kfree(cma_dev_group->default_ports_group);
+	kfree(ports_group);
 	cma_dev_group->ports = NULL;
 	cma_dev_group->default_ports_group = NULL;
 	return err;
