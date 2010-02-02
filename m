From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 11/18] IB/umad: use stack variable 'base' in
	ib_umad_init_port
Date: Tue, 02 Feb 2010 12:08:40 -0700
Message-ID: <20100202190840.28217.76826.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
Sender: linux-kernel-owner@vger.kernel.org
To: rdreier@cisco.com
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This change is not useful by itself, but sets us up for a future change
that allows us to support more than IB_UMAD_MAX_PORTS in a system.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/user_mad.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index df403ec..5a66bd0 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -975,6 +975,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 			     struct ib_umad_port *port)
 {
 	int devnum;
+	dev_t base;
 
 	spin_lock(&port_lock);
 	devnum = find_first_zero_bit(dev_map, IB_UMAD_MAX_PORTS);
@@ -983,6 +984,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 		return -1;
 	}
 	port->dev_num = devnum;
+	base = devnum + base_dev;
 	set_bit(devnum, dev_map);
 	spin_unlock(&port_lock);
 
@@ -995,7 +997,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	cdev_init(&port->cdev, &umad_fops);
 	port->cdev.owner = THIS_MODULE;
 	kobject_set_name(&port->cdev.kobj, "umad%d", port->dev_num);
-	if (cdev_add(&port->cdev, base_dev + devnum, 1))
+	if (cdev_add(&port->cdev, base, 1))
 		goto err_cdev;
 
 	port->dev = device_create(umad_class, device->dma_device,
@@ -1009,10 +1011,11 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (device_create_file(port->dev, &dev_attr_port))
 		goto err_dev;
 
+	base += IB_UMAD_MAX_PORTS;
 	cdev_init(&port->sm_cdev, &umad_sm_fops);
 	port->sm_cdev.owner = THIS_MODULE;
 	kobject_set_name(&port->sm_cdev.kobj, "issm%d", port->dev_num);
-	if (cdev_add(&port->sm_cdev, base_dev + devnum + IB_UMAD_MAX_PORTS, 1))
+	if (cdev_add(&port->sm_cdev, base, 1))
 		goto err_sm_cdev;
 
 	port->sm_dev = device_create(umad_class, device->dma_device,
