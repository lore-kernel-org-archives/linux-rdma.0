Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=141.105.120.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895464;
	b=jVBseSMhjr8qFgPmY64zdJtK60nuBDUfwvXN2kSSKAR9BwbZZEMfBTnPY7+1yeXSaspW
	 C6dWJGIDvL6v7i24gHqR58npbnUxnystMFaJqNDCBB196zxTBkyjuQ7sBcF+wn5Ca/zvA
	 SB7T9pHkrPyGIuVyrmT4S5hJ+z9qbgmWlRmYJG3OFuaHJnt3dfQy/sfGB77YDY8omVP99
	 DHdeFi73y3gPEXByii0r7Av2Ji2e8TGp6jqvLJfzjMYKFtaN+/Xv6AMJ7TxgYOJOYHkoD
	 OjBizPJD949BNPrsVyeTwmMkEGt2YUSIg3okZNkFgnco5tpvLbom47392Ie/U7f73Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895464;
	h=DMARC-Filter:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=45BMwDl5+k3yl6C4+VgHK+KgYa2hgKR/ezUXr9zZDnA=;
	b=3G9WY1krc3MNMOsr0w+tRpr3PGUE0M5fQ/V9kim14yKG80FTz7DD49qF37GIU3x1TOMs
	 /FqcQ8gE0IAJzZ5mStcOnRpOMcdjWS6NVq7qnYeSmF0Cjs1JlIOwX0mdj0W52ITnj4tR5
	 2wl0DAPeQMq83OQsWYEYxK91P9ZFgiYEFyOgo56TxehG935gjtSMAoAvvuCH9o/4XepLT
	 uc0lnLg6qpXoODKJAJ9J5tpbXZLS7SDTCnXdnGDqPjoiLuj7nyJZrLE5eJ2dZZEFYIryi
	 HjChBXUO2n/xx2giwDCYN/7SA4/rZjKwJv2DoEEu1TNduLsJFahSn6qrmzKAr9Fk4zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lankhorst.se;
	spf=pass smtp.mailfrom=lankhorst.se;
	dkim=pass header.d=lankhorst.se header.i=@lankhorst.se header.a=rsa-sha256 header.s=default header.b=LiGqdCVf;
	arc=none smtp.remote-ip=141.105.120.124
