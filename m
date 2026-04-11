Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AA2387361
	for <linux-rdma@vger.kernel.org>; Sat, 11 Apr 2026 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775918977; cv=none; b=lNju6Z8FGpL5cdxucPvJGQg83c27BTzcp466bOPyqvWD7cHifxCwHJEYqWAVvw+pKIhFz5LwT+16KPa4KS8wStklG0WWEJ6o36AbAk6NfcOWKgZhsFrFNwxcABBRfs/3ub5SbP2WSWDkFf4UwuCwMVhhkjO9YIHUTn1FRVWxeWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775918977; c=relaxed/simple;
	bh=31TDGU9M8cRWEMIWQIBUszyFl+Ek1i3+NC6n5568EBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbHLI8L4f8ttDkxObcfITvDgypxzooR22vAhKKAvOC4NPHzZvedI1EAqy6kFUT5NdcOFm/7bpb9/gcONgcG2PEt8VbRd09d86ylujm3pmw5vcNVxC7BVt62NFPQvN2TDAZy5P0xG5DbLI0GlN7Q6Zqm0hFkBlV4f7SSnOfwljgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=lrq0PtMb; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="lrq0PtMb"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488aa77a06eso48989755e9.0
        for <linux-rdma@vger.kernel.org>; Sat, 11 Apr 2026 07:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1775918974; x=1776523774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZWMRnRdmBJ2dDfApWjzsRyX+wwdBVRUAXbkrjKVQdY=;
        b=lrq0PtMbh7LzxeGmpEiBhZ/DGafuf8LwHhcwpCd/jNBHgVC3Luc4NegECwrYCIRmMG
         +uNI1s76r/Y1vshGU1Gb7EiDqiwa9kblD772ml9hL9tBcg/c+44+WY3d4dl09mAVzmpS
         /QdCB3DR6HGQ4xCY+cjK8Qvpl8Bv055D/9FBD98kz6Dw2NyzmfiXtis/JzkkMZpXRRkg
         NFnmXRBwX/mGDltp15ggHfm85tWJTRtRTPUtL1cDJxgPnDSavqFRtUR14+EUKUe6OE4+
         bzXeiFknC4AXAWiFB4/Zre5CfAu6mmC+P9/8wylArpd5BVZxj6waoiXdjNH8qSAiiujB
         VlsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775918974; x=1776523774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WZWMRnRdmBJ2dDfApWjzsRyX+wwdBVRUAXbkrjKVQdY=;
        b=mgUoZxSN7Azjku4zn/NHwDWySexsur4THJ8Y9spkqmgdeA+3TixZ9L+B2d+azzU575
         SAnHOPIFrO4PLjr9ACh+mcDaMAv88cwYUxpMiRq/ctYJE1hdsOBZgSObvaoyTBWaAWKA
         8O8N148XQVilvOiuajyW0ws/Ob+RPiwoJjYWIHOZbxTzFgL/NBZ19Ici77LZ0yR9m2kz
         2INLj68WadJJNWKMPf6HEcJYoeBdZ5DgsH/4rRXZ31zwEO5Hw6aOoy8+QfdaO0pPUxL6
         IcukfSnqJ5hd08r39pKKxybFl/5pEqbROgQHtVIW+Ew5zyGDNtylq3FwpUUIUCM4wozw
         iExg==
X-Gm-Message-State: AOJu0Yy63mWEK6PAocfKTu9J9h03eAqBnUryWK/7KPxWUm2xnwDDRAmo
	kR6LqoKkx3cTKAlq5hLb6ySzGEpmC2RTBOalRIj7b/PCYfOk9DdzqlZD8Lo1USUpoAGm17mJF8n
	6YxS/
X-Gm-Gg: AeBDievSzajOqXQkNdb5Dn+cBMqDIZm6rc29tJZdg6i8mH7VOEKhKIVqbchtxS3zgy/
	NIeEZ59RQUckce8BI75qo3qa04di4moDA5k8melUejlo1YtwT5xLK9kKvOJ4sCRdqxSJIb1fikL
	TuEWKIezGaT3kr3YwGTUXf6EYEy/Fpo2ib4x8bo87O/XdRHfLYv7SF/QTOp13G4nAcqq5Q5KRrt
	phygnQCEs/20LjKP6xopF1rFCMJ0ojKVPND40EhSunSqLIvWE+CW6VebTTQzw+5+WxjZoRAQWI2
	9dWFmI+HVaxWdBFytSyaERz7q/TzqPHeDsojWQmzIKhhPMSzJvd+UJMwkX2v/pT1QUsonsS+VI6
	Z1S5spBE0fBlCGqDQtCTZeAnUk4QXdFJM9Dh/mBhMLSV09ztH0W1WRcB+sn+xnPymtZFFYB/wHJ
	AK1IAWTVFHyTSukH4z4nPLBKZnSXVfW8QnzBMQ5lQO/IxkxwZ/fb5dcA==
X-Received: by 2002:a05:600c:8b2f:b0:487:1520:d107 with SMTP id 5b1f17b1804b1-488d688da37mr93616225e9.31.1775918974202;
        Sat, 11 Apr 2026 07:49:34 -0700 (PDT)
Received: from localhost (78-80-9-176.customers.tmcz.cz. [78.80.9.176])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d532ef00sm171574225e9.5.2026.04.11.07.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 07:49:33 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	mrgolin@amazon.com,
	gal.pressman@linux.dev,
	sleybo@amazon.com,
	parav@nvidia.com,
	mbloch@nvidia.com,
	yanjun.zhu@linux.dev,
	marco.crivellari@suse.com,
	roman.gushchin@linux.dev,
	phaddad@nvidia.com,
	lirongqing@baidu.com,
	ynachum@amazon.com,
	huangjunxian6@hisilicon.com,
	kalesh-anakkur.purayil@broadcom.com,
	ohartoov@nvidia.com,
	michaelgur@nvidia.com,
	shayd@nvidia.com,
	edwards@nvidia.com,
	sriharsha.basavapatna@broadcom.com,
	andrew.gospodarek@broadcom.com,
	selvin.xavier@broadcom.com
Subject: [PATCH rdma-next v2 12/15] RDMA/uverbs: Add doorbell record buffer slot to CQ umem_list
Date: Sat, 11 Apr 2026 16:49:12 +0200
Message-ID: <20260411144915.114571-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260411144915.114571-1-jiri@resnulli.us>
References: <20260411144915.114571-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Extend the CQ buffer slot enum with UVERBS_BUF_CQ_DBR, allowing
userspace to provide doorbell record memory via the generic buffer
descriptor infrastructure.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/uapi/rdma/ib_user_ioctl_cmds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 9c5d3f989977..26c2e3b2125a 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -122,6 +122,7 @@ enum uverbs_attrs_create_cq_cmd_attr_ids {
 
 enum uverbs_buf_cq_slots {
 	UVERBS_BUF_CQ_BUF,
+	UVERBS_BUF_CQ_DBR,
 	__UVERBS_BUF_CQ_MAX,
 	UVERBS_BUF_CQ_MAX = __UVERBS_BUF_CQ_MAX - 1,
 };
-- 
2.53.0

