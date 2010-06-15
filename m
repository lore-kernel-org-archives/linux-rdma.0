From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] ofa_kernel/infiniband node description patch
Date: Tue, 15 Jun 2010 14:35:35 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E79E8@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, the node description of an HCA is set to a description of the HCA hardware or, at boot time, to a brief string containing the hostname of the node the HCA is installed in.

The problem is that if the host's DHCP server is slow, the node description may be set before the hostname, resulting in an entire fabric of nodes called "localhost".

This fix adds a small parsing function to the core infiniband code and a hook in each of the HCA drivers so that, at the time the HCA is actually queried for its node description, the description is scanned for an '@' character which is then replaced with the utsname of the node. This ensures that even if the hostname is initially set incorrectly, if it later changes the HCA will report the updated information.

In addition, the initialization code for HCA drivers that preset the node_desc has been patched to include an '@' character at the beginning of the description. This eliminates the need for a special initialization script - although existing scripts are still supported.

This updated patch incorporates feedback from Jason Gunthorpe and Or Gerlitz.

Signed-Off-By: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

---------------

Testing on Mellanox HCA, case 1 (default):

root@bart:~# cat /sys/class/infiniband/mthca0/node_desc
@:MT25218 InfiniHostEx Mellanox Technologies

[root@panic ~]# smpquery ND 6
Node Description: bart:MT25218 InfiniHostEx Mellanox Technologies


Testing on Mellanox HCA, case 2 - over 64 characters long:

root@bart:~# echo "0123456789112345678921234567893@234567894123456789512345678961234567897" >/sys/class/infiniband/mthca0/node_desc
root@bart:~# cat /sys/class/infiniband/mthca0/node_desc 
0123456789112345678921234567893@23456789412345678951234567896123

[root@panic sbin]# smpquery ND 6
Node Description:.0123456789112345678921234567893bart2345678941234567895123456789


Testing on Mellanox HCA, case 3 - short:

root@bart:~# echo "@" >/sys/class/infiniband/mthca0/node_desc

[root@panic sbin]# smpquery ND 6
Node Description:...........................bart

----------

Testing with QIB HCA:

[root@node-b2 ~]# cat /sys/class/infiniband/qib0/node_desc
@:QLogic kernel.org driver

[root@node-a1 ~]# smpquery ND 0x140
Node Description:.node-b2:QLogic kernel.org driver


[root@node-b2 1]# cat /sys/class/infiniband/qib0/node_desc
@

[root@node-a1 ~]# smpquery ND 0x140
Node Description:.........................node-b2


[root@node-b2 ~]# echo "0123456789112345678921234567893@234567894123456789512345678961234567897" >/sys/class/infiniband/qib0/node_desc

[root@node-a1 ~]# smpquery ND 0x140
Node Description:.0123456789112345678921234567893node-b22345678941234567895123456


-----------


diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index ef1304f..bdf1cfa 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -41,6 +41,7 @@
 #include "mad_rmpp.h"
 #include "smi.h"
 #include "agent.h"
+#include "linux/utsname.h"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("kernel IB MAD API");
@@ -932,6 +933,29 @@ int ib_get_mad_data_offset(u8 mgmt_class)
 }
 EXPORT_SYMBOL(ib_get_mad_data_offset);
 
