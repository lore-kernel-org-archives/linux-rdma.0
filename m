Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAE447DFA9
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784039414; cv=none; b=bzrX5nLxavN3C2RWnj/OBawcOIdNdp3JVHDB+xkkKEqqzEaCRVZfo5WV/yeIEPueYkYfX+oJnEcsSnss7/0Y1UnpoM1RelCg3/WV5AbfWF+fDGX2MAexXRRQAZdYfFjGtvzbfczpwwikofi6UhronxKTa4/K8qyQCTbWzQ70rhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784039414; c=relaxed/simple;
	bh=2JgBpAWc31ZSpkYiSaZDvjmnHKEA4A5V63g6j0fsopU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7JG0Flvsg1awyWhV96ELeATrpc+XOqVUfH+a6jkBldh/vZGmIMyKz6ZVfhujlUW3C1B4MJLPctLziC5mbT1hDY322NZeOHocpPLmvOjR6Ty4OmvM+7tTx323y5NpcpF/Nx9T3UEWzd6hP02NrQZopgLp9COeiVjJ2OjX0BX52c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=tIplLQKz; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="tIplLQKz"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47de008b020so579531f8f.1
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 07:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784039409; x=1784644209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jsn8I3x6C8T9FLWqok7MXQBFznxd0+GMkoGzBjmbnHQ=;
        b=tIplLQKz7ETUgWcKFbHl0CWUrXenVkiXEyO3ng32niwGV71m/oIlqG0zutHaXUDmTn
         YXtlbK43Zle+QsSGZvahavbXjyKpupb2yhLdTwQbwyu+aE9aBLPKB3MzuH0tBTFbi0Fo
         w28wbfwUYeOoAbbs+DS1Ue++EkO7RQuVFmDxcSdN4t7lZTR1biPzQzSHco/so5vimC5y
         l0qcL1mvsChAugvRgeaMTPj6i43RpPrLaqRnILoJihFe1XIWbF0x3xz0Ge0wsW+I1E4d
         TGcE3lOQNqAJlhvSQ+hwOpokRo4GvE9inrTL/mcdyaB1TF1T59c/Ci8fOGj0LoYRID2V
         AgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784039409; x=1784644209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jsn8I3x6C8T9FLWqok7MXQBFznxd0+GMkoGzBjmbnHQ=;
        b=keNN0doJGyO2loUAuC/V8PW/uTWxgn3f5SrKeOAwgFOBd7cUK/xC3eCb9cHwySEytS
         T8JL5SUOjW2eGlm+6j9M4+70NCetc5iCHhdtd5oDJ8E4PlEssN1E2iQjhSKY/Mtqp8Mg
         FgA2xzpzH7yy4lGMlVB6KxGY98Ximi7D2MB3qmsb+rhY7B4am5E41CWaamSYbuxrBo4W
         pxR1kl7fak7XFXPqbCtJqsNXAgdv/gHYL/liubnbYtjT3I7EPX6lOvvIf3VEcoGXG4HI
         UAVmnoRNeazVsS/UMcYzweq93dWjI0Jq0Bxu3IvCaO4AWfxrxPAvMB4jjoAmz4cUHakN
         AOlQ==
X-Gm-Message-State: AOJu0YzS1//x+/Dhg0PhtYDxX/89LiCGkVSdZGPAzFkjJXkKuuDL2WdB
	TNvoDwXxkhWjKCaPfkHDtHWC4Px3ACMkuEgrNIEV4Fr2YsN9J78cpQZKhu1aiXC4JZ1LqIukBDr
	4/cW6
X-Gm-Gg: AfdE7cl9W56ZmBDuZyf/0GTCjpBzuYVldIBk/+hz/2gmaj2BuijqQu8fz2dUMe8Y4rS
	2grFZr8sOgioVlMkMXbmws/NDCaLK1bG6B5akSsuxKtgBXDuv0IkzrhIe2H1Lmm8A+O1UM7E0tu
	umvZQD7fxfh2pYFca11jtIff9loOHVRSM/DFb68ygYMKjLvn8RU0G6pXErhqXSF5+0poH2ytnP3
	Fo7bnYrhvHECa2Ix3hIIyU/Qamed2hJvs2cFkVLfTHbW5TmpaMdb9K8kV4cAnum+C2unirqXrpr
	pBSHiUbKMWPvmIKrkKp640GMq6qJEuGbNDbYdpZxIheGiBq26TDmH14BS55ftf1OrzX+rE9d8RQ
	HCMYj5GD7T2IvkxWBEgJBbG/zTZ+MbQTkF0UHHFAQDRis2MI/+oPYnTdtGhYejU+sxcYpmww9D7
	CwphKj3l2ih09b3sFeNsUrZQ==
X-Received: by 2002:a05:6000:480b:b0:46f:1b89:999 with SMTP id ffacd0b85a97d-47ef69910b9mr23198373f8f.30.1784039409490;
        Tue, 14 Jul 2026 07:30:09 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635082csm9292456f8f.7.2026.07.14.07.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 07:30:08 -0700 (PDT)
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
Subject: [PATCH rdma-next v2 10/14] RDMA/core: Document the SELinux ibendport net namespace limitation
Date: Tue, 14 Jul 2026 16:29:23 +0200
Message-ID: <20260714142927.1298897-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714142927.1298897-1-jiri@resnulli.us>
References: <20260714142927.1298897-1-jiri@resnulli.us>
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

