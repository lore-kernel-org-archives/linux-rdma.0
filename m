Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D584A92DD;
	Wed,  2 Sep 2026 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363578; cv=none; b=LDbNMbeTctVqTcirj52AUkyVJtzLOpPVJ/9JqZQe40f7AoS9DOu8sQ0DCrhMl15ssErCHkKgolaqSX+ZQb/SGNoVjTAzP1xJ+wYSRVSreUaUQOH+aFlPCQkcHSJTFf6hGxDHWFYm7yMU05tMhbrhU7cR0W5zzXoQv5CkgIWvwOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363578; c=relaxed/simple;
	bh=VU9DtAlzKIpgs6krNbnMH0eL8crsuwpfJ+2S4EkS3p0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LX/cSgfXIRgZCUMOMRAVCiTHLdu5SGHAZ2VeOMkTAQ98G9zPpel/kbWf4MVx5tJxYVjFMm/EPi1SfdqM4VM9hn6Rg3/RP1kZwMeGcN7xXpbxHXpXp40yCeTtrC3WxzW8LaIKNrykTQXwiifujau1YPw1/cbNVBPuDJWXAqEKWHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ai9yZZ5L; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ai9yZZ5L"
Received: by linux.microsoft.com (Postfix, from userid 1249)
	id 0BEEC20B712B; Wed,  2 Sep 2026 08:39:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0BEEC20B712B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788363540;
	bh=8bgbxz64iL5pF0y29VZ0iW69D5tZy8lEY05GUYEoo54=;
	h=From:To:Cc:Subject:Date:From;
	b=Ai9yZZ5LTGLLbvNA9hQfwCQzl04lV/zaPHNoaQ2CvzLAnLYacJOJ9rCmz5WaIleYR
	 k9fbavbUbVAh9vFrdVyTv0lfOe05dnhGqmYVubVQQOMa7oSd4NkUUf7BCYVYJQZ2iv
	 96byLUlTs1PyV3rcDcnNUJ8U5TMemxCCSpCTtMe0=
From: Snehal Sanghvi <snsanghvi@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mana_ib: advertise pow2 RC SQ support to user space
Date: Wed,  2 Sep 2026 08:38:13 -0700
Message-ID: <20260902153813.3385076-1-snsanghvi@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Snehal Sanghvi <snsanghvi@microsoft.com>

The send queue of an RC QP normally needs an extra rollback area in
shared memory. With fixed-size WQEs the rollback can be derived from the
WQE size alone, so an adapter supporting it can accept a plain
power-of-two send queue and the rollback area becomes unnecessary.

Report the adapter capability to user space with a new comp_mask bit in
the alloc ucontext response, so that user space can request a
power-of-two RC send queue when the adapter supports it.

Signed-off-by: Snehal Sanghvi <snsanghvi@microsoft.com>
Reviewed-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/main.c    | 2 ++
 drivers/infiniband/hw/mana/mana_ib.h | 1 +
 include/uapi/rdma/mana-abi.h         | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 83a97f1c5c..672bd3f650 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -248,6 +248,8 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
 	ucontext->doorbell = doorbell_page;
 	ucmd_resp.comp_mask = MANA_IB_UCNTX_ALLOC_PDN_SUPPORT;
 	ucmd_resp.comp_mask |= MANA_IB_UCNTX_RC_EXT_SUPPORT;
+	if (mdev->adapter_caps.feature_flags & MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT)
+		ucmd_resp.comp_mask |= MANA_IB_UCNTX_RC_SQ_POW2_SUPPORT;
 	ret = ib_respond_udata(udata, ucmd_resp);
 	if (ret)
 		return ret;
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 1be33ed8bd..4da110b302 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -268,6 +268,7 @@ enum mana_ib_adapter_features {
 	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT = BIT(5),
 	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT = BIT(6),
 	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT = BIT(7),
+	MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT = BIT(14),
 	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT = BIT(15),
 };
 
diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
index c9a2417666..ebc9a655b8 100644
--- a/include/uapi/rdma/mana-abi.h
+++ b/include/uapi/rdma/mana-abi.h
@@ -111,6 +111,7 @@ struct mana_ib_create_qp_rss_resp {
 enum mana_ib_ucontext_support {
 	MANA_IB_UCNTX_ALLOC_PDN_SUPPORT = 1 << 0,
 	MANA_IB_UCNTX_RC_EXT_SUPPORT = 1 << 1,
+	MANA_IB_UCNTX_RC_SQ_POW2_SUPPORT = 1 << 2,
 };
 
 struct mana_ib_alloc_ucontext_resp {
-- 
2.43.0