+#define NODE_DESC_FIELD_LENGTH 64
+void ib_build_node_desc(char *dest, char *src)
+{
+	int i;
+	for (i=0; i<NODE_DESC_FIELD_LENGTH;) {
+		if (*src == '@') {
+			char *name = init_utsname()->nodename;
+			for (; *name && *name != '.' && i<NODE_DESC_FIELD_LENGTH; ++i)
+				*dest++ = *name++;
+			src++;
+		} else {
+			*dest++ = *src++;
+			i++;
+		}
+	}
+	if (i<NODE_DESC_FIELD_LENGTH) {
+		dest[i]=0;
+	} else {
+		dest[NODE_DESC_FIELD_LENGTH-1]=0;
+	}
+}
+EXPORT_SYMBOL(ib_build_node_desc);
+
 int ib_is_mad_class_rmpp(u8 mgmt_class)
 {
 	if ((mgmt_class == IB_MGMT_CLASS_SUBN_ADM) ||
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index a237d49..2217d1b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -356,6 +356,6 @@ int build_phys_page_list(struct ib_phys_buf *buffer_list,
 					__be64 **page_list);
 
 
-#define IWCH_NODE_DESC "cxgb3 Chelsio Communications"
+#define IWCH_NODE_DESC "@: cxgb3 Chelsio Communications"
 
 #endif
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index ceb98ee..9def630 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -60,7 +60,7 @@ static int recv_subn_get_nodedescription(struct ib_smp *smp,
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	memcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	ib_build_node_desc((char*)smp->data, ibdev->node_desc);
 
 	return reply(smp);
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index dd7f26d..db8b719 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -2180,7 +2180,7 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->dma_ops = &ipath_dma_mapping_ops;
 
 	snprintf(dev->node_desc, sizeof(dev->node_desc),
-		 IPATH_IDSTR " %s", init_utsname()->nodename);
+		 "@:" IPATH_IDSTR);
 
 	ret = ib_register_device(dev, NULL);
 	if (ret)
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index f38d5b1..d83398f 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -196,7 +196,7 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		spin_lock(&to_mdev(dev)->sm_lock);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		ib_build_node_desc((char*)((struct ib_smp *) mad)->data, dev->node_desc);
 		spin_unlock(&to_mdev(dev)->sm_lock);
 	}
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4e94e36..67e317f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -479,7 +479,9 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	if (err)
 		goto out;
 
-	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
+	dev->ib_dev.node_desc[0]='@';
+	dev->ib_dev.node_desc[1]=':';
+	memcpy(&(dev->ib_dev.node_desc[2]), out_mad->data, 62);
 
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 5648659..d71458e 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -153,7 +153,7 @@ static void node_desc_override(struct ib_device *dev,
 	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
 	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
 		mutex_lock(&to_mdev(dev)->cap_mask_mutex);
-		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		ib_build_node_desc((char*)((struct ib_smp *) mad)->data, dev->node_desc);
 		mutex_unlock(&to_mdev(dev)->cap_mask_mutex);
 	}
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 1e0b4b6..4c4dbe0 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1273,7 +1273,9 @@ static int mthca_init_node_data(struct mthca_dev *dev)
 		goto out;
 	}
 
-	memcpy(dev->ib_dev.node_desc, out_mad->data, 64);
+	dev->ib_dev.node_desc[0]='@';
+	dev->ib_dev.node_desc[1]=':';
+	memcpy(&(dev->ib_dev.node_desc[2]), out_mad->data, 62);
 
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 94b0d1f..f7e4b51 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -260,7 +260,7 @@ static int subn_get_nodedescription(struct ib_smp *smp,
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	memcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	ib_build_node_desc((char*)smp->data, ibdev->node_desc);
 
 	return reply(smp);
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index cda8f41..bd143e4 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2153,7 +2153,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->dma_ops = &qib_dma_mapping_ops;
 
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
-		 QIB_IDSTR " %s", init_utsname()->nodename);
+		 "@:" QIB_IDSTR);
 
 	ret = ib_register_device(ibdev, qib_create_port_files);
 	if (ret)
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..5916617 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -637,6 +637,14 @@ int ib_is_mad_class_rmpp(u8 mgmt_class);
 int ib_get_mad_data_offset(u8 mgmt_class);
 
 /**
+ * ib_build_node_desc - copies the node description and replaces
+ * any @ markers with the present system node name.
+ * @dest: destination
+ * @src: source
+ */
+void ib_build_node_desc(char *dest, char *src);
+
+/**
  * ib_get_rmpp_segment - returns the data buffer for a given RMPP segment.
  * @send_buf: Previously allocated send data buffer.
  * @seg_num: number of segment to return
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
