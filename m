Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795874923;
	b=LZFs0/4nkBu3583m1mNCrd5epoxs28mS7rWrgGDxMTTZX9iGeqEKdBi1gbFWVHQtJIVh
	 2QnA72E04row2nH/du/FsxyJ4a3q3iJMAdzdCLIE8VMnPlsEhF7TOOKkWgTl1QC6U//or
	 bqL7mije/fWxtoJfw64Nr02FAmMWLEma3YY4M7H+OS3JDmMGdGCl4RunGiHLot2Xr9lya
	 Av/UqWVVO1c6xsFBlWW5i4Ey3SpEUDams4tL9OAF/b+92FOEn4zgRk3m2nLcEja54GwAt
	 qgW6tUKyfTG0Xnn27cLabtD9pPPvHMiVH/qmpjE4+QPDc5fWfcjLSl81HBBo/RGKsSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795874923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7tBnj8Gi7eaE7gLQaitgtHGzu075b8jhxq/uf6VL6Vk=;
	b=c14rFqapyhLu6IxzSAdkznSbbdjH7CGGpekeUC5GHUGSwv15sBR6S8G9lS2ZikVKD2fF
	 DP3AIEVDstEGeyh6OczcVazW/xa0ftgONTejd/Op4ptkT4RAHRMfj55Eu7uO1+PcdQa81
	 Zz4jFQX61c01wEKu7ZG2HWgafvxu2AXQVmGEH8nzScaxXtDtNEe8IraI3vOQmm+CaLetq
	 Vu2G2fnjgTZ8NU+ZfrMSwjQahBNtyULS2eJT1QXMar9lr+kYJw1Z8bxDMATkbdqM4j9Kx
	 ivM8WiNB4o9wwN2Ir+BG/M1ILktQKEPCegGfNNKpAXulsA/hiHPInZ1UJnJBf5652DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=none smtp.mailfrom=stellman-greene.com;
	dkim=pass header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RmQ1AmBZ;
	arc=none smtp.remote-ip=209.85.222.173
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2850606A326
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 14:08:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2850606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RmQ1AmBZ
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93f22a8515eso768809885a.2
        for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 06:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stellman-greene-com.20260707.gappssmtp.com; s=20260707; t=1795874922; x=1796479722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7tBnj8Gi7eaE7gLQaitgtHGzu075b8jhxq/uf6VL6Vk=;
        b=RmQ1AmBZKLOKJCSBrw3H81D9mOSRRfvgpgopF9/M2rkKm89Vba0Vhq1ve/ND7iVcSB
         H2S0FW57wsNoLYsg6w14ZaGn63JoBEDEOMZS/jNxdKEsQNJMll3YvGqyznLie2pQo9CT
         vfL4ZfqtDbfmEPVPjUMKtqtofG4JxQJPkTOEV9lNxdS6s7Gb5GkzaZHqAthpdhRuFX1M
         uWdZQFiNNDNcj9v6MzsILDCVRVoQIi/Rspv6kj8jltb323/dH6Gs0ItIO5ExVy9KS8yO
         Bk/SrH0D17/5/3ixbrR59RI7ed3Z1WbgsDsyGOMcPTPK4Ij4GJOUsubXIHmAzHLyJFo6
         A4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795874922; x=1796479722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7tBnj8Gi7eaE7gLQaitgtHGzu075b8jhxq/uf6VL6Vk=;
        b=zpFlfkcs9dapcgbp7LvM9NTCGXqgp3JP+n1q9jEVrmG9PKK9SYPDO4sbJaHw9D3kRp
         OGmck8W3CdMiG8SqhPKJcVWailtJLSdFYRFtNAblZWCzsMQMK4jmWaU/+qMwTd/CRngQ
         fRarLDyxJsu8PY+/Zxn0OOAu4WzqJfu141PymdvR6Quq3/4aGTHNSZ/I+hHYEF4zGdDy
         2tNN7WpkoNd2wELizFfMesEvOK7kEHTa4cTvOcvEMOL2ZEKS08NQhSLxgpPHMGKNhELa
         ZJnNJItUOlPBvVXkc58VhLfPz3ATPGv9H4gKfX2JMGb5Akl2S3QaJNcCi7uiYjShlNBd
         BwcA==
X-Forwarded-Encrypted: i=1; AL+hErE9X87Qdwy6bvWlQ7QJAxXLe8Rae/LJ6b8FP2dH0nRZVas7MRrNICO00jE3IBQi2X99f+8k9mqBg0TX@vger.kernel.org
X-Gm-Message-State: APuU4Z/wqeaUt6hGXqywzSMt5ekxX6m2TVaCNsJlt5ON91MYBqfn1dH2
	N2c2BkBbTXHGVXoMKg8fhyJhYWlipn7A72aftUa0lskU61fJgSkx0cIi6uWiPQsuSaA=
