Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D073B6360
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484059; cv=none; b=pVTPKLx71ZOJOXf7USKKYtJ9OkZqIAfvvVoPJI4p9EVf7cR8dxPDzzzHZgPOkpl2xh+6c8KWnh025fvYusfTzjW8USWGnUbEkVd1QsSPakJ/NifdXsTOu6LpodxG2rzX7mcQAWW/8Q37NlIflfJj71vdRPBCklsm51WMptfWdo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484059; c=relaxed/simple;
	bh=NrtEpgxQUFrRc1uTeZZtwhQVm6kBTpOeb6Zgg5an5FE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0xmCPYfv6nO7aRLjz8riIJyhRhuRj0j0kwh8cwU1EOO4KEv4cIMOm/kunplSJjD9j63FDAUCCyudYc8FHohg88o8AniWwVu4j5BWsChlWqZ0W+NCx7SZE9Ny6WiGpQ5B7vM4RP7nXWsEh42nt/NN2Khk8okbxbZg/i4TXMqJYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UfIbyMaw; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UfIbyMaw"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cacf197759so100679295ad.2
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 11:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784484050; x=1785088850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xWOKjN21n342CNCWn9TzH0J09vI9mPVEGuCL2DJh7/4=;
        b=UfIbyMawCJcA7TNUIk4vhveVttM+K31M83v+ZIRteW5hIg/GlEXNM2souZCurveLo8
         DjGDBZosXPgqLhymMbkj8xAiMnR+XuRzYKojTMzQWtOy/pjo22PV1+PsXD7Th7h6FqX4
         sAMyFPSpwTrAksv7B5K692GtnAr64r8t5S1FXOJX1/aJmsusMY85Pt6kC3lA1wcnUWmv
         UmLuwk6Acq1B5FUbXHFgYfSfm+BiMwpKNw3dKNjnhf4Ai8LsIv5FH/0vToWVH+g91B6q
         nUBKW8Yj6z5trdH6n4UCSF0al6dEMa50I+VNS9N4GIgjO6kXJSc72b/vXeDnkQ7PC2ds
         mogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784484050; x=1785088850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xWOKjN21n342CNCWn9TzH0J09vI9mPVEGuCL2DJh7/4=;
        b=tL5qIm0VRNjRMmFIy9EWm+fZbFIPpz/J+3lPe5klOgmC5h+88HjwGD+jTQSqz/Ecm2
         ZU9h3gGI7FAGHAN1t6kJeyMkAWGmzYVD/57mJKXuAoxCQA6CpEIRzLKGlp84B26Bzbqy
         H5fX0Fcucbb7dM/t2hlfOsw7cKZNj2gujIsMUwgHGNcpiq47ZGi7vxa8FnmfdsGOURuQ
         nmTFqgbCC/863rVv42yVmn9CclGyZN8mRdsk8+tx44A4qEwSldW26NGQFOz/vx7ouxca
         4ObDinYd98VVuOpyaTKb/4GGpi7B+E9ukC9cHzzA5gVqCemJautPi4QotYQMZVjHYuxS
         vneA==
X-Forwarded-Encrypted: i=1; AHgh+RqjTA4jvIL4iILLMu4H1c8088WZZKtzV9vuWQuwi6+JKHQhFpz5HnzSYHEW1U0w9sVz565I6M3gC6o8@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+RvNPapE1twbpocUZWEd75I1MTGPM3NpRmi9Cc6fP3ckQP1sO
	1PHJ9Iv0HMZZg1paO2sHbg/bNyoG7NTa+Z59UaAHc4sjpFa4DqQF4myv
X-Gm-Gg: AfdE7cm+1B4SvGNKCCRbPpr6q8AGBvDXG1buFiBNHupxLHxrNL3iMnh1fUKyKC2YCh9
	jIFA14vAbwMosHUtoURVHg9yGiXdYVrrkglXREC2Dbz1+hJ1/Z4hdA9ctHzYKUmXXsjTjZjq6l2
	tW3a60X5bGaUV/soRE8Cl5zg5hSAMFr1CTefU9Ofswb89B12NOjUw+Ar3Pl/TqyPDJy6NCW+pNC
	M+ltdqPe8io6MvDdjz5VfN9xnBtXpv1e6TAlLvW3b8tr+GousWSAl4OlTxj+0zX7eow0huDdt8Z
	NKBX2mCluLBYesXyF2sHYlrIIkkHI5zIdec8Gw7PA6j4n04UGWzxfvKa0GPp3EJVEAEdipcrHrK
	aw6A+ZVIcjEupHUF6oXR6QbvPpjm0PPNejXrGk8Q9nze4HUqbsFskfIzqq9+VRsVLzg==
X-Received: by 2002:a17:902:c411:b0:2c9:97a9:2096 with SMTP id d9443c01a7336-2cf349edab6mr112140895ad.42.1784484049397;
        Sun, 19 Jul 2026 11:00:49 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34769bd6sm43511065ad.74.2026.07.19.11.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 11:00:48 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	Alexei Starovoitov <ast@kernel.org>,
	amd-gfx@lists.freedesktop.org,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrii Nakryiko <andrii@kernel.org>,
	Bill Wendling <morbo@google.com>,
	bpf@vger.kernel.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Dumazet <edumazet@google.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Hoyeon Lee <hoyeon.rhee@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	linaro-mm-sig@lists.linaro.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Michael Chan <michael.chan@broadcom.com>,
	Nathan Chancellor <nathan@kernel.org>,
	netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Simona Vetter <simona@ffwll.ch>,
	Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: [RFC PATCH net-next 06/13] drm/amdkfd: prepare kfd core for the knod provider
Date: Sun, 19 Jul 2026 17:58:50 +0000
Message-ID: <20260719175857.4071636-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719175857.4071636-1-ap420073@gmail.com>
References: <20260719175857.4071636-1-ap420073@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose the kfd internals the knod provider needs to build and run GPU
queues on behalf of the kernel: kernel-side event waiting, GPUVM
allocation for VRAM/GTT, doorbell access, and the HSA queue/packet
layout (kfd_hsa.h).  No functional change for existing user-mode
queue users; the provider itself is added in a following patch.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
(cherry picked from commit 7d2c7cbfbb2a4a80052b5793841f6a229271973d)
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  13 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  |  65 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c       |   3 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 117 ++---
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c     |  20 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c       | 112 ++++-
 drivers/gpu/drm/amd/amdkfd/kfd_events.h       |   4 +
 drivers/gpu/drm/amd/amdkfd/kfd_hsa.h          | 451 ++++++++++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_module.c       |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h         |  34 ++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      |  26 +-
 11 files changed, 778 insertions(+), 68 deletions(-)
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_hsa.h

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index e443a7277299..cf906b32eacb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -328,6 +328,8 @@ int amdgpu_amdkfd_gpuvm_sync_memory(
 		struct amdgpu_device *adev, struct kgd_mem *mem, bool intr);
 int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_mem *mem,
 					     void **kptr, uint64_t *size);
