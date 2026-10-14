Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39F34A5EDC;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016479; cv=none; b=LGOCRWRdXwadV7CFJdHZHjHmJoRCZ7jXkc74vcBsGa4dIqLXh+OIbfpVbmi8zskvP3s6GKcin3+MYgnb6pJH7NYJiatbOjJW80T3zdkFOJqv66lz8Y1Uq5ZSbpbd6ibwsvZXTGht+7kguIaUVJ0/SfdNGOdhigCTbB8H04kVIoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016479; c=relaxed/simple;
	bh=uminC8aRudLJBeh/LmKY7eTI4s2cJ4jkZ3mGnQkVcrw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=czvQCYDnsVK0VSo1xZDX3Y+MbXmCcZYzfCruHQ3cDaLwrmoa+v1nlMnlglWhil2Zx3W37h80F8CaWx4hawFrHllF9iB1VdOIBSdCxir5Zd+kUKxZxaByzvWKC5yLHfl8BimXU3+fFw5ZGIwf7G9dvepvSyfk3MnWVSiIot8xJak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9DGG0D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9DGG0D+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6899CC2BD00;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792016479;
	bh=uminC8aRudLJBeh/LmKY7eTI4s2cJ4jkZ3mGnQkVcrw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=d9DGG0D+wcHIqw8SJks39nCSoCXEycXeXSeAqQcWB2Mn0WQkDaZOQgm47OzICvq9P
	 c8zcQvI6DDSq9xm6dUBbH3wZwQH7+CZTzT+N3yYk/dfBvMFkRub6Wg/FPYKzroZDY4
	 NozwxfcvqNy7BqPhVzgy3V+BllJl3L70uk5Ej7ATl6kqkfiTf8QYLLh7p7Bk5Y9YvU
	 a+vBnRDNa0R7N4FNr8EjLcU4ukknuKxE5Jwhf3kfKG7M72OI4OiJ6GqnwGAclQa+6M
	 HwB0+XyHNLxFr3//tesXBkgE5kP67V8LbgPg2ZDXhVkZeS6S4LrkS8zcYt8nHrOcos
	 4lCkIeCloBfSw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA09CC6B2A;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Wed, 14 Oct 2026 15:21:12 -0700
Subject: [PATCH rdma-next 03/13] RDMA/core: report the reliable unconnected
 device capabilities
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-uet-ib-core-v1-3-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
In-Reply-To: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792016478; l=4489;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=0vggS3kxYqLouN3EkZY+uyQtSRkdqNXoiZQOh4hHx1U=;
 b=iK6T7YSFxiGXf2cmJ/r2FKQkkJynVSD55RohTUp1Opi0WIY8p3Q+/KzZWD01lN8DuHwpov3XA
 QabvwZvJI8RAPq6PMH4rZysnrIWoOg3B2K3q4CHtXx7OaZgk0zA6fzl
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com

From: Eric Davis <eric.davis@broadcom.com>

Add the capability bits a device uses to advertise reliable unconnected
support alongside additional features. The transport itself, 64-bit
immediate data, 64-bit memory keys, caller-chosen keys, and the four
memory region access restrictions.

Report the job, job key, and address table limits through the extended
query_device response so userspace can size against them.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/uverbs_cmd.c |  3 +++
 include/rdma/ib_verbs.h              | 14 ++++++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 25 +++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index aca7c6ab55cd..ed55fbbdfc18 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3597,6 +3597,9 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
 	resp.cq_moderation_caps.max_cq_moderation_period =
 		attr.cq_caps.max_cq_moderation_period;
 	resp.max_dm_size = attr.max_dm_size;
