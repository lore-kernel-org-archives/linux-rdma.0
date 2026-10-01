Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7F03A5E65
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 16:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790871992; cv=none; b=T39+RmVXos9ATXcxP2ZJO3g3CQHoIld+Pd2pABr3Rn+iM9ZDbdsdTtoYp7WnxYQw/lnipwOX89IYvpsJHcMDtZW+adyGzNAq6oBPSUqCVs155AlQEdeO6d/qph78bcPiCYRwjnZutfxkAi9nfpr8f2rgA7snXrYUMs93uEa3CiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790871992; c=relaxed/simple;
	bh=kXQ3eEFiIRaHpJLBx462aax0T4Y5CefDCfJWlkX6oNE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fuzGwL/n+LUGQvSez+W7Gln8ierfNQ7fGeQxFD4Lx8lOCLFDHXkdHNkJb57+3CiNO2PebvIA06dAgEYcbronEnYnlIpSsek3aSR2Qcw8dDKwzTxwTv41RncseB/w1tif7+emVuq3+hc9sR7xiqeVrDJZvr95MFXAtb6P5/EI2x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HxUe5pfH; arc=none smtp.client-ip=209.85.128.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HxUe5pfH"
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-8ab43f7f5faso54355437b3.2
        for <linux-rdma@vger.kernel.org>; Thu, 01 Oct 2026 09:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790871990; x=1791476790; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2D+i4IqmzpL/jZOgG/SQKX6WUZa+Pwsd7TKq8qXunUA=;
        b=HxUe5pfHc27+39wNnXJVHeh5BpdDqoazqe6zUcXyDKR4PfdtFAKadW9LWiiXXLSES1
         s//ztxW1ShnxV6aizCiRslmc73rQ68ylB/FYPkOjzd97iGhP+T6ZD/6SKiyCCMRrGAYi
         /pTi8s9lmmuukovABGyOS2g31JxTdQ0X+R55mIgux7004v6WzmTe5Idbg0dlLS8bg9zl
         ahJltr5BREYv/3ywaUVgwhNxL2Wy0RxxOo9j5RnJTjCyUIf6MLMVdIXYJ1HoqhO/pqAb
         WyPaDwB+imEEeDxmKT/Z0qaJYNr6QDSJwgSLblXU5ICUyIN1Moq/IKzTT6HMycjhzc0k
         RvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790871990; x=1791476790;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2D+i4IqmzpL/jZOgG/SQKX6WUZa+Pwsd7TKq8qXunUA=;
        b=W4Rk42Tb9HGNGT2ImpqSF/l1gJheWK/knZ7IU157rn0uwvwp7hcti0bT/gCaT96gK6
         aUIqZSl0Rx/Yw42IldxUH6j8Wz2PRjLLljlbLX7FURGqy+GW5lYERB2wwWtSLdt8ONji
         gR4RzHmeZvZtXkycjqLsZisbUymg5OP0c4nfloRLEAxgvPTAaQgRAASb2Z/BNV6ZgXa2
         ZBmUlxXPfw+rbiOYzmV1xx7jQjs+PuEaZ12lIV2yfSzn3lzZ2y1D0F9n63JX+XANGw39
         XqKbEXjbADvspCOUI4NCxZ8z2HHC469Z1sVm0vLU2U6T+BaLOS7VEiofCberYLak4ti9
         6cgg==
X-Gm-Message-State: AFuF++lbbOtM8VTy4oqYM6qqshpcOoKomOJksJVrz9ILGGg5blOJGVeK
	+BjLpS+pp+T9S090lE3mb8iRIp+BmA8SzvObmYBT5uF/RxH5vBgTT38fxJSZGRRQyigJSc6ECw0
	VqJArj0rquw==
X-Received: from ywae12.prod.google.com ([2002:a05:690c:a78c:b0:81f:35dc:5b15])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:4f0a:b0:8ab:46c9:d27e
 with SMTP id 00721157ae682-8ac93cfb49bmr17648147b3.34.1790871989419; Thu, 01
 Oct 2026 09:26:29 -0700 (PDT)
