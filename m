Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465417;
	b=oST08zDngXmViIyj2w7rk0hi7D1m+Di+QwDP6C0XUqP8juQd7x5Hq7dW0AxO6q2w7pi9
	 qCJ/NBulCOTgKd7eEi5k1UWb18Cm2M49C4n9PfendcLTBJP5DGIv6YTpfddCHgVjp3eHY
	 5Hq+t6+pIRPUVpcyCvCB2wZ/j0PKXHSZlYl38jKck7t6i6XEly3WYQccmHW4zS0I/P8Tf
	 4isKVsSMn+RPittinH/2TscLkQWht3YmjSoK8NTKA9tt0tMfKNg/7eR4NpuhR7AVqaE7H
	 vLHO2PNGBXb0KLkv0bDKmxUTq5uagINHoZUyVx8P5Wvl8LbEq6kiJiRZ9+GsH5xhfVw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465417;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=vbclyfnZWGCoubbNqK5pgo3qhGorGItlL5Nu/vYmNBE=;
	b=fWBtcxaVTIB423YSfwcGOQwRJShUvdpr0hppjIXfWXq2PFYbaAiKp0y03NKdyAzqLjeD
	 nzBT48CcI25AQdZ9x+AY3nJAra5Ttgfafg7zKQ95Abm6A+HV+DmEyl5+ohUQP/HWo4/z8
	 vN6gFZmaM7DGsGzM1cBalFJZ7ag3Ft45IxggQR0HD5vfGeDg/JbMn8I2wusoAxdyjBVsy
	 iglcXmPxxasWbPyYWEiS7ju3VBt6tNN8REds5m0cbpmk9RtLYNjSEz/gP3i5hBImt331J
	 dJMC2WYxIBWi6zwq74SRLZNCFQrFKcn1CRE0HpL/9+VM7a+2IWONeDHPrjpMBZSBBWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d3s8BcKJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95877606A31E;
	Tue, 20 Oct 2026 03:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d3s8BcKJ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465417;
	b=xtu9Q50XrxgLUDal/jSDpDDd8r+AWo/1UNi660KSqMxdcXQJDam6hHtoLWPx3Gtax99p
	 R0S/bKjm8drfIjG+RP36QcaO4s/ghAbojHYUaavAPEHB5JxESsNpRDI1xsSmKBzo0wKzy
	 ZfWifxat62R9JGckoJTAaZqXyfAQN1xwiUibhAtCrVLYlYsGvgyf0A+79IejAtmQdMV0e
	 mepB8xDilSpt6V0pKu1ZMH1AQrewvxSnWhX3zyo8KU/scfXAw8o/Hozd8hf6u3vzHaRZ7
	 z67LQTTBiScpCFy4+d/q5sI+OUJ8aD1B5lbb427gGsWuRQASg/VSf6SQRkT+tR4if2Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465417;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=vbclyfnZWGCoubbNqK5pgo3qhGorGItlL5Nu/vYmNBE=;
	b=Nn5HmBKHeV7By2Y+jbqoVZpHDXUYPtguPW3lnLElehYqK+6lk8j2fpmbnbd3qG/U2X9y
	 GxHHp1KlRTKM4XKFVRoFhobAlQJmY43A0N+VUmH5DN1jzgP0xhoLytCZvgiNOXPubZu/7
	 bgDgvJRgbFN7VACE8ahT//zUJnzlxfvRBD+j7GzdoaMDvNT8c6ZAeJ/UCesYmdGN+pw95
	 3PGHQxqevqUFBuE2lBKBsIF8PjCQCMdQt9pwRoEFTdDX3qQDHfM+wj/1oYv8FvuxrW3uP
	 Mn07yg1RCVrAWBo0w4Reu4JF0ESl4ZG6Td8Tzvmm4VZSr5v1pJVvUzNvGiy4PgNjSaA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B7D6E1F000C8;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465417;
	bh=vbclyfnZWGCoubbNqK5pgo3qhGorGItlL5Nu/vYmNBE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=d3s8BcKJ23hLyJ7LnxIrax2KxkzBjKSpTuBeam/mwJfVjCR8C6TBzmMAS9j9uOEvr
	 7K3EYCXLY8KrACOlOpBF2oZTLlKGIA1ahXSHivEYo/iDD90UvyMRgVIkwn3bwT4HAN
	 JF36pyva1WsLbYp7Xw+CudHgh65mT/dHYphSYrEkKdIvrrddRM6HSL2zzLIsRsnfb+
	 BK0jCQJfzynr0OrXLelNp32MM5SxFiX2UQ45RUYE5NM+JSmZovHtG/eyd7FAEpt/ny
	 HDDTFEvS0kVPnzUFxPJzFALtVKEYxyPnxLY29fbACvxvwKxcYu/h4ZQU1UywaB3N2w
	 PE/d4pqGCmVGg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 27A5E40704;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:30 -0700
Subject: [PATCH rdma-next v2 03/13] RDMA/core: report the reliable
 unconnected device capabilities
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261019-uet-ib-core-v2-3-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=4489;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=0vggS3kxYqLouN3EkZY+uyQtSRkdqNXoiZQOh4hHx1U=;
 b=cg/2mylI21Itjpszv+1uxDeun+tvbMihqM3Il54YCOww7DMN/miTtNcGxC5J5BzfQQzslDyCM
 /RChb0I+mjMCkuRaUxD4FZheA+41JrEcCdNRxZNrQuNDrLMhWQmcyCJ
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

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


