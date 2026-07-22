Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1719943B3CC
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 21:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784756698; cv=none; b=oH8i+FSFDLlk+C+qWGz/mkPRjW7kQeigayFQIvm1wCwnU6mbo/HVpQm8eQby1ZrSrdfdwycNi7qFFhFguBnzVxUDoGIubC0Wkl/6RJrO0JK+IAcsOQMncWulBHDPcjjW5JXfpfDrpMaeNDm32E+CoM/fqnPC+2tr/DuTH2jK+lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784756698; c=relaxed/simple;
	bh=KaVy0LDD2WZ56zIlG4jDVljfxrz2j27JL0AnOSACkpk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=npuWi56j3qzIKT02eGM4tzvcPmwwZH0VLq2THtNERTxpudqPlBm7j2C+1QW0If/hJv4t8EoWFmHgYMljBIPBH6QmeFgLTHWqBDIh2QBiiGCtje1WrxJNzOMRq1Xgy2zf1WwwzlssMC5RrhBQctyO9VZ6pkK+NU929ftufUXwGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MjXGis/0; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjXGis/0"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84a2dcede83so12909350b3a.3
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 14:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756695; x=1785361495; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WVIK4CTS2ebWqFuX16f+6TzH9lK4l3CZHr+WHLsMqrs=;
        b=MjXGis/08C6P1DbvTDS6XJJiOLeKA3eQfTgRH93dbv1sJJCfHSRkL3aF/mNyyMkS+M
         2/bzui3U5K4koDZ1W+02OsJlccKvZw20haIwOpjsQL6hK4muM/KJT0lqRDPbyLUU18VR
         pm1Mgq7UGLlKE0DYF+SgPGFSWxgOKUnaQ85PNqqo5naqIWdQKyv4vHEXcrv87MBWVXKn
         zra+0ehpmUoykyEljanDVPzp3AfQRYC/c5nVsAoTFdRDqc+tF2ByiA7xh7hs5Dj0b0x1
         OEtwLJzVmH1UNoPWyOsX/CF+qI+idQQHhRLt2Svm9kDITmGxLhByKG6WSxAoISesyuHF
         es8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756695; x=1785361495;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WVIK4CTS2ebWqFuX16f+6TzH9lK4l3CZHr+WHLsMqrs=;
        b=rjLRdJgVnsupIl6BDevbeeKFrOk1kMTbcK8IOKk/IUMoACK94XscK+nWLr1Kem8vrJ
         RcQji5K+RIpL8r6PxBYP70CsxV1pNzEJ2iLiADS6w5sjf4EwMzejmyjw0afE19V1wbUD
         EMEQko+jbslQgFX1fhwIsnnY/nMvoo6UKC1Njw3DwNPOOI7z1Txi6ZXd8XOmaxVJm5hT
         CgsHdHKB5/+Vgrv7FcdlEbSQUG1EEMeFnvB5Iku2uOLgcnXne/BFGoLK83oZvUvOsknr
         DPlbfAcpx35/33Mn/H5Tfc4hfOcMowRgxJN74OcDgLmk7zZfZ+yMq/e2QUYUZvwLJeuz
         C+Pg==
X-Forwarded-Encrypted: i=1; AHgh+Ro2g1y8msX6/dzeE3IDyXWr6susERHBNnaC9E7MPiF3ZglAO6N/j+RiXX0b8ADs5sgH7GHofiprMPii@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/jFHgyhA4B142I8C/Cnt8Ni6bfIWSs7qdO7tfIAgyWDTUScMr
	5UATmMDYTDr0Oa/wHQqd/MAbsr2V8WhmgDmQR9FiMQl46w5YSlNP2C1R
X-Gm-Gg: AR+sD11H5O6M7AoMyQPGOVIvDAiFlE8hPfM77vO4BRRtWvrnN/vWRW5P0n1RHDW+Lns
	WG/tuJsmkCvGZTRyBed/4EZGiDYdsUSuZgNQHJqPqsflbKCmHyxrufTmJqyI+Pn8Y6gff2pZLiO
	851JQDGMQwADGOauALvKfdfvVjEquGNgdC+5A6Is8Gm2aUn4EzzW3wsND7YLY6q/CSTLabmR54d
	tMUGGlk1feD0pXD/dr3ujm2DPQUaMkIKGpJR7kBokJNqa/7IwpyrHmivMx4E+2JZyl3sPAkZC2O
	UZEs1E+/DhnMZmHMKK+eRlpXWk7AS4b0TGx2V+MjO+HKkzIBzniAhLUSHwBdtuBbsB2FWlfX8RV
	ctlzQ5hjYcGJDGZVPQ2t2fgPiGk0/6B00DTx9RXuizXk4eDqjZ0oli3TkrueezuF3NuwnesrWPg
	OXpc0y92Rq9NqbP7k7DvLob4qSBj2Z5cMQnCGzTxf68DJu0/Ae
X-Received: by 2002:a05:6a00:852:b0:848:46ea:bbe7 with SMTP id d2e1a72fcca58-84e2bc6b5d6mr673956b3a.19.1784756695183;
        Wed, 22 Jul 2026 14:44:55 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:54 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:27 -0700
Subject: [PATCH v10 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-5-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
 Oded Gabbay <ogabbay@kernel.org>, skinsburskii@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=2163;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=KaVy0LDD2WZ56zIlG4jDVljfxrz2j27JL0AnOSACkpk=;
 b=uKgRFxKY7gMhEFoK0hHnwQl6N8UsouNcazo70jIAxend3BGPO0koGFjjGoE03g3KTWZd66DI6
 5tAsc5/qbDAAjPQ/pjqrtB3km5I7U9rctkdARaqcdzu58Lj+SzHd5bT
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=

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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index dcc92131488e..58735446d783 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -678,20 +678,22 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 	range.end = notifier->notifier.interval_tree.last + 1;
 
 	while (true) {
-		if (time_after(jiffies, timeout)) {
+		long remaining = timeout - jiffies;
+
+		/*
+		 * The HMM timeout only bounds retries while HMM is walking and
+		 * faulting the range. This fault is handled by a kernel worker,
+		 * so fatal signals from the faulting process cannot stop an
+		 * endless stream of invalidations here.
+		 */
+		if (time_after_eq(jiffies, timeout)) {
 			ret = -EBUSY;
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range, remaining);
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,

-- 
2.43.0

