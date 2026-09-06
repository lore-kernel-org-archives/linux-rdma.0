Received: from mail-vk1-f228.google.com (mail-vk1-f228.google.com [209.85.221.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89743D2FF4
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716766; cv=none; b=TRy33AAB/qaNZ60BYyll1FM9RT8IaGAu7dDJjs8jLxdqg9ETR6Ed7/tN9WQkaE2k7ItR4WGikA+VsR1a9DXuMoTGwFyqTF0LxXeyPYLtHmXjuJBbQODqMGVeulVaYinei+qmrdYE6ZaNDh9mtnqlDx2vrvKiHMgVvaSynjLPS68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716766; c=relaxed/simple;
	bh=DGVic7suNxLLqWDF69xmI8uiCqeegazxE/HjkldmZwM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kbrkxQP4QSKPNw84/LeznqS/7LbF4MUVtYX4uL5cbEGslNLcyn3FtV5CR03zHWzDJaWgO11rBypIEpeZEfBV6g+2X3Q8uFuS2MlHi06TWjn6sMpfywiATjqD5R41OMFCWlsuWXvlEUdylWoVlZpyHJWjYUmPc5IYdWZUBXMrNbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=aAPTXWRr; arc=none smtp.client-ip=209.85.221.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aAPTXWRr"
Received: by mail-vk1-f228.google.com with SMTP id 71dfb90a1353d-5c652293bcdso3274192e0c.1
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716763; x=1789321563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/mbemSCvdTcBPg5TTH5npOyd4Ba3fsyO6I7o+rhTaR0=;
        b=OtWNxXXG5K7JOSkuV2+mtXJXPOmTO5bRJoH2W9v3InBTHbiafjgz6YfU5Sw/RYmIWE
         lY/219UFe7NjL+wTlgQTDJx1Hu8yaJZNZSlOLH+JQjZfUYr3agqC4ozpOZ0v/r25Zawz
         G4hsC/occE2fxLDWf6/OvtImWX2aEHfRlIEUZsLKzyNM1nLibCMD0CLMqQHe2dVGlAdl
         pEFZ8nIHXdgt10DPLCKbueME2CumsIYzwCjAETl387L58ZccOcV17bYDcPHYAsnXBxzQ
         Gn+ulqMNrI0s76CKlsge3vphkOPPt7m0D5VQF1knLQH0GFj7drrb0DVRBVQCs/iAIT6U
         Kbqw==
X-Gm-Message-State: AFuF++mxOy7fY+d8Ar92H+5cPv9+ywgUb5rxdLYjjxsUocgwo7XIQCJw
	GqneY1E2z6cUvvwrDI3NpAK0stZpbiUZOshe80D7n6b878U0ui438Mwzi/S9Uu9al+PSUx3eWXP
	KLWb6i4JCOq4wY4e3xNa6PhTyAXiHdHQ4s7mhz5EDVh0qHcmnScrwgSPil3I8giHAiXqhXVgXgj
	PfFe6ilBzoU3rAEwegNTudjvN2n5vjONa/x58MlKH8Qisu/lWPTrRIa1nhvy+N0jD9ufdZVAify
	XtaBWp0XQwFmq0aaw==
X-Gm-Gg: AYBFou1DasEUsDNhj/QT8wuH7ng1mXWu9kT8Du82uCJqMWfhrBoxfwnh43goXM1kzZK
	hhNUBKSfgG5Lx/KTXdqah4YZj4jSl8U5y6iN1b7p/Gt6anMruwwkEsoW7d88RzE4D32NN2p+65+
	gW3m9YaD1fiejiAmI9NreecofEUx0AUdCSJfde4Qz5TpHD7SyDOXT/pWd7KkMFXuAzKeyGj68eV
	6LJMTVMFiR4XZ9dFFRhtNebb/DVTFuXY7+D7hG8HxuJYyLQJC3u5k/As9NFJk9QEGEGhgfohgXz
	7Z2wUEvDrUGLDcBt63ACmk2+Gn/Mxbh6NWIlx32dBUXFedH98brpZ8IamVIzycSrWYHu8Gtls19
	ItEUolqFN4kuUf3yp3pVaTCkr8l7oJxbq7pK+tjkwd4P66tdA7TsbrLy+E9FWannrpYExunvXR0
	F+RX6HMIf7LTh0k6yo8EKi/4jKrsMrHGdjkxf8
X-Received: by 2002:a05:6122:4b17:b0:5c7:fb4e:2cee with SMTP id 71dfb90a1353d-5c7fb4e2dbfmr5715710e0c.1.1788716763425;
        Sun, 06 Sep 2026 10:46:03 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c7ec1386b0sm4040422e0c.1.2026.09.06.10.46.03
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:46:03 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1b8088202so2531682a12.3
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716762; x=1789321562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/mbemSCvdTcBPg5TTH5npOyd4Ba3fsyO6I7o+rhTaR0=;
        b=aAPTXWRro7ZsJ/CYQRaROefPWHVlugm8PPsruFKyIOXRN5BBhsWAIJJ2ekQKDrlx3d
         nhwOcVbEHPPMWpjFBn93C+F8gvaNC75ZffKswvd7ee3zXX7p69UxDjshdjdwugSPoHpu
         vTGj/9/iEHZYjiG+1uvsx0uFyQwBoOsVnxClg=
X-Received: by 2002:a17:90b:2e4b:b0:398:a145:5d3d with SMTP id 98e67ed59e1d1-39b26151b89mr29158981a91.6.1788716761902;
        Sun, 06 Sep 2026 10:46:01 -0700 (PDT)
X-Received: by 2002:a17:90b:2e4b:b0:398:a145:5d3d with SMTP id 98e67ed59e1d1-39b26151b89mr29158922a91.6.1788716761331;
        Sun, 06 Sep 2026 10:46:01 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:46:00 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 5/8] RDMA/bnxt_re: Fix rdev lifetime races in  suspend/resume/shutdown
Date: Sun,  6 Sep 2026 16:06:57 -0700
Message-Id: <20260906230700.12233-6-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260906230700.12233-1-selvin.xavier@broadcom.com>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
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

