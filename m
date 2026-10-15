Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392FB48EBF6
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 08:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792053404; cv=none; b=Vf1dUjVihWUwpKJXhVSE96644Hs4LEhWdcJPdq8TizNoM0UpRmE1xQbUKlZfB9fxFbZQxbjLYaoy28stAy9EUE+q3y1rlzhDKLYf1eFJMyRAO2SmjXWeJDUwtI8T8ZZt/bKuYon7Zbhc3QYQdGw+/hCXjqfSeLND4QwvloY8xiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792053404; c=relaxed/simple;
	bh=npDvVQ5z9FFSw1dO7sjs27nSs1ONKFM4kOi8CDIPTR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNHK5Ukn2QDsEvXJ64ly2FlNZrFU2AeC34T0uKAhCBxHrlBVpyHBnA2Px3D2Efq6VtBJCA/YSNMjJdy7MZqG5aSeABCPowkRarWxmk/A1j2JUQMHujDKh56VZbPOIxd35LuHyV8utijphAJ+rRprD3NwnU3mM8d3MV7Hz+QMoe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KYaLFmqB; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KYaLFmqB"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93ef1a2948dso365053585a.3
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792053401; x=1792658201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2STKe93BsxxSjKyZn2b4YvS4oxKmV5oT37N/2nRdsNg=;
        b=KYaLFmqBNd+aGu7grYEMuYvaaGaG4dnqsPkMqYul2qlRkqBTqRYJof9a2EuPWSUr7X
         rNMJ4+5+eGRwvOh3V65EzpOarY7SftF8Eu9c9lHM8BrKCNv014HN6wR7P9ScxMnZ5NBB
         y7qOAVLGsZDcti9Usp0s6Eut/hFKrj0Ic0PEtcIwgdC4irOyU7HMjmGd1sYHggWSEIX5
         5lfzRi2YFlwT1EH67fKMJHtkwWCnPs8ozVaIjwm/h0aAP6EfCFipiPCOWb4wsUOMmcV7
         h8Kc9AQqFTab0aN7XVoPQZPsruKO9qyz/A0WgpsnRZOmkoq8WRR287fmrlW9ilw48W5+
         WmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792053401; x=1792658201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2STKe93BsxxSjKyZn2b4YvS4oxKmV5oT37N/2nRdsNg=;
        b=jfzW3rNtt/MJ1ZsZgE0maa2MjlS6Y2jgdOv24mq/gPUT7v/IUBFGDrOOCyOASKLyo3
         niWaRQJf0E24pXENxiKy7m5OYpJefXqySbgQdfRZf3aO5JtJI+ngPjwqAdZrY0XleN0Q
         4b0foYIcCmIgykZKKfp3TZ+8e3NhU9jpPk59o4NVJADtbVYXfvqBhYU3/qCGtmUqlW9K
         gyyLX88jei1wpNyyVvQmrtvH80vHS3zeH214/H2EdDCA3SnEHBwRMb8EkTbdzCkaqE7Z
         NvISFsRpUfs4aKkdN2T76t5qzWZvupBJ2EIiqSHINpOmn6JuZelTSDZSrRYmrnhczXl4
         20vg==
X-Gm-Message-State: AFq9FYIfOk1FZXFF65P2jiFe5xFbs7wEXCN9BWD+VOb+Obp9DfOI3NSh
	tB3JYWyZVr+f/iA16iXBeFjKsCLiVc1XALw8vOj5k30KVFw8AL+iucHD
