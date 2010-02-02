From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 12/18] IB/umad: increase maximum devices supported
Date: Tue, 02 Feb 2010 12:08:45 -0700
Message-ID: <20100202190845.28217.29701.stgit@bob.kio>
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

Some large systems may support more than IB_UMAD_MAX_PORTS
(currently 64).

This change allows us to support more ports in a backwards-compatible
manner. The first IB_UMAD_MAX_PORTS keep the same major/minor device
numbers they've always had.

If there are more than IB_UMAD_MAX_PORTS, we then dynamically request
a new major device number (new minors start at 0).

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/user_mad.c |   50 ++++++++++++++++++++++++++++++++----
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 5a66bd0..7fc1e51 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -971,6 +971,28 @@ static ssize_t show_abi_version(struct class *class, char *buf)
 }
 static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
 
+static dev_t oflo_maj;
+static DECLARE_BITMAP(oflo_map, IB_UMAD_MAX_PORTS);
+static int find_oflo_devnum(void)
+{
+	int ret;
+
+	if (!oflo_maj) {
+		ret = alloc_chrdev_region(&oflo_maj, 0, IB_UMAD_MAX_PORTS * 2,
+					  "infiniband_mad");
+		if (ret) {
+			printk(KERN_ERR "user_mad: couldn't register dynamic device number\n");
+			return ret;
+		}
+	}
+
+	ret = find_first_zero_bit(oflo_map, IB_UMAD_MAX_PORTS);
+	if (ret >= IB_UMAD_MAX_PORTS)
+		return -1;
+
+	return ret;
+}
+
 static int ib_umad_init_port(struct ib_device *device, int port_num,
 			     struct ib_umad_port *port)
 {
@@ -981,11 +1003,19 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	devnum = find_first_zero_bit(dev_map, IB_UMAD_MAX_PORTS);
 	if (devnum >= IB_UMAD_MAX_PORTS) {
 		spin_unlock(&port_lock);
-		return -1;
+		devnum = find_oflo_devnum();
+		if (devnum < 0)
+			return -1;
+
+		spin_lock(&port_lock);
+		port->dev_num = devnum + IB_UMAD_MAX_PORTS;
+		base = devnum + oflo_maj;
+		set_bit(devnum, oflo_map);
+	} else {
+		port->dev_num = devnum;
+		base = devnum + base_dev;
+		set_bit(devnum, dev_map);
 	}
-	port->dev_num = devnum;
-	base = devnum + base_dev;
-	set_bit(devnum, dev_map);
 	spin_unlock(&port_lock);
 
 	port->ib_dev   = device;
@@ -1042,7 +1072,10 @@ err_dev:
 
 err_cdev:
 	cdev_del(&port->cdev);
-	clear_bit(devnum, dev_map);
+	if (port->dev_num < IB_UMAD_MAX_PORTS)
+		clear_bit(devnum, dev_map);
+	else
+		clear_bit(devnum, oflo_map);
 
 	return -1;
 }
@@ -1079,7 +1112,10 @@ static void ib_umad_kill_port(struct ib_umad_port *port)
 
 	mutex_unlock(&port->file_mutex);
 
-	clear_bit(port->dev_num, dev_map);
+	if (port->dev_num < IB_UMAD_MAX_PORTS)
+		clear_bit(port->dev_num, dev_map);
+	else
+		clear_bit(port->dev_num - IB_UMAD_MAX_PORTS, oflo_map);
 }
 
 static void ib_umad_add_one(struct ib_device *device)
@@ -1187,6 +1223,8 @@ static void __exit ib_umad_cleanup(void)
 	ib_unregister_client(&umad_client);
 	class_destroy(umad_class);
 	unregister_chrdev_region(base_dev, IB_UMAD_MAX_PORTS * 2);
+	if (oflo_maj)
+		unregister_chrdev_region(oflo_maj, IB_UMAD_MAX_PORTS * 2);
 }
 
 module_init(ib_umad_init);
