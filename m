From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: v4.11 mlx5 regression
Date: Fri, 3 Mar 2017 22:04:41 +0000
Message-ID: <1488578667.25946.1.camel@sandisk.com>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box>
         <1488233058.2597.1.camel@sandisk.com>
         <alpine.LFD.2.20.1702280950380.2045@schleppi.fritz.box>
         <1488300599.2370.5.camel@sandisk.com>
         <VI1PR0502MB30082C037BEE60367954ED0FD1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <1488312028.2370.12.camel@sandisk.com>
         <742435998.40235677.1488312819300.JavaMail.zimbra@redhat.com>
         <VI1PR0502MB30087B8BB5E6733E92E96D62D1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB30087B8BB5E6733E92E96D62D1560-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Content-ID: <E9C25665166AAD48ACB6E202B93E7B90-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-02-28 at 20:34 +0000, Parav Pandit wrote:
> In middle of debugging/using setup right now for other issue.
> I am basically using nvme-rdma target mode code and somewhere in path of =
MR or QP setup it fails.
> I am suspecting MR because QP1 creation has passed.
> I will get to the bottom of this to provide traces tomorrow.

Hello Parav,

The I/O MMU was disabled while I prepared and tested the patch series that
reworks DMA support for RDMA drivers. I assume that the error message you
reported means that the I/O MMU was enabled on your test setup? If so, can
you check whether the patch below makes the mlx5 driver (and all other RDMA
drivers) work again on your test setup?

Thanks,

Bart.


diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/dev=
ice.c
index 593d2ce6ec7c..d80e3f3b9bae 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/pci.h>
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
@@ -336,8 +337,12 @@ int ib_register_device(struct ib_device *device,
 	struct device *parent =3D device->dev.parent;
=20
 	WARN_ON_ONCE(!parent);
-	if (!device->dev.dma_ops)
+	if (!device->dev.dma_ops) {
 		device->dev.dma_ops =3D parent->dma_ops;
+		device->dev.pci_dev =3D to_pci_dev(parent);
+		/* For I/O MMU support */
+		device->dev.archdata =3D parent->archdata;
+	}
 	if (!device->dev.dma_mask)
 		device->dev.dma_mask =3D parent->dma_mask;
 	if (!device->dev.coherent_dma_mask)
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dfc9a2794141..60d739b59520 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1736,6 +1736,7 @@ struct pci_dev *pci_alloc_dev(struct pci_bus *bus)
=20
 	INIT_LIST_HEAD(&dev->bus_list);
 	dev->dev.type =3D &pci_dev_type;
+	dev->dev.pci_dev =3D dev;
 	dev->bus =3D pci_bus_get(bus);
=20
 	return dev;
diff --git a/include/linux/device.h b/include/linux/device.h
index 30c4570e928d..c18afd376d2a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -42,6 +42,7 @@ struct fwnode_handle;
 struct iommu_ops;
 struct iommu_group;
 struct iommu_fwspec;
+struct pci_dev;
=20
 struct bus_attribute {
 	struct attribute	attr;
@@ -860,6 +861,9 @@ struct dev_links_info {
  * 		segment limitations.
  * @dma_pools:	Dma pools (if dma'ble device).
  * @dma_mem:	Internal for coherent mem override.
+ * @pci_dev:	PCI device associated with this device. Used by DMA mapping
+ *		operations on architectures that need access to PCI device
+ *		members that are not in struct device.
  * @cma_area:	Contiguous memory area for dma allocations
  * @archdata:	For arch-specific additions.
  * @of_node:	Associated device tree node.
@@ -940,6 +944,7 @@ struct device {
=20
 	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
 					     override */
+	struct pci_dev		*pci_dev; /* for DMA mapping operations */
 #ifdef CONFIG_DMA_CMA
 	struct cma *cma_area;		/* contiguous memory area for dma
 					   allocations */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index eb3da1a04e6c..eca790eaae20 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -409,7 +409,10 @@ static inline struct pci_dev *pci_physfn(struct pci_de=
v *dev)
=20
 struct pci_dev *pci_alloc_dev(struct pci_bus *bus);
=20
-#define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
+static inline struct pci_dev *to_pci_dev(const struct device *dev)
+{
+	return dev->pci_dev;
+}
 #define for_each_pci_dev(d) while ((d =3D pci_get_device(PCI_ANY_ID, PCI_A=
NY_ID, d)) !=3D NULL)
=20
 static inline int pci_channel_offline(struct pci_dev *pdev)=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
