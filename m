Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FD548E0DD
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942682; cv=none; b=DdyNd742AOFVpffOCx1m/dk4YxUHMB1nxt385K1VyvloHcD4OqPX7P4RuQuFwUc5hSvd1oHVy0fuPTv/hRC67Edy7qkS79Fh31viSCUJ37OpIouet3fA+a7AnUwoJiE0bYnvp5hOIBSGLzJhk5Pr8uYLur8/zn1LEKXXsXK/leQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942682; c=relaxed/simple;
	bh=W1/Ou5hIt89rD/4uzgmONZoZn4o83VSZ6ISnRq3YeVU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gysl/xnvb1pJJ+O8sNs5IUb0kzK1u/YmYGb37f7bMPqLMligzO3Dk+CVOoq+3FDjMc4N5fYtOxm3B+YpyRBVZdrP9gOQV8CU3GeY5RizW8qB6JHrEgu+mo9Os7EUoTRuNkQ3WlYZGiRL4Wb1+B5VRsMnqunCNijGZXGdMf2NMLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Of3JJtPE; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Of3JJtPE"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-39b9a99469fso1522616a91.3
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942679; x=1789547479;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lvt5Bo1f4x0OMIWQNGMa2/esojW3tmDJ/5LXmCj5kW4=;
        b=pXrxJrqVZ90J7wv0teI1Odm8SYbIHyShgUOeZVppgj+49UfGNyhJl0HEfgCo8eCoaG
         sxZfb8QcARuSMKTvar9z6VOr+6hN8q9jpBs43L/mQKPbVBVdCTmFbOmiaByGv74iaswR
         zcrmri0aaIY0QRv+RL1z8qJ+Fx0kS4KV7Zk1+l9bPMA2TmS9aBrU4HIA+CLJWgsbVU1+
         4KBG2WAG5emYZpMCc699+IiojTxLS0xZMJbuwIfQFzs7uS7S5hjjB6cFQOBecHRsBhOy
         CsKXOYLk3966s2ipvznbhmBmSw9NBA59JX4cZcs8QD2hXBym6yO3cXrPWisEs7w+hZJh
         /jhg==
X-Gm-Message-State: AFuF++nvaLsiEhWCYau63UOCfLLtGDRIhL4ZJ+aUKhgztyGxxgB3CfvF
	XmuTr5CEPIVm42cDvYgb6DaKPr41g+oITYv/go5d/icPvIKdOkwDgVNNoXbn+XSXDBfYoYtFugS
	rkKYfX1iz5jFmi0zuESmlRbEalBSjznkKvuK4JrS1NaaDcc7hMp4hKJHQWjQGebHNQabKbFDTOn
	SDtRByzNtCXsnIR3R4ZUhZWn7BK9W4xcMr1W9gjk/DR3o1FkwOoNJpd8hPUVdsNMbAWK40rdgnP
	J2vX9nZK8RcbrYVtw==
X-Gm-Gg: AYBFou3jnlvqXKIqOY43XcrLLmJQkwzAqZ4mh3zMpf70Pam3ecXDWuzmoytIHw6pAMt
	sg9VbKK+6WMdxLcSTPpOL2cCF7FzwjwWfCSMzA+XGI8OZVp3JYkjBFf2kSV0x1cqhIIORNfziaG
	4EQ0tM4B8xQbgJhNV4e9C2ud/+SBFNYrjOspEAA8CasOTpJwKBVXpFQMHmSjmncgF+iOHs0yAp5
	HZqzDU1QRbRO24CpZLDCqECK7LiuaDCfBGiOYvN6gZRBlZedSluYr6R4AKnmrO3PRTj8vZKd7N4
	IOcKh1Jsi9TaiICEWcgxNJesCPELW2zv1wBiIBSSDieVTkMA/g9+StkfdJJfIWpQSQHRuVXSWT2
	6j11rpADc1bXWw4wFkmkZXEtrxy0Dz2szBnqqv3FJbuX22hdiBvVBFCjplruXhinCUrT8DktHWA
	gZ/Ce6yebPbMi5KCZUj8WRpEohasauY0+eyw==
X-Received: by 2002:a17:90b:5844:b0:398:dc16:3c29 with SMTP id 98e67ed59e1d1-39b26101530mr51647400a91.7.1788942678816;
        Wed, 09 Sep 2026 01:31:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b16099fd3sm11126246a91.7.2026.09.09.01.31.18
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:31:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso3039435a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942677; x=1789547477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lvt5Bo1f4x0OMIWQNGMa2/esojW3tmDJ/5LXmCj5kW4=;
        b=Of3JJtPEYXpt/5C9h0wgesPcDGZ5KdjmiNpZ2LxmueA5HjSArsMgoRhfUYaKqqNzuZ
         qLD2DK+3Sc4QPk8z58C83DifGcDgmB2Cdn3jjmWXzMmTimOSmlr2fF6wi3H1YUEQ/P4q
         U+VjUd9BN9sUdTF4HYjNWslsFD/y5ES/kPAsI=
X-Received: by 2002:a17:90b:4fd1:b0:398:bd37:6a49 with SMTP id 98e67ed59e1d1-39b261cfd8cmr50717802a91.12.1788942677022;
        Wed, 09 Sep 2026 01:31:17 -0700 (PDT)
X-Received: by 2002:a17:90b:4fd1:b0:398:bd37:6a49 with SMTP id 98e67ed59e1d1-39b261cfd8cmr50717740a91.12.1788942676421;
        Wed, 09 Sep 2026 01:31:16 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1433171a97esm45999620c88.12.2026.09.09.01.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:31:15 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH for-rc v2 1/8] RDMA/bnxt_re: Reject executable mappings of the DBR and toggle pages
Date: Wed,  9 Sep 2026 06:52:37 -0700
Message-Id: <20260909135244.122747-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
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
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ccd2702db78b..d80a22e4ac70 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -5057,9 +5057,9 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
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
 			vm_flags_clear(vma, VM_MAYWRITE);
 			ret = vm_insert_page(vma, vma->vm_start,
-- 
2.39.3

