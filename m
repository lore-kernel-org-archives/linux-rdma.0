Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC15424651
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208219; cv=none; b=o6JVeFRE+cr+bjCFmzovWCT0mZ5L6xjuPGgSdYZd0hywZXaUGM3xiRCK9XiTFePtwtqPwIgu95e0YsqiIdIcKhAdT6oXhQpqsYek05oVGkKFaK2gCzwR+x9cpJeeq7kXhQbgXEyarHLg+mrKOM/6SylUFJBmmowM5IFM+mnweiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208219; c=relaxed/simple;
	bh=DZOG7H+X305alvcfYyKRY+OmEfAdQKwMydMDvfsKbqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk2TsZ0mf6z7yTQBH/AftU/JQgfpImkXZMNeS7XOu+Oxmwe7SFZH54OuQF8yPzPXdMWYXi2un4xMfX6nUP78H9nkFAsd91FPtq5ugMaNi1FivIZ4mP4UWdcaMTEVFi3FbWHzejXHF5K5E6f378WHYd0QhRpoAGyQRNPXh7jtuCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=bN/WIsyc; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="bN/WIsyc"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493b1710405so36659675e9.2
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 06:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208215; x=1784813015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3hvdgg/J5f+MIG37tkYT96k3bKW9qtjOneXBYLVa18U=;
        b=bN/WIsycRyjenY8fmlziexThg5Td82HX0pUBuXFZEzB6+P5V2/GnigsN/2VjlHYcHY
         QbxXufmRDw+AyZyrA93fJmzFTg/vjmdEvzDhnLQpkvM4aV/S9SrpPr6vgkKb+rFJCEg/
         AXqv87EogTaFDe7AEwmg98hKhy6QYRad+MA+gjPUHEi+zpktyWYL7fxqCysyRpAKa37x
         bkTcxr/ZqQaHjltMnaQl3XIiTtZ8HBdFmPesjWwsjf+XqLDnOG4hJebnO+DJIKUajYoB
         agbABX/5B3Gld+tH4iL7AF20hbcrkIptHg4Cg/8H29z6nXYb01pXiIp1LNIwL77/Mudp
         ZEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208215; x=1784813015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3hvdgg/J5f+MIG37tkYT96k3bKW9qtjOneXBYLVa18U=;
        b=rXQ4WOjj8Bje3608p43tuJtw+hY+urTiiCTIDeG4yZwxm3IylnDpDdAsgclMq6ILZs
         h9d0hSGgsfgkcyuT2jtnhwdhXqbVr818wTohNiEWqTuALtyxU2m7kGU6zrF5E+g6a0sr
         Gdp3kMRGHA2FRRzKtf73NP0JwTqJVKVMe1DqWrQw+RlL0qRpRkZpNkQAxGxL+UDfaOhF
         NdcYBFqPsS9XRQYvkJC9fOSW0JDUX2Ek4mQgOgE53snwuTrKKfS2mgJ/dp6lwj5ZiE93
         ZuAjL8Fhr3vA2UJ4pRWdlvTIWLCsaIMEiD7jGl+EnOO9xdtsTV0OCe3VvmSjKf8zJpak
         HsEw==
X-Gm-Message-State: AOJu0YxclixZYYqrwgiEcYrb9LtAUOkd7YgFVV9RueBobCUCs569sppz
	sJBfS3DrjV/uSOM8Au4Sx4j1dtXaFq1R45LBH8vsA7Fcy9C2KF1w0lzSE36kE7Rn+wKTdrahyye
	1IzoA
X-Gm-Gg: AfdE7clYhPcB4h+dSgPHeKElyWzdKgcG0K4QL+mSwFhIn9EUKNJ3WNFQDi3HbSsQ4at
	Z9AhBiRZetphyb/zmeKpwkxumKGaghVK/Dqlq3iZa0a3dTo/rEk5DqP8QTP966QKRmAodSaZQ7Z
	9kusNcR8G0Xy6zNN2uxWXIK8rKGuKCJxu9jGUhnrCKDYjKYzBKs0BAVg0EYDRca3QeNl5GiYeaE
	w8QhuojJn2oxn38KzbPnutFGv/78B3dsfK3LiL/C/bNNd0lYpwCWQsDQK1hWY2lh97i8GtTF318
	Lm1fWnWEhWUh5u7+g3JeMC4oO8s08G6Lj2Q62kSgyFb0pl2eR/g/a3dyRx1ersZM9ImK9E0UPah
	7rcuFErb0j5D38XahnYnBIkU41wXU5zqHTKpiZkrrUMKS7mrP7rT/YChFrvReHxrUFsNUC7mHFj
	Yp4gij0j5Si+Y=
