Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E56387346
	for <linux-rdma@vger.kernel.org>; Tue,  7 Jul 2026 19:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783453661; cv=none; b=LiQPPJx9Va5sXIeB8xrQYtN5SlqiCr12I4pBWg099VB329gQYJrAXOMl5wKGLXpoGraE24AtTcVjk0wDhnjOML/a8BRH+CggXWs8rCz2vK/N635JD756uLnqVDPqmu7Qv7IIaJ13j7WKuprHZBOvdMjBgjhJPOQYw3krnkY7S0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783453661; c=relaxed/simple;
	bh=cLajtPW0MZ2OaqGeLhMH9ovKQAc7UWeuKIBvIqrQFY0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MroQ85EaMIi3O1lXco0L7IXTJbf3CO27GUJv84hOev/0sWiM97qS4JojfJlPdBPGVshplt5WSCA6g4rgFkb5BvGCnEtuykn98AOUULt52SIREL8nhuJnYeh7QqKIzR0jzkX89kXV1g3rd2ZP4B0LXZdjHS4ef5lhppL95Pd68RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hohY8F+R; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hohY8F+R"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so417015ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 07 Jul 2026 12:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453659; x=1784058459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+Fuhl2eREcU7wQkONDn3KjcEE0Ws3TgFkFsQfjplBps=;
        b=hohY8F+RKdiRcr5Q02tTxf0dBC8c0szuQYsfv5idKDm8lYCkwpz30Ghaf/E6sTkP/p
         ke/KokGFkDR3b75JOLXFR+eLCb9O6I2ESkB98dSr8UfZJzUGiZHHc84GJnjMXT/QWfVt
         nAanhIPYJ7FHpoUpeJ3VWLdz+0nTVZdTYmcsbI+/8PWZJ/6CYg5JcixkuSLYUqmjNlUQ
         GnqJmirnjUDPEPQCzWkXsSmCmbzIUx/ha0onl/hx21eikU0ymBbnWjF9lJ4QYsojHiEM
         ldBNWjzPUEGQe9bxqSjYW4Mf8Zs1K8PZWScXqLIZirhFNH/cBBl8S8iBV0moF/PqR0c3
         2o7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453659; x=1784058459;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Fuhl2eREcU7wQkONDn3KjcEE0Ws3TgFkFsQfjplBps=;
        b=pyd2rAWZLJ5yPklLuQ54pIcRGPJxSyiiOEirYiAvIp6NOfakwRg6Y17tc9qZTbMNWD
         8CU5ZixZe1rpl+RJUWUYzhZQKy0NuD+H/ZWC6AUYG8wG9EUMytVQo836R8rqlrOEzwU+
         LR9Zucl7RY63SA9cnm2hAlcVE1wJL3VPg1CovoMMDK/R5nzi0oJUf4jKgNsZzTGkmhxn
         VNWkRoknNJVpBqAk+YxJHuOr93PCyxzFS3llUlSLbDbt22ntHAVPJ+frqaDSohSUyFZH
         3W3PKW8/Obnel+vflhyzBijabb7fE+MzVx/OWZXzqVtfLPYsma/FD1Aq3Y8Hk7aGXiho
         JOkg==
X-Forwarded-Encrypted: i=1; AHgh+Rot9M6huji9+Iq6t+A7lkXN5Smofw+PJ9hLBNV/HWhVGlmE5pJKY3M+II3ARCf4AuODXtYltD/urEoC@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0E3uk6gmKdy0iu2O7G0OVd534rtByGWccoFMRcN0vFD7RevVk
	XgyspqYpo2n9eU+F7k7KZaUvkWc7o68zNK8HT5GndqZGdXHm24PQZSmw
X-Gm-Gg: AfdE7cm+ixV+5PQUe7TCDbIGlWt8nanHesKd9ADqmVfHhmbYX7XSaad++D7+Wb4PSTd
	W+ubM9Nde8kPoZdMJLa8xEWj4cN49ptjy5HzQbH3cKgszrz9GpuENjW5gos4hFKRNXf+407359y
	LMA8Mxd/asv53asUd/mW4bvwWNew/3bMsFl1hzx4B31/Cvk6bQWLtiQRLMi1rdAuSNET1NP2Azs
	CDwzGKm4ZQxKb7yUur3SPFNu9Q6e40N/3J61rWTtYoAgIIJlAJ4P+PaH+seInKr3FJBXJc8yh6v
	qxg3RKWcFQuWVg2WY4Zx+U7UO8Dco88DDNmArUa9rhadzzjkhdu6e8PahPcrt8WR+QJlAzuEuRh
	UrtpZnHKNLJnrUlxrtBjRQ5t7jh9U1YtgKJccMvScU9ByhbLhmbINgTy8OU3AZnVFekHNSQ6pKT
	OFyfHF4qugYTzy6kq3FdrDMJzVR/D1pB3IdNtODz2oQNmJaOaUL4kpnEgTbsM=
X-Received: by 2002:a17:902:f68f:b0:2c0:e5ee:f554 with SMTP id d9443c01a7336-2ccbe40ee4cmr72069895ad.8.1783453658644;
        Tue, 07 Jul 2026 12:47:38 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1ea7fsm17015165ad.38.2026.07.07.12.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:38 -0700 (PDT)
Subject: [PATCH v7 7/8] accel/amdxdna: Use hmm_range_fault_unlocked_timeout()
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
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Tue, 07 Jul 2026 12:47:36 -0700
Message-ID: <178345365679.660027.16671418103486907555.stgit@skinsburskii>
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

aie2_populate_range() takes mmap_read_lock() only around hmm_range_fault().
It keeps a single HMM_RANGE_DEFAULT_TIMEOUT deadline for the populate pass
and retries -EBUSY until that deadline expires.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes mapp->range.notifier_seq for its internal
retries. Pass the remaining jiffies from the existing deadline to HMM,
while preserving the driver's existing outer loop for interval invalidation
retries and for selecting the next invalid mapping.

Keep returning -ETIME when the retry budget expires, matching the driver's
existing timeout error convention.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/accel/amdxdna/aie2_ctx.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index e9fbd8c14364..412f812d7c2c 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -1031,22 +1031,11 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 		return -EFAULT;
 	}
 
-	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
-	mmap_read_lock(mm);
-	ret = hmm_range_fault(&mapp->range);
-	mmap_read_unlock(mm);
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range,
+			max_t(long, timeout - jiffies, 1));
 	if (ret) {
-		if (time_after(jiffies, timeout)) {
+		if (ret == -EBUSY)
 			ret = -ETIME;
-			goto put_mm;
-		}
-
-		if (ret == -EBUSY) {
-			amdxdna_umap_put(mapp);
-			mmput(mm);
-			goto again;
-		}
-
 		goto put_mm;
 	}
 


