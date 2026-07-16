Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1E3429020
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208243; cv=none; b=Y3GXNKLPe8ollwfAtZlB2dx0N/CPK7oI0mW4PN+688xuu1Rx0vRoelEnrAJ+NFT4agk6zzmKtOKMjUAb7EkW2fvnx9Rlz+h1bJCTsAWo3G57cJxyF3o2N8+qvV5njevx1YB/pN4ne7zXQtwSRVjnK2PzbGevmbF5dbHyxkMRYno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208243; c=relaxed/simple;
	bh=2JgBpAWc31ZSpkYiSaZDvjmnHKEA4A5V63g6j0fsopU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVDV2z5tqtfLCCfjvwj/oo9WZIRku7d78UqyAZ68PCdYkYdnU+VtVa62BbLR+I/TZ0mN8t4dFuviSq4uycC6oO5iBWaN7fJbgy2V9WyLV4yLDhIy41xPVW/Sv5IRrgTI5DazkF0a/RWsb7ES5dm1rW6VZ/aGJY05ikCKtRLFpfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=z3W7Q/Vp; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="z3W7Q/Vp"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493f25d47dcso19485845e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 06:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208239; x=1784813039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jsn8I3x6C8T9FLWqok7MXQBFznxd0+GMkoGzBjmbnHQ=;
        b=z3W7Q/Vp0l1NU8deNMLBoNbWyYcuLSpHkGAkibaFWx+4p5jEFFZ1wg3/PeOwjquSrJ
         sG7/2NBJZ5Nb3jRXFFnRU9GOGQb3igJw5xW32mJkvID9oA/m5S2Nqb68z9FBTAgmeHXu
         C0LIrMOGkrRSBK8h0FKbm3uBJ7+UnaKSSidEnSMUbdDE7TYfwFQFfIHVssaQMAkuzHsx
         djL8B02CPgRwTlxHvbaAlVARHmjE+8X+af8JYFk1NOPbG0Psv9FNgDpinZEKCjP06S3/
         cN5efKRCLZyH+IDqW+lkn/BoBP6otHCF7S/lk4FepSBtK4mllHKdFLEOQfAQt5TgKepd
         9aIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208239; x=1784813039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jsn8I3x6C8T9FLWqok7MXQBFznxd0+GMkoGzBjmbnHQ=;
        b=jEe9DbDPkO9biSWqs6Nov24k2peVtkpKgQuQaporxdnlKU0C9r5xYl+osAA7bGQmgg
         Wc9dm8DWCV+PrYA8iiGxJKs6Aw9ujo57hat1vfgYNOL18qkkKFCj5aTEL7QkKmGG49t5
         ywQr9m4fBO12GuxXA07Zbrw3toGl6eWVMBTOJ1GCirfVvUVw8TBrE6aOJhtpnOt5N5Uh
         pkqWwoF6QKuo/WauquDXaE4Mgh+EUPTS+kPe9UT1sgr1dgL85gVitP9CJ4/XbRebBwIc
         iM0UpAsAp5HEZexhiHocK/rjlaS8jRyX51rc8HeRr8otd6/Mk8DBQcP0fm9JzSh0+VZ4
         AY9w==
X-Gm-Message-State: AOJu0Yyak1g1SKGNwT+My2pvoOpZwq2TFnrHGFVEKEyb2vLUPIusOQch
	641nZfzkHaXXzJxUD26pAgpCTCZF/HpMz6UTXl44HYEAGUpaG9RsqWPIpA9GgmuAZR5bByVVSyc
	tPHmL
X-Gm-Gg: AfdE7ckplrPcjvv5kstOh74X5LdLAghe5swrZIamrCa+opbOU9AMdNLq6rvy9xUjJ4x
	JobC1zpDRvzEyMJY3Tyrh2H4xJrIy4RNOtkGfrgCQK0CN7PcR2bc/lMPeUS/dmPQlq2OoRzXV0I
	YsHYr3eMEgoKcBKGy/6Urm/yV/ngyqHPoBX/16x4AnMhQgG6Sd2E9LgavXUqOTnEQ/85AsuCJ6I
	pr+cBSz5jbE7X4Fr742w9Z/9gkbGSOQoxiTZOb3w816XK95MCY2MjqICTRqrorRpV8bLLM+DWw2
	62RmqndhwuFbmIRj8fA1jVQqQcv7hFf+bkA+lfr4ivULvOTNJ/iosDiAypuMG9eMspvmyBx1Iln
	3EsTntPYSELy0+qSF0KVPrAfAmfvNquKCmk/wnZtT8ju8VJDQnc4HOKuJY9r2sHGLVHJGzdOlN+
	r55reQwvrqhgA=
X-Received: by 2002:a05:600c:6089:b0:493:b7cb:c5f with SMTP id 5b1f17b1804b1-493fa8afbb6mr218943975e9.11.1784208239547;
        Thu, 16 Jul 2026 06:23:59 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e8c47esm60892495e9.8.2026.07.16.06.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:59 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	parav@nvidia.com,
	mbloch@nvidia.com,
	cmeiohas@nvidia.com,
	roman.gushchin@linux.dev,
	bvanassche@acm.org,
	zyjzyj2000@gmail.com,
	shuah@kernel.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	yanjun.zhu@linux.dev,
	cui.tao@linux.dev
Subject: [PATCH rdma-next v3 10/14] RDMA/core: Document the SELinux ibendport net namespace limitation
Date: Thu, 16 Jul 2026 15:23:11 +0200
Message-ID: <20260716132316.1495242-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716132316.1495242-1-jiri@resnulli.us>
References: <20260716132316.1495242-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Document that SELinux ibendport labels use a global (device name, port)
key, so same-named RDMA devices in different net namespaces share a label.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/security.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 9af31d1d9d70..a82c46965416 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -700,6 +700,12 @@ int ib_mad_agent_security_setup(struct ib_mad_agent *agent,
 	if (qp_type != IB_QPT_SMI)
 		return 0;
 
+	/*
+	 * SELinux labels an endport by (device name, port) from a global
+	 * policy. If devices in different net namespaces share a name, they get
+	 * the same label; distinguishing them would need net namespace support
+	 * in the policy language and tooling.
+	 */
 	spin_lock(&mad_agent_list_lock);
 	ret = security_ib_endport_manage_subnet(agent->security,
 						dev_name(&agent->device->dev),
-- 
2.54.0