Received: from lankhorst.se (unknown [141.105.120.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BFA606A33D;
	Thu,  5 Nov 2026 16:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9BFA606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lankhorst.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lankhorst.se header.i=@lankhorst.se header.a=rsa-sha256 header.s=default header.b=LiGqdCVf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1793895455;
	bh=sQcybDD0TFEKFGLjkC5J5HLRe1kKfr3bprl/6+1sRdw=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=LiGqdCVf46YxCnpoQZd83wAPplv4qbvls59YegWhExqo9VqC+Ps5ldIWkOn2agoZP
	 ZMXQqyPn8v2JWb0WVUOzST3N2QAj7aURdKGa3qhzvlROGXU7vrnoHvPVIRF7IdHuzO
	 +viukXbom4levRafdMCl/BqMKYR+tPU/xqK5AyRuJ+eup24NxbiNpf3j79O9RtGKCO
	 0P7KMFS8NmhaQAo2WDpHO+KxUzysVOYFtZ7TWVbD+xjHO/kqCG/4ebx50Fg3qVHL78
	 Hs0qZ5TwA7BG5c/HOGZG/mICcNXwtsmVDrm1fjfMqu0fD8ZO/+rDxUFBYgH0KNP3dL
	 MszzCu1UAZKkg==
Message-ID: <1a573649-adb5-43c7-93e5-c691af670ab5@lankhorst.se>
Date: Thu, 5 Nov 2026 17:18:31 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/23] DMA-buf mapping types
To: Alistair Popple <apopple@nvidia.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Mina Almasry <almasrymina@google.com>,
 netdev@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>,
 zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For the whole series:

Acked-by: Maarten Lankhorst <dev@lankhorst.se>

Great to see the non-sgt mapping types finally being a first class option in dma-buf.

On 11/5/26 07:40, Alistair Popple wrote:
> This is v2 of the DMA-buf mapping types series [1]. It keeps the framework
> and the SGT conversions from the RFC but defers the final mapping type
> selection until the first pin/map of the buffer.
>
> At pin/map the exporter chooses one of the types matched, taking the other
> attachments and the buffer's placement into account. That choice is held by the
> core until the exporter explicitly invalidates the attachment. This ensures
> unmap/remap cannot cause buffer movement and ping/pong.
>
> Future work will build on top of this series to add an iommufd importer type
> per the plan in [2], separate out PCIe P2P as its own mapping type and convert
> XGMI to an exclusive mapping type.
>
> Why mapping types
> -----------------
>
> Since its introduction, DMA-buf has only supported using scatterlist for
> the exporter and importer to exchange address information.  This is not
> sufficient for all use cases as dma_addr_t is a very specific and limited
> type that should not be abused for things unrelated to the DMA API.
>
> There are several motivations for addressing this now:
>  1) VFIO to IOMMUFD and KVM requires a physical address, not a dma_addr_t
>     scatterlist, it cannot be represented in the scatterlist structure
>  2) xe vGPU requires the host driver to accept a DMABUF from VFIO of its
>     own VF and convert it into an internal VRAM address on the PF
>  3) We are starting to look at replacement datastructures for
>     scatterlist
>  4) Ideas around UALink/etc are suggesting not using the DMA API
>  5) Private interconnects, such as XGMI, are forced to work around this using
>     driver-specific hacks.
>
> None of these can be achieved using scatterlist. This series introduces a
> "mapping type" mechanism allowing dma-buf to negotiate compatibility between
> different types and support alternate mapping options. See the description of
> patch 2 for more details.
>
> Selecting mapping type
> ----------------------
>
> Importers and exporters list possible mapping types with the exporter
> responsible for selecting the final type at pin/map time under the dma_resv
> lock. A matching phase at attachment time eliminates types which statically
> cannot be supported for a given exporter/importer.
>
> This was done in response to review comments on the RFC. Karl found that the
> RFC's match callback ran on an uninitialised attachment [3]. Christian noted
> that the final decision has to be made under the dma_resv lock before a
> mapping is created, not at attach [4], and Thomas proposed the three steps
> followed here: agree the possible types at attach, select at map, hold the
> selection until invalidate_mappings() [5]. Christian also noted that remaps
> must not change type or placement as that makes buffers ping/pong [6].
>
> The dma-buf core enforces that last point by calling select_mapping() only on
> the first pin/map after attach or after an invalidate. The pin/map type can
> therefore only change once the exporter has explicitly invalidated the mapping.
>
> Future work
> -----------
>
> This series stops at the SGT type so that the framework and the
> attach/pin/map contract can be reviewed on their own. I already have
> proof-of-concept conversions of both PCIe P2P (building on Thomas's work [7])
> and XGMI to separate mapping types. If those would be helpful for reviewing
> this series let me know and I will post them.
>
> Alternatively this series could be split up with patches 1-9 & 22-23 adding the
> general framework and the rest adding the conversions later.
>
> Further work, per [2], is an iommufd importer type to replace the private
> vfio/iommufd interface and allow other DMA-bufs to be imported into iommufd.
>
> Testing
> -------
>
> - KUnit dma-buf-mapping suite (patches 22 and 23) passes.
> - Every patch compile-tested with a config enabling all converted drivers.
>
> Changes since v1 [9]
> --------------------
>
> - Rebased onto v7.4-rc1. The rename also covers the new nvme-pci DMA-buf
>   importer and devmem's switch to pinning. xe's dynamic-debug knob for the
>   p2pdma distance check (3bc497a40178) is dropped, since the check is now
>   done by the core at match time, and amdgpu's PREEMPT-domain import
>   decision (78cdd96ab497) asks the negotiated match set instead of
>   attach->peer2peer.
> - The dma_buf_map_attachment()/dma_buf_unmap_attachment() rename is now the
>   first patch, squashed into one, and uses the shorter dma_buf_map_sgt() and
>   dma_buf_unmap_sgt() names (Christian [9]).
> - Dropped dma_buf_mapping_attach() and the dma_buf_sgt_attach() /
>   dma_buf_sgt_dynamic_attach() renames. Importers that support more than
>   the SGT type list them in a static dma_buf_attach_ops
>   ->supported_mapping_types table. The importing device is passed to the
>   mapping types through the match arguments rather than stored in each
>   entry. dma_buf_attach() and dma_buf_dynamic_attach() are unchanged for
>   everyone else (Christian [9]).
> - The selected type is an index into the attachment's match set, read
>   through dma_buf_attach_map_type(), instead of a copy in attach->map_type.
>   finish_match() fills the match set entry directly and select_mapping()
>   returns the index.
> - A failed pin or map only undoes a selection it made itself, so a map
>   failing under a held pin keeps the pinned type and a failed first pin
>   leaves the attachment unselected; KUnit tests for both (Karl [10]).
> - dma_buf_match_mapping() returns -EOPNOTSUPP when the two sides have no
>   type in common, keeping -EINVAL for an empty list, which restores the
>   error xe's own tests expect (Sashiko).
> - New DMA_SGT_EXPORTER_REQUIRES_P2P flavour that requires a P2P capable
>   importer without a pci_p2pdma_distance() check at match time, used by
>   vfio and uverbs so iommufd's non-PCI device can still attach and so no
>   pci_dev is dereferenced outside the dma_resv lock (Sashiko).
> - The SGT P2P distance check is quiet, as it was in xe and amdgpu before
>   the conversion (Sashiko).
> - Fixed a NULL importer_ops dereference in dma_buf_dynamic_attach() and the
>   NULL check order in dma_buf_unmap_sgt() (Sashiko).
> - Signed-off-by added to every patch (Jason). Patch 4 is now authored by me
>   with Jason as co-developer, as little of the original remains.
> - Not addressed: the Tegra fault with CONFIG_DMABUF_DEBUG that Karl
>   reported [12] is a pre-existing Tegra bug being fixed separately.
>
> Changes since RFC v1 [1]
> ------------------------
>
> - Dropped the PAL type and its vfio/iommufd users (RFC 21-25).
> - Rebased onto v7.3-rc5: move_notify is now invalidate_mappings,
>   CONFIG_DMABUF_MOVE_NOTIFY is gone, new amdxdna/panfrost/panthor
>   exporters converted, kzalloc_obj().
> - Patch 1 records the whole match set in a fixed-size array in the
>   attachment; patch 3 initialises the attachment before match_mapping()
>   (Karl); patch 15 holds a pci_dev reference instead of asserting the resv
>   lock (Baolu).
> - New patches 5, 6 and 7: exporter selection at pin/map with core-enforced
>   stickiness, match set queries, and dma_buf_mapping_map()/unmap().
> - xe and amdgpu conversions written against the final API; amdgpu's XGMI
>   override rewrites the recorded match set entry.
> - New patch 26 with KUnit tests for the selection contract.
>
> [1] https://lore.kernel.org/all/0-v1-b5cab63049c0+191af-dmabuf_map_type_jgg@nvidia.com/
> [2] https://lore.kernel.org/all/20260422150000.GK3199414@nvidia.com/
> [3] https://lore.kernel.org/all/20261016202653.97339-1-kmehltretter@gmail.com/
> [4] https://lore.kernel.org/all/d08a26ed-ded7-4447-bf7b-88597ee7df0e@amd.com/
> [5] https://lore.kernel.org/all/8d4cb20b70ac4c3f36d8d631769757158af2ac8e.camel@linux.intel.com/
> [6] https://lore.kernel.org/all/7b4dc988-5dbd-40e4-b17a-47b6eaf4bf81@amd.com/
> [7] https://gitlab.freedesktop.org/thomash/xe-vibe/-/commit/7452df0fc858a7dc5ccac0e2037852cb7ab64d61
> [8] https://lore.kernel.org/all/20261026053623.202642-1-apopple@nvidia.com/
> [9] https://lore.kernel.org/all/3151a820-c583-4968-8440-673a9e390446@amd.com/
> [10] https://lore.kernel.org/all/7193d384-5e28-4f85-8004-1dc9318d5c1c@amd.com/
> [11] https://lore.kernel.org/all/at8IQZ34wkHQ_5PL@gmail.com/
> [12] https://lore.kernel.org/all/auAIO0y09SXk34CN@gmail.com/
>
> ---
> Alistair Popple (5):
>       dma-buf: Negotiate the mapping type in dma_buf_dynamic_attach()
>       dma-buf: Let the exporter select mapping type at pin/map
>       dma-buf: Add match set queries for exporter placement decisions
>       dma-buf: Add dma_buf_mapping_map() returning a type-tagged mapping
>       dma-buf: Add kunit tests for mapping type selection
>
> Jason Gunthorpe (18):
>       treewide: Rename dma_buf_(un)map_attachment() to dma_buf_(un)map_sgt()
>       dma-buf: Introduce DMA-buf mapping types
>       dma-buf: Add the SGT DMA mapping type
>       dma-buf: Route SGT related actions through the attachment's mapping type
>       dma-buf: Allow single exporter drivers to avoid the match_mapping function
>       drm: Check the SGT ops for drm_gem_map_dma_buf()
>       dma-buf: Convert all the simple exporters to use SGT mapping type
>       drm/vmwgfx: Use match_mapping instead of dummy calls
>       accel/habanalabs: Use the SGT_P2P mapping type
>       drm/xe/dma-buf: Use the SGT mapping type
>       drm/amdgpu: Use the SGT mapping type
>       vfio/pci: Change the DMA-buf exporter to use mapping_type
>       RDMA/uverbs: Use the SGT_P2P mapping type
>       dma-buf: Update dma_buf_phys_vec_to_sgt() to use the SGT mapping type
>       iio: buffer: convert to use the SGT mapping type
>       functionfs: convert to use the SGT mapping type
>       dma-buf: Remove unused SGT stuff from the common structures
>       dma-buf: Add kunit tests for mapping type
>
>  drivers/accel/amdxdna/amdxdna_cbuf.c               |   8 +-
>  drivers/accel/amdxdna/amdxdna_gem.c                |  11 +-
>  drivers/accel/amdxdna/amdxdna_ubuf.c               |   8 +-
>  drivers/accel/habanalabs/common/memory.c           |  54 +-
>  drivers/accel/ivpu/ivpu_gem.c                      |   6 +-
>  drivers/accel/ivpu/ivpu_gem_userptr.c              |  11 +-
>  drivers/accel/qaic/qaic_data.c                     |   6 +-
>  drivers/dma-buf/Makefile                           |   1 +
>  drivers/dma-buf/dma-buf-mapping.c                  | 291 ++++++-
>  drivers/dma-buf/dma-buf.c                          | 266 ++++--
>  drivers/dma-buf/heaps/cma_heap.c                   |  12 +-
>  drivers/dma-buf/heaps/system_heap.c                |  13 +-
>  drivers/dma-buf/st-dma-mapping.c                   | 896 +++++++++++++++++++++
>  drivers/dma-buf/udmabuf.c                          |   8 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        | 136 ++--
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   4 +-
>  drivers/gpu/drm/armada/armada_gem.c                |  28 +-
>  drivers/gpu/drm/drm_prime.c                        |  28 +-
>  drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |  16 +-
>  drivers/gpu/drm/i915/gem/i915_gem_object.c         |   2 +-
>  .../gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c   |   4 +-
>  drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c   |   8 +-
>  drivers/gpu/drm/msm/msm_gem_prime.c                |   7 +-
>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |   9 +-
>  drivers/gpu/drm/panfrost/panfrost_gem.c            |  13 +-
>  drivers/gpu/drm/panthor/panthor_gem.c              |  11 +-
>  drivers/gpu/drm/tegra/gem.c                        |  26 +-
>  drivers/gpu/drm/virtio/virtgpu_prime.c             |  19 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_prime.c              |  32 +-
>  drivers/gpu/drm/xe/xe_bo.c                         |  16 +-
>  drivers/gpu/drm/xe/xe_dma_buf.c                    |  79 +-
>  drivers/iio/industrialio-buffer.c                  |  13 +-
>  drivers/infiniband/core/umem_dmabuf.c              |   8 +-
>  drivers/infiniband/core/uverbs_std_types_dmabuf.c  |  30 +-
>  drivers/iommu/iommufd/selftest.c                   |  18 +-
>  drivers/media/common/videobuf2/videobuf2-core.c    |   2 +-
>  .../media/common/videobuf2/videobuf2-dma-contig.c  |  23 +-
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c  |  18 +-
>  drivers/media/common/videobuf2/videobuf2-vmalloc.c |  13 +-
>  .../media/platform/nvidia/tegra-vde/dmabuf-cache.c |   6 +-
>  drivers/misc/fastrpc.c                             |  18 +-
>  drivers/nvme/host/pci-dmabuf.c                     |   6 +-
>  drivers/tee/tee_heap.c                             |  13 +-
>  drivers/usb/gadget/function/f_fs.c                 |   9 +-
>  drivers/vfio/pci/vfio_pci_dmabuf.c                 |  26 +-
>  drivers/xen/gntdev-dmabuf.c                        |  27 +-
>  include/linux/dma-buf-mapping.h                    | 420 ++++++++++
>  include/linux/dma-buf.h                            | 234 ++++--
>  include/trace/events/dma_buf.h                     |   2 +-
>  io_uring/zcrx.c                                    |   6 +-
>  net/core/devmem.c                                  |   8 +-
>  samples/vfio-mdev/mbochs.c                         |  10 +-
>  sound/soc/fsl/fsl_asrc_m2m.c                       |  12 +-
>  53 files changed, 2415 insertions(+), 536 deletions(-)
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20261105-dma_mapping_type_v4-f71180b977e8
>
> Best regards,
> --  
> Alistair Popple <apopple@nvidia.com>
>

