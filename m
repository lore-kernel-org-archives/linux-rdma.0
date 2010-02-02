From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 10/18] IB/umad: use stack variable 'devnum' in
	ib_umad_init_port
Date: Tue, 02 Feb 2010 12:08:35 -0700
Message-ID: <20100202190835.28217.25180.stgit@bob.kio>
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

This change is not useful by itself, but sets us up for a future
change that allows us to dynamically allocate device numbers
in case we have more than IB_UMAD_MAX_PORTS in the system.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/user_mad.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 46c8879..df403ec 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -974,13 +974,16 @@ static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
 static int ib_umad_init_port(struct ib_device *device, int port_num,
 			     struct ib_umad_port *port)
 {
+	int devnum;
+
 	spin_lock(&port_lock);
-	port->dev_num = find_first_zero_bit(dev_map, IB_UMAD_MAX_PORTS);
-	if (port->dev_num >= IB_UMAD_MAX_PORTS) {
+	devnum = find_first_zero_bit(dev_map, IB_UMAD_MAX_PORTS);
+	if (devnum >= IB_UMAD_MAX_PORTS) {
 		spin_unlock(&port_lock);
 		return -1;
 	}
-	set_bit(port->dev_num, dev_map);
+	port->dev_num = devnum;
+	set_bit(devnum, dev_map);
 	spin_unlock(&port_lock);
 
 	port->ib_dev   = device;
@@ -992,7 +995,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	cdev_init(&port->cdev, &umad_fops);
 	port->cdev.owner = THIS_MODULE;
 	kobject_set_name(&port->cdev.kobj, "umad%d", port->dev_num);
-	if (cdev_add(&port->cdev, base_dev + port->dev_num, 1))
+	if (cdev_add(&port->cdev, base_dev + devnum, 1))
 		goto err_cdev;
 
 	port->dev = device_create(umad_class, device->dma_device,
@@ -1009,7 +1012,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	cdev_init(&port->sm_cdev, &umad_sm_fops);
 	port->sm_cdev.owner = THIS_MODULE;
 	kobject_set_name(&port->sm_cdev.kobj, "issm%d", port->dev_num);
-	if (cdev_add(&port->sm_cdev, base_dev + port->dev_num + IB_UMAD_MAX_PORTS, 1))
+	if (cdev_add(&port->sm_cdev, base_dev + devnum + IB_UMAD_MAX_PORTS, 1))
 		goto err_sm_cdev;
 
 	port->sm_dev = device_create(umad_class, device->dma_device,
@@ -1036,7 +1039,7 @@ err_dev:
 
 err_cdev:
 	cdev_del(&port->cdev);
-	clear_bit(port->dev_num, dev_map);
+	clear_bit(devnum, dev_map);
 
 	return -1;
 }
