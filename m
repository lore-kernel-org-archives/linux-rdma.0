Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F801A8F97;
	Thu, 23 Apr 2026 06:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776926854; cv=none; b=FS7Z2oAs0Pln6/vC49F1H2fYUnfCAw4FZ8YZEosrazX0chGDglldx+/Q2IYkPZXMNFxEGsgPoUSmhEfzfBQqnWLfaZ7iRuaM8cjnpk2Hnly6KoTsfNpocghAYxGWV0Vq7AScDmIxnM72raYRYT3ilDu4mcVBmbwpA0YsFQvepWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776926854; c=relaxed/simple;
	bh=T85gaMy4LIQZW74fX7a1NM3xHggzpBS3fOSheJJkzdY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ieb5TAqYUqgjgBlheqMCQypZ+EvJbgq+4uBUSwy6LCBqX9SJH0PfcgDes+WYv0w1y6VYSyLxAOb6882PPcLmZxDILg38M8Bjowhzhaw0Qv+ah49tVTfJjbIBTVhhJhyOoTESEMSCEsmxAcks4+6iqEF4VDC6D6bgdeLWAvoeJSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 49e97ad63ee011f1aa26b74ffac11d73-20260423
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0fe5b066-c7ba-4aae-bb2f-e80d995e40c3,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:0fe5b066-c7ba-4aae-bb2f-e80d995e40c3,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:8e9c053e02041cf42645112e92a36484,BulkI
	D:260423144727UR1YRIPO,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|898
	,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 49e97ad63ee011f1aa26b74ffac11d73-20260423
X-User: cuitao@kylinos.cn
Received: from ctao-book.. [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 566276217; Thu, 23 Apr 2026 14:47:25 +0800
From: Tao Cui <cuitao@kylinos.cn>
To: dsahern@kernel.org,
	leon@kernel.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] rdma: display resource usage rate in resource show
Date: Thu, 23 Apr 2026 14:47:11 +0800
Message-ID: <20260423064711.360024-1-cuitao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parse the new RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX netlink attribute
to show resource usage percentage alongside current counts:

  Before: 0: mlx5_0: qp 123  cq 45  mr 200  pd 10
  After:  0: mlx5_0: qp 123 (0.0%)  cq 45 (0.0%)  mr 200 (0.0%)  pd 10 (0.0%)

JSON output gains "max" and "usage" fields per resource type.
Backward compatible: no output change when kernel lacks the new attribute.

Link: https://lore.kernel.org/all/20260423061352.359749-1-cuitao@kylinos.cn/

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 rdma/include/uapi/rdma/rdma_netlink.h |  5 +++++
 rdma/res.c                            | 15 +++++++++++++++
 rdma/utils.c                          |  1 +
 3 files changed, 21 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 8709e558..12ca07ef 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -604,6 +604,11 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_RES_FRMR_POOL_PINNED,		/* u32 */
 	RDMA_NLDEV_ATTR_RES_FRMR_POOL_KEY_KERNEL_VENDOR_KEY, /* u64 */
 
+	/*
+	 * Resource summary entry maximum value, used to calculate usage rate.
+	 */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX,		/* u64 */
+
 	/*
 	 * Always the end
 	 */
diff --git a/rdma/res.c b/rdma/res.c
index 062f0007..cf9c79a3 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -56,6 +56,21 @@ static int res_print_summary(struct nlattr **tb)
 		name = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME]);
 		curr = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
 		res_print_u64(name, curr, nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]) {
+			uint64_t max;
+
+			max = mnl_attr_get_u64(
+				nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]);
+			print_u64(PRINT_JSON, "max", NULL, max);
+			if (max > 0) {
+				char usage_str[32];
+
+				snprintf(usage_str, sizeof(usage_str), "(%.1f%%)",
+					 (double)curr * 100.0 / (double)max);
+				print_string(PRINT_ANY, "usage", "%s ", usage_str);
+			}
+		}
 	}
 	return 0;
 }
diff --git a/rdma/utils.c b/rdma/utils.c
index 87003b2c..90ea1c55 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -480,6 +480,7 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_EVENT_TYPE] = MNL_TYPE_U8,
 	[RDMA_NLDEV_SYS_ATTR_MONITOR_MODE] = MNL_TYPE_U8,
 	[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENABLED] = MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX] = MNL_TYPE_U64,
 };
 
 static int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.43.0

