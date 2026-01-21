Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F1F3ED13B;
	Wed, 21 Jan 2026 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769000373; cv=none; b=lV0wPn5EJC+ujqSG4paPuZvY11805r/sY12nA5wj9ipma3GmBR9LnWP38H44gstBh9FYOa9+H6BxYKtPRCS/DvOTHvdm1CvcEfAq0L1ti5J0U88/ftTriieSrd/oyC+Qzky2BAlOpIxUZ93TAMxUiLLC3slmsfGbi2YyEpOCucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769000373; c=relaxed/simple;
	bh=W2rPiTt7POS+Rymv7il/JSlLvJ76kJZLP7yqkB/gfmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iS8lUvrSg3QnviAf8nlSbTmpJ+rlj/nIfEtgo+a2zEPDX1QPAfVpO4oZ9AfzsMskggwb+dZiMzkA9cioIGvwkB+MQlEDgL9iHqZYPD8033drQh4XPE+lzZPO/Zrs6vIAx7HmAhrbkryXZRwdGdarPNYukkQ9YHSd0RZF9Ns4eow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ea+Q3WRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ea+Q3WRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D538C116D0;
	Wed, 21 Jan 2026 12:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769000371;
	bh=W2rPiTt7POS+Rymv7il/JSlLvJ76kJZLP7yqkB/gfmg=;
	h=From:To:Cc:Subject:Date:From;
	b=ea+Q3WRy2FiSABNW/9niK0WvNzge7rD9suFwk6d+tPTgwv1TkWt7BR+E2wfmOMHf2
	 ONEsHZtzbyMk1AKsw72wPiI7hPZhQxXp5six5NvXYka1th0ZVIwrnAdzPAW2twSds8
	 QpxPuHqYtogOogTCKwpgZSLmPCaaqqWRWeMwVcwVjqnAvrzJjg9SC3URCKimztvVhF
	 uPOUaJ4u9gE7n8uZscmt/pBR+v/5Q/NfqWYwhX2P58PXSDXOM8lgDZFVkaZ8Nk+qvC
	 0hUbFns2SLdm1dXiEzn/ldfyOZFRdxS4+KEVqwLK/2qDt7X8TYnDDxTQZHn6gzpcxB
	 WRF/6hUo4kf2Q==
From: Leon Romanovsky <leon@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v4 0/8] dma-buf: Use revoke mechanism to invalidate shared buffers
Date: Wed, 21 Jan 2026 14:59:08 +0200
Message-ID: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20251221-dmabuf-revoke-b90ef16e4236
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit

Changelog:
v4:
 * Changed DMA_RESV_USAGE_KERNEL to DMA_RESV_USAGE_BOOKKEEP.
 * Made .invalidate_mapping() truly optional.
 * Added patch which renames dma_buf_move_notify() to be
   dma_buf_invalidate_mappings().
 * Restored dma_buf_attachment_is_dynamic() function.
v3: https://lore.kernel.org/all/20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com/
 * Used Jason's wordings for commits and cover letter.
 * Removed IOMMUFD patch.
 * Renamed dma_buf_attachment_is_revoke() to be dma_buf_attach_revocable().
 * Added patch to remove CONFIG_DMABUF_MOVE_NOTIFY.
 * Added Reviewed-by tags.
 * Called to dma_resv_wait_timeout() after dma_buf_move_notify() in VFIO.
 * Added dma_buf_attach_revocable() check to VFIO DMABUF attach function.
 * Slightly changed commit messages.
v2: https://patch.msgid.link/20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com
 * Changed series to document the revoke semantics instead of
   implementing it.
v1: https://patch.msgid.link/20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com

-------------------------------------------------------------------------
This series documents a dma-buf “revoke” mechanism: to allow a dma-buf
exporter to explicitly invalidate (“kill”) a shared buffer after it has
been distributed to importers, so that further CPU and device access is
prevented and importers reliably observe failure.

The change in this series is to properly document and use existing core
“revoked” state on the dma-buf object and a corresponding exporter-triggered
revoke operation.

dma-buf has quietly allowed calling move_notify on pinned dma-bufs, even
though legacy importers using dma_buf_attach() would simply ignore
these calls.

RDMA saw this and needed to use allow_peer2peer=true, so implemented a
new-style pinned importer with an explicitly non-working move_notify()
callback.

This has been tolerable because the existing exporters are thought to
only call move_notify() on a pinned DMABUF under RAS events and we
have been willing to tolerate the UAF that results by allowing the
importer to continue to use the mapping in this rare case.

VFIO wants to implement a pin supporting exporter that will issue a
revoking move_notify() around FLRs and a few other user triggerable
operations. Since this is much more common we are not willing to
tolerate the security UAF caused by interworking with non-move_notify()
supporting drivers. Thus till now VFIO has required dynamic importers,
even though it never actually moves the buffer location.

To allow VFIO to work with pinned importers, according to how dma-buf
was intended, we need to allow VFIO to detect if an importer is legacy
or RDMA and does not actually implement move_notify().

In theory all exporters that call move_notify() on pinned dma-buf's
should call this function, however that would break a number of widely
used NIC/GPU flows. Thus for now do not spread this further than VFIO
until we can understand how much of RDMA can implement the full
semantic.

In the process clarify how move_notify is intended to be used with
pinned dma-bufs.

Thanks

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (8):
      dma-buf: Rename .move_notify() callback to a clearer identifier
      dma-buf: Rename dma_buf_move_notify() to dma_buf_invalidate_mappings()
      dma-buf: Always build with DMABUF_MOVE_NOTIFY
      dma-buf: Make .invalidate_mapping() truly optional
      dma-buf: Add check function for revoke semantics
      iommufd: Pin dma-buf importer for revoke semantics
      vfio: Wait for dma-buf invalidation to complete
      vfio: Validate dma-buf revocation semantics

 drivers/dma-buf/Kconfig                     | 12 -------
 drivers/dma-buf/dma-buf.c                   | 53 ++++++++++++++++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 +++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |  2 +-
 drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
 drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
 drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++--
 drivers/gpu/drm/xe/xe_bo.c                  |  2 +-
 drivers/gpu/drm/xe/xe_dma_buf.c             | 14 +++-----
 drivers/infiniband/core/umem_dmabuf.c       | 13 -------
 drivers/infiniband/hw/mlx5/mr.c             |  2 +-
 drivers/iommu/iommufd/pages.c               | 11 ++++--
 drivers/iommu/iommufd/selftest.c            |  2 +-
 drivers/vfio/pci/vfio_pci_dmabuf.c          | 13 +++++--
 include/linux/dma-buf.h                     |  9 ++---
 15 files changed, 84 insertions(+), 74 deletions(-)
---
base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
change-id: 20251221-dmabuf-revoke-b90ef16e4236

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

