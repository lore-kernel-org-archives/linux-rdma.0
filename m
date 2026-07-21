Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB5B4302F8
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 06:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784615597; cv=none; b=eqX47P2+DXyvzQOkQWb/aU9VwrBk4XfgW40cS7sGVn1FiaIfEBJewNsKSqm3DMSXVEUX5JBCinJbmcWeDmB8tJp8tDGOINXARkZGbTnvR1ytOFxG/FNSngeXerALFNmrL1q/e07pb3WmB0JAejn3ou1jpFkBzkg8Y5Z2fuLYuYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784615597; c=relaxed/simple;
	bh=/DDcqgoyyxsHzU3tPyW7pbsV7crQTrRnLX3s28kOfP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DhVQfL1JwjXK4vuNw5qOOLRSe8zBn2xJdG+xOLvvdfgyUQQByXj135fWAGusGZRXMsL3zI049Zi5MB41KFlUb62nuEf4pbFsONsWprvhieTFOjij6rqSE2rQdol0Mjcgo+7j5iHFLBf8Nd19x9jrct6LqqxJDDJEMD9lSSH5A5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fB1r96Sd; arc=none smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fB1r96Sd"
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso7392207a12.2
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784615595; x=1785220395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BqSUtVL9MwSHfMx9M9KnrdxRN5zwPiliu+z78BuNeZY=;
        b=dX8hNxCzXSo2oiSCaJ7cs6rMdIykUxUHUXSENE6VnB6R7zBOuizPXJWT7yaN2nxMMQ
         6hfvVB3Sao5c1MN76wtW9cWdMZiXf9jzh3QEMqIa/wdzSdRduuiYQa7WMEzpvlFXMlR8
         RrJULVzxB+PgcqAcMNr+kw12k8B3dO0xOqJWgtyglK3aV4aCrHbrZ5m4un0PkDvTKD02
         onguBYUbUgE2JUaynEZqfBl8GO2qS0Jn2Lbt8wjKb7svtvzKpQodABhK6HRtFNfRhgUS
         FygBVCrZMUiibJ2zFa/yeQKF+XqEx+8Mcp7r5pifsV3d2vYkw9yja1IlUShs8/kSy/3f
         fU/w==
X-Gm-Message-State: AOJu0Yxf1Vc0HOF01UscPkb/RLn3suRhrwI0TRKHxsBynSa3XSiJTODL
	4NAJ5K9vnMIziq0s57jbbbEJZMeIU/YMh+xEA7yiX1fSAnf/WC6jrLSPWJbPxUWbuEIGY1pQpjx
	bVEyY8D5zx5VU0C/So21nbGP5uocAAqX28W0R/9E5zgq+CfEuUucDT5WvhBBB0zMh+QsDqFTujJ
	eLOTbti3eTlCRk35ETWycKR5vquKfuThAG4gkHCfJwZ80gvi7sxFEwC3cUhX9besnIL9pWZbD/O
	I6d8mJ38hlWwmx9zw==
X-Gm-Gg: AR+sD11uZZXtbLTL5QilXct8A5RIeYbCdlZ6gMXre2T2Wn5MeIJMO8wsepjoixG3Bf9
	SDATgVOqnAkXaazOa/yFezm+seBKRVQdsJAbZft63Dbbjw64HkPrTG4TMrFnrfc/85+Ooo/CwP1
	oLXUutFS1L/N2dEYURygzjE1yEZLob9dw9Sz6B0NVT0OR8ML6H4kyZHjcgzD28nJ6tD1ZCtf2r9
	prQ5jX+frd+ZBvaPPxsqDTpwEpkG8BGDg1sDmEymZty8+6N0h8SNb9DEf37yuNBWCVKbKTohqLO
	s04nflxffACeqOISZCR1WPSdvL+cCnR1AXmW8ap2BE7T96kaoJAW3StPpPXapr3+0MUv9BZUkSX
	nZiz8NvwXdxBTjVOM2Q9Bnq6PXr3MA/JdTMSMZXXL0znd4WrwJQNp0Vdd80ftDYVsP7NQrxvaig
	9h7t+9igN+PPqheRRpFFOTalxpYv8YoK0JH2gcO3Y=
X-Received: by 2002:a05:6a00:1382:b0:846:7507:4e07 with SMTP id d2e1a72fcca58-84c29505e28mr17474189b3a.39.1784615595339;
        Mon, 20 Jul 2026 23:33:15 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-84c2afb390csm787206b3a.6.2026.07.20.23.33.14
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 23:33:15 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so6659031a12.0
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784615593; x=1785220393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BqSUtVL9MwSHfMx9M9KnrdxRN5zwPiliu+z78BuNeZY=;
        b=fB1r96Sd24zOIEG+SXhOj/f/0mIEVqFBW9UA1ryeKThNKPf+6WnY7xg3GumLZ3iKBn
         Ls0SDjmD/NGj/xSFDuI0nWyjEHZc7KVbNmX8u6Y+tnI0t+Gp11eYsVwa7NkJCYu9xnE8
         +jNN3bDmiJvvUJVzUYX8pgOmHZUk8DzQOeets=
X-Received: by 2002:a05:6a20:2583:b0:3c0:ac0f:6558 with SMTP id adf61e73a8af0-3c3ad677d0amr18062526637.2.1784615593368;
        Mon, 20 Jul 2026 23:33:13 -0700 (PDT)
X-Received: by 2002:a05:6a20:2583:b0:3c0:ac0f:6558 with SMTP id adf61e73a8af0-3c3ad677d0amr18062499637.2.1784615592980;
        Mon, 20 Jul 2026 23:33:12 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2900a37sm35230176c88.0.2026.07.20.23.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:33:12 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com,
	alhouseenyousef@gmail.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next v4 4/4] RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap
Date: Tue, 21 Jul 2026 04:54:40 -0700
Message-Id: <20260721115440.24021-5-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260721115440.24021-1-selvin.xavier@broadcom.com>
References: <20260721115440.24021-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

bnxt_re_mmap() rejects VM_WRITE for the DBR_PAGE and TOGGLE_PAGE mmap
flags, but a read-only mapping can still retain VM_MAYWRITE. nd later
be upgraded with mprotect(PROT_WRITE). This can bypass the write check
that only runs at mmap time.

Clear VM_MAYWRITE before vm_insert_page() in the shared DBR/toggle-page
branch, matching the existing policy that userspace writes are not
expected for these pages.

Suggested-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index a14b17d4261f..883c0674b90c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -5063,11 +5063,13 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
 	case BNXT_RE_MMAP_DBR_PAGE:
 	case BNXT_RE_MMAP_TOGGLE_PAGE:
 		/* Driver doesn't expect write access for user space */
-		if (vma->vm_flags & VM_WRITE)
+		if (vma->vm_flags & VM_WRITE) {
 			ret = -EFAULT;
-		else
+		} else {
+			vm_flags_clear(vma, VM_MAYWRITE);
 			ret = vm_insert_page(vma, vma->vm_start,
 					     virt_to_page((void *)bnxt_entry->mem_offset));
+		}
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.39.3

