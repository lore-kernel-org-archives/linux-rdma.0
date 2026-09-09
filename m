Received: from mail-ua1-f100.google.com (mail-ua1-f100.google.com [209.85.222.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A044C4EB
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942687; cv=none; b=RrsYVnWcd/+73hAW6xfN5RLepIzyOxccMiStChvsE4tmqDn6kVovMZOH8haywW6ol3ecL88x7F6XVp2n4LWgOXINWizCTc9PsxIx88+BarTZ/28oSBU7sT/NhXvjqLNfwIL4yf9h3HwFNID4STXHK9CTQ1gbzTc3Uz/1cDP5Q8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942687; c=relaxed/simple;
	bh=KJytyvVwt38LbJ5ZcbkSDw9Zd6PCfjj9L+SCTo8LV/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hnp+1g9BaL+qpWIMMpeY4enE5CA5TN+UY7iobIL0+M492VXoiMTHtqBNc0zkQltlpTmBp0kPHMWBb4etXXk0a5++FQCxMP2l7fcAbhFRDo89bAiGoNqzBBaX3faUJD6ec+eKV8emWoUHdGyDThFZ1GaHdQhimQpA6a8j8YXxXLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=X/SK58/F; arc=none smtp.client-ip=209.85.222.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X/SK58/F"
Received: by mail-ua1-f100.google.com with SMTP id a1e0cc1a2514c-96723c7151eso1344398241.2
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942685; x=1789547485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4DB7eD8OWDF/O7FTICkIF+iPSrpqew5QUVAbIXQKijY=;
        b=KKFVnOOjbNKdHpgzeKXvsfNPKUzfDVDECuJNzhquE/4brDbdUrl9hThTBnBsbQrTw7
         UPy3rBedCdQdAzclPlHoC0zlD1hpBw3hloIE7dy18HsEhzqRZOWjQ6mSCBkonb2ftJJT
         ceCO6BCXAu9euGaooBXV6fYvnOTQPwsbMTic75MciOGhc+8sz0Posm0MpiH2YOwVEitO
         0qFprErMBu6fzLY5Sbenk9yWrUz3H1qukyKTIcVBqYg0pMj/YP/gDF1zKbjd+Mx4cek4
         L9ydhOSa8/0VbwXDd9s//yxdVDFqtUFI8c0ivrR8KeJmFWSaWCkfapVCUHGb/QfT6P/u
         GppQ==
X-Gm-Message-State: AFuF++lXHuTqP96Xod3mtiz5yQzs5ZFw+fHIkYJBquwxnkGgPEtKEjjs
	la+TIzW+3X3cCJfK9by9iDN7iCt9Dh0+diElyV7fdc+Vo4JsVkPngsUJPz6vGUFQ3ZI3YlABZWp
	ikdLMXU9gxHbuUvDfNZ0u1Obj2PH4dRGXjG9S4FHcHyD5eALCuBIcTTpAERM0dgi46VakesFWZf
	ZbAPpqQZ6iP0WHrOXdLHrX5dyzA+My1qdvpbsdeWz5zEjTdSTBXjE6WixG3WINUztFPf6BydfXU
	IUjZ/RdDcHxVYdnuA==
X-Gm-Gg: AYBFou3WwtvJxuhFuAktuRdpyhhY0wBqmlyq+8abs7oNiWqbsh4QQOVe+n86AvCDPKT
	+TKHcAtVEwbKyNxxl+YFPKtfFaBV5prWnXR1YbRgSjKZsuTRznxYOOt9NfEvwO0iMYeRuFm+r4d
	+zD46Hmbt4dvNMUzhY6vRvGRcN4oDPnwTnf4Goaeq7v5vFjTbwGjAmhruxI2GT3zX4sJpAg602q
	PkBNx7ktJ0wPT7gPjmHFNdy9StF2al26Sj+aB2qdGhaBFe7I6kXYMAO3RDqtcb59fCaUxTDCYuQ
	O6B4We6VSCVX0Kv9BvjqBPhZdgUiDXTKOyQ+XfXUd6BpTQ9uL7wGYpPtzrnI1Kk9dtbEEzuQk6o
	2rDZ0rn1hwgFoH/qV+Gw9spjc5AsnxQhIgu5GaAPSu9qAXHSwKrdG4w7aMUeDG3GI5++gcaHWdC
	aQxBQgOZUDEK6moYwkfun/lki422v+6JV5vs1Y5+s=
X-Received: by 2002:a05:6122:4f82:b0:5c2:ac92:eb18 with SMTP id 71dfb90a1353d-5c7ed3f6d2bmr12801904e0c.7.1788942684528;
        Wed, 09 Sep 2026 01:31:24 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-116.dlp.protect.broadcom.com. [144.49.247.116])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c7ec20f1desm7420067e0c.3.2026.09.09.01.31.24
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:31:24 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-396638f9a18so4812668a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942683; x=1789547483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4DB7eD8OWDF/O7FTICkIF+iPSrpqew5QUVAbIXQKijY=;
        b=X/SK58/FXCM4fuu24E+DkGHV8x1oxTby9niEuW763/X6GKdgiUNUaNTiK0/6w9f5NC
         nhlyH3jBfdPHj8j0t8OlFfeZ268zaiyvGTWmfz6C7Ycs+Ir/1Z5jskiG4YtL1+/ewXBE
         0/9g9BH5jxg3R7W/lIH0gmafjtwvNtOvORjUU=
X-Received: by 2002:a17:90a:d64e:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-39b2612eb54mr50577484a91.9.1788942683055;
        Wed, 09 Sep 2026 01:31:23 -0700 (PDT)
X-Received: by 2002:a17:90a:d64e:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-39b2612eb54mr50577420a91.9.1788942682550;
        Wed, 09 Sep 2026 01:31:22 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1433171a97esm45999620c88.12.2026.09.09.01.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:31:22 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v2 3/8] RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()
Date: Wed,  9 Sep 2026 06:52:39 -0700
Message-Id: <20260909135244.122747-3-selvin.xavier@broadcom.com>
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

Add a check if max sge for SRQ is exceeding the device
maximum.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index e56830a669bf..ab9d4d6bf5b0 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2389,6 +2389,13 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
 		wqe.num_sge = wr->num_sge;
+		if (wr->num_sge > srq->qplib_srq.max_sge) {
+			ibdev_err(&srq->rdev->ibdev,
+				  "Limit exceeded for SRQ Receive SGEs");
+			rc = -EINVAL;
+			*bad_wr = wr;
+			break;
+		}
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
 		wqe.type = BNXT_QPLIB_SWQE_TYPE_RECV;
-- 
2.39.3

