Received: from mail-vk1-f226.google.com (mail-vk1-f226.google.com [209.85.221.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FB4470EA7
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942694; cv=none; b=rjve8Y62fts375gXQXXBOs9tM7pHCMyWuN9+48HLNBw4nM5dl9lRkdJFUkChTPnQTocKqHVllxnAXFf7GkvstrS1wldF1QCJEV4X1SP8v3RKoyTdW0jL8kGIs+aERCM4p1ba79PNiMZvc742uTNWBbNldOyAQoPTsM3Hms/cQaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942694; c=relaxed/simple;
	bh=DGVic7suNxLLqWDF69xmI8uiCqeegazxE/HjkldmZwM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PYCF4KtOu6FACFOCzhyzZ2LjV5ONCQ8gCHCIdro3wfb6Sc5YSsFOTvPA53QyfBRKaOl7Kpil1bXpUe6QyNeO8JAC3dS0x8OnoarMIVKbLt/m0xGqS21qstNuayG7yCjSf1HOAY/JqJGMwYCcrI10wG6nkk00h+P8QTtWCTEjmJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CxZ/yS6u; arc=none smtp.client-ip=209.85.221.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CxZ/yS6u"
Received: by mail-vk1-f226.google.com with SMTP id 71dfb90a1353d-5c7afda4515so3160509e0c.1
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942691; x=1789547491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/mbemSCvdTcBPg5TTH5npOyd4Ba3fsyO6I7o+rhTaR0=;
        b=NpGpModsOCStxivK8w9Rw8AZW/yiWV4/Khcy/VHi0PR1lJaffSeuhd1vWcGZVvUgnw
         q6lwcxC9JB46tYDY4v8mJUCmovHQ0bUmqLJyszeyReAWhuEUx9t7iZV7YE+U3CqeiNjr
         b2udm08uvPOIk+8kRXZvlsPGX+GaJKmEQN6VWgrbzgFVaynUes/zjCklOOyf/+oDHk+W
         51zo6mquF1RDXuGLLR4GCfMT826xkWBZT2FOJ1yzuIEW7VCXzL7JsGtLmiqDAhHHL7zi
         NN9eOqjBg9W6LAKkOiRI0ikbV7t8QUp881pcGDW+Kfs9AUgNqaTuwQxRITkstOT9zuwz
         KV2Q==
X-Gm-Message-State: AFuF++lWAENebut82WarTQp1Sn+s7b37zCFU/+7m2mQgszUEW19v3VJL
	bd4/AWSx88BnQYGb+XpptU0AN+qbR0I3OG1ZVzrYDaMCt8H+EpTAUW6q42/rK0ISw/5oR7pJtVS
	FXlUC0PM68gsjardnA+K21F7iDJyIws7fkHjYuuwAlliRXmOrQyq3hAZPUWjY67xIc5WvxkuXh0
	XLKkhUfj2rhBQ1eCvcptJ3+keEtTX5MoIHgoGwPRSZIew4sRC8fj0l8a7I7t9nhdsD0Cq6PWITD
	SbBnyruWHyVTOliXw==
X-Gm-Gg: AYBFou1O/JHKQn/eJ+0ma5+TR9qCM99HawogEW/AMOy4aiBsnbUrRtvB6n0kalggx6S
	NZN8J3o8VCKAQB/t0c0VLfRqEjZa9Ftq3WfbHa0z1jqLADDPYBt4HymohaAU6KGkv+ftj7A+OEw
	PoI0vnXVnLxwDNuPtZ665JyKzS7UPBepslZgpczf6jB07NkjSqC3dN0k2xcmeWnLymqz5t2RLUD
	uJSv0AFvhOuay6FWe+sg34SpE7ZOBbvK0Jql85rxM97a0iYiSdgo+0pc1C88FsDKt1pr0c/9f1S
	V9n2xXRrC4hDHvD2PNb5TpMYdthWvmyPvQUx52mCopyyo/LkHMH1K5mIeLiN9uF93zOY3nMw+HY
	pT4GIIR9AQra+XV7NQR4z8Pzc1h1oAiXdeO8MfOf2pVGi8nLe1FXUTl9YCdqVKmR18kUP/j5uyY
	x0tYMiPSn7OFsls5F+VBdO9I3NeZhvXt0ZjhrO
X-Received: by 2002:a05:6123:67:b0:5bf:b500:c4f4 with SMTP id 71dfb90a1353d-5c7ed285aefmr17792729e0c.2.1788942690819;
        Wed, 09 Sep 2026 01:31:30 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c7ec232ce8sm7582361e0c.5.2026.09.09.01.31.30
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:31:30 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84a67b16217so4421576b3a.3
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942689; x=1789547489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/mbemSCvdTcBPg5TTH5npOyd4Ba3fsyO6I7o+rhTaR0=;
        b=CxZ/yS6uWcRpZ6wVLBNntFrcyp46XtYIw9/MWqEmjkMHryuAOizxVE7E2v5vIk7hie
         lDNc64jhiRhm/AcXLoMq4YYqV5StmNWtTHA7olDuBG2PhK9UJj4RFsCn6Ak85fPMSovx
         +ajw3v2LnpiwYQhbiPxfGhX802/Fiw56XsZC0=
X-Received: by 2002:a05:6a20:7f8a:b0:3da:b8b4:91d7 with SMTP id adf61e73a8af0-3dab8b492cemr7993852637.2.1788942689465;
        Wed, 09 Sep 2026 01:31:29 -0700 (PDT)
X-Received: by 2002:a05:6a20:7f8a:b0:3da:b8b4:91d7 with SMTP id adf61e73a8af0-3dab8b492cemr7993778637.2.1788942688907;
        Wed, 09 Sep 2026 01:31:28 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1433171a97esm45999620c88.12.2026.09.09.01.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:31:28 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v2 5/8] RDMA/bnxt_re: Fix rdev lifetime races in  suspend/resume/shutdown
Date: Wed,  9 Sep 2026 06:52:41 -0700
Message-Id: <20260909135244.122747-5-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260909135244.122747-1-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

en_info->rdev is read by unlocked L2 ULP callbacks
(bnxt_re_stop_irq/start_irq/async_notifier), which rely on rdev
being cleared before it is freed, not after. bnxt_re_add_device()
cleared it too late on a bnxt_re_dev_init() failure and
bnxt_re_resume() didn't check the return value, risking a
use-after-free/NULL deref. bnxt_re_suspend() froze and freed rdev
before clearing en_info->rdev, opening the same UAF window.
bnxt_re_shutdown() took no lock, never checked rdev for NULL, never
cleared en_info->rdev, and never freed rdev at all.

Fix the ordering in bnxt_re_add_device()/bnxt_re_suspend(), add the
missing return-value check in bnxt_re_resume(), and rewrite
bnxt_re_shutdown() to take the lock, check for NULL, and reuse
bnxt_re_remove_device() with the same clear-before-free ordering.

Fixes: dee3da3422d5 ("RDMA/bnxt_re: Change aux driver data to en_info to hold more information")
Fixes: cc5b9b48d447 ("RDMA/bnxt_re: Recover the device when FW error is detected")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/main.c | 32 ++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 17654a9e23fe..91c2edebdb93 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -2433,11 +2433,14 @@ static int bnxt_re_add_device(struct auxiliary_device *adev, u8 op_type)
 	bnxt_re_update_en_info_rdev(rdev, en_info, adev);
 
 	rc = bnxt_re_dev_init(rdev, op_type);
-	if (rc)
+	if (rc) {
+		bnxt_re_update_en_info_rdev(NULL, en_info, adev);
 		goto re_dev_dealloc;
+	}
 
 	rc = bnxt_re_ib_init(rdev);
 	if (rc) {
+		bnxt_re_update_en_info_rdev(NULL, en_info, adev);
 		pr_err("Failed to register with IB: %s",
 			aux_priv->aux_dev.name);
 		goto re_dev_uninit;
@@ -2448,7 +2451,6 @@ static int bnxt_re_add_device(struct auxiliary_device *adev, u8 op_type)
 	return 0;
 
 re_dev_uninit:
-	bnxt_re_update_en_info_rdev(NULL, en_info, adev);
 	bnxt_re_dev_uninit(rdev, BNXT_RE_COMPLETE_REMOVE);
 re_dev_dealloc:
 	ib_dealloc_device(&rdev->ibdev);
@@ -2517,9 +2519,13 @@ static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 	struct bnxt_en_dev *en_dev;
 	struct bnxt_re_dev *rdev;
 
+	mutex_lock(&bnxt_re_mutex);
 	rdev = en_info->rdev;
+	if (!rdev) {
+		mutex_unlock(&bnxt_re_mutex);
+		return 0;
+	}
 	en_dev = en_info->en_dev;
-	mutex_lock(&bnxt_re_mutex);
 
 	ibdev_info(&rdev->ibdev, "Handle device suspend call");
 	/* Check the current device state from bnxt_en_dev and move the
@@ -2539,8 +2545,9 @@ static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 
 	ibdev_info(&rdev->ibdev, "%s: L2 driver notified to stop en_state 0x%lx",
 		   __func__, en_dev->en_state);
-	bnxt_re_remove_device(rdev, BNXT_RE_PRE_RECOVERY_REMOVE, adev);
+
 	bnxt_re_update_en_info_rdev(NULL, en_info, adev);
+	bnxt_re_remove_device(rdev, BNXT_RE_PRE_RECOVERY_REMOVE, adev);
 	mutex_unlock(&bnxt_re_mutex);
 
 	return 0;
@@ -2550,9 +2557,14 @@ static int bnxt_re_resume(struct auxiliary_device *adev)
 {
 	struct bnxt_re_en_dev_info *en_info = auxiliary_get_drvdata(adev);
 	struct bnxt_re_dev *rdev;
+	int rc;
 
 	mutex_lock(&bnxt_re_mutex);
-	bnxt_re_add_device(adev, BNXT_RE_POST_RECOVERY_INIT);
+	rc = bnxt_re_add_device(adev, BNXT_RE_POST_RECOVERY_INIT);
+	if (rc) {
+		mutex_unlock(&bnxt_re_mutex);
+		return rc;
+	}
 	rdev = en_info->rdev;
 	ibdev_info(&rdev->ibdev, "Device resume completed");
 	mutex_unlock(&bnxt_re_mutex);
@@ -2565,9 +2577,15 @@ static void bnxt_re_shutdown(struct auxiliary_device *adev)
 	struct bnxt_re_en_dev_info *en_info = auxiliary_get_drvdata(adev);
 	struct bnxt_re_dev *rdev;
 
+	mutex_lock(&bnxt_re_mutex);
 	rdev = en_info->rdev;
-	ib_unregister_device(&rdev->ibdev);
-	bnxt_re_dev_uninit(rdev, BNXT_RE_COMPLETE_REMOVE);
+	if (!rdev)
+		goto out;
+
+	bnxt_re_update_en_info_rdev(NULL, en_info, adev);
+	bnxt_re_remove_device(rdev, BNXT_RE_COMPLETE_REMOVE, adev);
+out:
+	mutex_unlock(&bnxt_re_mutex);
 }
 
 static const struct auxiliary_device_id bnxt_re_id_table[] = {
-- 
2.39.3

