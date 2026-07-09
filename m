Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B65402B96
	for <linux-rdma@vger.kernel.org>; Thu,  9 Jul 2026 09:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783590955; cv=none; b=aDB/7Mq+H4pZHNu/Dh2S90odSykCp0hCAAvSPwCVT5+3of8OC2r5sSaPIwRMmEz10cddDwE3H+bxD7mOkj65HfOCgZFe2MOMhYBxrSpNNMngfX7vNjIGFK106iIK1SV8a3y73KgGsJiIqUKu36T7EKzxjbESp+H6Wfzc/j1CQis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783590955; c=relaxed/simple;
	bh=K9CoRzGWe5Snmxtd8ymX7IyXAu1ar0x9Ob9wGfUGEBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muz9wRLaU6clfu1E0xhW+7qgHTZPa/mkmXffRpXPgwuHh7kqSLCI6pXh8gEEiOGTcnSVvJgnaKDNCM9BvFlhM4t+IOu17O75syr3sYeBx3XOESR8hcc9mQOHJmt6B4q25tnCCyoaXIvQSlLSFQA2nutuD7ohIES8HR8MKgd3J+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=CTHIOCmE; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="CTHIOCmE"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493c19bad03so15615725e9.2
        for <linux-rdma@vger.kernel.org>; Thu, 09 Jul 2026 02:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1783590952; x=1784195752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fNmk0bmqBHuWVqJOuS5xVAk5q96ZY6RqDhKX3ikJqio=;
        b=CTHIOCmEi9IrR73tFiRqc88ohe49m7aLkRMT3+zx6857ZhLioUfs8qKV5jS0R+fyZG
         O7u/tdfTbOR/a1hVWZC6NsB76+wUgI4HuXhLZ+LepMpYnca8JwaBYaOl6zqLFIqUQrUO
         IrsPnoOQvWN6rjsCjYdy2tA9e+aA7pVKxho+l1dbOfdQEFByCpDz8AvQc23KnlayLae+
         ZNIhmUxqiVUpLcuIlM0HWFubIm8c1aCzAjNH5SuXpLU59Pq50lzpYQipkrgwh1q+0CDA
         sKXq6uKcVMTZKCRXpnY0X94ip1CQ/yOSgUyHSeOOohU1CsJYcD4XAjRZTs2o1Ma5Q1bj
         k/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783590952; x=1784195752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fNmk0bmqBHuWVqJOuS5xVAk5q96ZY6RqDhKX3ikJqio=;
        b=l1P10AFO+E7l9menIjXw2YY5haN4G0n9wOKsvkdhn728ykcsbfj81LXR3iVpfY/Bly
         irIFNxUB9vOAV998RdncewBTHVkLs2xVYPM7p0LqCsQfPGZZ0peNjJ7Bd4yG0ju3D7oP
         ZGz6/Guhk/lb2tx/hhIs+RoQqXqyjh12fGYMHaZJdZWM28lg+wQuIUjoYdRpZvjMoEKp
         xRZaYs/PAIFxmqvDa+Sya10qCNXv/iEPf98vMmCUgULyfd6BxwqD9wU9et4QiwhrvjZF
         iyr4KQcZskCKfiBD6nhiJt4BKEodGDLMOmu7SV13iCdJvT/LBXZUrkEymQpHbADmhS0x
         CoBw==
X-Gm-Message-State: AOJu0YxtztbE5ma/CBFmVYfpc8kF9KiSIaUZQOSKMmvNzizQlkCcjDjU
	mTQkOb00RkKDiwOcUEwPTTiHap+uxWLfcfXKNwbSw0u6BpvCD/qZgaaXliScuRjQVM3saNuMK++
	Fl2nA
X-Gm-Gg: AfdE7clXffsuWA1iOHOcWFnDrhkk3xSkmSbTN6CeTq9mAQCvCO7aGRzyGUIlUsaDbjl
	QvIFq1HItlXTjRQANFbtdnMgzy/RyIRP81Tnlg8uuJ9C6gpcbWP1H0AUpcjHabi6ypX3765/mHr
	hhxIPP3ptdTvENoMnB1x6U7wmp932NpkokUqHeSWUMpR55vMriqABuiRCitgnbHbX4Bzm/lp6Ba
	Kgjb3GELtV2iKrQCEej2sPvHJ/QXAjcvyGKyD4Wpefe9wlC69JLGYH8jsVQPxis3HljfsGNhGFB
	FH3O2olg+WB3TVCMn3MpLTND0j9es+56GYB8XhkE9u9W47PFrWeqmntDU/+P+rOU5QREXBIUp3F
	J5JRFQWfUMbfrziDaCEeOnkHz88xfoLRQoHuv7pAp6bOhqlC8DyUEf8C0NpwWRBlQ52LH7XsD8A
	gn89X9D1KDJLesONZwnHPtwg==
