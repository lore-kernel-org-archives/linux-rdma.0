Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296F030D411;
	Thu, 16 Jul 2026 01:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784164064; cv=none; b=o1pntPcW7GL/4ieBDEFm5m8JSt9gS52QwC2GIxtw5h+Q/gz6hqNZ3zAuKye+Tjrpxw3T5V+I0ghbxZqkHSKGamjJvpXio0oLxpBlLu24qZNoqU3khDCnkmOEZFGY8fonYiz3qUqjgkIT6Yj6SdhCME/XHdgJVZOK5OURiG/zDug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784164064; c=relaxed/simple;
	bh=5mGPqdBzgZCU76/AXTHqb90cph8IhAIk4vJhe8ZEpn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=M60z6JerwzYfyxFrYe1CG3er6Y4BimREn/PCRr4aRDJDVpw7xPbeAv926WD24sFOKwESl/ZugBGwp19To5+v/inUnssmhyAU+vpcas5d73cCWl6WiUE2+kJaqYn2jVXzsCO0MAq7u13e2zTgBZKogai4kuk4Wj/tAxWW8AwNuCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=yR6iu4+m; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="yR6iu4+m"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=u3hQkWIKM9rLk74FG4EzV/OU5cfjkjl4u73zLaFEaew=;
	b=yR6iu4+m0jMMxlXtzIE64e3SQGhOy7b0OXPc3EROVeSAetdOJW1Ez4f1Yky9iTxCpPHDn3jMy
	MYc/BTrazH8jDTO5q7Ch0H7/mqR1HiC929kYLr0AvvmMxcFl9J5Gws2ihLLpJSZ/PifIi6VfS8J
	LjcGst1AhoMzV6H1djNFEuA=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h0vm74C2kz12LCc;
	Thu, 16 Jul 2026 08:57:59 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id EBA3440575;
	Thu, 16 Jul 2026 09:07:36 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 16 Jul 2026 09:07:36 +0800
Message-ID: <7dd5c995-a23c-4d3a-9ba0-7fc77972339f@huawei.com>
Date: Thu, 16 Jul 2026 09:07:35 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 0/4] vfio/dma-buf: add TPH support for peer-to-peer
 access
To: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Michael Guralnik <michaelgur@nvidia.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: <kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <20260715204008.3911275-1-zhipingz@meta.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <20260715204008.3911275-1-zhipingz@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemo500009.china.huawei.com (7.202.194.199)

Hi Zhiping,

One concern I'd like to raise is the implicit topology constraint of the
TPH P2P path. TPH Steering Tag only works reliably when both importer and
exporter devices sit under the same Root Port (or same TPH-aware switch).

For cross-Root-Port P2P traffic (e.g. P2P devices located in different
RC or even socket), most server-grade Root Complexes do not forward TPH
prefixes through their internal routing. The ST field gets silently
stripped before reaching the target device, so all TPH setup becomes
ineffective with no error reported to user.

Because cross-Root-Port P2P traffic with ST does not affect the host, but
merely the completer may experience some performance degradation because
it lacks the TPH hint. In this case, I suggest adding restrictions in the
uAPI.

A further step is to check whether the importer and exporter are under
the same root port. However, this verification will cause the P2P TPH
to be unsupported in the case of multi-host or multi-root PCIe switch.

Thanks

