Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0D11E5018
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038320; cv=none; b=KCD2ro3QsmGDpUszaxO71jCPIs4pUnv2jIlSKjpNxiWIN/viOayE586lsHzL+sgimPzvMoRO2732QFvvk+VsJRM7yWNMrFBVlmof8yKNPAqdnPvt6X2+UdYES/hom/zZmr061Ernx6r4LTpLjt6OQbUTvVsn+vq7rRb2qRYw9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038320; c=relaxed/simple;
	bh=kTxejOjKKxtXvZwORf4FNfNkPibipByCgwq6gPE5V+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E3MebGAAEnItu6FBHjAXaX5wQ3BXHyxXCAEnN2WAa7v774zpk6dqF4LuSzEHrMGnEWmMUGhAmMPfkLE6bAm/RaPKNvVgXua1rOSjDCvuGZwNe2Wur3J5irHsRaWmcnfINmdOsmczLqkwOZrc4EdyP/uQ/1NDZ1Wfn1n8F+IDzOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=f8SlF0Nq; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="f8SlF0Nq"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so339836a12.0
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038318; x=1790643118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N7LgFcu/UuPb+6gApl/uvXaRn70/eg2QL3yrAwJleak=;
        b=Q6mtU8mVRteLv/g6GJI5M1VyGOB3BfUSVPH+CWSXmgYPJm8cUOSPLvj3FdRD8b8aLp
         uJypkG+ulXrR3Z73aDhKffxe4ME7Cox2q1kxIHWBtMrroi1Ml1RZQMbc55MACgE71OVJ
         PaTQf+xloP6Hl5dzDA+EWI6ObhasLrSP5EZqvWlJPznVTzVHAQZtDXZD5zHkLqK4TTVq
         zj89PmxsWTfmh+t1/V3RdW9g9EmzCZQUNeSPiI3VqepcN3PD7Ufjy36sHwnxfHjQekCv
         Sgwa1YOZp4rBvzSQUSYIizqwUfI0TSBwrpJIqK2kRhRa8WuIL95nlxybUKzNoZQCg5ZV
         jb5g==
X-Gm-Message-State: AFuF++l7ieEU5csBwGqee2P8QYz11OFkSygZBPazDV0q5N3N4arVqcW9
	6LCXmAA6Md1hH1bqHftCwawcT4Gd/XtmRbiWwY1VBSfApLxhP8oODvEe5T4CbeJ4u3oMbs9sg8v
	rEQq+d4p6O5qkfhsLiNKrKNZqXoBLJ0OyrLZJwPevZoail3VHeK4eLC0OT/OWjZDaLrrlOPxNPw
	n9DSYcfvB5JtzP07D89YVeehtZ02xB0UKo/KjinVAHoCmB8E6eHb9JzBXxi8y5/kx/Cldgb+3t3
	B5pGWMkSuNT0VhTAQ==
X-Gm-Gg: AYBFou2G+WSxtBp/Ra7wAm8yfr6euSJcA+VTECRZejmqdmDHJLijBbAf6DJgPEDCbQg
	ABcdLCgOvvikyRbySKUaKnaBNxvHVckVOIvOgs8LEPjx6QhxSuDQb/RPcMf+9koXgr6KE6oc9da
	Uq5q9hRYrXm7r6sRfBlFlQqKh7Zsz2bFiM/zxom2LP3HHbaoBmQ3HDPP2wH2eOGTsVt6B8I1nD0
	WHBfHZWvuLbgL9va1OjGql50zddb5Y47WHY8y7eNk1vs+PpnylPLUkP4ccBBiinmSCr/KrhjMhK
	Kx9bf9ggzc4gMkhpcOSKZoYPOsmgYzpYm1YYXAoTiZ5OXTf9TXRIoqU+6BrzZVlCQCVUtwUb8wH
	SJLdjEP/FXONu0rG5uEqK2YL7dv9drCQlZEiEVMWCyZZan346GVuiq1h/HcMU190RkHy8jESCuS
	zNlD3Irg9tdjRyvdP66Ggv8KcJdnpcGPh6D8dD
X-Received: by 2002:a05:6a21:6f06:b0:3da:f1b3:50fa with SMTP id adf61e73a8af0-3dde0111d71mr1103807637.8.1790038317796;
        Mon, 21 Sep 2026 17:51:57 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-144f29feb69sm22915c88.5.2026.09.21.17.51.57
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:51:57 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39af92138f9so484737a91.0
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038316; x=1790643116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N7LgFcu/UuPb+6gApl/uvXaRn70/eg2QL3yrAwJleak=;
        b=f8SlF0NqzWU3XnZXcwUyxMgOcnUY1GPBjxMzYaftjCp1fnjb46dr4y+3UayJ/PdMOv
         VLkzyfAWM1e37z7/AVNeVjPvo1oMtpqiDcYBrvILJigeDvR/PSmq2PqgsUZarZRSEpSK
         l4B/riV6WPa/lvL4Fi5r8f/fN6WLtx64XOR5M=