+int amdgpu_amdkfd_gpuvm_map_vram_bo_to_kernel(struct kgd_mem *mem,
+					      void **kptr, uint64_t *size);
 void amdgpu_amdkfd_gpuvm_unmap_gtt_bo_from_kernel(struct kgd_mem *mem);
 
 int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_bo *bo, struct amdgpu_bo **bo_gart);
@@ -446,7 +448,6 @@ bool kgd2kfd_vmfault_fast_path(struct amdgpu_device *adev, struct amdgpu_iv_entr
 			       bool retry_fault);
 void kgd2kfd_lock_kfd(void);
 void kgd2kfd_teardown_processes(struct amdgpu_device *adev);
-
 #else
 static inline int kgd2kfd_init(void)
 {
@@ -576,5 +577,15 @@ static inline void kgd2kfd_teardown_processes(struct amdgpu_device *adev)
 {
 }
 
+#endif
+
+#if defined(CONFIG_HSA_AMD_KNOD)
+int knod_init(struct amdgpu_device *adev);
+void knod_fini(struct amdgpu_device *adev);
+void knod_exit(void);
+#else
+static inline int knod_init(struct amdgpu_device *adev) { return 0; }
+static inline void knod_fini(struct amdgpu_device *adev) { }
+static inline void knod_exit(void) { }
 #endif
 #endif /* AMDGPU_AMDKFD_H_INCLUDED */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 35fe2c974699..79fd0ce7fc24 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2336,6 +2336,71 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_mem *mem,
 	return ret;
 }
 
+/** amdgpu_amdkfd_gpuvm_map_vram_bo_to_kernel() - Map a VRAM BO for kernel CPU access
+ *
+ * @mem: Buffer object to be mapped for CPU access
+ * @kptr[out]: pointer in kernel CPU address space
+ * @size[out]: size of the buffer
+ *
+ * Pins the BO and maps it for kernel CPU access. The eviction fence is removed
+ * from the BO, since pinned BOs cannot be evicted. The bo must remain on the
+ * validate_list, so the GPU mapping can be restored after a page table was
+ * evicted.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int amdgpu_amdkfd_gpuvm_map_vram_bo_to_kernel(struct kgd_mem *mem,
+					      void **kptr, uint64_t *size)
+{
+	int ret;
+	struct amdgpu_bo *bo = mem->bo;
+
+	if (amdgpu_ttm_tt_get_usermm(bo->tbo.ttm)) {
+		pr_err("userptr can't be mapped to kernel\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&mem->process_info->lock);
+
+	ret = amdgpu_bo_reserve(bo, true);
+	if (ret) {
+		pr_err("Failed to reserve bo. ret %d\n", ret);
+		goto bo_reserve_failed;
+	}
+
+	ret = amdgpu_bo_pin(bo, AMDGPU_GEM_DOMAIN_VRAM);
+	if (ret) {
+		pr_err("Failed to pin bo. ret %d\n", ret);
+		goto pin_failed;
+	}
+
+	ret = amdgpu_bo_kmap(bo, kptr);
+	if (ret) {
+		pr_err("Failed to map bo to kernel. ret %d\n", ret);
+		goto kmap_failed;
+	}
+
+	amdgpu_amdkfd_remove_eviction_fence(
+		bo, mem->process_info->eviction_fence);
+
+	if (size)
+		*size = amdgpu_bo_size(bo);
+
+	amdgpu_bo_unreserve(bo);
+
+	mutex_unlock(&mem->process_info->lock);
+	return 0;
+
+kmap_failed:
+	amdgpu_bo_unpin(bo);
+pin_failed:
+	amdgpu_bo_unreserve(bo);
+bo_reserve_failed:
+	mutex_unlock(&mem->process_info->lock);
+
+	return ret;
+}
+
 /** amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel() - Unmap a GTT BO for kernel CPU access
  *
  * @mem: Buffer object to be unmapped for CPU access
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 4c0c77eafbd1..aa974929d22a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2480,6 +2480,8 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 		drm_client_setup(adev_to_drm(adev), format);
 	}
 
+	knod_init(adev);
+
 	ret = amdgpu_debugfs_init(adev);
 	if (ret)
 		DRM_ERROR("Creating debugfs files failed (%d).\n", ret);
@@ -2540,6 +2542,7 @@ amdgpu_pci_remove(struct pci_dev *pdev)
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct amdgpu_device *adev = drm_to_adev(dev);
 
+	knod_fini(adev);
 	amdgpu_ras_eeprom_check_and_recover(adev);
 	amdgpu_xcp_dev_unplug(adev);
 	amdgpu_gmc_prepare_nps_mode_change(adev);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index c7edebd2fd8a..7879a6ffaa76 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -335,32 +335,27 @@ static int set_queue_properties_from_user(struct queue_properties *q_properties,
 	return 0;
 }
 
-static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
-					void *data)
+/*
+ * Create a queue from a kernel-filled queue_properties.  @q_properties is
+ * owned by the caller and must already be populated (the ioctl handler does
+ * this from user args via set_queue_properties_from_user(); in-kernel callers
+ * fill it directly).  On success *@queue_id_out and *@doorbell_offset_out are
+ * set.
+ */
+int kfd_create_queue(struct kfd_process *p, struct queue_properties *q_properties,
+		     u32 gpu_id, u32 *queue_id_out, u64 *doorbell_offset_out)
 {
-	struct kfd_ioctl_create_queue_args *args = data;
 	struct kfd_node *dev;
 	int err = 0;
 	unsigned int queue_id;
 	struct kfd_process_device *pdd;
-	struct queue_properties q_properties;
 	uint32_t doorbell_offset_in_process = 0;
 
-	memset(&q_properties, 0, sizeof(struct queue_properties));
-
-	pr_debug("Creating queue ioctl\n");
-
-	err = set_queue_properties_from_user(&q_properties, args);
-	if (err)
-		return err;
-
-	pr_debug("Looking for gpu id 0x%x\n", args->gpu_id);
-
 	mutex_lock(&p->mutex);
 
-	pdd = kfd_process_device_data_by_id(p, args->gpu_id);
+	pdd = kfd_process_device_data_by_id(p, gpu_id);
 	if (!pdd) {
-		pr_debug("Could not find gpu id 0x%x\n", args->gpu_id);
+		pr_debug("Could not find gpu id 0x%x\n", gpu_id);
 		err = -EINVAL;
 		goto err_pdd;
 	}
@@ -372,14 +367,14 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 		goto err_bind_process;
 	}
 
