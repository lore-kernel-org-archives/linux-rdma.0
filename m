Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE83AA9F3
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716756; cv=none; b=IODRGb9tAfjltTV0nC4ii0vICxlxfxCTI/5s7eop9yCN1QimmeQorf9FSHwwOYhnb3zXgzz0NECv+HNbpvuiEkApPB1WcV1YYoC4TAE0iQsZzlpx4iIjR64bvxVUAvw1rQkUcDA5o0Phv6PxJbNbxbq0xU+gqOXa3baE1o2okPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716756; c=relaxed/simple;
	bh=Fr3fVMXgQ2Aq0by2LYTWQcbbX49y0iI0Bs/9IMFPXVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TW35CvphgcAMZPQJkE1Y2yUczRh4jgawzFzjx+1Oxx5XfZykhaekYCun0G+qK42vaEdDzACSyubHd49VsZ2GlIlw4pbz+b1V/hp9GUzIvHDjmGgsa6n2EYJqM1vsybhBnTOoxGSteYlZErlQvELvWwrGrmCO6O+Jrz7XlCAEwtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fq7WvI+I; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fq7WvI+I"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-39b2ad862bdso2879138a91.2
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716754; x=1789321554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R1e69zldH9lK8uDZCx+xDKRqDJOW60/BFPAIJH0KpSg=;
        b=nkBeX2NMffd2SRuiU6IpcOpRlTLeishxfMDiht/fzhMHHe0cNKZrIZppXdXAr7X39Z
         x4M17hpzB0Q1LqByOdiSuQy0eYqQOKLZ76qTK7r9i8I3unOK4nd1uvjTsiLFcLGsBcUk
         vkJ0n30XBa5kY0IIS46uoGfYWHfacXdH7o0tv2EVkwfB1yvF3/9XTflMlLayMazMtMh7
         9eiS6/UOxJ0YH8jzX4/PqZjL98chLm0AR1RmhTy+XyAhIIXWNzvuB6iuAqzu1BdmWhK+
         aHrbhG6q3FW+fQTm6Qa2kfB5c57YypCCKXrZtnoJtyF0ngDY9x7upjGJ3VBkgZCC8l2z
         T04w==
X-Gm-Message-State: AFuF++kqzoJhht7Ys0L867DQqVn+dxaP2sUKeMmNfv51N2pXbDzM24X7
	/TuffEdfQ2FtuIgxhQVP9GVSY92vrGSLaWM5vOq6xaaGQ2FGFZ119PE09Cc6n2AI/DFqfRl7QBU
	P3XyQ8IWC5JokLgIUX3GFq88x5JheBH7zXqoDOeuudrNHSJlP+h2jWurbIAc7liFYMdg/4+Tk+a
	Cio2KrP2buUUEBLlAXRuWNrodpFTRUTrNLLjfh7oRstRS2ygVxDjFQY/O3CxVnr/VLu6iREVNgq
	MkEL7H52OD8id+UNg==
X-Gm-Gg: AYBFou1DYmKTAgKU6SMuYf2dcNDYQd3g0v+ycYof4NaYDFHpa7fXHRsswwsCbEU28rr
	gEqyjUVenOSoegL1zBXLtI2lLiH5CoqFBlx7hHDbS4VW6kVzfjiRCpXhNYPWUSw9IkbHf8lC/sq
	1hG6KHE0l+RYdsauCg6ZoO+fX1yFC8x0IhVL0NijV4F+PcWab1xXZOB7NcOeIfXl+hwrGH9M55n
	/POHrP3fUgacVRn0OAkqf/qesSEYYqjPPS4MAcD8wNsxfsQStY0Q7O++0Xs4oOmbkhgVbckvIfU
	yML4Ih+1cme/2HQBPItGkNJWslAxQogd0+UeVkakOnrwNDndOd3/b0WDaxJYsibp8qttL5qpcMU
	1FrhSYW2FeTwW1ucUQN6+3g/7c+E1g7THBpwSIOMHHJ4uV7im6t2KE2Q+bl0TktlDOPe/kNvECh
	gMd9foMWpXAW59I1oyat4wdaVomYMD0WMslzGD
X-Received: by 2002:a17:90b:5905:b0:398:9bd5:490b with SMTP id 98e67ed59e1d1-39b262133ccmr27162225a91.18.1788716754239;
        Sun, 06 Sep 2026 10:45:54 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b16055f3fsm6748639a91.6.2026.09.06.10.45.53
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:45:54 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so5618798a91.1
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716752; x=1789321552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R1e69zldH9lK8uDZCx+xDKRqDJOW60/BFPAIJH0KpSg=;
        b=fq7WvI+Irafl+f4Lm9cigsrbhRGZtDaHQ52NottitkkFwvX6rJxAmkzVqUf7al00fT
         LMgvIPbAMaT1qU6SfrKlAu6xWhX6Phar/naTDlusTan3TCnfWrfi8mdteYKD0E/e8yC/
         8bgPN0Pr4WYw8eOmsWtXkgovJJBhnmAC77bls=
X-Received: by 2002:a17:90a:1c81:b0:39b:3109:10ce with SMTP id 98e67ed59e1d1-39b310914e0mr15793102a91.16.1788716752438;
        Sun, 06 Sep 2026 10:45:52 -0700 (PDT)
X-Received: by 2002:a17:90a:1c81:b0:39b:3109:10ce with SMTP id 98e67ed59e1d1-39b310914e0mr15793087a91.16.1788716751966;
        Sun, 06 Sep 2026 10:45:51 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:45:51 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 2/8] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Sun,  6 Sep 2026 16:06:54 -0700
Message-Id: <20260906230700.12233-3-selvin.xavier@broadcom.com>
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
index e39f99434923..108be3a68b25 100644
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