X-Gm-Gg: AYBFou3CKuYQkaIUw//xsnL8hU61IG4euokCLVkflq7bHAJMRBa81/Szn2FL3EeO3hY
	J+2/LiESOKidSK7myChYwE4B17uO19Ajt13lZmdW1KvxGB4dFaSbMwUZk8LRJaEXvDZHjkWEub+
	23ws2UrbXgy13vk/IkzpTQZqmtjFM+PUnUF7oQR56t3j5HGz2ri4B1itlAewXXh4NnZM4O9s4VI
	XTNW+8LFW5dAXCrNgwDfc1S9zop76/QfaxerOwql7C3HxhFmAY+rhkNqZ4JJZYtaH+Kt+PNZzYG
	bPvyRpyRnVAyJTakZlaxhU4WnRtAjAE5ttohIcAnXocwxZ+dTbxyHCB3LYH4N1188nc9L4IenND
	3vuJrKH41GZuIKATCspEYO/XxK6fLE/Rc4JlaIifqQLZXRXpiNCKos3RVFaGl+OBDVonmGfzFlj
	Ie9XXEm5/PNisKzNN10Nkswi/CcqdeITUA8W7DUze5a265sDIj75s1E7I+S9opb/Du0r/Wz1p6h
	zAc72/6YmNsYdiBv7V0Hqii37EWUWpunyv1hSqJtmFuuQk93jCp/tzR6AA1syjFTxrnIu6kEjl3
	4hV2l/fRCjynX9xEK0y4UiR0
X-Received: by 2002:a05:620a:462b:b0:93d:cbe6:c236 with SMTP id af79cd13be357-93ebd4a97edmr3010062885a.66.1792053400997;
        Thu, 15 Oct 2026 01:36:40 -0700 (PDT)
