Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8503D3D03
	for <linux-rdma@vger.kernel.org>; Mon, 15 Jun 2026 08:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781513467; cv=none; b=LUYMSucsUxRCb8zgTRru/4D9X+GN0b7y0O0Eeo0g8srrhXzNqOntXzlfmRH8oYssOyu4X6/2gWgxuIxJMCEKMQSiGjW8h2lo2Gf60eEEGl+g0CrhEvUW1ledalZRCO0GPkqgjSm5aLbviCCGFVbik1fMNj9MJdUxxqlcmvshmVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781513467; c=relaxed/simple;
	bh=fSWKEgU3IuMWBnORTJHX/WCB4YHnbX+OemLa/TXuhxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imiRh2pZyT+QI2YWwjjDoyHYAO5XCu+i4RjxIhOdIqdBd8DgFr4zuey7xInvo8DQBDaZnL4C87/7FDBbtE64QUaBzewknU1H+Q3gBacx1qi309UKIk2/Q1vceJcLe4r23971mOlW+4U68zHNwzzMR6tucfdE+pqXhjYmZtTQVm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=zrUfsqms; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="zrUfsqms"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490ac10e337so20840845e9.3
        for <linux-rdma@vger.kernel.org>; Mon, 15 Jun 2026 01:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1781513462; x=1782118262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbLTLyKBLugmOPG2x80Vx9uMy8Frzlob/PKD2OJV07Y=;
        b=zrUfsqmsDuD+j3CvvyuDTXvJQXbwa8AHA7pQDV73DdorWWYsKYhyyT8wgzsR66y+LN
         AFwWqQuZ24bgJnCAtq2gU5o8hJNoswXPcwd6ZMeUkWMzRSc3DHYpRlvc11enjMvi7mWT
         2xsJGWZC6fQWgWB5tF44XkbAeWHb3rgixXffTHLFmwd00mvLwU3zjKp+PDDDo/LBHTUx
         9nNOL8h4qCbU/LWuEbJDGHYY3pJqWdLT/2KsAozFqrmyAlr2wvDsi9ChXZ1Z1hxFD283
         aKfjiYs7Tu6sj3J6gZ3ACjJdtXuD2LKOoqE9SOtajJocCpl+awJ/6F1thVXagCJR51PK
         p3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781513462; x=1782118262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mbLTLyKBLugmOPG2x80Vx9uMy8Frzlob/PKD2OJV07Y=;
        b=lu83zTBsmnWwD9fVjbaWzRCwKn5A0WeemnvMUT8hzC/IeTI2+2RxuxkELzUyWuLsIg
         t50MfeDB4xfr7dMFlE7HHbedxj9yV/x6OCuolWNRhoaxSgsAJTKCxrJScSa0cOJ2K0dh
         g9Qp+whx7UqJ77kWXViP0EzLAa7sHcscsunrgik6yqign2ZTVPgG3PYPIZ5QOnDOZ5TK
         gBIbcXN0CWgRsCao7HIzv3iUBp+Il7fKATwX6+3oX1RBGWBZxRKO6xop+7r99yGEapxF
         QHSefYMjyOnuzybuEKISDepdfWDMqDV1VAPs9vLaY8WEvyS3MTqi1OGcFUkDkP2nYfT5
         rhWQ==
X-Gm-Message-State: AOJu0Yzu5mM1YoZgIVvn8WnysQr8nZr0kf58V59+WVv+zowcKeyVPcME
	V8SIb8pdhClmMzM7TPcFdJS8w/VV3gp/rt69pDECfPtqHmkj3eDu0U5oUHJgKHiunHcxnzxieiY
	5JAZ1
X-Gm-Gg: Acq92OFzW31DznzueFtn6H7+Bo17NTw3d7bI19zs2YB0d0tChUlEVQEv6T2w8Q3sMsH
	KfOl/TpTmmVC+SjzecCq+CmvthqZAE2aCKeWfDu9WulgkhoBLmS+WEug+iMyxBvLcazrkXhZ900
	pGa/6tPcDS70Jr6I6g5yYaCSNdPgucN4zWfoKIJtnVO9lioVfsgpIoWN4UBVcgr+jiTmaNXv/Yc
	oJWugl3hMcrtxV4uQu5CsmeXbabxNnqASpXZ7eqomcry7UlRUG3LePPXyIW8i4B8dFaNn+Lt+Zv
	3ChFsIjDbFlscIxGg3VVwzqqi4uCl9PVfx5TJuFRYZ2Jo0uy0x/Im/LfI2DC/8CY1GEOEBMYGQh
	bpJWDGgpkAIpPaXZk/+PexTrKAlVUhXq9ZmKGzt1x72u7QNsHJHWpI2Sin1OG25FnXkqY4wEKiI
	zFI9ACWyCDM4y8ortkNfF0fBWfhLEakL4I
X-Received: by 2002:a05:600c:5252:b0:490:c6c2:bdc2 with SMTP id 5b1f17b1804b1-49220051650mr127320615e9.4.1781513462057;
        Mon, 15 Jun 2026 01:51:02 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95c51dsm224563285e9.1.2026.06.15.01.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 01:51:01 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	mrgolin@amazon.com
Subject: [PATCH rdma-next v2 5/6] RDMA/uverbs: Add CQ resize buffer UMEM attribute
Date: Mon, 15 Jun 2026 10:50:39 +0200
Message-ID: <20260615085040.1396623-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615085040.1396623-1-jiri@resnulli.us>
References: <20260615085040.1396623-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Add an optional UMEM attribute to the CQ resize method that backs the
resized CQ buffer, so userspace can supply it as either a VA or a
dma-buf through a single descriptor, consistent with the CQ and QP
create methods.

mlx5 is the only driver that pins a resized CQ buffer via umem; it maps
a single ucmd->buf_addr region through this attribute.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_cq.c | 2 ++
 include/uapi/rdma/ib_user_ioctl_cmds.h        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_cq.c b/drivers/infiniband/core/uverbs_std_types_cq.c
index 4699747f4ad3..7904f8862018 100644
--- a/drivers/infiniband/core/uverbs_std_types_cq.c
+++ b/drivers/infiniband/core/uverbs_std_types_cq.c
@@ -266,6 +266,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_RESIZE_CQ_RESP_CQE,
 			    UVERBS_ATTR_TYPE(u32),
 			    UA_MANDATORY),
+	UVERBS_ATTR_UMEM(UVERBS_ATTR_RESIZE_CQ_BUF_UMEM,
+			 UA_OPTIONAL),
 	UVERBS_ATTR_UHW());
 
 DECLARE_UVERBS_NAMED_OBJECT(
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 5d2451a03a83..7cab5daefe63 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -129,6 +129,7 @@ enum uverbs_attrs_resize_cq_cmd_attr_ids {
 	UVERBS_ATTR_RESIZE_CQ_HANDLE,
 	UVERBS_ATTR_RESIZE_CQ_CQE,
 	UVERBS_ATTR_RESIZE_CQ_RESP_CQE,
+	UVERBS_ATTR_RESIZE_CQ_BUF_UMEM,
 };
 
 enum uverbs_attrs_create_flow_action_esp {
-- 
2.54.0

