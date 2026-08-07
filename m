Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF4C3D5C07
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 19:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044593; cv=none; b=u8hs4iDKY37tOba//fz6BksTUWwqXqSUIjvAXH+NQ33jqK8eip/yRBRvz6eZ7fsilsVF01+/VtfYLFTGtvlEYWXlTHKarDgul3tLjk6qYlnNEV5IHuwXGU9gCbVucK7QAKSBkECBnwsXhcF0TfcSMXk6QyTQjCphmdQAFJ+YVj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044593; c=relaxed/simple;
	bh=wEicr2TxBAo8D9bPLXnkIOGfC17CNcP38JRmAPt35NU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GUVtohVQKgnLF0pfYxtyV4J4rD+/D+OCPXw+yZwQofW1vG67ciJqtv9FDKr8AoMQJX3EsiUaQH6Sk5yJMu8a8O5j3/9g9vOEQO3mZ1IM1lWoVMSJfWMtKLNdUUeunfpLCQpsxLxMV15OPFREuene01B2eBNzDe1fibSR25T8XEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KQ4j+kZn; arc=none smtp.client-ip=209.85.222.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KQ4j+kZn"
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-92e50979c71so262742885a.3
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044590; x=1786649390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mr+d2mILvJiFemn5CwAmEwB6THLUuSnSiPh6wa/Wi7w=;
        b=F0AvOVF7jkgJxL94pIcnGg8spflrLX0JiWW3fISJ0isxvAsQc2djUoMgVZpySL0/Ha
         NpsXyACxp/gLreFgMhtbIg9OtdeUGm1bxgIrO4VQdSmEJjkmO0LzSPigILqT0aNa0Ai4
         jo6D5YoCwFcgIiouZup11/HCOQ1y5ccd8RcVLbVD6gBp7lgOcJGPdRGMYOP7uo6gG/9x
         rc29lp7wMY9RKL7aJa77ho5qiGmLHufdIdb/CTKdpkA+dLbXySzkr6B1E4aKi23dSQih
         9uLKKQFv0NtN8V4KjyF4EAHZU8m9G4te0KrT7W3bAlB0WaWn1qhXBGMXc6CeeKHd80WO
         nihw==
X-Gm-Message-State: AOJu0Yyc2Hvtciz1wLY0w25APb3UXxgR40/FFkm2SBAziYTzpne0XJQj
	6bLTjFQBQA49xgDnmxh4EnJ+f9cudr5DBo4YyCapU6RJ4gcG6Qs0yDMuQ/3I+n0Xspbp2tx8ZTb
	I/P1AcY8sT50JK8lPZv8NBn2YvAdqprL0XFChjLUm6zDWMg7b2iGPiAg6JxV4YfxAFPPEoS2Y8Y
	4dPkk1N+uW1KKEreIGN4hfcefT/4N1SYJPfkVNa39gOuw4vVLFb5y942zpPOFfoqoyu8yL7NqU4
	tjJuk5o+4jnX0GgmQ==
X-Gm-Gg: AR+sD105EtxJrunjaYm+NKqa0+/9EhaAfaJmIaOfPiPV4bdwSEjp+LKl/i94r+ErcVU
	D9ofxeUcjKdSepUTWPkFt0zUMlYb2QIsPJr71bEX8oky3E/MZ8eWrt1HTnToebDZ+eEaME9YOtp
	wM3U0xZL9VFCQgMv0RDD/pIO6DlQkGAxTzFKx90ZDwS3IyOhG7q95RA0hgkQm5cl81EwGfQjlcS
	WbRIToTVwxf1LJ93l8sBHieQ32WTlo30KwuNnQS9K+kA0trWxS+BMpOOoCQ4PBZQAJ7XBSiycnP
	yL3MNWAwepwFCsl9nUOAcWsCGHUPIjeAbtxvggBmZ04X1NXzwJ9laGPxrhBryHc9wflrfFfYE0X
	vON0apzxo2b4kBAP1EAVtT8gMFY9p3+lMr6RvaxPGff4eZCES6gYapCVaL7m3Ng7vPcA1mqXmn0
	eJ0I24dTRHkOqxT1E+TD04jewB6PBUchow7Ym9
