From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: IB on s390 broken with commit 99db94940 "IB/core: Remove
 ib_device.dma_device"
Date: Mon, 27 Feb 2017 22:04:33 +0000
Message-ID: <1488233058.2597.1.camel@sandisk.com>
References: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1702272047120.2997@schleppi.fritz.box>
Content-Language: en-US
Content-ID: <C7EF43A8BDD7054D8A5F818D92F61982@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "sebott@linux.vnet.ibm.com" <sebott@linux.vnet.ibm.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "gerald.schaefer@de.ibm.com" <gerald.schaefer@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-02-27 at 21:17 +0100, Sebastian Ott wrote:
> commit 99db94940 "IB/core: Remove ib_device.dma_device"
> breaks infiniband on s390 (and I think also other archs that do something
> like to_pci_dev(dev) in one of their dma_ops callbacks).
>=20
> With this commit you use the dma_ops of the device that called
> ib_register_device but you call e.g. dma_map with ib_device->dev
> as an argument.
>=20
> S390's (pci specific) dma_map uses to_pci_dev(dev) to look into the
> pci device (and its arch specific data) and oopses.
>=20
> Calling dma_map with ib_device->dev.parent would work but then it
> wouldn't make sense to copy dma_ops and mask from ib_device->dev.parent
> to ib_device->dev..

How about something like the untested patch below?

---
 drivers/infiniband/core/device.c | 5 ++++-
 drivers/pci/probe.c              | 1 +
 include/linux/device.h           | 5 +++++
 include/linux/pci.h              | 5 ++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/dev=
ice.c
index a63e8400ea3b..989077fc6dbb 100644
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
@@ -336,8 +337,10 @@ int ib_register_device(struct ib_device *device,
 	struct device *parent =3D device->dev.parent;
=20
 	WARN_ON_ONCE(!parent);
-	if (!device->dev.dma_ops)
+	if (!device->dev.dma_ops) {
 		device->dev.dma_ops =3D parent->dma_ops;
+		device->dev.pci_dev =3D to_pci_dev(parent);
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
+ *		structure elements that are not in struct device.
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
index 282ed32244ce..ba1222f32046 100644
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
 static inline int pci_channel_offline(struct pci_dev *pdev)
--=20
2.12.0
