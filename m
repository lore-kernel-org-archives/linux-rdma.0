Received: from mail-wm2-f2.google.com (mail-wm2-f2.google.com [74.125.225.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB52E3E3176
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 18:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792263050; cv=none; b=jFZfN8WNzdDsZZQxPOf/9yFeuW5gDZ03QUe7ODi8TZrqJrjdsFD/g6rlEbsFP0nZLzeQlIVhaERFpWhIF+N1dc/lhMoOXNhg7VQ+hqrDZmiltOt8/RXhMlijKFOQb55B9ZCckjQ9AfG6cK1ImxgxN7xRrFCG4ghsJwIe7DI3sW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792263050; c=relaxed/simple;
	bh=fhFh3Ys2uymSwdSZsLLJ544Yj6Gc1C9qBViPJtZ97+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S/HUIsMq4Xt1qq7FOLYlKZcn3+twMgKWNm5Fsj9gAJlBNUAobg0BF9l7kZOUg6T9L4UfN4Qm+pFQGaRb8wmyoOh0XGpM7sZv1HDKAha6pfB7vWTR82eE7cseH+3qSUjHlj7FMZQL0PXTyVAIzJr2mkvaQZ1OGpQTiOSIDGg4aio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2HqK98j; arc=none smtp.client-ip=74.125.225.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2HqK98j"
Received: by mail-wm2-f2.google.com with SMTP id 5b1f17b1804b1-4a1d047b661so2119875e9.1
        for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 11:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792263047; x=1792867847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FZ55wAQt+5C+2u2S6IrGGzVNApcVZRVgGwe/A996wyc=;
        b=K2HqK98jBKY8KxgbDdyBQWKagmkxZjUITuixnXp+CHKDUIpaJxeJoIFC4cGhMyqJpL
         xZzWA04wDDEGCcr03GD5RnJtBsfAJ+ptqOT+/AqyUKOr8TXSx57SfvVykhWw/lVcsbkZ
         2GbEtIodbrwqe8IPvMueYxhYZLljJVq1ool1mbx0ZD8qUqVgtWRWJ4cJZEcP6Cl5i2es
         zkO2ff7Q4LBVd5CAm4kt7m3yaeF/1nwPI8xx1CLp3FkB9+Ix8s5hUmy6aPKUeENHjTyt
         dji40FnmwdOowS2BCAMSaJAo2qcYrZ5G+LI5oRyc/KtVwxih1q6xfmJNy3CnUBH1OEd3
         dTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792263047; x=1792867847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FZ55wAQt+5C+2u2S6IrGGzVNApcVZRVgGwe/A996wyc=;
        b=cYmQX00cezJfr2GapHBwWg/BsYzmi3MrWFQ6I01sHTXZwZFBdxIxZvyU/KrTtvMOL/
         E4K3WO9gPs5xMXdEBsYOg+P1Oui9ykCP3FZI0BdbEbKhQpKIyjQgZPQ1NhZWyg+anCnf
         8urpeCWVt8rEiH7zLhEzAQ8rSXFC2NGfKShAd4YcPJKvI0zupC5+hwTrVbtDiTKgFPSA
         b2UABTg272xrPsihCnbX9jyGlXAZiniS7yXre3lRstzK82V21AjZLXzR0wlarTQRUzTp
         mresLsmfPAfF1YxQJC7GYK0PAvYymQZGH+U2BxfcDrkNdfILXLCkA9nKXXpabfHIJDpU
         7Fmg==
X-Gm-Message-State: AFq9FYI0KU0BvIX4KhhJxtbYC+B5vPYDJ3jeLwZryoaggSFVR8LuIPs1
	revKmF7IUzmr4eT77oT4GihYOzNlRQnozb81zZ1LKY+JzZD4kaYpE8BE
X-Gm-Gg: AYBFou1s3OvW52zqH6NYeIGT9vE3ocj/rlNyAcGcJRqThcNUSsbIWckvPZh4XP7/Xtj
	gSxRmF5KrtF8cypZ+Gl2nOjwyOFd1/4b1iTdzf36n0zxOJGtZJHBSaQl5OY4bWBpQIFxhtKZLVM
	7WxD46ZDi6Aro2LeUoOqOUkPuhDXOJWU2mtx2H0DLjK8ljDPcmpgky/iP3qbI/inoxsu+MOgHKV
	unRofCD/Iba+D3/ntd/+v8l6ynX9Yqh5FWQJK0WihhsRZfKmoxpTDe96hfGmrWH4q79TX6SFYzp
	/V8txVW7hHUNbxBN4Q2zkTHFqyPk10VMuN4cmjR0AxO4kCM/2aR3VfjzXYbZ/sLKuiuqt7mkk2D
	22EXi3dcoobhFT0hbmlYjBdER44EBUx/lpPntQTivMZQTLHXitHoQv34E5MlURb2cdb5URDdCNX
	LtKopiyzb/ucv9HJXqEAE18PAzxhXTskIeBiYYK6+yedYCI53Do9uVrYUnv05z4oiJPlYrPilQ6
	SYGCypk2TgL5w==
X-Received: by 2002:a05:600c:3550:b0:49f:ce78:356d with SMTP id 5b1f17b1804b1-4a1d7616454mr69387635e9.30.1792263046736;
        Sat, 17 Oct 2026 11:50:46 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.205.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1d28b698asm135972895e9.11.2026.10.17.11.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 11:50:46 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
Date: Sat, 17 Oct 2026 21:50:28 +0300
Message-ID: <20261017185028.1019445-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In flowinfo_read(), 'left' tracks the remaining space in the 512-byte
stack buffer 'buf', but it is initialized to 'count'.

Initialize 'left' to sizeof(buf) instead of 'count'.

Fixes: 9f637f793602 ("IB/usnic: Expose flows via debugfs")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
found by smatch:
- drivers/infiniband/hw/usnic/usnic_debugfs.c:85 flowinfo_read() error: scnprintf() 'ptr' too small (512 vs 1000000000)

 drivers/infiniband/hw/usnic/usnic_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index 10a8cd5ba076..ece7c6e71499 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -76,7 +76,7 @@ static ssize_t flowinfo_read(struct file *f, char __user *data,
 
 	qp_flow = f->private_data;
 	ptr = buf;
-	left = count;
+	left = sizeof(buf);
 
 	if (*ppos > 0)
 		return 0;
-- 
2.53.0