X-Received: by 2002:a05:620a:8807:b0:92f:362:8097 with SMTP id af79cd13be357-936490579c2mr1958828885a.8.1786044589883;
        Thu, 06 Aug 2026 12:29:49 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93657eeba62sm72799985a.2.2026.08.06.12.29.49
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2026 12:29:49 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cd01a14e81so35879005ad.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786044588; x=1786649388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mr+d2mILvJiFemn5CwAmEwB6THLUuSnSiPh6wa/Wi7w=;
        b=KQ4j+kZn2wgyg+wVzzkTaJ6AsN56rG9Zyu2tARGVVqqojnM+ljAHfVffAwnSLdu5SZ
         WpWtdB+EQ4J384JhldgofGO/6UC5Qe571VILcADDAO88WYa34lY5CvBAM700FqLAAMWF
         W1wFc5yDf3PLCXniWDZl/0EyG0wY7pY7+vud4=
X-Received: by 2002:a17:903:3b84:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2d0ca712d68mr219310255ad.2.1786044588548;
        Thu, 06 Aug 2026 12:29:48 -0700 (PDT)
X-Received: by 2002:a17:903:3b84:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2d0ca712d68mr219309695ad.2.1786044588086;
        Thu, 06 Aug 2026 12:29:48 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158644a195sm28484575eec.13.2026.08.06.12.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:29:47 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	saravanan.vajravel@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 1/4] RDMA/bnxt_re: Update the page sizes supported for MR
Date: Thu,  6 Aug 2026 17:51:35 -0700
Message-Id: <20260807005138.771669-2-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260807005138.771669-1-selvin.xavier@broadcom.com>
References: <20260807005138.771669-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Not all the MR page sizes supported by HW are tested. So reduce
the supported page sizes to  4k, 64k and 2M and 256M only for now.

Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  | 1 -
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 4 ++--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 ++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h | 1 +
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index a43e678151d3..5d46743f075a 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -46,7 +46,6 @@
 #define BNXT_RE_DESC	"Broadcom NetXtreme-C/E RoCE Driver"
 
 #define BNXT_RE_PAGE_SHIFT_1G		(30)
-#define BNXT_RE_PAGE_SIZE_SUPPORTED	0x7FFFF000 /* 4kb - 1G */
 
 #define BNXT_RE_MAX_MR_SIZE_LOW		BIT_ULL(BNXT_RE_PAGE_SHIFT_1G)
 #define BNXT_RE_MAX_MR_SIZE_HIGH	BIT_ULL(39)
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ccd2702db78b..21caf34a1dc8 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -199,7 +199,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	addrconf_addr_eui48((u8 *)&ib_attr->sys_image_guid,
 			    rdev->netdev->dev_addr);
 	ib_attr->max_mr_size = BNXT_RE_MAX_MR_SIZE;
-	ib_attr->page_size_cap = BNXT_RE_PAGE_SIZE_SUPPORTED;
+	ib_attr->page_size_cap = dev_attr->mr_page_size_cap;
 
 	ib_attr->vendor_id = rdev->en_dev->pdev->vendor;
 	ib_attr->vendor_part_id = rdev->en_dev->pdev->device;
@@ -4687,7 +4687,7 @@ static struct ib_mr *__bnxt_re_user_reg_mr(struct ib_pd *ib_pd, u64 length, u64
 		return ERR_PTR(-ENOMEM);
 	}
 
-	page_size = ib_umem_find_best_pgsz(umem, BNXT_RE_PAGE_SIZE_SUPPORTED, virt_addr);
+	page_size = ib_umem_find_best_pgsz(umem, rdev->dev_attr->mr_page_size_cap, virt_addr);
 	if (!page_size) {
 		ibdev_err(&rdev->ibdev, "umem page size unsupported!");
 		return ERR_PTR(-EINVAL);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index ec9eb52a8ebf..71240f7be9e6 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -177,6 +177,8 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 	attr->dev_cap_flags = le16_to_cpu(sb->dev_cap_flags);
 	attr->dev_cap_flags2 = le16_to_cpu(sb->dev_cap_ext_flags_2);
 
+	attr->mr_page_size_cap = BIT_ULL(28) | BIT_ULL(21) | BIT_ULL(16) | BIT_ULL(12);
+
 	if (_is_max_srq_ext_supported(attr->dev_cap_flags2))
 		attr->max_srq += le16_to_cpu(sb->max_srq_ext);
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index c4193ae75b54..b16e12d3b7ab 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -75,6 +75,7 @@ struct bnxt_qplib_dev_attr {
 	bool				is_atomic;
 	u16                             dev_cap_flags;
 	u16                             dev_cap_flags2;
+	u64				mr_page_size_cap;
 	u32                             max_dpi;
 	u16				rate_limit_min;
 	u32				rate_limit_max;
-- 
2.39.3

