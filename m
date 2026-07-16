Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FC6429811
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208246; cv=none; b=oX5V/FB8KxBdgIBXgoNC96pQ3ye7mpNZNE5v0VMv9ZKFdn5PSbKWXjBic852kzbA3CBonFqsJ7c5/aDO/7gU0nvOLNiDeVEfmryw7XfCsXOmh4l+vQesSByubwBEZ5v8eUy9l2um90eVl8WpRfPP03tngkVJ5oxbSywdlXMQWO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208246; c=relaxed/simple;
	bh=vXTVHC8jrIfunzmq69nH+ECf64rA25Ltg6ybB9/xSAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onTZeVrUt9UCMbvumurDMgWj0YDqOK9xNvbGAamS0nMCyjTjj5STOmX8eAQRtgbzqG7B6fjoNDd+LJBd+pdziFRN4SAeCjWO62QoVMr4pwTZ6tlgbvJdNufeIQUeVobui5s1foAMMSybRjg/bC0b2qCkguWKWXtwHAzGFJyTIEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=NzfYDzrK; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="NzfYDzrK"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so2919931f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 06:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208243; x=1784813043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=axmo6X45l643i+ylWNgoVG07bt+75yV7VClJ23IyRYM=;
        b=NzfYDzrKfSXlqHYGnyFriyPDXXHmWZnXqM3PJaM+mrg5B/59DlRpH3ATg42SaZ7dzL
         eQZmwnRJjOf1cEtLlg5xdM9adeUGLGllxQ4e/Bxgf29paRMVa4oSCZMrs0pOkytTuB79
         oSJfXyUwZVpDtuAibVMP4VArNjbSZy4QaZY8xWUbDdxz/nMzWiRCtN21i/Y1SqCz5+ZY
         AYUVBH+zbdkHrEul6F8SDXOiMZsehCLDPMN6ecBFfp0W5DYXda045AWrnDueMZ+QHIrm
         FdPJzPAJ1rqaAP6/IkULzbPLkp2zKcaPMKjdfuYUzM3xTjsv0Vu6J39LQuIrYsZpG3Vz
         6tjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208243; x=1784813043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=axmo6X45l643i+ylWNgoVG07bt+75yV7VClJ23IyRYM=;
        b=NQ1mDSa6Pozf0lpvMt8PwKcQ59vCYoI2rQVszIR0Glu86/oq1IBAsXyqQdaEcE9+Xx
         TNGQxyRiDYXKLVCKZPsCYfeExoQa7UeNXko88tVIIamy73J9MNX4BfpYvy3pO8gFhDFL
         W3jrxKMDLTKPkgmj3/3CV7egDqihWVqemkNm/vKf/2r4vRicveAvOy7B3wLkvTOQmJFU
         4biH40MPftzHIq40oPOROUq8RU8mx6AlSVRcTkbR+40+/K2XRUfEaD14CiI14N5ivtWO
         W3e04XlLGYZhd/VyI8Vmm+puU/a4Ckii0poITdNWeAy/fjLuKEEhcPleUqRu5VEWKSHJ
         OZlw==
X-Gm-Message-State: AOJu0YzpLZblizeTI59/TBmWgWvOhGG6dfReKs01mstp5qdxkroshJE2
	689cuvyJH5BNR5CNbn/0zxSFKIUsimnPavmvNXjIuDpipzfXd3pJSi5e7c5DhSB0iZK3/d8421O
	VsKYN
X-Gm-Gg: AfdE7cmBfkheL4xapyT/Dct2JB7HEKfLrSAHaow+uIBN4lJF3Kr6ZfcDEtl8vYKaabd
	VwqZX4tYoqsSCPDjS7bVq8JJIRuzK9AjlrRvEGUksffhV3XAj2r1haNynmzL0sO2YLqTqkIe4un
	sZ+fMZdRzyo7j739ZPAkbnoRuMSE4UOPDeTvzaqJSkYmf7KWxi8eDysqLzcOs6a+LQnSoV2SqwQ
	2x3S3HQ+o+3pYruf4SdWtWQlp/T4WTdF0G3gGF7x0yADz2S7/zslu0g+dubrpOH9PLeUkgVOvR3
	jC9ShSIrvA+bW/b/F6G6uco38ELNIfMVM6y2QZlpO+IdIhkMMGmiDifIMhctC0vEk+GGp4QLn1T
	QtEEeTDHnR9AYJvxQW2+dBTKZh2B6IWnzT+Y5izylSMSh5lgzbSn6agmAb1RCORuiK63XpO3qfg
	YXs4M5SOYUoV8=
