From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 1/2] device: Stop requiring that struct device is embedded
 in struct pci_dev
Date: Tue, 7 Mar 2017 02:41:32 +0000
Message-ID: <VI1PR0502MB3008D3B38ED2F3694E100E5ED12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
 <20170307003549.3872-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307003549.3872-2-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Monday, March 6, 2017 6:36 PM
> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>; Sebastian Ott
> <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>;
> Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>; David Woodhouse
> <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; H . Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>; Ingo Molnar
> <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
> Subject: [PATCH 1/2] device: Stop requiring that struct device is embedde=
d in
> struct pci_dev
>=20
> The dma mapping operations of several architectures and also of several I=
/O
> MMU implementations need to translate a struct device pointer into a stru=
ct
> pci_dev pointer. This translation is performed by to_pci_dev(). That macr=
o
> assumes that struct device is embedded in struct pci_dev. However, that i=
s
> not the case for the device structure in struct ib_device. Since that dev=
ice
> structure is passed to DMA mapping operations since kernel v4.11-rc1,
> introduce a pointer in struct device to make the translation from struct
> device into struct pci_dev more flexible.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
> Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
> ---
>  drivers/pci/probe.c    | 1 +
>  include/linux/device.h | 5 +++++
>  include/linux/pci.h    | 5 ++++-
>  3 files changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/device.h b/include/linux/device.h index
> 30c4570e928d..c18afd376d2a 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -42,6 +42,7 @@ struct fwnode_handle;
>  struct iommu_ops;
>  struct iommu_group;
>  struct iommu_fwspec;
> +struct pci_dev;
>=20
>  struct bus_attribute {
>  	struct attribute	attr;
> @@ -860,6 +861,9 @@ struct dev_links_info {
>   * 		segment limitations.
>   * @dma_pools:	Dma pools (if dma'ble device).
>   * @dma_mem:	Internal for coherent mem override.
> + * @pci_dev:	PCI device associated with this device. Used by DMA
> mapping
> + *		operations on architectures that need access to PCI device
> + *		members that are not in struct device.
>   * @cma_area:	Contiguous memory area for dma allocations
>   * @archdata:	For arch-specific additions.
>   * @of_node:	Associated device tree node.
> @@ -940,6 +944,7 @@ struct device {
>=20
>  	struct dma_coherent_mem	*dma_mem; /* internal for coherent
> mem
>  					     override */
> +	struct pci_dev		*pci_dev; /* for DMA mapping operations */

Compilation would break when CONFIG_PCI is not defined for some embedded pl=
atforms.
More than that, including specific pci_dev structure pointer in generic str=
ucture such as device just doesn't sound right.
I tested equivalent patch that you sent, but I don't think this is right di=
rection to fix this bug.

>  #ifdef CONFIG_DMA_CMA
>  	struct cma *cma_area;		/* contiguous memory area for dma
>  					   allocations */
> diff --git a/include/linux/pci.h b/include/linux/pci.h index
> eb3da1a04e6c..eca790eaae20 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -409,7 +409,10 @@ static inline struct pci_dev *pci_physfn(struct
> pci_dev *dev)
>=20
>  struct pci_dev *pci_alloc_dev(struct pci_bus *bus);
>=20
> -#define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
> +static inline struct pci_dev *to_pci_dev(const struct device *dev) {
> +	return dev->pci_dev;
> +}
>  #define for_each_pci_dev(d) while ((d =3D pci_get_device(PCI_ANY_ID,
> PCI_ANY_ID, d)) !=3D NULL)
>=20
>  static inline int pci_channel_offline(struct pci_dev *pdev)
> --
> 2.12.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
