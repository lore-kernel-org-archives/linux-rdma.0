Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F7D286881
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791300552; cv=none; b=isGwvGFEkmQxdYLME3jubSr1tyTqdfFuSGSw6piysdMy2Ehkz8m0LB1arjVs7ygp/4AOoTGCBDenYGNSuYN07dB/hWmUH/xasj5qG1zxkA5SEJLMeZzH+EnJBiExbRc1k/ifz9ANU2E9eZMLShj6X4wwo4++Gv885bmdvRG06rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791300552; c=relaxed/simple;
	bh=A6GYb8f9+s2t/pjLZXD0kEzbh0P7B/i5OpvBBOpOZS0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VPCIeUQWbT4vSDU/PcRxQ0drvst43e4f2bSeJD/bpTPvkwMNcTJQNDSmVNArd11YLm+KgWOAHsuKQX5enfan95SBPrryz/b5ZaSWqyTmw08qn6hBcMnSOGzQEedjdnifX6cof0BWqZlQJqJPbsTjqiReZSztNPm4y4hJas1hGJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QozAh5SS; arc=none smtp.client-ip=209.85.222.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QozAh5SS"
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93cb6391e89so515881085a.1
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 08:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791300550; x=1791905350; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cBSiXsrix4zCtg8vy7Cjx3nquVP6PfNCn2cG7lbTMTU=;
        b=QozAh5SSUpOLEEI3M9kum0zj0Va8aPj6+etZIjsreQ5Tuv4Kfuxlz5UIfGzG143M6g
         nlehqnnt+Ep51U2inRGAo07+4T9jYFyOOffnqVyqmC8WPEmsWxX/Bx1Mkl4dWiC6/GjF
         clKJKiSVGNwJaLB79prs00zmsu3afIvPJ0POUSjUO5+XD+c4WkZgMADPdXtqEX/n57Li
         CKKiPmF5u/2gjjYohwULRP+mAZZrXrmQNx1c6Dyk7fD5JOQ6MF0cCGI42sSns8DYAyMa
         xTW9P4kbExO/Lnnx2/c/g4Dp7ztLyYL4JXiatyJDQcf1PKd+OWZADLg27H+r8iQo0iyI
         WAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791300550; x=1791905350;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cBSiXsrix4zCtg8vy7Cjx3nquVP6PfNCn2cG7lbTMTU=;
        b=jn9FDRzExzmrxeU1+SChdytbr8Pf18XSK3hOEij5e+2pexC2Vci3pWe8VN6vta4UCp
         dZn/ntw83YEHnGsHxfhVmh/rqIzZMkul8VzTbw/BlBL8aEnE0KTVYwZPS1Lf9XzbEpYC
         t8ke6bJJXI7P/LdUQ/eWjeqh/S7dTAkkyvo1TZcqA7BsbS1qWeMy+x3zbQ0/GxjB/NmO
         JHCcRkeL+YzQTViBXm3ZpK70IvEAVTZosJ3WhGEEJ7QbNXJQvNSNP+btYIC++clTdoJU
         FPDzh/Uf9SuflPCYzf/n5KilEdr8Pl6K/KXA74c/9zrVCEJav3OHTCZLWTMVyQ1vI3zn
         p2QA==
X-Gm-Message-State: AFuF++nvy21tUAbfF69cHitoAH4pdvB0OnLVDhQi/PsQLFqYB+noigrr
	7YENoVlqwUxv1eE/84iMlfbIhtQxQoKCwiDcbh83VNJyKrpxdCRImsVl6Zs4OO6cjGusg7j9qHE
	8Vk+Q+uWC0g==
X-Received: from qkbm15.prod.google.com ([2002:a05:620a:6b8f:b0:93c:c2d9:eada])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:3713:b0:93b:cb6d:6d73
 with SMTP id af79cd13be357-93e8f36303fmr339477185a.32.1791300549630; Tue, 06
 Oct 2026 08:29:09 -0700 (PDT)
Date: Tue,  6 Oct 2026 15:29:08 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261006152908.888059-1-jmoroni@google.com>
Subject: [PATCH v2] RDMA/core: Clear driver_udata before destroying objects in rdma_core
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
Changes in v2:
- Drop redundant NULL check in create_qp() now that
  uverbs_get_cleared_udata() handles NULL (Leon)

 drivers/infiniband/core/ib_core_uverbs.c | 12 ------------
 drivers/infiniband/core/rdma_core.c      |  2 ++
 drivers/infiniband/core/rdma_core.h      | 17 +++++++++++------
 drivers/infiniband/core/verbs.c          |  3 +--
 4 files changed, 14 insertions(+), 20 deletions(-)

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
index a7cbe643e33c..b32e5445601b 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -734,6 +734,7 @@ void rdma_assign_uobject(struct ib_uobject *to_uobj, struct ib_uobject *new_uobj
 	 * If this fails then the uobject is still completely valid (though with
 	 * a new ID) and we leak it until context close.
 	 */
+	uverbs_get_cleared_udata(attrs);
 	uverbs_destroy_uobject(to_uobj, RDMA_REMOVE_DESTROY, attrs);
 }
 EXPORT_SYMBOL_NS_GPL(rdma_assign_uobject, "rdma_core");
@@ -750,6 +751,7 @@ void rdma_alloc_abort_uobject(struct ib_uobject *uobj,
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
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6d5825114c19..edf62652f9d3 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1331,8 +1331,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 	return qp;
 
 err_security:
-	qp->device->ops.destroy_qp(
-		qp, uattrs ? uverbs_get_cleared_udata(uattrs) : NULL);
+	qp->device->ops.destroy_qp(qp, uverbs_get_cleared_udata(uattrs));
 err_create:
 	rdma_restrack_put(&qp->res);
 	xa_destroy(&qp->comp_cntrs);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

