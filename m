Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6673BD63B
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716754; cv=none; b=rBZ7WxFDXf+26/n+obPb3uLpasYTTh03a2aZbpYQ4h/6C0mf6DkJ+8h+ZJRhHE9a8Y3gQ4wZZUf/xfDKJt2tsApwpRGT7Kb1FOE7IVHx2T7E1vL42mjd3bHXbs0HNPWVVp4yQWEPAXTyYtLUGub/CuE7ACvT0FcRgxAMgZU0K+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716754; c=relaxed/simple;
	bh=hwsPIiy2UvDa9rozEM9tTmuelJ1SHJuFPW/AaYdDFvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YBShT/WG50JtiCoxveYE/oe50KTbwIlka/LJ+yBYlpWFU2HJ2osWSYGrZLX6VbpIiZaj3TeTdzRSjbW9M4ReAtE+RClzQ35hZ+PUyNOrWx0VBG3+4wZAw131eU6uBW8+nB4RT+fe7gA+RGMVn3Q0n4HmbYW4b2uINW8HOksSGbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FFcOtSHA; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FFcOtSHA"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38dfe910e9dso3045592a91.3
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716751; x=1789321551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9j4s+IcRc/ytnep/noKy7a3TSAaSFtr82QEoPtiDLWk=;
        b=WFqYcIM5Gf23w6eVKWkWfeCx4LTHxcltT3/w6DttxY/4r4JVlTTh6IO1zxpu9D9/fN
         KgrLHErAnyMdaeXxbGC4mPJhovbgyvo7Nb29lwuHEfGZh4b4XUTpIFkwUeQzkfgDjEsj
         jgNB9ig4mQ1GptpKwNXksZnthVBO5bjigYj1etZYU8JdyNSWqHBV5aoTirMl+4FaVKJf
         /wa/dCGE3z4W7pLKTUuOL5KpydghKSHu/RZUV0Giaze5lvVwKMfuPtB0JmzO4QGChCip
         yjB7eo9d3WuNgByr3DKIKEqz/Sm2a3ONmvr3u3aFTwm90VEKkiCSPwahNNNC5DoS4ZLL
         tdlQ==
X-Gm-Message-State: AFuF++mtcVpPvtQBEfMZ8NIMtcbdyqmIQ8L9X6meS3HgJcK52XWs/zpa
	FW9WVFOsLL3NTkwSP9DJPszNwmmsg69qZKjomUxiJtVw6uBz17XdP0uxDjz2Lglohifxvnqyj3d
	5mvj+l6lUMD4jOE72p60yXZbQlpYqqEHPOEeyp+oWWG5jLmqlcCO6Mim4U0OMZMSdzOgb83WS0K
	kRc8kpCTHrZc9IfWkKpvBSSjJsMFFOYEB3+pSAta4GUjHrZt5ExMdRrPfPYHiBTMl3omlVshCCy
	Ix3jxC1I9FdYIQfwA==
X-Gm-Gg: AYBFou02nejCwmbwF6mb01CyBbjG1fG0qGAYxryE3FDVA+0Sj++XAZoZFh2mSmxFhZ0
	SLY2kdz93MkOSv1h58MsHpOqbArC19LHWuzERi1sBn1t7vGaBQgwnBs2w9YTdGloU789Hhc6dSp
	jkg0MzTHXkGCIwnRe+14UyTM4nL9FLWT3ylOA/fImA3TyLmRWGHBW00ZGCF4DGckI+eaFNwTtM1
	2goUOQ5DosFxD04XFPwIzNTXSftTQYosrDkooUsbyUs+2MlRwAk8od3a1hOqxRvVlF8MNkZHQPQ
	jKcqpU2HK0HSqPnfdY1nGzS2I3gO3JVP2DH90kbBXRgBqi/O2JgBi/TLBSgLhA4F07mckgcgr2O
	SAYA1TIXKmB3lpA/laBix4pc06EVyONGDvpaIgDkELlpf9o4CbvRDJP8EZUxdberDwvGeL8cEve
	/GHHa6bVodiUOntRoyxpMVnQL9NWBg7RnKFg==
X-Received: by 2002:a17:90b:3a50:b0:38e:4cb:51f with SMTP id 98e67ed59e1d1-39b26101576mr31421538a91.11.1788716751368;
        Sun, 06 Sep 2026 10:45:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b16055f3fsm6748575a91.6.2026.09.06.10.45.51
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:45:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-398d292eac1so6034060a91.1
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716749; x=1789321549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9j4s+IcRc/ytnep/noKy7a3TSAaSFtr82QEoPtiDLWk=;
        b=FFcOtSHA5TWIuy7+czloZ/nKzyaZ2/A4k4MCWXyOXsL4WrZZGnPVdXIONDcLFYIpne
         VogBIK7cYaTCx4CGL2DNjOF//uojyY6KmFnROxvOA23oOzHDRJ/cAhBk7LyT7jH6OkR/
         Bz0JnSI6tfEqSwvsE0Imrf0L9xV7mE1iWbLpk=
X-Received: by 2002:a17:90a:d004:b0:398:c9be:cca8 with SMTP id 98e67ed59e1d1-39b2609f363mr32551323a91.2.1788716749439;
        Sun, 06 Sep 2026 10:45:49 -0700 (PDT)
X-Received: by 2002:a17:90a:d004:b0:398:c9be:cca8 with SMTP id 98e67ed59e1d1-39b2609f363mr32551284a91.2.1788716748983;
        Sun, 06 Sep 2026 10:45:48 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:45:48 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of the DBR and toggle pages
Date: Sun,  6 Sep 2026 16:06:53 -0700
Message-Id: <20260906230700.12233-2-selvin.xavier@broadcom.com>
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

The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
bnxt_re_mmap() hand out kernel pages that userspace is only supposed to
read. VM_WRITE was already rejected, but VM_EXEC was not, so userspace
could map these kernel pages executable. Reject VM_EXEC as well.
Also, return EPERM instead of EFAULT.

Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap")
CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ccd2702db78b..e39f99434923 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
 		break;
 	case BNXT_RE_MMAP_DBR_PAGE:
 	case BNXT_RE_MMAP_TOGGLE_PAGE:
-		/* Driver doesn't expect write access for user space */
-		if (vma->vm_flags & VM_WRITE) {
-			ret = -EFAULT;
+		/* Driver doesn't expect write and exec access for user space */
+		if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
+			ret = -EPERM;
 		} else {
-			vm_flags_clear(vma, VM_MAYWRITE);
+			vm_flags_clear(vma, VM_MAYWRITE | VM_MAYEXEC);
 			ret = vm_insert_page(vma, vma->vm_start,
 					     virt_to_page((void *)bnxt_entry->mem_offset));
 		}
-- 
2.39.3

