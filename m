Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3369F377AB4
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 22:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784067699; cv=none; b=sACdfWJw3R1DLmgZX2h1HoBflgBj82HBdpEsCaHorsvv125+lJsojamAdBWFUsbFKPHqfiIKxGysd7S+TGkbcvHqleMg2a1rcVX1Twrs6L1kQ+qntvzLdsHTyimAIzzdL4vjrnpLAP4R4LQpyC8LQE5MuFLRrerEXbHbulBV9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784067699; c=relaxed/simple;
	bh=yfrRBEA8+1jTOU/Ov53fj/3O/42x9krywkX8bMxjRO4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bunlJ4RhvTQZhAm/leO0j/OuxVdCSdhfwaUpcUMJMkqNzoK1NvgRWSne08GEfAiEqpDMpW7FkrhEhl6jp7D9u6GDKHJnU6026TYC5Ox7wZKzTdIMv1rvKLgr9i7cusH8c410aNDs8B4GRb0rI3yS/ECLSG5oD4QuRgiFhx8JFCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1iGNVTW; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1iGNVTW"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8487b7b4066so4753646b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 15:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784067697; x=1784672497; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=s/XP8nJGTiSx4jpNVu3XVkKeZD1kh7QswKhz9rXqGp8=;
        b=J1iGNVTWEe0KyQiu+5OStpLUutxVy8Gh9wWoQqtFoamqdxqxQgOIATZL8pqk99cj+b
         7l6aQCg6jdHL8gyDaVYC9sqCgYg/0R9/RHxBFnbBnExH2oQAbtjFZjJEBVoilbCdReTX
         DdAxpnjAGK4/gSJMJTtBTcQYK8tUgNVHu716ES7B65rFzOhchWzw30Ydk1AYvD4InDsk
         5wtJjKtyarYR2MA6ao6ruIK1W+IfJZYyql/phkA2JinAzCV0JLyzSyYr0jZuu8xUxDOo
         0ByrR1ob3xk3/w90uoAzs9o945rEBI0DraCcd99SGGqJdHlEe4A1fyXHtk4DA1qcBceV
         MXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784067697; x=1784672497;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s/XP8nJGTiSx4jpNVu3XVkKeZD1kh7QswKhz9rXqGp8=;
        b=Nv57EUqHMyJYb8vMUv/0ACLwRYPSlwsyU85mgW3aw0EkZzPW/WQQMhsyeEFo66EqQn
         BYPZtVdyAi+81rMXt9/0IwLld//bR1PpazQSikVtj3vyjUFoRKHpiZkm/GBtoZosSNV+
         qXE4kUlA+5i+5EaGJdoNNVlV3SFPbscLIJ98JT90BJn74MV6gEZjEADTincAMQpB64Uv
         /79tWrsC87DPqdMJCv71dA4G3aIGnDiHP25VydTiCQOwiou+pDy7F+Er1NYo0sG7PtLh
         sXx0PG0L/yV7pQaE1ILIIiB2et7fXlQkgHdMr0s/UcLPGgpC7dEkvYk13R8xM1UdgaeZ
         RCKA==
X-Forwarded-Encrypted: i=1; AHgh+Rpn5nwvF9sApGSYjkA45xTbYBIsc7bBgQmqgpG8AVqDHstq+ANBW2/W6s/Z4jQ/kyOKK97Jj/qS0vj6@vger.kernel.org
X-Gm-Message-State: AOJu0YwHACl3q9sbDZIn71lpI5ZBQmbqGKWXMevRcbnEuuVQSwEPI4pS
	OMitM4JAkYnmR4EJ0WLTZn/Cijp3yfgFFg4xStqoyT0rZPzsdXLtWB2q
X-Gm-Gg: AfdE7cmU4jkXjCVq/JwZMfy1tR99vBROyO1vDJCtOS9X/exmQou6WsSM0VrIWFgdaaN
	yxNgw0XNQMwvCNTNrB4YwzGevcMmszFSipkjOvMFUIwYOqRgTlNc/PdpFHjTE0nW3+SFQmNQnXM
	89LGA/5SBjbqcxHMLizw23XRctfGeMg1MBm58USqZBZVzJLT3+m/uzwvjQdnFIMvX1oNXLnTWY9
	ztc1cZ3RQreRutytTkK0a8ycOq877q61tXSUQ3YDj6b1I3/X50Ela5TjnRa4m8EvxlR7jg0pT3Q
	L9/qnF//8k9RN1WReqCJ1uY55vPMMnKWsD8vn+TJxlo3ieDX52rIgSwbN2u9hYjL98VJn9IldQw
	whMqWfjKLBRLo4N6D7xRmb0QRMjsRB7dQI350pEzy4CDFxBlK/K/vP+c+kundQWep8Mro6HwNHg
	maKCJOOpQpmlOxWMKCQoSmaJDPpQuCMCtwiq0WHwly5Ku5xpRgMw1dgPs2k7jgPJyEd36zRA==
X-Received: by 2002:a05:6a00:4b13:b0:847:8dec:141f with SMTP id d2e1a72fcca58-84a672ea3bfmr293017b3a.51.1784067697563;
        Tue, 14 Jul 2026 15:21:37 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f238f75sm2119769b3a.9.2026.07.14.15.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 15:21:37 -0700 (PDT)
Subject: [PATCH v2 2/4] fixup! drm/nouveau: use
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
Date: Tue, 14 Jul 2026 15:21:35 -0700
Message-ID: <178406769581.1106335.2090301352195900623.stgit@skinsburskii>
In-Reply-To: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
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
the HMM fault path. Pass the remaining SVM fault timeout into HMM as a
positive relative timeout instead of open-coding the HMM retry loop in
nouveau.

Keep the outer absolute timeout around nouveau's
mmu_interval_read_retry() loop. HMM's timeout only bounds retries while
HMM is walking and faulting the range. Once HMM returns successfully, a
continuous stream of mmu-notifier invalidations can still make
mmu_interval_read_retry() restart the operation. This path runs from the
GPU fault worker, so fatal signals for the faulting userspace task cannot
be relied on to break that outer loop.

Use time_after_eq() before the HMM call so the remaining timeout passed
to HMM is always positive. This preserves the old timeout behavior at the
expiry boundary and avoids passing 0, which means retry indefinitely, to
hmm_range_fault_unlocked_timeout().

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 4cfb6eb7c771..58735446d783 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -678,14 +678,20 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
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
 
-		ret = hmm_range_fault_unlocked_timeout(&range,
-						       max(timeout - jiffies,
-							   1L));
+		ret = hmm_range_fault_unlocked_timeout(&range, remaining);
 		if (ret)
 			goto out;
 