X-Gm-Gg: AZFdTZfajwxdaZPMvNX4Z7O0vv3ct6tiT8j4v0pqjZ+nMl2LpW8D9dl1c4LZbtl62v9
	o9Nqu2Ly6DAUZLdQ/PhZYqbGszMnOciP+rCxGrGwEMxHfIZc7Da81eTz4FivLTSVMHSUqF1Y5WQ
	xDfruiHurEU4pePORUvb0Qm/7cguW/BMsVLKR60noqGpnKCu7IEumZmAi5eUquL+jWdSkdzrVXZ
	zVIBwk8q8CFvwqE0h4YEpEFNaBQIzCB1C6zvTI9gCc43M7muCnvXHLMzTMRJQ97IXkKpwQ7sa8B
	g/8Ya1VqalPjW9DiAQS12BnMamPk40+mqW9yrzhpG7hjCUkV1Ffl6dTFeEiXKb6Y8Z953J6C4Ed
	qo3w6dxk0YMnHkzHvMtb7jjnUesJMXAWingl2R8gz5BvO4qHPOciNe2//boqx2scrr4zo3NoFB+
	mL7XfCMBFKyroiYspWpwtcIxHKX4tyME05mvB+ROnJOOu3okdKUMe/PDQuN8p8mLda5A+eFxdWz
	IComP+s8dfjTS1MQJzbDzi5hlKNag09uyvleS8K6ANlBxqvrHQB1eihqbGp/Odbh2MOtp7cehdX
	Z08O4TbgsCOad8HD/13UNd8T9ivlZuSD8k3MVJ/bQTBPOPXTrK38e4/Bc7O4/I+LtdS19WF7D4l
	WwA==
X-Received: by 2002:a05:620a:6c18:b0:949:6841:2ba2 with SMTP id af79cd13be357-949ba96e544mr5055337485a.22.1795874921780;
        Sat, 28 Nov 2026 06:08:41 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:a4e3:fb15:aef5:60c7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3ba04bsm2108250285a.24.2026.11.28.06.08.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Nov 2026 06:08:41 -0800 (PST)
From: Andrew Stellman <bugs@stellman-greene.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/rxe: Bound MR copy and flush chunks to MR pages
Date: Sat, 28 Nov 2026 09:08:40 -0500
Message-ID: <20261128140840.59003-1-bugs@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Stellman <astellman@stellman-greene.com>

A fast-reg MR can use 4 KiB pages on a 64 KiB-page kernel, with each
MR page in its own page_info entry. rxe_mr_copy_xarray() limits each
chunk to the end of the system page, not the end of the MR page, so a
copy that crosses an MR-page boundary continues in the same system
page instead of moving to the next page_info entry.
rxe_mr_flush_pmem_iova() has the same bound.

Limit each chunk to the end of the MR page when MR pages are smaller
than PAGE_SIZE. For MR pages of PAGE_SIZE or larger the bound is
unchanged.

On arm64 with 64 KiB pages (QEMU TCG, mainline 7cd8495c0f16), a
test-only hook built an MR by hand with two 4 KiB pages at offsets
0x1000 and 0x3000 of two different system pages and called
rxe_mr_copy() for 32 bytes starting 16 bytes before the MR-page
boundary, checking that the last 16 bytes came from or went to the
second MR page. Without this patch, both the read and the write check
failed. With it, both passed, and they failed again with it reverted.
A 32-byte read within one MR page passed on all three builds. The
flush path was not run.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix was drafted with OpenAI GPT-6 (Codex) and this changelog with
Claude Opus 5.5, and both were reviewed by me.

Fixes: 12985e5915a0 ("RDMA/rxe: Fix iova-to-va conversion for MR page sizes != PAGE_SIZE")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
A reproducer is available on request.

 drivers/infiniband/sw/rxe/rxe_mr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 13cb28d3916f6e..258f8524ef06b4 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -333,12 +333,14 @@ static int rxe_mr_copy_xarray(struct rxe_mr *mr, u64 iova, void *addr,
 		unsigned long index = rxe_mr_iova_to_index(mr, iova);
 		struct rxe_mr_page *info = &mr->page_info[index];
 		unsigned int page_offset = rxe_mr_iova_to_page_offset(mr, iova);
+		unsigned int chunk = min_t(unsigned int, PAGE_SIZE,
+					   mr_page_size(mr)) - page_offset;
 
 		if (!info->page)
 			return -EFAULT;
 
 		page_offset += info->offset;
-		bytes = min_t(unsigned int, length, PAGE_SIZE - page_offset);
+		bytes = min_t(unsigned int, length, chunk);
 		va = kmap_local_page(info->page);
 
 		if (dir == RXE_FROM_MR_OBJ)
@@ -519,12 +521,14 @@ static int rxe_mr_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int leng
 		unsigned long index = rxe_mr_iova_to_index(mr, iova);
 		struct rxe_mr_page *info = &mr->page_info[index];
 		unsigned int page_offset = rxe_mr_iova_to_page_offset(mr, iova);
+		unsigned int chunk = min_t(unsigned int, PAGE_SIZE,
+					   mr_page_size(mr)) - page_offset;
 
 		if (!info->page)
 			return -EFAULT;
 
 		page_offset += info->offset;
-		bytes = min_t(unsigned int, length, PAGE_SIZE - page_offset);
+		bytes = min_t(unsigned int, length, chunk);
 
 		va = kmap_local_page(info->page);
 		arch_wb_cache_pmem(va + page_offset, bytes);
-- 
2.53.0

