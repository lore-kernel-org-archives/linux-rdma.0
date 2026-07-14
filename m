Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0847D927
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 14:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784039381; cv=none; b=fQNM2LzvZLoamB0CTUaD/+pYWCMMIQM2Wrux+WzoOINctelm0AIhBznCtAR75x0uMz7E/dROSkV2xTIYDZH9Jpoy0uVOlmiX6bzBb49cceATrUi15MvpNtbFa0Gl4HoQLNeZpb83X4JvejX9XaaG7HFip6GbariW/tW3l+l/kkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784039381; c=relaxed/simple;
	bh=fj0Q6ihUmYqKUkY8KaHXFWF5Aioa8BtTYy9MtuieBMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hX9TKHvqC+usMQIX7d7Ruk+LqMcYD8Mf2MfsXxIwRlEcFJaCOh5/vLTTXPyymRPe52Ho7K/rMme7hkFCwyjUnICsYqUAaBl1SzKNhvh03P9Mpxyzirtnx2My0tA55epWLJZQHf/jqjRxDzCUn+G1LWOAFRecU1hFFu8XPysyqsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=Rw5eW6pp; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="Rw5eW6pp"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4720f3bf164so529075f8f.1
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 07:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784039375; x=1784644175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q+RolV7SjzshTN5zqSzxTVIaSTGOodHrW0P7odUB/p4=;
        b=Rw5eW6ppmDIrndA6q1mBhiSrnWhnU2hXHfxl2KFtVK1zkFOxQ43DK6GNmKOJP0oX5q
         r3vwazSVBJXfppL7Hoi94Ew9DpoaJut7vGKVwOYJ8an9S2GM0nQ7Oe3jGQcJVXuqWiua
         P9pqV36DnvKqa+LewDRIhJTP2Qfnov4Trpk3SgB/Znf3aIF8a7Jb+Fft3Etng1+OQBG8
         nlajd3Mu024JqN050emv6K2zEa6bKNEL0URvLDxBJSz9kSUx1T2f51I0X3H0sB40oVht
         z7O38q89XSmUmFTTh3hg/YndietSfsrcqhAaQtd3sKVGd6Yzniz2akLTlCOK6RLGw8lW
         /4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784039375; x=1784644175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q+RolV7SjzshTN5zqSzxTVIaSTGOodHrW0P7odUB/p4=;
        b=KsuMVa27LNkqkTISObxcuUmouJjCy28QF14jOEXe7RkKF5duU/S6VNF4iQ+RmWnL1E
         KqvEjFkWL4Y1doMHQJ7NswtsdYybcNG8TL+8qEBUXnqRUH1NblcL2d7tC/o66Vv94ASP
         s2ZQROfsbLZwZUbXch/CFjjFYV55cg4FKIeqfx5TN1LsV90ntjS78vK2as6S8wHlcpjH
         hhGaF/rNsOur4f7u3mH8WCydfl+3DXXikLG768DepI3LQD09Vsm3hC019Y18Pc2QfZO5
         9HAe8/EKyf02MlSkAzsL2K4dPaLbtAl8b2v6doilKD8VvSQdGnth9KuqdtZutJrzVhTb
         aJ8Q==
X-Gm-Message-State: AOJu0YzW42m7AiHAkaewjmxMtWhXuYLSCTAAtDTNUWD28d8BECZVFLH0
	rIhq6OEisVKrv5Yiqm2idOhqdmCPVpVb6O7b6vgAlNxtp/+Qq4Tfa732aCmSfljMHM7Gxf9lZjz
	KAwKs