Received: from ip-172-31-15-253.ec2.internal (ec2-44-200-54-59.compute-1.amazonaws.com. [44.200.54.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5090050sm711843985a.40.2026.10.15.01.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 01:36:40 -0700 (PDT)
From: Deep Shah <deepshah146@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	Yishai Hadas <yishaih@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Deep Shah <deepshah146@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH rdma-rc 2/2] RDMA/uverbs: Fix DMABUF use-after-free during ufile cleanup
Date: Thu, 15 Oct 2026 08:36:37 +0000
Message-ID: <20261015083637.200958-3-deepshah146@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015083637.200958-1-deepshah146@gmail.com>
References: <20261015083637.200958-1-deepshah146@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The DMABUF release can race with ufile cleanup. When the cleanup holds
hw_destroy_rwsem for write, uverbs_uobject_release() fails its trylock
and leaves the uobject on the ufile list, but the dma_buf is freed as
soon as the release returns. The cleanup then destroys the uobject and
uses the freed dma_buf:

  BUG: KASAN: slab-use-after-free in uverbs_dmabuf_fd_destroy_uobj+0x46/0x200
  Read of size 8 at addr ff11000109cf14b0 by task repro/435
  Call Trace:
   uverbs_dmabuf_fd_destroy_uobj+0x46/0x200
   destroy_hw_fd_uobject+0x3f/0x50
   uverbs_destroy_uobject+0xc5/0x380
   __uverbs_cleanup_ufile+0x1a8/0x260
   uverbs_destroy_ufile_hw+0x54/0x160
   ib_uverbs_close+0x34/0x110
  Allocated by task 435:
   dma_buf_export+0x1b5/0x530
   ib_uverbs_handler_UVERBS_METHOD_DMABUF_ALLOC+0x223/0x3f0
  Freed by task 436:
   kfree+0x301/0x530
   dentry_kill+0x14c/0x560
   __fput+0x23a/0x4a0

rdma_user_mmap_entry_remove() dereferences the same pointer.

Protect the stored dma_buf pointer with a mutex and clear it before
release returns. Use a shared revoke helper so uobject destruction and
mmap entry removal both skip a cleared pointer. Hold a temporary uobject
reference across uverbs_uobject_release() and the pointer update.

Use a separate mutex because uobject destruction can free the mmap entry
before release finishes. Map and unmap use attachment->dmabuf directly,
so they do not need to take the new mutex while holding the reservation
lock.

Fixes: 0ac6f4056c4a ("RDMA/uverbs: Add DMABUF object type and operations")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Deep Shah <deepshah146@gmail.com>
---
 drivers/infiniband/core/ib_core_uverbs.c      | 10 +----
 drivers/infiniband/core/uverbs.h              | 37 ++++++++++++++++++
 .../infiniband/core/uverbs_std_types_dmabuf.c | 39 +++++++++++--------
 3 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
index 41c84ffe8c09..2bdb6972fe1a 100644
--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -244,16 +244,8 @@ void rdma_user_mmap_entry_remove(struct rdma_user_mmap_entry *entry)
 	entry->driver_removed = true;
 	xa_unlock(&entry->ucontext->mmap_xa);
 	list_for_each_entry_safe(uverbs_dmabuf, tmp, &entry->dmabufs, dmabufs_elm) {
-		dma_resv_lock(uverbs_dmabuf->dmabuf->resv, NULL);
 		list_del(&uverbs_dmabuf->dmabufs_elm);
-		uverbs_dmabuf->revoked = true;
-		dma_buf_invalidate_mappings(uverbs_dmabuf->dmabuf);
-		dma_resv_wait_timeout(uverbs_dmabuf->dmabuf->resv,
-				      DMA_RESV_USAGE_BOOKKEEP, false,
-				      MAX_SCHEDULE_TIMEOUT);
-		dma_resv_unlock(uverbs_dmabuf->dmabuf->resv);
-		kref_put(&uverbs_dmabuf->kref, ib_uverbs_dmabuf_done);
-		wait_for_completion(&uverbs_dmabuf->comp);
+		ib_uverbs_dmabuf_revoke(uverbs_dmabuf);
 	}
 	mutex_unlock(&entry->dmabufs_lock);
 
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index c64dd6b94e10..728e09b41992 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -42,6 +42,8 @@
 #include <linux/mutex.h>
 #include <linux/completion.h>
 #include <linux/cdev.h>
+#include <linux/dma-buf.h>
+#include <linux/dma-resv.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
@@ -135,6 +137,13 @@ struct ib_uverbs_completion_event_file {
 
 struct ib_uverbs_dmabuf_file {
 	struct ib_uobject uobj;
+	/*
+	 * Serializes users of dmabuf with the dma_buf's release, which sets it
+	 * to NULL. The uobject can outlive the dma_buf while it waits to be
+	 * destroyed. The map and unmap callbacks use attachment->dmabuf
+	 * instead of taking this lock.
+	 */
+	struct mutex dmabuf_release_lock;
 	struct dma_buf *dmabuf;
 	struct list_head dmabufs_elm;
 	struct rdma_user_mmap_entry *mmap_entry;
@@ -359,6 +368,34 @@ static inline void ib_uverbs_dmabuf_done(struct kref *kref)
 	complete(&priv->comp);
 }
 
+/*
+ * Revoke the dmabuf and wait for all of its DMA mappings to be gone. Must be
+ * called with the mmap entry's dmabufs_lock held, after the dmabuf has been
+ * removed from the entry's dmabufs list, so it runs once per dmabuf. Lock
+ * order is dmabufs_lock, dmabuf_release_lock, then the dma_resv lock.
+ */
+static inline void ib_uverbs_dmabuf_revoke(struct ib_uverbs_dmabuf_file *priv)
+{
+	mutex_lock(&priv->dmabuf_release_lock);
+	if (priv->dmabuf) {
+		dma_resv_lock(priv->dmabuf->resv, NULL);
+		priv->revoked = true;
+		dma_buf_invalidate_mappings(priv->dmabuf);
+		dma_resv_wait_timeout(priv->dmabuf->resv,
+				      DMA_RESV_USAGE_BOOKKEEP, false,
+				      MAX_SCHEDULE_TIMEOUT);
+		dma_resv_unlock(priv->dmabuf->resv);
+	} else {
+		/* A released dma_buf has no attachments left to invalidate */
+		priv->revoked = true;
+	}
+	mutex_unlock(&priv->dmabuf_release_lock);
+
+	kref_put(&priv->kref, ib_uverbs_dmabuf_done);
+	/* Wait till all DMA unmaps are completed */
+	wait_for_completion(&priv->comp);
+}
+
 int __uverbs_cleanup_ufile(struct ib_uverbs_file *ufile,
 			   enum rdma_remove_reason reason);
 
diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index d88d30f1e42f..8d8c997a4883 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -28,7 +28,7 @@ uverbs_dmabuf_map(struct dma_buf_attachment *attachment,
 	struct ib_uverbs_dmabuf_file *priv = attachment->dmabuf->priv;
 	struct sg_table *ret;
 
-	dma_resv_assert_held(priv->dmabuf->resv);
+	dma_resv_assert_held(attachment->dmabuf->resv);
 
 	if (priv->revoked)
 		return ERR_PTR(-ENODEV);
@@ -49,7 +49,7 @@ static void uverbs_dmabuf_unmap(struct dma_buf_attachment *attachment,
 {
 	struct ib_uverbs_dmabuf_file *priv = attachment->dmabuf->priv;
 
-	dma_resv_assert_held(priv->dmabuf->resv);
+	dma_resv_assert_held(attachment->dmabuf->resv);
 	dma_buf_free_sgt(attachment, sgt, dir);
 	kref_put(&priv->kref, ib_uverbs_dmabuf_done);
 }
@@ -74,7 +74,25 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 	if (!priv)
 		return;
 
+	/*
+	 * uverbs_uobject_release() may drop the last reference to the uobject,
+	 * keep it around until the dmabuf pointer below has been cleared.
+	 */
+	uverbs_uobject_get(&priv->uobj);
 	uverbs_uobject_release(&priv->uobj);
+
+	/*
+	 * The dma_buf is freed once this function returns. If the uobject was
+	 * not destroyed above, because the ufile is concurrently being cleaned
+	 * up, it is still reachable through the ufile's uobjects list and the
+	 * mmap entry's dmabufs list. Make sure those paths are not in the
+	 * middle of using the dma_buf and cannot use it afterwards.
+	 */
+	mutex_lock(&priv->dmabuf_release_lock);
+	priv->dmabuf = NULL;
+	mutex_unlock(&priv->dmabuf_release_lock);
+
+	uverbs_uobject_put(&priv->uobj);
 }
 
 static const struct dma_buf_ops uverbs_dmabuf_ops = {
@@ -100,6 +118,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
 	off_t pg_off;
 	int ret;
 
+	mutex_init(&uverbs_dmabuf->dmabuf_release_lock);
+
 	ret = uverbs_get_const(&pg_off, attrs, UVERBS_ATTR_ALLOC_DMABUF_PGOFF);
 	if (ret)
 		return ret;
@@ -165,24 +185,11 @@ static void uverbs_dmabuf_fd_destroy_uobj(struct ib_uobject *uobj,
 {
 	struct ib_uverbs_dmabuf_file *uverbs_dmabuf =
 		container_of(uobj, struct ib_uverbs_dmabuf_file, uobj);
-	bool wait_for_comp = false;
 
 	mutex_lock(&uverbs_dmabuf->mmap_entry->dmabufs_lock);
-	dma_resv_lock(uverbs_dmabuf->dmabuf->resv, NULL);
 	if (!uverbs_dmabuf->revoked) {
-		uverbs_dmabuf->revoked = true;
 		list_del(&uverbs_dmabuf->dmabufs_elm);
-		dma_buf_invalidate_mappings(uverbs_dmabuf->dmabuf);
-		dma_resv_wait_timeout(uverbs_dmabuf->dmabuf->resv,
-				      DMA_RESV_USAGE_BOOKKEEP, false,
-				      MAX_SCHEDULE_TIMEOUT);
-		wait_for_comp = true;
-	}
-	dma_resv_unlock(uverbs_dmabuf->dmabuf->resv);
-	if (wait_for_comp) {
-		kref_put(&uverbs_dmabuf->kref, ib_uverbs_dmabuf_done);
-		/* Let's wait till all DMA unmap are completed. */
-		wait_for_completion(&uverbs_dmabuf->comp);
+		ib_uverbs_dmabuf_revoke(uverbs_dmabuf);
 	}
 	mutex_unlock(&uverbs_dmabuf->mmap_entry->dmabufs_lock);
 
