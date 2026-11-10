Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283257;
	b=Vy7KypOyQm1N4h2hnHGmRxanRhUm+nnJOyTb2TNSd2xRNcvvSFuEoW0jXbEkx5DX75s4
	 BQeyqPNULs2iYnWPfyIl7ch/QswWv5QmEwOIgiu8nLjmZx65OjIG91EHE+/NwNr4xjrWv
	 9MOF2qo8KOFLNKLhRYzujcCCSQJOCqIwtnVGy8qyTJjAHBg0LjGDj4QvGQCHJGSieiALM
	 b4QOn0NtAaWYJhgoEpjXLBvgNI7VGaIyQkpaUXofvzjxyZ1qBwZbqWq2mGoGWqtSmoIud
	 umGdPPaG9bHHflBW0/0AgEwaznVICx+0E5yOE1pF19qlu9I3WoTW2ojPetsYc0njxtw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283257;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qZyDtSn1g0h2ItFJu1SDHhmHLJJgEVmwSQ+pDO4If2E=;
	b=C68dm9f2yyL2ShFeKW7ZFy5STkCL2yHLVcFzfxgT+AolrpBy7+hRiF/BIrDFh7g3zIdP
	 0weYR1q7eHJub4plOTirbGFON/I+COxQCKwIiX2cDUO3sKURtIhw7tkMf/z/Kmmg9UBTI
	 2U0K7Ov9qv6Gj23XUGyfa72Z/xm99zTIQn8dksl58C3KEFegnoVKB3iiJbNiV3CN5eEQJ
	 E7oXY2LKpFaQOEm/Ow76D2hpvJi2UAEhFhIiHwtzsxAIugxwNoO3qjMz9tYWMd0xm1dUL
	 AsyDFCZABCugn8RsWLSWnl/s/sWJL2J25K7Dr2KT5v0PwdCBAXTSIs06wzBR04n2EIg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LHhnRTk6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29BE606A33D;
	Tue, 10 Nov 2026 04:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LHhnRTk6
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283256;
	b=lhL/pG/2HK3Zd4sbN31CarcRFf43dAzLrSWZH2wG+C9tjcMq58w1C1+WRIlYP1FyKw9H
	 BRDjF1uDvz69mpNvx8pw7wmV2JEb5xzO3d2f4V9cbENnFd/iP9mq8u7TNBMEE9tMqed2Y
	 Noqd08ByCeySPDEWNS8oP/wROdyu5Z24UUpLL7UukwKK2A1yX+0D9Ssnf+/4TYgBN/ujp
	 CVCcw3qdupJ0XTT8v+Ie4pGSTKFwadF7ajfXU9GY89hNRc89SXcuwsO/NqWEBbdHkttOD
	 0aE1MuEg35Sn8VbSYk4V8CBclU98H67Fb4L70EgSlVAo6i5vWTk3F2W5yCx3NOzEHxw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283256;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qZyDtSn1g0h2ItFJu1SDHhmHLJJgEVmwSQ+pDO4If2E=;
	b=qvj37SjOr3rcGal9uwpe2ZGFHkt1beujBKRsMaf5oC3I/rcjlueL925/Ceic+tpDoeb8
	 k+VzXNnWqKUseDVuWPLCjjT7Hl8K2q5PGCTiRdHtVIxoHKqpBTKymwnr7QWPkZ/P911Pw
	 +j7FXAv9aFTtAUELYlQ86HjFt4DyTvrQ1P3r9vUiyIDEgvJOgn63Kka7qffcR13l9g8a8
	 CiXtgWN3YYslll9k+ZlCDg30jHkU0SYJSeE5/Mnl9u4tUxDJeBJnFxeDdY6TcmFTXFnS3
	 MxNStf7tcSDOU8gUQz2M+69l+PKQOOyNldpBjB40URmLuaHHSRkiamSBGCS8EzrKoOg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2ECD01F008A7;
	Tue, 10 Nov 2026 04:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283256;
	bh=qZyDtSn1g0h2ItFJu1SDHhmHLJJgEVmwSQ+pDO4If2E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LHhnRTk6fx3uNEKHuQv0vgrI7eMPS91G/tCK4JnYBYTgXJwlMKSHP44hloacIUGSQ
	 hUfkcYKVxObQlMmp2/Yw+QWGCtELrFCQmndiplHXGtcW4Gt8Zrp3z9g7KTPe3BqhNm
	 qLci8dS38HPSj9nJRM3qsqi+LLvK5BD9XcSenTwoHYxSTOgZLnIr/1zVDNlIjddfyw
	 hY6PUMV64LFIogi3I3Lkoo5EbSp+NAYqMojmewurf/cpycJCHNx57YEesyqxRq6XTD
	 8icwSRyvJ1dNeJW2eG0guTztR68p/BBh4Zpk5TLiBJ+UNqSmY47DsThXHiVKOsLJfa
	 2t8e53Gi1ka2A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AFB2748804;
	Tue, 10 Nov 2026 04:00:51 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 09 Nov 2026 20:00:36 -0800
Subject: [PATCH rdma-next v3 03/13] RDMA/core: report the reliable
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
Message-Id: <20261109-uet-ib-core-v3-3-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=4668;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=/23nLQczVlMf+hykewDRjOk06ky6wwzSdo1klVIpgIM=;
 b=FEOTDrE9MW7BeNSfKgSdgbupwq7zwhpBam3Cd32xREQuPx0suVgGyNbI34JBQg4ut2QI95g5k
 ft1gZFP8RiBDNMW/ZpXQhwXW3eWo8secyoZbaevJS/cS7OgewIAbzn5
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

Add the capability bits a device uses to advertise reliable unconnected
support alongside additional features: the transport itself, 64-bit
immediate data, 64-bit memory keys, caller-chosen keys, and the four
memory region access restrictions.

Report the job, job key, and address table limits through the extended
query_device response so userspace can size against them.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/uverbs_cmd.c |  3 +++
 include/rdma/ib_verbs.h              | 14 ++++++++++++++
 include/uapi/rdma/ib_user_verbs.h    | 27 +++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

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
index 565301594634..df3e72aee9a8 100644
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
@@ -1370,6 +1374,29 @@ enum ib_uverbs_device_cap_flags {
 	IB_UVERBS_DEVICE_ATOMIC_WRITE = 1ULL << 40,
 	/* CoCo guest with DMA bounce buffering required */
 	IB_UVERBS_DEVICE_CC_DMA_BOUNCE = 1ULL << 41,
+	/* Reliable unconnected QPs, jobs, job keys and address tables */
+	IB_UVERBS_DEVICE_RU = 1ULL << 42,
+	/* 64-bit immediate data on at least one QP type */
+	IB_UVERBS_DEVICE_IMM64 = 1ULL << 43,
+	/* An MR may carry 64-bit keys as a second name beside its 32-bit ones */
+	IB_UVERBS_DEVICE_KEY64 = 1ULL << 44,
+	/* MR registration with a caller-chosen rkey */
+	IB_UVERBS_DEVICE_USER_RKEY = 1ULL << 45,
+	/*
+	 * MR access restrictions, meaningful only with IB_UVERBS_DEVICE_RU.
+	 * Each names what an incoming request must match, and each is its own
+	 * match: supporting two does not imply their combination. A region in
+	 * a class the device does not advertise, such as one waiting to be
+	 * attached to a QP or detached from one, is reachable by no peer.
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