X-Received: by 2002:a05:600c:c87:b0:493:fd5b:2d5c with SMTP id 5b1f17b1804b1-49515904a8dmr140034755e9.22.1784208215371;
        Thu, 16 Jul 2026 06:23:35 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e8c41asm60535985e9.9.2026.07.16.06.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:34 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 04/14] RDMA/nldev: Report net namespace move errors through extack
Date: Thu, 16 Jul 2026 15:23:05 +0200
Message-ID: <20260716132316.1495242-5-jiri@resnulli.us>
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

Thread extack through the existing net namespace move helper and report the
main failure reasons from the core path. Keep the existing move UAPI shape
unchanged.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/core_priv.h |  3 ++-
 drivers/infiniband/core/device.c    | 24 ++++++++++++++++++++++--
 drivers/infiniband/core/nldev.c     |  6 ++----
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 3bd5bb7135a3..aaf330b0d333 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -356,7 +356,8 @@ void ib_port_unregister_client_groups(struct ib_device *ibdev, u32 port_num,
 				     const struct attribute_group **groups);
 
 int ib_device_set_netns_put(struct sk_buff *skb,
-			    struct ib_device *dev, u32 ns_fd, const char *name);
+			    struct ib_device *dev, u32 ns_fd, const char *name,
+			    struct netlink_ext_ack *extack);
 
 int rdma_nl_net_init(struct rdma_dev_net *rnet);
 void rdma_nl_net_exit(struct rdma_dev_net *rnet);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index c0b6613dba4c..366bd8463c07 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1871,18 +1871,22 @@ static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
 }
 
 int ib_device_set_netns_put(struct sk_buff *skb,
-			    struct ib_device *dev, u32 ns_fd, const char *name)
+			    struct ib_device *dev, u32 ns_fd, const char *name,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net;
 	int ret;
 
 	net = get_net_ns_by_fd(ns_fd);
 	if (IS_ERR(net)) {
+		NL_SET_ERR_MSG(extack, "Invalid target net namespace fd");
 		ret = PTR_ERR(net);
 		goto net_err;
 	}
 
 	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+		NL_SET_ERR_MSG(extack,
+			       "Missing CAP_NET_ADMIN in the target net namespace");
 		ret = -EPERM;
 		goto ns_err;
 	}
@@ -1893,6 +1897,10 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 	 */
 	if (net_eq(net, read_pnet(&dev->coredev.rdma_net))) {
 		ret = name ? ib_device_rename(dev, name) : 0;
+
+		if (ret == -EEXIST)
+			NL_SET_ERR_MSG(extack,
+				       "Device name already exists in the target net namespace");
 		goto ns_err;
 	}
 
@@ -1901,7 +1909,16 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 	 * changed and this cannot be blocked waiting for userspace to do
 	 * something, so disassociation is mandatory.
 	 */
-	if (!dev->ops.disassociate_ucontext || ib_devices_shared_netns) {
+	if (ib_devices_shared_netns) {
+		NL_SET_ERR_MSG(extack,
+			       "Cannot change net namespace of RDMA device in shared netns mode");
+		ret = -EOPNOTSUPP;
+		goto ns_err;
+	}
+
+	if (!dev->ops.disassociate_ucontext) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support namespace changes (no disassociate support)");
 		ret = -EOPNOTSUPP;
 		goto ns_err;
 	}
@@ -1911,6 +1928,9 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 	ret = rdma_dev_change_netns(dev, current->nsproxy->net_ns, net, name,
 				    NULL);
 	put_device(&dev->dev);
+	if (ret == -EEXIST)
+		NL_SET_ERR_MSG(extack,
+			       "Device name already exists in the target net namespace");
 
 	put_net(net);
 	return ret;
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 77a758080148..8648e95700bf 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1195,10 +1195,8 @@ static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		u32 ns_fd;
 
 		ns_fd = nla_get_u32(tb[RDMA_NLDEV_NET_NS_FD]);
-		err = ib_device_set_netns_put(skb, device, ns_fd, NULL);
-		if (err == -EEXIST)
-			NL_SET_ERR_MSG(extack,
-				       "Device name already exists in the target net namespace");
+		err = ib_device_set_netns_put(skb, device, ns_fd, NULL,
+					      extack);
 		goto put_done;
 	}
 
-- 
2.54.0

