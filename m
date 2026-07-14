Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E462047ECE0
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784039398; cv=none; b=KIbXLo6BnBG6ldK1xj4/QO+atCeYYPiBphadC2RqrlPnhvtDKy/p7u8zlpe8ks3hCp9M+AapNJiIF3Bx5FzRALX/VwYhRSw/nxpDNIzeFP7ZOP0DqAUzhZvr3DAITj4rZo11+YJKzTDHiWHhIaHhOIqcU7H6OmEjYzpAzrlW1WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784039398; c=relaxed/simple;
	bh=pdMmpZJCv+StAJxQjGBnq4nulDEDCbuKp7xLyLbTHHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nt7P+kBjazhB1y3T0izB5yTRYlIwgP/QtX/StnmdIzJgb6CiE9vSFruJfsx0iSqYZ8dF5qj2siladCydPPLNq5DKR02fNu5gEHbxo7a5cEDQoZu/fh6KjL5J+73U8vb0b0N3Ptqex9psv07/yniMSksrwFQf4redW7AcvJNYxwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=Vo32TBRC; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="Vo32TBRC"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47defd0c1c5so806726f8f.3
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 07:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784039395; x=1784644195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NfMuLF2nfHbgRgmO34SL3Jj6SviYlx2uzsjm64OYl7Y=;
        b=Vo32TBRCF2/LvT29lPbpGRO7VepZBr6VenCK+29LGopNgQn4isFdvtLYoBoIkKvvFL
         aVcS+jeetq7g32zM0XbvS/13wfmHfFWtZGvI0rBWyKCWciCpwGpHll/XvdvDmk4UXFIr
         FXIfwC4N47DJOaPCOH2A9Zel69WVGK7sOLpI6u5e4SxuRZhnOoeMQfKJCPmDiRAKgL/t
         7wuRd6l3M7wa8wvYBUKKty7z928MQ7750NP9SXWK2EU0dZksirt2W/KaLV64N2KNs8/Q
         4JXUlW6HDYJDP4JpWIHG2nkI9WFvtTRko5toaElx2DrpfLbbKs4EQN+NQfls7OSFWI+d
         DZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784039395; x=1784644195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NfMuLF2nfHbgRgmO34SL3Jj6SviYlx2uzsjm64OYl7Y=;
        b=DP0yT64G7JylnA3mp1IAmp2MHP1/YXiJu9FKkkKf2XhyJWX20mHdaH8DZS+DC+R3oD
         MbpCk8jYcbI1lKOkJ/VrIKfqGJMzgIJA4DAhVP1OtUdWtaO2FwdbOuXbrIoqQuHT3hWn
         q2gVNTHemiiizATSu7YMRdDTiAi3o3E4wStn9J/cplnZMTmVg+ByQOO3/BnoGmUN92W8
         GpIfyC9MIZCeG+rHkLahhLtw7kZXGsnD6tM8agvoStvW4qtGrrGwnghXAyGETURSfwrG
         ems7D5wncBOmtUatePT1PLiyXslyEeQXBrO39PmVWa7AmKj0jGcyAh0Vn9xqM51wgwwi
         e9CQ==
X-Gm-Message-State: AOJu0Yx7r7VkDEkCjFtjby4VykDf2R2aAjP0gCIXClCnVBY8DJ2+ydHM
	4U40VFf+TVrwI53KsBgIPI1s8OsIiHrdiHwaWtlKluJHy/UnqBch9VJn7gV+6X80VV7V6WJJJ3i
	vbL/X
