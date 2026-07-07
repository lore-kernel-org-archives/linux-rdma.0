Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0653B9608
	for <linux-rdma@vger.kernel.org>; Tue,  7 Jul 2026 19:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783453646; cv=none; b=otzS/ij5PoTUvqvd681GSc2byZ6wC6bchU2lCnb6LR0uQZhS3Ppl37SYmRELDvoe2qZtl+pRI4f/WLvafgyHWp0jC0ejcSzcBTOgWECYtaXOrtoB4+HyX/DIDm1JZ7NLk8f2yx1VDBS71R5iyPFOMvt56Ci1Q7bIqMF609Mi98E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783453646; c=relaxed/simple;
	bh=xTSDaR22pQyGQk/4EZgY3fuju5s4OkZUSYSS6xsFiZE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iLrouZRshavguD9VzfPzR7U2Ru/BOJN68zACms8/83zYmmI9cVzg7dEWBRTySOTtkmWv1B8MISSYjOMdQ6iqc2pca8rjcdIQqaid4gDG7Gw0D8YaU9WdH+3BCx/gXPBOwPFgXb/oyq4H6iNRnrtME1QuQqR8IFcEEJObA8VS7Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IRr+Kt8X; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IRr+Kt8X"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2caed617615so38588205ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 07 Jul 2026 12:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453644; x=1784058444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WqmeYeEILR9RvWotHFEqmi/tcbmYPgYQ90HTJiqdd/A=;
        b=IRr+Kt8XSoZi0W/cldbqT4dGFa+mVVylCryGOIn/eLU0ZAbWdF1D664cAwugbHEkeB
         tL2PGkXKGusyYcEZE3N7jMiNgQlLsYQxEzgs3b/bzotVPiZUOf9lRR7poFxDBtNzWHEc
         8zwYmO/+t/yDhTD9ZZPrS4e/X6UO76dwRO93IMd9lQIp6IQJEg95okpXbiCkoP4odgsn
         KFV2wNkzC4fmEj+Xb7h8r91kzm1KDPlJQY2lwjvGSZcRfq5Nxhjzo82Qp52WMn5ZoUdU
         Vp3tRr3L34MkXsK7L6nvcY/GMpO9A9Xspn/puO9WLqbPcI+/q7CNOMy9qKCSlAjjiyoi
         6OGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453644; x=1784058444;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WqmeYeEILR9RvWotHFEqmi/tcbmYPgYQ90HTJiqdd/A=;
        b=q2kA9gW82BwS7T/3GIck8+F070x8XcGF8XC+cNtQHT2zBjR3/CurCyajfk10E5B6aq
         vZ0UpAxtRrp5lSmhJNsbXc7m1JEsddJ/wGO6Kl22v44gr989Ng/HLhXTDtxZm7BxlJfG
         cQ0IScalt4Kwae9UbWOaiCzYmkg140gmIFAhR2O4bn1CHUlw5lkHZ1zO2a5s9Go2na9b
         vr2WBPSIhLPGV5q6gDJOyfec781mYUbmtzcUtHV8wGy7VAaPbTajhGjhHQaQKycKFzDn
         TmT91YoArMaKUMAXEYm0T3R/F8nNEiRpByZgR8PqH83Kt5h7lMhggJCtT78tLTxu9Bsx
         es6Q==
X-Forwarded-Encrypted: i=1; AHgh+RoQgjOvDMQwZFGJG27I6Ract4Q8FqFqCdW9+No+hVOupx+HkFoWFYK9mj6VoAeZikB3IHBrIH96dmbD@vger.kernel.org
X-Gm-Message-State: AOJu0YzLinUdDYgJOyKthIalSU34X6vWOpR3RR2ZiIHpjNVRQhs6P+w9
	+l1QptYIFbH/Lp+xRxswifbWz1Q60GMhClN9ZxbL3Su3Y2FqKEqmTsvZ
X-Gm-Gg: AfdE7cnDjpur5udo1JG/TSOMh9uQC20pB8arujqUtFU4WJHGFqa4O6Hba7iW9TB6Xuf
	B/zyJXgb+Hdna/npFKZwM2czMXzkedj69dpAhCvGXAX1I5e+O+RbUQ6sw069591BMJ4vKra6OqM
	OZcN9wZnfJZpQDSZglmbsE8uVjAsB9+DOgNRl+XEQYxb+baUkSXn/S008juunITbRHy5BEE5tpd
	0Puqw5iSyIYuxve+sWbXsTYy/j6KZhVyCqeFdc7dKsUgiQiS5JJvrKnqO/SYZi0EC/FlOdM5hJn
	yR4pbkapI14cnHKPyG3kqj4pAjFs79Gpu+cKhA/tBVz8CgtGBYFz6Kjzfh2UQjDTCxE/1igHr9b
	wFcPeZzE4/Gv40yGWtklCIRY0boOVdkTAnr79M8hw9qUq+1pKKL5nPA7IFIPN1ZyOa46UuHvfiR
	GZ8q8vfHwMtCP1rbogKU/x///yqxwHYjZy70wGgR+4B9+p7iwl79Jf4IegcnKM+Lpy80HuoA==
X-Received: by 2002:a17:902:ea03:b0:2c9:d8c6:1dc3 with SMTP id d9443c01a7336-2ccbdc41f65mr54794995ad.0.1783453644502;
        Tue, 07 Jul 2026 12:47:24 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb7e9sm17819615ad.10.2026.07.07.12.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:24 -0700 (PDT)
Subject: [PATCH v7 5/8] drm/nouveau: Use hmm_range_fault_unlocked_timeout()
 for SVM faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Tue, 07 Jul 2026 12:47:22 -0700
Message-ID: <178345364273.660027.15274510603185163961.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

nouveau_range_fault() takes mmap_read_lock() only to call
hmm_range_fault(). It also keeps a single HMM_RANGE_DEFAULT_TIMEOUT
deadline across both HMM -EBUSY retries and post-fault
mmu_interval_read_retry() retries.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries.
Nouveau keeps its existing absolute deadline in the outer loop and passes
the remaining jiffies to the helper for each fault attempt, so retries
caused by mmu_interval_read_retry() do not reset the overall retry budget.

Nouveau still validates the interval notifier sequence while holding
svmm->mutex before programming the GPU mapping.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index dcc92131488e..ba93273341af 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -683,15 +683,10 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range,
+				       max_t(long, timeout - jiffies, 1UL));
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,


