Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7E42DC357
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038305; cv=none; b=ruG/2Fk3vPDeACl77XY0bwjGoSx0au2Bb/lL2w1WhB24feNDfaDxADfXu+4FtyehXNKo3AuHsIVqYB8XyYV5BlM2iAHdIV7pFq5g3jAziZ4azAxJfMO2rvQybEVuRafl2QthbhehWyaSQTj/h8pTbXBAado+gnuzz03ybZBQB3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038305; c=relaxed/simple;
	bh=LIZgq7EAAte91axxK5QsuoZXcBcJl5f78gZ7OWuGt0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rs7GEZcMAq4nMKTzLbD0qgutIXZgrN26KPrfYqNN4cPi9vayl6CSjehOHcecRq48Kk8xf0KwYJ0pmilXuoRto69UJCXXouxIQ3RwFhDKrBeqF5BhkDDVmdTOgJwTNDG9zJrj0PWrlAXaALvi653RtuMkzzYuNzKbU5MUExTtGcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ZQ4lVL/t; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZQ4lVL/t"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-39675172593so1460832a91.2
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038303; x=1790643103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bFbFitU5aziihQhhHrZv4Y/92r4nCP9fRNsnDWZQdc0=;
        b=l4axKLXCI1qaxth5DsC/XNz/lP3u4mbIUXn60SgwGNcLnazApZlFJ9v+YZfkBnzH/r
         /mcgky2zi3sYQKHBOIFWpzmBAExdpqQjmPGr4HjrDUnkgNtqqQPMRBKJLRDjaRmQybSF
         //i5AlpWWt5PthLud92wXTVMpY9wo27/hR3POWTm/DSUaWBdmTBRyDu5eit2j5W61hAg
         uPGKkZw9L/s3J0mojibcKrL1r9GetoJ4T5kN9aXA91l5/qk4hPuEG1oabwLOYd1zwcul
         iLwHu7xPoMoySljxRbPRICTmNiWL+f3amcxLnZ2CjIqbilwZUW7UHH8oWWn4kJeubprL
         dv6A==
X-Gm-Message-State: AFuF++kZCdrlc5oU/ZiqfRALZj2uJYlN1bFM2EA0ZPO1v0CpEVb1U6v4
	fj1MnZOsKkF2PO/Fmm2xfyUmp7ReK2piZiw3YSNTJu45aHqYisclxOHHBxU+fXPPA4++apzMVQu
	H3JuXcjjbi3nitQHHnvtBUfn4c3BJYtffODOtW6hmkE5w0SkHlqX4ak3SLURVK9Pb1lclF01fCH
	lTQtfwGoPeD/G6q7feC5/QQ7WTg0qOOrDi3iiq7VS0n9djLRyVvV5hNmQ39TcLdfDom7f+gOGn2
	zqqQNuBLhbUMOv+TQ==
X-Gm-Gg: AYBFou0Anx0TRkcCuRjFfIwfNEIPrYlH8katcpkck0NRQdyM9guNVuDDGr4h0rVzUjq
	yFSl/essW9VwBYXW65i02/79pdS68fsddBp2RI1/N7+gVaPuiHPcM074BCLLhvFOgJ58kMtr1r8
	2S+NeOF36WB/GjYsrR/XshPmcM//fVFso1zuFTpKDKqKouD2hGrMgQ20mlkvp4CJ9365Q+toOvX
	fiaBhmnHLLqUkN/QC38sQkrlC9lu+mfOv/h6GPALmvpWM04QvKG+7jwjmbqQ4PJca3HqqwOEIgH
	GtS9NRosodk95c/nBvwGDU8yg9BCw+oQgKZqzNe3MMOP7zTZyU6rPAGvkdgYb9oCNU7apcPVH8C
	fT7ZOclMPNSzST359yOy67mvF/Sftl3N4o4523sYCqdklJv0iLyJf9Kg1XUMrpHwesmqkijz5Ai
	zsSB5okRqkth5+CwaxgP7MU+G3aGMKuoT3Uovr
X-Received: by 2002:a17:90b:2d4e:b0:39e:4c80:44bd with SMTP id 98e67ed59e1d1-39e54df9105mr19150919a91.32.1790038302779;
        Mon, 21 Sep 2026 17:51:42 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a066ab8102sm625725a91.1.2026.09.21.17.51.42
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:51:42 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d55d8cd938so62791065ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038301; x=1790643101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bFbFitU5aziihQhhHrZv4Y/92r4nCP9fRNsnDWZQdc0=;
        b=ZQ4lVL/t6IQuuw5mDT9gEuPTsusWAHWKi6ZXVGd5DMRfZNMBGY8aWbPxSLH0/jledC
         mQ2mi3hmPSkIVpvjy+asSt2I1j+VkFLAonDwEFbSFeF+SioFBrIjMJu+iOi6qMF0FQIQ
         sENCOJDRrHnpyYs29U/O0tnmeWomXzypuEdRE=
X-Received: by 2002:a17:903:19e4:b0:2d9:2149:57c0 with SMTP id d9443c01a7336-2ddb1ba35aemr176145945ad.22.1790038301123;
        Mon, 21 Sep 2026 17:51:41 -0700 (PDT)
X-Received: by 2002:a17:903:19e4:b0:2d9:2149:57c0 with SMTP id d9443c01a7336-2ddb1ba35aemr176145695ad.22.1790038300666;
        Mon, 21 Sep 2026 17:51:40 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:51:40 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 2/8] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Mon, 21 Sep 2026 23:12:24 -0700
Message-Id: <20260922061230.7909-3-selvin.xavier@broadcom.com>
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
index 9775a22b8d0d..c293c30da13e 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3169,8 +3169,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
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

