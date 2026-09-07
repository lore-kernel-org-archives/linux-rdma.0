Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B5F4052D7
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 06:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763870; cv=none; b=mQAcrdeGgPwinCpDCrdPl6DlSP6Rv8PDdqq9G+oxP0rJQIPQUqihkwCnImRvr7jRxUqDMkXSzKbcPtqsyHRnBxjwG50Q+AZPocWKROlcWumQIAPdH7WMTVqUxRd8KOh7y76BNdpb6gc5L2yz4bQM4nsnJrvWZFvbnLR+7neZ5yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763870; c=relaxed/simple;
	bh=ujTVo13mhtQSZM3dZ1D9Y4fVcKanGUzQzI+aiyx+F9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyoPrHq7y3YjS97HPtmlRrLAqQrS/UAonOVzqcrKyTzg7iDMBRKdAuIzDLT8661rVJWMOxWAW5idpAGCotjEuwhTNTJ6YjbBeNhpe0Zg0Ttl05ajQhcffU9sO4RPSzuFlfmK/kEDsQTZqXJtlNUkupV6ArQIM6qiuyn52md+91g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uiv37xkO; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uiv37xkO"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3966791a6eeso3850869a91.3
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 23:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788763868; x=1789368668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yPgV6ur+BwahojS5JHPO8OPhQae5Mb5F4foZ8st31o8=;
        b=Uiv37xkOTuYB4niihzkiwal5/3fhViVNrXe54rNBSvAiEVyzy37eV5uf7fiCXhnn2Q
         xeRnMS+k6+4/+sn7vtwltLRcITYKmFLPIYHEtwPcNh2h04FjeazbUkTkFEjucXu26KN4
         6W/WgmSlANC+nKiBP2hPrT1mQlN9gCG1GkDalmNLszvZG8X5D6u5ytKwAcTfFhSzm/1H
         jYN96zUO6/EDC53mtAmNCUmL4y04Dqy9LzXxHVoHBOjYBTv7Mdiyz/nNqEEB3OfJjNci
         qq+RpHf9bMd3PGHeUqpFbXGUZ0MnEy3HzDHf/R3Xjz3jST/au1U0Q47T2BUYQR8fe6l/
         P+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763868; x=1789368668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yPgV6ur+BwahojS5JHPO8OPhQae5Mb5F4foZ8st31o8=;
        b=iGOpIK/Xoq8xnfc+BNFfQUgBhWBnU+LUJOLHqiy18GbIwkxFsBBhkzzhX5q6wh29iL
         N7dQLXdRNdDh/tUIFjkptpZBGpvu3OI3kuaCUOxgYVKVgm3Ps+XbZVKHwOjxRaOG5Khl
         ogxgSUZjJ8jhyOEQToDDv0g/xz4h/uUe0QTZhD4R3oS5tBv789CQc/808nsnIr96+wdI
         0m3J1MzBvNxvJ0/8/yPKn3dbMQlz966QtjwEX+dpVbubzv8ld5l5aE72uqRgATEdWxXK
         Sl1Ame96xL7VMAh6dLNRm+hWFeLWvdVycpue7Ahe33c6nwDI2En5XvFe49uG5Mnv3Dhl
         WeFg==
X-Gm-Message-State: AFuF++mhLHkxUVlCXS6ru4VD4orsAhikgQ0AvV1ej5ULLqZBF1ZMhBTV
	aCavFAN6/olVrpUC4rbuPXAjSBDaJX94HDaHls1QhwhFcurrTLNXo2HS
X-Gm-Gg: AYBFou3h8sJX+soscNcs+EanGhYNDysbiNWsKm2iMsN6W/S8mHG+Q3YoiNmeYh5Orz+
	K3oJi5+40hbZtSfEkmp61jnZaEqiqpLQwGm1Q4YOJm/NKIG52wH+HKOCPt4KngRHyWHJAjKVecW
	cQ91+wr4vn6J1Dn55po++GQu9z+s2xrSZsPM09C/68sPwIYG1i8Pe27pimunlpu3rgh7sPygS6e
	X8WKbrC9QnM8tjnVf+beMk5KQ4a2t6CnXeZfqOdUsPZLOXPrFJvdigsjPZ9yImaAbw1qlbnFoDh
	J+f5kL6SaibWslyUlVDJh0YggJ6WjUKAQWF0WWHjSB28BmdRYCkh3LuWxA8L8QKnoDimI3+mQ0g
	0mCiRLCLIpJLR4gfT5k3PSk2/hVAmXzz5p6eTUgnZZ4Bf9AQqj21DrCn3OKFlUkgUpfioWkKA+s
	li9QYqgv9/VFu/+bINfp1MLmNrQkplS0n/aX06Vx8UKb/BjT02lPLI6DybyU+vrwZ0x0NnoOn7/
	edb3h1dgFQFow==
X-Received: by 2002:a17:90b:4c4a:b0:398:bc52:825b with SMTP id 98e67ed59e1d1-39b2624c32amr29338566a91.21.1788763868106;
        Sun, 06 Sep 2026 23:51:08 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-338778fb926sm473120eec.31.2026.09.06.23.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:51:07 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH 2/2] RDMA: fix repeated words in comments
Date: Mon,  7 Sep 2026 12:20:47 +0530
Message-ID: <20260907065047.26773-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907065047.26773-1-hemanth.selam@gmail.com>
References: <20260907065047.26773-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop words accidentally written twice, reported by checkpatch.pl as a
possible repeated word.  Only touches comments, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/infiniband/core/iwcm.c        | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 0b7246ec559e..4b05867dad89 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -936,7 +936,7 @@ static void cm_disconnect_handler(struct iwcm_id_private *cm_id_priv,
 /*
  * CM_ID <-- IDLE
  *
- * If in the ESTBLISHED or CLOSING states, the QP will have have been
+ * If in the ESTBLISHED or CLOSING states, the QP will have been
  * moved by the provider to the ERR state. Disassociate the CM_ID from
  * the QP,  move to IDLE, and remove the 'connected' reference.
  *
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7197d95f2216..43c3ff1ad8e7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1888,7 +1888,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	 * We divide up our send queue size into half SEND WRs to send the
 	 * completions, and half R/W contexts to actually do the RDMA
 	 * READ/WRITE transfers.  Note that we need to allocate CQ slots for
-	 * both both, as RDMA contexts will also post completions for the
+	 * both, as RDMA contexts will also post completions for the
 	 * RDMA READ case.
 	 */
 	qp_init->cap.max_send_wr = min(sq_size / 2, attrs->max_qp_wr);