X-Gm-Gg: AfdE7ckxHri1bhSgAlDUzU0mOH6eFYD7EbnazdY6MKWMcCYEXaFeh1FKIeKdvqthl+S
	8T1bHibW8y7yPDzes6kl27g/kpGJWVdF+RQDOxFDxVpENDj/oX3qaO8uVvSjSqDYDeijBr+mYuv
	v5RNAOIq8vwlkdonz7QA/LClQep8Ev/7tZiax3zoIO5yi0BT8tQOXNvN/H1ve1IwFWsmLoNoHxy
	QD9TNwnsQ2P5lf5TE7FhujGTH/G3iEKDMhQjn7GL2LWx1rYFsJZl8MUaLD6J8F9Pvm7LOEb3DUW
	HlvE4NDey7kU5ZqVk5sWMY7piimd0SvfUD18ReJhTiAe61zjTJa2T7SmrLxPMwj2pN02V9NQbkL
	dqb6q6HT5YWMmXlFhVSulR1DlLJzGBk0cVlLCNBt2N4o1ohFhweI6R3fMcTukmYlEUCCB/Ca2T2
	c6PBKR4+ssk+ljvKi9mbEJWQ==
X-Received: by 2002:a05:6000:1866:b0:478:7019:e5ef with SMTP id ffacd0b85a97d-47ef6986d21mr22449614f8f.21.1784039374656;
        Tue, 14 Jul 2026 07:29:34 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c9cc3sm8626412f8f.35.2026.07.14.07.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 07:29:34 -0700 (PDT)
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
Subject: [PATCH rdma-next v2 01/14] RDMA/core: Pass the net namespace to the device name lookups
Date: Tue, 14 Jul 2026 16:29:14 +0200
Message-ID: <20260714142927.1298897-2-jiri@resnulli.us>
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

Prepare for per-netns RDMA device names by passing the target net
namespace through the name lookup and allocation helpers. Keep current
global uniqueness behaviour.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/device.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b8193e077a74..de610f52c9b2 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -351,7 +351,8 @@ void ib_device_put(struct ib_device *device)
 }
 EXPORT_SYMBOL(ib_device_put);
 
-static struct ib_device *__ib_device_get_by_name(const char *name)
+static struct ib_device *__ib_device_get_by_name(const char *name,
+						 const struct net *net)
 {
 	struct ib_device *device;
 	unsigned long index;
@@ -395,7 +396,7 @@ int ib_device_rename(struct ib_device *ibdev, const char *name)
 		return 0;
 	}
 
-	if (__ib_device_get_by_name(name)) {
+	if (__ib_device_get_by_name(name, rdma_dev_net(ibdev))) {
 		up_write(&devices_rwsem);
 		return -EEXIST;
 	}
@@ -435,7 +436,8 @@ int ib_device_set_dim(struct ib_device *ibdev, u8 use_dim)
 	return 0;
 }
 
-static int alloc_name(struct ib_device *ibdev, const char *name)
+/* Pick a free index for the '%d' style @name pattern. */
+static int alloc_name_id(struct net *net, const char *name)
 {
 	struct ib_device *device;
 	unsigned long index;
@@ -462,15 +464,22 @@ static int alloc_name(struct ib_device *ibdev, const char *name)
 	}
 
 	rc = ida_alloc(&inuse, GFP_KERNEL);
-	if (rc < 0)
-		goto out;
-
-	rc = dev_set_name(&ibdev->dev, name, rc);
 out:
 	ida_destroy(&inuse);
 	return rc;
 }
 
+static int alloc_name(struct ib_device *ibdev, const char *name)
+{
+	int id;
+
+	id = alloc_name_id(rdma_dev_net(ibdev), name);
+	if (id < 0)
+		return id;
+
+	return dev_set_name(&ibdev->dev, name, id);
+}
+
 static void ib_device_release(struct device *device)
 {
 	struct ib_device *dev = container_of(device, struct ib_device, dev);
@@ -1223,7 +1232,8 @@ static int assign_name(struct ib_device *device, const char *name)
 	if (ret)
 		goto out;
 
-	if (__ib_device_get_by_name(dev_name(&device->dev))) {
+	if (__ib_device_get_by_name(dev_name(&device->dev),
+				    rdma_dev_net(device))) {
 		ret = -ENFILE;
 		goto out;
 	}
-- 
2.54.0