-	if (q_properties.type == KFD_QUEUE_TYPE_SDMA_BY_ENG_ID) {
+	if (q_properties->type == KFD_QUEUE_TYPE_SDMA_BY_ENG_ID) {
 		int max_sdma_eng_id = kfd_get_num_sdma_engines(dev) +
 				      kfd_get_num_xgmi_sdma_engines(dev) - 1;
 
-		if (q_properties.sdma_engine_id > max_sdma_eng_id) {
+		if (q_properties->sdma_engine_id > max_sdma_eng_id) {
 			err = -EINVAL;
 			pr_err("sdma_engine_id %i exceeds maximum id of %i\n",
-			       q_properties.sdma_engine_id, max_sdma_eng_id);
+			       q_properties->sdma_engine_id, max_sdma_eng_id);
 			goto err_sdma_engine_id;
 		}
 	}
@@ -392,7 +387,7 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 		}
 	}
 
-	err = kfd_queue_acquire_buffers(pdd, &q_properties);
+	err = kfd_queue_acquire_buffers(pdd, q_properties);
 	if (err) {
 		pr_debug("failed to acquire user queue buffers\n");
 		goto err_acquire_queue_buf;
@@ -402,42 +397,32 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 			p->lead_thread->pid,
 			dev->id);
 
-	err = pqm_create_queue(&p->pqm, dev, &q_properties, &queue_id,
+	err = pqm_create_queue(&p->pqm, dev, q_properties, &queue_id,
 			NULL, NULL, NULL, &doorbell_offset_in_process);
 	if (err != 0)
 		goto err_create_queue;
 
-	args->queue_id = queue_id;
-
+	*queue_id_out = queue_id;
 
 	/* Return gpu_id as doorbell offset for mmap usage */
-	args->doorbell_offset = KFD_MMAP_TYPE_DOORBELL;
-	args->doorbell_offset |= KFD_MMAP_GPU_ID(args->gpu_id);
+	*doorbell_offset_out = KFD_MMAP_TYPE_DOORBELL;
+	*doorbell_offset_out |= KFD_MMAP_GPU_ID(gpu_id);
 	if (KFD_IS_SOC15(dev))
 		/* On SOC15 ASICs, include the doorbell offset within the
 		 * process doorbell frame, which is 2 pages.
 		 */
-		args->doorbell_offset |= doorbell_offset_in_process;
+		*doorbell_offset_out |= doorbell_offset_in_process;
 
 	mutex_unlock(&p->mutex);
 
-	pr_debug("Queue id %d was created successfully\n", args->queue_id);
-
-	pr_debug("Ring buffer address == 0x%016llX\n",
-			args->ring_base_address);
-
-	pr_debug("Read ptr address    == 0x%016llX\n",
-			args->read_pointer_address);
-
-	pr_debug("Write ptr address   == 0x%016llX\n",
-			args->write_pointer_address);
+	pr_debug("Queue id %d was created successfully\n", queue_id);
 
 	kfd_dbg_ev_raise(KFD_EC_MASK(EC_QUEUE_NEW), p, dev, queue_id, false, NULL, 0);
 	return 0;
 
 err_create_queue:
-	kfd_queue_unref_bo_vas(pdd, &q_properties);
-	kfd_queue_release_buffers(pdd, &q_properties);
+	kfd_queue_unref_bo_vas(pdd, q_properties);
+	kfd_queue_release_buffers(pdd, q_properties);
 err_acquire_queue_buf:
 err_sdma_engine_id:
 err_bind_process:
@@ -446,6 +431,23 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 	return err;
 }
 
