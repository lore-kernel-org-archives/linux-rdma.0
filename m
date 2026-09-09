Received: from mail-oo1-f99.google.com (mail-oo1-f99.google.com [209.85.161.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16564A0143
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942684; cv=none; b=SWbTBnQOrSmKtGBtuPLmUh/cr8SYMoIbsIA+s0ycM9G4VJ9O/5sEQlPXpN+8WLSXxKQOOFV2DKLajZ5D8w62I3jVzPX+8p+r+jII3Ns390aA7GMXFHThm+O74p+lh55GqWgdIB8HQjPD6hXsu+9REzOwiIJEutpXGPMTgEl3oQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942684; c=relaxed/simple;
	bh=/xYKJDAFXpZm6kmnCA1dktIbuXCxgbHym0UvKKuADgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pzz2Pymi0Sh0cXlA+W28pBAlbFM8p8jI8mKFt+lgY3kZ/YRvpxSfFLgRyFbqFgEkZPK1mw0eDScthk9OzrRb3S4OSwOdJ5l0MsTVpaCU8GEo+crutUYJjyKrD4BX9ZzbH5BbfxxjYMB1oD10LcnvhK2iGtRNvFkHjganb3W+B58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UHSvSzc5; arc=none smtp.client-ip=209.85.161.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UHSvSzc5"
Received: by mail-oo1-f99.google.com with SMTP id 006d021491bc7-6be1f18687bso279662eaf.2
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942681; x=1789547481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OnAsAVLCVcqxghRrw7ER5zE+yURM/ivOXMX1X7wIVx0=;
        b=qc+I6ujuDrHGIgQ3ebcOUknmwolRA0hB/d0Vf2YPwCGQLQIbr/qOY+hvN3K6PRTKpI
         +p8sUW/rFZ4lGLy2Y5v26r6izGqva3RKB+UlcnbVw7/t64bIh4LQZlmpWhWfACeDhvtV
         htjSlK6kcFHgO0Ogu/RfSs+AHyPWGB1zeLNuCs9pzBdrhbi6yQTm4i0JewAzN+oMikDi
         TzDIY7wbHrsWjSnFurNxTzng3V9g6LqN8tLSmsWggBsAZc81wYTPsUIHSqlYfGSs/r32
         Kszeg6KVbWJSA271YyUa08ud86JDsWmsLzF5zlgyFSBJVzRuIvN+hfwsVm9IDUNYJMFg
         6dRg==
X-Gm-Message-State: AFuF++mT9/oyx+5XWeQJAK82s/Sh+ylxo+PSq0iyH/UAxYfqcHfIVVUa
	bWyBn+bQWoqE3pnoarLvlkGzD4mNMxnl152WOmMgKjQ2UgBraAykp3sXRZLxsa+GKvhU9FrHYDr
	3PJn8nMGBGvfMwef1Ml+hm4L00MJDDUwc7Twf1QxroM2/oH54Sn2zpDZYkqzNj0nLqmDV+Vgodi
	2l6mD2oLpbkHgqO2zi52JuvlV0D/QbZFMousw+GwrAgqRCBMFLxpN2wzfXgrLzCUF1vrEkc6QFW
	0G/JS8Rt82nyhgTSQ==
X-Gm-Gg: AYBFou2nERJnRlfj+ZowCY4Ahp9vJU2OxrSTDDKwTs6+Qwk8nXR+X7kKNOvrolAxz+1
	sjCXFITKBmey4iDBs+6nvMMHRL1YZo7qO1AW0VciO31x8Xs3NGh5dYFTJEWEih/uRLjg63P0ryE
	oVZNdDBVM+DJurxlYonjfqntLMCXdx6L2HfDsUusitvLR462+MNMU2OMHY37mgL11mglZJiwifR
	8zzncISXJCIz92sLkFhbndNPUlSXDr+Z56JWb+C3FGc7HhhWDNy9j8A7FmGeKdT5tOPIt59V8nP
	hd51HwS/v9wwGntrO78NscpXYL3H/7qxqvjFuDK+9Z1l9Sg9KK6Vm80QU+Ytgs1TkL79jtUOCXZ
	m3D7kI8kHADVtg39ucnrTmIJ4bxbNVxNX9mIVADbIUmK1+zwBMjhl0loUhoqabL1CHffYPYxfgB
	06yFuG6utz8okncURly6RZf2OvNrUkThFJazlQ
X-Received: by 2002:a05:6820:179b:b0:6ae:774d:45ab with SMTP id 006d021491bc7-6b6fd8cdab9mr19916895eaf.27.1788942681125;
        Wed, 09 Sep 2026 01:31:21 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7faf7de412asm1942706a34.7.2026.09.09.01.31.20
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:31:21 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-458326d2d9aso8417000fac.2
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942680; x=1789547480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OnAsAVLCVcqxghRrw7ER5zE+yURM/ivOXMX1X7wIVx0=;
        b=UHSvSzc5StALLgIhtq8qRocasgzsojWEqM3gxDXfstJfiA4yHedhYdFrwGbhJpQp15
         nkiQNyWmMFS1+bDRYYyI+F0JpPENxo3YUgGemz0WOBE147JzHhm+/ZOlb/47pEkdvrmY
         An2H4yo0eDppNf9YAg+EgjtoXHS6/EsmtVToE=
X-Received: by 2002:a05:6820:811:b0:6b7:83d6:2921 with SMTP id 006d021491bc7-6b783d62ee4mr16346485eaf.36.1788942680038;
        Wed, 09 Sep 2026 01:31:20 -0700 (PDT)
X-Received: by 2002:a05:6820:811:b0:6b7:83d6:2921 with SMTP id 006d021491bc7-6b783d62ee4mr16346467eaf.36.1788942679531;
        Wed, 09 Sep 2026 01:31:19 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1433171a97esm45999620c88.12.2026.09.09.01.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:31:18 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v2 2/8] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Wed,  9 Sep 2026 06:52:38 -0700
Message-Id: <20260909135244.122747-2-selvin.xavier@broadcom.com>
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

Avoid handling wrong sge_len by adding extra check
to see if the passed length is more than the inline
size supported.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index d80a22e4ac70..e56830a669bf 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3168,8 +3168,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 				wr->sg_list[i].addr;
 		sge_len = wr->sg_list[i].length;
 
-		if ((sge_len + wqe->inline_len) >
-		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH) {
+		if (sge_len > BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH ||
+		    ((sge_len + wqe->inline_len) >
+		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH)) {
 			ibdev_err(&rdev->ibdev,
 				  "Inline data size requested > supported value");
 			return -EINVAL;
-- 
2.39.3