Date: Thu,  1 Oct 2026 16:26:28 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001162628.3187887-1-jmoroni@google.com>
Subject: [PATCH] RDMA/core: Clear driver_udata before destroying objects in rdma_core
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

When uobject creation fails while copying user output data (i.e.,
after the HW object has been created), it calls
rdma_alloc_abort_uobject() with hw_obj_valid=true which then
invokes the object's destroy callback, but passes the
uverbs_attr_bundle from the original creation command.

The issue is that drivers are expected to validate the udata
and return an error if there's unexpected content, and data from
the wrong command counts as "unexpected content", so this ends
up causing the driver's destroy call to fail.

A similar issue exists in the rereg_mr path when a new MR
is created and the old one is destroyed.

Fix this by clearing driver_udata before invoking the driver's
destroy method.

Fixes: 6e0954b11c05 ("RDMA/uverbs: Allow drivers to create a new HW object during rereg_mr")
Fixes: 0ac8903cbbe6 ("RDMA/core: Allow the ioctl layer to abort a fully created uobject")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/core/ib_core_uverbs.c | 12 ------------
 drivers/infiniband/core/rdma_core.c      |  2 ++
 drivers/infiniband/core/rdma_core.h      | 17 +++++++++++------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
index 41c84ffe8c09..1482d9b27b38 100644
--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -535,18 +535,6 @@ int uverbs_destroy_def_handler(struct uverbs_attr_bundle *attrs)
 }
 EXPORT_SYMBOL(uverbs_destroy_def_handler);
 
-/*
- * When calling a destroy function during an error unwind we need to pass in
- * the udata that is sanitized of all user arguments. Ie from the driver
- * perspective it looks like no udata was passed.
- */
-struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
-{
-	attrs->driver_udata = (struct ib_udata){};
-	return &attrs->driver_udata;
-}
-EXPORT_SYMBOL_NS_GPL(uverbs_get_cleared_udata, "rdma_core");
-
 /**
  * _uverbs_alloc() - Quickly allocate memory for use with a bundle
  * @bundle: The bundle
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index fd5651c003ae..fc727dbbb897 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -735,6 +735,7 @@ void rdma_assign_uobject(struct ib_uobject *to_uobj, struct ib_uobject *new_uobj
 	 * If this fails then the uobject is still completely valid (though with
 	 * a new ID) and we leak it until context close.
 	 */
+	uverbs_get_cleared_udata(attrs);
 	uverbs_destroy_uobject(to_uobj, RDMA_REMOVE_DESTROY, attrs);
 }
 EXPORT_SYMBOL_NS_GPL(rdma_assign_uobject, "rdma_core");
@@ -751,6 +752,7 @@ void rdma_alloc_abort_uobject(struct ib_uobject *uobj,
 	int ret;
 
 	if (hw_obj_valid) {
+		uverbs_get_cleared_udata(attrs);
 		ret = uobj->uapi_object->type_class->destroy_hw(
 			uobj, RDMA_REMOVE_ABORT, attrs);
 		/*
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 2b91e8527287..9de14e625dd3 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -71,14 +71,19 @@ int uverbs_output_written(const struct uverbs_attr_bundle *bundle, size_t idx);
 
 void setup_ufile_idr_uobject(struct ib_uverbs_file *ufile);
 
-#if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
-struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs);
-#else
-static inline struct ib_udata *uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
+/*
+ * When calling a destroy function during an error unwind we need to pass in
+ * the udata that is sanitized of all user arguments. Ie from the driver
+ * perspective it looks like no udata was passed.
+ */
+static inline struct ib_udata *
+uverbs_get_cleared_udata(struct uverbs_attr_bundle *attrs)
 {
-	return NULL;
+	if (!attrs)
+		return NULL;
+	attrs->driver_udata = (struct ib_udata){};
+	return &attrs->driver_udata;
 }
-#endif
 
 /*
  * This is the runtime description of the uverbs API, used by the syscall
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