+static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
+				  void *data)
+{
+	struct kfd_ioctl_create_queue_args *args = data;
+	struct queue_properties q_properties;
+	int err;
+
+	memset(&q_properties, 0, sizeof(q_properties));
+
+	err = set_queue_properties_from_user(&q_properties, args);
+	if (err)
+		return err;
+
+	return kfd_create_queue(p, &q_properties, args->gpu_id,
+				&args->queue_id, &args->doorbell_offset);
+}
+
 static int kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p,
 					void *data)
 {
@@ -643,7 +645,7 @@ static int kfd_ioctl_set_memory_policy(struct file *filep,
 	return err;
 }
 
-static int kfd_ioctl_set_trap_handler(struct file *filep,
+int kfd_ioctl_set_trap_handler(struct file *filep,
 					struct kfd_process *p, void *data)
 {
 	struct kfd_ioctl_set_trap_handler_args *args = data;
@@ -726,7 +728,7 @@ static int kfd_ioctl_get_clock_counters(struct file *filep,
 
 
 static int kfd_ioctl_get_process_apertures(struct file *filp,
-				struct kfd_process *p, void *data)
+					   struct kfd_process *p, void *data)
 {
 	struct kfd_ioctl_get_process_apertures_args *args = data;
 	struct kfd_process_device_apertures *pAperture;
@@ -859,7 +861,7 @@ static int kfd_ioctl_get_process_apertures_new(struct file *filp,
 }
 
 static int kfd_ioctl_create_event(struct file *filp, struct kfd_process *p,
-					void *data)
+				  void *data)
 {
 	struct kfd_ioctl_create_event_args *args = data;
 	int err;
@@ -894,24 +896,24 @@ static int kfd_ioctl_destroy_event(struct file *filp, struct kfd_process *p,
 	return kfd_event_destroy(p, args->event_id);
 }
 
-static int kfd_ioctl_set_event(struct file *filp, struct kfd_process *p,
-				void *data)
+int kfd_ioctl_set_event(struct file *filp, struct kfd_process *p,
+			void *data)
 {
 	struct kfd_ioctl_set_event_args *args = data;
 
 	return kfd_set_event(p, args->event_id);
 }
 
-static int kfd_ioctl_reset_event(struct file *filp, struct kfd_process *p,
-				void *data)
+int kfd_ioctl_reset_event(struct file *filp, struct kfd_process *p,
+			  void *data)
 {
 	struct kfd_ioctl_reset_event_args *args = data;
 
 	return kfd_reset_event(p, args->event_id);
 }
 
-static int kfd_ioctl_wait_events(struct file *filp, struct kfd_process *p,
-				void *data)
+int kfd_ioctl_wait_events(struct file *filp, struct kfd_process *p,
+			  void *data)
 {
 	struct kfd_ioctl_wait_events_args *args = data;
 
@@ -920,8 +922,9 @@ static int kfd_ioctl_wait_events(struct file *filp, struct kfd_process *p,
 			(args->wait_for_all != 0),
 			&args->timeout, &args->wait_result);
 }
-static int kfd_ioctl_set_scratch_backing_va(struct file *filep,
-					struct kfd_process *p, void *data)
+
+int kfd_ioctl_set_scratch_backing_va(struct file *filep,
+				     struct kfd_process *p, void *data)
 {
 	struct kfd_ioctl_set_scratch_backing_va_args *args = data;
 	struct kfd_process_device *pdd;
@@ -1003,8 +1006,8 @@ static int kfd_ioctl_get_tile_config(struct file *filep,
 	return 0;
 }
 
-static int kfd_ioctl_acquire_vm(struct file *filep, struct kfd_process *p,
-				void *data)
+int kfd_ioctl_acquire_vm(struct file *filep, struct kfd_process *p,
+			 void *data)
 {
 	struct kfd_ioctl_acquire_vm_args *args = data;
 	struct kfd_process_device *pdd;
@@ -1078,8 +1081,8 @@ static int kfd_ioctl_get_available_memory(struct file *filep,
 	return 0;
 }
 
-static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
-					struct kfd_process *p, void *data)
+int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
+				  struct kfd_process *p, void *data)
 {
 	struct kfd_ioctl_alloc_memory_of_gpu_args *args = data;
 	struct kfd_process_device *pdd;
@@ -1279,8 +1282,8 @@ static int kfd_ioctl_free_memory_of_gpu(struct file *filep,
 	return ret;
 }
 
-static int kfd_ioctl_map_memory_to_gpu(struct file *filep,
-					struct kfd_process *p, void *data)
+int kfd_ioctl_map_memory_to_gpu(struct file *filep,
+				struct kfd_process *p, void *data)
 {
 	struct kfd_ioctl_map_memory_to_gpu_args *args = data;
 	struct kfd_process_device *pdd, *peer_pdd;
@@ -1624,8 +1627,8 @@ static int kfd_ioctl_import_dmabuf(struct file *filep,
 	return r;
 }
 
-static int kfd_ioctl_export_dmabuf(struct file *filep,
-				   struct kfd_process *p, void *data)
+int kfd_ioctl_export_dmabuf(struct file *filep,
+			    struct kfd_process *p, void *data)
 {
 	struct kfd_ioctl_export_dmabuf_args *args = data;
 	struct kfd_process_device *pdd;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index fdcf7f2d1b5b..78b7e956f590 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -145,10 +145,28 @@ int kfd_doorbell_mmap(struct kfd_node *dev, struct kfd_process *process,
 				vma->vm_page_prot);
 }
 
+void __iomem *kfd_kernel_doorbell_mmap(struct kfd_node *dev,
+				       struct kfd_process *process)
+{
+	phys_addr_t address;
+	struct kfd_process_device *pdd;
+
+	pdd = kfd_get_process_device_data(dev, process);
+	if (!pdd)
+		return NULL;
+
+	/* Calculate physical address of doorbell */
+	address = kfd_get_process_doorbells(pdd);
+	if (!address)
+		return NULL;
+
+	return ioremap(address, kfd_doorbell_process_slice(dev->kfd));
+}
+
 
 /* get kernel iomem pointer for a doorbell */
 void __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd,
-					unsigned int *doorbell_off)
+				      unsigned int *doorbell_off)
 {
 	u32 inx;
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 81900b49d9d5..91ef4c61a8bc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -326,7 +326,7 @@ static bool event_can_be_cpu_signaled(const struct kfd_event *ev)
 	return ev->type == KFD_EVENT_TYPE_SIGNAL;
 }
 
-static int kfd_event_page_set(struct kfd_process *p, void *kernel_address,
+int kfd_event_page_set(struct kfd_process *p, void *kernel_address,
 		       uint64_t size, uint64_t user_handle)
 {
 	struct kfd_signal_page *page;
@@ -1068,6 +1068,116 @@ int kfd_wait_on_events(struct kfd_process *p,
 	return ret;
 }
 
+int kfd_wait_on_events_kernel(struct kfd_process *p,
+			      uint32_t num_events, void __user *data,
+			      bool all, uint32_t *user_timeout_ms,
+			      uint32_t *wait_result)
+{
+	struct kfd_event_data *events = (struct kfd_event_data *) data;
+	uint32_t i;
+	int ret = 0;
+
+	struct kfd_event_waiter *event_waiters = NULL;
+	long timeout = user_timeout_to_jiffies(*user_timeout_ms);
+
+	event_waiters = alloc_event_waiters(num_events);
+	if (!event_waiters) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Use p->event_mutex here to protect against concurrent creation and
+	 * destruction of events while we initialize event_waiters.
+	 */
+	mutex_lock(&p->event_mutex);
+
+	for (i = 0; i < num_events; i++) {
+		struct kfd_event_data event_data;
+
+		memcpy(&event_data, &events[i], sizeof(struct kfd_event_data));
+		ret = init_event_waiter(p, &event_waiters[i], &event_data);
+		if (ret)
+			goto out_unlock;
+	}
+
+	/* Check condition once. */
+	*wait_result = test_event_condition(all, num_events, event_waiters);
+	if (*wait_result == KFD_IOC_WAIT_RESULT_COMPLETE) {
+		ret = copy_signaled_event_data(num_events,
+					       event_waiters, events);
+		goto out_unlock;
+	} else if (WARN_ON(*wait_result == KFD_IOC_WAIT_RESULT_FAIL)) {
+		/* This should not happen. Events shouldn't be
+		 * destroyed while we're holding the event_mutex
+		 */
+		goto out_unlock;
+	}
+
+	mutex_unlock(&p->event_mutex);
+
+	while (true) {
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			if (*user_timeout_ms != KFD_EVENT_TIMEOUT_IMMEDIATE &&
+			    *user_timeout_ms != KFD_EVENT_TIMEOUT_INFINITE)
+				*user_timeout_ms = jiffies_to_msecs(
+					max(0l, timeout-1));
+			break;
+		}
+
+		/* Set task state to interruptible sleep before
+		 * checking wake-up conditions. A concurrent wake-up
+		 * will put the task back into runnable state. In that
+		 * case schedule_timeout will not put the task to
+		 * sleep and we'll get a chance to re-check the
+		 * updated conditions almost immediately. Otherwise,
+		 * this race condition would lead to a soft hang or a
+		 * very long sleep.
+		 */
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		*wait_result = test_event_condition(all, num_events,
+						    event_waiters);
+		if (*wait_result != KFD_IOC_WAIT_RESULT_TIMEOUT)
+			break;
+
+		if (timeout <= 0)
+			break;
+
+		timeout = schedule_timeout(timeout);
+	}
+	__set_current_state(TASK_RUNNING);
+
+	mutex_lock(&p->event_mutex);
+	/* copy_signaled_event_data may sleep. So this has to happen
+	 * after the task state is set back to RUNNING.
+	 *
+	 * The event may also have been destroyed after signaling. So
+	 * copy_signaled_event_data also must confirm that the event
+	 * still exists. Therefore this must be under the p->event_mutex
+	 * which is also held when events are destroyed.
+	 */
+	if (!ret && *wait_result == KFD_IOC_WAIT_RESULT_COMPLETE)
+		ret = copy_signaled_event_data(num_events,
+					       event_waiters, events);
+
+out_unlock:
+	free_waiters(num_events, event_waiters, ret == -ERESTARTSYS);
+	mutex_unlock(&p->event_mutex);
+out:
+	if (ret)
+		*wait_result = KFD_IOC_WAIT_RESULT_FAIL;
+	else if (*wait_result == KFD_IOC_WAIT_RESULT_FAIL)
+		ret = -EIO;
+
+	return ret;
+}
+
 int kfd_event_mmap(struct kfd_process *p, struct vm_area_struct *vma)
 {
 	unsigned long pfn;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.h b/drivers/gpu/drm/amd/amdkfd/kfd_events.h
index 1dc21c13833b..aa6ead122084 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.h
@@ -87,5 +87,9 @@ struct kfd_event {
 extern void kfd_signal_event_interrupt(u32 pasid, uint32_t partial_id,
 				       uint32_t valid_id_bits,
 				       bool signal_mailbox_updated);
+int kfd_wait_on_events_kernel(struct kfd_process *p,
+			      uint32_t num_events, void __user *data,
+			      bool all, uint32_t *user_timeout_ms,
+			      uint32_t *wait_result);
 
 #endif
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_hsa.h b/drivers/gpu/drm/amd/amdkfd/kfd_hsa.h
new file mode 100644
index 000000000000..794688c615f0
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_hsa.h
@@ -0,0 +1,451 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef KFD_HSA_CODE_H_
+#define KFD_HSA_CODE_H_
+
+struct amd_queue_properties {
+	u32 enable_trap_handler:1,
+	    is_ptr64:1,
+	    enable_trap_handler_debug_sgprs:1,
+	    enable_profiling:1,
+	    use_scratch_once:1,
+	    reserved1:27;
+};
+
+enum hsa_packet_type {
+	/*
+	 * Vendor-specific packet.
+	 */
+	HSA_PACKET_TYPE_VENDOR_SPECIFIC = 0,
+	/*
+	 * The packet has been processed in the past, but has not been reassigned to
+	 * the packet processor. A packet processor must not process a packet of this
+	 * type. All queues support this packet type.
+	 */
+	HSA_PACKET_TYPE_INVALID = 1,
+	/*
+	 * Packet used by agents for dispatching jobs to kernel agents. Not all
+	 * queues support packets of this type (see ::hsa_queue_feature_t).
+	 */
+	HSA_PACKET_TYPE_KERNEL_DISPATCH = 2,
+	/*
+	 * Packet used by agents to delay processing of subsequent packets, and to
+	 * express complex dependencies between multiple packets. All queues support
+	 * this packet type.
+	 */
+	HSA_PACKET_TYPE_BARRIER_AND = 3,
+	/*
+	 * Packet used by agents for dispatching jobs to agents.  Not all
+	 * queues support packets of this type (see ::hsa_queue_feature_t).
+	 */
+	HSA_PACKET_TYPE_AGENT_DISPATCH = 4,
+	/*
+	 * Packet used by agents to delay processing of subsequent packets, and to
+	 * express complex dependencies between multiple packets. All queues support
+	 * this packet type.
+	 */
+	HSA_PACKET_TYPE_BARRIER_OR = 5
+};
+
+enum hsa_packet_header {
+	/*
+	 * Packet type. The value of this sub-field must be one of
+	 * ::hsa_packet_type_t. If the type is ::HSA_PACKET_TYPE_VENDOR_SPECIFIC, the
+	 * packet layout is vendor-specific.
+	 */
+	HSA_PACKET_HEADER_TYPE = 0,
+	/*
+	 * Barrier bit. If the barrier bit is set, the processing of the current
+	 * packet only launches when all preceding packets (within the same queue) are
+	 * complete.
+	 */
+	HSA_PACKET_HEADER_BARRIER = 8,
+	/*
+	 * Acquire fence scope. The value of this sub-field determines the scope and
+	 * type of the memory fence operation applied before the packet enters the
+	 * active phase. An acquire fence ensures that any subsequent global segment
+	 * or image loads by any unit of execution that belongs to a dispatch that has
+	 * not yet entered the active phase on any queue of the same kernel agent,
+	 * sees any data previously released at the scopes specified by the acquire
+	 * fence. The value of this sub-field must be one of ::hsa_fence_scope_t.
+	 */
+	HSA_PACKET_HEADER_ACQUIRE_FENCE_SCOPE = 9,
+	/*
+	 * Release fence scope, The value of this sub-field determines the scope and
+	 * type of the memory fence operation applied after kernel completion but
+	 * before the packet is completed. A release fence makes any global segment or
+	 * image data that was stored by any unit of execution that belonged to a
+	 * dispatch that has completed the active phase on any queue of the same
+	 * kernel agent visible in all the scopes specified by the release fence. The
+	 * value of this sub-field must be one of ::hsa_fence_scope_t.
+	 */
+	HSA_PACKET_HEADER_RELEASE_FENCE_SCOPE = 11
+};
+
+struct code_properties {
+	    /* 4-sgprs */
+	u16 enable_sgpr_private_segment_buffer:1,
+	    /* 2-sgprs */
+	    enable_sgpr_dispatch_ptr:1,
+	    /* 2-sgprs */
+	    enable_sgpr_queue_ptr:1,
+	    /* 2-sgprs */
+	    enable_sgpr_kernarg_segment_ptr:1,
+	    /* 2-sgprs */
+	    enable_sgpr_dispatch_id:1,
+	    /* 2-sgprs */
+	    enable_sgpr_flat_scratch_init:1,
+	    /* 2-sgprs */
+	    enable_sgpr_private_segment_size:1,
+	    reserved0:3,
+	    enable_wavefront_size32:1, // gfx10+
+	    uses_dynamic_stack:1,
+	    reserved1:4;
+};
+
+struct compute_pgm_rsrc1 {
+	u32 granulated_workitem_vgpr_count:6,
+	    granulated_wavefront_sgpr_count:4,
+	    priority:2,
+	    float_round_mode_32:2,
+	    float_round_mode_16_64:2,
+	    float_denorm_mode_32:2,
+	    float_denorm_mode_16_64:2,
+	    priv:1,
+	    enable_dx10_clamp:1,
+	    debug_mode:1,
+	    enable_ieee_mode:1,
+	    bulky:1,
+	    cdbg_user:1,
+	    fp16_ovfl:1,	/* gfx9+ */
+	    reserved0:2,
+	    wgp_mode:1,		/* gfx10+ */
+	    mem_ordered:1,	/* gfx10+ */
+	    fwd_progress:1;	/* gfx10+ */
+};
+
+struct compute_pgm_rsrc2 {
+	    /* 1-sgprs
+	     * enable_sgpr_private_segment_wavefront_offset
+	     */
+	u32 enable_private_segment:1,
+	    /* More or equal to enable_sgpr_*.
+	     * Exceed 16 will be ignored.
+	     */
+	    user_sgpr_count:5,
+	    enable_trap_handler:1,
+	    /* 1-sgpr */
+	    enable_sgpr_workgroup_id_x:1,
+	    /* 1-sgpr */
+	    enable_sgpr_workgroup_id_y:1,
+	    /* 1-sgpr */
+	    enable_sgpr_workgroup_id_z:1,
+	    /* 1-sgpr */
+	    enable_sgpr_workgroup_info:1,
+	    enable_vgpr_workitem_id:2,
+	    enable_exception_address_watch:1,
+	    enable_exception_memory:1,
+	    granulated_lds_size:9,
+	    enable_exception_ieee_754_fp_invalid_operation:1,
+	    enable_exception_fp_denormal_source:1,
+	    enable_exception_ieee_754_fp_division_by_zero:1,
+	    enable_exception_ieee_754_fp_overflow:1,
+	    enable_exception_ieee_754_fp_underflow:1,
+	    enable_exception_ieee_754_fp_inexact:1,
+	    enable_exception_int_divide_by_zero:1,
+	    reserved0:1;
+};
+
+struct compute_pgm_rsrc3 {
+	u32 accum_offset:6,
+	    reserved0:10,
+	    tg_split:1,
+	    reserved1:15;
+};
+
+struct kernel_descriptor {
+	u32 group_segment_fixed_size;
+	u32 private_segment_fixed_size;
+	u32 kernarg_size;
+	u8 reserved0[4];
+	s64 kernel_code_entry_byte_offset;
+	u8 reserved1[20];
+	struct compute_pgm_rsrc3 compute_pgm_rsrc3; /* GFX10+ and GFX90A+ */
+	struct compute_pgm_rsrc1 compute_pgm_rsrc1;
+	struct compute_pgm_rsrc2 compute_pgm_rsrc2;
+	struct code_properties code_properties;
+	u8 reserved2[6];
+};
+
+enum hsa_queue_type {
+	HSA_QUEUE_TYPE_MULTI = 0,
+	HSA_QUEUE_TYPE_SINGLE = 1
+};
+
+enum hsa_queue_feature {
+	HSA_QUEUE_FEATURE_KERNEL_DISPATCH = 1,
+	HSA_QUEUE_FEATURE_AGENT_DISPATCH = 2
+};
+
+struct hsa_kernel_dispatch_packet {
+	u16 header;
+	u16 setup;
+	u16 workgroup_size_x;
+	u16 workgroup_size_y;
+	u16 workgroup_size_z;
+	u16 reserved0;
+	u32 grid_size_x;
+	u32 grid_size_y;
+	u32 grid_size_z;
+	u32 private_segment_size;
+	u32 group_segment_size;
+	u64 kernel_object;
+	void *kernarg_address;
+	u64 reserved2;
+	u64 completion_signal;
+};
+
+enum amd_signal_kind {
+	AMD_SIGNAL_KIND_INVALID = 0,
+	AMD_SIGNAL_KIND_USER = 1,
+	AMD_SIGNAL_KIND_DOORBELL = -1,
+	AMD_SIGNAL_KIND_LEGACY_DOORBELL = -2
+};
+
+/* An AMD Signal object must always be 64 byte aligned to ensure it cannot
+ * span a page boundary. This is required by CP microcode which optimizes
+ * access to the structure by only doing a single SUA (System Uniform Address)
+ * translation when accessing signal fields. This optimization is used in GFX8.
+ */
+struct amd_signal {
+	u64 kind;
+	union {
+		volatile s64 value;
+		volatile u32 *legacy_hardware_doorbell_ptr;
+		volatile u64 *hardware_doorbell_ptr;
+	};
+	/* For AMD_SIGNAL_KIND_USER: mailbox address for event notification
+	 * in Signal operations.
+	 */
+	u64 event_mailbox_ptr;
+	/* For AMD_SIGNAL_KIND_USER: event id for event notification in Signal
+	 * operations.
+	 */
+	u32 event_id;
+	u32 reserved1;
+	/* Start of the AQL packet timestamp, when profiled. */
+	u64 start_ts;
+	/* End of the AQL packet timestamp, when profiled. */
+	u64 end_ts;
+	union {
+		/* For AMD_SIGNAL_KIND_*DOORBELL: the address of the associated
+		 * amd_queue, otherwise reserved and must be 0.
+		 */
+		void *queue_ptr;
+		u64 reserved2;
+	};
+	u32 reserved3[2];
+} __aligned(64);
+
+struct hsa_queue {
+	u32 type;
+
+	u32 features;
+
+	void *base_address;
+	/*
+	 * Signal object used by the application to indicate the ID of a packet that
+	 * is ready to be processed. The HSA runtime manages the doorbell signal. If
+	 * the application tries to replace or destroy this signal, the behavior is
+	 * undefined.
+	 *
+	 * If @a type is ::HSA_QUEUE_TYPE_SINGLE, the doorbell signal value must be
+	 * updated in a monotonically increasing fashion. If @a type is
+	 * ::HSA_QUEUE_TYPE_MULTI, the doorbell signal value can be updated with any
+	 * value.
+	 */
+	u64 doorbell_signal;
+
+	/*
+	 * Maximum number of packets the queue can hold. Must be a power of 2.
+	 */
+	u32 size;
+	/* Reserved. Must be 0. */
+	u32 reserved1;
+	/*
+	 * Queue identifier, which is unique over the lifetime of the application.
+	 */
+	u64 id;
+
+};
+
+enum hsa_fence_scope {
+	HSA_FENCE_SCOPE_NONE = 0,
+	HSA_FENCE_SCOPE_AGENT = 1,
+	HSA_FENCE_SCOPE_SYSTEM = 2
+};
+
+struct amd_queue {
+	struct hsa_queue hsa_queue;
+	u32 reserved1[4];
+	volatile u64 write_dispatch_id;
+	u32 group_segment_aperture_base_hi;
+	u32 private_segment_aperture_base_hi;
+	u32 max_cu_id;
+	u32 max_wave_id;
+	volatile u64 max_legacy_doorbell_dispatch_id_plus_1;
+	volatile u32 legacy_doorbell_lock;
+	u32 reserved2[9];
+	volatile u64 read_dispatch_id;
+	u32 read_dispatch_id_field_base_byte_offset;
+	u32 compute_tmpring_size;
+	u32 scratch_resource_descriptor[4];
+	u64 scratch_backing_memory_location;
+	u64 scratch_backing_memory_byte_size;
+	u32 scratch_wave64_lane_byte_size;
+	struct amd_queue_properties queue_properties;
+	u32 reserved3[2];
+	u64 queue_inactive_signal;
+	u32 reserved4[14];
+} __aligned(64);
+
+struct hsa_sync_var {
+	union {
+		/* pointer to user mode data */
+		void *user_data;
+		/* 64bit compatibility of value */
+		u64 user_data_ptr_value;
+	};
+	u64 SyncVarSize;
+};
+
+enum hsa_event_type {
+	/* user-mode generated GPU signal */
+	HSA_EVENTTYPE_SIGNAL		= 0,
+	/* HSA node change (attach/detach) */
+	HSA_EVENTTYPE_NODECHANGE	= 1,
+	/* HSA device state change( start/stop ) */
+	HSA_EVENTTYPE_DEVICESTATECHANGE = 2,
+	/* GPU shader exception event   */
+	HSA_EVENTTYPE_HW_EXCEPTION	= 3,
+	/* GPU SYSCALL with parameter info */
+	HSA_EVENTTYPE_SYSTEM_EVENT	= 4,
+	/* GPU signal for debugging     */
+	HSA_EVENTTYPE_DEBUG_EVENT	= 5,
+	/* GPU signal for profiling     */
+	HSA_EVENTTYPE_PROFILE_EVENT	= 6,
+	/* GPU signal queue idle state (EOP pm4) */
+	HSA_EVENTTYPE_QUEUE_EVENT	= 7,
+	/* GPU signal for signaling memory access faults and memory subsystem issues */
+	HSA_EVENTTYPE_MEMORY		= 8,
+	/* ... */
+	HSA_EVENTTYPE_MAXID,
+	HSA_EVENTTYPE_TYPE_SIZE		= 0xffffffff
+};
+
+enum hsa_eventtype_nodechange_flags {
+	HSA_EVENTTYPE_NODECHANGE_ADD	= 0,
+	HSA_EVENTTYPE_NODECHANGE_REMOVE	= 1,
+	HSA_EVENTTYPE_NODECHANGE_SIZE	= 0xffffffff
+};
+
+struct hsa_node_change {
+	/* HSA node added/removed on the platform */
+	enum hsa_eventtype_nodechange_flags flags;
+};
+
+enum hsa_device {
+	HSA_DEVICE_CPU	= 0,
+	HSA_DEVICE_GPU	= 1,
+	MAX_HSA_DEVICE	= 2
+};
+
+enum hsa_eventtype_devicestatechange_flags {
+	/* device started (and available) */
+	HSA_EVENTTYPE_DEVICESTATUSCHANGE_START	= 0,
+	/* device stopped (i.e. unavailable) */
+	HSA_EVENTTYPE_DEVICESTATUSCHANGE_STOP	= 1,
+	HSA_EVENTTYPE_DEVICESTATUSCHANGE_SIZE	= 0xffffffff
+};
+
+struct hsa_device_state_change {
+	/* F-NUMA node that contains the device */
+	u32 node_id;
+	/* device type: GPU or CPU */
+	enum hsa_device device;
+	/* event flags */
+	enum hsa_eventtype_devicestatechange_flags flags;
+};
+
+struct hsa_access_attribute_failure {
+	/* Page not present or supervisor privilege */
+	unsigned int not_present:1;
+	/* Write access to a read-only page */
+	unsigned int readonly:1;
+	/* Execute access to a page marked NX */
+	unsigned int no_execute:1;
+	/* Host access only */
+	unsigned int gpu_access:1;
+	/* RAS ECC failure (notification of DRAM ECC - non-recoverable -
+	 * error, if supported by HW)
+	 */
+	unsigned int ecc:1;
+	/* Can't determine the exact fault address */
+	unsigned int imprecise:1;
+	/* Indicates RAS errors or other errors causing the access to GPU to fail
+	 * 0 = no RAS error,
+	 * 1 = ECC_SRAM,
+	 * 2 = Link_SYNFLOOD (poison),
+	 * 3 = GPU hang (not attributable to a specific cause), other values reserved
+	 */
+	unsigned int error_type:3;
+	/* must be 0 */
+	unsigned int Reserved:23;
+};
+
+enum hsa_eventid_memory_flags {
+	/* access fault, recoverable after page adjustment */
+	HSA_EVENTID_MEMORY_RECOVERABLE		= 0,
+	/* memory access requires process context destruction, unrecoverable */
+	HSA_EVENTID_MEMORY_FATAL_PROCESS	= 1,
+	/* memory access requires all GPU VA context destruction, unrecoverable */
+	HSA_EVENTID_MEMORY_FATAL_VM		= 2,
+};
+
+struct hsa_memory_access_fault {
+	/* H-NUMA node that contains the device where the memory access occurred */
+	u32 node_id;
+	/* virtual address this occurred on */
+	u64 virtual_address;
+	/* failure attribute */
+	struct hsa_access_attribute_failure failure;
+	/* event flags */
+	enum hsa_eventid_memory_flags flags;
+};
+
+struct hsa_event_data {
+	enum hsa_event_type event_type;
+
+	union {
+		/* return data associated with HSA_EVENTTYPE_SIGNAL and other events */
+		struct hsa_sync_var sync_var;
+		/* data associated with HSA_EVENTTYPE_NODE_CHANGE */
+		struct hsa_node_change node_change_state;
+		/* data associated with HSA_EVENTTYPE_DEVICE_STATE_CHANGE */
+		struct hsa_device_state_change    device_state;
+		/* data associated with HSA_EVENTTYPE_MEMORY */
+		struct hsa_memory_access_fault    memory_access_fault;
+	};
+
+	// the following data entries are internal to the KFD & thunk itself.
+
+	u64 hw_data1; // internal thunk store for Event data  (OsEventHandle)
+	u64 hw_data2; // internal thunk store for Event data  (HWAddress)
+	u32 hw_data3; // internal thunk store for Event data  (HWData)
+};
+
+struct hsa_event {
+	u32 event_id;
+	struct hsa_event_data event_data;
+};
+
+#endif /* KFD_HSA_CODE_H_ */
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
index 33aa23450b3f..2a2405db5b9c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
@@ -77,6 +77,7 @@ static int kfd_init(void)
 
 static void kfd_exit(void)
 {
+	knod_exit();
 	kfd_cleanup_processes();
 	kfd_process_destroy_wq();
 	kfd_debugfs_fini();
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index acd0e41e744c..4f5d4b0bfa89 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1069,6 +1069,7 @@ bool kfd_dev_is_large_bar(struct kfd_node *dev);
 struct kfd_process *create_process(const struct task_struct *thread, bool primary);
 int kfd_process_create_wq(void);
 void kfd_process_destroy_wq(void);
+void kfd_process_flush_wq(void);
 void kfd_cleanup_processes(void);
 struct kfd_process *kfd_create_process(struct task_struct *thread);
 int kfd_create_process_sysfs(struct kfd_process *process);
@@ -1536,6 +1537,9 @@ void kfd_signal_hw_exception_event(u32 pasid);
 int kfd_set_event(struct kfd_process *p, uint32_t event_id);
 int kfd_reset_event(struct kfd_process *p, uint32_t event_id);
 int kfd_kmap_event_page(struct kfd_process *p, uint64_t event_page_offset);
+int kfd_event_page_set(struct kfd_process *p, void *kernel_address,
+		       uint64_t size, uint64_t user_handle);
+
 
 int kfd_event_create(struct file *devkfd, struct kfd_process *p,
 		     uint32_t event_type, bool auto_reset, uint32_t node_id,
@@ -1641,3 +1645,33 @@ static inline void kfd_debugfs_remove_process(struct kfd_process *p) {}
 #endif
 
 #endif
+
+int kfd_process_alloc_gpuvm(struct kfd_process_device *pdd,
+			    uint64_t gpu_va, uint32_t size,
+			    uint32_t flags, struct kgd_mem **mem, void **kptr);
+void kfd_process_free_gpuvm(struct kgd_mem *mem,
+			    struct kfd_process_device *pdd, void **kptr);
+int kfd_create_queue(struct kfd_process *p, struct queue_properties *q_properties,
+		     u32 gpu_id, u32 *queue_id_out, u64 *doorbell_offset_out);
+int kfd_ioctl_set_event(struct file *filp, struct kfd_process *p,
+			void *data);
+int kfd_ioctl_reset_event(struct file *filp, struct kfd_process *p,
+			  void *data);
+int kfd_ioctl_wait_events(struct file *filp, struct kfd_process *p, void *data);
+
+int kfd_ioctl_set_trap_handler(struct file *filep,
+			       struct kfd_process *p, void *data);
+int kfd_ioctl_set_scratch_backing_va(struct file *filep,
+				     struct kfd_process *p, void *data);
+
+
+int kfd_ioctl_acquire_vm(struct file *filep, struct kfd_process *p, void *data);
+int kfd_ioctl_map_memory_to_gpu(struct file *filep, struct kfd_process *p,
+				void *data);
+int kfd_ioctl_alloc_memory_of_gpu(struct file *filep, struct kfd_process *p,
+				  void *data);
+int kfd_ioctl_export_dmabuf(struct file *filep,
+			    struct kfd_process *p, void *data);
+
+void __iomem *kfd_kernel_doorbell_mmap(struct kfd_node *dev,
+				       struct kfd_process *process);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index ca71fa726e32..3c9268241800 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -715,8 +715,14 @@ void kfd_process_destroy_wq(void)
 	}
 }
 
-static void kfd_process_free_gpuvm(struct kgd_mem *mem,
-			struct kfd_process_device *pdd, void **kptr)
+void kfd_process_flush_wq(void)
+{
+	if (kfd_process_wq)
+		flush_workqueue(kfd_process_wq);
+}
+
+void kfd_process_free_gpuvm(struct kgd_mem *mem,
+			    struct kfd_process_device *pdd, void **kptr)
 {
 	struct kfd_node *dev = pdd->dev;
 
@@ -736,9 +742,9 @@ static void kfd_process_free_gpuvm(struct kgd_mem *mem,
  *	to avoid concurrency. Because of that exclusiveness, we do
  *	not need to take p->mutex.
  */
-static int kfd_process_alloc_gpuvm(struct kfd_process_device *pdd,
-				   uint64_t gpu_va, uint32_t size,
-				   uint32_t flags, struct kgd_mem **mem, void **kptr)
+int kfd_process_alloc_gpuvm(struct kfd_process_device *pdd,
+			    uint64_t gpu_va, uint32_t size,
+			    uint32_t flags, struct kgd_mem **mem, void **kptr)
 {
 	struct kfd_node *kdev = pdd->dev;
 	int err;
@@ -761,10 +767,14 @@ static int kfd_process_alloc_gpuvm(struct kfd_process_device *pdd,
 	}
 
 	if (kptr) {
-		err = amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(
-				(struct kgd_mem *)*mem, kptr, NULL);
+		if (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM)
+			err = amdgpu_amdkfd_gpuvm_map_vram_bo_to_kernel(
+					(struct kgd_mem *)*mem, kptr, NULL);
+		else
+			err = amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(
+					(struct kgd_mem *)*mem, kptr, NULL);
 		if (err) {
-			pr_debug("Map GTT BO to kernel failed\n");
+			pr_debug("Map BO to kernel failed\n");
 			goto sync_memory_failed;
 		}
 	}
-- 
2.43.0

