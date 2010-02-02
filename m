From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 08/18] IB/umad: convert cdev pointers to embedded structs
	in struct ib_umad_port
Date: Tue, 02 Feb 2010 12:08:25 -0700
Message-ID: <20100202190824.28217.22339.stgit@bob.kio>
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

Instead of storing pointers to cdev and sm_cdev, embed the full
structures instead.

This change allows us to use the container_of() macro in ib_umad_open()
and ib_umad_sm_open() in a future patch.

This change increases the size of struct ib_umad_port to 320 bytes
from 128.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/user_mad.c |   46 ++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 7de0296..40440ef 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -87,10 +87,10 @@ enum {
  */
 
 struct ib_umad_port {
-	struct cdev           *cdev;
+	struct cdev           cdev;
 	struct device	      *dev;
 
-	struct cdev           *sm_cdev;
+	struct cdev           sm_cdev;
 	struct device	      *sm_dev;
 	struct semaphore       sm_sem;
 
@@ -1008,17 +1008,14 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	mutex_init(&port->file_mutex);
 	INIT_LIST_HEAD(&port->file_list);
 
-	port->cdev = cdev_alloc();
-	if (!port->cdev)
-		return -1;
-	port->cdev->owner = THIS_MODULE;
-	port->cdev->ops   = &umad_fops;
-	kobject_set_name(&port->cdev->kobj, "umad%d", port->dev_num);
-	if (cdev_add(port->cdev, base_dev + port->dev_num, 1))
+	cdev_init(&port->cdev, &umad_fops);
+	port->cdev.owner = THIS_MODULE;
+	kobject_set_name(&port->cdev.kobj, "umad%d", port->dev_num);
+	if (cdev_add(&port->cdev, base_dev + port->dev_num, 1))
 		goto err_cdev;
 
 	port->dev = device_create(umad_class, device->dma_device,
-				  port->cdev->dev, port,
+				  port->cdev.dev, port,
 				  "umad%d", port->dev_num);
 	if (IS_ERR(port->dev))
 		goto err_cdev;
@@ -1028,17 +1025,14 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (device_create_file(port->dev, &dev_attr_port))
 		goto err_dev;
 
-	port->sm_cdev = cdev_alloc();
-	if (!port->sm_cdev)
-		goto err_dev;
-	port->sm_cdev->owner = THIS_MODULE;
-	port->sm_cdev->ops   = &umad_sm_fops;
-	kobject_set_name(&port->sm_cdev->kobj, "issm%d", port->dev_num);
-	if (cdev_add(port->sm_cdev, base_dev + port->dev_num + IB_UMAD_MAX_PORTS, 1))
+	cdev_init(&port->sm_cdev, &umad_sm_fops);
+	port->sm_cdev.owner = THIS_MODULE;
+	kobject_set_name(&port->sm_cdev.kobj, "issm%d", port->dev_num);
+	if (cdev_add(&port->sm_cdev, base_dev + port->dev_num + IB_UMAD_MAX_PORTS, 1))
 		goto err_sm_cdev;
 
 	port->sm_dev = device_create(umad_class, device->dma_device,
-				     port->sm_cdev->dev, port,
+				     port->sm_cdev.dev, port,
 				     "issm%d", port->dev_num);
 	if (IS_ERR(port->sm_dev))
 		goto err_sm_cdev;
@@ -1055,16 +1049,16 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	return 0;
 
 err_sm_dev:
-	device_destroy(umad_class, port->sm_cdev->dev);
+	device_destroy(umad_class, port->sm_cdev.dev);
 
 err_sm_cdev:
-	cdev_del(port->sm_cdev);
+	cdev_del(&port->sm_cdev);
 
 err_dev:
-	device_destroy(umad_class, port->cdev->dev);
+	device_destroy(umad_class, port->cdev.dev);
 
 err_cdev:
-	cdev_del(port->cdev);
+	cdev_del(&port->cdev);
 	clear_bit(port->dev_num, dev_map);
 
 	return -1;
@@ -1079,11 +1073,11 @@ static void ib_umad_kill_port(struct ib_umad_port *port)
 	dev_set_drvdata(port->dev,    NULL);
 	dev_set_drvdata(port->sm_dev, NULL);
 
-	device_destroy(umad_class, port->cdev->dev);
-	device_destroy(umad_class, port->sm_cdev->dev);
+	device_destroy(umad_class, port->cdev.dev);
+	device_destroy(umad_class, port->sm_cdev.dev);
 
-	cdev_del(port->cdev);
-	cdev_del(port->sm_cdev);
+	cdev_del(&port->cdev);
+	cdev_del(&port->sm_cdev);
 
 	spin_lock(&port_lock);
 	umad_port[port->dev_num] = NULL;
