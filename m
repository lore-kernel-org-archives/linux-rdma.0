Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C665646AF1A
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388937; cv=none; b=IjP1FDj1+OAfZw5DDn4cMT7FlAr86JlbtuTA1o6BuWDROl0BQR0n/et/X7xwk2zenm8urxekyY9i7+OquQ+0s7azhRGjgUv6ba4WPtM0Eh8cw3r5ir9uptfopITykncLi5hIwh6rF1hfIspnOvdmAgJo6WZb3zhgVzM/VqeE9xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388937; c=relaxed/simple;
	bh=kzA3pbMdUChPDPLqRGXEVGXUg+GUst1G2WkUNxAkz7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MIXzp6WUZ6AtM6N0kKKwPxa30fNTToJ4oVACEOwUZ0N1KVHUQ78n+Ek2Qv2c+fjp+RlvIVp4ZKBAs0qVZoxDIXAipNup1CstD7y4GKaExxpBNOZnWXjV/crd5TZXZNu/iq9diIgDJe2ghLGWE0oy3AooHOSOim08cuUvyttQTrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Va3RcIFe; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Va3RcIFe"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-868cfc5c244so1115222b3a.3
        for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 05:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789388935; x=1789993735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nxdoFQzMWATTkINkxyDhaawW3qZZZKJ6A0rPl9EM/AE=;
        b=Va3RcIFemjJGGWuwCYuEVX8J4MWvEfwhzIpymnf6u9yxZYV5qH+PXIevZB3HqFfmHI
         N6TFRav+LzwzcyQXriVGEBWsWNWdA8bqPfupatnqnArjpz3rpREdKwGqZWnWBoOa5Yh9
         EdKWQ7/+3tGx7QjmfPqOtzsy8wLX+koCW9GApaZjKAPG7avjZ1ZlcVWqEeMaZ+n+NNyD
         bgSxHDQCqoE8cZEaPzEXepEc8Lecb4HZ+h1xlQ6wseQCM8VqRd2Fta8X5PfaNRmhfUJe
         vsozYYEoAcxOO+gOlmuTcsCfbqqmm2NeE2vlLCyuA2GFxK3q/eog2Ab02NVHpRCZ4+U0
         KKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789388935; x=1789993735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nxdoFQzMWATTkINkxyDhaawW3qZZZKJ6A0rPl9EM/AE=;
        b=MUB9AL+GyyI4rPdoraYUzKcQ7y/KdKcaVRRXDsdeLCCmU5AU5gKu4x9WqA8P9Oqe8E
         Lrm5FmFwFDsBu+S/K75W/rf8w5AdC/fZtMBLJI3EZgb49fDPVZ0Gp6xRUAj5WTuHYyff
         oU8oVHiMrzNfialwo2eTVZAR6hQOidmDXCAQDj4Yq108z6Wm5hQTW/8hawgnS1/mXLgj
         kUSrUiaUBxT7nTVbMO/Nkd2J0wnjTBchWhAW67hDA0GqGeF0QS49gq4gcPcazhn+uYP4
         gSB/H3WNyFN7VteEY/qAiG6C8fJlbp93r4ge5U+mWf5XA5c6NhC8UXbIsRqqyIsqPwSJ
         wP3A==
X-Forwarded-Encrypted: i=1; AKwUvBzsWuy0c7bT1MpbAWutLE+LqpUzWjvV3N+M3AVz5wMjCmuD74zSs9RdncWmZASLa65i0GSd0/AeHETR@vger.kernel.org
X-Gm-Message-State: AFuF++kFuzAGjNOMQOxVis/t7bFfFGrSkUsUROKanMMI6eCTAE173mKQ
	tPKn1RYIyX1/jIMgx5U5cDw8INFk0jiBdmtnj4aG9iUtD6J0AzDJPXaQ
