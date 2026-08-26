Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A92F3DFC7F
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 11:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787742290; cv=none; b=Yc4JLXPDV1DuCQpKdxvZi3fiiuwpiM+oFqmrk2GHc5u7JjtSN1EIPgoKYybm7F/NLBjIEQl1RQxe0NCRmeciWok8bffWKMPonXyFBtH68HoAezOz87PpSLNeVODDNdtYAv6IfbkJjwba+JtuAsSFDhk9+LYnJLHGGC9dzrc+BE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787742290; c=relaxed/simple;
	bh=549+99gbIRTFxNP1G9IFU/8+t3At2S1wUWxvGlBs3ZM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hj8GJJ2vLdZ1oNaksh6bOZd/Xlg70U2PNpzCMC4TUuZ9HIQey9m/d4P0vcIVYOH0MQg+53HwLFGAVEYjXT4iFpphjJbild7v7wtLjtcEjlA0VdfdkQRzSkwY877K0oimGVXejaxlKvpmryoXaenWzJDejggSYePO/j8ateuQd5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=GnYKdFtE; arc=none smtp.client-ip=111.202.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="GnYKdFtE"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Stefan
 Metzmacher <metze@samba.org>, Kees Cook <kees@kernel.org>, Li RongQing
	<lirongqing@baidu.com>, Or Gerlitz <ogerlitz@ddn.com>, Norbert Szetei
	<norbert@doyensec.com>, Marco Crivellari <marco.crivellari@suse.com>, Vlad
 Dumitrescu <vdumitrescu@nvidia.com>, Mark Zhang <markzhang@nvidia.com>, Or
 Har-Toov <ohartoov@nvidia.com>, <linux-rdma@vger.kernel.org>
Subject: [PATCH] RDMA/cma: publish service records after initializing them
Date: Wed, 26 Aug 2026 19:02:13 +0800
Message-ID: <20260826110213.18378-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc6.internal.baidu.com (172.31.3.16) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1787742148;
	bh=czw8+xgVh8kdgROg8WNaMLgeD9wrDCwvEp3tzqJexEQ=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=GnYKdFtER4bMlZl/8lpbegDhEjGb1Gw9A3FeCYrPsVbdi43sVXWx/TVY0uOLMxhrP
	 bLgofw4TAz9hOxy6D39meFuuBxtky08qrxzAC022DMHOZ1nVs2pTWr0m/+HYIp7A36
	 K/zFGrnvD734hvkOWdt68qLV/OEJj1xd7bd2XbD/y6oA5u70N7vP9h+vTBqLAW7fDH
	 gLYTKrQ80e9D5f9lz6L+uwkqlS8VHnpkckLlVtPq8WfMT4361VY3z3UpBkuhYYf3X/
	 8VEh5vxMIGPR8baKz2hFa7JNLHXb9REgSYhvk8iuDXCwALqewP02ZJrC2lem0q/Ma5
	 i1DU1asUkOAOg==

From: Li RongQing <lirongqing@baidu.com>

cma_query_ib_service_handler() stores the freshly allocated
service_recs array and its count before the records are filled in:

	id_priv->id.route.service_recs = kmalloc_objs(*recs, num_recs);
	...
	id_priv->id.route.num_service_recs = num_recs;
	memcpy(id_priv->id.route.service_recs, recs, ...);

ucma_query_ib_service() only holds ctx->mutex and is not serialized
against this SA callback.  It gates on service_recs being non-NULL
and then copies num_service_recs records out to user space.  A task
spinning on RDMA_USER_CM_CMD_QUERY while another one issues
RDMA_USER_CM_CMD_RESOLVE_IB_SERVICE can therefore see a non-NULL
pointer together with a non-zero count while the kmalloc'ed array
still holds uninitialized heap data, and leak it through
copy_to_user().  Nothing ordered the stores either, so the reader
could also observe them out of order.

Fill a local allocation first, set the count, then publish the array
with smp_store_release().  The reader fetches it once with a
matching smp_load_acquire() and copies from that value, so a visible
pointer now implies that both the count and the record contents are
visible as well.

Fixes: a6404823fe20 ("RDMA/cma: Support IB service record resolution")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/cma.c  | 14 ++++++++++----
 drivers/infiniband/core/ucma.c |  8 +++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 73170b1..4df9b48 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5556,6 +5556,7 @@ static void cma_query_ib_service_handler(int status,
 {
 	struct cma_work *work = context;
 	struct rdma_id_private *id_priv = work->id;
+	struct sa_service_rec *service_recs;
 	struct sockaddr_ib *addr;
 
 	if (status)
@@ -5571,15 +5572,20 @@ static void cma_query_ib_service_handler(int status,
 		goto fail;
 	}
 
-	id_priv->id.route.service_recs =
-		kmalloc_objs(*recs, num_recs);
-	if (!id_priv->id.route.service_recs) {
+	service_recs = kmalloc_objs(*recs, num_recs);
+	if (!service_recs) {
 		status = -ENOMEM;
 		goto fail;
 	}
 
+	memcpy(service_recs, recs, sizeof(*recs) * num_recs);
 	id_priv->id.route.num_service_recs = num_recs;
-	memcpy(id_priv->id.route.service_recs, recs, sizeof(*recs) * num_recs);
+	/*
+	 * Readers such as ucma_query_ib_service() are not serialized against
+	 * this handler and gate on service_recs, so publish it only once the
+	 * records and the count are fully written.
+	 */
+	smp_store_release(&id_priv->id.route.service_recs, service_recs);
 
 	addr = (struct sockaddr_ib *)&id_priv->id.route.addr.dst_addr;
 	addr->sib_family = AF_IB;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 4929636..2b4762f7 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1025,12 +1025,15 @@ static ssize_t ucma_query_ib_service(struct ucma_context *ctx,
 				     void __user *response, int out_len)
 {
 	struct rdma_ucm_query_ib_service_resp *resp;
+	struct sa_service_rec *service_recs;
 	int n, ret = 0;
 
 	if (out_len < sizeof(struct rdma_ucm_query_ib_service_resp))
 		return -ENOSPC;
 
-	if (!ctx->cm_id->route.service_recs)
+	/* Pairs with the release store in cma_query_ib_service_handler() */
+	service_recs = smp_load_acquire(&ctx->cm_id->route.service_recs);
+	if (!service_recs)
 		return -ENODATA;
 
 	resp = kzalloc(out_len, GFP_KERNEL);
@@ -1048,8 +1051,7 @@ static ssize_t ucma_query_ib_service(struct ucma_context *ctx,
 	if (n > ctx->cm_id->route.num_service_recs)
 		n = ctx->cm_id->route.num_service_recs;
 
-	memcpy(resp->recs, ctx->cm_id->route.service_recs,
-	       sizeof(*resp->recs) * n);
+	memcpy(resp->recs, service_recs, sizeof(*resp->recs) * n);
 	if (copy_to_user(response, resp, struct_size(resp, recs, n)))
 		ret = -EFAULT;
 
-- 
2.9.4