X-Received: by 2002:a17:90b:3e85:b0:39e:1bfa:c5f0 with SMTP id 98e67ed59e1d1-3a066a0adb0mr911800a91.5.1790038315579;
        Mon, 21 Sep 2026 17:51:55 -0700 (PDT)
X-Received: by 2002:a17:90b:3e85:b0:39e:1bfa:c5f0 with SMTP id 98e67ed59e1d1-3a066a0adb0mr911780a91.5.1790038314987;
        Mon, 21 Sep 2026 17:51:54 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:51:54 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 6/8] RDMA/bnxt_re: Serialize dcb_wq access against async notifier
Date: Mon, 21 Sep 2026 23:12:28 -0700
Message-Id: <20260922061230.7909-7-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260922061230.7909-1-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

bnxt_re_async_notifier() runs in NAPI/softirq context via bnxt_en's
RCU-protected ULP ops dispatch, never under rtnl_lock, so it isn't
serialized against bnxt_re_uninit_dcb_wq() destroying rdev->dcb_wq.
A concurrent notifier call can queue_work() on a workqueue that is
being, or has just been, destroyed.

Add a spinlock scoped to dcb_wq: the notifier takes it before
checking dcb_wq and queuing work, and bnxt_re_uninit_dcb_wq() takes
it to atomically clear dcb_wq before destroying it. Initialize the
lock at rdev allocation so it is valid on every teardown path,
including bnxt_re_dev_init()'s early failure labels.

Fixes: 51dc5312dcd9 ("RDMA/bnxt_re: Add support to handle DCB_CONFIG_CHANGE event")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h |  4 ++++
 drivers/infiniband/hw/bnxt_re/main.c    | 24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index a43e678151d3..da471c63a3ba 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -216,6 +216,10 @@ struct bnxt_re_dev {
 	unsigned long			event_bitmap;
 	struct bnxt_qplib_cc_param	cc_param;
 	struct workqueue_struct		*dcb_wq;
+	/* Protects dcb_wq against bnxt_re_uninit_dcb_wq() destroying it
+	 * concurrently with bnxt_re_async_notifier() queuing work on it.
+	 */
+	spinlock_t			dcb_lock;
 	struct dentry                   *cc_config;
 	struct bnxt_re_dbg_cc_config_params *cc_config_params;
 	struct dentry			*cq_coal_cfg;
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 17654a9e23fe..fa0e1323a326 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -367,9 +367,15 @@ static int bnxt_re_init_dcb_wq(struct bnxt_re_dev *rdev)
 
 static void bnxt_re_uninit_dcb_wq(struct bnxt_re_dev *rdev)
 {
-	if (!rdev->dcb_wq)
-		return;
-	destroy_workqueue(rdev->dcb_wq);
+	struct workqueue_struct *dcb_wq;
+
+	spin_lock_bh(&rdev->dcb_lock);
+	dcb_wq = rdev->dcb_wq;
+	rdev->dcb_wq = NULL;
+	spin_unlock_bh(&rdev->dcb_lock);
+
+	if (dcb_wq)
+		destroy_workqueue(dcb_wq);
 }
 
 static void bnxt_re_dcb_wq_task(struct work_struct *work)
@@ -424,14 +430,23 @@ static void bnxt_re_async_notifier(void *handle, struct hwrm_async_event_cmpl *c
 
 	switch (event_id) {
 	case ASYNC_EVENT_CMPL_EVENT_ID_DCB_CONFIG_CHANGE:
+		spin_lock(&rdev->dcb_lock);
+		if (!rdev->dcb_wq) {
+			spin_unlock(&rdev->dcb_lock);
+			break;
+		}
+
 		dcb_work = kzalloc_obj(*dcb_work, GFP_ATOMIC);
-		if (!dcb_work)
+		if (!dcb_work) {
+			spin_unlock(&rdev->dcb_lock);
 			break;
+		}
 
 		dcb_work->rdev = rdev;
 		memcpy(&dcb_work->cmpl, cmpl, sizeof(*cmpl));
 		INIT_WORK(&dcb_work->work, bnxt_re_dcb_wq_task);
 		queue_work(rdev->dcb_wq, &dcb_work->work);
+		spin_unlock(&rdev->dcb_lock);
 		break;
 	default:
 		break;
@@ -1448,6 +1463,7 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct auxiliary_device *adev,
 	INIT_LIST_HEAD(&rdev->qp_list);
 	mutex_init(&rdev->qp_lock);
 	mutex_init(&rdev->pacing.dbq_lock);
+	spin_lock_init(&rdev->dcb_lock);
 	atomic_set(&rdev->stats.res.qp_count, 0);
 	atomic_set(&rdev->stats.res.cq_count, 0);
 	atomic_set(&rdev->stats.res.srq_count, 0);
-- 
2.39.3