X-Gm-Gg: AYBFou2wb4e0xSKTX4ODAL1VKDZu+Vj9Ylc1qtKImzrM+cDAjE4E3lucXIa4Rvn17v2
	stnH0I7FZuRBoiWa5Abwm9IX0+YTDLtp3OifIaCxmAWXTSfPqK7Zn5S5FCHnJwq620U0gQ/CUCs
	uQoMcJvsXQm3Wu1MZ4/VTaDzQQ19IZtM7a4wRrqV3Z0bmRTQ5o0JrRA0PBZoeirgrUp/cigaIBs
	gQcHzmbm+chRZdz3RJ1NH4Ofj5gFuxZ/bYMTSI3gLQrfUMD9t8HTJXpRso/qC0iLsqwOrWeQ6Am
	ENQodRMv1Rixx6YJ85yQNQm3ERDNMfIiLkW+fqBF9ZAFRPG/3sjAtib5j3ZrTiJG8A/3XlhSPjf
	bKxKQ2HBN2d6HOaqOPKwwwafrxpI94unRJ6SBkzJuzHkDumxSrSIOy0OTNBiKxw0kBMBkeDOZps
	gWpgHo1Dca/j26UZHbKkZaOe9k3L8bK02V+tpPw8F6kxaii734Ydu2AA==
X-Received: by 2002:a05:6a20:d70f:b0:3d0:8cbb:8c2d with SMTP id adf61e73a8af0-3db404467f0mr6071048637.4.1789388935057;
        Mon, 14 Sep 2026 05:28:55 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6550bbasm4801375a12.17.2026.09.14.05.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 05:28:54 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/irdma: avoid use-after-free in icrdma_remove
Date: Mon, 14 Sep 2026 20:28:40 +0800
Message-ID: <20260914122840.1709743-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

icrdma_remove() dereferences iwdev after calling
irdma_ib_unregister_device():

  irdma_ib_unregister_device(iwdev)
    -> ib_unregister_device(&iwdev->ibdev)
      -> __ib_unregister_device()
        -> ib_dealloc_device()

irdma registers irdma_ib_dealloc_device() as the dealloc_driver
callback in its ib_device_ops. The RDMA core explicitly documents
ib_unregister_device() that when ops.dealloc_driver is used, ib_dev
will be freed upon return from the function.

The ib_device is embedded in struct irdma_device and iwdev itself was
allocated by ib_alloc_device(irdma_device, ibdev). Consequently, once
irdma_ib_unregister_device() returns, iwdev must no longer be
dereferenced.

However, icrdma_remove() currently accesses iwdev->rf afterwards when
deinitializing interrupts, destroying ah_tbl_lock, and freeing rf.
Although the final ib_device storage is released with kfree_rcu(), the
object lifetime has already ended and callers must not rely on the RCU
grace period to continue dereferencing iwdev.

Save iwdev->rf before unregistering the RDMA device and use the saved
pointer for the remaining cleanup.

This issue was found by manual code inspection.

Fixes: 8498a30e1b94 ("RDMA/irdma: Register auxiliary driver and implement private channel OPs")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/infiniband/hw/irdma/icrdma_if.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/icrdma_if.c b/drivers/infiniband/hw/irdma/icrdma_if.c
index 4b451d8482a4..f405ef761f84 100644
--- a/drivers/infiniband/hw/irdma/icrdma_if.c
+++ b/drivers/infiniband/hw/irdma/icrdma_if.c
@@ -318,14 +318,15 @@ static void icrdma_remove(struct auxiliary_device *aux_dev)
 		container_of(aux_dev, struct iidc_rdma_core_auxiliary_dev, adev);
 	struct iidc_rdma_core_dev_info *cdev_info = idc_adev->cdev_info;
 	struct irdma_device *iwdev = auxiliary_get_drvdata(aux_dev);
-	u8 rdma_ver = iwdev->rf->rdma_ver;
+	struct irdma_pci_f *rf = iwdev->rf;
+	u8 rdma_ver = rf->rdma_ver;
 
 	ice_rdma_update_vsi_filter(cdev_info, iwdev->vsi_num, false);
 	irdma_ib_unregister_device(iwdev);
-	icrdma_deinit_interrupts(iwdev->rf, cdev_info);
-	mutex_destroy(&iwdev->rf->ah_tbl_lock);
+	icrdma_deinit_interrupts(rf, cdev_info);
+	mutex_destroy(&rf->ah_tbl_lock);
 
-	kfree(iwdev->rf);
+	kfree(rf);
 
 	pr_debug("INIT: Gen[%d] func[%d] device remove success\n",
 		 rdma_ver, PCI_FUNC(cdev_info->pdev->devfn));
-- 
2.43.0

