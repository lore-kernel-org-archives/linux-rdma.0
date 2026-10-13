Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0EE4F30CF
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891975; cv=none; b=r2zfw2IxUulZe+lwS5/8jql0efzRl7fuV1n+MPyq6KVInzUTn+74YtMP5kGqSzVAjIJ4an7uWpHuMnZgnM+sbOZXGW/4560Ct4g3BZ2RgjAPhTAo8tI5/aZuETzRrhOEuiYIHz1CPHbW76vBu/fdknarvXM+PYavXZmp0CBMDEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891975; c=relaxed/simple;
	bh=0OliP7ptCs6MeaRJIrahUGF/TFc4Gll9XZ6CU8f2/04=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tgpssCfNfAzbzmSyYQJURz5r9BA2BSghuTRixNqGzeCy7UQaKBqALjDTG/Mm0a79Nx0FeEHKwNVifrYFjiw0HWH8O2dyP5BNsg8U/YtrKRCvvzq3zIbC7EkAK/8uRSeTzht3/vKKEjT1ZRQDVmA1imiMJ/ysDeJbXSaTn4OMFgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FU6oAM4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FU6oAM4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7101F000FF;
	Tue, 13 Oct 2026 11:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891973;
	bh=MI9WH0n7C94nbl7uHmCU5eUsP6cxH/XfMK8OQ0DFqL8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FU6oAM4fW+z+c7qflmayCgMkKQil4ZNBEKVBQ6hA8OGNs8kUxWooimbVCbo64U6es
	 eNSGn7qddpBhS2ldDGaaLNebVsunuP6lNphxXBwaVmZwxJ2wOwNX9xPUEagBD2RCIP
	 Uv4r12HGRNvTCAImg3f1/67GtjSnmSOsmKRPqkD4QwsOxcMlMKIIp0JBzqiIquDQSR
	 XpUvVqa+4Ugfarwo+do502/AXseRa4AV4Ra/vXxg1yOHyMWPN7XxTvFwEPbUlmFH0V
	 ZcRObpCaGjb4RcksPk4kZSyVD/xr9e5crscIIEFD3iCE0l8g3apnwIrFNz/9oLSjzH
	 xVc9fdP2j2uLg==
Message-ID: <sashiko-outbox-169649@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/15] yunsilicon: add RDMA device support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114412.2471317-10-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114412.2471317-10-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:13 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 13 potential issue=
(s) to consider:
- [Critical] rdma: arbitrary physical memory mapping via unvalidated vma si=
ze
- [High] rdma: ABI breakage due to size_t in UAPI structures
- [High] rdma: out-of-bounds access due to duplicated core private structs
- [High] rdma: hardcoded physical address offset breaks PCI mapping
- [High] rdma: API violation using virt_to_phys on DMA coherent memory
- [High] rdma: double free due to auxiliary driver unregister in reboot not=
ifier
- [High] rdma: use-after-free of netdev pointer due to missing reference an=
d unregister handling
- [High] rdma: race condition exposing uninitialized device state to usersp=
ace
- [Medium] rdma: truncated UAPI data due to fixed struct offset accumulator
- [Medium] rdma: integer underflow causes small MTUs to report maximum MTU
- [Medium] rdma: uninitialized ib_event structure dispatched on unhandled e=
vents
- [Medium] rdma: missing udata->inlen check in xsc_ib_alloc_ucontext()
- [Low] rdma: endian-dependent firmware version formatting
--

commit 206aea3bd72ce8a9a32742a3fba3649e658d1875
Author: Xin Tian <tianx@yunsilicon.com>
Subject: yunsilicon: add RDMA device support

This commit adds basic RDMA driver support for Yunsilicon XSC devices. It
includes device registration, port queries, memory mapping, and the uverbs
ABI header.

> diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc=
/main.c
> index 0000000000000..9d53a89beee02
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/main.c
> @@ -40,15 +40,29 @@ static int xsc_ib_query_device(struct ib_device *ibde=
v,
>  {
>  	size_t udata_outlen =3D (udata) ? udata->outlen : 0;
[ ... ]
>  	fw_ver.data =3D 0;
>  	fw_ver.s.ver_major =3D dev->xdev->fw_version_major;
>  	fw_ver.s.ver_minor =3D dev->xdev->fw_version_minor;
>  	fw_ver.s.ver_patch =3D dev->xdev->fw_version_patch;
>  	fw_ver.s.ver_tweak =3D dev->xdev->fw_version_tweak;
>  	props->fw_ver =3D fw_ver.data;

[Severity: Low]
Does this union-based assignment expose host endianness variations to the
UAPI? Because struct bitfield and byte layout depend on host endianness, the
resulting u64 will have a different value on little-endian versus big-endian
systems. Could explicit bit shifts be used instead to ensure a consistent
firmware version value across architectures?

>  	/*response tso_caps extend param*/
>  	if (offsetofend(typeof(resp), tso_caps) <=3D udata_outlen) {
>  		max_tso =3D dev->xdev->caps.log_max_tso ? (1 << dev->xdev->caps.log_ma=
x_tso) : 0;
>  		if (max_tso) {
>  			resp.tso_caps.max_tso =3D max_tso;
>  			resp.tso_caps.supported_qpts |=3D 1 << IB_QPT_RAW_PACKET;
>  			resp.response_length +=3D sizeof(resp.tso_caps);
>  		}
>  	}

[Severity: Medium]
Will this dynamic accumulation of lengths truncate UAPI data? The destinati=
on
buffer resp is a monolithic C structure with fixed offsets. If an
intermediate feature is disabled, its size is not added to response_length,
making the length fall behind the actual struct offset of subsequent fields.
When ib_copy_to_udata() is called with this length, will trailing features
like packet_pacing_caps be silently truncated before reaching userspace?

> @@ -292,10 +306,12 @@ int xsc_ib_alloc_ucontext(struct ib_ucontext *uctx,
>  			  struct ib_udata *udata)
>  {
>  	struct ib_device *ibdev =3D uctx->device;
>  	struct xsc_ib_dev *dev =3D to_xdev(ibdev);
>  	struct xsc_ib_alloc_ucontext_req req;
>  	struct xsc_ib_alloc_ucontext_resp resp;
>  	int err;
> =20
>  	if (!dev->ib_active)
>  		return -EAGAIN;
> =20
>  	err =3D ib_copy_from_udata(&req, udata, sizeof(req));

[Severity: Medium]
Can this copy read out-of-bounds memory or cause a fault? The copy happens
unconditionally using sizeof(req) without checking if udata->inlen is large
enough. If userspace provides a smaller buffer or passes 0 bytes, this could
read garbage data or return -EFAULT. Should it use min(udata->inlen,
sizeof(req)) instead?

> @@ -318,29 +334,16 @@ static int xsc_ib_mmap(struct ib_ucontext *ibcontex=
t, struct vm_area_struct *vma
>  {
>  	struct xsc_ib_dev *dev =3D to_xdev(ibcontext->device);
>  	struct xsc_core_device *xdev =3D dev->xdev;
>  	unsigned long offset =3D vma->vm_pgoff << PAGE_SHIFT;
>  	resource_size_t reg_base;
>  	resource_size_t reg_size =3D vma->vm_end - vma->vm_start;

[Severity: Critical]
Does this allow mapping arbitrary physical memory? The reg_size is derived
directly from the userspace mmap syscall arguments without any upper bound
validation against the legitimate boundaries of the PCI resource. When this
unvalidated reg_size is later passed to remap_pfn_range(), could a local us=
er
map adjacent physical memory belonging to the kernel or other hardware?

>  	if (offset =3D=3D (tx_db & PAGE_MASK))
>  		reg_base =3D pci_resource_start(xdev->pdev, xdev->bar_num) + (tx_db & =
PAGE_MASK);
[ ... ]
>  	reg_base =3D (xsc_core_is_pf(xdev) && !is_pf_bar_compressed(xdev)) ?
>  		reg_base - 0xA0000000 : reg_base;

[Severity: High]
Does subtracting this hardcoded constant break correct memory mapping on
generic platforms? PCI BARs are dynamically mapped, and the CPU physical
address from pci_resource_start() is already correct. Modifying the generic
PCI physical address with a hardcoded, architecture-specific offset like
0xA0000000 could cause remap_pfn_range() to map unrelated RAM or trap the
system instead of the intended MMIO registers.

> @@ -417,31 +419,25 @@ static void xsc_ib_event(struct xsc_core_device *de=
v, void *context,
>  			 enum xsc_dev_event event, unsigned long data)
>  {
>  	struct xsc_ib_dev *ibdev =3D (struct xsc_ib_dev *)context;
>  	struct ib_event ibev;
>  	u8 port =3D 0;
> =20
>  	switch (event) {
[ ... ]
>  	}
> =20
>  	ibev.device	      =3D &ibdev->ib_dev;
>  	ibev.element.port_num =3D port;
> =20
>  	if (ibdev->ib_active)
>  		ib_dispatch_event(&ibev);

[Severity: Medium]
Could this dispatch an uninitialized ib_event structure? The stack-allocated
ibev is not zero-initialized, and the switch statement lacks a default case.
If called with an unhandled event, ibev.event remains uninitialized, leading
to a garbage event type containing stack memory being dispatched to the core
and userspace.

> @@ -592,44 +601,31 @@ static int init_one(struct xsc_core_device *xdev,
>  		    struct xsc_ib_dev **ibdev)
>  {
>  	struct xsc_ib_dev *dev;
>  	int err;
> =20
>  	dev =3D (struct xsc_ib_dev *)ib_alloc_device(xsc_ib_dev, ib_dev);
>  	if (!dev)
>  		return -ENOMEM;
> =20
>  	dev->xdev =3D xdev;
>  	dev->netdev =3D xdev->netdev;

[Severity: High]
Does this store a pointer to the netdevice without taking a reference? The
assignment happens without dev_hold().

Looking at xsc_netdev_event() below, it explicitly ignores the
NETDEV_UNREGISTER event:

	switch (event) {
	case NETDEV_CHANGE:
	case NETDEV_UP:
	case NETDEV_DOWN:
		xsc_get_port_state(ibdev->netdev, &ev);
		xsc_ib_event(ibdev->xdev, ibdev, ev, (unsigned long)&port);
		break;
	default:
		break;
	}

If the underlying ethernet device is unbound, the netdevice is freed, leavi=
ng
dev->netdev as a dangling pointer. Subsequent calls to ib callbacks like
xsc_ib_query_port() would dereference this pointer, triggering a
use-after-free.

>  	err =3D ib_register_device(&dev->ib_dev, dev->ib_dev.name,
>  				 dev->xdev->device);
>  	if (err)
>  		goto err_free;
> =20
>  	rdma_roce_rescan_device(&dev->ib_dev);
>  	dev->ib_active =3D true;
>  	*ibdev =3D dev;
> =20
>  	xsc_register_netdev_notifier(dev);

[Severity: High]
Is there a race condition exposing the device before initialization is
complete? ib_register_device() publishes the device to userspace. However,
the netdev notifier is registered after this, and looking at xsc_ib_probe(),
init_iommu_state() is called after init_one() returns. This creates a window
where userspace can open the device and attempt operations before the IOMMU
mode is resolved or link events are tracked.

> @@ -704,22 +701,21 @@ static void init_iommu_state(struct xsc_ib_dev *dev)
>  {
>  	struct iommu_domain *domain;
> =20
>  	dev->iommu_state =3D XSC_IB_IOMMU_MAP_DISABLE;
>  	domain =3D iommu_get_domain_for_dev(dev->ib_dev.dma_device);
>  	if (domain) {
>  		if (domain->type & __IOMMU_DOMAIN_DMA_API)
>  			dev->iommu_state =3D XSC_IB_IOMMU_MAP_NORMAL;
>  	} else {
>  		dma_addr_t dma_addr;
>  		void *tmp;
> =20
>  		tmp =3D dma_alloc_coherent(dev->ib_dev.dma_device, PAGE_SIZE,
>  					 &dma_addr, GFP_KERNEL);
>  		if (tmp) {
>  			if (virt_to_phys(tmp) !=3D dma_addr)

[Severity: High]
Does this violate the DMA API? Calling virt_to_phys() on memory returned by
dma_alloc_coherent() is generally unsafe because the virtual address may not
be part of the direct linear mapping (e.g., vmalloc space on ARM/MIPS).
Passing such an address to virt_to_phys() yields an incorrect physical
address and can trigger crashes if CONFIG_DEBUG_VIRTUAL is enabled.

> @@ -758,21 +757,17 @@ static struct auxiliary_driver xsc_ib_driver =3D {
>  	.id_table =3D xsc_ib_id_table,
>  };
> =20
>  static int xsc_ib_reboot_event_handler(struct notifier_block *nb, unsign=
ed long action, void *data)
>  {
>  	pr_info("xsc ib driver recv %lu event\n", action);
> =20
>  	xsc_remove_rdma_driver();
> =20
>  	return NOTIFY_OK;
>  }
> =20
>  struct notifier_block xsc_ib_nb =3D {
>  	.notifier_call =3D xsc_ib_reboot_event_handler,
>  	.next =3D NULL,
>  	.priority =3D 2,
>  };
> =20
>  void xsc_remove_rdma_driver(void)
>  {
>  	auxiliary_driver_unregister(&xsc_ib_driver);
>  }
> =20
>  static int __init xsc_ib_init(void)
>  {
>  	int ret;
> =20
>  	ret =3D auxiliary_driver_register(&xsc_ib_driver);
>  	if (ret) {
>  		pr_err("failed to register auxiliary driver\n");
>  		return ret;
>  	}
> =20
>  	register_reboot_notifier(&xsc_ib_nb);
> =20
>  	return 0;
>  }
> =20
>  static void __exit xsc_ib_cleanup(void)
>  {
>  	unregister_reboot_notifier(&xsc_ib_nb);
>  	xsc_remove_rdma_driver();
>  }

[Severity: High]
Can this cause a double-free of the driver name? The reboot notifier
unconditionally calls xsc_remove_rdma_driver(), which invokes
auxiliary_driver_unregister(). If the module is later unloaded,
xsc_ib_cleanup() calls unregister_reboot_notifier() and then
xsc_remove_rdma_driver() a second time.

> diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/x=
sc/xsc_ib.h
> index 0000000000000..a2ae382e22ce8
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/xsc_ib.h
> @@ -379,15 +379,20 @@ static inline enum ib_mtu xsc_net_to_ib_mtu(unsigne=
d int mtu)
>  {
>  	mtu =3D mtu - (IB_GRH_BYTES + IB_UDP_BYTES + IB_BTH_BYTES +
>  		     IB_EXT_XRC_BYTES + IB_EXT_ATOMICETH_BYTES +
>  		     IB_ICRC_BYTES);
>  	if (mtu >=3D 8192)
>  		return IB_MTU_8192;

[Severity: Medium]
Will this trigger an integer underflow if the netdevice MTU is smaller than
96 bytes? Subtracting the fixed headers without an upper bound or minimum
check means a small MTU wraps around to a massive positive number. The check
for mtu >=3D 8192 then evaluates to true, incorrectly returning IB_MTU_8192
instead of properly clamping the value.

> @@ -436,25 +436,20 @@ struct ib_mad_list_head {
>  	struct list_head list;
>  	struct ib_cqe cqe;
>  	struct ib_mad_queue *mad_queue;
>  };
> =20
>  #define IB_MAD_SEND_REQ_MAX_SG 2
>  struct ib_mad_send_wr_private {
>  	struct ib_mad_list_head mad_list;
>  	struct list_head agent_list;
>  	struct ib_mad_agent_private *mad_agent_priv;

[Severity: High]
Does this safely duplicate internal RDMA MAD core structures? The driver
illegitimately duplicates private core structures like
ib_mad_send_wr_private and ib_mad_private. Since these are internal to the
RDMA core, they may change layout at any time.

When xsc_ib_send_mad_sg_virt_addr() unsafely casts core pointers using these
locally duplicated structures:

	mad_list =3D container_of(wr->wr_cqe, struct ib_mad_list_head, cqe);
	mad_send_wr =3D container_of(mad_list, struct ib_mad_send_wr_private,
				   mad_list);

will this lead to out-of-bounds reads or memory corruption if the core
updates the upstream layout?

> @@ -483,16 +483,12 @@ static inline void *xsc_ib_send_mad_sg_virt_addr(st=
ruct ib_device *ibdev,
>  						 const struct ib_send_wr *wr,
>  						 int sg)
>  {
>  	struct ib_mad_send_wr_private *mad_send_wr;
>  	struct ib_mad_list_head *mad_list;
>  	int iommu_state =3D xsc_ib_iommu_dma_map(ibdev);
> =20
>  	/* direct dma mapping */
>  	if (!iommu_state)
>  		return phys_to_virt(dma_to_phys(ibdev->dma_device, wr->sg_list[sg].add=
r));

[Severity: High]
Does manually reverse-mapping a dma_addr_t to a virtual address using
phys_to_virt(dma_to_phys(...)) break coherency on SWIOTLB architectures or
cause crashes if the buffer is in HighMem?

> diff --git a/include/uapi/rdma/xsc-abi.h b/include/uapi/rdma/xsc-abi.h
> index 0000000000000..c4d0db30e43c4
> --- /dev/null
> +++ b/include/uapi/rdma/xsc-abi.h
> @@ -82,21 +82,18 @@ struct xsc_ib_alloc_ucontext_resp {
>  	__u32	reserved[32];
>  };
> =20
>  struct xsc_ib_create_qp {
>  	__u64	buf_addr;
>  	__u64	db_addr;
>  	__u32	sq_wqe_count;
>  	__u32	rq_wqe_count;
>  	__u32	rq_wqe_shift;
>  	__u32	flags;
> =20
>  	int	dmabuf_fd;
>  	size_t	dmabuf_sz;
>  };

[Severity: High]
Does using size_t in a UAPI struct break ABI compatibility? size_t changes
from 4 bytes on 32-bit architectures to 8 bytes on 64-bit architectures,
causing struct size and alignment mismatches. If a 32-bit userspace program
interacts with a 64-bit kernel, the kernel will read fields at incorrect
offsets. Should an explicitly sized type like __u64 be used instead?

> @@ -112,18 +112,16 @@ struct xsc_ib_create_srq_resp {
>  };
> =20
>  struct xsc_ib_create_cq {
>  	__u64 buf_addr;
>  	__u64 db_addr;
>  	__u32	cqe_size;
> =20
>  	int	dmabuf_fd;
>  	size_t	dmabuf_sz;
>  };

[Severity: High]
Does using size_t in this UAPI struct cause the same ABI breakage across
32-bit and 64-bit boundaries as mentioned above? Explicitly sized types are
required for stable UAPI boundaries.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D9
