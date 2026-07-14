Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5E4418A40
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 20:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784060022; cv=none; b=LzyWCnY2+3Xaf1+P0rZhF+Qom0qrpB7v1/vGD0janNLgB10AxrjZdeELyMbTSDyvlAo2EcxqaBPLbBdRr3nfcEYagvGNNpaxMPfpuI9/lc76uOr7GJiwf6QwYCMW8uubnAK6d4khphahOsHT263M5mnCvyi3z4EUShBA+c/12UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784060022; c=relaxed/simple;
	bh=WvDPQHYOIkqnmOV2e/TAfKZ2L/I07bZ1I5RIwEB62T0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZMuM+F5ZMB2ZvEthpiiJXr9zb9CIlVNe2NPq0jd2w1j076rzvybQ9HkTgHf51hwQEKDBtqCx3+N42kIEpDzp1j1o71GqOBnAC0EEL4dcLI1kQyfL4Zn8nJhZiJf72tR2AEQrR0wINEg407lUB408lmpX5gItcL/xYlfkBTWy+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tI88np37; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tI88np37"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8453427d3f4so4174977b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 13:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784060021; x=1784664821; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SKEncuDEb35sxzE1YTlJf1hRIKo4X4QhyOOQXqSLrW4=;
        b=tI88np37nu17in0up+CXIDz/YCk68r8JvxjEKWz9q+3FlvBVN9F5+S+WM7wjSQsg1N
         Bap47XONl7+YRhLzjKnUvgmGKYshkMIarES/ULKGzhWLmWCSD2Cbd5e4dDzchjhD/mzJ
         ADX8QUG+nY8LWphdb8rEFWqXNOZBl82V2W3XwSou7Mem/YVCBWsaq6eUGEZmOwucFRTb
         evTXdeQ0uH8idZyN/SzvZhQmIaczrqLaneqBFWdnlP0EmCyTLjN5fAteepSXaROXxmLi
         kMlE7uI9V3Txd7cQi3j61tSlCgpdtpl13Rj2xPcpBjhSY6azKJfR9KQjufAbFMUTSXVY
         Yd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784060021; x=1784664821;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SKEncuDEb35sxzE1YTlJf1hRIKo4X4QhyOOQXqSLrW4=;
        b=JVxnj1FKMWXkLY9ykgt9HcuB1FUbrCtzImAprKfhEFjFhpTFlY7EJB9LcImLUOX6h8
         yIUtAN9aV7yocW3JiOiI7H4pflWKJIn4tGWXDVxiryse5HTEf201Qj5F9x7mHhDxmvUn
         hr1N5grXoqJwEopvNnESm0ROq2lCnTEqagvOMjqZbA0Uu1fVWzFplNyHte7Qasid150W
         oxSqrww9AaUr4VFzMRWs+PT4rC4yHKVjt8wqdSQTBFGJs2UzFoyY3KnRB8nz7M5KoPmY
         lrFUEh7h1wKYdTRqsv7igZtG4VQ0648NAdc0F8Pz+J3fkwQao6aggzbf/rOKgLdDZNGF
         uiVA==
X-Forwarded-Encrypted: i=1; AHgh+RqOAAwea6zz5lNjo3D6sjzDw6Q56H+ln4zRSVHW3a0I7VwGUT1GLDEEDpj6olYUQ32dWyY44O51F7IE@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkd2INN0j2/R9FdxbSMvLg1cf1d7X8McmWOfkcTfjvaLWtpCSF
	5yS5orIScxowKs+8F0+DeVxxlDWxAigRG0wxVbFSAcRG+ixS0DbWcMNL
X-Gm-Gg: AfdE7clK3Z/lBm0bcakkEcaQ2JmZNwwj5pDN6VWl16K6EKJaD0Jg3rS8Euvj5gTRr2m
	JYIWWlnKGXMxYUozYaSWXf/hQueITlpp87BoydTd7d6dl4HhVdTeb+XPGLtUg05TUXD2Kp5XcTR
	vD7uQxhmhbPRVUFImqIG3XdzqDd2stlHHNTCRLMP6zY/LyY4jjCgNrNlMXp16kOV99Vv8oEWhB9
	vlJf3NmAjlr00u4jj3lVDm1oyIQ6xHsQUnJW2vP+gMWogtbZu8LdStwr8qet4S0ynrGLTfWfynB
	RtYW2SnNPRN1T828IiRg9JY+Ut+MBHXwDqO/1F5Dgo5jLEHnAq54rLYIainoycgHQjBsm3j7F3R
	7bO8lzxJugC0B/yZADGXfAAYneSoAkh0rP7zoyRSb8dnDU3UYQOvHwFtwS1oH3L+JmnGVRymCF3
	V1zlz2TZLQU55uRwA8omCpe4DgXDHjx2HC3jeptUqtueqrH+UA0ZDLdpuqpAM=
X-Received: by 2002:a05:6a00:2e16:b0:846:f502:4cd4 with SMTP id d2e1a72fcca58-84a671da73cmr45857b3a.4.1784060020856;
        Tue, 14 Jul 2026 13:13:40 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f81d770sm1966491b3a.61.2026.07.14.13.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 13:13:39 -0700 (PDT)
Subject: [PATCH 2/4] fixup! drm/nouveau: use
 hmm_range_fault_unlocked_timeout() for SVM faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
 kees@kernel.org, leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
 ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 14 Jul 2026 13:13:38 -0700
Message-ID: <178406001808.1082778.17299764648397654220.stgit@skinsburskii>
In-Reply-To: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
References: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

nouveau_range_fault() now uses hmm_range_fault_unlocked_timeout() for
the HMM fault path. The timeout passed to that helper is meant to bound
HMM's internal mmu-notifier retry loop, not the whole nouveau retry loop
around mmu_interval_read_retry().

Pass the full relative HMM_RANGE_DEFAULT_TIMEOUT value to
hmm_range_fault_unlocked_timeout() on each attempt, and retry from the
nouveau-side mmu_interval_read_retry() check with a fresh HMM retry
budget. This lets HMM continue when it has made progress, while still
preserving a timeout for repeated notifier invalidation retries inside
one HMM fault attempt.

This also removes the open-coded absolute deadline and remaining-time
calculation from nouveau_range_fault().

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 4cfb6eb7c771..b1415c2e49fc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -655,8 +655,7 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 			       unsigned long hmm_flags,
 			       struct svm_notifier *notifier)
 {
-	unsigned long timeout =
-		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	/* Have HMM fault pages within the fault window to the GPU. */
 	unsigned long hmm_pfns[1];
 	struct hmm_range range = {
@@ -677,25 +676,16 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 	range.start = notifier->notifier.interval_tree.start;
 	range.end = notifier->notifier.interval_tree.last + 1;
 
-	while (true) {
-		if (time_after(jiffies, timeout)) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		ret = hmm_range_fault_unlocked_timeout(&range,
-						       max(timeout - jiffies,
-							   1L));
-		if (ret)
-			goto out;
+again:
+	ret = hmm_range_fault_unlocked_timeout(&range, timeout);
+	if (ret)
+		goto out;
 
-		mutex_lock(&svmm->mutex);
-		if (mmu_interval_read_retry(range.notifier,
-					    range.notifier_seq)) {
-			mutex_unlock(&svmm->mutex);
-			continue;
-		}
-		break;
+	mutex_lock(&svmm->mutex);
+	if (mmu_interval_read_retry(range.notifier,
+				    range.notifier_seq)) {
+		mutex_unlock(&svmm->mutex);
+		goto again;
 	}
 
 	nouveau_hmm_convert_pfn(drm, &range, args);