X-Received: by 2002:a05:600c:630a:b0:493:c84c:2b57 with SMTP id 5b1f17b1804b1-493e686c848mr60622675e9.29.1783590952129;
        Thu, 09 Jul 2026 02:55:52 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e5a5d174sm148952445e9.2.2026.07.09.02.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 02:55:51 -0700 (PDT)
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
	wenjia@linux.ibm.com
Subject: [PATCH rdma-next 05/13] RDMA/nldev: Allow setting the device name while changing net namespace
Date: Thu,  9 Jul 2026 11:55:24 +0200
Message-ID: <20260709095532.855647-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709095532.855647-1-jiri@resnulli.us>
References: <20260709095532.855647-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Accept RDMA_NLDEV_ATTR_DEV_NAME together with RDMA_NLDEV_NET_NS_FD so a
netlink move can rename the device in the destination namespace. Keep the
name semantics aligned with the existing RDMA rename path.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/device.c |  6 ++++++
 drivers/infiniband/core/nldev.c  | 27 ++++++++++++++++++---------
 include/uapi/rdma/rdma_netlink.h |  5 ++++-
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 2391bc7c8d23..8705011fab66 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1901,6 +1901,9 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 		if (ret == -EEXIST)
 			NL_SET_ERR_MSG(extack,
 				       "Device name already exists in the target net namespace");
+		else if (ret == -EINVAL && name)
+			NL_SET_ERR_MSG(extack,
+				       "Unable to use requested device name in the target net namespace");
 		goto ns_err;
 	}
 
@@ -1931,6 +1934,9 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 	if (ret == -EEXIST)
 		NL_SET_ERR_MSG(extack,
 			       "Device name already exists in the target net namespace");
+	else if (ret == -EINVAL && name)
+		NL_SET_ERR_MSG(extack,
+			       "Unable to use requested device name in the target net namespace");
 
 	put_net(net);
 	return ret;
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 5fd1ef2c5050..473bf9667f83 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1177,6 +1177,24 @@ static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!device)
 		return -EINVAL;
 
+	if (tb[RDMA_NLDEV_NET_NS_FD]) {
+		char name[IB_DEVICE_NAME_MAX] = {};
+		u32 ns_fd;
+
+		if (tb[RDMA_NLDEV_ATTR_DEV_NAME]) {
+			nla_strscpy(name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
+				    IB_DEVICE_NAME_MAX);
+			if (strlen(name) == 0) {
+				err = -EINVAL;
+				goto done;
+			}
+		}
+		ns_fd = nla_get_u32(tb[RDMA_NLDEV_NET_NS_FD]);
+		err = ib_device_set_netns_put(skb, device, ns_fd,
+					      name[0] ? name : NULL, extack);
+		goto put_done;
+	}
+
 	if (tb[RDMA_NLDEV_ATTR_DEV_NAME]) {
 		char name[IB_DEVICE_NAME_MAX] = {};
 
@@ -1190,15 +1208,6 @@ static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto done;
 	}
 
-	if (tb[RDMA_NLDEV_NET_NS_FD]) {
-		u32 ns_fd;
-
-		ns_fd = nla_get_u32(tb[RDMA_NLDEV_NET_NS_FD]);
-		err = ib_device_set_netns_put(skb, device, ns_fd, NULL,
-					      extack);
-		goto put_done;
-	}
-
 	if (tb[RDMA_NLDEV_ATTR_DEV_DIM]) {
 		u8 use_dim;
 
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 3af946ecbac3..ee11c3bbbae2 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -516,7 +516,10 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_DEV_PROTOCOL,		/* string */
 
 	/*
-	 * File descriptor handle of the net namespace object
+	 * File descriptor handle of the net namespace object. May be combined
+	 * with RDMA_NLDEV_ATTR_DEV_NAME (a literal device name) to also rename
+	 * the device in the destination namespace; the move fails with -EEXIST
+	 * if that name is already taken there.
 	 */
 	RDMA_NLDEV_NET_NS_FD,			/* u32 */
 	/*
-- 
2.54.0