+	resp.max_job_ids = attr.max_job_ids;
+	resp.max_job_keys = attr.max_job_keys;
+	resp.max_addr_entries = attr.max_addr_entries;
 	resp.response_length = uverbs_response_length(attrs, sizeof(resp));
 
 	return uverbs_response(attrs, &resp, sizeof(resp));
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4e3a5c38cbe8..02f3312c7cf2 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -278,6 +278,14 @@ enum ib_device_cap_flags {
 	IB_DEVICE_FLUSH_PERSISTENT = IB_UVERBS_DEVICE_FLUSH_PERSISTENT,
 	IB_DEVICE_ATOMIC_WRITE = IB_UVERBS_DEVICE_ATOMIC_WRITE,
 	IB_DEVICE_CC_DMA_BOUNCE = IB_UVERBS_DEVICE_CC_DMA_BOUNCE,
+	IB_DEVICE_RU = IB_UVERBS_DEVICE_RU,
+	IB_DEVICE_IMM64 = IB_UVERBS_DEVICE_IMM64,
+	IB_DEVICE_KEY64 = IB_UVERBS_DEVICE_KEY64,
+	IB_DEVICE_USER_RKEY = IB_UVERBS_DEVICE_USER_RKEY,
+	IB_DEVICE_MR_UNRESTRICTED = IB_UVERBS_DEVICE_MR_UNRESTRICTED,
+	IB_DEVICE_MR_JOB_RESTRICTED = IB_UVERBS_DEVICE_MR_JOB_RESTRICTED,
+	IB_DEVICE_MR_QP_RESTRICTED = IB_UVERBS_DEVICE_MR_QP_RESTRICTED,
+	IB_DEVICE_MR_QP_JOB_RESTRICTED = IB_UVERBS_DEVICE_MR_QP_JOB_RESTRICTED,
 };
 
 enum ib_kernel_cap_flags {
@@ -456,6 +464,12 @@ struct ib_device_attr {
 	u64			max_dm_size;
 	/* Max entries for sgl for optimized performance per READ */
 	u32			max_sgl_rd;
+	/* Jobs allocated at once, not the largest JobID */
+	u32			max_job_ids;
+	/* Job keys allocated at once */
+	u32			max_job_keys;
+	/* Largest address table a single job may have */
+	u32			max_addr_entries;
 };
 
 enum ib_mtu {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 565301594634..bae6fcfa01dd 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -300,6 +300,10 @@ struct ib_uverbs_ex_query_device_resp {
 	__aligned_u64 max_dm_size;
 	__u32 xrc_odp_caps;
 	__u32 reserved;
+	__u32 max_job_ids; /* jobs allocated at once, not a JobID */
+	__u32 max_job_keys; /* job keys allocated at once */
+	__u32 max_addr_entries; /* largest address table of one job */
+	__u32 reserved2;
 };
 
 struct ib_uverbs_query_port {
@@ -1370,6 +1374,27 @@ enum ib_uverbs_device_cap_flags {
 	IB_UVERBS_DEVICE_ATOMIC_WRITE = 1ULL << 40,
 	/* CoCo guest with DMA bounce buffering required */
 	IB_UVERBS_DEVICE_CC_DMA_BOUNCE = 1ULL << 41,
+	/* Reliable unconnected QPs, jobs, job keys and address tables */
+	IB_UVERBS_DEVICE_RU = 1ULL << 42,
+	/* 64-bit immediate data */
+	IB_UVERBS_DEVICE_IMM64 = 1ULL << 43,
+	/* An MR may carry 64-bit keys as a second name beside its 32-bit ones */
+	IB_UVERBS_DEVICE_KEY64 = 1ULL << 44,
+	/* MR registration with a caller-chosen rkey */
+	IB_UVERBS_DEVICE_USER_RKEY = 1ULL << 45,
+	/*
+	 * MR access restrictions, meaningful only with IB_UVERBS_DEVICE_RU.
+	 * Each names what an incoming request must match, and each is its own
+	 * match: supporting two does not imply their combination.
+	 */
+	/* PD: any QP */
+	IB_UVERBS_DEVICE_MR_UNRESTRICTED = 1ULL << 46,
+	/* PD and JobID: any QP, one job */
+	IB_UVERBS_DEVICE_MR_JOB_RESTRICTED = 1ULL << 47,
+	/* PD and QP: the QP the MR is attached to */
+	IB_UVERBS_DEVICE_MR_QP_RESTRICTED = 1ULL << 48,
+	/* PD, QP and JobID: the attached QP, one job */
+	IB_UVERBS_DEVICE_MR_QP_JOB_RESTRICTED = 1ULL << 49,
 };
 
 enum ib_uverbs_raw_packet_caps {

-- 
2.56.0


