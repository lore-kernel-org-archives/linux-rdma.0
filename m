Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4F13EEAE5
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 08:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788339164; cv=none; b=mAEfC+fKJBDicd2k2lhTYmMK2kjng4NZxX3A1J9ssALbmXb7eteLeuci+ZlMqqaohOdqwqmefhIlQfn02yfri9OyM58lQRrN2GGZrafNq8SSh1CH3Nx/bbdWGWyHDtDoZJLEK0f8dslKmk8bQjSbn0r2WsbVkpt2VaCO+QVDzQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788339164; c=relaxed/simple;
	bh=gUU55rnPa2yoR70v6DkK3q8d87edYW/3hRo7Mo58p2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZBJXAu1cAXpupQLBrZHCGk+WqC2mNGUOjwZYMO4hR6yyEh9D7DcNsig9bOUiX4JA/85umrCFbCrx69iMId3hp9W4r8ONY88a5sUDwU1RNa/zMV7I5GD3/OrJ4A5OiY4gRwK0jfOxuphRLyU7+TLhr22vi4W07C1TrcBhPm7sDH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jj7rrpzv; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jj7rrpzv"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-39675172593so767974a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 02 Sep 2026 01:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788339160; x=1788943960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v3FkXABhM9zrrvqkbDsCZIOIRL6LKHNZMT148w1DCsQ=;
        b=Jj7rrpzvvoretNux3pPV1vKkc8t39ml/4MZ8XMmHJ02nbc/x0aGL/i5nr6Xx/YPFYs
         2HKwUgZEeqwbvFXf0VbXuROzwMvALGGR7nVxUMpiMow+N7lztrCRvwppe9bOeVSgDT4r
         NUpnDkRM3Oh8Xa1wj5bzEdTXDGsPCnX/Q7f8UCAg+mck3h427DCuv2hWFL3IV1f44lEW
         tIGi92ACWLOAA0pmjzhB0n1MzkYcUQnLv0cRHGtyEdpEqn9msm8xkKVdJZc4q9onwIG7
         1QAhh9JyY9aVq3X4PJPKxCEmPP238jaMG8Z7H0MOsJ0hEm1V+ceWIkUmS1XV6Ue363VW
         8bcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788339160; x=1788943960;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v3FkXABhM9zrrvqkbDsCZIOIRL6LKHNZMT148w1DCsQ=;
        b=GMuUe6c9W5aDf3Chfg+RL9ANwDTfrHDP/48NrNWQMTeNhQyjB29/AFyd0Nt6uskGFr
         d+lo8BTtv/RcITKPqmK7RPNXRFqZHGS4e6orpztZiAhNNKc5l0mN7D2LKEYimVb1dHtA
         UpS8EsS5Abkxd1QxLdoNYIWlDdPHTv9bP0aX9y4j9uZI4+XHZ+5DvxtrqIQ5iU2k12jN
         OEpuYJXrUKFiNA8PBuWGdRUrFsq9HwgrWn0ujCBUGLt8MR4KI0eyzo6GVAQ25GY6gfK1
         TeMg/0bFmo8XR32eVfTt5SCLHJTmxwLL0ZwRXtBJVrRFn8HeZ9G68+25hB57c4R0gW8A
         gYMw==
X-Forwarded-Encrypted: i=1; AKwUvBx6p43FBKzXo1QWl5nLG/wkMnXqRcnAOGjNvgzHO5gVH+Lfe8pgSXgduxwLJ51jbZRMG0fMf6gbvelz@vger.kernel.org
X-Gm-Message-State: AFuF++noIeB5dNeO6fAVesYDY2a1g10fFTzdeaaaE5nvfZpP/VhFg4k+
	FWLc/F+vgUB0KeKS+fPlAhD+fxjgP3EIGeB0WRPUSnMhz4JLppFPHgxU
X-Gm-Gg: AYBFou2mKrPrzZPa1JS2Dpc5dswV7CXQwvFTvq1E+OomuL1+8s6r6rMOrZEcspDjyo2
	J0U6GoPC9U5pzEkZwuLd/WWPsWUG65YeyqLVCrWYkaxnrVLA6nsUw9XkHUGNaA1rrzAyURCVOED
	zFZshAxHaFschj2GtYw0sdlPGJSxZvycoSpnivx+dkrwN7fDJlybAjY3smxn+1CJEd8/dA9GfFD
	aWnVeI8/4kg1xceWOvBn/HqiigBvmPyFd8MTmXfrFbf8g+B6PH/zLEb5HHj2pJoTXMN9hv7J5Ab
	Mwlhb2ETbnrV3PDOp3soijNLIkTwLtOVFdB/2FJWlu7hldAP+ZWo7Ehg/Ru/6ExYCC27Z4Fll09
	oxFSj/2+QZeroTg0KjyFdvIUUKbibYXq2ppGHXi1nPF9FmOTBh0FmJym/lK9TcA8kkVsgEfkCPa
	LEMgQU9Y+IpVWMKZcDmMFxjI0/uvR5VDfjGWLs6hD3OWmljwlpJSIxyjs3j4qZkfU2XAIzXqDj9
	L/G
X-Received: by 2002:a17:90b:4d87:b0:398:e436:370 with SMTP id 98e67ed59e1d1-39aedf66692mr4193494a91.2.1788339160457;
        Wed, 02 Sep 2026 01:52:40 -0700 (PDT)
Received: from Default ([2409:40f4:1028:3142:b3d:c633:7dbd:1e80])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f079ee369sm4927157eec.7.2026.09.02.01.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 01:52:39 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: jgg@ziepe.ca
Cc: leon@kernel.org,
	kees@kernel.org,
	Tatyana.E.Nikolova@intel.com,
	roland@purestorage.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	larrystevenwise@gmail.com,
	pj.waskiewicz@solidfire.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	syzbot+bd317784d628820741b5@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()
Date: Wed,  2 Sep 2026 14:22:13 +0530
Message-ID: <20260902085213.145312-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iwpm_get_nlmsg_request() initializes refcount _after_ list_add_tail()
making it accessible to global list where another CPU can kref_get()
on nlmsg_request causing a refcount "addition on 0" bug. Fix this
by initializing kref _before_ list_add_tail() so refcount for
nlmsg_request can be incremented/decremented normally.

Reported-by: syzbot+bd317784d628820741b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd317784d628820741b5
Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
---
 drivers/infiniband/core/iwpm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 990cf928b32a..5d07c5756987 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -313,13 +313,13 @@ struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
 	nlmsg_request = kzalloc_obj(struct iwpm_nlmsg_request, gfp);
 	if (!nlmsg_request)
 		return NULL;
+	kref_init(&nlmsg_request->kref);
+	kref_get(&nlmsg_request->kref);
 
 	spin_lock_irqsave(&iwpm_nlmsg_req_lock, flags);
 	list_add_tail(&nlmsg_request->inprocess_list, &iwpm_nlmsg_req_list);
 	spin_unlock_irqrestore(&iwpm_nlmsg_req_lock, flags);
 
-	kref_init(&nlmsg_request->kref);
-	kref_get(&nlmsg_request->kref);
 	nlmsg_request->nlmsg_seq = nlmsg_seq;
 	nlmsg_request->nl_client = nl_client;
 	nlmsg_request->request_done = 0;
-- 
2.55.0