X-Received: by 2002:a05:6000:27db:20b0:47f:5378:b6e1 with SMTP id ffacd0b85a97d-47f5378b75fmr4609976f8f.30.1784208243456;
        Thu, 16 Jul 2026 06:24:03 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a63esm24667399f8f.9.2026.07.16.06.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:24:02 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 11/14] RDMA/core: Make device names unique per net namespace
Date: Thu, 16 Jul 2026 15:23:12 +0200
Message-ID: <20260716132316.1495242-12-jiri@resnulli.us>
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

Use rdma_dev_access_netns() to scope RDMA device name lookup and "%d" name
allocation to the relevant net namespace. Keep shared mode and
CONFIG_NET_NS=n behaviour system-wide.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/device.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index bb02640239d7..4c75078448a3 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -129,7 +129,7 @@ static DECLARE_RWSEM(rdma_nets_rwsem);
 bool ib_devices_shared_netns = true;
 module_param_named(netns_mode, ib_devices_shared_netns, bool, 0444);
 MODULE_PARM_DESC(netns_mode,
-		 "Share device among net namespaces; default=1 (shared)");
+		 "Share device among net namespaces; default=1 (shared). In exclusive mode device names are unique per net namespace");
 /**
  * rdma_dev_access_netns() - Return whether an rdma device can be accessed
  *			     from a specified net namespace or not.
@@ -359,7 +359,8 @@ static struct ib_device *__ib_device_get_by_name(const char *name,
 	unsigned long index;
 
 	xa_for_each (&devices, index, device)
-		if (!strcmp(name, dev_name(&device->dev)))
+		if (rdma_dev_access_netns(device, net) &&
+		    !strcmp(name, dev_name(&device->dev)))
 			return device;
 
 	return NULL;
@@ -437,7 +438,11 @@ int ib_device_set_dim(struct ib_device *ibdev, u8 use_dim)
 	return 0;
 }
 
-/* Pick a free index for the '%d' style @name pattern. */
+/*
+ * Pick a free index for the '%d' style @name pattern within net namespace
+ * @net. Returns the index on success or a negative errno. The caller builds
+ * the final unique device name from the returned index.
+ */
 static int __alloc_name_id(struct net *net, const char *name,
 			   const struct ib_device *skip)
 {
@@ -452,7 +457,7 @@ static int __alloc_name_id(struct net *net, const char *name,
 	xa_for_each (&devices, index, device) {
 		char buf[IB_DEVICE_NAME_MAX];
 
-		if (device == skip)
+		if (device == skip || !rdma_dev_access_netns(device, net))
 			continue;
 		if (sscanf(dev_name(&device->dev), name, &i) != 1)
 			continue;
@@ -1233,7 +1238,8 @@ static __net_init int rdma_dev_init_net(struct net *net)
 }
 
 /*
- * Assign the unique string device name and the unique device index. This is
+ * Assign the unique string device name and the unique device index. The device
+ * name is unique within the net namespace the device is assigned to. This is
  * undone by ib_dealloc_device.
  */
 static int assign_name(struct ib_device *device, const char *name)
@@ -1416,8 +1422,9 @@ static void ib_device_notify_register(struct ib_device *device)
 /**
  * ib_register_device - Register an IB device with IB core
  * @device: Device to register
- * @name: unique string device name. This may include a '%' which will
- * 	  cause a unique index to be added to the passed device name.
+ * @name: device name, unique within the device's net namespace. This may
+ *	  include a '%' which will cause a unique index to be added to the
+ *	  passed device name.
  * @dma_device: pointer to a DMA-capable device. If %NULL, then the IB
  *	        device will be used. In this case the caller should fully
  *		setup the ibdev for DMA. This usually means using dma_virt_ops.
@@ -1708,6 +1715,7 @@ static bool rdma_dev_name_in_netns(struct ib_device *skip, struct net *net,
 
 	xa_for_each(&devices, index, device)
 		if (device != skip &&
+		    rdma_dev_access_netns(device, net) &&
 		    !strcmp(name, dev_name(&device->dev)))
 			return true;
 
-- 
2.54.0

