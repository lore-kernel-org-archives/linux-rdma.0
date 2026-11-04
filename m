Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759289;
	b=WYXCrXMV79aIsWwdtXNqUc/pyuEVvYfbg7QWdsmsx3D+UsuJM8X2+JcfYD5mm+ztKdnW
	 NHy+XtXKwCye2NgN/+C0mPFxkge/FEu5UWRpoZCaG23xOkNvcve7ot6L9LmV+iPqq5yRJ
	 QDXM8oxf3P18p48gk3XPqogV0QEtrYu0IpGIap8hg0Rr3CuR86LAN50/nRfmFEh4ir34C
	 vd4tawYP6P6rPkMdRokfV5mu+8Uy8Amsxre67dKl4Jo8R4gtZeOj8Ok8NiyjdLgjHE6Pe
	 WHzgrwuqawkGkiriQXv0jWpR74ReXwiXua0s6lYA5q8B9q0FbnDJliB585c4zfmSkJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759289;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=Ojrc+x8JHkngO7OdqeCuGVdfBdyZz/qzrjANOLDklpE=;
	b=csDaPVHy4FdOaeH1w3ohYmz138WKG/9r4AOVdzMVnsdG6HWF6i4whk4N7fbUB/oYufs6
	 n4zScJ8gH5jOHEG6ru2bWou3J/AE+aUEsQNuwGcCNuq8FjdjCemCVsi0AurgjUivbOAKH
	 4wGxG499of8OCQz+73kiG5wmK4R6w9agR1UH1FONBW9TTSoseP2NG0r9F6aqsAaFI19sB
	 jkjeIHCge7SZWcJ56N461ztiEWQ3zEJtHoH6uUfLqtegAiDuzZAuSR5CzkvaT3nz8XoER
	 0NBgs44mI5OhykWFj3iIrEpRtfNkNSZTdv/wFXaUp6vFY6vgBhyNsbud7PUZ6hPW0Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B26606D805;
	Wed,  4 Nov 2026 02:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45B26606D805
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABHcPozmOpqvps+AA--.42060S2;
	Wed, 04 Nov 2026 10:28:03 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH] net/smc: deregister the MR when SG mapping fails
Date: Wed,  4 Nov 2026 02:28:12 +0000
Message-Id: <20261104022812.1484233-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:qwCowABHcPozmOpqvps+AA--.42060S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AF15AryDWrykZr4fAF18Xwb_yoW8XryDp3
	yfCrWvkryfJF12vw1Iyr18uas0kanrKryUCrWkCwn09wn7Jr1UAFn2gF12qFn8CFWkCF4a
	vr4rt3yrWr4UAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBjb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26F1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x0267
	AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07bzhL5UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAQBA2rqY+TJjQAAsJ

When smc_ib_map_mr_sg() maps fewer entries than the SG table holds,
smc_ib_get_memory_region() returns -EINVAL with the memory region
still allocated and its pointer left in buf_slot->mr[link_idx].
The caller only undoes the DMA mapping and frees the SG table, and
because buf_desc->is_map_ib[] is set only after this function
succeeds, smcr_buf_unmap_link() later skips the buffer.  Both the
MR and the pd->usecnt reference taken by ib_alloc_mr() are lost.

The stale pointer is also harmful: a retry takes the "already done"
shortcut and treats a memory region that was never mapped as valid.

Deregister the memory region and clear the slot before returning.

Fixes: 897e1c245773 ("net/smc: use separate memory regions for RMBs")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 net/smc/smc_ib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index daaa8a72da90..fa21d269196e 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -735,8 +735,11 @@ int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
 	}
 
 	if (smc_ib_map_mr_sg(buf_slot, link_idx) !=
-			     buf_slot->sgt[link_idx].orig_nents)
+			     buf_slot->sgt[link_idx].orig_nents) {
+		smc_ib_put_memory_region(buf_slot->mr[link_idx]);
+		buf_slot->mr[link_idx] = NULL;
 		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.34.1