X-Gm-Gg: AfdE7cmpsqAKAtxLG1DA7tZdDQ4oTkFE5hOi5yKi/f/FqK7lWGcYpmkDUEgudx8C2AY
	xdX4OiFinHpzC1EkNbx5AcftVHCO06Gr8BCPE7xJ/K7iwagEAcQijRrS4Wu2BEQ7gjO86uhYcPX
	qQ6yiI7vplajryglQbFElUKim8MkAdO0OGqKpx/LvjSg4BHY7y1rO8aM75dAuE63bOSDksnfcni
	GNdudwvlErLZ+CG4QVwoNjlNVgOgTwtsjwDP1Va5BX1H5cYA3UB776cs91TmWiy56LH6EczoWKA
	C+T2Qs1HZxS0cIfoQo4DDbqwpmPGSkLeXuu23fQ+shOzHByVN1LZ4faWu3TQbz1ukZDFllk64RT
	S78LWPa+khVHs3JEZmzLbclhJ19/wtLIEY0LaZvoCHP65LTCnbNXdkkvxhgW/RdINfbefFojn9C
	N4+vbh6Z7dHdgRH8YYv9LTwLnFwHbIN5ad
X-Received: by 2002:a05:600c:1d18:b0:493:b750:bd20 with SMTP id 5b1f17b1804b1-493f87e86bemr141687715e9.15.1784039395166;
        Tue, 14 Jul 2026 07:29:55 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a322c86sm71800745e9.11.2026.07.14.07.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 07:29:54 -0700 (PDT)
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
Subject: [PATCH rdma-next v2 06/14] net/smc: Look up the pnetid ib device within the net namespace
Date: Tue, 14 Jul 2026 16:29:19 +0200
Message-ID: <20260714142927.1298897-7-jiri@resnulli.us>
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

Scope smc_pnet_find_ib() to the caller's net namespace so pnetid setup
cannot bind to a same-named RDMA device from another namespace once names
become per-netns.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/smc/smc_pnet.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 63e286e2dfaa..ff9c9c35cc2f 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -304,13 +304,18 @@ static bool smc_pnetid_valid(const char *pnet_name, char *pnetid)
 	return true;
 }
 
-/* Find an infiniband device by a given name. The device might not exist. */
-static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)
+/*
+ * Find an infiniband device by a given name, restricted to the devices
+ * accessible from @net. The device might not exist.
+ */
+static struct smc_ib_device *smc_pnet_find_ib(struct net *net, char *ib_name)
 {
 	struct smc_ib_device *ibdev;
 
 	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
+		if (!rdma_dev_access_netns(ibdev->ibdev, net))
+			continue;
 		if (!strncmp(ibdev->ibdev->name, ib_name,
 			     sizeof(ibdev->ibdev->name)) ||
 		    (ibdev->ibdev->dev.parent &&
@@ -408,8 +413,8 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	return rc;
 }
 
-static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
-			   u8 ib_port, char *pnet_name)
+static int smc_pnet_add_ib(struct smc_pnettable *pnettable, struct net *net,
+			   char *ib_name, u8 ib_port, char *pnet_name)
 {
 	struct smc_pnetentry *tmp_pe, *new_pe;
 	struct smc_ib_device *ib_dev;
@@ -419,7 +424,7 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	bool new_ibdev;
 
 	/* try to apply the pnetid to active devices */
-	ib_dev = smc_pnet_find_ib(ib_name);
+	ib_dev = smc_pnet_find_ib(net, ib_name);
 	if (ib_dev) {
 		ibdev_applied = smc_pnet_apply_ib(ib_dev, ib_port, pnet_name);
 		if (ibdev_applied)
@@ -518,7 +523,7 @@ static int smc_pnet_enter(struct net *net, struct nlattr *tb[])
 			if (ibport < 1 || ibport > SMC_MAX_PORTS)
 				goto error;
 		}
-		rc = smc_pnet_add_ib(pnettable, string, ibport, pnet_name);
+		rc = smc_pnet_add_ib(pnettable, net, string, ibport, pnet_name);
 		if (!rc)
 			new_ibdev = true;
 		else if (rc != -EEXIST)
@@ -1170,6 +1175,9 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 	struct smc_net *sn;
 	int rc = -ENOENT;
 
+	if (!rdma_dev_access_netns(smcibdev->ibdev, &init_net))
+		return -ENOENT;
+
 	/* get pnettable for init namespace */
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
-- 
2.54.0

