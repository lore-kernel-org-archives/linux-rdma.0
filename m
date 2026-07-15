Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926DF41A56A
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 18:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139415; cv=none; b=G+Pbt3jOwQphm1milsVsfu12xZEH+sHRQMVJk7NHGq86IBK57aNzY5FAAHyoAJzzkkFX9ed0W8k2Q9Y7gmSG4vAuq1NCZ+m84e/MhbbhosXlydmlhk5lQo5cDcjh/dLc/KeCAsLGmOQ3iEwzVknTSNYSkaj3+B2JLmSA9D1Pz7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139415; c=relaxed/simple;
	bh=xAOaqD9o05fm96vslZiqqo0PDijNJtR0XV7t4d/e/as=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fpVq9Lz69T3HHZ1BFQ3qzMA335+9QCS5K7svSnH1RzvMV/iUAfiybFK2LptvC0mpGjd18C5HkWplzaIIWzVXLSKtI0tvnKmdrBZZBVWAeiSh0RNc/MTZpzW1GHmLClWdaEjwl25n6WI3qIWu8SXpfb5BLk+R97OYH4PxppQPcb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SE47BdFA; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SE47BdFA"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso25554245ad.2
        for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 11:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139407; x=1784744207; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+q3csfDWWlHf03esSbv28913HL95J8hCqGqZ6tTf+OA=;
        b=SE47BdFAKydCpd3F0xQvH+uV4OK+/DfA0ukeyxnJhoOMwEyaZ6uynE9gF/5aMEwqBe
         CHYJ3cIQlGddeFo3GB2+re2p6ohhBBFoJ9a2OggO34cy4v7+T5H9LhdXqYqnqvYh27jj
         epveLpJerNf7bSeBcBAB1Spr79INN3BGE4tAsLSq1Y8SEhyyqnOTumk+xKgnXgwJC8dw
         4o1RZfrRhGjpApZsl3rYdxRXOnKMwcjIkxaxtHdF8Lm0K2gB67MlbIRkd1XAADgNQRgs
         coFN3L+hylwUI0Jnf6zel8dPMH1mJjjc1mxkcCm1Fdo/hYj2r7m4v65I8gubN2e0Meln
         BwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139407; x=1784744207;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+q3csfDWWlHf03esSbv28913HL95J8hCqGqZ6tTf+OA=;
        b=sHGzQJyZU+lIW14i8zWZJSs/0x2FJYT8JAGLet/YiF+vv0VSI7yP2QtNChIV90WeXF
         X3ZGGnM2FM4XczYm3eaUHdlNULqNfSEnisNaRjqbbzk9XvUZP+uqPdCPofzVJVf56nU3
         jg8ETTqbB2jZvbLUI7Y/zn8iePFbPYDCjd6BKzEqxzbXXVpxcqdJK6KbLQw8e0REDbQ+
         1HM/mLd/RiPrhWV3iL7MNBHj1Q+R+FOvX8SvoJzoALG/OszcS8wxL0FYMP98P4CGG4LB
         pNlOLux8eaPRMvXBviY1HxQoIxHzsDyfgsjcmowZw/EBCgXsMBYI5Y+otdlnSmBsvUMV
         sGBA==
X-Forwarded-Encrypted: i=1; AHgh+RphQtUbzipgNeCECYzd8wS3dqTdUyUQFKN8jQxFF4ehfcIGoE8XeIOUHwJLE4QXBIsF+j8mBMhDdSoV@vger.kernel.org
X-Gm-Message-State: AOJu0YyGOk+URPmCbt0VISndupe+wWy9jlqZDLw7rwvFRefNCS6g19bl
	nYmKJWxekBzkBlAFvg048BYS7fDa+Fz9EdgLzURITGij5uf92FJV5thC
X-Gm-Gg: AfdE7cmF4dJhLJDzV8BkQ7XOcf6v8uqRkZ6e9rFs2SCCV1oXriyVcCiTtiz7dvelyIG
	4wkq1YJrBM3R44OAgeZUCo/BBPcOUz2NwxoihqKSvcdIJHOa+lBvscy+PRkJWiPdoX9WLbaH1nd
	tbhTcNEuWliNmEuiKAL4xpvIGehpbq/8LYO+nS2uLQ+rfekFg0l1W0bTEkyzSIt4OTMgjCi13s7
	Q7im0UVqflkONedMeid9WsvxSq/u1o2aPnwTrueZtDC+NUz5I0K+poTA4kZ7klMYUvvce79noyJ
	pxsvDMd6b6hKB/4eBFI9+3fyqxi0rl0gpZAjiEEM/Ze591n7usNIRSYmp33RTLMq24zAwFkhio2
	e5UzvkTbfVSiIMBETVHtZ6Q3k53yN5tcqXlT9d7lUMNN7OOq1jGooOAmkJ09BM9EdTO3VicenqE
	QWQGgszNZ3tJEKZJBSDtn4SFWfJvDpQP0ssj5roxKMY8gEVoHe+DH9cCedcz8=
X-Received: by 2002:a17:902:c94a:b0:2ca:b8fd:f31 with SMTP id d9443c01a7336-2ce9e9a175bmr176469515ad.15.1784139406969;
        Wed, 15 Jul 2026 11:16:46 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf1055d661sm6778695ad.42.2026.07.15.11.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:46 -0700 (PDT)
Subject: [PATCH v9 7/8] accel/amdxdna: Use hmm_range_fault_unlocked_timeout()
 for range population
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
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:16:44 -0700
Message-ID: <178413940486.1155966.10368807598827608499.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

aie2_populate_range() takes mmap_read_lock() only around hmm_range_fault().
It also open-codes the mmu interval sequence setup before each HMM walk and
retries -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes mapp->range.notifier_seq for its internal
retries, so the driver only needs to call the helper and then validate the
sequence before marking the mapping populated.

Pass HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM
population attempt. This scopes the timeout to repeated HMM notifier
retries while preserving the existing outer loop that moves between invalid
mappings and restarts when the interval is invalidated before the driver
updates its mapping state.

Keep returning -ETIME when the HMM retry budget expires, matching the
driver's existing timeout error convention.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/accel/amdxdna/aie2_ctx.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 54486960cbf5..b5b4ca263002 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -1034,7 +1034,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	bool found;
 	int ret;
 
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 again:
 	found = false;
 	down_write(&xdna->notifier_lock);
@@ -1061,24 +1061,9 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 		return -EFAULT;
 	}
 
-	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
-	mmap_read_lock(mm);
-	ret = hmm_range_fault(&mapp->range);
-	mmap_read_unlock(mm);
-	if (ret) {
-		if (time_after(jiffies, timeout)) {
-			ret = -ETIME;
-			goto put_mm;
-		}
-
-		if (ret == -EBUSY) {
-			amdxdna_umap_put(mapp);
-			mmput(mm);
-			goto again;
-		}
-
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range, timeout);
+	if (ret)
 		goto put_mm;
-	}
 
 	down_write(&xdna->notifier_lock);
 	if (mmu_interval_read_retry(&mapp->notifier, mapp->range.notifier_seq)) {
@@ -1096,7 +1081,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 put_mm:
 	amdxdna_umap_put(mapp);
 	mmput(mm);
-	return ret;
+	return ret == -EBUSY ? -ETIME : ret;
 }
 
 int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq)


