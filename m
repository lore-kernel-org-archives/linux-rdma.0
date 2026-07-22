Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA583CB2FA
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709375; cv=none; b=SRCEEc1IRruHUD2xU4TLOYO6nXOly/R4bhGw2lMuMCKpUv2Oq7qzWoydpCFoWVUqPMJ7mxaqi1XjYpVKrNwqGzcXtO56xau0+giofhPCyC+RxdQTzVrLdp3TTloA9IrXyWyByysyrRpfH7LiMMrv/ry0yqiWZg5aKh4PH2Uw9TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709375; c=relaxed/simple;
	bh=c7rHzvkDIzJx8KamrfiklWQynvE2LKhZPbn9dMg7azw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R4GW4nOeJOikYRkKxD8oRNg+rGrYvpYbOpuG1iapvRVY1+ln4wLsULs9wFihcbbHDenmyHeI90s7cfDL2x+x8k2pJqpNaaPnHQ/ipnTRNwfP2plgMV8VToHaCWjnbSbLPzE3etgij2yXzluQOfMVCWzBwTv+zV06fSuWLeDQUJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=RjkA2FdA; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="RjkA2FdA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784709373; x=1816245373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JJqZDqPVbZeoViNuGiexSDsdID5t4KnowWN3ZcBQB7s=;
  b=RjkA2FdAOOgueGXQj9W9ljG9LYmD1KWx3xeMJbpvsN5bNfsAy5aIVHHO
   GSv9O97J9Bmyy9Ow1J34ROhW+LChs/SjRCjCzhhO4VC2b32yVMKCB5d4q
   VPAd1sDmbL5jNcQCtjt9v7wqE3Gf518Oxfw5oVb0XlyvXo1JkN2KOCTSV
   kFShVBbChrix2YKPQnnAV++KhPZZL+Tw/hvDd5qymIfJzJrto83+AqZIJ
   3WKmG65j6CAv863MbZZzAvC97P+E8acwlsz1NMwwv0joko4/VpQ2qYBdS
   6Qi4rVH6RdTFUT+UAVH3T/lu+VjEtAryRWz8S2fFbWcsW6g/6fz+6WqqU
   g==;
X-CSE-ConnectionGUID: JC7louJaQw62VCEsjJycLw==
X-CSE-MsgGUID: H1e4i1czTQWePgYRsCnayQ==
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="24119327"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:36:10 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:21627]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.151:2525] with esmtp (Farcaster)
 id 6c0f7cb7-858b-4243-b294-111bd1c4baa5; Wed, 22 Jul 2026 08:36:10 +0000 (UTC)
X-Farcaster-Flow-ID: 6c0f7cb7-858b-4243-b294-111bd1c4baa5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 08:36:09 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 08:36:08 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Yonatan Nachum" <ynachum@amazon.com>
Subject: [PATCH for-next v11 2/6] RDMA/core: Prevent destroying in-use completion counters
Date: Wed, 22 Jul 2026 08:35:59 +0000
Message-ID: <20260722083603.30334-3-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722083603.30334-1-mrgolin@amazon.com>
References: <20260722083603.30334-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA001.ant.amazon.com (10.13.139.62) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Reject comp_cntr destroy while it is attached to any QP. Track
attachments using an xarray in ib_qp keyed by the attach op_mask.
Use op bitmask to reject overlapping attaches early.

Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
---
 .../core/uverbs_std_types_comp_cntr.c          |  3 +++
 drivers/infiniband/core/uverbs_std_types_qp.c  | 18 +++++++++++++++++-
 drivers/infiniband/core/verbs.c                |  8 ++++++++
 include/rdma/ib_verbs.h                        |  3 +++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_comp_cntr.c b/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
index 7db3feace2a9..e12aececbb09 100644
--- a/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
+++ b/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
@@ -13,6 +13,9 @@ static int uverbs_free_comp_cntr(struct ib_uobject *uobject, enum rdma_remove_re
 	struct ib_comp_cntr *cc = uobject->object;
 	int ret;
 
+	if (atomic_read(&cc->usecnt))
+		return -EBUSY;
+
 	ret = cc->device->ops.destroy_comp_cntr(cc);
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 1a32a902bdba..30fc20fb251f 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -403,7 +403,23 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_ATTACH_COMP_CNTR)(
 	if (!attr.op_mask)
 		return -EINVAL;
 
-	return qp->device->ops.qp_attach_comp_cntr(qp, cc, &attr);
+	if (attr.op_mask & qp->comp_cntr_op_mask)
+		return -EBUSY;
+
+	ret = xa_err(xa_store(&qp->comp_cntrs, attr.op_mask, cc, GFP_KERNEL));
+	if (ret)
+		return ret;
+
+	ret = qp->device->ops.qp_attach_comp_cntr(qp, cc, &attr);
+	if (ret) {
+		xa_erase(&qp->comp_cntrs, attr.op_mask);
+		return ret;
+	}
+
+	atomic_inc(&cc->usecnt);
+	qp->comp_cntr_op_mask |= attr.op_mask;
+
+	return 0;
 }
 
 DECLARE_UVERBS_NAMED_METHOD(
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 3b613b57e269..e30e250640c8 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1293,6 +1293,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 	qp->qp_context = attr->qp_context;
 
 	spin_lock_init(&qp->mr_lock);
+	xa_init(&qp->comp_cntrs);
 	INIT_LIST_HEAD(&qp->rdma_mrs);
 	INIT_LIST_HEAD(&qp->sig_mrs);
 	init_completion(&qp->srq_completion);
@@ -1327,6 +1328,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 		qp, uattrs ? uverbs_get_cleared_udata(uattrs) : NULL);
 err_create:
 	rdma_restrack_put(&qp->res);
+	xa_destroy(&qp->comp_cntrs);
 	kfree(qp);
 	return ERR_PTR(ret);
 
@@ -2144,6 +2146,8 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 	const struct ib_gid_attr *alt_path_sgid_attr = qp->alt_path_sgid_attr;
 	const struct ib_gid_attr *av_sgid_attr = qp->av_sgid_attr;
 	struct ib_qp_security *sec;
+	struct ib_comp_cntr *cc;
+	unsigned long index;
 	int ret;
 
 	WARN_ON_ONCE(qp->mrs_used > 0);
@@ -2174,6 +2178,10 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 	if (av_sgid_attr)
 		rdma_put_gid_attr(av_sgid_attr);
 
+	xa_for_each(&qp->comp_cntrs, index, cc)
+		atomic_dec(&cc->usecnt);
+	xa_destroy(&qp->comp_cntrs);
+
 	ib_qp_usecnt_dec(qp);
 	if (sec)
 		ib_destroy_qp_security_end(sec);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9a952750f068..84a8904fbad4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1758,6 +1758,7 @@ enum ib_qp_attach_comp_cntr_op {
 struct ib_comp_cntr {
 	struct ib_device *device;
 	struct ib_uobject *uobject;
+	atomic_t usecnt;
 };
 
 enum ib_comp_cntr_entry {
@@ -1944,6 +1945,8 @@ struct ib_qp {
 	struct completion	srq_completion;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
+	struct xarray		comp_cntrs; /* op_mask -> comp_cntr */
+	u32			comp_cntr_op_mask;
 
 	/* count times opened, mcast attaches, flow attaches */
 	atomic_t		usecnt;
-- 
2.47.3