On 7/16/2026 4:39 AM, Zhiping Zhang wrote:
> This series adds TLP Processing Hints (TPH) support to the VFIO dma-buf
> export path, allowing importing drivers (e.g. mlx5) to use the
> exporter's steering tag when performing peer-to-peer DMA into a
> VFIO-owned device.
> 
> There is no separate in-tree vendor kernel driver for the target device:
> vfio-pci is the in-tree driver and the targeted device is managed
> from userspace via VFIO passthrough. That is why the ST has to flow
> through a uAPI: userspace owns the device and its ST table, so it is the
> entity that can configure a meaningful value for a given dma-buf. The
> kernel-visible participants are still in-tree: vfio-pci exports the
> dma-buf and mlx5 imports it.
> 
> On the effect: the endpoint's PCIe ingress block uses the ST as
> an in-band instruction for the incoming P2P TLP -- selecting a target
> cache partition and, on writes, an in-flight operation on the data
> before it lands. The dma-buf callback keeps this opaque to the
> framework -- only the producer (userspace owner of the VFIO device)
> and the consumer (endpoint block) need to interpret the value. The
> dma-buf get_pci_tph callback itself is optional, but workloads that
> depend on the endpoint's in-flight operation need it because fallback
> does not produce the same result.
> 
> The dma-buf hook is intentionally generic and discoverable rather than
> a private side channel. The exporter owns the completing address
> space for the dma-buf and decides whether it can provide a meaningful
> ST/PH tuple for that completer; the dma-buf core keeps the tuple opaque,
> and importers merely request the namespace they support and place the
> returned value on generated TLPs. Exporters that cannot derive a
> meaningful tuple simply return -EOPNOTSUPP.
> 
> Patch 1 adds small PCI/TPH type helpers so drivers can query the enabled
> TPH requester mode and the device's TPH Completer Supported field
> without reaching into pci_dev internals (and so callers in
> CONFIG_PCIE_TPH=n builds get a clean fallback). pcie_tph_completer_type()
> reuses the reserved-encoding fold introduced by the separately-submitted
> folding patch rather than duplicating the completer decode.
> Patch 2 adds the optional dma_buf_ops::get_pci_tph callback plus the
> dma_buf_get_pci_tph() importer wrapper so importers can fetch TPH
> metadata from an exporter under dmabuf->resv.
> Patch 3 implements get_pci_tph in vfio-pci and adds the new uAPI
> (VFIO_DEVICE_FEATURE_DMA_BUF_TPH) for userspace to attach the metadata.
> Patch 4 wires up the mlx5 RDMA driver as a consumer. It also enforces the
> dma_buf_get_pci_tph() steering-tag lifetime: the tag is only valid for the
> mapping it was queried against, and the mkey's TPH fields cannot be
> reprogrammed in place. mlx5 therefore records the registration-time tuple
> and re-queries after each dma-buf mapping is established under dmabuf->resv;
> unchanged tuples continue with the existing mkey, while changed or missing
> tuples fail the remap rather than continue with a stale hint. For vfio-pci
> BAR dma-bufs this is expected to be a no-op because invalidation is
> revoke/quiesce, not movement to a new backing placement, and the
> userspace-provided tuple is not changed by the revoke/un-revoke path.
> 
> Build-tested with both CONFIG_PCIE_TPH=y and CONFIG_PCIE_TPH=n.
> Functional validation on the target topology: PCIe analyzer captures
> on the P2P TLPs confirm the ST emitted by mlx5 matches the value
> configured through VFIO_DEVICE_FEATURE_DMA_BUF_TPH, and the end-to-end
> P2P workload only produces results consistent with the endpoint's
> ST-selected in-flight operation. For example, with userspace
> configuring 8-bit ST=0xf0 and PH=2, an analyzer capture of a peer-to-
> peer MWr64 shows "STP MWr64 TC=0 OHC=2 ..." followed by "OHC-B
> ST=F0h PH=2 HV=1":
> (TLP Captures)
> 08000260 -> STP MWr64 TC=0 OHC=2 TS=0 Attr=0 L=8
> F0000004 -> RID=4h:0h.0h EP- Tag=F0h
> E0200000 -> AddrH=000020E0h
> 00080006 -> AddrL=06000800h
> 90F00000 -> OHC-B ST=F0h PH=2 HV=1 AMA=0 AV-
> 
> The dma-buf get_pci_tph interface has also been exercised by a second,
> independent importer: a different vendor's NIC whose driver is not yet
> upstream, locally taught to call dma_buf_get_pci_tph(). A PCIe analyzer
> confirmed the ST it placed on outbound P2P TLPs matches the value
> configured through VFIO_DEVICE_FEATURE_DMA_BUF_TPH, the same result as
> with mlx5. Two unrelated importer drivers exercising the callback
> end-to-end shows the interface is not tied to a single consumer. That
> importer change is out-of-tree and not part of this series. For that
> second importer, with userspace configuring 8-bit ST=0xe0 and PH=0,
> an analyzer capture shows:
> (TLP Captures)
> 08200260 -> STP MWr64 TC=0 OHC=2 TS=1 Attr=0 L=8
> 4E00004C -> RID=4Ch:0h.0h EP- Tag=4Eh
> 00170000 -> AddrH=00001700h
> 00200006 -> AddrL=06002000h
> 10E00000 -> OHC-B ST=E0h PH=0 HV=1 AMA=0 AV-
> 
> Depends on (submitted separately):
>   net/mlx5: free mlx5_st_idx_data on final dealloc
>     https://lore.kernel.org/linux-rdma/20260612170406.3339093-1-zhipingz@meta.com
>   PCI/TPH: fold reserved completer encoding in get_rp_completer_type()
>     https://lore.kernel.org/linux-pci/20260715202409.3767494-1-zhipingz@meta.com
> 
> Changes since v11:
>   Patch 1 (PCI/TPH): add pcie_tph_completer_type() and
>   pcie_tph_enabled_req_type(); pcie_tph_completer_type() reuses the
>   reserved-encoding fold from the separately-submitted folding patch
>   rather than duplicating the completer decode.
> 
>   Patch 2 (dma-buf): fix the kernel-doc to reference
>   &dma_buf_attach_ops.invalidate_mappings instead of the non-existent
>   move_notify callback (reported by Sashiko and Alex Williamson).
> 
>   Patch 3 (vfio/pci): hold memory_lock while validating dma-buf ownership
>   and publishing TPH metadata, so cleanup cannot disassociate the dma-buf
>   from the VFIO device under the SET path. Also use WRITE_ONCE() for
>   revoked-state writers to pair with the lockless attach-path READ_ONCE().
> 
>   Patch 4 (mlx5): enforce the steering-tag lifetime documented in patch 2
>   (addresses the lifecycle gap Sashiko and Alex noted on v11). mlx5 now
>   stores the registration-time TPH tuple and re-queries the exporter after
>   each dma-buf mapping is established under dmabuf->resv. If the tuple is
>   unchanged, the existing mkey continues to be used. If it changed or
>   disappeared, mlx5 unmaps the pages and returns -EFAULT because the
>   existing mkey cannot be updated in place (no UMR update mask for TPH
>   fields, and rebuilding the mkey would change the rkey/lkey). The exporter
>   query runs under dmabuf->resv, but the ST-index allocation is done
>   outside it so no GFP_KERNEL allocation is held under dmabuf->resv. For
>   vfio-pci BAR dma-bufs this validation is expected to be a no-op because
>   the tuple is stable across revoke/un-revoke.
> 
> Previous link:
> v11: https://lore.kernel.org/linux-pci/20260702181025.2694961-1-zhipingz@meta.com/
> v10: https://lore.kernel.org/linux-pci/20260630224328.3218796-1-zhipingz@meta.com/
> v9: https://lore.kernel.org/dri-devel/20260622184211.2229399-1-zhipingz@meta.com/
> v8: https://lore.kernel.org/dri-devel/20260615065912.2177918-1-zhipingz@meta.com/
> v7: https://lore.kernel.org/dri-devel/20260611161546.4075580-1-zhipingz@meta.com/
> v6: https://lore.kernel.org/dri-devel/20260608185646.4085127-1-zhipingz@meta.com/
> v5: https://lore.kernel.org/dri-devel/20260526144401.1485788-1-zhipingz@meta.com/
> v4: https://lore.kernel.org/linux-pci/20260519201401.1558410-1-zhipingz@meta.com/
> v3: https://lore.kernel.org/linux-pci/20260512184755.4137227-1-zhipingz@meta.com/
> v2: https://lore.kernel.org/linux-pci/20260430200704.352228-1-zhipingz@meta.com/
> 
> Zhiping Zhang (4):
>   PCI/TPH: Add requester/completer type helpers
>   dma-buf: add optional get_pci_tph() callback
>   vfio/pci: implement get_pci_tph and DMA_BUF_TPH feature
>   RDMA/mlx5: get tph for p2p access when registering dma-buf mr
> 
>  drivers/dma-buf/dma-buf.c                     |  32 ++++
>  drivers/infiniband/hw/mlx5/main.c             |   1 +
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  11 ++
>  drivers/infiniband/hw/mlx5/mr.c               | 151 +++++++++++++++++--
>  drivers/infiniband/hw/mlx5/odp.c              |   7 +
>  .../net/ethernet/mellanox/mlx5/core/lib/st.c  |  49 +++++-
>  drivers/pci/tph.c                             |  39 ++++++
>  drivers/vfio/pci/vfio_pci_core.c              |   3 +
>  drivers/vfio/pci/vfio_pci_dmabuf.c            | 117 ++++++++++++-
>  drivers/vfio/pci/vfio_pci_priv.h              |  13 ++
>  include/linux/dma-buf.h                       |  25 +++
>  include/linux/mlx5/driver.h                   |  15 ++
>  include/linux/pci-tph.h                       |   8 +
>  include/uapi/linux/vfio.h                     |  43 +++++
>  14 files changed, 496 insertions(+), 18 deletions(-)
> 
> --
> 2.53.0-Meta
> 

