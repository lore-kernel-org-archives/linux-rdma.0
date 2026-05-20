Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EA33B27F1;
	Wed, 20 May 2026 10:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779274036; cv=none; b=PGVR4aSpUoZqszdR6f4Fu9ACOyGCkMH8rRnycE9pvk53HfBIEnR9qankcniuh3608iqLYMsIqvCgOvPB3xaDpx2ZOmBZXnVQGSlE4YWnmVe0qKobapS6j+p0unqGz6yZNoEqjdmN/96qq2T4Z54yGf6NtFcyJD6zU73Gr4bqatg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779274036; c=relaxed/simple;
	bh=Q7qqfAutSKZauhY+EWz7gxG0pSfznptXMmhDOTQQdXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv8JdyVl//O0GhwMPbT9UOlKzu5RmSaLSUer7b/o8CvL5ESOTsQd/NtjMhr/2Sr66wrEZ5orTPp2Jp7Bj+XW2sGeNoXsgEyuCJ+zv3iz+/HZluJUeeFqfznToRZhxDGM9MGGgzkxwRFLuZfZ2EkYFrIYfSG+79V0ZiAKHLCuVQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3e6bff76543911f1aa26b74ffac11d73-20260520
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9df82894-dd82-411c-a960-8fb16084a39b,IP:10,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.12,REQID:9df82894-dd82-411c-a960-8fb16084a39b,IP:10,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:e7bac3a,CLOUDID:b1cfc8ac9afd1916f45568792029fdc9,BulkI
	D:260520184708G9BHAY0L,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|865|898,TC:nil,Content:0|15|50,EDM:1,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3e6bff76543911f1aa26b74ffac11d73-20260520
X-User: cuitao@kylinos.cn
Received: from ctao-book.. [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1927830860; Wed, 20 May 2026 18:47:06 +0800
From: Tao Cui <cuitao@kylinos.cn>
To: leon@kernel.org,
	jgg@ziepe.ca,
	linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH rdma-next 2/2] RDMA/counter: Fix incorrect port index in rdma_counter_init() error cleanup
Date: Wed, 20 May 2026 18:45:46 +0800
Message-ID: <20260520104546.1776253-3-cuitao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260520104546.1776253-1-cuitao@kylinos.cn>
References: <20260520104546.1776253-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The error cleanup loop in rdma_counter_init() iterates with variable
'i' but accesses dev->port_data[port] instead of dev->port_data[i].
This causes the failed port's hstats to be freed multiple times while
leaking hstats of previously initialized ports.

Fixes: 56594ae1d250 ("RDMA/core: Annotate destroy of mutex to ensure that it is released as unlocked")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 drivers/infiniband/core/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 5ddd607d5fbe..a9e189194c13 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -669,7 +669,7 @@ void rdma_counter_init(struct ib_device *dev)
 
 fail:
 	for (i = port; i >= rdma_start_port(dev); i--) {
-		port_counter = &dev->port_data[port].port_counter;
+		port_counter = &dev->port_data[i].port_counter;
 		rdma_free_hw_stats_struct(port_counter->hstats);
 		port_counter->hstats = NULL;
 		mutex_destroy(&port_counter->lock);
-- 
2.43.0

