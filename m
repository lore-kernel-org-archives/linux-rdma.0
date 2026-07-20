Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B60425CEE
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 13:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553751; cv=none; b=sCLfkRpO5hHR3fA+G/5y8EOMpBMb3wlc2uw4tHRh3uYWagXN2pxi9x1fsqeU9E9n/SkPbaWCurACmLCP266lXhcLKy1LJ2NcfGf+/6kRH+PVfTFe+SZa6VzWZ9XKT7vqdL/LiFYGvjholobFYeKmXS4a823d58wgtMSGpbm7ZSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553751; c=relaxed/simple;
	bh=c7rHzvkDIzJx8KamrfiklWQynvE2LKhZPbn9dMg7azw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZnnlbPuJnN+NW//JGBkhTGKosmZGHkniAokIRXx6KS4zeTGlcFYWnbKKqiG7pF1O0oDUXMI4FfcvL6kugfF+huUZt8Cbi45WTaePhlQsxBw9d9cDxiwYbzvx6xBt8FM7pz/22edn0iwShJprt69bnComVSwJvVIXqOC7v5L/CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZhIEJf3d; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZhIEJf3d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784553750; x=1816089750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JJqZDqPVbZeoViNuGiexSDsdID5t4KnowWN3ZcBQB7s=;
  b=ZhIEJf3dcWYmFkR3njB4B5CIxLuhZmP8OFKze89DkLi0BklZc2lZedx6
   GFOMosz1wcq0lfy9FBdkg9JtUxHe/MAehLf1LJr+Lw23wdoUxDZhwkDIc
   4Wz4S6Kwjsla5yw/fD0Ttkl2tJR2xXBdsMmvPlw367lFs6nIsi1Orvu+n
   oPxY0B7fiEXJT4oCmeMlh/R4IqXl+XfUjKhgDhDX5LBNzEu83+Lgeteru
   JaJZKEHn8t83iAioZNv07crodV9B1ofYuu6R2EMphl786P/fGFSotYGfn
   J/fRTQJJDZRBU1ZYIXSZwRAY1XpBN7RDurvjRGQVQ/IX7r3qdMAjND0Mi
   Q==;
X-CSE-ConnectionGUID: 7EQNbR4ITPiGjkDgctSbSg==
X-CSE-MsgGUID: Cttf+873T8md6H0jFqZbvQ==
X-IronPort-AV: E=Sophos;i="6.25,174,1779148800"; 
   d="scan'208";a="24003885"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 13:22:27 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:30479]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.246:2525] with esmtp (Farcaster)
 id b61f5012-e9a3-4cb8-8920-1ff60ae2a126; Mon, 20 Jul 2026 13:22:27 +0000 (UTC)
X-Farcaster-Flow-ID: b61f5012-e9a3-4cb8-8920-1ff60ae2a126
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Mon, 20 Jul 2026 13:22:27 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Mon, 20 Jul 2026
 13:22:25 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Yonatan Nachum" <ynachum@amazon.com>
Subject: [PATCH for-next v10 2/6] RDMA/core: Prevent destroying in-use completion counters
Date: Mon, 20 Jul 2026 13:22:17 +0000
Message-ID: <20260720132221.2551-3-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720132221.2551-1-mrgolin@amazon.com>
References: <20260720132221.2551-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWA001.ant.amazon.com (10.13.139.110) To
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

