Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23EDF3164A9;
	Fri, 17 Jul 2026 20:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784318931; cv=none; b=lXJxnfCH2z9ini86WjFBc8F5aPg2Fq87P7nkbahbdWsQlCeQ3VVLVVZqoClNJZxTTJ2xZzFOUgffFSl/3RgSa6FJKKDG9U2zYhaLWDXUb2Eyt3aTP7GN3hjtYUuZKqQDFVaIHpjr9w4DH+bTaWFNLdoGuWI/ukWL66W9+KnIBR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784318931; c=relaxed/simple;
	bh=XkmTW/zLN211sMyeR3E5YqsjmfM4Q7mO8s331xIwxc4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DeKxxsNoKPhbwz98FYwb7zBpRIO/F/RG2iogkTxdAAuLTy5r1NlZnAw7DpF1MrAUtLbq1gFa4nRA+58cBGYoUdWN+8vbyhZnF4WR5LOKCVrdOeTvOk8l3pzuxdxCvEVfLWQ5XJTAN9PbEJ5zwE7d0NtdYHvSFyuAgVKreweSpn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=LnYf8HBX; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="LnYf8HBX"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id E460E20B7169; Fri, 17 Jul 2026 13:08:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E460E20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1784318919;
	bh=lzYd7HXJAv1CmOcE6SAirwqAapuTq3aKUkuJIs6O7RY=;
	h=From:To:Cc:Subject:Date:From;
	b=LnYf8HBX8dFInM5AUcmRJOhAuohLifuzjnEknTH4tFqn5+S20Y41Fx9Zv/5k/UayJ
	 0ys70+ZYQ2RlmAdEmVaXNW5wz/dzudCQHEuxdrstWT2/69HJKr99tYrbXMSX67YEic
	 46aimwfzzDNzpaj2s/gOxlh6e8Y9zWbPNYTlqX34=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 1/1] RDMA/mana_ib: return PD number to the user
Date: Fri, 17 Jul 2026 13:08:39 -0700
Message-ID: <20260717200839.495327-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Implement returning to userspace applications PDNs of created PDs.
The PDN is used by applications that build work requests outside of the
rdma-core code base. The PDN is used to build work requests that require
mentioning the PD. The HW still ensures PD isolation using PDN attached
to MRs and WRs, therefore the PDN mentioned in the work request must match
the PDN of the used work queue. The work requests can fit only 16 bit PDNs.
Allow users to request short PDNs which are 16 bits.

The capability to request short PDN and get PDN is encoded in the response
of alloc user context IOCTL.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v4: follow robust udata. Return the capability in ucontext response.
v3: updated commit message
v2: updated commit message
 drivers/infiniband/hw/mana/main.c | 62 ++++++++++++++++++++++---------
 include/net/mana/gdma.h           |  6 +--
 include/uapi/rdma/mana-abi.h      | 22 +++++++++++
 3 files changed, 69 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index c52e436d8..2d0947aab 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -90,20 +90,41 @@ int mana_ib_cfg_vport(struct mana_ib_dev *dev, u32 port, struct mana_ib_pd *pd,
 	return err;
 }
 
+static int mana_gd_destroy_pd(struct mana_ib_dev *mdev, u64 pd_handle)
+{
+	struct gdma_destroy_pd_resp resp = {};
+	struct gdma_destroy_pd_req req = {};
+
+	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_PD, sizeof(req),
+			     sizeof(resp));
+
+	req.pd_handle = pd_handle;
+
+	return mana_gd_send_request(mdev_to_gc(mdev), sizeof(req), &req, sizeof(resp), &resp);
+}
+
 int mana_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 {
 	struct mana_ib_pd *pd = container_of(ibpd, struct mana_ib_pd, ibpd);
+	struct mana_ib_alloc_pd_resp ucmd_resp = {};
 	struct ib_device *ibdev = ibpd->device;
 	struct gdma_create_pd_resp resp = {};
 	struct gdma_create_pd_req req = {};
+	struct mana_ib_alloc_pd ucmd;
 	enum gdma_pd_flags flags = 0;
 	struct mana_ib_dev *dev;
 	struct gdma_context *gc;
 	int err;
 
-	err = ib_no_udata_io(udata);
-	if (err)
-		return err;
+	if (udata && udata->inlen) {
+		err = ib_copy_validate_udata_in_cm(udata, ucmd, reserved,
+						   MANA_IB_PD_SHORT_PDN);
+		if (err)
+			return err;
+
+		if (ucmd.comp_mask & MANA_IB_PD_SHORT_PDN)
+			flags |= GDMA_PD_FLAG_SHORT_PDN;
+	}
 
 	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
 	gc = mdev_to_gc(dev);
@@ -121,22 +142,29 @@ int mana_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 
 	pd->pd_handle = resp.pd_handle;
 	pd->pdn = resp.pd_id;
-	ibdev_dbg(&dev->ib_dev, "pd_handle 0x%llx pd_id %d\n",
-		  pd->pd_handle, pd->pdn);
-
 	mutex_init(&pd->vport_mutex);
 	pd->vport_use_count = 0;
+
+	if (udata) {
+		ucmd_resp.pdn = pd->pdn;
+		err = ib_respond_udata(udata, ucmd_resp);
+		if (err)
+			goto destroy_pd;
+	}
+
 	return 0;
+
+destroy_pd:
+	mana_gd_destroy_pd(dev, pd->pd_handle);
+
+	return err;
 }
 
 int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 {
 	struct mana_ib_pd *pd = container_of(ibpd, struct mana_ib_pd, ibpd);
 	struct ib_device *ibdev = ibpd->device;
-	struct gdma_destory_pd_resp resp = {};
-	struct gdma_destroy_pd_req req = {};
 	struct mana_ib_dev *dev;
-	struct gdma_context *gc;
 	int err;
 
 	err = ib_no_udata_io(udata);
@@ -144,14 +172,7 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 		return err;
 
 	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
-	gc = mdev_to_gc(dev);
-
-	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_PD, sizeof(req),
-			     sizeof(resp));
-
-	req.pd_handle = pd->pd_handle;
-
-	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	err = mana_gd_destroy_pd(dev, pd->pd_handle);
 	if (err)
 		return err;
 
@@ -205,13 +226,14 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
 {
 	struct mana_ib_ucontext *ucontext =
 		container_of(ibcontext, struct mana_ib_ucontext, ibucontext);
+	struct mana_ib_alloc_ucontext_resp ucmd_resp = {};
 	struct ib_device *ibdev = ibcontext->device;
 	struct mana_ib_dev *mdev;
 	struct gdma_context *gc;
 	int doorbell_page;
 	int ret;
 
-	ret = ib_no_udata_io(udata);
+	ret = ib_is_udata_in_empty(udata);
 	if (ret)
 		return ret;
 
@@ -224,6 +246,10 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
 		return ret;
 
 	ucontext->doorbell = doorbell_page;
+	ucmd_resp.comp_mask = MANA_IB_UCNTX_ALLOC_PDN_SUPPORT;
+	ret = ib_respond_udata(udata, ucmd_resp);
+	if (ret)
+		return ret;
 
 	return 0;
 }
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 0c395917b..de17c9bba 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -867,8 +867,8 @@ struct gdma_destroy_dma_region_req {
 }; /* HW DATA */
 
 enum gdma_pd_flags {
-	GDMA_PD_FLAG_INVALID = 0,
-	GDMA_PD_FLAG_ALLOW_GPA_MR = 1,
+	GDMA_PD_FLAG_ALLOW_GPA_MR = BIT(0),
+	GDMA_PD_FLAG_SHORT_PDN = BIT(2),
 };
 
 struct gdma_create_pd_req {
@@ -889,7 +889,7 @@ struct gdma_destroy_pd_req {
 	u64 pd_handle;
 };/* HW DATA */
 
-struct gdma_destory_pd_resp {
+struct gdma_destroy_pd_resp {
 	struct gdma_resp_hdr hdr;
 };/* HW DATA */
 
diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
index 169bf91b3..32cbbfc80 100644
--- a/include/uapi/rdma/mana-abi.h
+++ b/include/uapi/rdma/mana-abi.h
@@ -98,4 +98,26 @@ struct mana_ib_create_qp_rss_resp {
 	struct rss_resp_entry entries[64];
 };
 
+enum mana_ib_ucontext_support {
+	MANA_IB_UCNTX_ALLOC_PDN_SUPPORT = 1 << 0,
+};
+
+struct mana_ib_alloc_ucontext_resp {
+	__aligned_u64 comp_mask;
+};
+
+enum mana_ib_create_pd_flags {
+	MANA_IB_PD_SHORT_PDN = 1 << 0,
+};
+
+struct mana_ib_alloc_pd {
+	__u32 comp_mask;
+	__u32 reserved;
+};
+
+struct mana_ib_alloc_pd_resp {
+	__u32 pdn;
+	__u32 reserved;
+};
+
 #endif
-- 
2.43.0

